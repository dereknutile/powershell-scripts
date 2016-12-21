<# -----------------------------------------------------------------------------
    WARNING: THIS SCRIPT DELETES FILES, USE WITH CAUTION!
----------------------------------------------------------------------------- #>

<# -----------------------------------------------------------------------------
.SYNOPSIS
    Logfile roller.
.DESCRIPTION
    Reads config.json to get the target directory where log files would be kept
    as well as the value for how many days back to start removing items.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v3
                     (can use v2 if .net 4 w/system.web.extensions is installed)
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1
    powershell.exe .\run.ps1 targetDir
    powershell.exe .\run.ps1 targetDir targetDaysOld
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 targetDir targetDaysOld -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
    Handle commandline parameters
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False)]
    [string]$targetDir = (Get-Item -Path ".\logs" -Verbose).FullName,

    [Parameter(Mandatory=$False)]
    [string]$targetDaysOld = 30
)


<# -----------------------------------------------------------------------------
    Import common functions.
----------------------------------------------------------------------------- #>
. "..\_common\functions.ps1"

# If the client uses Powershell v2, there is no cmdlet for handling json
if(Get-PowershellVersion -eq 2) {
    . "..\_common\functions-for-ps-2.ps1"
}


<# -----------------------------------------------------------------------------
    Set variables.
----------------------------------------------------------------------------- #>
$targetDateTime = (Get-Date).AddDays(-$targetDaysOld)


<# -----------------------------------------------------------------------------
    Script functions
----------------------------------------------------------------------------- #>
Function Remove-Logfiles {
    # Iterate and count
    $files = Get-ChildItem $targetDir -Recurse | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt $targetDateTime }
    $script:count = $files.Count

    # Perform the removal
    Get-ChildItem $targetDir -Recurse | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt $targetDateTime } | Remove-Item
}


<# -----------------------------------------------------------------------------
    Run.
----------------------------------------------------------------------------- #>
Write-Host "Starting script"
Remove-Logfiles
Write-Host "Parsed $targetDir ..."
Write-Host "Removed log files older than $targetDateTime."
Write-Host "$script:count files removed"
Write-Host "Ending script"
