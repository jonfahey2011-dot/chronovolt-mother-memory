# ChronoVolt — Mother Memory Core

## 📖 Overview
This repository is the **brain** of the ChronoVolt system.  
It holds the **memory core**, rules, manifests, and procedural schemas that define how ChronoVolt operates.

ChronoVolt screens are built to **surpass Alien Covenant plates** in both fidelity and functionality:  
- **Fidelity** → sharper, controllable, spec-driven.  
- **Functionality** → interactive, real software, not static playback.  

---

## 🧠 Contents
- `MOTHER_BRAIN.json` → High-level memory state machine.  
- `memory_core.json` → Authoritative core specification.  
- `hardware.json` → Hardware manifest (nixie, VFD, CRT).  
- `projects.json` → Active project/task tracking.  
- `ui.json` → UI configuration and states.  
- `references.json` → Asset reference mappings.  
- `assets_map.json` → Asset manifest map.  
- `catalog.json` → Project catalog definitions.  
- `output_pipeline.json` → Packaging pipeline rules.  
- `Docs/` → Supplemental docs (`procedural_rules.md`, `screen_reference_map.md`, `README_supplement.md`).  
- `schemas/` → JSON schemas for validation.  

---

## 🔒 Invariants
- Desktop root: `C:\Users\jonfa\Desktop`  
- Sources of truth: **GitHub**, **Dropbox**, **Local PC**  
- OneDrive: ❌ permanently excluded  
- Master SVG allowlist:  
  - `chronovolt_boot_master_redwhite_v1_1.svg`  
  - `covenant_master_template_for_main_app_screens_green&black.svg`  
  - `covenant_master_template_for_main_app_screens_blue.svg`  
- Denylist: all legacy/layer1 files (e.g., `alien_layer1.svg`, `MasterTemplate_v1.0*`, `OLD/`, `Archive/`).  

---

## 🔄 Workflow Role
1. Define rules & invariants here.  
2. Reference assets from [`chronovolt-manifest-references-assets`](https://github.com/jonfahey2011-dot/chronovolt-manifest-references-assets).  
3. Feed validated manifests into [`chronovolt-app-build`](https://github.com/jonfahey2011-dot/chronovolt-app-build).  

---

## 🛰️ Status
This repository is **authoritative** for:  
- Memory state  
- Validation schemas  
- Project invariants  

Everything else consumes this repo’s rules.
