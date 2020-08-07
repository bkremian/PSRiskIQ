function Format-Header {
<#
.SYNOPSIS
    Outputs a header for use with Invoke-Endpoint
.PARAMETER ENDPOINT
    RiskIQ endpoint name
.PARAMETER REQUEST
    Request object
.PARAMETER HEADER
    Additional header values to add from input
#>
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 1)]
        [string] $Endpoint,

        [Parameter(
            Mandatory = $true,
            Position = 2)]
        [object] $Request,

        [Parameter(Position = 3)]
        [hashtable] $Header
    )
    begin {
        # Set RiskIQ endpoint target
        $Target = $RiskIQ.Endpoint($Endpoint)

        # Set Id/Username, if not present
        if (-not($RiskIQ.Id)) {
            $RiskIQ.Id = Read-Host "Id"
        }
        # Set Secret/Password, if not present
        if (-not($RiskIQ.Secret)) {
            $RiskIQ.Secret = Read-Host "Secret" -AsSecureString
        }
        # Set authorization value
        $Authorization = Get-AuthPair

        function Add-Authorization {
            # Add authorization to header
            if ($Request -is [System.Net.Http.HttpClient]) {
                $Request.DefaultRequestHeaders.Add('Authorization', $Authorization)
            } else {
                $Request.Headers.Add('Authorization', $Authorization)
            }
        }
        function Add-Header {
            # Add inputs to header
            if ($Request -is [System.Net.Http.HttpClient]) {
                foreach ($Pair in $Header.GetEnumerator()) {
                    $Request.DefaultRequestHeaders.Add($Pair.Key, $Pair.Value)
                }
            } else {
                foreach ($Pair in $Header.GetEnumerator()) {
                    $Request.Headers.Add($Pair.Key, $Pair.Value)
                }
            }
        }
    }
    process {
        if ($Request -is [System.Net.WebClient]) {
            if ($Target.Headers) {
                foreach ($Name in ($Target.Headers | Get-Member -MemberType NoteProperty).Name) {
                    # Add header values from endpoint for file downloads
                    $Request.Headers.Add($Name,$Target.Headers.$Name)
                }
            }
        } elseif ($Request -is [System.Net.Http.HttpClient]) {
            if ($Target.Headers) {
                foreach ($Name in ($Target.Headers | Get-Member -MemberType NoteProperty).Name) {
                    # Add header values from endpoint for file uploads
                    $Request.DefaultRequestHeaders.Add($Name,$Target.Headers.$Name)
                }
            }
        } elseif ($Target.Headers) {
            switch (($Target.Headers | Get-Member -MemberType NoteProperty).Name) {
                # Add header values from endpoint
                'Accept' {
                    $Request.Accept = $Target.Headers.$_
                }
                'ContentType' {
                    $Request.ContentType = $Target.Headers.$_
                }
                default {
                    $Request.Headers.Add($_, $Target.Headers.$_)
                }
            }
        }
        # Add authorization to header
        Add-Authorization

        if ($Header) {
            # Add inputs to header
            Add-Header $Header
        }
        @($Request.DefaultRequestHeaders, $Request.Headers) | ForEach-Object {
            if ($_) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] $($_ -join ', ')"
            }
        }
    }
}