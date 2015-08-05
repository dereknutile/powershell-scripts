<#
.SYNOPSIS
    Automated service restarter.
.DESCRIPTION
    Reads config.json and stops, starts, logs, and emails the status of a list
    of services.  Note that the config file needs to be named 'config.json' and
    there needs to be a value for the logfile and the services array needs to
    contain one element.
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
$services = @()
$logfile = ""


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

Function Get-Config ([string]$configFile) {
  $result = 0
  $config = Get-Content $configFile -Raw | ConvertFrom-Json

  if($config.logfile){
    $result++
    $LogFile = $config.logfile
  }

  # Gather services
  if($config.services.count -ge 0) {
    $result++
    foreach($val in $config.services) {
      $services += $val
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
    Add-Content $LogFile -value $entry
}


Get-Config config.json

<# -----------------------------------------------------------------------------
  The meat.
----------------------------------------------------------------------------- #>
# Write-ToLogFile "----- Start Flush: $(Get-Date) -----"

# Write-Verbose -Message "Stopping $($service)..."
# Stop-Service $service
# Get-Service $service | ForEach-Object {
#     Write-Verbose -Message "Status: $($_.Status)"
# }

# Write-Verbose -Message "Starting $($service)..."
# Start-Service $service
# Get-Service $service | ForEach-Object {
#     Write-Verbose -Message "Status: $($_.Status)"
# }

# Write-ToLogFile "----- End Flush: $(Get-Date) -----"
