function Get-Header {
<#
.SYNOPSIS
    Outputs a hashtable of header values from input
.PARAMETER ENDPOINT
    RiskIQ endpoint
.PARAMETER DYNAMIC
    A runtime parameter dictionary to search for input values
#>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 1)]
        [object] $Endpoint,

        [Parameter(
            Mandatory = $true,
            Position = 2)]
        [System.Collections.ArrayList] $Dynamic
    )
    process {
        foreach ($Item in ($Dynamic.Values | Where-Object IsSet)) {
            # Match input parameter with endpoint
            $Param = $Endpoint.Parameters | Where-Object Dynamic -eq $Item.Name

            if ($Param.In -match 'header') {
                if (-not($Header)) {
                    $Header = @{ }
                }
                # Add header key/value to output
                $Header[$Param.Name] = $Item.Value
            }
        }
        if ($Header) {
            # Output result
            Write-Debug ("[$($MyInvocation.MyCommand.Name)] $(ConvertTo-Json $Header)")
            $Header
        }
    }
}