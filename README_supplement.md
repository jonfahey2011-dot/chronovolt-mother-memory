# Mother Memory — Supplemental Guide

This repo is the **canonical memory** for ChronoVolt + MU/TH/UR Console.
Use it to rehydrate a new chat or to feed the Electron app.

---

## 1) What each JSON module does

- **MOTHER_BRAIN.json** — One-file compressed superset of everything. If you only pass one file to a new chat, use this.
- **memory_core.json** — Project invariants (rules, protocols, continuity flags, locked SVG list).
- **ui.json** — Page stack (Boot → Wake/Login → Selector → Config/Render), geometry/layout invariants, theme switch (green CRT / blue Covenant).
- **hardware.json** — Tube/spec data, fitment & sizing model, PCB variants, CRT integration plan.
- **projects.json** — Watches/Clocks/Custom projects (e.g., Gauss Counter, Fallout CRTs, Prometheus Block).
- **output_pipeline.json** — Export policy (STL, PCB, schematics, docs), packaging expectations.
- **references.json** — Repo pointers, asset folders, directory snapshots.
- **catalog.json** — Integrity table (sizes + SHA-256) for all above.

Schemas for each live in **/schemas** and are enforced by CI.

---

## 2) Rehydrate a new chat

Paste the repo URL:

