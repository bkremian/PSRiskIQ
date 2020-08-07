function Get-AuthPair {
<#
.SYNOPSIS
    Outputs an authorization pair for Format-Header
#>
    [CmdletBinding()]
    [OutputType()]
    param()
    process {
        if ($RiskIQ.Id -and $RiskIQ.Secret) {
            # Output base64 encoded Username/Password pair
            "basic $([System.Convert]::ToBase64String(
                [System.Text.Encoding]::ASCII.GetBytes("$($RiskIQ.Id):$(Get-SecureString $RiskIQ.Secret)")))"
        } else {
            $null
        }
    }
}