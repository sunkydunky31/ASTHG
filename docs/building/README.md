# Building

## Requirements

|Name      |Version  |Description                                                                                        |
|:--------:|:-------:|:--------------------------------------------------------------------------------------------------|
|Haxe      |4.3.2+   |OBRIGATORY, for compiling the game                                                                 |
|PowerShell|Core (6+)|ONLY if you will use the scripts! PowerShell Core is multiplatform and not only for Windows anymore|

## Setup

Windows:

- Microsoft Visual Studio
  - Windows 10 SDK (10.0.19041)
  - MSVC v142 - VS 2019 C++ x64/x86 build tools (latest)

## Extra

Before running the PowerShell script, check the [config file](../../build/config.psd1) and adjust it to fit your setup.
Alternatively, you can use `.\build.ps1 (Your Arguments)` to override the config file settings.

And, feel free to translate the script! (I like translations so that's why it's possible to do it)

## Script Usage

There's 2 ways on how to use the build script:

### Using PowerShell

1. Open PowerShell (Core) terminal
2. Navigate to the `build` folder (`Set-Location "[your_project_path]/ASTHG/Build"`)
3. Call the script with `. .\build.ps1`, you can add arguments if needed (it overrides the config file settings)
  Arguments:
  - `Platform`: Target platform, Default: Hashlink (`hl`)
  - `Action`: Build action (second argument for Lime), Default: `test`
  - `BuildFlags`: Additional build flags to pass to Lime compiler
  - `Is32Bits`: Whether to build for 32 bits

### Double Click
1. Navigate to the `build` folder
2. Double click `build.ps1` file (use `setup.ps1` to configure the project!)
3. Done! The script will ask for nescessary inputs.****
