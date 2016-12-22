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
    [string]$csvFile = (Get-Item -Path ".\rules.csv" -Verbose).FullName,
    # [string]$csvFile = (Get-Item -Path ".\rules.example" -Verbose).FullName,

    [Parameter(Mandatory=$False)]
    [string]$webSiteName = "Default Web Site",

    [Parameter(Mandatory=$False)]
    [string]$logFile = ".\logfile.log",
    
    [switch]$Force = $False
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
$rulesCounter = 0
$site = "iis:\sites\$webSiteName"

<# -----------------------------------------------------------------------------
    Script functions.
----------------------------------------------------------------------------- #>
Function Parse-CsvFile {
    Import-CSV $script:csvFile | Foreach-Object { 
        $script:rulesCounter++

        if($Force){
            Delete-IisRewrite $_.Name
        }

        Add-IisRewrite $_.PatternSyntax $_.StopProcessing $_.Name $_.Pattern $_.Type $_.IgnoreCase $_.RewriteUrl
    }
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
}

Function Delete-IisRewrite ([string]$ruleName) {
    Clear-WebConfiguration -pspath $script:site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']"
    Write-Log "Deleted rule: $ruleName"
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
Write-Log "$rulesCounter rules processed."
Write-Log "End of Import"
Write-Log "-----------------------------------------------------------"
Write-Log ""
