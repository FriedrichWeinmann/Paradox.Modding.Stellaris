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