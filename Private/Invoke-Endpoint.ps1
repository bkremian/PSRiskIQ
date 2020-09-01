function Invoke-Endpoint {
<#
.SYNOPSIS
    Makes a request to an API endpoint
.PARAMETER ENDPOINT
    RiskIQ endpoint
.PARAMETER HEADER
    Header key/value pair inputs
.PARAMETER QUERY
    An array of string values to append to the URI
.PARAMETER BODY
    Body string
.PARAMETER FORMDATA
    Formdata dictionary
.PARAMETER OUTFILE
    Path for file output
.PARAMETER PATH
    A modified 'path' value to use in place of the endpoint-defined string
#>
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 1)]
        [string] $Endpoint,

        [Parameter()]
        [hashtable] $Header,

        [Parameter()]
        [array] $Query,

        [Parameter()]
        [object] $Body,

        [Parameter()]
        [System.Collections.IDictionary] $Formdata,

        [Parameter()]
        [string] $Outfile,

        [Parameter()]
        [string] $Path
    )
    begin {
        # Set RiskIQ endpoint target
        $Target = $RiskIQ.Endpoint($Endpoint)

        # Define 'path' for request
        $FullPath = if ($Path) {
            "$($RiskIQ.Hostname)$($Path)"
        } else {
            "$($RiskIQ.Hostname)$($Target.Path)"
        }
        if ($Query) {
            # Add query items to UriPath
            $FullPath += "?$($Query -join '&')"
        }
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            # Add System.Net.Http
            Add-Type -AssemblyName System.Net.Http
        }
    }
    process {
        # Create Http request objects
        $Client = New-Object System.Net.Http.HttpClient
        $Method = New-Object System.Net.Http.HttpMethod($Target.Method)
        $Request = New-Object System.Net.Http.HttpRequestMessage($Method, $FullPath)

        # Add headers
        $Param = @{
            Endpoint = $Target
            Request = $Request
        }
        if ($Header) {
            $Param['Header'] = $Header
        }
        Format-Header @Param

        Write-Verbose ("[$($MyInvocation.MyCommand.Name)] $(($Target.Method).ToUpper())" +
        " $($RiskIQ.Hostname)$($Target.Path)")
        try {
            if ($Formdata) {
                # Add multipart content
                $MultiContent = New-Object System.Net.Http.MultipartFormDataContent

                foreach ($Key in $Formdata.Keys) {
                    if ((Test-Path $Formdata.$Key) -eq $true) {
                        # If file, read as bytes
                        $FileStream = [System.IO.File]::OpenRead($Formdata.$Key)
                        $Filename = [System.IO.Path]::GetFileName($Formdata.$Key)
                        $FileContent = New-Object System.Net.Http.StreamContent($FileStream)
                        $MultiContent.Add($FileContent, $Key, $Filename)
                    } else {
                        # Add as string
                        $StringContent = New-Object System.Net.Http.StringContent($Formdata.$Key)
                        $MultiContent.Add($StringContent, $Key)
                    }
                }
                $Request.Content = $MultiContent
            } elseif ($Body) {
                # Add body content
                $StringContent = New-Object System.Net.Http.StringContent($Body,
                    [System.Text.Encoding]::UTF8, ($Target.Headers.ContentType))
                $Request.Content = $StringContent
            }
            # Make request
            $Response = if ($Outfile) {
                foreach ($Pair in $Request.Headers.GetEnumerator()) {
                    # Add headers to HttpClient from HttpRequestMessage
                    $Client.DefaultRequestHeaders.Add($Pair.Key, $Pair.Value)
                }
                # Dispose of HttpRequestMessage
                $Request.Dispose()

                # Make direct request using HttpClient
                $Client.GetByteArrayAsync($FullPath)
            } else {
                # Make request using HttpRequestMessage
                $Client.SendAsync($Request)
            }
            if ($Response.Result -is [System.Byte[]]) {
                # Output response to file
                [System.IO.File]::WriteAllBytes($Outfile, ($Response.Result))
    
                if (Test-Path $Outfile) {
                    # Display successful output
                    Get-ChildItem $Outfile | Out-Host
                }
            } elseif ($Response.Result.IsSuccessStatusCode) {
                # Format output
                Format-Result $Response
            } elseif ($Response.Result) {
                # Output exception
                $Response.Result.EnsureSuccessStatusCode()
            } else {
                $Response
            }
        } catch {
            # Output error
            throw $_
        }
    }
    end {
        if ($Response) {
            # Dispose open HttpClient
            $Response.Dispose()
        }
    }
}