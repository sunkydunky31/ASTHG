# Handbook

## Functions
- `trace(v:Dynamic, ?infos:Null<haxe.PosInfos>)`
    Display a text on the console
    Note that it can only be visible with a build!

- `onGameStart()`
    Called when the game starts (`states.Init` is created)

- `onCreate()`
    Called when a state are created.
    Note that it works on every created state!
    Be careful
 
- `onUpdate(elapsed:Float)`
    Called when a state updates

## Variables

- `game`
    - `game` is a syntax for commom variables, like `version` or `name`
    - Options:
        - `version`: Game version;
    - Usage:
    ```
    game.version
    ```

## Imported classes

### Backend
- `ClientPrefs`;
- `CoolUtil`;
- `Controls`; (With instance)
- `Language`;

### Objects
- `LifeIcon`;
- `Character`; (As "Player")

### Substates
- `Pause`;
