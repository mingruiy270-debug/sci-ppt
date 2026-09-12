# sci-ppt

Evidence-led academic presentations and editable scientific diagram reconstruction for Codex. Version 1.2.0 adds paper/document-to-PPT workflows while preserving the diagram tools from 1.1.0.

## Install

Clone this repository into a project's `.agents/skills/sci-ppt` directory. Start a new Codex turn and invoke `$sci-ppt` with your paper and figure files.

```bash
python -m venv .venv
# Activate the environment for your OS, then:
python -m pip install -r requirements.txt
python scripts/build_deck.py examples/synthetic_deck.json --output output/example.pptx
python scripts/check_delivery.py --pptx output/example.pptx
```

The builder uses portable PPTX primitives; Microsoft PowerPoint is optional for authoring and required for the included Windows rendering/component-export helpers. Those helpers require Windows PowerShell 5.1. No online service receives your paper automatically.

```powershell
powershell.exe -NoProfile -File scripts/render_deck.ps1 -PresentationPath output/example.pptx -OutputDirectory output/previews
```

## Capabilities

- Papers, Word/PDF/Markdown reports and figures -> Chinese or English lab-meeting presentations with speaker notes and source attribution.
- Editable native titles, explanations, diagrams and summaries; high-resolution scientific figures embedded without changing results.
- Flexible slide layouts, actual PowerPoint previews, text-overflow checks and source-linked revisions.
- Reference-image reconstruction, semantic component tags, pure-vector SVG and transparent PNG exports.

See `references/deck-spec.md` for the optional JSON authoring interface. Model reasoning selects the scientific argument and evidence; the scripts only implement layout and export. Embedded experimental images are not internally editable vectors. Structural checks cannot establish scientific correctness or visual fidelity.

This repository contains generic tools and a synthetic example only. It contains no manuscripts, study figures, author information, credentials or real project data. The synthetic example is not a scientific result. An open-source license is not assigned here; public visibility alone does not grant a license.
