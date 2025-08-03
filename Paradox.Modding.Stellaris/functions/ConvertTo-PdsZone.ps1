function ConvertTo-PdsZone {
	<#
	.SYNOPSIS
		Converts zone configuration files into zone mod files.
	
	.DESCRIPTION
		Converts zone configuration files into zone mod files.
		This command is used to read psd1-based configuration files for zones and convert them into the format Stellaris expects.
		Generally, this command needs not be called directly and happens automatically during Build-PdxMod.

		For more details on how to define zones via configuration file, see:
		https://github.com/FriedrichWeinmann/Paradox.Modding.Stellaris/blob/master/docs/content/zones.md
	
	.PARAMETER Path
		Path to the file(s) to build.
	
	.PARAMETER ModRoot
		Root path of the mod you are building.
		Defaults to the parent folder of the parent folder of the first file specified in -Path.
	
	.EXAMPLE
		PS C:\> ConvertTo-PdsZone -Path "$PSScriptRoot\common\zones\*.psd1"

		Builds all .psd1 files in the common\zones subfolder under the path the current script is placed.
	
	.LINK
		https://github.com/FriedrichWeinmann/Paradox.Modding.Stellaris/blob/master/docs/content/zones.md
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('FullName')]
		[PSFFile]
		$Path,

		[string]
		$ModRoot
	)
	begin {
		$commonProps = [ordered]@{
			Icon           = 'icon'
			BuildTime      = 'base_buildtime'
			Potential      = 'potential'
			Unlock         = 'unlock'
			Include        = 'include'
			Resources      = 'resources'
			MaxBuildings   = 'max_buildings'
			PlanetModifier = 'planet_modifier'
		}

		$localeMap = @{
			Name        = '{0}'
			Description = '{0}_desc'
		}
		$typeMap = @{
			include = 'array'
			exclude = 'array'
			included_building_sets = 'array'
			excluded_building_sets = 'array'
		}
	}
	process {
		foreach ($filePath in $Path) {
			if (-not $ModRoot) {
				$ModRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $filePath))
			}

			$strings = New-PdxLocalizedString
			$data = Import-PSFPowerShellDataFile -LiteralPath $filePath -Psd1Mode Unsafe
			$allzones = [ordered]@{}

			#region Build Edict Data
			foreach ($zoneName in $data.zones.Keys) {
				$zoneData = $data.zones.$zoneName

				$newzone = [ordered]@{}

				#region Cost & Upkeep
				$currentCost = $data.Core.Cost
				if ($zoneData.Cost) { $currentCost = $zoneData.Cost }

				if ($currentCost) {
					$resourceData = [ordered]@{
						category = 'planet_zones'
					}
					if ($currentCost) {
						if ($currentCost -is [int]) {
							$resourceData['cost'] = @{ minerals = $currentCost }
						}
						else {
							$resourceData['cost'] = $currentCost
						}
					}
					$newzone['resources'] = $resourceData
				}
				#endregion Cost & Upkeep

				$allzones[$zoneName] = New-PdxConfigEntry -Entry $zoneData -Name $zoneName -Defaults $data.Core -Common $commonProps -Output $newzone -Strings $strings -LocalizationProperties $localeMap -Ignore Cost -TypeMap $typeMap
			}
			#endregion Build Edict Data

			# Write File
			$sourceFile = Get-Item -LiteralPath $filePath
			$exportFile = Join-Path -Path $sourceFile.DirectoryName -ChildPath "$($sourceFile.BaseName).txt"
			$allzones | ConvertTo-PdxConfigFormat -TopLevel | Set-Content -Path $exportFile

			# Write Localization
			Export-PdxLocalizedString -Strings $strings -ModRoot $ModRoot -Name "zones_$($sourceFile.BaseName)"
		}
	}
}