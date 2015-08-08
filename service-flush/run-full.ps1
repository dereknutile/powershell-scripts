<#
.SYNOPSIS
    Automated service restarter.
.DESCRIPTION
    Reads config.json then stops, starts, logs, and emails the status of a list
    of services.  Note that the config file needs to be named 'config.json' and
    there needs to be a value for the logfile and the services array needs to
    contain at least one element.

    This has the same functionality as the run.ps1 file but does not read a json
    file (due to lack of support in Powershell v2).
.NOTES
    File Name      : run-full.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V2+
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    powershell.exe .\run-full.ps1
.EXAMPLE
    Provide output to the console.
    powershell.exe .\run-full.ps1 -verbose
#>


<# -----------------------------------------------------------------------------
  Needed to accept the '-Verbose' switch.
----------------------------------------------------------------------------- #>
[CmdletBinding()]
Param()


<# -----------------------------------------------------------------------------
  Preset variables in the script scope.
----------------------------------------------------------------------------- #>
$script:services = @()
$script:logfile = ""


<# -----------------------------------------------------------------------------
  Script functions
----------------------------------------------------------------------------- #>
Function Get-PowershellVersion {
  return $PSVersionTable.PSVersion.Major
}


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
Write-ToLogFile "Starting script"
Flush-AllServices
Write-ToLogFile "Ending script"
Write-ToLogFile ""
