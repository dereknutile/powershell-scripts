<#
.SYNOPSIS
    Powershell 2.0 missing functions
.DESCRIPTION
    When writing Powershell scripts, some common cmdlets do not exist in older
    versions.  This file attempts to remedy that by offering mostly compatible
    alternatives.
.NOTES
    File Name      : functions-for-ps-2.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V2+
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    Include this file in your script, then you can call functions from it.
    . "C:\path\to\tools\functions-for-ps-2.ps1"
#>


<# -----------------------------------------------------------------------------
  Functions
----------------------------------------------------------------------------- #>
<# Powershell 2 does NOT have the ConvertTo-Json commandlet #>
function ConvertTo-Json ([object] $item) {
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    return $ps_js.Serialize($item)
}


<# Powershell 2 does NOT have the ConvertFrom-Json commandlet #>
function ConvertFrom-Json ([object] $item) {
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    return $ps_js.DeserializeObject($item)
}