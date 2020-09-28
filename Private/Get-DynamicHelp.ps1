function Get-DynamicHelp {
<#
.SYNOPSIS
    Outputs documentation about commands
.PARAMETER COMMAND
    PSRiskIQ command name(s)
.PARAMETER EXCLUSIONS
    RiskIQ endpoint names to exclude from results
#>
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 1)]
        [array] $Command,

        [Parameter(Position = 2)]
        [array] $Exclusions
    )
    begin {
        # PowerShell default parameter names (plus Help) to exclude from results
        $Defaults = @('Help', 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
        'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable')

        # Capture parameter set information
        $ParamSets = foreach ($Set in ((Get-Command $Command).ParameterSets | Where-Object {
        ($_.name -ne 'DynamicHelp') -and ($Exclusions -notcontains $_.name)})) {
            $Endpoint = $RiskIQ.Endpoint($Set.Name)
            @{
                $Set.name = @{
                    Endpoint = "$($Endpoint.Method.ToUpper()) $($Endpoint.Path)"
                    Description = "$($Endpoint.Description)"
                    Parameters = ($Set.parameters | Where-Object { $Defaults -notcontains $_.name }).foreach{
                        # Include parameters not listed in $Defaults
                        $Parameter = [ordered] @{
                            Name = $_.name
                            Type = $_.ParameterType.name
                            Required = $_.IsMandatory
                            Description = $_.HelpMessage
                        }
                        # Add ValidateSet, ValidateLength and ValidateRange values
                        foreach ($Attribute in @('ValidValues', 'RegexPattern', 'MinLength', 'MaxLength',
                        'MinRange', 'MaxRange')) {
                            $Name = switch -Regex ($Attribute) {
                                # Convert field names into friendly descriptors
                                'ValidValues' { 'Accepted' }
                                'RegexPattern' { 'Pattern' }
                                '(MinLength|MinRange)' { 'Minimum' }
                                '(MaxLength|MaxRange)' { 'Maximum' }
                            }
                            if ($_.Attributes.$Attribute) {
                                $Value = if ($_.Attributes.$Attribute -is [array]) {
                                    # Convert [array] to [string]
                                    $_.Attributes.$Attribute -join ', '
                                } else {
                                    $_.Attributes.$Attribute
                                }
                                $Parameter[$Name] = $Value
                            }
                        }
                        # Add parameter to array
                        $Parameter
                    }
                }
            }
        }
    }
    process {
        foreach ($Set in $ParamSets.Keys) {
            # Output a basic description of each endpoint in $Command
            "`n$($ParamSets.$Set.Description)" +
            "`n  Endpoint : $($ParamSets.$Set.Endpoint)"

            if ($ParamSets.$Set.Parameters) {
                # Output a description of each parameter involved with each endpoint
                foreach ($Parameter in $ParamSets.$Set.Parameters) {
                    $Label = "`n  -$($Parameter.Name) [$($Parameter.Type)]"

                    if ($Parameter.Required -eq $true) {
                        $Label += " <Required>"
                    }
                    $Label + "`n    $($Parameter.Description)"

                    foreach ($Pair in ($Parameter.GetEnumerator() | Where-Object { $_.Key -notmatch
                    '(Name|Type|Required|Description)'})) {
                        "      $($Pair.Key) : $($Pair.Value)"
                    }
                }
            }
        }
        "`n"
   }
}