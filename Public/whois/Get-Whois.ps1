function Get-Whois {
<#
.SYNOPSIS
    Get Whois information
.DESCRIPTION
    Additional information is available with the -Help parameter
.PARAMETER HELP
    Output dynamic help information
#>
    [CmdletBinding(DefaultParameterSetName = 'GetV2WhoisSearchKeyword')]
    [OutputType()]
    param(
        [Parameter(
            ParameterSetName = 'DynamicHelp',
            Mandatory = $true)]
        [switch] $Help
    )
    DynamicParam {
        # Endpoint(s) used by function
        $Endpoints = @('GetV2WhoisSearchKeyword', 'GetV2Whois', 'GetV2WhoisSearch')

        # Create runtime dictionary
        return (Get-Dictionary $Endpoints -OutVariable Dynamic)
    }
    process {
        if ($Help) {
            # Output dynamic help
            Get-DynamicHelp $MyInvocation.MyCommand.Name
        } else {
            # Evaluate dynamic input
            $Param = Get-Param $PSCmdlet.ParameterSetName $Dynamic

            # Make request
            Invoke-Endpoint @Param
        }
    }
}