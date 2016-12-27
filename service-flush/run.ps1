<# -----------------------------------------------------------------------------
.SYNOPSIS
    Automated service restarter.
.DESCRIPTION
    Reads config.json then stops, starts, logs, and emails the status of a list
    of services.  Note that the config file needs to be named 'config.json' and
    there needs to be a value for the logfile and the services array needs to
    contain at least one element.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v3
                     (can use v2 if .net 4 w/system.web.extensions is installed)
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
    Handle commandline parameters and verbosity
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
    Import common functions.
----------------------------------------------------------------------------- #>
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. "$scriptPath\..\_common\functions.ps1"


<# -----------------------------------------------------------------------------
    Preset variables in the script scope.
----------------------------------------------------------------------------- #>
$config = Get-Configuration "$scriptPath\config.json"
$now = Get-Date
# $config.services = @()
# $config.logfile = ""


<# -----------------------------------------------------------------------------
    Script functions
----------------------------------------------------------------------------- #>

Function Flush-AllServices {
    Write-Log "-----------------------------------------------------------"
    Write-Log "Starting service-flush script"

    Stop-AllServices
    Start-AllServices
    
    Write-Log "Ending service-flush script"
    Write-Log "-----------------------------------------------------------"
    Write-Log ""
}


Function Stop-AllServices {
    Foreach ($service in $config.services) {
        Write-Log "Stopping $($service) ..."
        Stop-Service $service
        Get-Service $service | ForEach-Object {
            Write-Log "Status: $($service) $($_.Status)"
        }
    }
}


Function Start-AllServices {
    Foreach ($service in $config.services) {
        Write-Log "Starting $($service) ..."
        Start-Service $service
        Get-Service $service | ForEach-Object {
            Write-Log "Status: $($service) $($_.Status)"
        }
    }
}

<# -----------------------------------------------------------------------------
    Run.
----------------------------------------------------------------------------- #>
Flush-AllServices