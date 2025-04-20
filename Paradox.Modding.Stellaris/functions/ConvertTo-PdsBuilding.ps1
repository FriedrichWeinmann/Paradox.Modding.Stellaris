function ConvertTo-PdsBuilding {
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
			Capital         = 'capital'
			CanBuild        = 'can_build'
			CanDemolish     = 'can_demolish'
			CanRuin         = 'can_be_ruined'
			CanDisable      = 'can_be_disabled'
			Position        = 'position_priority'
			BuildTime       = 'base_buildtime'
			EmpireLimit     = 'empire_limit'
			CanBeRuined     = 'can_be_ruined'
			Category        = 'category'
			Prerequisites   = 'prerequisites'
			UpgradeTo       = 'upgrades'
			Upgrades        = 'upgrades'
			Potential       = 'potential'
			Allow           = 'allow'
			PlanetModifier  = 'planet_modifier'
			CountryModifier = 'country_modifier'
		}

		$localeMap = @{
			Name        = '{0}'
			Description = '{0}_desc'
		}

		$typeMap = @{
			upgrades = 'array'
			prerequisites = 'array'
		}
	}
	process {
		foreach ($filePath in $Path) {
			if (-not $ModRoot) {
				$ModRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $filePath))
			}

			$strings = New-PdxLocalizedString
			$data = Import-PSFPowerShellDataFile -LiteralPath $filePath -Psd1Mode Unsafe
			$allBuildings = [ordered]@{}

			#region Build Edict Data
			foreach ($buildingName in $data.Buildings.Keys) {
				$buildingData = $data.Buildings.$buildingName

				$newBuilding = [ordered]@{}

				#region Cost & Upkeep
				$currentCost = $data.Core.Cost
				if ($buildingData.Cost) { $currentCost = $buildingData.Cost }
				$currentUpkeep = $data.Core.Upkeep
				if ($buildingData.Upkeep) { $currentUpkeep = $buildingData.Upkeep }

				if ($currentCost -or $currentUpkeep) {
					$resourceData = [ordered]@{
						category = 'planet_buildings'
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
					$newBuilding['resources'] = $resourceData
				}
				#endregion Cost & Upkeep

				$allBuildings[$buildingName] = New-PdxConfigEntry -Entry $buildingData -Name $buildingName -Defaults $data.Core -Common $commonProps -Output $newBuilding -Strings $strings -LocalizationProperties $localeMap -Ignore Cost, Upkeep -TypeMap $typeMap
			}
			#endregion Build Edict Data

			# Write File
			$sourceFile = Get-Item -LiteralPath $filePath
			$exportFile = Join-Path -Path $sourceFile.DirectoryName -ChildPath "$($sourceFile.BaseName).txt"
			$allBuildings | ConvertTo-PdxConfigFormat -TopLevel | Set-Content -Path $exportFile

			# Write Localization
			Export-PdxLocalizedString -Strings $strings -ModRoot $ModRoot -Name "buildings_$($sourceFile.BaseName)"
		}
	}
}