# Language Files

## Introduction

So, planning to translate the game? That 's great! Translation with [[FireTongue][firetongue]][[firetongue][firetongue]] is powerful 'n you can not only translate texts but use different fonts, and also, swap files if needed.

## How to Use

[FireTongue][firetongue] works with `CSV` (Comma Separated Values) and the more common `TSV` (Tab Separated Values). Their syntax looks like this:

TSV:
```tsv
flag	content
MY_TEXT	This is my text.
```

CSV:
```csv
"flag","content"
"MY_TEXT","This is my text."
```

Before adding any file, you need to edit [index.xml][locales_index]. This is the main file where you define how many languages the game supports, notes, which files to use, etc. Basically, it's the core of the localization system.

Syntax of `index.xml`:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<data>

	<!-- Adds a translation file -->
	<file id="my_context" value="my_file.tsv"/>

	<file id="fonts" value="my_fonts.xml"/>

	<locale id="en-US" is_default="true" sort="0">
		<contributors value="Sunnydev31"/>
		<ui language="Language" region="Region"/>
		<label id="en-US" language="English" region="United States"/>
	</locale>
</data>
```

- `file`
  - `id`: Context, in case the same `flag` appears in multiple files.
  - `value`: Name and location of the file.
- `locale`
  - `id`: Language code, based on ISO (e.g., en-US).
  - `is_default`: Defines if this language is the default one.
  - `sort`: Index in the language list.
- `contributors`: List of translators.
- `ui`
  - `language`: Word “language” in the current language.
  - `region`: Word “region” in the current language.
- `label`
  - `id`: Language code shown in the localized list.
  - `language`: Localized name of the language.
  - `region`: Localized name of the region.

## Formatting

Some text formatting like `\n` for line breaks won 't work here. You need to use [FireTongue][firetongue]'s own formatters:

| Formatter | In [FireTongue][firetongue] |    Description    |
|:---------:|:---------------------------:|:-----------------:|
| `\n`      | `<N>`                       | Line Break        |
| `\t`      | `<T>`                       | Tabulation        |
| `,`       | `<C>`                       | Comma             |
| `"`       | `<Q>`                       | Quote             |
| `“`       | `<LQ>`                      | Fancy Left Quote  |
| `”`       | `<RQ>`                      | Fancy Right Quote |

This implementation prevents parsing errors and ensures texts display correctly.

## Translating

When translating, the identifier (`flag`) must be lowercase, without spaces (use `_` instead), and avoid special characters like: `~ & \ / ; : < > # . , ' " % ? !`

Use this code:
```haxe
Locale.getString(flag:String, context:String, values:Array<Dynamic>):String
```
- `flag`: Identifier used in translation files.
- `context`: `id` defined in [index.xml][locales_index].
- `values`: Replaces any placeholder using the string formatter.

## Replacing Files and Fonts

Replacing fonts and files hasn't been fully tested yet, but it can still be used.

To replace files, use the code below
```haxe
Locale.getFile(key:String, ?extension:String = ""):String
```

### Code parameters
 - `key`: Path to file (e.g. “images/myImage”)
 - `extension`: (OPTIONAL) File extension (e.g. “png“, “txt“)
    - this adds a period (“.”) automatically
    - Starting to think now, this seems a very dumb idea


<!-- Links -->
[firetongue]: <https://github.com/larsiusprime/firetongue> "Firetongue github repository"
[locales_index]: <../../../assets/locales/index.xml>