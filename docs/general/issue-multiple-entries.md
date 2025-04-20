# Issue: Multiple Entries

When using the `.psd1` config file format, using the same node twice - e.g. two `triggered_planet_modifier` - build fails with red error messages.

Example Configuration-fragment that fails:

```powershell
@{
    triggered_planet_modifier = @{
        potential = @{
            exists = 'owner'
            owner = @{ is_gestalt = $false }
            NOT = @{ has_modifier = 'slave_colony' }
        }
        modifier = @{
            job_soldier_add = 1
        }
    }

    triggered_planet_modifier = @{
        potential = @{
            exists = 'owner'
            owner = @{ is_gestalt = $false }
            has_modifier = 'slave_colony'
        }
        modifier = @{
            job_battle_thrall_add = 1
        }
    }

    triggered_planet_modifier = @{
        potential = @{
            exists = 'owner'
            owner = @{ is_gestalt = $true }
        }
        modifier = @{
            job_warrior_drone_add = 1
        }
    }
}
```

This is not going to work.

The reason behind that is a limitation in the datatype used by PowerShell.

> Solution

You can add an index-suffix between each conflicting entry.
These will be detected and removed during export, leading to the desired mod file result.

The index-suffix notation is `<thorn><index><thorn>` - e.g.: `þ1þ`.
Admittedly inconvenient to type ("ALT + 0254" on the num-pad, assuming a Windows setup), but in return pretty much guaranteed to _not_ conflict with any actual mod content.
Other than maybe an Iceland mod for Hearts of Iron.

So this would work as desired:

```powershell
@{
    triggered_planet_modifierþ1þ = @{
        potential = @{
            exists = 'owner'
            owner = @{ is_gestalt = $false }
            NOT = @{ has_modifier = 'slave_colony' }
        }
        modifier = @{
            job_soldier_add = 1
        }
    }

    triggered_planet_modifierþ2þ = @{
        potential = @{
            exists = 'owner'
            owner = @{ is_gestalt = $false }
            has_modifier = 'slave_colony'
        }
        modifier = @{
            job_battle_thrall_add = 1
        }
    }

    triggered_planet_modifierþ3þ = @{
        potential = @{
            exists = 'owner'
            owner = @{ is_gestalt = $true }
        }
        modifier = @{
            job_warrior_drone_add = 1
        }
    }
}
```
