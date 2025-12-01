# Handbook

## Functions

### `trace(v:Dynamic, ?infos:Null<haxe.PosInfos>)`

- Display a text on the console

- #### Usage

  ```haxe
  trace("Hello, Haxe!");
  ```

### `onGameStart()`

Called when the game starts (`states.Init` is created)

### `onCreate()`

Called when a state are created.
Note that it works on every created state!
Be careful

- `onUpdate(elapsed:Float)`
    Called when a state updates

## Variables

### `game`

`game` is a syntax for commom variables, like `version` or `title`

---

|Options    |Description          |
|:----------|:--------------------|
|company    |Game's company       |
|file       |File name of the Game|
|title      |Game's title         |
|version    |Version of the Game  |
|packageName|Version of the Game  |

---

**Usage**:

```haxe
trace(game.version);
```
