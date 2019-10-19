Configuration EsxHost
{
    param(
        [Parameter(Mandatory)]
        [System.String]
        $Name,

        [Parameter(Mandatory)]
        [System.String]
        $Server,

        [hashtable[]]
        $NtpServers
    )

    Import-DscResource -ModuleName VMware.vSphereDSC
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    $Credentials = New-Object pscredential('Domain\Domainaccount', ("mysecurepassword" | ConvertTo-SecureString -AsPlainText -Force))
    
    foreach ($NtpServer in $NtpServers) {
        VMHostNtpSettings "MyVMHostNtpSetting" {
            Name             = $Name
            Server           = $Server
            Credential       = $Credentials
            NtpServer        = @($NtpServer.NtpServer)
            NtpServicePolicy = 'automatic'
        }
    }

    VMHostService "MyVMHostService_NTP" {
        Name       = $Name
        Server     = $Server
        Credential = $Credentials
        Key        = 'ntpd'
        Policy     = 'On'
        Running    = $true
    }
}
