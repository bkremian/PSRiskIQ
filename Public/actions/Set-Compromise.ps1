function Set-Compromise {
<#
.SYNOPSIS
    Set compromise status for a domain
.DESCRIPTION
    Additional information is available with the -Help parameter
.PARAMETER HELP
    Output dynamic help information
#>
    [CmdletBinding(DefaultParameterSetName = 'PostV2ActionsEverCompromised')]
    [OutputType()]
    param(
        [Parameter(
            ParameterSetName = 'DynamicHelp',
            Mandatory = $true)]
        [switch] $Help
    )
    DynamicParam {
        # Endpoint(s) used by function
        $Endpoints = @('PostV2ActionsEverCompromised')

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