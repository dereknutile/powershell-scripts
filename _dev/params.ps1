<#
.DESCRIPTION
    Simple example of parsing command line paramters
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$filePath,
    
    [Parameter(Mandatory=$False)]

    [string]$computerName = $env:computerName
)

Write-Host $filePath
Write-Host $computerName