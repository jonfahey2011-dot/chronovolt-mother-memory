# Mother Memory — Supplemental Notes

This repo stores the canonical Memory Core for **ChronoVolt + MOTHER_BRAIN**.

## Layout
- Modular JSONs at the root (`memory_core.json`, `ui.json`, `hardware.json`, `projects.json`, `output_pipeline.json`, `references.json`, `catalog.json`)
- JSON Schemas in `/schemas` for validation and tooling
- GitHub Action in `.github/workflows/validate-json.yml`

## Update flow
1. Edit the relevant JSON(s).
2. Run the validator (push to a branch or trigger workflow_dispatch).
3. Rebuild `catalog.json` using `tools/catalog_rebuild.py` if sizes changed.
4. Commit to `main` with a clear message (e.g., `add iv-11 verified measurements`).