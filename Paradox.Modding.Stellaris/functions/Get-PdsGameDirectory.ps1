function Get-PdsGameDirectory {
	<#
	.SYNOPSIS
		Returns the root path to the Stellaris game installation.
	
	.DESCRIPTION
		Returns the root path to the Stellaris game installation.
		Uses steam to figure it out the path.
		Define the 'Paradox.Modding.Stellaris.Installpath' configuration setting (using Set-PSFConfig) to override (and disable) autodetection.
	
	.EXAMPLE
		PS C:\> Get-PdsGameDirectory

		returns the path to where the game is installed.
	#>
	[OutputType([string])]
	[CmdletBinding()]
	param ()
	process {
		# Configuration beats it all
		if (Get-PSFConfigValue -Fullname 'Paradox.Modding.Stellaris.Installpath') {
			return Get-PSFConfigValue -Fullname 'Paradox.Modding.Stellaris.Installpath'
		}

		# Once cached, do not resolve again.
		if ($script:_stellarisGamePath) { return $script:_stellarisGamePath }

		# Resolve using Steam configuration path.
		$steamLibraryCfgFile = "${env:ProgramFiles(x86)}\Steam\config\libraryfolders.vdf"
		$steamLibraries = Get-Content -Path $steamLibraryCfgFile | Where-Object { $_ -match '"path"' } | ForEach-Object {
			$_ -replace '^.+"path".+?"' -replace '".{0,}' -replace '\\\\', '\'
		}
		foreach ($path in $steamLibraries) {
			if (Test-Path -Path "$path\steamapps\common\Stellaris\stellaris.exe") {
				$script:_stellarisGamePath = "$path\steamapps\common\Stellaris"
				return "$path\steamapps\common\Stellaris"
			}
		}

		Stop-PSFFunction -Message "Stellaris installation path not found! Autodiscovery failed to detect it, use the following line to tell the module where to find the game:`nSet-PSFConfig -FullName 'Paradox.Modding.Stellaris.Installpath' -Value '<InsertPathhere>' -PassThru | Register-PSFConfig" -EnableException $true -Cmdlet $PSCmdlet
	}
}