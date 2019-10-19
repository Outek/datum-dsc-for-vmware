<#
Copyright (c) 2018 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

function New-DateTimeConfig {
    [CmdletBinding()]
    [OutputType([VMware.Vim.HostDateTimeConfig])]
    param(
        [string[]] $NtpServer
    )

    $dateTimeConfig = New-Object VMware.Vim.HostDateTimeConfig
    $dateTimeConfig.NtpConfig = New-Object VMware.Vim.HostNtpConfig
    $dateTimeConfig.NtpConfig.Server = $NtpServer

    return $dateTimeConfig
}

function Update-DateTimeConfig {
    [CmdletBinding()]
    param(
        [VMware.Vim.HostDateTimeSystem] $DateTimeSystem,
        [VMware.Vim.HostDateTimeConfig] $DateTimeConfig
    )

    $DateTimeSystem.UpdateDateTimeConfig($DateTimeConfig)
}

function Update-ServicePolicy {
    [CmdletBinding()]
    param(
        [VMware.Vim.HostServiceSystem] $ServiceSystem,
        [string] $ServiceId,
        [string] $ServicePolicyValue
    )

    $ServiceSystem.UpdateServicePolicy($ServiceId, $ServicePolicyValue)
}

function New-DNSConfig {
    [CmdletBinding()]
    [OutputType([VMware.Vim.HostDnsConfig])]
    param(
        [string[]] $Address,
        [bool] $Dhcp,
        [string] $DomainName,
        [string] $HostName,
        [string] $Ipv6VirtualNicDevice,
        [string[]] $SearchDomain,
        [string] $VirtualNicDevice
    )

    $dnsConfig = New-Object VMware.Vim.HostDnsConfig
    $dnsConfig.HostName = $HostName
    $dnsConfig.DomainName = $DomainName

    if (!$Dhcp) {
        $dnsConfig.Address = $Address
        $dnsConfig.SearchDomain = $SearchDomain
    }
    else {
        $dnsConfig.Dhcp = $Dhcp
        $dnsConfig.VirtualNicDevice = $VirtualNicDevice

        if ($Ipv6VirtualNicDevice -ne [string]::Empty) {
            $dnsConfig.Ipv6VirtualNicDevice = $Ipv6VirtualNicDevice
        }
    }

    return $dnsConfig
}

function Update-DNSConfig {
    [CmdletBinding()]
    param(
        [VMware.Vim.HostNetworkSystem] $NetworkSystem,
        [VMware.Vim.HostDnsConfig] $DnsConfig
    )

    $NetworkSystem.UpdateDnsConfig($DnsConfig)
}

function Get-SATPClaimRules {
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [PSObject] $EsxCli
    )

    $satpClaimRules = $EsxCli.storage.nmp.satp.rule.list.Invoke()
    return $satpClaimRules
}

function Add-CreateArgs {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param(
        [PSOBject] $EsxCli
    )

    $satpArgs = $EsxCli.storage.nmp.satp.rule.add.CreateArgs()
    return $satpArgs
}

function Add-SATPClaimRule {
    [CmdletBinding()]
    param(
        [PSObject] $EsxCli,
        [Hashtable] $SatpArgs
    )

    $EsxCli.storage.nmp.satp.rule.add.Invoke($SatpArgs)
}

function Remove-CreateArgs {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param(
        [PSObject] $EsxCli
    )

    $satpArgs = $EsxCli.storage.nmp.satp.rule.remove.CreateArgs()
    return $satpArgs
}

function Remove-SATPClaimRule {
    [CmdletBinding()]
    param(
        [PSObject] $EsxCli,
        [Hashtable] $SatpArgs
    )

    $EsxCli.storage.nmp.satp.rule.remove.Invoke($SatpArgs)
}

function New-PerformanceInterval {
    [CmdletBinding()]
    [OutputType([VMware.Vim.PerfInterval])]
    param(
        [int] $Key,
        [string] $Name,
        [bool] $Enabled,
        [int] $Level,
        [long] $SamplingPeriod,
        [long] $Length
    )

    $performanceInterval = New-Object VMware.Vim.PerfInterval

    $performanceInterval.Key = $Key
    $performanceInterval.Name = $Name
    $performanceInterval.Enabled = $Enabled
    $performanceInterval.Level = $Level
    $performanceInterval.SamplingPeriod = $SamplingPeriod
    $performanceInterval.Length = $Length

    return $performanceInterval
}

function Update-PerfInterval {
    [CmdletBinding()]
    param(
        [VMware.Vim.PerformanceManager] $PerformanceManager,
        [VMware.Vim.PerfInterval] $PerformanceInterval
    )

    $PerformanceManager.UpdatePerfInterval($PerformanceInterval)
}

function Compare-Settings {
    <#
    .SYNOPSIS
    Compare settings between current and desired states
    .DESCRIPTION
    This compares the current and desired states by comparing the configuration values specified in the desired state to the current state.
    If a value is not specified in the desired state it is not assessed against the current state.

    .PARAMETER DesiredState
    Desired state configuration object.

    .PARAMETER CurrentState
    Current state configuration object.
    #>
    [CmdletBinding()]
    param(
        $DesiredState,
        $CurrentState
    )

    foreach ($key in $DesiredState.Keys) {
        if ($CurrentState.$key -ne $DesiredState.$key ) {
            return $true
        }
    }
    return $false
}

function Get-VMHostSyslogConfig {
    [CmdletBinding()]
    [OutputType([Object])]
    param(
        [PSObject] $EsxCli
    )

    $syslogConfig = $EsxCli.system.syslog.config.get.Invoke()

    return $syslogConfig
}

function Set-VMHostSyslogConfig {
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [PSObject] $EsxCli,
        [Hashtable] $VMHostSyslogConfig
    )

    $esxcli.system.syslog.config.set.Invoke($VMHostSyslogConfig)
    $esxcli.system.syslog.reload.Invoke()
}

function Update-Network {
    [CmdletBinding()]
    param(
        [VMware.Vim.HostNetworkSystem] $NetworkSystem,
        [Parameter(ParameterSetName = 'VSS')]
        [Hashtable] $VssConfig,
        [Parameter(ParameterSetName = 'VSSSecurity')]
        [Hashtable] $VssSecurityConfig,
        [Parameter(ParameterSetName = 'VSSShaping')]
        [Hashtable] $VssShapingConfig,
        [Parameter(ParameterSetName = 'VSSTeaming')]
        [Hashtable] $VssTeamingConfig,
        [Parameter(ParameterSetName = 'VSSBridge')]
        [Hashtable] $VssBridgeConfig
    )

    Write-Verbose -Message "$(Get-Date) $($s = Get-PSCallStack; "Entering {0}" -f $s[0].FunctionName)"

    <#
    $configNet is the parameter object we pass to the UpdateNetworkConfig method.
    Since all network updates will be done via this UpdateNetworkConfig method,
    we start with an empty VMware.Vim.HostNetworkConfig object in $configNet.
    Depending on the Switch case, we add the required objects to $configNet.

    This allows the Update-Network function to be used for all ESXi network related changes.
    #>

    $configNet = New-Object VMware.Vim.HostNetworkConfig

    switch ($PSCmdlet.ParameterSetName) {
        'VSS' {
            $hostVirtualSwitchConfig = $NetworkSystem.NetworkConfig.Vswitch | Where-Object { $_.Name -eq $VssConfig.Name }

            if ($null -eq $hostVirtualSwitchConfig -and 'add' -ne $VssConfig.Operation) {
                throw "Standard Virtual Switch $($this.Name) was not found"
            }

            if ($null -eq $hostVirtualSwitchConfig) {
                $hostVirtualSwitchConfig = New-Object VMware.Vim.HostVirtualSwitchConfig
            }

            $hostVirtualSwitchConfig.ChangeOperation = $VssConfig.Operation
            $hostVirtualSwitchConfig.Name = $VssConfig.Name

            if ($null -eq $hostVirtualSwitchConfig.Spec) {
                $hostVirtualSwitchConfig.Spec = New-Object VMware.Vim.HostVirtualSwitchSpec
            }

            $hostVirtualSwitchConfig.Spec.Mtu = $VssConfig.Mtu
            # Although ignored since ESXi 5.5, the NumPorts property is 'required'
            $hostVirtualSwitchConfig.Spec.NumPorts = 1
            $configNet.Vswitch += $hostVirtualSwitchConfig
        }

        'VSSSecurity' {
            $hostVirtualSwitchConfig = $NetworkSystem.NetworkConfig.Vswitch | Where-Object { $_.Name -eq $VssSecurityConfig.Name }

            $hostVirtualSwitchConfig.ChangeOperation = $VssSecurityConfig.Operation
            $hostVirtualSwitchConfig.Spec.Policy.Security.AllowPromiscuous = $VssSecurityConfig.AllowPromiscuous
            $hostVirtualSwitchConfig.Spec.Policy.Security.ForgedTransmits = $VssSecurityConfig.ForgedTransmits
            $hostVirtualSwitchConfig.Spec.Policy.Security.MacChanges = $VssSecurityConfig.MacChanges

            $configNet.Vswitch += $hostVirtualSwitchConfig
        }

        'VSSShaping' {
            $hostVirtualSwitchConfig = $NetworkSystem.NetworkConfig.Vswitch | Where-Object { $_.Name -eq $VssShapingConfig.Name }

            $hostVirtualSwitchConfig.ChangeOperation = $VssShapingConfig.Operation
            $hostVirtualSwitchConfig.Spec.Policy.ShapingPolicy.AverageBandwidth = $VssShapingConfig.AverageBandwidth
            $hostVirtualSwitchConfig.Spec.Policy.ShapingPolicy.BurstSize = $VssShapingConfig.BurstSize
            $hostVirtualSwitchConfig.Spec.Policy.ShapingPolicy.Enabled = $VssShapingConfig.Enabled
            $hostVirtualSwitchConfig.Spec.Policy.ShapingPolicy.PeakBandwidth = $VssShapingConfig.PeakBandwidth

            $configNet.Vswitch += $hostVirtualSwitchConfig
        }

        'VSSTeaming' {
            $hostVirtualSwitchConfig = $NetworkSystem.NetworkConfig.Vswitch | Where-Object { $_.Name -eq $VssTeamingConfig.Name }

            if ($VssTeamingConfig.CheckBeacon -and
                ($hostVirtualSwitchConfig.Spec.Bridge -isnot [VMware.Vim.HostVirtualSwitchBridge] -or
                    $hostVirtualSwitchConfig.Spec.Bridge.Interval -eq 0)) {
                throw 'VMHostVssTeaming: Configuration error - CheckBeacon can only be enabled if the VirtualSwitch has been configured to use the beacon.'
            }

            if (-not $VssTeamingConfig.CheckBeacon -and
                $hostVirtualSwitchConfig.Spec.Bridge -is [VMware.Vim.HostVirtualSwitchBridge] -and
                $hostVirtualSwitchConfig.Spec.Bridge.Interval -eq 0) {
                throw 'VMHostVssTeaming: Configuration error - CheckBeacon can only be disabled if the VirtualSwitch has not been configured to use the beacon.'
            }

            if ((0 -ne $VssTeamingConfig.ActiveNic.Count -or
                    0 -ne $VssTeamingConfig.StandbyNic.Count) -and
                $null -ne $hostVirtualSwitchConfig.Spec.Bridge -and
                0 -eq $hostVirtualSwitchConfig.Spec.Bridge.NicDevice.Count) {
                throw "VMHostVssTeaming: Configuration error - You cannot use Active- or Standby NICs, when there are no NICs assigned to the Bridge"
            }

            $hostVirtualSwitchConfig.ChangeOperation = $VssTeamingConfig.Operation
            $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.FailureCriteria.CheckBeacon = $VssTeamingConfig.CheckBeacon
            $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.NicOrder.ActiveNic = $VssTeamingConfig.ActiveNic
            $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.NicOrder.StandbyNic = $VssTeamingConfig.StandbyNic
            $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.NotifySwitches = $VssTeamingConfig.NotifySwitches
            $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.Policy = $VssTeamingConfig.Policy
            $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.RollingOrder = $VssTeamingConfig.RollingOrder

            $configNet.Vswitch += $hostVirtualSwitchConfig
        }

        'VssBridge' {
            $hostVirtualSwitchConfig = $NetworkSystem.NetworkConfig.Vswitch | Where-Object { $_.Name -eq $VssBridgeConfig.Name }

            if ($VssBridgeConfig.NicDevice.Count -eq 0) {
                if ($hostVirtualSwitchConfig.Spec.Policy.NicTeaming.NicOrder.ActiveNic.Count -ne 0 -or
                    $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.NicOrder.StandbyNic.Count -ne 0) {
                    throw "VMHostVssBridge: Configuration error - When NICs are defined as Active or Standby, you must specify them under NicDevice as well."
                }
                elseif ($VssBridgeConfig.BeaconInterval) {
                    throw "VMHostVssBridge: Configuration error - When you define a BeaconInterval, you must have one or more NICs defined under NicDevice."
                }
                elseif ($VssBridgeConfig.LinkDiscoveryProtocolOperation -or $VssBridgeConfig.LinkDiscoveryProtocolProtocol) {
                    throw "VMHostVssBridge: Configuration error - When you use Link Discovery, you must have NICs defined under NicDevice."
                }
            }
            else {
                if ($VssBridgeConfig.BeaconInterval -eq 0 -and $hostVirtualSwitchConfig.Spec.Policy.NicTeaming.FailureCriteria.CheckBeacon -eq $true) {
                    throw "VMHostVssBridge: Configuration error - You can not have a Beacon interval of zero, when Beacon Checking is enabled."
                }

            }

            $hostVirtualSwitchConfig.ChangeOperation = $VssBridgeConfig.Operation

            if ($VssBridgeConfig.NicDevice.Count -ne 0) {
                $hostVirtualSwitchConfig.Spec.Bridge = New-Object -TypeName 'VMware.Vim.HostVirtualSwitchBondBridge'
                $hostVirtualSwitchConfig.Spec.Bridge.NicDevice = $VssBridgeConfig.NicDevice

                if (0 -ne $VssBridgeConfig.BeaconInterval) {
                    $hostVirtualSwitchConfig.Spec.Bridge.Beacon = New-Object VMware.Vim.HostVirtualSwitchBeaconConfig
                    $hostVirtualSwitchConfig.Spec.Bridge.Beacon.Interval = $VssBridgeConfig.BeaconInterval
                }
                else {
                    if ($vss.Spec.Policy.NicTeaming.FailureCriteria.CheckBeacon) {
                        throw "VMHostVssBridge: Configuration error - When CheckBeacon is True, the BeaconInterval cannot be 0"
                    }
                }

                if ( [LinkDiscoveryProtocolProtocol]::CDP -eq $VssBridgeConfig.LinkDiscoveryProtocolProtocol) {
                    $hostVirtualSwitchConfig.Spec.Bridge.linkDiscoveryProtocolConfig = New-Object -TypeName VMware.Vim.LinkDiscoveryProtocolConfig
                    $hostVirtualSwitchConfig.Spec.Bridge.linkDiscoveryProtocolConfig.Operation = ([string]$VssBridgeConfig.LinkDiscoveryProtocolOperation).ToLower()
                    $hostVirtualSwitchConfig.Spec.Bridge.linkDiscoveryProtocolConfig.Protocol = ([string]$VssBridgeConfig.LinkDiscoveryProtocolProtocol).ToLower()
                }
                elseif ( [LinkDiscoveryProtocolProtocol]::CDP -ne $VssBridgeConfig.LinkDiscoveryProtocolProtocol ) {
                    throw "VMHostVssBridge: Configuration error - A Virtual Switch (VSS) only supports CDP as the Link Discovery Protocol"
                }
            }
            else {
                $hostVirtualSwitchConfig.Spec.Bridge = $null
            }

            $configNet.Vswitch += $hostVirtualSwitchConfig
        }
    }

    $NetworkSystem.UpdateNetworkConfig($configNet, [VMware.Vim.HostConfigChangeMode]::modify)
}

function Add-Cluster {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [VMware.Vim.Folder] $Folder,

        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [VMware.Vim.ClusterConfigSpecEx] $Spec
    )

    $Folder.CreateClusterEx($Name, $Spec)
}

function Update-ClusterComputeResource {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [VMware.Vim.ClusterComputeResource] $ClusterComputeResource,

        [Parameter(Mandatory = $true)]
        [VMware.Vim.ClusterConfigSpecEx] $Spec
    )

    $ClusterComputeResource.ReconfigureComputeResource_Task($Spec, $true)
}

function Remove-ClusterComputeResource {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [VMware.Vim.ClusterComputeResource] $ClusterComputeResource
    )

    $ClusterComputeResource.Destroy()
}

# SIG # Begin signature block
# MIIdUQYJKoZIhvcNAQcCoIIdQjCCHT4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+tBksw3eRg7Wj7UAxKkFYl7R
# /fugghhkMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggTMMIIDtKADAgECAhBdqtQcwalQC13tonk09GI7MA0GCSqGSIb3DQEBCwUAMH8x
# CzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0G
# A1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMg
# Q2xhc3MgMyBTSEEyNTYgQ29kZSBTaWduaW5nIENBMB4XDTE4MDgxMzAwMDAwMFoX
# DTIxMDkxMTIzNTk1OVowZDELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3Ju
# aWExEjAQBgNVBAcMCVBhbG8gQWx0bzEVMBMGA1UECgwMVk13YXJlLCBJbmMuMRUw
# EwYDVQQDDAxWTXdhcmUsIEluYy4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCuswYfqnKot0mNu9VhCCCRvVcCrxoSdB6G30MlukAVxgQ8qTyJwr7IVBJX
# EKJYpzv63/iDYiNAY3MOW+Pb4qGIbNpafqxc2WLW17vtQO3QZwscIVRapLV1xFpw
# uxJ4LYdsxHPZaGq9rOPBOKqTP7JyKQxE/1ysjzacA4NXHORf2iars70VpZRksBzk
# niDmurvwCkjtof+5krxXd9XSDEFZ9oxeUGUOBCvSLwOOuBkWPlvCnzEqMUeSoXJa
# vl1QSJvUOOQeoKUHRycc54S6Lern2ddmdUDPwjD2cQ3PL8cgVqTsjRGDrCgOT7Gw
# ShW3EsRsOwc7o5nsiqg/x7ZmFpSJAgMBAAGjggFdMIIBWTAJBgNVHRMEAjAAMA4G
# A1UdDwEB/wQEAwIHgDArBgNVHR8EJDAiMCCgHqAchhpodHRwOi8vc3Yuc3ltY2Iu
# Y29tL3N2LmNybDBhBgNVHSAEWjBYMFYGBmeBDAEEATBMMCMGCCsGAQUFBwIBFhdo
# dHRwczovL2Quc3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZDBdodHRwczovL2Qu
# c3ltY2IuY29tL3JwYTATBgNVHSUEDDAKBggrBgEFBQcDAzBXBggrBgEFBQcBAQRL
# MEkwHwYIKwYBBQUHMAGGE2h0dHA6Ly9zdi5zeW1jZC5jb20wJgYIKwYBBQUHMAKG
# Gmh0dHA6Ly9zdi5zeW1jYi5jb20vc3YuY3J0MB8GA1UdIwQYMBaAFJY7U/B5M5ev
# fYPvLivMyreGHnJmMB0GA1UdDgQWBBTVp9RQKpAUKYYLZ70Ta983qBUJ1TANBgkq
# hkiG9w0BAQsFAAOCAQEAlnsx3io+W/9i0QtDDhosvG+zTubTNCPtyYpv59Nhi81M
# 0GbGOPNO3kVavCpBA11Enf0CZuEqf/ctbzYlMRONwQtGZ0GexfD/RhaORSKib/AC
# t70siKYBHyTL1jmHfIfi2yajKkMxUrPM9nHjKeagXTCGthD/kYW6o7YKKcD7kQUy
# BhofimeSgumQlm12KSmkW0cHwSSXTUNWtshVz+74EcnZtGFI6bwYmhvnTp05hWJ8
# EU2Y1LdBwgTaRTxlSDP9JK+e63vmSXElMqnn1DDXABT5RW8lNt6g9P09a2J8p63J
# GgwMBhmnatw7yrMm5EAo+K6gVliJLUMlTW3O09MbDTCCBVkwggRBoAMCAQICED14
# 1/l2SWCyYX308B7KhiowDQYJKoZIhvcNAQELBQAwgcoxCzAJBgNVBAYTAlVTMRcw
# FQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3Qg
# TmV0d29yazE6MDgGA1UECxMxKGMpIDIwMDYgVmVyaVNpZ24sIEluYy4gLSBGb3Ig
# YXV0aG9yaXplZCB1c2Ugb25seTFFMEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMyBQ
# dWJsaWMgUHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEc1MB4XDTEz
# MTIxMDAwMDAwMFoXDTIzMTIwOTIzNTk1OVowfzELMAkGA1UEBhMCVVMxHTAbBgNV
# BAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVz
# dCBOZXR3b3JrMTAwLgYDVQQDEydTeW1hbnRlYyBDbGFzcyAzIFNIQTI1NiBDb2Rl
# IFNpZ25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCXgx4A
# Fq8ssdIIxNdok1FgHnH24ke021hNI2JqtL9aG1H3ow0Yd2i72DarLyFQ2p7z518n
# TgvCl8gJcJOp2lwNTqQNkaC07BTOkXJULs6j20TpUhs/QTzKSuSqwOg5q1PMIdDM
# z3+b5sLMWGqCFe49Ns8cxZcHJI7xe74xLT1u3LWZQp9LYZVfHHDuF33bi+VhiXjH
# aBuvEXgamK7EVUdT2bMy1qEORkDFl5KK0VOnmVuFNVfT6pNiYSAKxzB3JBFNYoO2
# untogjHuZcrf+dWNsjXcjCtvanJcYISc8gyUXsBWUgBIzNP4pX3eL9cT5DiohNVG
# uBOGwhud6lo43ZvbAgMBAAGjggGDMIIBfzAvBggrBgEFBQcBAQQjMCEwHwYIKwYB
# BQUHMAGGE2h0dHA6Ly9zMi5zeW1jYi5jb20wEgYDVR0TAQH/BAgwBgEB/wIBADBs
# BgNVHSAEZTBjMGEGC2CGSAGG+EUBBxcDMFIwJgYIKwYBBQUHAgEWGmh0dHA6Ly93
# d3cuc3ltYXV0aC5jb20vY3BzMCgGCCsGAQUFBwICMBwaGmh0dHA6Ly93d3cuc3lt
# YXV0aC5jb20vcnBhMDAGA1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9zMS5zeW1jYi5j
# b20vcGNhMy1nNS5jcmwwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRU3ltYW50ZWNQ
# S0ktMS01NjcwHQYDVR0OBBYEFJY7U/B5M5evfYPvLivMyreGHnJmMB8GA1UdIwQY
# MBaAFH/TZafC3ey78DAJ80M5+gKvMzEzMA0GCSqGSIb3DQEBCwUAA4IBAQAThRoe
# aak396C9pK9+HWFT/p2MXgymdR54FyPd/ewaA1U5+3GVx2Vap44w0kRaYdtwb9oh
# BcIuc7pJ8dGT/l3JzV4D4ImeP3Qe1/c4i6nWz7s1LzNYqJJW0chNO4LmeYQW/Ciw
# sUfzHaI+7ofZpn+kVqU/rYQuKd58vKiqoz0EAeq6k6IOUCIpF0yH5DoRX9akJYmb
# BWsvtMkBTCd7C6wZBSKgYBU/2sn7TUyP+3Jnd/0nlMe6NQ6ISf6N/SivShK9DbOX
# Bd5EDBX6NisD3MFQAfGhEV0U5eK9J0tUviuEXg+mw3QFCu+Xw4kisR93873NQ9Tx
# TKk/tYuEr2Ty0BQhMIIFmjCCA4KgAwIBAgIKYRmT5AAAAAAAHDANBgkqhkiG9w0B
# AQUFADB/MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYD
# VQQDEyBNaWNyb3NvZnQgQ29kZSBWZXJpZmljYXRpb24gUm9vdDAeFw0xMTAyMjIx
# OTI1MTdaFw0yMTAyMjIxOTM1MTdaMIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMO
# VmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsx
# OjA4BgNVBAsTMShjKSAyMDA2IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6
# ZWQgdXNlIG9ubHkxRTBDBgNVBAMTPFZlcmlTaWduIENsYXNzIDMgUHVibGljIFBy
# aW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHNTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAK8kCAgpejWeYAyq50s7Ttx8vDxFHLsr4P4pAvlX
# CKNkhRUn9fGtyDGJXSLoKqqmQrOP+LlVt7G3S7P+j34HV+zvQ9tmYhVhz2ANpNje
# +ODDYgg9VBPrScpZVIUm5SuPG5/r9aGRwjNJ2ENjalJL0o/ocFFN0Ylpe8dw9rPc
# EnTbe11LVtOWvxV3obD0oiXyrxySZxjl9AYE75C55ADk3Tq1Gf8CuvQ87uCL6zeL
# 7PTXrPL28D2v3XWRMxkdHEDLdCQZIZPZFP6sKlLHj9UESeSNY0eIPGmDy/5HvSt+
# T8WVrg6d1NFDwGdz4xQIfuU/n3O4MwrPXT80h5aK7lPoJRUCAwEAAaOByzCByDAR
# BgNVHSAECjAIMAYGBFUdIAAwDwYDVR0TAQH/BAUwAwEB/zALBgNVHQ8EBAMCAYYw
# HQYDVR0OBBYEFH/TZafC3ey78DAJ80M5+gKvMzEzMB8GA1UdIwQYMBaAFGL7CiFb
# f0NuEdoJVFBr9dKWcfGeMFUGA1UdHwROMEwwSqBIoEaGRGh0dHA6Ly9jcmwubWlj
# cm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY3Jvc29mdENvZGVWZXJpZlJv
# b3QuY3JsMA0GCSqGSIb3DQEBBQUAA4ICAQCBKoIWjDRnK+UD6zR7jKKjUIr0VYbx
# HoyOrn3uAxnOcpUYSK1iEf0g/T9HBgFa4uBvjBUsTjxqUGwLNqPPeg2cQrxc+BnV
# YONp5uIjQWeMaIN2K4+Toyq1f75Z+6nJsiaPyqLzghuYPpGVJ5eGYe5bXQdrzYao
# 4mWAqOIV4rK+IwVqugzzR5NNrKSMB3k5wGESOgUNiaPsn1eJhPvsynxHZhSR2LYP
# GV3muEqsvEfIcUOW5jIgpdx3hv0844tx23ubA/y3HTJk6xZSoEOj+i6tWZJOfMfy
# M0JIOFE6fDjHGyQiKEAeGkYfF9sY9/AnNWy4Y9nNuWRdK6Ve78YptPLH+CHMBLpX
# /QG2q8Zn+efTmX/09SL6cvX9/zocQjqh+YAYpe6NHNRmnkUB/qru//sXjzD38c0p
# xZ3stdVJAD2FuMu7kzonaknAMK5myfcjKDJ2+aSDVshIzlqWqqDMDMR/tI6Xr23j
# VCfDn4bA1uRzCJcF29BUYl4DSMLVn3+nZozQnbBP1NOYX0t6yX+yKVLQEoDHD1S2
# HmfNxqBsEQOE00h15yr+sDtuCjqma3aZBaPxd2hhMxRHBvxTf1K9khRcSiRqZ4yv
# jZCq0PZ5IRuTJnzDzh69iDiSrkXGGWpJULMF+K5ZN4pqJQOUsVmBUOi6g4C3IzX0
# drlnHVkYrSCNlDGCBFcwggRTAgEBMIGTMH8xCzAJBgNVBAYTAlVTMR0wGwYDVQQK
# ExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3Qg
# TmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMgQ2xhc3MgMyBTSEEyNTYgQ29kZSBT
# aWduaW5nIENBAhBdqtQcwalQC13tonk09GI7MAkGBSsOAwIaBQCggYowGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFBRC9i0eERG94oI7zNkZ8t13hzFwMCoGCisGAQQB
# gjcCAQwxHDAaoRiAFmh0dHA6Ly93d3cudm13YXJlLmNvbS8wDQYJKoZIhvcNAQEB
# BQAEggEABPhsWgPsKCXxeio1T8dowfWtTBuKnb8R+bHUxrDierDEldsJZM+pt0np
# /EBlboMDlSvHHZc0EZSfVDSr3btbRt1wDqVzH2Mx2C1xAgAxxmSQU4FhcI+plhSV
# 88jDDSfGUCt1PSSRJX6jyR2Ugmo7xpQIpjJO68rpGnDN9gvIgbZJkB8/enrdoI1V
# rHwCEYO7UjTeOmk30JcxcZW+p8BbflxEnI9XEyAYr+a6GR6EywCi6kCXZ5kRybsR
# aoMVEaHMAGwO4UOpLPqLR4Yzf+h5KGXbvBWp8sOfuhp1tqs8xABQl1XEMDfYSAJs
# YLSH+lIMzmV6rYPaani1j6Fx6Ue7YKGCAgswggIHBgkqhkiG9w0BCQYxggH4MIIB
# 9AIBATByMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyAhAOz/Q4yP6/NW4E2GqYGxpQMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0B
# CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xOTA2MTIxMTQ3MDRaMCMG
# CSqGSIb3DQEJBDEWBBQb44qsXoNZh7r5G07bsQbjHzMLVDANBgkqhkiG9w0BAQEF
# AASCAQBVDWeldK55AnJjS0k260iLmxpChULEgZYFffX4VeKT8rEdPJkkcsj+BPwf
# OysdvM841dWpFIAHgcR1AEZzYHVGBzWhFub9Y+cuae4YuNpjmNjp3kqlkDDHlBQ8
# JJWurQoNsR5hhYPyJ49uoMmQ9oarY7PT0iJATgmuIEedg2jvL2Wh7fE9D8q91uIt
# 26ccRS7SD7nsUe82Wk0WwblCa6T7P+zvBZXh02L0V+VTemUyxqr1tlRrZG6o9cd3
# +czTpxMUGgV8fflWDMvsVdO+tgn+8mXFFXNd1d/HaDqmYadO2Cd0PGap0Qe86ccU
# so+9BCzwuHyVy+6FQa6E7Jr8tWAE
# SIG # End signature block
