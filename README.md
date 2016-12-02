# Powershell Scripts

Overview
--------
List of assorted PowerShell scripts.


Script List
-----------
* [Windows Service Flush](#service-flush)


Script Details
----------------------------
#### [Windows Service Flush](id:windows-service-flush)
##### 2015 July

Parses a configuration file (`config.json`) and restarts a list of services and
logs activity to a log file.  Optionally sends email to recipients in config.

    $ .\run.ps1 -verbose

If the client is running powerShell version 2 or lower, or does not have the .net v4 w/system.web.extensions, you must run the legacy version of the script.

    $ .\run-legacy -verbose

``` service, email, log, json ```
