<#
.SYNOPSIS
    Automated service restarter.
.DESCRIPTION
    Reads config.json then stops, starts, logs, and emails the status of a list
    of services.  Note that the config file needs to be named 'config.json' and
    there needs to be a value for the logfile and the services array needs to
    contain at least one element.
.NOTES
    File Name      : run.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V2+
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run.ps1 -verbose
#>


<# -----------------------------------------------------------------------------
  Needed to accept the '-Verbose' switch.
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
  Preset variables in the script scope.
----------------------------------------------------------------------------- #>
$now = Get-Date
$script:services = @()
$script:logfile = ""


<# -----------------------------------------------------------------------------
  Script functions
----------------------------------------------------------------------------- #>
# Usage: Send-Email $SmtpClientHost $MailMessageFrom $MailMessageTo $MailMessageSubject $Body
# function Send-Email ([string]$hostName, [string]$fromEmail, [string]$toEmail, [string]$subject, [string]$body) {
#     $SmtpClient = New-Object system.Net.Mail.SmtpClient($hostName)
#     $MailMessage = New-Object system.Net.Mail.MailMessage($fromEmail, $toEmail, $subject, $body)
#     $SmtpClient.UseDefaultCredentials = 'True'
#     $SmtpClient.Send($MailMessage)
# }

Function Get-Configuration ([string]$configFile) {
  $result = 0
  $config = Get-Content $configFile -Raw | ConvertFrom-Json

  # set $script:logfile
  if($config.logfile){
    $result++
    $script:logfile = $config.logfile
  }

  # set $script:services
  if($config.services.count -ge 0) {
    $result++
    foreach($val in $config.services) {
      $script:services += $val
      # Write-Host $val
    }
  }

  if($result -ne 2){
    Write-Verbose -Message "There is an error in the configuration file."
    exit
  }
}

Function Write-ToLogFile ([string]$entry) {
    Write-Verbose -Message $entry
    Add-Content $script:logfile -value $entry
}


<# -----------------------------------------------------------------------------
  The meat.
----------------------------------------------------------------------------- #>
Get-Configuration config.json
Write-ToLogFile "----- Starting script: $(Get-Date) -----"

Foreach ($service in $script:services){

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
}

Write-ToLogFile "----- Ending script: $(Get-Date) -----"
