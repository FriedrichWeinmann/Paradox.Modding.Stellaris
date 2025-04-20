# Localizing Strings

When defining localization strings, language files under the localization folder are the place to write.
This is a bit annoying though, when you are only writing in a single language anyway.
It also is fragile, in case you change anything in your mod, having lots of old strings lying around that may no longer be in use.

So, when defining content via `psd1` config files, we offer an alternative.
Each localized property - such as `Name` or `Description` takes the text directly and as part of the build step, the localization files get generated.

There are two ways you can provide the text:

## Monolingual

Providing a single language is simple:

```powershell
Name = 'Infernal Diplomacy'
```

That's it.

## Multilingual

If you want to provide multiple languages, you need to provide them as a dictionary/hashtable notation instead:

```powershell
Name = @{
    english = 'Infernal Diplomacy'
    german = 'Teuflische Diplomatie'
    spanish = 'Diplomacia infernal'
}
```

Any language not specified will default to `english`, so make sure to provide that (even if the text provided is not actually in English).
Languages supported:
`japanese`, `braz_por`, `polish`, `russian`, `spanish`, `simp_chinese`, `french`, `german`, `english`
