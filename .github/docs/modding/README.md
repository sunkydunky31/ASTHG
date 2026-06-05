# How to create a mod

## Mod setup

Creating a mod, you can do almost anything in the game: Changing sprites, music, sounds, texts, code...

The first thing you need to do, is checking if the game supports mods, the faster way is if a folder named `mods` exists in your game path, or if you defined the `MODS_ALLOWED` haxeflag on your built.

Now that you checked the mods folder, you might see a `zip` file named, `Example Mod.zip`, that's a template! You can use it if you want to do in a faster way

If your plan is to use scripts, you need to create a `scripts` folder inside your mod folder, it's the only way the game checks for scripts.

## Creating a `mod.json` file

Mods use a `mod.json` file for metadata, if it doesn't exists, the game will use the folder name as display name;

`mod.json` Structure:

```json
{
    "title": "",
    "description": "",
    "contributors": [
        {
            "name": "" }
    ],
    "mod_version": ""
}
```

- `title`: Display name of the mod;
- `description`: Describes what your mod do!
- `contributors`: List of who contribute on the mod!
  - `name`: Name of the contributor (includes you!)
- `mod_version`: Semantic Version of your mod ("MAJOR, MINOR, PATCH");
