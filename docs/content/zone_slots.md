# Modding Zone Slots

When [modding Zone Slots](https://stellaris.paradoxwikis.com/District_modding), we place the definitions of our Zone Slots in `common/zone_slots`.

The same we do with the new configuration type file.
What used to be `mymod_zone_slots.txt` becomes `mymod_zone_slots.psd1`.

## Example Files

```powershell
@{
    Core = [ordered]@{
        Include = @( 'all' )
        Potential = @{
            exists = 'owner'
            owner = @{ is_ai = $false }
        }
        Unlock = @{ always = $true }
    }
    ZoneSlots = [ordered]@{
        slot_infernal_core = @{
            Start = 'zone_infernal_core'
        }
        slot_infernal_sector = @{
            Start = 'zone_infernal_core'
        }
        slot_infernal_01 = @{
            Start = 'zone_infernal'
        }
        slot_infernal_02 = @{
            Start = 'zone_infernal'
        }
    }
}
```

> [What's up with "Core"?](../general/core.md)
