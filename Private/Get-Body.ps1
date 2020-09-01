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
    [OutputType()]
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
                    # Capture filename for debug output
                    $Filename = $Item.Value

                    if ($PSVersionTable.PSVersion.Major -ge 6) {
                        # Convert to bytes and upload in PowerShell 6+
                        $ByteOutput = Get-Content $Item.Value -AsByteStream
                    } else {
                        # Convert to bytes and upload in PowerShell 5.1
                        $ByteOutput = Get-Content $Item.Value -Encoding Byte -Raw
                    }
                } else {
                    if (-not($BodyOutput)) {
                        # Create output object
                        $BodyOutput = @{ }
                    }
                    if ($Param.Parent) {
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
                        # Add input to body output
                        $BodyOutput[$Param.Name] = $Item.Value
                    }
                }
            }
        }
        if ($Parents) {
            foreach ($Key in $Parents.Keys) {
                # Add value arrays with parents to body output
                $BodyOutput[$Key] = @( $Parents.$Key )
            }
        }
        if ($BodyOutput) {
            # Output body value
            $BodyOutput
        } elseif ($ByteOutput) {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] File: $Filename"

            # Output file content
            $ByteOutput
        }
    }
}