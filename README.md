# Powershell Scripts

## Overview

List of assorted PowerShell scripts.  The main purpose of this repository is to create a library of PowerShell tools that can be reused in my Windows environment.  Secondary purposes are both learning PowerShell and establishing a convention for creating easy to follow PowerShell code.

## Structure

All directories in this repository are individual modules.  Those modules are mainly self contained if the `.\_common` folder is included with them. except for the following:

### ```.\_dev```
Development scripts for learning and trail-testing.  Each script should use a name that eases the understanding the functionality of that script.  All scripts should contain details of the script in the header of the ps1 file.

### ```.\_common```
This is where all common reusable code and data should be kept.

## Modules

* [IIS Rewrite Rules](#iis-rewrite-rules)
* [Log Ripper](#log-ripper)
* [Log Roller](#log-roller)
* [Service Flush](#service-flush)

-----
### [IIS Rewrite Rules](id:iis-rewrite-rules)

Tags: ``` iis-rewrite-rules ```
Purpose: Reads a csv file with IIS rules, applies those rules to supplied server and website.

### [Log Ripper](id:log-ripper)

Tags: ``` log-ripper ```
Purpose: Reads config.json to gather an array of attributes to search for, then opens a log file and reads it line-by-line writing out only the matching criteria to an output file.

### [Log Roller](id:log-roller)

Tags: ``` log-roller ```
Purpose: Reads config.json to get the target directory where log files would be kept as well as the value for how many days back to start removing items.

### [Service Flush](id:service-flush)

Tags: ``` service-flush, service, log, json ```
Purpose: Parses a configuration file (`config.json`) and restarts a list of services and logs activity to a log file.
