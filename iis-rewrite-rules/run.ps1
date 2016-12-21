<# -----------------------------------------------------------------------------
.SYNOPSIS
    IIS Rewrite Rule.
.DESCRIPTION
    Reads a csv file with IIS rules, applies those rules to supplied server and
    website.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V3+ (or .net 4 w/system.web.extensions for json)
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1 serverName csvFile webSiteName
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 serverName csvFile webSiteName -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
  Handle commandline parameters and verbosity.
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$serverName,

    [Parameter(Mandatory=$False)]
    # [string]$csvFile = (Get-Item -Path ".\rules.csv" -Verbose).FullName,
    [string]$csvFile = (Get-Item -Path ".\rules.csv" -Verbose).FullName,

    [Parameter(Mandatory=$False)]
    [string]$webSiteName = "Default Web Site"
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
$now = Get-Date
$counter = 0


<# -----------------------------------------------------------------------------
    Script functions.
----------------------------------------------------------------------------- #>
Function Parse-CsvFile ([string]$file) {
    Import-CSV $csvFile | Foreach-Object { 
        $script:counter++
        Write-Host "Name: $($_.name)"
    }
}

<# -----------------------------------------------------------------------------
    Run.
----------------------------------------------------------------------------- #>
Parse-CsvFile
Write-Host "$counter lines processed."
