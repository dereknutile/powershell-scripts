<#
.SYNOPSIS
    Logfile roller.
.DESCRIPTION
    Reads config.json to get the target directory where log files would be kept
    as well as the value for how many days back to start removing items.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V3+ (or .net 4 w/system.web.extensions for json)
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1 logfile output
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 -Verbose
#>


<# -----------------------------------------------------------------------------
  Needed to accept the '-Verbose' switch.
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
  Import toolbox.
----------------------------------------------------------------------------- #>
. "..\tools\functions.ps1"

# If the client uses Powershell v2, there is no cmdlet for handling json
if(Get-PowershellVersion -eq 2) {
  . "..\tools\functions-for-ps-2.ps1"
}


<# -----------------------------------------------------------------------------
  Set variables.
----------------------------------------------------------------------------- #>
$config = Get-Configuration config.json

# Removed the call from the config because Powershell v2 has issues with reading
# JSON and the slashes are causing trouble. Example: .\logs is invalid JSON.
# $targetDir = $config.targetDir

$targetDir = ".\logs"
$targetDaysOld = (Get-Date).AddDays(-$config.targetDaysOld)


<# -----------------------------------------------------------------------------
  Script functions
----------------------------------------------------------------------------- #>
Function Remove-Logfiles {
    Get-ChildItem $targetDir -Recurse | ? {
        -not $_.PSIsContainer -and $_.CreationTime -lt $targetDaysOld
    }
    # } | Remove-Item
}


<# -----------------------------------------------------------------------------
  The meat.
----------------------------------------------------------------------------- #>
Write-Host "Starting script"
Write-Host "Parsing $targetDir ..."
Write-Host "Removing log files older than $targetDaysOld."
Remove-Logfiles
Write-Host "Ending script"
