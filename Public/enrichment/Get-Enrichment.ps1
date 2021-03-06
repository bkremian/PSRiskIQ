function Get-Enrichment {
<#
.SYNOPSIS
    Get enrichment data for domains and IPs
.DESCRIPTION
    Additional information is available with the -Help parameter
.PARAMETER HELP
    Output dynamic help information
#>
    [CmdletBinding(DefaultParameterSetName = 'GetV2EnrichmentBulk')]
    [OutputType()]
    param(
        [Parameter(
            ParameterSetName = 'DynamicHelp',
            Mandatory = $true)]
        [switch] $Help
    )
    DynamicParam {
        # Endpoint(s) used by function
        $Endpoints = @('GetV2EnrichmentBulk')

        # Create runtime dictionary
        return (Get-Dictionary $Endpoints -OutVariable Dynamic)
    }
    process {
        if ($Help) {
            # Output dynamic help
            Get-DynamicHelp $MyInvocation.MyCommand.Name
        } else {
            # Evaluate dynamic input
            $Param = if ($Dynamic.Query.Value.count -eq 1) {
                Get-Param 'GetV2Enrichment' $Dynamic
            } else {
                Get-Param $Endpoints[0] $Dynamic
            }
            # Make request
            Invoke-Endpoint @Param
        }
    }
}