# Installation
You can clone this repository to manually import PSRiskIQ, or install from the PowerShell Gallery:\
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

**Get-RiskOrganization**:\
List organization metadata

**Get-RiskQuota**:\
List current account and organization quotas

**Get-RiskSources**:\
List sources being used for queries
```
  -Source [String]
    Source filter
```

**Get-RiskTeamstream**:\
List team activity
```
  -DateTime [String]
    Datetime filter

  -Focus [String]
    Focus filter (domain, ip, etc)

  -Source [String]
    Source filter

  -Type [String]
    Type filter
```

### Actions
**Add-RiskTags**:\
Add tags to an artifact
```
  -Artifact [String] (Required)
    Artifact

  -Tags [Array] (Required)
    One or more tags to add
```

**Get-RiskClassification**:\
Retrieve items with the specified classification
```
  -Type [String] <malicious, suspicious, non_malicious, unknown>
    Classification type
```

Retrieve classification status for a given domain
```
  -Domain [String] (Required)
    Domain
```

Retrieve classification status for multiple domains
```
  -Domains [Array] (Required)
    Domains
```

**Get-RiskCompromise**:\
Indicates whether or not a given domain has ever been compromised
```
  -Domain [String] (Required)
    Domain
```

**Get-RiskDDNS**:\
Indicates whether or not a domain's DNS records are updated via dynamic DNS
```
  -Domain [String] (Required)
    Domain
```

**Get-RiskMonitor**:\
Indicates whether or not a domain is monitored
```
  -Domain [String] (Required)
    Domain
```

**Get-RiskSinkhole**:\
Indicates whether or not an IPv4 address is a sinkhole
```
  -IPv4 [String] (Required)
    IPv4 address to check for sinkhole status
```

**Get-RiskTags**:\
List tags associated with an artifact
```
  -Artifact [String] (Required)
    Artifact
```

List artifacts associated with a tag
```
  -Tag [String] (Required)
    Tag
```

**Remove-RiskTags**:\
Removes tags from an artifact
```
  -Artifact [String] (Required)
    Artifact

  -Tags [Array] (Required)
    One or more tags to remove
```

**Set-RiskClassification**:\
Sets the classification status for a given domain
```
  -Classification [String] (Required) <malicious, suspicious, non_malicious, unknown>
    Classification status

  -Domain [String] (Required)
    Domain
```

**Set-RiskCompromise**:\
Sets status for a domain to indicate if it has ever been compromised
```
  -Domain [String] (Required)
    Domain

  -Status [Boolean] (Required)
    Compromise status
```

**Set-RiskDDNS**:\
Sets a domain's status to indicate whether or not its DNS records are updated via dynamic DNS
```
  -Domain [String] (Required)
    domain for which to set dynamic DNS status

  -Status [Boolean] (Required)
    Dynamic DNS status
```

**Set-RiskSinkhole**:\
Sets status for an IPv4 address to indicate whether or not it is a sinkhole
```
  -IPv4 [String] (Required)
    IPv4 address for which to set sinkhole status

  -Status [Boolean] (Required)
    Sinkhole status
```

**Set-RiskTags**:\
Sets the tags for a given artifact
```
  -Artifact [String] (Required)
    Artifact

  -Tags [Array] (Required)
    One or more tags to set
```

### Artifacts
**Get-RiskArtifact**:\
Find existing artifacts
```
  -ArtifactId [String]
    Artifact identifier

  -Creator [String]
    Filter by creator

  -Organization [String]
    Filter by organization

  -Owner [String]
    Filter by owner (email address or organization)

  -ProjectId [String]
    Project identifier

  -Query [String]
    Filter by query (passivetotal.org, etc)

  -Type [String]
    Filter by artifact type (domain, ip, etc)
```

**New-RiskArtifact**:\
Create an artifact
```
  -ProjectId [String] (Required)
    Project identifier

  -Query [String] (Required)
    Artifact value

  -Tags [Array]
    One or more tags to assign to the artifact

  -Type [String] <ip, wildcard, email, domain, component, hash_md5, hash_sha1, hash_sha256, cookies_name, cookies_domain, url, certificate_serialnumber, certificate_sha1, certificate_issuercommonname, certificate_issueralternativename, certificate_subjectcommonname, certificate_subjectalternativename, certificate_issuerorganizationname, certificate_subjectorganizationname, certificate_issuerorganizationunit, certificate_subjectorganizationunit, certificate_issuerstreetaddress, certificate_subjectstreetaddress, certificate_issuerlocalityname, certificate_subjectlocalityname, certificate_issuerstateorprovincename, certificate_subjectstateorprovincename, certificate_issuercountry, certificate_subjectcountry, certificate_issuerserialnumber, certificate_subjectserialnumber>
    Artifact type

  Create artifacts in bulk

  -Array [Array] (Required)
    An array of hashtables matching artifact fields (project id, query, type, tags)
```

**Remove-RiskArtifact**:\
**Update-RiskArtifact**:\

### Attributes
**Get-RiskComponents**:\
**Get-RiskHostPairs**:\
**Get-RiskTrackers**:\

### Enrichment
**Get-RiskEnrichment**:\
**Get-RiskMalware**:\
**Get-RiskOSInt**:\

### Monitor
**Get-RiskAlerts**:\

### Projects
**Add-RiskProjectTags**:\
**Get-RiskProject**:\
**New-RiskProject**:\
**Remove-RiskProject**:\
**Remove-RiskProjectTags**:\
**Set-RiskProjectTags**:\
**Update-RiskProject**:\

### Services
**Get-RiskServices**:\

### SSL Certificates
**Get-RiskCertificate**:\

### WHOIS
**Get-RiskWhois**:\