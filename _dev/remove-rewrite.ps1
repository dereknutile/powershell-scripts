$site = "iis:\sites\Default Web Site"
$ruleName = "This is a test"

Clear-WebConfiguration -pspath $site -filter "/system.webserver/rewrite/rules/rule[@name='$ruleName']"
