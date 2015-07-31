<#
.SYNOPSIS
    Automated service restarter.
.DESCRIPTION
    Reads config.json and stops, starts, logs, and emails the status of a list
    of services.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V3
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 -verbose
#>

# Needed to accept the -Verbose switch
[CmdletBinding()]
Param()

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

Function Write-ToLog ([string]$entry) {
    Write-Verbose -Message $entry
    Add-Content $LogFile -value $entry
}

Write-ToLog "----- Start Flush: $(Get-Date) -----"

Write-Verbose -Message "Stopping $($service)..."
Stop-Service $service
Get-Service $service | ForEach-Object {
    Write-Verbose -Message "Status: $($_.Status)"
}

Write-Verbose -Message "Starting $($service)..."
Start-Service $service
Get-Service $service | ForEach-Object {
    Write-Verbose -Message "Status: $($_.Status)"
}

# Send-Email $SmtpClientHost $MailMessageFrom $MailMessageTo $MailMessageSubject $Body

Write-ToLog "----- End Flush: $(Get-Date) -----"

