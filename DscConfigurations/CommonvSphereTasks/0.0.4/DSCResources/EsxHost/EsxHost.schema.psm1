Configuration EsxHost 
{
    param (
        [Parameter(Mandatory)]
        [System.String]
        $Name,

        [Parameter(Mandatory)]
        [System.String]
        $Server,

        [System.String]
        $NtpServers
    )

    Import-DscResource -ModuleName VMware.vSphereDSC
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    $Credential = New-Object pscredential('Domain\Domainaccount', ("mysecurepassword" | ConvertTo-SecureString -AsPlainText -Force))

    if ($NtpServers) {
        VMHostNtpSettings "VMHostNtpSettings_$($Name)" {
            Name             = $Name
            Server           = $Server
            Credential       = $Credentials
            NtpServer        = $NtpServers
            NtpServicePolicy = 'automatic'
        }

        VMHostService "VMHostService_$($Name)" {
            Name       = $Name
            Server     = $Server
            Credential = $Credential
            Key        = 'ntpd'
            Policy     = 'On'
            Running    = $true
        }
    }
}
