class RiskIQ {
    [string] $Hostname
    [string] $Id
    [securestring] $Secret
    [array] $Endpoints

    RiskIQ ($Hostname) {
        # Set hostname
        $this.Hostname = $Hostname

        if (Test-Path "$this.cred") {
            # Import cached credentials
            $Cred = Import-Clixml "$this.cred"
            $this.Id = $Cred.UserName
            $this.Secret = $Cred.Password
        }
        # Add PSTypeName
        $this.psobject.typenames.insert(0,'RiskIQ')
    }
    [array] Endpoint($Endpoint) {
        # Return endpoint detail
        return ($this.Endpoints | Where-Object Name -cin $Endpoint)
    }
    [string] ExportCred() {
        # Collect and export credentials
        $Cred = Get-Credential
        $this.Id = $Cred.UserName
        $this.Secret = $Cred.Password
        $Cred | Export-Clixml "$this.cred"
        return "Created $this.cred"
    }
    [string] ImportCred($Name) {
        # Import credentials
        $Cred = Import-Clixml "$Name.cred"

        if ($Cred) {
            $this.Id = $Cred.UserName
            $this.Secret = $Cred.Password
            return "Imported $Name.cred"
        } else {
            return "$Name.cred does not exist"
        }
    }
}