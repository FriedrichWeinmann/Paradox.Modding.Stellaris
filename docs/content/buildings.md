# Modding Buildings

When [modding buildings](https://stellaris.paradoxwikis.com/Building_modding), we place the definitions of our buildings in `common/buildings`.

The same we do with the new configuration type file.
What used to be `mymod_buildings.txt` becomes `mymod_buildings.psd1`.

## Example Files

> One big set of probably cheating buildings

```powershell
@{
    Core      = @{
        Category  = 'government'
        Potential = @{
            exists = 'owner'
            owner = @{ is_ai  = $false }
        }
    }
    Buildings = [ordered]@{
        infernal_palace              = [ordered]@{
            Name            = 'Infernal Palace'
            Description     = 'The heart of evil, from which all is ruled.'
            Position        = 1

            PlanetModifier  = [ordered]@{
                job_infernaloverlord_add  = 2
                job_infernaloverseers_add = 3
                job_infernalminions_add   = 10
                planet_housing_add        = 5
            }
        
            CountryModifier = [ordered]@{
                country_resource_max_astral_threads_add  = 100
                country_resource_max_minor_artifacts_add = 100
                country_resource_max_influence_add       = 1000
            }
            
            triggered_desc  = @{
                text = 'job_infernaloverlord_effect_desc'
            }
        }
        building_infernal_harmonizer = [ordered]@{
            base_buildtime = 1

            building_sets  = @('cosmogenesis_world')

            Potential      = @{
                is_planet_class = 'pc_cosmogenesis_world'
                exists          = 'owner'
            }

            Category       = 'resource'

            PlanetModifier = [ordered]@{
                planet_housing_add      = 200
                planet_amenities_add    = 666
                planet_stability_add    = 1000
                pop_purge_speed         = -10
                planet_jobs_upkeep_mult = -2
            }
        }
    }
}
```

## Extra Properties

This configuration adds additional properties to a building not present in the Stellaris defaults:

|Name|Example|Description|
|---|---|---|
|Name|'Building Display name'|The localized string presented to the user|
|Description|'We shall at some point have something meaningful to say'|The localized description of what the building does|
|Cost|20|The resource cost associated with constructing the building|
|Upkeep|5|The resource cost (per month) to operate the building|

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

Buildings can have different kinds of costs to construct them.
While the default is minerals, that is in no way the only option out there.

This is usually reflected in the `resource` setting of a building.
In an attempt to simplify this for casual modding, the `Cost` setting was introduced, which will then calculate the `resource` node for you.

Important: If you specify a `resource` setting, `Cost` _and_ `Upkeep` will be overridden.
This gives you full control, but makes you do all the work.

You can provide two kinds of values to `Cost`:

+ A numeric value, such as `25`. This will be used as straight Minerals cost of the building.
+ A hashtable, mapping resource type to value, such as `@{ energy = 50 }`. This allows you to pick another resource type. You can also provide multiple resource types: `@{ minerals = 200; energy = 50 }`

> Upkeep

Upkeep is the monthly cost to keep running a building.
The same rules apply to `Upkeep` as do to `Cost`, except that the default resource type is `energy`, not `minerals`.

## Aliases

You can freely use regular terminology for the settings, but there are a few aliases for properties of what should/could be on an edict:

+ Capital --> capital
+ CanBuild --> can_build
+ CanDemolish --> can_demolish
+ CanRuin --> can_be_ruined
+ CanDisable --> can_be_disabled
+ Position --> position_priority
+ BuildTime --> base_buildtime
+ EmpireLimit --> empire_limit
+ CanBeRuined --> can_be_ruined
+ Category --> category
+ Prerequisites --> prerequisites
+ UpgradeTo --> upgrades
+ Upgrades --> upgrades
+ Potential --> potential
+ Allow --> allow
+ PlanetModifier --> planet_modifier
+ CountryModifier --> country_modifier

Some are just to ensure casing and order of placement.
So you can use either `PlanetModifier` or `planet_modifier` - the effect will be the same.
