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
    powershell.exe .\run.ps1 serverName csvFile webSiteName logFile
.EXAMPLE
    Add the -Force switch to overwrite the rule if it exists
    powershell.exe .\run.ps1 serverName -Force
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 serverName csvFile webSiteName logFile -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
    Handle commandline parameters and verbosity.
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False)]
    [string]$serverName = $env:computerName,

    [Parameter(Mandatory=$False)]
    [string]$csvFile = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\rules.csv",

    [Parameter(Mandatory=$False)]
    [string]$webSiteName = "Default Web Site",

    [Parameter(Mandatory=$False)]
    [string]$logFile = "$(Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)\logfile.log",
    
    [switch]$Force = $False
)


<# -----------------------------------------------------------------------------
    Import common functions.
----------------------------------------------------------------------------- #>
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. "$scriptPath\..\_common\functions.ps1"


<# -----------------------------------------------------------------------------
    Set variables.
----------------------------------------------------------------------------- #>
$now = Get-Date
$totalRulesProcessed = 0
$totalRulesDeleted = 0
$totalRulesAdded = 0
$site = "iis:\sites\$webSiteName"

<# -----------------------------------------------------------------------------
    Script functions.
----------------------------------------------------------------------------- #>
Function Parse-CsvFile {
    Import-CSV $script:csvFile | Foreach-Object { 
        $script:totalRulesProcessed++

        # Force will delete if exists, then add
        if($Force){
            if(Rewrite-Exists $_.Name){
                Delete-IisRewrite $_.Name
            }
            Add-IisRewrite $_.PatternSyntax $_.StopProcessing $_.Name $_.Pattern $_.Type $_.IgnoreCase $_.RewriteUrl

        # No Force means only add if it doesn't exist
        } else {
            if(-Not (Rewrite-Exists $_.Name)){
                Add-IisRewrite $_.PatternSyntax $_.StopProcessing $_.Name $_.Pattern $_.Type $_.IgnoreCase $_.RewriteUrl
            }
        }
    }
}

Function Rewrite-Exists ([string]$name){
    $exists = Get-WebConfigurationProperty -pspath $script:site -filter "/system.webserver/rewrite/rules/rule[@name='$name']" -name "."
    
    return $exists
}

Function Add-IisRewrite (
    [string]$patternSyntax = "Regular Expressions",
    [string]$stopProcessing = "True",
    [string]$name,
    [string]$pattern,
    [string]$type = "Rewrite",
    [string]$ignoreCase = "True",
    [string]$RewriteUrl )
{
        
    Add-WebConfigurationProperty -pspath $site -filter "system.webServer/rewrite/rules" -name "." -value @{
        name="$name";
        patternSyntax='Regular Expressions';
        stopProcessing='True';
    }

    Set-WebConfigurationProperty -pspath $script:site -filter "/system.webserver/rewrite/rules/rule[@name='$name']/match" -name "." -value @{ url="$pattern";ignoreCase="$ignoreCase"; }

    Set-WebConfigurationProperty -pspath $script:site -filter "/system.webserver/rewrite/rules/rule[@name='$name']/action" -name "." -value @{ type="$type"; url="$RewriteUrl";} 

    Write-Log "Added rule: $name"
    $script:totalRulesAdded++
}

Function Delete-IisRewrite ([string]$name) {
    Clear-WebConfiguration -pspath $script:site -filter "/system.webserver/rewrite/rules/rule[@name='$name']"
    Write-Log "Deleted rule: $name"
    $script:totalRulesDeleted++
}

Function Process-CsvFile ([string]$file) {
    Parse-CsvFile
}

<# -----------------------------------------------------------------------------
    Run.
----------------------------------------------------------------------------- #>
Write-Log "-----------------------------------------------------------"
Write-Log "Start import of $csvFile."
Write-Log "Processing for server: $serverName"
Process-CsvFile
Write-Log "$totalRulesProcessed rules processed."
Write-Log "$totalRulesAdded rules added."
Write-Log "$totalRulesDeleted rules deleted."
Write-Log "End of Import"
Write-Log "-----------------------------------------------------------"
Write-Log ""
