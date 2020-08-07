function Get-Body {
<#
.SYNOPSIS
    Outputs a Json string from input
.PARAMETER ENDPOINT
    RiskIQ endpoint
.PARAMETER DYNAMIC
    A runtime parameter dictionary to search for input values
#>
    [CmdletBinding()]
    [OutputType([string])]
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

            if ($Param.In -match 'body') {
                if ($Param.Name -eq 'body') {
                    if ($PSVersionTable.PSVersion.Major -ge 6) {
                        # Convert to bytes and upload in PowerShell 6+
                        $BodyInput = Get-Content $Item.Value -AsByteStream
                    } else {
                        # Convert to bytes and upload in PowerShell 5.1
                        $BodyInput = Get-Content $Item.Value -Encoding Byte -Raw
                    }
                }
                if (-not($BodyInput)) {
                    # Create output object
                    $BodyInput = @{ }
                }
                if ($Param.Parent -and $Param.Parent -ne 'array') {
                    if (-not($Parents)) {
                        # Create object to contain 'parents'
                        $Parents = @{ }
                    }
                    if (-not($Parents.($Param.Parent))) {
                        # Add table to parents
                        $Parents[$Param.Parent] = @{ }
                    }
                    # Add input to parent object
                    $Parents.($Param.Parent)[$Param.Name] = $Item.Value
                } else {
                    if ($Param.Parent -eq 'array') {
                        $Array = $true
                    }
                    if ($Item.Value -is [array] -and $Item.Value.count -eq 1) {
                        # Add single input to body output as a string
                        $BodyInput[$Param.Name] = $Item.Value[0]
                    } else {
                        # Add input(s) to body output
                        $BodyInput[$Param.Name] = $Item.Value
                    }
                }
            }
        }
        if ($Parents) {
            foreach ($Key in $Parents.Keys) {
                # Add value arrays with parents to body output
                $BodyInput[$Key] = @( $Parents.$Key )
            }
        }
        if ($BodyInput) {
            if ($Array -eq $true) {
                # Add result as an array
                @( $BodyInput )
            } else {
                # Output result
                $BodyInput
            }
        }
    }
}