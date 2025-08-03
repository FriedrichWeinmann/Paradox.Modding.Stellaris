# Modding Zones

When [modding Zones](https://stellaris.paradoxwikis.com/District_modding), we place the definitions of our zones in `common/zones`.

The same we do with the new configuration type file.
What used to be `mymod_zones.txt` becomes `mymod_zones.psd1`.

## Example Files

> A simple set of zones that are definitely not broken

```powershell
@{
    Core = @{
        Icon = 'GFX_colony_type_urban' # icon
        BuildTime = 1 # base_buildtime
        Potential = @{ # potential
            hidden_trigger = @{ exists = 'owner' }
            owner = @{ is_ai = $false }
        }
        Unlock = @{ # unlock
            hidden_trigger = @{ exists = 'owner' }
            owner = @{ is_ai  = $false }
        }
        Include = @(
            'all'
        )
        Cost = 0 # <resources>
        MaxBuildings = 3 # max_buildings
        PlanetModifier = @{ # planet_modifier
            zone_building_slots_add = 3
        }
    }
    Zones = @{
        zone_infernal_core = @{
            Name = 'Heart of Evil'
            Description = 'The central nexus, coordinating all that is vile.'

            MaxBuildings = 6
            PlanetModifier = [ordered]@{
                zone_building_slots_add = 6
            }
            district_planet_modifier = [ordered]@{
                job_infernaloverlord_add  = 40
                job_infernaloverseers_add = 60
                job_infernalminions_add   = 2000
                planet_housing_add        = 2000
            }
        }
        zone_infernal_sector = @{
            Name = 'Dark Stronghold'
            Description = 'A regional center of wickedness.'

            MaxBuildings = 6
            district_planet_modifier = [ordered]@{
                job_infernaloverlord_add  = 40
                job_infernaloverseers_add = 60
                job_infernalminions_add   = 2000
                planet_housing_add        = 2000
            }
        }
        zone_infernal = @{
            Name = 'Lair of Evil'
            Description = 'Where the most wicked schemes are hatched and innocent victims are sacrificed.'
            
            district_planet_modifier = [ordered]@{
                job_infernaloverlord_add  = 20
                job_infernaloverseers_add = 30
                job_infernalminions_add   = 1000
                planet_housing_add        = 1000
            }
        }
    }
}
```

> [What's up with "Core"?](../general/core.md)

## Extra Properties

This configuration adds additional properties not present in the game defaults:

|Name|Example|Description|
|---|---|---|
|Name|'Zone Display name'|The localized string presented to the user|
|Description|'We shall at some point have something meaningful to say'|The localized description of what the zone does|
|Cost|20|The resource cost associated with constructing the zone|

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

This is usually reflected in the `resource` setting of a zone.
In an attempt to simplify this for casual modding, the `Cost` setting was introduced, which will then calculate the `resource` node for you.

Important: If you specify a `resource` setting, `Cost` _and_ `Upkeep` will be overridden.
This gives you full control, but makes you do all the work.

You can provide two kinds of values to `Cost`:

+ A numeric value, such as `25`. This will be used as straight Minerals cost of the zone.
+ A hashtable, mapping resource type to value, such as `@{ energy = 50 }`. This allows you to pick another resource type. You can also provide multiple resource types: `@{ minerals = 200; energy = 50 }`

## Aliases

You can freely use regular terminology for the settings, but there are a few aliases for properties of what should/could be on an ITEMTYPE:

TODO: Update Mapping

+ Capital --> capital

Some are just to ensure casing and order of placement.
So you can use either `PlanetModifier` or `planet_modifier` - the effect will be the same.
