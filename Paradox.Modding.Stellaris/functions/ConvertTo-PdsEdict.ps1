function ConvertTo-PdsEdict {
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
			Length = 'length'
			EdictCapUsage = 'edict_cap_usage'
			Potential = 'potential'
			Allow = 'allow'
			AIWeight = 'ai_weight'
			Modifier = 'modifier'
		}
	}
	process {
		foreach ($filePath in $Path) {
			if (-not $ModRoot) {
				$ModRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $filePath))
			}

			$strings = New-PdxLocalizedString
			$data = Import-PSFPowerShellDataFile -LiteralPath $filePath -Psd1Mode Unsafe
			$allEdicts = [ordered]@{}

			#region Build Edict Data
			foreach ($edictName in $data.Edicts.Keys) {
				$edictData = $data.Edicts.$edictName

				$newEdict = [ordered]@{}

				#region Cost
				$currentCost = $data.Core.Cost
				if ($edictData.Cost) { $currentCost = $edictData.Cost }
				if (-not $currentCost) { $currentCost = 0 }

				$costHash = @{ influence = $currentCost }
				if ($currentCost -isnot [int]) { $costhash = $currentCost }

				$newEdict['resources'] = [ordered]@{
					category = 'edicts'
					cost = $costHash
				}
				#endregion Cost

				$allEdicts[$edictName] = New-PdxConfigEntry -Entry $edictData -Name $edictName -Defaults $data.Core -Common $commonProps -Output $newEdict -Strings $strings -LocalizationProperties @{
					Name = 'edict_{0}'
					Description = 'edict_{0}_desc'
				} -Ignore Cost
			}
			#endregion Build Edict Data

			# Write File
			$sourceFile = Get-Item -LiteralPath $filePath
			$exportFile = Join-Path -Path $sourceFile.DirectoryName -ChildPath "$($sourceFile.BaseName).txt"
			$allEdicts | ConvertTo-PdxConfigFormat -TopLevel | Set-Content -Path $exportFile

			# Write Localization
			Export-PdxLocalizedString -Strings $strings -ModRoot $ModRoot -Name "edicts_$($sourceFile.BaseName)"
		}
	}
}