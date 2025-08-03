# Modding Edicts

When [modding edicts](https://stellaris.paradoxwikis.com/Edicts_modding), we place the definitions of our edicts in `common/edicts`.

The same we do with the new configuration type file.
What used to be `mymod_edicts.txt` becomes `mymod_edicts.psd1`.

## Example Files

> Simple Edict

```powershell
@{
    Edicts = @{
        infernal_diplomacy = @{
            Name          = "Infernal Diplomacy"
            Description   = "Who wouldn't want to be your friend?"
            Length        = -1
            Cost          = 10
            EdictCapUsage = 10
            Potential     = @{ is_ai = $false }
            Allow         = @{ is_ai = $false }
            Modifier      = @{
                envoys_add = 1
            }
        }
    }
}
```

> Multiple Edicts with Default Values

```powershell
@{
    Core = @{
        Length        = -1
        Cost          = 0
        EdictCapUsage = 0
        Potential     = @{ is_ai = $false }
        Allow         = @{ is_ai = $false }
        AIWeight      = @{ weight = 0 }
    }
    Edicts = @{
        infernal_robotics_1             = @{
            Name        = 'Infernal Robotics 1'
            Description = 'Our machine empire shall rise ever faster! Advanced infernal jobs increase robot construction.'
        }
        infernal_robotics_2             = @{
            Name        = 'Infernal Robotics 2'
            Description = 'Our machine empire shall rise ever faster! Advanced infernal jobs increase robot construction.'
        }
        infernal_robotics_3             = @{
            Name        = 'Infernal Robotics 3'
            Description = 'Our machine empire shall rise ever faster! Advanced infernal jobs increase robot construction.'
        }
        infernal_robotics_4             = @{
            Name        = 'Infernal Robotics 4'
            Description = 'Our machine empire shall rise ever faster! Advanced infernal jobs increase robot construction.'
            EdictCapUsage = 10
        }
        infernal_robotics_5             = @{
            Name        = 'Infernal Robotics 5'
            Description = 'Our machine empire shall rise ever faster! Advanced infernal jobs increase robot construction.'
            EdictCapUsage = 20
        }
    }
}
```

The explicit usage of EdictCapUsage in the last two edicts will override the defined default.

> [What's up with "Core"?](../general/core.md)

## Extra Properties

This configuration adds additional properties to an edict not present in the Stellaris defaults:

|Name|Example|Description|
|---|---|---|
|Name|'Edict Display name'|The localized string presented to the user|
|Description|'We shall at some point have something meaningful to say'|The localized description of what the edict does|
|Cost|20|The resource cost associated with enabling the edict|

> Name

The name to show to the user.
Will be generated as `edict_<name>` in the localization files.

You can define it either as string or as hashtable, providing either a single language or multiple ones.

For more details, see the [docs on localization](../general/localization.md)

> Description

The description to show to the user.
Will be generated as `edict_<name>_desc` in the localization files.

You can define it either as string or as hashtable, providing either a single language or multiple ones.

For more details, see the [docs on localization](../general/localization.md)

> Cost

Edicts can have different costs associated with taking them.
While the default is unity, that is in no way the only option out there.

This is usually reflected in the `resource` setting of an edict.
In an attempt to simplify this for casual modding, the `Cost` setting was introduced, which will then calculate the `resource` node for you.

Important: If you specify a `resource` setting, `Cost` will be overridden.
This gives you full control, but makes you do all the work.

You can provide two kinds of values to `Cost`:

+ A numeric value, such as `25`. This will be used as straight Unity cost of the edict.
+ A hashtable, mapping resource type to value, such as `@{ energy = 50 }`. This allows you to pick another resource type.

## Aliases

You can freely use regular terminology for the settings, but there are a few aliases for properties of what should/could be on an edict:

+ Length --> length
+ EdictCapUsage --> edict_cap_usage
+ Potential --> potential
+ Allow --> allow
+ AIWeight --> ai_weight
+ Modifier --> modifier

Some are just to ensure casing and order of placement.
So you can use either `EdictCapUsage` or `edict_cap_usage` - the effect will be the same.
