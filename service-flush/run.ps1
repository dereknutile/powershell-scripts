# Variables
$now = Get-Date
$service = "AdobeARMservice"
$LogFile = "logfile.log"

# Functions
function Send-Email ([string]$hostName, [string]$fromEmail, [string]$toEmail, [string]$subject, [string]$body) {
    $SmtpClient = New-Object system.Net.Mail.SmtpClient($hostName)
    $MailMessage = New-Object system.Net.Mail.MailMessage($fromEmail, $toEmail, $subject, $body)
    $SmtpClient.UseDefaultCredentials = 'True'
    $SmtpClient.Send($MailMessage)
}

Function Write-Log ([string]$entry) {
   Add-Content $LogFile -value $entry
}

Write-Log "----- Start Flush: $(Get-Date) -----"

Write-Host "Stopping $($service)..."
Stop-Service $service
Get-Service $service | ForEach-Object {
    Write-Host "Status: $($_.Status)"
}

Write-Host "Starting $($service)..."
Start-Service $service
Get-Service $service | ForEach-Object {
    Write-Host "Status: $($_.Status)"
}

Send-Email $SmtpClientHost $MailMessageFrom $MailMessageTo $MailMessageSubject $Body

Write-Log "----- End Flush: $(Get-Date) -----"

