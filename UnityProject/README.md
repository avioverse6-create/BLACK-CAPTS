# BLACK-CAPTS — Unity port

This is the Unity 6 migration track. The original Godot project remains at the repository root as a fallback until the Unity build is validated.

## Current port
- Runtime-created winter town blockout and lighting
- Third-person player controller and follow camera
- Five roaming NPCs
- Seven collectible tokens saved locally with PlayerPrefs
- Android build target

## Build
Unity Editor 6000.0.45f1 is expected. Android builds are configured for ARM64 and IL2CPP in the CI workflow.

**GitHub Actions licensing:** Unity's editor must be activated for CI. Add a valid Unity Personal/Pro license file as the repository Actions secret `UNITY_LICENSE` before the workflow can export an APK. Do not commit license files or account credentials.

This first migration checkpoint intentionally does not remove the Godot project and does not claim feature parity yet. Real CC0 GLB models and touch controls will be integrated after the Unity pipeline is validated.
