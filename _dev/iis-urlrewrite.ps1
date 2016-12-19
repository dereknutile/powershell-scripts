$site = "iis:\sites\Default Web Site"
$ruleName = "This is a test"

Add-WebConfigurationProperty -pspath $site -filter "system.webServer/rewrite/rules" -name "." -value @{
    name='This is a test';
    patternSyntax='Regular Expressions';
     stopProcessing='True';
}

Set-WebConfigurationProperty -pspath $site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']/match" -name "." -value @{url='test.html';ignoreCase='True';} 
Set-WebConfigurationProperty -pspath $site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']/action" -name "." -value @{ type="Rewrite"; url='destination.html';} 