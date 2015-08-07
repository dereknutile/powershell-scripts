<#
.SYNOPSIS
    Common utility functions.
.DESCRIPTION
    Included in this file are functions commonly used, re-written, copied and
    pasted and otherwise abused throughout other Powershell scripts.
.NOTES
    File Name      : functions.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V2+
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    Include this file in your script, then you can call functions from it.

    . "C:\path\to\tools\functions.ps1"
    $version = Get-PowershellVersion
#>


<# -----------------------------------------------------------------------------
  Returns the Powershell major version - ex: 2 or 3, or 4, etc.
----------------------------------------------------------------------------- #>
Function Get-PowershellVersion {
  return $PSVersionTable.PSVersion.Major
}