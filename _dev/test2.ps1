param ($ComputerName = $(throw "ComputerName parameter is required."))  

 param (
    [string]$server = "http://defaultserver",
    [Parameter(Mandatory=$true)][string]$username,
    [string]$password = $( Read-Host "Input password, please" )
 )

 write-output $server