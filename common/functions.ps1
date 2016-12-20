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


Function Read-IniFile ([string]$iniFile) {
    Get-Content $iniFile | foreach-object -begin {
        $setting=@{}
    } -process {
        $k = [regex]::split($_,'=')
        if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) {
            $setting.Add($k[0], $k[1])
        } 
    }
    return $setting
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