# Optional JSON authoring interface

`build_deck.py spec.json --output output/talk.pptx` accepts a UTF-8 JSON document. All paths resolve relative to that JSON file. Coordinates are `[left, top, width, height]` in inches; sizes are points. Images are embedded with aspect ratio preserved and no cropping.

Top-level keys: `title`, `author` (optional), `size` (default 13.333333 × 7.5), `theme` and `slides`. Use an installed font such as Microsoft YaHei for Chinese. Header/footer geometry currently targets 16:9 landscape; customize the renderer for different aspect ratios instead of shrinking the deck.

Each slide has `title`, `section`, `source`, `notes`, optional `footer` (short displayed source; full source remains in notes), `takeaway`, `images`, `texts`, and `shapes`. Images specify `path`, `box` and optional stable `id`. Texts specify `text`, `box`, `size`, `bold`, `color`, `id`. Shapes specify `kind` (`arrow` or rectangle), `box`, `fill`. Text and schematic elements remain native PowerPoint objects. See `examples/synthetic_deck.json` for a runnable complete example.

Body content should usually stay between y=1.55 and y=6.4. Header/title/source/page slots and optional takeaway occupy the other areas. Add more slides when text or source figures do not fit. `render_deck.ps1` checks actual PowerPoint text geometry; its PNGs must also be visually inspected.
