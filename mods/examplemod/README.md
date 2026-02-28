# AstroClient Example Mod

This is a template mod for AstroClient that demonstrates the structure and build process for creating your own mods.

## Project Structure

```
examplemod/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/
│       │       └── ExampleMod.java      # Your mod's main class
│       └── resources/
│           └── example.amt              # Metadata file
├── build.gradle                          # Gradle build configuration
├── settings.gradle                       # Gradle settings
├── CompileMod.sh                        # Unix/Linux build script
├── CompileMod.bat                       # Windows build script
└── README.md                            # This file
```

## File Types

### `.amt` - AstroModTitle (Metadata)
Contains key=value pairs to describe your mod. Create one in `src/main/resources/`:

```properties
name=Example Mod
version=1.0
author=Your Name
modid=examplemod
mainClass=com.example.ExampleMod
description=This is an example mod for AstroClient
```

**Required fields:**
- `name` - Display name of your mod
- `version` - Mod version
- `author` - Your name/credit
- `modid` - Unique identifier (lowercase, no spaces)
- `mainClass` - Java class with a static `init()` method

**Optional fields:**
- `description` - Shown in the mod details screen

## `.ams` - AstroModSystem (Binary Data)

Store any custom binary data, scripts, or assets. You **do not need to create this file by hand** – the helper build script will automatically generate an `.ams` containing your compiled jar. You can still add additional `.ams` files or other resources under `src/main/resources/` if needed.
In the client, mods are loaded via `ModManager` and each `ModContainer` exposes:

```java
ModContainer c = ModManager.getInstance().getContainer("examplemod");
byte[] script = c.getModSystems().get(0); // first ams blob
byte[] image = c.getResource("assets/textures/myimage.png");
```

The loader preserves all non-class files found in the zip – `.png`, `.mp3`, `.mp4`, `.glb`, `.gflb`, models, sounds, etc. See the converter tool or Gradle task for examples.
Example structure:

```
src/main/resources/
├── example.amt
├── logic.ams          # auto‑generated from your compiled jar
└── assets/            # (optional) additional resources
    └── ...
```

## Building Your Mod

Media & resources

All file types under `src/main/resources/` (images, audio, video, models) are automatically bundled into the final mod zip. You can place whatever your mod needs there and access them at runtime via `ModContainer.getResource(path)`. This allows you to ship custom GUI textures, horror sound effects, GLB model files, etc.

The `.ams` files themselves may contain instructions that your mod code interprets; there is no enforced format – your `ExampleMod` class can read the bytes and act accordingly, e.g. patching UI, manipulating packets, or modifying the game state.


### Using the provided scripts:

Both versions will now fill in a basic `example.amt` based on environment variables (or the defaults shown above) and copy the compiled jar into `logic.ams` for you. You no longer need to create those files manually.

**Linux/Mac:**
```bash
./CompileMod.sh
```

**Windows:**
```bash
CompileMod.bat
```

### Or with Gradle directly:
```bash
./gradlew build
```

The built mod will be in `build/libs/examplemod.zip` and can be imported into AstroClient.

## Customizing Your Mod

1. **Rename the package:** Change `com.example` to your own package name
   - Update `src/main/java/com/example/` directory
   - Update `mainClass` in `example.amt`

2. **Update metadata:** Edit `src/main/resources/example.amt` with your mod's info

3. **Add Java code:** Implement your mod logic in `ExampleMod.java`
   - The `init()` method is called when the mod is loaded
   - Add static fields, methods, and logic as needed

4. **Add binary data:** Create `.ams` files in `src/main/resources/` for custom assets

5. **Update Gradle config:** Change the `modName` variable in `build.gradle` to match your project

## Java Compatibility

This example uses Java 8 for compatibility with Eaglercraft's browser environment. Keep your code Java 8 compatible:

- No lambda expressions in critical paths
- No streams API (unless necessary)
- Use traditional loops for better compatibility

## Importing into AstroClient

1. Compile your mod using the build script
2. Open AstroClient and go to **Mods**
3. Click **Import Mods**
4. Select `build/libs/examplemod.zip`
5. Your mod will appear in the mods list and can be toggled on/off

## Tips

- Keep mod names unique to avoid conflicts
- Test your mod frequently during development
- Use the `description` field to help users understand what your mod does
- The `init()` method runs on mod load, use it wisely

## Converting existing mods

A helper script at the workspace root (`tools/convert_mod.sh`) can package a Fabric/Forge jar into an AstroClient
`.zip` containing an `.amt` and `.ams`. Simply run:

```bash
./tools/convert_mod.sh path/to/SomeMod.jar output.zip
```

The converter reads `fabric.mod.json` or `mcmod.info` from the jar for metadata, so it works with 1.21+ mods as well.

For more information, see the main [AstroClient documentation](../../README.md).
