# Selected ready-made assets for the Android prototype

These are candidate packs to import into Godot. They are not yet included in the repository: download each pack from its original publisher page, keep its license file, then copy only the needed GLB/glTF files into the folders below.

## Roads
- **Kenney — City Kit (Roads)**: https://kenney.nl/assets/city-kit-roads
- Includes modular road pieces and street props; page lists Creative Commons CC0.
- Target folder: `assets/environment/roads/`

## Buildings
- **Kenney — City Kit (Suburban)**: https://kenney.nl/assets/city-kit-suburban
- Modular suburban buildings; page lists Creative Commons CC0.
- **Kenney — City Kit (Commercial)**: https://kenney.nl/assets/city-kit-commercial
- Commercial building parts and props; page lists CC0.
- Target folder: `assets/environment/buildings/`

## Trees and outdoor props
- **Kenney — Nature Kit**: https://kenney.nl/assets/nature-kit
- Trees, rocks, and foliage; page lists CC0.
- Target folder: `assets/environment/props/`

## Humanoid character and animations
- **Quaternius — Universal Animation Library**: https://quaternius.com/packs/universalanimationlibrary.html
- Candidate shared humanoid animation set. Confirm the current pack page and included license before import.
- **Quaternius — Ultimate Animated Character Pack**: https://quaternius.com/packs/ultimatedanimatedcharacter.html
- Candidate ready-rigged stylized characters; verify the current license/version on the publisher page.
- Target folder: `assets/characters/`


## Additional CC0 modular city kit (secondary props only)
- **Kayquer — Low Poly City Kit**: https://github.com/kayquer/kit-cidade-lowpoly
- 129 GLB/glTF models including modular road tiles, buildings, vehicles, street furniture and trees; repository documents CC0 1.0.
- This is a clean stylized low-poly kit, **not** authentic GTA SA geometry. Use only as a temporary source for compatible modular pieces if the visual style fits; do not pass it off as original SA assets.
- The repository states models are Y-up, front facing -Z, and designed for a 2 m grid; individual models are generally under 1,500 triangles.

## Import rules
1. Prefer GLB/glTF for Godot.
2. Keep one rig for the player and NPCs where possible, so animation clips can be reused.
3. Use low-poly LODs, compressed textures, and simple collision shapes for mobile.
4. Do not import any asset until its exact license is checked and stored beside it in `SOURCE.md`.
5. These are clean, openly published assets — not leaked or ripped files from commercial games.

## Current status
The project still has temporary blockout geometry. This file records the selected source packs; it does not claim that those models have already been downloaded or integrated.
