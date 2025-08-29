# ChronoVolt Clean Rules

- ✅ Sources of truth: **GitHub + Dropbox + Local PC**
- ❌ OneDrive: permanently excluded
- ❌ Legacy/danger files written off:
  - MasterTemplate_v1.0*
  - alien_layer1.svg, bladerunner_layer1.svg, fallout_layer1.svg, cyberpunk_layer1.svg
  - Any */OLD/*, */MASTER_V1+V2/*, */Important_Renders_BACKUP/*, */Archive/*, */Mockups/*
- ✅ Authoritative layouts: only the 3 MASTER SVGS (boot red, covenant green, covenant blue)
- ✅ Specs: from manifests (`memory_core.json`, `hardware.json`, `projects.json`, `ui.json`, etc.)
- ✅ Enforcement scripts: use `verify_assets.ps1` + `run_full_validation.bat` + `preflight_validate_payload.bat`

