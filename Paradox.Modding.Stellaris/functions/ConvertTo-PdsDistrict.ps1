function ConvertTo-PdsDistrict {
	<#
	.SYNOPSIS
		Converts district configuration files into district mod files.
	
	.DESCRIPTION
		Converts district configuration files into district mod files.
		This command is used to read psd1-based configuration files for districts and convert them into the format Stellaris expects.
		Generally, this command needs not be called directly and happens automatically during Build-PdxMod.

		For more details on how to define districts via configuration file, see:
		https://github.com/FriedrichWeinmann/Paradox.Modding.Stellaris/blob/master/docs/content/districts.md
	
	.PARAMETER Path
		Path to the file(s) to build.
	
	.PARAMETER ModRoot
		Root path of the mod you are building.
		Defaults to the parent folder of the parent folder of the first file specified in -Path.
	
	.EXAMPLE
		PS C:\> ConvertTo-PdsDistrict -Path "$PSScriptRoot\common\districts\*.psd1"

		Builds all .psd1 files in the common\districts subfolder under the path the current script is placed.
	
	.LINK
		https://github.com/FriedrichWeinmann/Paradox.Modding.Stellaris/blob/master/docs/content/districts.md
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
			BuildTime         = 'base_buildtime'
			MinDeposits       = 'min_for_deposits_on_planet'
			MaxDeposits       = 'max_for_deposits_on_planet'
			Capped            = 'is_capped_by_modifier'
			Exempt            = 'exempt_from_ai_planet_specialization'
			Default           = 'default_starting_district'
			Slots             = 'zone_slots'
			ShowOnUncolonized = 'show_on_uncolonized'
			Potential         = 'potential'
			Allow             = 'allow'
			ConversionRatio   = 'conversion_ratio' # integer
			ConvertTo         = 'convert_to' # array
			Resources         = 'resources'
			PlanetModifier    = 'planet_modifier'
		}

		$localeMap = @{
			Name        = '{0}'
			Description = '{0}_desc'
		}
		$typeMap = @{
			zone_slots = 'array'
			convert_to = 'array'
		}
	}
	process {
		foreach ($filePath in $Path) {
			if (-not $ModRoot) {
				$ModRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $filePath))
			}

			$strings = New-PdxLocalizedString
			$data = Import-PSFPowerShellDataFile -LiteralPath $filePath -Psd1Mode Unsafe
			$alldistricts = [ordered]@{}

			#region Build Edict Data
			foreach ($districtName in $data.districts.Keys) {
				$districtData = $data.districts.$districtName

				$newdistrict = [ordered]@{}

				#region Cost & Upkeep
				$currentCost = $data.Core.Cost
				if ($districtData.Cost) { $currentCost = $districtData.Cost }
				$currentUpkeep = $data.Core.Upkeep
				if ($districtData.Upkeep) { $currentUpkeep = $districtData.Upkeep }

				if ($currentCost -or $currentUpkeep) {
					$resourceData = [ordered]@{
						category = 'planet_districts_cities'
					}
					if ($currentCost) {
						if ($currentCost -is [int]) {
							$resourceData['cost'] = @{ minerals = $currentCost }
						}
						else {
							$resourceData['cost'] = $currentCost
						}
					}
					if ($currentUpkeep) {
						if ($currentUpkeep -is [int]) {
							$resourceData['upkeep'] = @{ energy = $currentUpkeep }
						}
						else {
							$resourceData['upkeep'] = $currentUpkeep
						}
					}
					$newdistrict['resources'] = $resourceData
				}
				#endregion Cost & Upkeep

				$alldistricts[$districtName] = New-PdxConfigEntry -Entry $districtData -Name $districtName -Defaults $data.Core -Common $commonProps -Output $newdistrict -Strings $strings -LocalizationProperties $localeMap -Ignore Cost, Upkeep -TypeMap $typeMap
			}
			#endregion Build Edict Data

			# Write File
			$sourceFile = Get-Item -LiteralPath $filePath
			$exportFile = Join-Path -Path $sourceFile.DirectoryName -ChildPath "$($sourceFile.BaseName).txt"
			$alldistricts | ConvertTo-PdxConfigFormat -TopLevel | Set-Content -Path $exportFile

			# Write Localization
			Export-PdxLocalizedString -Strings $strings -ModRoot $ModRoot -Name "districts_$($sourceFile.BaseName)"
		}
	}
}