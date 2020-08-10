# Installation
You can clone this repository to manually import PSRiskIQ, or install from the PowerShell Gallery:
`PS> Install-Module -Name PSRiskIQ`

## Requirements
Requires **[PowerShell 5.1+](https://github.com/PowerShell/PowerShell#get-powershell)**

# Credentials
In order to interact with the RiskIQ APIs, you need a valid **[API Key and Secret](https://community.riskiq.com/settings)**.
If you have previously exported your credentials into `$Home\RiskIQ.cred`, they will be automatically imported
when you import the PSRiskIQ module from the `$Home` directory.

## Exporting Credentials
You can save your credentials using the `ExportCred()` method, which will prompt you for your Key (username)
and Secret (password). Once input, the credentials will be exported to `$Home\RiskIQ.cred`.

This exported file is designed to be used only by the user that created it, on the device that it was created on.
Attemping to copy this file to a different device or importing it into PSRiskIQ under a different user account
will fail. **[Learn more about encrypted credentials here](https://adamtheautomator.com/powershell-export-xml/#Saving_an_Encrypted_Credential)**.

```powershell
PS> $RiskIQ.ExportCred()
```
**WARNING**: This exported file is encrypted on Windows, but it is not encrypted on MacOS or Linux. Credential
handling in PSRiskIQ is provided for convenience and not security.

## Importing Credentials
You can rename these files to save different credential sets and import them using the `.ImportCred()`
method. When importing credentials you only need to specify the name of the file, as it will be imported from
the local path and default to using the `.cred` extension.

```powershell
PS> $RiskIQ.ImportCred('Example')
Imported Example.cred
```

# Usage
You can list all available commands through `Get-Module -Name PSRiskIQ` once the module has
been imported. Using the `-Help` parameter with any command will show the available parameters and
a brief description.

## Commands
The commands in PSRiskIQ generally map to the [API documentation](https://api.passivetotal.org/index.html):

### Account
**Get-RiskAccount**:\
List current account metadata and settings

**Get-RiskHistory**:\
List API usage history

```
-Source [String] <api, ui>
    History source [api, ui]
```

### Project

### Artifact

### Monitor

### Actions

### Enrichment

### Trackers

### WHOIS

### Host Attributes

### Passive DNS

### SSL Certificates