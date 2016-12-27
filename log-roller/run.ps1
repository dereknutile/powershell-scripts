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
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. "$scriptPath\..\_common\functions.ps1"


<# -----------------------------------------------------------------------------
    Set variables.
----------------------------------------------------------------------------- #>
$targetDateTime = (Get-Date).AddDays(-$targetDaysOld)
$count = 0


<# -----------------------------------------------------------------------------
    Script functions
----------------------------------------------------------------------------- #>
Function Remove-Logfiles {
    # Iterate and count
    $files = Get-ChildItem $targetDir -Recurse | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt $targetDateTime }

    if($files.Count -gt 0){
        # Perform the removal
        Get-ChildItem $targetDir -Recurse | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt $targetDateTime } | Remove-Item
        $script:count = $files.Count
    }
}


<# -----------------------------------------------------------------------------
    Run.
----------------------------------------------------------------------------- #>
Write-Log "-----------------------------------------------------------"
Write-Log "Starting log-roller script"
Remove-Logfiles
Write-Log "Parsed $targetDir ..."
Write-Log "Removed log files older than $targetDateTime."
Write-Log "$count files removed"
Write-Log "Ending log-roller script"
Write-Log "-----------------------------------------------------------"
