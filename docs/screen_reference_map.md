# Screen Reference Map (LOCKED)

Master map linking UI pages to purpose, assets, and notes.

---

## 001 — Boot (Splash)
- **Purpose**: Power-on splash; ~2.0 s; plays `app/assets/sfx/back.wav`
- **Layout**: Red background, scanlines; title `CHRONOVOLT`, subtitle `7102`
- **SVG**: `chronovolt_boot_master_redwhite_v1_1.svg`
- **Notes**: No date, no WY logo

## 002 — Wake / Login
- **Purpose**: Automated wake; transitions to READY
- **Copy sequence**:
  - `MU/TH/UR 9001 WAKING UP…` (animated ellipsis)
  - then `MOTHER READY`
- **Panels**: Left date panel shows `28 APRIL 2142`; location `ZETA 2 RETICULI SYSTEM`
- **Color**: Green CRT; yellow for geometry only
- **WY logo**: Present (top-right box)
- **SFX**: `click.wav` (UI), `confirm.wav` (ready)
- **SVG**: `covenant_master_template_for_main_app_screens_green&black.svg`

## 003 — Selector / Build Hub
- **Purpose**: Select WATCH / CLOCK / CUSTOM; choose tube family, count, PCB variant
- **Panels**:
  - Left: Family tabs (VFD / NIXIE / NUMITRON / OTHERS)
  - Center: Config (tube count, PCB Basic/Enhanced/Sound, case size)
  - Right: SPECS + INFO (reads manifest only)
- **Preview**: Tube card grid (from `TUBE_CARDS/`), visual reference only
- **SVG**: `covenant_master_template_for_main_app_screens_green&black.svg`

## 004 — Config (per Project)
- **Purpose**: Parametric controls (fitment, clearances, add-ons)
- **Output**: STL case, tube fit diag, schematic, PCB files
- **Notes**: Enforce “No Visual Guessing” – specs from manifest only
- **SVG**: Covenant template (green) or blue theme per setting

## 005 — Render / Export
- **Purpose**: Final checks + package export (single complete bundle)
- **Checks**:
  - Tripled verified specs
  - Watch thresholds observed (or flagged)
  - PCB variant chosen and mapped
- **Artifacts**: `*.stl`, `*.kicad_*`, `schematic.png/pdf`, `BOM.csv`, `README_export.md`

---

### Theme Switching
- **Green CRT** and **Blue Covenant** share identical geometry and layout; only palette changes.
- Only the three approved SVGs may be used.

(End of map.)
