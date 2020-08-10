function Get-OSINT {
<#
.SYNOPSIS
    Get OSInt data for domains and IPs
.DESCRIPTION
    Additional information is available with the -Help parameter
.PARAMETER HELP
    Output dynamic help information
#>
    [CmdletBinding(DefaultParameterSetName = 'GetV2EnrichmentBulkOsint')]
    [OutputType()]
    param(
        [Parameter(
            ParameterSetName = 'DynamicHelp',
            Mandatory = $true)]
        [switch] $Help
    )
    DynamicParam {
        # Endpoint(s) used by function
        $Endpoints = @('GetV2EnrichmentBulkOsint')

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
                Get-Param 'GetV2EnrichmentOsint' $Dynamic
            } else {
                Get-Param $Endpoints[0] $Dynamic
            }
            # Make request
            Invoke-Endpoint @Param
        }
    }
}