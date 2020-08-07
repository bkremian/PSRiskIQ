function Get-Certificate {
<#
.SYNOPSIS
    Get SSL certificate information
.PARAMETER HISTORY
    Retrieve certificate history
.DESCRIPTION
    Additional information is available with the -Help parameter
.PARAMETER HELP
    Output dynamic help information
#>
    [CmdletBinding(DefaultParameterSetName = 'GetV2SslCertificateSearchKeyword')]
    [OutputType()]
    param(
        [Parameter(
            ParameterSetName = 'GetV2SslCertificateHistory',
            Mandatory = $true)]
        [switch] $History,

        [Parameter(
            ParameterSetName = 'DynamicHelp',
            Mandatory = $true)]
        [switch] $Help
    )
    DynamicParam {
        # Endpoint(s) used by function
        $Endpoints = @('GetV2SslCertificateSearchKeyword', 'GetV2SslCertificate', 'GetV2SslCertificateSearch',
            'GetV2SslCertificateHistory')

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