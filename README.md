# BLACK-CAPTS

A mobile-oriented 3D offline roleplay prototype built with Godot 4.

## Direction
A compact open-world town with a retro low-poly atmosphere. The project uses independently published CC0 assets; it does not claim to contain original Rockstar or SA-MP files.

## Current prototype
- Snowy town with modular 3D road pieces and imported full building models.
- Street props, trees, crosswalk area, sidewalks and bus stop.
- Third-person character using a rigged GLB model with idle and walk animations.
- On-screen movement joystick, swipe camera and hold-to-sprint control.
- Five wandering NPCs with name tags and simple local dialogue.
- Seven collectible tokens with progress saved locally on the device.
- A parked 3D sedan model.

## Offline behavior
The Android build downloads the openly licensed GLB files during GitHub Actions packaging and embeds them in the APK. All gameplay assets are loaded from the local app package. There is no multiplayer server and no runtime asset download; the current build is single-player/offline.

## Asset sources and licenses
- [Asset license register](assets/ASSET_LICENSES.md)
- [Download script](scripts/download_assets.sh)
- [Asset source notes](ASSET_SOURCES.md)

The Kenney models are CC0. The Casual Walker character is also CC0 and includes a humanoid rig with idle, walk, wave and look-around animations. These are independent assets, not extracted GTA models.

## Run locally
Open the project in Godot 4.4 or newer. Before running locally, execute `bash scripts/download_assets.sh` once so the GLB files are present. The Android APK build runs this step automatically.

## Validation
GitHub Actions downloads the assets, imports the project in headless Godot, and launches the main scene briefly.

## Android APK
The Android workflow exports a debug APK and uploads it as a GitHub Actions artifact when the build succeeds.
