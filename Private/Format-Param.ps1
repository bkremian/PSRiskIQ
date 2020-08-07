function Format-Param {
<#
.SYNOPSIS
    Converts a 'splat' hashtable body into Json
.PARAMETER PARAM
    Parameter hashtable
#>
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 1)]
        [hashtable] $Param
    )
    process {
        if ($Param.Body) {
            # Convert body to Json
            $Param.Body = ConvertTo-Json $Param.Body -Depth 8
            Write-Debug ("[$($MyInvocation.MyCommand.Name)] $($Param.Body)")
        }
        # Output result
        $Param
    }
}