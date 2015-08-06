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
Function Send-SmtpEmail {
  # todo: add these variables to the config?
  $smtpFromEmail = "admin@washco.us"
  $smtpToRecipients = "dereknutile@hotmail.com"
  # $smtpCcRecipients = "email,email"
  # $Attachment = "C:\files\log.txt"
  $smtpSubject = "Service Flush Log"
  $Body = "Insert body text here"
  $SMTPServer = "smtp.gmail.com"
  $SMTPPort = "587"


  Send-MailMessage -From $smtpFromEmail -to $smtpToRecipient -Cc $smtpCcRecipients -Subject $smtpSubject `
  -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
  -Credential (Get-Credential) -Attachments $Attachment
}

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

Function Flush-AllServices {
  Stop-AllServices
  Start-AllServices
}

Function Stop-AllServices {
  Foreach ($service in $script:services){
    Write-ToLogFile "Stopping $($service) ..."
    Stop-Service $service
    Get-Service $service | ForEach-Object {
        Write-ToLogFile "Status: $($service) $($_.Status)"
    }
  }
}

Function Start-AllServices {
  Foreach ($service in $script:services){
    Write-ToLogFile "Starting $($service) ..."
    Start-Service $service
    Get-Service $service | ForEach-Object {
        Write-ToLogFile "Status: $($service) $($_.Status)"
    }
  }
}

Function Write-ToLogFile ([string]$entry) {
    Write-Verbose -Message $entry
    if($entry.length -gt 0) {
      Add-Content $script:logfile -value "$($(Get-Date).ToString('yyyy-MM-dd-HH-mm-ss')): $($entry)"
    } else {
      Add-Content $script:logfile -value ""
    }
}


<# -----------------------------------------------------------------------------
  The meat.
----------------------------------------------------------------------------- #>
Get-Configuration config.json
Write-ToLogFile "Starting script"
Flush-AllServices
Write-ToLogFile "Ending script"
Write-ToLogFile ""
