# Installation
You can clone this repository to manually import PSRiskIQ, or install from the **[PowerShell Gallery](https://www.powershellgallery.com/packages/PSRiskIQ)**:\
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

  -Type [String] <ip, wildcard, email, domain, component, hash_md5, hash_sha1, hash_sha256,
      cookies_name, cookies_domain, url, certificate_serialnumber, certificate_sha1,
      certificate_issuercommonname, certificate_issueralternativename,
      certificate_subjectcommonname, certificate_subjectalternativename,
      certificate_issuerorganizationname, certificate_subjectorganizationname,
      certificate_issuerorganizationunit, certificate_subjectorganizationunit,
      certificate_issuerstreetaddress, certificate_subjectstreetaddress,
      certificate_issuerlocalityname, certificate_subjectlocalityname,
      certificate_issuerstateorprovincename, certificate_subjectstateorprovincename,
      certificate_issuercountry, certificate_subjectcountry, certificate_issuerserialnumber,
      certificate_subjectserialnumber>
    Artifact type
```

Create artifacts in bulk
```
  -Array [Array] (Required)
    An array of hashtables matching artifact fields (project id, query, type, tags)
```

**Remove-RiskArtifact**:\

Delete an artifact
```
  -ArtifactId [String] (Required)
    Artifact identifier
```

Delete artifacts in bulk
```
  -ArtifactIds [Array] (Required)
    One or more artifact identifiers
```

**Update-RiskArtifact**:\
Update artifact or toggle monitoring status
```
  -ArtifactId [String] (Required)
    Artifact identifier

  -Monitor [Boolean]
    Monitor status

  -Tags [Array]
    One or more tags to set
```

Update artifacts in bulk
```
  -Array [Array] (Required)
    An array of hashtables matching artifact fields (artifact id, monitor, tags)
```

### Attributes
**Get-RiskComponents**:\
Retrieves the host attribute components of a query
```
  -Query [String] (Required)
    Domain or IPv4 address

  -EndDate [String]
    End date and time

  -Page [Int32]
    Position when paging through results

  -StartDate [String]
    Start date and time
```

**Get-RiskHostPairs**:\
Retrieves host attribute pairs for a Domain or IPv4 address
```
  -Direction [String] (Required) <children, parents>
    Direction of target results

  -Query [String] (Required)
    Domain or IPv4 address

  -EndDate [String]
    End date and time

  -Page [Int32]
    Position when paging through results

  -StartDate [String]
    Start date and time
```

**Get-RiskTrackers**:\
Retrieves host attribute trackers for a domain or IPv4 address
```
  -Query [String] (Required)
    Domain or IPv4 address

  -EndDate [String]
    End date and time

  -Page [Int32]
    Position when paging through results

  -StartDate [String]
    Start date and time
```

### Enrichment
**Get-RiskEnrichment**:\
Get bulk enrichment data
```
  -Query [Array] (Required)
    One or more domains or IPv4 addresses
```

**Get-RiskMalware**:\
Get bulk malware data
```
  -Query [Array] (Required)
    One or more domains or IPv4 addresses
```

**Get-RiskOSINT**:\
Get bulk OSINT Data
```
  -Query [Array] (Required)
    One or more domains or IPv4 addresses
```

### Monitor
**Get-RiskAlerts**:\
Retrieve all alerts associated with an artifact or project
```
  -ArtifactId [String]
    Artifact identifier

  -EndDate [String]
    Restrict results to before a certain date and time

  -Page [Int32]
    Position when paging through results

  -ProjectId [String]
    Project identifier

  -Size [Int32]
    Maximum number of results to return [default: 25]

  -StartDate [String]
    Restrict results to after a certain date and time
```

### Projects
**Add-RiskProjectTags**:\
Add project tags
```
  -ProjectId [String] (Required)
    Project identifier

  -Tags [Array] (Required)
    One or more tags to add
```

**Get-RiskProject**:\
Retrieves a project or projects by search filter
```
  -Creator [String]
    Filter by creator email

  -Featured [Boolean]
    Filter by featured status

  -Organization [String]
    Filter by organization

  -Owner [String]
    Filter by owner (email or organization)

  -ProjectId [String]
    Project identifier

  -Visibility [String] <public, private, analyst>
    Filter by visibility
```

**New-RiskProject**:\
Create a new project
```
  -Name [String] (Required)
    Project name

  -Visibility [String] (Required) <public, private, analyst>
    Project visibility [public, private, analyst]

  -Description [String]
    Project description

  -Featured [Boolean]
    Whether to feature the project

  -Tags [Array]
    One or more tags
```

**Remove-RiskProject**:\
Delete a project
```
  -ProjectId [String] (Required)
    Project identifier
```

**Remove-RiskProjectTags**:\
Remove project tags
```
  -ProjectId [String] (Required)
    Project identifier

  -Tags [Array] (Required)
    One or more project tags to remove
```

**Set-RiskProjectTags**:\
Set project tags
```
  -ProjectId [String] (Required)
    Project identifier

  -Tags [Array] (Required)
    One or more tags to set
```

**Update-RiskProject**:\
  Update a project
```
  -ProjectId [String] (Required)
    Project identifier

  -Description [String]
    Project description

  -Featured [Boolean]
    Whether to feature the project

  -Name [String]
    Project name

  -Tags [Array]
    Project tags

  -Visibility [String] <public, private, analyst>
    Project visibility
```

### Services
**Get-RiskServices**:\
List exposed services for an IPv4 address
```
  -IP [String] (Required)
    IPv4 address
```

### SSL Certificates
**Get-RiskCertificate**:\
Retrieves an SSL certificate by its SHA-1 hash
```
  -SHA1 [String] (Required)
    SHA-1 hash of the certificate to retrieve
```

Retrieves the SSL certificate history for a given certificate SHA-1 hash or IPv4 address
```
  -History [SwitchParameter] (Required)

  -Query [String] (Required)
    SHA-1 hash or associated IPv4 address for which to retrieve certificate history
```

Retrieves SSL certificates for a given field value
```
  -FieldName [String] (Required) <issuerSurname, subjectOrganizationName, issuerCountry,
      issuerOrganizationUnitName, fingerprint, subjectOrganizationUnitName, serialNumber,
      subjectEmailAddress, subjectCountry, issuerGivenName, subjectCommonName, issuerCommonName,
      issuerStateOrProvinceName, issuerProvince, subjectStateOrProvinceName, sha1,
      subjectStreetAddress, subjectSerialNumber, issuerOrganizationName, subjectSurname,
      subjectLocalityName, issuerStreetAddress, issuerLocalityName, subjectGivenName, subjectProvince,
      issuerSerialNumber, issuerEmailAddress>
    Search field

  -FieldValue [String] (Required)
    Search value
```

Retrieves SSL certificates for a given keyword
```
  -Keyword [String] (Required)
    Search keyword
```

### WHOIS
**Get-RiskWhois**:\
Retrieve WHOIS data for a domain
```
  -Domain [String] (Required)
    Domain

  -CompactRecord [Boolean]
    Compress the results

  -History [Boolean]
    Return historical results
```

Search WHOIS data by field and value
```
  -FieldName [String] (Required) <email, domain, name, organization, address, phone, nameserver>
    The type of field to query

  -FieldValue [String] (Required)
    The value to query
```

Search WHOIS data by keyword
```
  -Keyword [String] (Required)
    The keyword to query
```