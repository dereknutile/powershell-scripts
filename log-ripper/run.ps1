<# -----------------------------------------------------------------------------
.SYNOPSIS
    Logfile ripper.
.DESCRIPTION
    Reads config.json to gather an array of attributes to search for, then opens
    a log file and reads it line-by-line writing out only the matching criteria
    to an output file.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V3+ (or .net 4 w/system.web.extensions for json)
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1
    powershell.exe .\run.ps1 inputFile outputFile
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
    Handle commandline parameters.
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False)]
    [string]$inputFile = (Get-Item -Path ".\input.log" -Verbose).FullName,

    [Parameter(Mandatory=$False)]
    [string]$outputFile = ".\$(Get-Date -Format yyyy-M-d-H-m-s)-output.log"
)


<# -----------------------------------------------------------------------------
    Import common functions.
----------------------------------------------------------------------------- #>
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
. "$scriptPath\..\_common\functions.ps1"


<# -----------------------------------------------------------------------------
    Set variables.
----------------------------------------------------------------------------- #>
$config = Get-Configuration config.json
$attributes = $config.attributes
$outputString = ""
$counter = 0
$hits = 0


<# -----------------------------------------------------------------------------
    Script functions
----------------------------------------------------------------------------- #>
Function Parse-File ([string]$file)  {
    $result = ""
    $io = [System.IO.File]::OpenText($file)
    while($null -ne ($line = $io.ReadLine())) {
        $script:counter++;
        foreach ($attribute in $attributes) {
            if($line.Contains($attribute)){
                $script:hits++;
                $trimmedLine = $line.Trim()
                $result = "$result$trimmedLine`n"
            }
        }
    }
    $io.Close
    $script:outputString = $result
}


<# -----------------------------------------------------------------------------
    Run.
----------------------------------------------------------------------------- #>
Parse-File $inputFile
$outputString | Set-Content $outputFile
Write-Host "$counter lines parsed with $hits matches from $inputFile."
