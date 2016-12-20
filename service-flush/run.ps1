<#
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
    Prerequisite   : PowerShell V3+ (or .net 4 w/system.web.extensions for json)
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 -Verbose
#>


<# -----------------------------------------------------------------------------
  Handle commandline parameters and verbosity
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
  Import common functions.
----------------------------------------------------------------------------- #>
. "..\common\functions.ps1"

# If the client uses Powershell v2, there is no cmdlet for handling json
if(Get-PowershellVersion -eq 2) {
  . "..\common\functions-for-ps-2.ps1"
}


<# -----------------------------------------------------------------------------
  Preset variables in the script scope.
----------------------------------------------------------------------------- #>
$config = Get-Configuration config.json
$now = Get-Date
# $config.services = @()
# $config.logfile = ""


<# -----------------------------------------------------------------------------
  Script functions
----------------------------------------------------------------------------- #>

Function Flush-AllServices {
  Stop-AllServices
  Start-AllServices
}


Function Stop-AllServices {
  Foreach ($service in $config.services) {
    Write-ToLogFile "Stopping $($service) ..."
    Stop-Service $service
    Get-Service $service | ForEach-Object {
        Write-ToLogFile "Status: $($service) $($_.Status)"
    }
  }
}


Function Start-AllServices {
  Foreach ($service in $config.services) {
    Write-ToLogFile "Starting $($service) ..."
    Start-Service $service
    Get-Service $service | ForEach-Object {
        Write-ToLogFile "Status: $($service) $($_.Status)"
    }
  }
}


Function Write-ToLogFile ([string]$entry) {
    if($entry.length -gt 0) {
      Write-Verbose -Message $entry
      Add-Content $config.logfile -value "$($(Get-Date).ToString('yyyy-MM-dd-HH-mm-ss')): $($entry)"
    } else {
      Add-Content $config.logfile -value ""
    }
}


<# -----------------------------------------------------------------------------
  Run
----------------------------------------------------------------------------- #>
Write-ToLogFile "Starting script"
Flush-AllServices
Write-ToLogFile "Ending script"
Write-ToLogFile ""
