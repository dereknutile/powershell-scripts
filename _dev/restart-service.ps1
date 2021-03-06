<# -----------------------------------------------------------------------------
.SYNOPSIS
    Testing: Restart services
.DESCRIPTION
    Restarts the Spooler service on the local machine.
.NOTES
    File Name      : restart-service.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v2
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\restart-service.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\restart-service.ps1 -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
	Handle commandline parameters and verbosity
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
	Preset variables in the script scope.
----------------------------------------------------------------------------- #>
$serviceName = "Spooler"


<# -----------------------------------------------------------------------------
	Run.
----------------------------------------------------------------------------- #>
Write-Output "Restarting $serviceName Service ..."

Get-Service | Where {$_.Name -Match $serviceName}

Get-Service $serviceName | Stop-Service -Force
Get-Service | Where {$_.Name -Match $serviceName}

Get-Service $serviceName | Start-Service
Get-Service | Where {$_.Name -Match $serviceName}
