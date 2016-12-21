<# -----------------------------------------------------------------------------
.SYNOPSIS
    Testing: Restart services
.DESCRIPTION
    Restarts the Spooler service on the local machine.
.NOTES
    File Name      : read-input.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v2
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\read-input.ps1
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
	Handle commandline parameters and verbosity
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
	Preset variables in the script scope.
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
	Run.
----------------------------------------------------------------------------- #>
$numberInput = Read-Host 'Type a number'
Write-Output "Your number: $numberInput"
