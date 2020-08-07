function Get-Param {
<#
.SYNOPSIS
    Creates a 'splat' hashtable for Invoke-Endpoint
.PARAMETER ENDPOINT
    RiskIQ endpoint name
.PARAMETER DYNAMIC
    A runtime parameter dictionary to search for input values
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
        [System.Collections.ArrayList] $Dynamic
    )
    begin {
        # Set RiskIQ endpoint target
        $Target = $RiskIQ.Endpoint($Endpoint)

        # Create output object
        $Output = @{
            Endpoint = $Endpoint
        }
    }
    process {
        # Check dictionary for input matching endpoint target
        @('Body', 'Formdata', 'Header', 'Outfile', 'Path', 'Query') | ForEach-Object {
            # Create variable for each input type
            New-Variable -Name $_ -Value (& "Get-$_" $Target $Dynamic)

            if ((Get-Variable $_).Value) {
                # Add results to output
                $Output[$_] = (Get-Variable $_).Value

                Write-Verbose ("[$($MyInvocation.MyCommand.Name)] $(((Get-Variable $_).Value).count)" +
                    " $(($_).ToLower()) input(s)")
            }
        }
        # Convert to Json and output
        Format-Param $Output
    }
}