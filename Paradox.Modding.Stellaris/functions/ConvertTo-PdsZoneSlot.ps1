function ConvertTo-PdsZoneSlot {
	<#
	.SYNOPSIS
		Converts zoneslot configuration files into zoneslot mod files.
	
	.DESCRIPTION
		Converts zoneslot configuration files into zoneslot mod files.
		This command is used to read psd1-based configuration files for zoneslots and convert them into the format Stellaris expects.
		Generally, this command needs not be called directly and happens automatically during Build-PdxMod.

		For more details on how to define zoneslots via configuration file, see:
		https://github.com/FriedrichWeinmann/Paradox.Modding.Stellaris/blob/master/docs/content/zone_slots.md
	
	.PARAMETER Path
		Path to the file(s) to build.
	
	.PARAMETER ModRoot
		Root path of the mod you are building.
		Defaults to the parent folder of the parent folder of the first file specified in -Path.
	
	.EXAMPLE
		PS C:\> ConvertTo-PdsZoneSlot -Path "$PSScriptRoot\common\zone_slots\*.psd1"

		Builds all .psd1 files in the common\zone_slots subfolder under the path the current script is placed.
	
	.LINK
		https://github.com/FriedrichWeinmann/Paradox.Modding.Stellaris/blob/master/docs/content/zone_slots.md
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
			Start     = 'start' # A zone of this type is immediately placed in a new district slot.
			Include   = 'include' # A list of zone types that are available to be built in the slot. The key 'all' can be used to include all existing zone types.
			Exclude   = 'exclude' # A list of zone types that aren't available to be built in the slot.
			Potential = 'potential' # Trigger that defines whether the slot is available on the planet at all. Scope = Planet.
			Unlock    = 'unlock'  # Trigger that defines whether the slot is unlocked on the planet. Scope = Planet.
		}
		$typeMap = @{
			include = 'array'
			exclude = 'array'
		}
	}
	process {
		foreach ($filePath in $Path) {
			if (-not $ModRoot) {
				$ModRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $filePath))
			}

			$data = Import-PSFPowerShellDataFile -LiteralPath $filePath -Psd1Mode Unsafe
			$allzoneslots = [ordered]@{}

			#region Build Edict Data
			foreach ($zoneslotName in $data.ZoneSlots.Keys) {
				$zoneslotData = $data.ZoneSlots.$zoneslotName

				$newzoneslot = [ordered]@{}

				$allzoneslots[$zoneslotName] = New-PdxConfigEntry -Entry $zoneslotData -Name $zoneslotName -Defaults $data.Core -Common $commonProps -Strings @{} -LocalizationProperties @{} -Output $newzoneslot -TypeMap $typeMap
			}
			#endregion Build Edict Data

			# Write File
			$sourceFile = Get-Item -LiteralPath $filePath
			$exportFile = Join-Path -Path $sourceFile.DirectoryName -ChildPath "$($sourceFile.BaseName).txt"
			$allzoneslots | ConvertTo-PdxConfigFormat -TopLevel | Set-Content -Path $exportFile
		}
	}
}