function New-Project {
<#
.SYNOPSIS
    Create a project
.DESCRIPTION
    Additional information is available with the -Help parameter
.PARAMETER HELP
    Output dynamic help information
#>
    [CmdletBinding(DefaultParameterSetName = 'PutV2Project')]
    [OutputType()]
    param(
        [Parameter(
            ParameterSetName = 'DynamicHelp',
            Mandatory = $true)]
        [switch] $Help
    )
    DynamicParam {
        # Endpoint(s) used by function
        $Endpoints = @('PutV2Project')

        # Create runtime dictionary
        return (Get-Dictionary $Endpoints -OutVariable Dynamic)
    }
    process {
        if ($Help) {
            # Output dynamic help
            Get-DynamicHelp $MyInvocation.MyCommand.Name
        } else {
            # Evaluate dynamic input
            $Param = Get-Param $Endpoints[0] $Dynamic

            # Make request
            Invoke-Endpoint @Param
        }
    }
}