# Language Files

## Introduction

Language files (.lang) are a special resource, you can replace text and even files without touching the source code.<br>
If you're adding new phrases, make sure the first line matches the original, that's how the game knows it's the same language.<br>
Note that doesn't applies for the default one!

## Phrases

 You probably will see something like this:

 ```text
 score_text: "Score: {1}"
 ```

This is a translatable text (internally named: phrase), with support of phrase replacements<br>
To use on your code, use this function:

```haxe
getString(key:String, ?defaultPhrase:String, values:Array<Dynamic> = null):String
```

- `key`: The phrase key to find on `.lang` files, any disallowed symbol will be removed, and spaces will be replaced with underscores;

- `defaultPhrase`: (Optional) The phrase in the DEFAULT language ("en-US" by default);
  - If this is null, the game will treat the `key` as both the lookup `key` and the `defaultPhrase`;

- `values`: Replaces any placeholder following the index on the text, [see about placeholders here](#substitution).

### Rules

- A phrase must have double quotes (") around it: `"this is a string!"`
  - You don't need to use escapements for internal quotes! It doesn't cause parse errors

- A key (identifier) must not have spaces, only underscores: `this_is_a_key`
  - The key also must have a colon on the end (`this_is_a_key:`), then, the string followed by quotes (`"`), colons act as a "split key".

- A key doesn't allows:

|Key                            |Reason                                     |
|-------------------------------|-------------------------------------------|
|~ . , & \ / # ' " : ; % < > ? !|Breaks parsing and the key will be ignored.|

**Note**: Some of this rules doesn't applies for file paths!

## Substitution

  You use `{n}` for placeholders, replace `n` with the substitution index on your code

### Subtstitution Rules

- Placeholders start at 1, never in 0;
- Placeholders can be used in any order;
- You can use the same placeholder on your file multiple times;

## Comments

You can use `//` to add comments in your `.lang` file.
Any line that starts with `//` will be ignored by the game — perfect for notes, reminders, or explanations.

- Comments must be on their own line — don’t mix them with keys or phrases.
- You can leave notes for translators, modders, or even yourself. Just don’t forget to remove them if you’re publishing your mod!

## Examples

### Commom Phrase

```text
common_string: "This is a text"
quoted_string: "This is a "quoted" text"
```

### Commented phrase

```text
// This is the English translation file
// Make sure to keep placeholders like {1} intact!

menu_start: "Start Game"
```

#### Files

```text
path/to/file.png: "path/to/replacement file.png"
```

#### Placeholders

```text
placeholder_text: "C: {1}, D: {2}"
```

- Code:

```haxe
Locale.getString("placeholder_text", "A: {1}, B: {2}", ["My text", "My other text"]);
```

#### File Structure

```text
English (US)

// Comment
common_string: "This is a text"
quoted_string: "This is a "quoted" text"
path/to/file: "path/to/your replacement file"
```
