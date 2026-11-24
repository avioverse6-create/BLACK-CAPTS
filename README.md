# BLACK-CAPTS

A mobile-oriented 3D winter-town roleplay prototype built with Godot 4.

## Visual direction
The target is the original low-poly GTA San Andreas / SA-MP visual era. The current scene is still a temporary blockout; authentic GTA models have not been imported.

## Current prototype
- Compact snowy town blockout with one main road and three building placeholders.
- Crosswalk, sidewalks, street lamps, bus stop and procedural snowfall.
- Third-person movement with an on-screen analog joystick.
- Swipe camera rotation and a spring-arm camera to reduce clipping through geometry.
- Three wandering town NPCs with name tags and simple dialogue interaction; dialogue closes automatically.
- Five spinning collectible town tokens with a live HUD counter.
- Optional rigged GLB pedestrian model support. See [assets/characters/README.md](assets/characters/README.md).

## Asset pipeline
See [ASSET_SOURCES.md](ASSET_SOURCES.md) for independently made, openly licensed model candidates. These are not Rockstar assets and should not be represented as original GTA models.

The scripts automatically use `assets/characters/casual-walker.glb` when that file is added. The model is optional; without it, placeholder visuals remain.

Do not commit proprietary game archives or extracted Rockstar models/textures to this repository.

## Run
Open this folder in Godot 4.4 or newer and run the project.

## Validation
GitHub Actions runs a headless Godot import/script parse and briefly launches the main scene on pushes to `main`.

## Android APK
An APK has not been built or tested yet. Android export still requires matching Godot export templates and Android SDK/JDK configuration.
