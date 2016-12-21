<# -----------------------------------------------------------------------------
.SYNOPSIS
    Testfile: Add a rule to IIS
.DESCRIPTION
    Add a rule to local IIS web server.
.NOTES
    File Name      : iis-add-rewrite.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell v2
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\iis-add-rewrite.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\iis-add-rewrite.ps1 -Verbose
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
$ruleName = "PowerShell Made This"


<# -----------------------------------------------------------------------------
    Run
----------------------------------------------------------------------------- #>
Add-WebConfigurationProperty -pspath $site -filter "system.webServer/rewrite/rules" -name "." -value @{
    name="$ruleName";
    patternSyntax='Regular Expressions';
     stopProcessing='True';
}

Set-WebConfigurationProperty -pspath $site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']/match" -name "." -value @{url='test.html';ignoreCase='True';} 
Set-WebConfigurationProperty -pspath $site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']/action" -name "." -value @{ type="Rewrite"; url='destination.html';} 