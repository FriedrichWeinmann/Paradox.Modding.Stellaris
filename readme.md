# Welcome to the Paradox Modding Tools Project

This is the Stellaris Module/Extension for the project designed to build Paradox Mods.
That said, if you are looking for the docs on how to set things up, [check the main project page](https://github.com/FriedrichWeinmann/Paradox.Modding).

See below for the specifics this Module adds.

## Module Specific Docs

This module to the Paradox Modding Tools Project provides the ability to define _some_ mod content via `psd1` config file format.
This comes with two key advantages:

> Centralize common settings.

Imagine defining 10 buildings, each with the same Category - with this format you only need to define it once.

> Keep Content and Localization together.

Localization is exported during build time.
This allows you to reduce file maintenance, especially when you are not translating anything anyway.

It still supports multiple languages, it will copy the English text to all unspecified languages.

## New Content Options

> Common

+ [Buildings](docs/content/buildings.md)
+ [Edicts](docs/content/edicts.md)

## New Automation Commands

> Get-PdsGameDirectory

Returns the root path to the Stellaris game installation.
Uses Steam to figure it out the path and should work on a default Steam-based install on Windows.

This may not work for everybody, as you may not work with either Steam or Windows.
In that case you can define the Path once as an override:

```powershell
Set-PSFConfig -FullName 'Paradox.Modding.Stellaris.Installpath' -Value '<InsertPathhere>' -PassThru | Register-PSFConfig
```

This will tell the command where to look for the Stellaris game, and make that available to your automation logic.

## Common Issues

+ [Multiple Entries with the same name lead to errors](docs/general/issue-multiple-entries.md)
