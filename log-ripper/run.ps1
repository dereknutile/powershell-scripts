<#
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
. "..\_common\functions.ps1"

# If the client uses Powershell v2, there is no cmdlet for handling json
if(Get-PowershellVersion -eq 2) {
  . "..\_common\functions-for-ps-2.ps1"
}


<# -----------------------------------------------------------------------------
  Set variables.
----------------------------------------------------------------------------- #>
$config = Get-Configuration config.json
$inputFile = "C:\Users\derekn\dev\powershell-scripts\log-ripper\input.log"
$outputFile = $config.logfile
$attributes = $config.attributes
$outputString = ""
$counter = 0


<# -----------------------------------------------------------------------------
  Script functions
----------------------------------------------------------------------------- #>
$io = [System.IO.File]::OpenText($inputFile)
while($null -ne ($line = $io.ReadLine())) {
    $counter++;
    foreach ($attribute in $attributes) {
        if($line.Contains($attribute)){
            $trimmedLine = $line.Trim()
            $outputString = "$outputString $trimmedLine`n"
        }
    }
}
$io.Close


<# -----------------------------------------------------------------------------
  The meat.
----------------------------------------------------------------------------- #>
$outputString | Set-Content $outputFile
Write-Host "$counter lines parsed from $inputFile."