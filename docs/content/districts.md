# Modding Districts

When [modding Districts](https://stellaris.paradoxwikis.com/District_modding), we place the definitions of our District in `common/districts`.

The same we do with the new configuration type file.
What used to be `mymod_districts.txt` becomes `mymod_districts.psd1`.

## Example Files

> Lets have some innocent fun here

```powershell
@{
    Core      = @{
        BuildTime      = 1
        Capped         = $false
        Exempt         = $true

        Cost           = 0

        Potential      = [ordered]@{
            exists = 'owner'
            owner = @{ is_ai  = $false }
        }
        Allow          = [ordered]@{
            exists = 'owner'
            owner = @{ is_ai  = $false }
        }
        PlanetModifier = @{
            planet_housing_add = 1000
        }
    }
    Districts = @{
        district_infernal          = [ordered]@{
            Name                         = 'Infernal Heartlands'
            Description                  = 'The central place to commit unspeakable atrocities.'

            Slots                        = @(
                'slot_infernal_core'
                'slot_infernal_01'
                'slot_infernal_02'
            )

            triggered_planet_modifierþ1þ = @{
                potential = @{
                    exists = 'owner'
                    owner  = @{ has_active_tradition = 'tr_prosperity_public_works' }
                }
                modifier  = @{
                    planet_housing_add = 500
                }
            }
        
            triggered_planet_modifierþ2þ = @{
                potential = @{
                    exists = 'owner'
                    owner  = @{ has_technology = 'tech_housing_1' }
                }
                modifier  = @{
                    planet_housing_add = 500
                }
            }
        
            triggered_planet_modifierþ3þ = @{
                potential = @{
                    exists = 'owner'
                    owner  = @{ has_technology = 'tech_housing_2' }
                }
                modifier  = @{
                    planet_housing_add = 1000
                }
            }
        }
        district_infernal_province = [ordered]@{
            Name        = 'Infernal Province'
            Description = 'A properly corrupted province, funneling mana, slaves and virgins to the Heartlands'

            Slots       = @(
                'slot_infernal_sector'
            )
        }
    }
}
```

> [What's up with "Core"?](../general/core.md)

## Extra Properties

This configuration adds additional properties not present in the game defaults:

|Name|Example|Description|
|---|---|---|
|Name|'District Display name'|The localized string presented to the user|
|Description|'We shall at some point have something meaningful to say'|The localized description of the District|
|Cost|20|The resource cost associated with constructing the district|
|Upkeep|5|The resource cost (per month) to operate the district|

> Name

The name to show to the user.
Will be generated as `<name>` in the localization files.

You can define it either as string or as hashtable, providing either a single language or multiple ones.

For more details, see the [docs on localization](../general/localization.md)

> Description

The description to show to the user.
Will be generated as `<name>_desc` in the localization files.

You can define it either as string or as hashtable, providing either a single language or multiple ones.

For more details, see the [docs on localization](../general/localization.md)

> Cost

Districts can have different kinds of costs to construct them.
While the default is minerals, that is in no way the only option out there.

This is usually reflected in the `resource` setting of a building.
In an attempt to simplify this for casual modding, the `Cost` setting was introduced, which will then calculate the `resource` node for you.

Important: If you specify a `resource` setting, `Cost` _and_ `Upkeep` will be overridden.
This gives you full control, but makes you do all the work.

You can provide two kinds of values to `Cost`:

+ A numeric value, such as `25`. This will be used as straight Minerals cost of the building.
+ A hashtable, mapping resource type to value, such as `@{ energy = 50 }`. This allows you to pick another resource type. You can also provide multiple resource types: `@{ minerals = 200; energy = 50 }`

> Upkeep

Upkeep is the monthly cost to keep running a district.
The same rules apply to `Upkeep` as do to `Cost`, except that the default resource type is `energy`, not `minerals`.

## Aliases

You can freely use regular terminology for the settings, but there are a few aliases for properties of what should/could be on an ITEMTYPE:

+ BuildTime --> base_buildtime
+ MinDeposits --> min_for_deposits_on_planet
+ MaxDeposits --> max_for_deposits_on_planet
+ Capped --> is_capped_by_modifier
+ Exempt --> exempt_from_ai_planet_specialization
+ Default --> default_starting_district
+ Slots --> zone_slots
+ ShowOnUncolonized --> show_on_uncolonized
+ Potential --> potential
+ Allow --> allow
+ ConversionRatio --> conversion_ratio
+ ConvertTo --> convert_to
+ Resources --> resources
+ PlanetModifier --> planet_modifier

Some are just to ensure casing and order of placement.
So you can use either `MinDeposits` or `min_for_deposits_on_planet` - the effect will be the same.
