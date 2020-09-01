function Format-Header {
<#
.SYNOPSIS
    Outputs a header for use with Invoke-Endpoint
.PARAMETER ENDPOINT
    RiskIQ endpoint
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
        [object] $Endpoint,

        [Parameter(
            Mandatory = $true,
            Position = 2)]
        [object] $Request,

        [Parameter(Position = 3)]
        [hashtable] $Header
    )
    begin {
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
    }
    process {
        if ($Endpoint.Headers) {
            foreach ($Name in ($Endpoint.Headers | Get-Member -MemberType NoteProperty).Name) {
                # Add headers from endpoint
                $Request.Headers.Add($Name,($Endpoint.Headers.$Name))
            }
        }
        if ($Header) {
            foreach ($Pair in $Header.GetEnumerator()) {
                # Add headers from input
                $Request.Headers.Add($Pair.Key, $Pair.Value)
            }
        }
        if ($Authorization) {
            # Add authorization
            $Request.Headers.Add('Authorization', $Authorization)
        }
    }
}