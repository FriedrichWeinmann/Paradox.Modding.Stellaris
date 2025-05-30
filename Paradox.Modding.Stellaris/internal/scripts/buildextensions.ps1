Register-PdxBuildExtension -Name 'Stellaris.Edicts' -Tags 'stellaris','edicts' -Description 'Builds all edicts in a Stellaris mod' -Code {
	param ($Data)

	if (Test-Path "$($Data.Root)\common\edicts\*.psd1") {
		ConvertTo-PdsEdict -Path "$($Data.Root)\common\edicts\*.psd1"
	}
}
Register-PdxBuildExtension -Name 'Stellaris.Buildings' -Tags 'stellaris','buildings' -Description 'Builds all buildings in a Stellaris mod' -Code {
	param ($Data)

	if (Test-Path "$($Data.Root)\common\buildings\*.psd1") {
		ConvertTo-PdsBuilding -Path "$($Data.Root)\common\buildings\*.psd1"
	}
}
Register-PdxBuildExtension -Name 'Stellaris.Zones' -Tags 'stellaris','zones' -Description 'Builds all zones in a Stellaris mod' -Code {
	param ($Data)

	if (Test-Path "$($Data.Root)\common\zones\*.psd1") {
		ConvertTo-PdsZone -Path "$($Data.Root)\common\zones\*.psd1"
	}
}
Register-PdxBuildExtension -Name 'Stellaris.ZoneSlotss' -Tags 'stellaris','zoneslots' -Description 'Builds all zone slots in a Stellaris mod' -Code {
	param ($Data)

	if (Test-Path "$($Data.Root)\common\zone_slots\*.psd1") {
		ConvertTo-PdsZoneSlot -Path "$($Data.Root)\common\zone_slots\*.psd1"
	}
}
Register-PdxBuildExtension -Name 'Stellaris.Districts' -Tags 'stellaris','districts' -Description 'Builds all districts in a Stellaris mod' -Code {
	param ($Data)

	if (Test-Path "$($Data.Root)\common\districts\*.psd1") {
		ConvertTo-PdsDistrict -Path "$($Data.Root)\common\districts\*.psd1"
	}
}