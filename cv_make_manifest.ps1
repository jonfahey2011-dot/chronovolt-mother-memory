# cv_make_manifest.ps1
# Scan Desktop files (plus known ChronoVolt roots when present) and write a manifest JSON + CSV

$ErrorActionPreference = "Stop"

function Info($msg)  { Write-Host "[INFO]  $msg"  -ForegroundColor Cyan }
function Warn($msg)  { Write-Warning $msg }
function Fail($msg)  { Write-Error $msg; exit 1 }

# 1) Locate Desktop
$Desktop = [Environment]::GetFolderPath("Desktop")
if (-not (Test-Path $Desktop)) { Fail "Could not resolve Desktop path." }

# 2) Build list of scan roots
#    We always include the Desktop itself; we also *prefer* to include specific ChronoVolt folders when they exist.
$KnownRoots = @(
  "$Desktop\chronovolt-app-build\payload\assets",
  "$Desktop\ChronoVolt_full\assets",
  "$Desktop\chronovolt-manifest-references-assets",
  "$Desktop\chronovolt-mother-memory",
  "$Desktop\chronovolt-app-build"
) | Where-Object { Test-Path $_ }

# Ensure uniqueness and include Desktop last (so relPaths favor the more specific roots first)
$ScanRoots = @()
$seen = @{}
foreach ($r in $KnownRoots) { if (-not $seen.ContainsKey($r)) { $ScanRoots += $r; $seen[$r] = $true } }
if (-not $seen.ContainsKey($Desktop)) { $ScanRoots += $Desktop }

Info "Scan roots:"
$ScanRoots | ForEach-Object { Write-Host "  - $_" }

# 3) Helper: get relative path to a chosen root (first root that matches)
function Get-RelativePath {
  param([string]$FullPath, [string[]]$Roots)
  foreach ($root in $Roots) {
    try {
      $fp = [System.IO.Path]::GetFullPath($FullPath)
      $rp = [System.IO.Path]::GetFullPath($root)
      if ($fp.StartsWith($rp, [System.StringComparison]::OrdinalIgnoreCase)) {
        $rel = $fp.Substring($rp.Length).TrimStart('\','/')
        if ([string]::IsNullOrWhiteSpace($rel)) { return "." }
        return $rel
      }
    } catch { continue }
  }
  # fallback to Desktop-relative
  $fp2 = [System.IO.Path]::GetFullPath($FullPath)
  $desk = [System.IO.Path]::GetFullPath($Desktop)
  if ($fp2.StartsWith($desk, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $fp2.Substring($desk.Length).TrimStart('\','/')
  }
  return [System.IO.Path]::GetFileName($FullPath)
}

# 4) Helper: simple category guess
function Guess-Category {
  param([string]$Path)
  $lower = $Path.ToLowerInvariant()
  if ($lower -match "\\previews\\")      { return "previews" }
  if ($lower -match "\\master" -and $lower -match "svg") { return "master_svgs" }
  if ($lower -match "signed" -or $lower -match "assets_signed") { return "signed_assets" }
  if ($lower -match "\\sounds?\\")       { return "sounds" }
  if ($lower -match "\\payload\\")       { return "payload" }
  if ($lower -match "\\tools?\\")        { return "tools" }
  # by extension
  switch -regex ($lower) {
    '\.svg$'   { return "svg" }
    '\.(png|jpg|jpeg|gif|webp)$' { return "images" }
    '\.(wav|mp3|ogg)$' { return "audio" }
    '\.(mp4|mov|mkv)$' { return "video" }
    '\.(ps1|bat|cmd|sh)$' { return "scripts" }
    '\.(json|yml|yaml|xml|toml|ini)$' { return "config" }
    '\.(zip|7z|rar)$' { return "archives" }
    default { return "other" }
  }
}

# 5) Walk files (no hidden/system by default)
Info "Scanning files..."
$allFiles = @()
$visited = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

foreach ($root in $ScanRoots) {
  if (-not (Test-Path $root)) { continue }
  try {
    Get-ChildItem -LiteralPath $root -File -Recurse -Force:$false -ErrorAction SilentlyContinue |
      ForEach-Object {
        if (-not $visited.Add($_.FullName)) { return }
        $allFiles += $_
      }
  } catch {
    Warn "Could not enumerate: $root ($($_.Exception.Message))"
  }
}

Info ("Found {0} files" -f $allFiles.Count)

# 6) Build entries with size + sha256
$entries = @()
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$idx = 0
foreach ($f in $allFiles) {
  $idx++
  if ($idx % 250 -eq 0) {
    Write-Host ("  Hashed {0}/{1}..." -f $idx, $allFiles.Count)
  }
  try {
    $hash = Get-FileHash -Algorithm SHA256 -LiteralPath $f.FullName
    $rel  = Get-RelativePath -FullPath $f.FullName -Roots $ScanRoots
    $ext  = [System.IO.Path]::GetExtension($f.Name)
    $cat  = Guess-Category -Path $f.FullName

    $entries += [PSCustomObject]@{
      relPath   = $rel
      absPath   = $f.FullName
      sizeBytes = [int64]$f.Length
      sha256    = $hash.Hash.ToLowerInvariant()
      ext       = $ext
      category  = $cat
      mtimeUtc  = $f.LastWriteTimeUtc.ToString("o")
    }
  } catch {
    Warn "Hash failed: $($f.FullName) ($($_.Exception.Message))"
  }
}
$stopwatch.Stop()
Info ("Finished hashing in {0:n1}s" -f $stopwatch.Elapsed.TotalSeconds)

# 7) Manifest object
$manifest = [PSCustomObject]@{
  name        = "chronovolt-desktop-manifest"
  generatedAt = (Get-Date).ToString("o")
  machine     = $env:COMPUTERNAME
  user        = $env:USERNAME
  roots       = $ScanRoots
  totalFiles  = $entries.Count
  totalBytes  = ($entries | Measure-Object sizeBytes -Sum).Sum
  files       = $entries
}

# 8) Decide output paths
$PreferredDir = "$Desktop\chronovolt-app-build\manifest"
if (-not (Test-Path $PreferredDir)) { $PreferredDir = $Desktop }
if (-not (Test-Path $PreferredDir)) { New-Item -ItemType Directory -Path $PreferredDir | Out-Null }

$manifestPath = Join-Path $PreferredDir "manifest.json"
$csvPath      = Join-Path $PreferredDir "files_inventory.csv"

# 9) Write outputs
$manifest | ConvertTo-Json -Depth 5 | Out-File -FilePath $manifestPath -Encoding utf8
$entries | Select-Object relPath,sizeBytes,sha256,ext,category,mtimeUtc |
  Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Info "Manifest written:"
Write-Host "  JSON : $manifestPath"
Write-Host "  CSV  : $csvPath"
