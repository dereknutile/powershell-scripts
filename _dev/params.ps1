<# -----------------------------------------------------------------------------
.SYNOPSIS
    Testing: Passing parameters
.DESCRIPTION
    Simple example of parsing command line paramters and passing through to variables.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v2
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1 filePath
    powershell.exe .\run.ps1 filePath computerName
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
	Handle commandline parameters and verbosity
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$filePath,
    
    [Parameter(Mandatory=$False)]
    [string]$computerName = $env:computerName
)


<# -----------------------------------------------------------------------------
	Preset variables in the script scope.
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
    Run
----------------------------------------------------------------------------- #>
Write-Host $filePath
Write-Host $computerName