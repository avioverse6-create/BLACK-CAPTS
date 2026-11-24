# BLACK-CAPTS

A mobile-oriented 3D winter-town roleplay prototype built with Godot 4.

## Visual direction
The target is the original low-poly GTA San Andreas / SA-MP look, not cartoon asset packs. The current scene is still a temporary blockout; authentic models have not yet been imported.

## Current prototype
- Compact snowy blockout map with one road and three building placeholders.
- Procedural snowfall and simple placeholder trees.
- Third-person player movement with a custom analog mobile joystick.
- Swipe camera rotation on the right side of the screen.
- Basic sidewalks and facade window details in the winter blockout.
- Three wandering NPC placeholders.

## Asset pipeline
See [GTA_ASSET_PIPELINE.md](GTA_ASSET_PIPELINE.md) for researched Blender tools that can prepare GTA San Andreas-style DFF/TXD/map/pedestrian assets for conversion to GLB and import into Godot.

The tools are importers, not collections of game assets. Original game files are not included. Do not commit proprietary game archives or extracted models/textures to this repository.

## Run
Open this folder in Godot 4.4 or newer and run the project.

## Android APK
An APK has not been built or tested yet. Android export requires matching Godot export templates and Android SDK/JDK configuration. Follow the [official Godot Android export guide](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html).
