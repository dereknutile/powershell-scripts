<# -----------------------------------------------------------------------------
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

    . ".\path\to\functions.ps1"
    if(Get-PowershellVersion -eq 2) { do stuff ... }
----------------------------------------------------------------------------- #>


<# -----------------------------------------------------------------------------
    Returns the Powershell major version - ex: 2 or 3, or 4, etc.
----------------------------------------------------------------------------- #>
Function Get-PowershellVersion {
    return $PSVersionTable.PSVersion.Major
}


<# -----------------------------------------------------------------------------
    Returns the contents of a configuration file in JSON format
----------------------------------------------------------------------------- #>
Function Get-Configuration ([string]$file) {
    $fileContents = (Get-Content $file) -join "`n"
    $config = ConvertFrom-Json $fileContents
    return $config
}


<# -----------------------------------------------------------------------------
    Returns the contents of a configuration file in INI format
----------------------------------------------------------------------------- #>
Function Get-IniFile ([string]$file) {
    Get-Content $file | foreach-object -begin {
        $config=@{}
    } -process {
        $k = [regex]::split($_,'=')
        if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) {
            $config.Add($k[0], $k[1])
        } 
    }
    return $config
}


<# -----------------------------------------------------------------------------
    Sends an email
----------------------------------------------------------------------------- #>
# NOTE: Non-functional!
# TODO: accept an array of variables from a config
Function Send-SmtpEmail {
    # Gather configuration
    $smtpFromEmail = "admin@domain.com"
    $smtpToRecipients = "recipient@domain.com"
    $smtpCcRecipients = "recipient2@domain.com,recipient3@domain.com"
    $Attachment = ".\path\to\attachment.txt"
    $smtpSubject = "Email Subject"
    $Body = "Content of email body."
    $SMTPServer = "smtp.domain.com"
    $SMTPPort = "587"

    # Send the email
    Send-MailMessage -From $smtpFromEmail -to $smtpToRecipient -Cc $smtpCcRecipients -Subject $smtpSubject `
    -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
    -Credential (Get-Credential) -Attachments $Attachment
}