# DeathWish Unity Client

This repository contains the Unity desktop client. The server owns player positions, physics and raycast results. Use the [testing guide](docs/Testing.md) when changing client behavior.

## Unity assets and server integration

- Keep the Canvas, buttons and controller references in `Assets/DeathWishMovement/Scenes/SyncTestScene.unity`. Preserve Unity asset GUIDs when moving or renaming assets.
- The server installer supplies `SyncTestClient.cs`, the protocol and networking DLLs, PhysicsLab data and the world shader. When changing a shared file, update its source in the server repository and synchronize the client copy. Keep the scene's serialized references intact.
- Keep Unity object and UI updates on the main thread. Document any new public thread or buffer ownership requirements in English.
- Use `UPPER_SNAKE_CASE` for constants and include units in names for distances, angles and durations.

## Development records

- Record changes and verification in the current Asia/Seoul date under [docs/devlog](docs/devlog/README.md).
- Distinguish script compilation, editor Play mode and live server checks when reporting verification.
