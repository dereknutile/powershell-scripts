$serviceName = "Spooler"

write-output "Restarting $serviceName Service ..."

Get-Service | Where {$_.Name -Match $serviceName}

Get-Service $serviceName | Stop-Service -Force
Get-Service | Where {$_.Name -Match $serviceName}

Get-Service $serviceName | Start-Service
Get-Service | Where {$_.Name -Match $serviceName}
