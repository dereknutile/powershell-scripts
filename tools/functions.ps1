<#
.SYNOPSIS
    Common utility functions.
.DESCRIPTION
    Included in this file are functions commonly used, re-written, copied and
    pasted and otherwise abused throughout other Powershell scripts.
.NOTES
    File Name      : functions.ps1
    Author         : Derek Nutile (dereknutile@gmail.com)
    Prerequisite   : PowerShell V2+
.LINK
    https://github.com/dereknutile/powershell-scripts
.EXAMPLE
    Include this file in your script, then you can call functions from it.

    . "C:\path\to\tools\functions.ps1"
    $version = Get-PowershellVersion
#>


<# -----------------------------------------------------------------------------
  Returns the Powershell major version - ex: 2 or 3, or 4, etc.
----------------------------------------------------------------------------- #>
Function Get-PowershellVersion {
    return $PSVersionTable.PSVersion.Major
}


Function Get-Configuration ([string]$configFile) {
    $result = 0
    $configFileRaw = (Get-Content $configFile) -join "`n"
    $config = ConvertFrom-Json $configFileRaw

    return $config
}


Function Test-Get-Configuration ([string]$configFile) {
    $result = 0

    $configFileRaw = (Get-Content $configFile) -join "`n"
    $config = ConvertFrom-Json $configFileRaw

    # set $script:logfile
    if($config.logfile) {
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

    if($result -ne 2) {
        Write-Verbose -Message "There is an error in the configuration file."
        exit
    }
}


Function Var-Dump ($var) {
    Write-Host ($var | Format-Table | Out-String)
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