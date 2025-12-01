# How to create a mod

## Mod setup

Creating a mod, you can do almost anything in the game: Changing sprites, music, sounds, texts, code...

The first thing you need to do, is checking if the game supports mods, the faster way is if a folder named `mods` exists in your game path, or if you defined the `MODS_ALLOWED` haxeflag on your built.

Now that you checked the mods folder, you might see a `zip` file named, `Example Mod.zip`, that's a template! You can use it if you want to do in a faster way

If your plan is to use scripts, you need to create a `scripts` folder inside your mod folder, it's the only way the game checks for scripts.

## Creating a `pack.json` file

Mods use a `pack.json` file for metadata, if it doesn't exists, the game will use the folder name as display name;

`pack.json` Structure:

```json
{
    "name": "",
    "description": "",
    "version": [0, 0, 0, 0],
    "discordClient": 0,

    "iconSettings": {
        "animated": false,
        "framerate": 0
    }
}
```

- `name`: Display name of the mod;
- `description`: Describes what your mod do!
- `version`: Version of your mod > [MAJOR, MINOR, PATCH, (Extra)] (Extra is for following the `YEAR.MONTH.DAY.PATCH` type);

- `discordClient`: Your Discord APP Client, used if the haxeflag `DISCORD_ALLOWED` is set on the build;

- `iconSettings`: Options of the mod's icon;
  - `animated`: If the icon is animated or not;
  - `framerate`: The framerate of the animation;
