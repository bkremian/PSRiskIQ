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
        [string] $Body,

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
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            # Add System.Net.Http
            Add-Type -AssemblyName System.Net.Http
        }
    }
    process {
        if ($Query) {
            # Add query items to UriPath
            $FullPath += "?$($Query -join '&')"
            Write-Debug ("[$($MyInvocation.MyCommand.Name)] $($Query -join '&')")
        }
        if ($Outfile) {
            # Create WebClient object
            $Request = New-Object System.Net.WebClient

            # Add headers and authorization to request
            $Param = @{
                Endpoint = $Endpoint
                Request = $Request
            }
            if ($Header) {
                $Param['Header'] = $Header
            }
            Format-Header @Param

            Write-Verbose ("[$($MyInvocation.MyCommand.Name)] $(($Target.Method).ToUpper())" +
            " $($RiskIQ.Hostname)$($Target.Path)")

            # Make request
            $Request.DownloadFile($FullPath, $Outfile)
        } elseif ($Formdata) {
            # Create HttpClient and MultipartFormData objects
            $Request = New-Object System.Net.Http.HttpClient
            $FormContent = New-Object System.Net.Http.MultipartFormDataContent

            # Add headers and authorization to request
            $Param = @{
                Endpoint = $Endpoint
                Request = $Request
            }
            if ($Header) {
                $Param['Header'] = $Header
            }
            Format-Header @Param

            foreach ($Key in $Formdata.Keys) {
                if ((Test-Path $Formdata.$Key) -eq $true) {
                    # Add file content
                    $FileStream = [System.IO.File]::OpenRead($Formdata.$Key)
                    $Filename = [System.IO.Path]::GetFileName($Formdata.$Key)
                    $FileContent = New-Object System.Net.Http.StreamContent($FileStream)
                    $FormContent.Add($FileContent, $Key, $Filename)
                } else {
                    # Add other content
                    $StringContent = New-Object System.Net.Http.StringContent $Formdata.$Key
                    $FormContent.Add($StringContent, $Key)
                }
            }
            Write-Verbose ("[$($MyInvocation.MyCommand.Name)] $(($Target.Method).ToUpper())" +
                " $($RiskIQ.Hostname)$($Target.Path)")

            # Make request and output result code
            $Request.PostAsync($FullPath, $FormContent).Result.StatusCode
        } else {
            # Create WebRequest object
            $Request = [System.Net.WebRequest]::Create($FullPath)
            $Request.Method = $Target.Method

            # Add headers and authorization to request
            $Param = @{
                Endpoint = $Endpoint
                Request = $Request
            }
            if ($Header) {
                $Param['Header'] = $Header
            }
            Format-Header @Param

            if ($Body) {
                # Add body to request
                if ($Body -is [string]) {
                    $RequestStream = $Request.GetRequestStream()
                    $StreamWriter = [System.IO.StreamWriter]($RequestStream)
                    $StreamWriter.Write($Body)
                    $StreamWriter.Flush()
                    $StreamWriter.Close()
                } else {
                    $Request.ContentLength = $Body.Length
                    $RequestStream = $Request.GetRequestStream()
                    $RequestStream.Write($Body, 0, $Body.Length)
                }
            }
            Write-Verbose ("[$($MyInvocation.MyCommand.Name)] $(($Target.Method).ToUpper())" +
            " $($RiskIQ.Hostname)$($Target.Path)")

            try {
                # Make request
                $Response = $Request.GetResponse()
            } catch {
                $_
            }
            if ($Response) {
                # Capture response
                $ResponseStream = $Response.GetResponseStream()
                $StreamReader = [System.IO.StreamReader]($ResponseStream)

                # Output formatted result
                ConvertFrom-Json $StreamReader.ReadToEnd()
            }
        }
    }
    end {
        # Close open streams
        @($FileContent, $FileStream, $ResponseStream, $StreamReader, $StreamWriter) |
            ForEach-Object {
            if ($null -ne $_) {
                $_.Dispose()
            }
        }
    }
}