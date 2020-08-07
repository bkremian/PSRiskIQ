function Get-Outfile {
<#
.SYNOPSIS
    Outputs a string from 'outfile' input
.PARAMETER ENDPOINT
    RiskIQ endpoint
.PARAMETER DYNAMIC
    A runtime parameter dictionary to search for input values
#>
    [CmdletBinding()]
    [OutputType([array])]
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

            if ($Param.In -match 'outfile') {
                if ($Item.Value -match '^\.') {
                    # Output value, converting relative path to absolute path
                    $Item.Value -replace '^\.', $pwd
                } else {
                    # Output value
                    $Item.Value
                }
            }
        }
    }
}