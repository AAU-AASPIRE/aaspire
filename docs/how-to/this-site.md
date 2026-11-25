# Work on this site

The site is MkDocs with the Material theme, in the `aaspire` repository. It is written for someone who
wants to build or run a line of their own with AASPIRE, and who was not there when it was made.

## Build and serve

```powershell
cd aaspire
python -m pip install -r docs/requirements.txt   # MkDocs and the Material theme
python -m mkdocs serve                           # http://127.0.0.1:8000, rebuilt on every save
python -m mkdocs build --strict                  # into site/ (not committed); fails on a broken link
```

## How the pages are written

- `mkdocs.yml` holds the navigation: a section per pillar, a page per part, then the how-to pages
  and the reference.
- A part's page: what it is and its repository; the figure; how it works, its steps numbered as in
  the figure; how to use it (commands that run as written); what it does not do; where to read further.
- **Generic first.** Say how a thing is done for any module, product or line. Commands use
  placeholders (`<Module>`, `<module host>`, `<Capability>`, `<module-spec.yaml>`) and run from the
  workspace folder, the folder that holds every repository. Name the example line (aseptic-line) only
  as an example, and say so.
- The words are those of the [glossary](../overview/glossary.md).
- The reference documents (the models, the rules, the tools) are pages of the site, in `docs/reference`.

## The figures

The figures are drawn by a script into a draw.io file, one page per figure, and shown on the site as
PNGs from `docs/figures/`. The sources are kept outside git, in the local
`AASPIRE-material/figures/aaspire-site`: `build_figures.py` (the figures), `figlib.py` (the drawing
kit), `export_png.py` (the export) and `aaspire.drawio` (what they draw). The style: Arial, grey lanes,
white cards, coloured pills and tags, black step numbers, the framework's icons. The figures show
generic modules, skills and capabilities (`MyModule`, `SkillA`, `CapabilityX`), not one line's.

| Colour | Means |
| --- | --- |
| black arrow | flow |
| gold arrow | IEC 61499 management protocol |
| blue arrow | operate over OPC UA |
| green arrow | a step runs a primitive |
| teal arrow | reads or writes an AAS |
| orange arrow | a message between agents (XMPP) |
| grey dashed | a reference, part of |
| salmon, dashed | new, planned, or described but not built |

To change a figure, change its function in `build_figures.py`, draw its page again and export the PNGs:

```powershell
cd AASPIRE-material/figures/aaspire-site
python build_figures.py --force modsync                                   # draw the page again
python export_png.py aaspire.drawio <workspace>/aaspire/docs/figures --page modsync   # every page without --page
```

A page edited by hand in draw.io (the VS Code extension, or app.diagrams.net) stays as it is until it is
drawn again with `--force`, which discards the hand edits. The PNG export uses the draw.io viewer of the
VS Code extension and headless Chrome. The logo is the page `logo`, exported to `docs/assets/logo.png`.
