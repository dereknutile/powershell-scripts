<# -----------------------------------------------------------------------------
.SYNOPSIS
    Testing: Remove IIS rewrite by name
.DESCRIPTION
    Simple example of parsing command line paramters and passing through to variables.
.NOTES
    File Name      : iis-remove-rewrite.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v2
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\iis-remove-rewrite.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\iis-remove-rewrite.ps1 -Verbose
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
	Handle commandline parameters and verbosity
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
	Preset variables in the script scope.
----------------------------------------------------------------------------- #>
$site = "iis:\sites\Default Web Site"
$ruleName = "This is a test"


<# -----------------------------------------------------------------------------
	Run
----------------------------------------------------------------------------- #>
Clear-WebConfiguration -pspath $site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']"
