function BeforeEachFeature {
    <#
        .SYNOPSIS
        Defines a ScriptBlock hook to run before each feature to set up the test environment

        .DESCRIPTION
        BeforeEachFeature hooks are run before each feature that is in (or above) the folder where the hook is defined.

        This is a convenience method, provided because unlike traditional RSpec Pester,
        there is not a simple test script where you can put setup and clean up.

        .PARAMETER Tags
        Optional tags. If set, this hook only runs for features with matching tags

        .PARAMETER Script
        The ScriptBlock to run for the hook

        .LINK
        AfterEachFeature
        BeforeEachScenario
        AfterEachScenario
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(

        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "Tags")]
        [String[]]$Tags = @(),

        [Parameter(Mandatory = $True, Position = 1, ParameterSetName = "Tags")]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "All")]
        [ScriptBlock]$Script
    )

    # This shouldn't be necessary, but PowerShell 2 is BAF
    if ($PSCmdlet.ParameterSetName -eq "Tags") {
        ${Script:GherkinHooks}.BeforeEachFeature += @( @{ Tags = $Tags; Script = $Script } )
    }
    else {
        ${Script:GherkinHooks}.BeforeEachFeature += @( @{ Tags = @(); Script = $Script } )
    }
}

function AfterEachFeature {
    <#
        .SYNOPSIS
        Defines a ScriptBlock hook to run at the very end of a test run

        .DESCRIPTION
        AfterEachFeature hooks are run after each feature that is in (or above) the folder where the hook is defined.

        This is a convenience method, provided because unlike traditional RSpec Pester,
        there is not a simple test script where you can put setup and clean up.

        .PARAMETER Tags
        Optional tags. If set, this hook only runs for features with matching tags.

        .PARAMETER Script
        The ScriptBlock to run for the hook

        .LINK
            BeforeEachFeature
            BeforeEachScenario
            AfterEachScenario
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(

        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "Tags")]
        [String[]]$Tags = @(),

        [Parameter(Mandatory = $True, Position = 1, ParameterSetName = "Tags")]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "All")]
        [ScriptBlock]$Script
    )

    # This shouldn't be necessary, but PowerShell 2 is BAF
    if ($PSCmdlet.ParameterSetName -eq "Tags") {
        ${Script:GherkinHooks}.AfterEachFeature += @( @{ Tags = $Tags; Script = $Script } )
    }
    else {
        ${Script:GherkinHooks}.AfterEachFeature += @( @{ Tags = @(); Script = $Script } )
    }
}

function BeforeEachScenario {
    <#
        .SYNOPSIS
        Defines a ScriptBlock hook to run before each scenario to set up the test environment

        .DESCRIPTION
        BeforeEachScenario hooks are run before each scenario that is in (or above) the folder where the hook is defined.

        You should not normally need this, because it overlaps significantly with the "Background" feature in the gherkin language.

        This is a convenience method, provided because unlike traditional RSpec Pester,
        there is not a simple test script where you can put setup and clean up.

        .PARAMETER Tags
        Optional tags. If set, this hook only runs for features with matching tags

        .PARAMETER Script
        The ScriptBlock to run for the hook

        .LINK
        AfterEachFeature
        BeforeEachScenario
        AfterEachScenario
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(

        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "Tags")]
        [String[]]$Tags = @(),

        [Parameter(Mandatory = $True, Position = 1, ParameterSetName = "Tags")]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "All")]
        [ScriptBlock]$Script
    )

    # This shouldn't be necessary, but PowerShell 2 is BAF
    if ($PSCmdlet.ParameterSetName -eq "Tags") {
        ${Script:GherkinHooks}.BeforeEachScenario += @( @{ Tags = $Tags; Script = $Script } )
    }
    else {
        ${Script:GherkinHooks}.BeforeEachScenario += @( @{ Tags = @(); Script = $Script } )
    }
}

function AfterEachScenario {
    <#
        .SYNOPSIS
        Defines a ScriptBlock hook to run after each scenario to set up the test environment

        .DESCRIPTION
        AfterEachScenario hooks are run after each Scenario that is in (or above) the folder where the hook is defined.

        This is a convenience method, provided because unlike traditional RSpec Pester,
        there is not a simple test script where you can put setup and clean up.

        .PARAMETER Tags
        Optional tags. If set, this hook only runs for features with matching tags

        .PARAMETER Script
        The ScriptBlock to run for the hook

        .LINK
            BeforeEachFeature
            BeforeEachScenario
            AfterEachScenario
    #>
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "Tags")]
        [String[]]$Tags = @(),

        [Parameter(Mandatory = $True, Position = 1, ParameterSetName = "Tags")]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = "All")]
        [ScriptBlock]$Script
    )

    # This shouldn't be necessary, but PowerShell 2 is BAF
    if ($PSCmdlet.ParameterSetName -eq "Tags") {
        ${Script:GherkinHooks}.AfterEachScenario += @( @{ Tags = $Tags; Script = $Script } )
    }
    else {
        ${Script:GherkinHooks}.AfterEachScenario += @( @{ Tags = @(); Script = $Script } )
    }
}

# SIG # Begin signature block
# MIIcVgYJKoZIhvcNAQcCoIIcRzCCHEMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6+OAExRC+0GA4ggglPLenQ/7
# GPOggheFMIIFDjCCA/agAwIBAgIQAkpwj7JyQh8pn8abOhJIUDANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE4MTEyNzAwMDAwMFoXDTE5MTIw
# MjEyMDAwMFowSzELMAkGA1UEBhMCQ1oxDjAMBgNVBAcTBVByYWhhMRUwEwYDVQQK
# DAxKYWt1YiBKYXJlxaExFTATBgNVBAMMDEpha3ViIEphcmXFoTCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAKgBHbFhyeivpcxqohppsNGucvZvAyvg3gKT
# M1B6EpI18C6NN7FXWTPym9ffe1kS5ZeYDKW98NcOBArm28mdgip6WcUQ0qMt9lI8
# EsTa4Ohlkj/AYYUdgh96zgIl/V+MIO3JVAY3OwkWjkfDKVbzrNG5IcO5yKfwnt8/
# a238OS/VlFNsNELGW7XIQBD/rKrEDY8JZReIrkz6sGdba+3OcXBClp513JFniVgD
# vOXo2RDUqtnpFuCdsthe8hWXtpbcjIpFykLzNcNA+2GIbwbBG5XKXsN0ZJsbrWVA
# RiwNoDN+Fh3pe5rxGVfMDHdXt1I0KpJbFlGB4P7Sy2Mh5CTwRyUCAwEAAaOCAcUw
# ggHBMB8GA1UdIwQYMBaAFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBSw
# +E81VeF9HSgNxUARWWqXFWZrZjAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYI
# KwYBBQUHAwMwdwYDVR0fBHAwbjA1oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQu
# Y29tL3NoYTItYXNzdXJlZC1jcy1nMS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRp
# Z2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3MtZzEuY3JsMEwGA1UdIARFMEMwNwYJ
# YIZIAYb9bAMBMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNv
# bS9DUFMwCAYGZ4EMAQQBMIGEBggrBgEFBQcBAQR4MHYwJAYIKwYBBQUHMAGGGGh0
# dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBOBggrBgEFBQcwAoZCaHR0cDovL2NhY2Vy
# dHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hBMkFzc3VyZWRJRENvZGVTaWduaW5n
# Q0EuY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggEBAFltMO2WO9L/
# fLYIbzeQIilLoH97l9PYQAPz5uNh4R8l5w6Y/SgusY3+k+KaNONXSTcSL1KP9Pn3
# 2y11xqFwdrJbRxC8i5x2KFvGDGkvpDWFsX24plq5brRL+qerkyTwRgSRUiU/luvq
# BTYQ/eQmgikkIB6l7f6m2An8qtOkNfDM0D/eVJS3+/TRSMIPmBp9Ubktacp8sNIK
# JacAkVl1zjucvVhyuWOFsIFtPn25XsiNu4d87pUyMzm8Vehyl1xxLNH/6cqxCkyG
# FXCrav1knrz22qD5b8wrwUYnmCt37BeBX6KvpSXpafDdAok5QkPs7TeJVcVVPdb4
# tqaLNvGOpBgwggUwMIIEGKADAgECAhAECRgbX9W7ZnVTQ7VvlVAIMA0GCSqGSIb3
# DQEBCwUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAX
# BgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3Vy
# ZWQgSUQgUm9vdCBDQTAeFw0xMzEwMjIxMjAwMDBaFw0yODEwMjIxMjAwMDBaMHIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJ
# RCBDb2RlIFNpZ25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD407Mcfw4Rr2d3B9MLMUkZz9D7RZmxOttE9X/lqJ3bMtdx6nadBS63j/qSQ8Cl
# +YnUNxnXtqrwnIal2CWsDnkoOn7p0WfTxvspJ8fTeyOU5JEjlpB3gvmhhCNmElQz
# UHSxKCa7JGnCwlLyFGeKiUXULaGj6YgsIJWuHEqHCN8M9eJNYBi+qsSyrnAxZjNx
# PqxwoqvOf+l8y5Kh5TsxHM/q8grkV7tKtel05iv+bMt+dDk2DZDv5LVOpKnqagqr
# hPOsZ061xPeM0SAlI+sIZD5SlsHyDxL0xY4PwaLoLFH3c7y9hbFig3NBggfkOItq
# cyDQD2RzPJ6fpjOp/RnfJZPRAgMBAAGjggHNMIIByTASBgNVHRMBAf8ECDAGAQH/
# AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzB5BggrBgEF
# BQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBD
# BggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2Ny
# bDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDig
# NoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9v
# dENBLmNybDBPBgNVHSAESDBGMDgGCmCGSAGG/WwAAgQwKjAoBggrBgEFBQcCARYc
# aHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAKBghghkgBhv1sAzAdBgNVHQ4E
# FgQUWsS5eyoKo6XqcQPAYPkt9mV1DlgwHwYDVR0jBBgwFoAUReuir/SSy4IxLVGL
# p6chnfNtyA8wDQYJKoZIhvcNAQELBQADggEBAD7sDVoks/Mi0RXILHwlKXaoHV0c
# LToaxO8wYdd+C2D9wz0PxK+L/e8q3yBVN7Dh9tGSdQ9RtG6ljlriXiSBThCk7j9x
# jmMOE0ut119EefM2FAaK95xGTlz/kLEbBw6RFfu6r7VRwo0kriTGxycqoSkoGjpx
# KAI8LpGjwCUR4pwUR6F6aGivm6dcIFzZcbEMj7uo+MUSaJ/PQMtARKUT8OZkDCUI
# QjKyNookAv4vcn4c10lFluhZHen6dGRrsutmQ9qzsIzV6Q3d9gEgzpkxYz0IGhiz
# gZtPxpMQBvwHgfqL2vmCSfdibqFT+hKUGIUukpHqaGxEMrJmoecYpJpkUe8wggZq
# MIIFUqADAgECAhADAZoCOv9YsWvW1ermF/BmMA0GCSqGSIb3DQEBBQUAMGIxCzAJ
# BgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5k
# aWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTAe
# Fw0xNDEwMjIwMDAwMDBaFw0yNDEwMjIwMDAwMDBaMEcxCzAJBgNVBAYTAlVTMREw
# DwYDVQQKEwhEaWdpQ2VydDElMCMGA1UEAxMcRGlnaUNlcnQgVGltZXN0YW1wIFJl
# c3BvbmRlcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKNkXfx8s+CC
# NeDg9sYq5kl1O8xu4FOpnx9kWeZ8a39rjJ1V+JLjntVaY1sCSVDZg85vZu7dy4Xp
# X6X51Id0iEQ7Gcnl9ZGfxhQ5rCTqqEsskYnMXij0ZLZQt/USs3OWCmejvmGfrvP9
# Enh1DqZbFP1FI46GRFV9GIYFjFWHeUhG98oOjafeTl/iqLYtWQJhiGFyGGi5uHzu
# 5uc0LzF3gTAfuzYBje8n4/ea8EwxZI3j6/oZh6h+z+yMDDZbesF6uHjHyQYuRhDI
# jegEYNu8c3T6Ttj+qkDxss5wRoPp2kChWTrZFQlXmVYwk/PJYczQCMxr7GJCkawC
# wO+k8IkRj3cCAwEAAaOCAzUwggMxMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8E
# AjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMIIBvwYDVR0gBIIBtjCCAbIwggGh
# BglghkgBhv1sBwEwggGSMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2Vy
# dC5jb20vQ1BTMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAA
# bwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMA
# dABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgA
# ZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgA
# ZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4A
# dAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAA
# YQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIA
# ZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwDFTAf
# BgNVHSMEGDAWgBQVABIrE5iymQftHt+ivlcNK2cCzTAdBgNVHQ4EFgQUYVpNJLZJ
# Mp1KKnkag0v0HonByn0wfQYDVR0fBHYwdDA4oDagNIYyaHR0cDovL2NybDMuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0EtMS5jcmwwOKA2oDSGMmh0dHA6
# Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMHcG
# CCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
# Y29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGln
# aUNlcnRBc3N1cmVkSURDQS0xLmNydDANBgkqhkiG9w0BAQUFAAOCAQEAnSV+GzNN
# siaBXJuGziMgD4CH5Yj//7HUaiwx7ToXGXEXzakbvFoWOQCd42yE5FpA+94GAYw3
# +puxnSR+/iCkV61bt5qwYCbqaVchXTQvH3Gwg5QZBWs1kBCge5fH9j/n4hFBpr1i
# 2fAnPTgdKG86Ugnw7HBi02JLsOBzppLA044x2C/jbRcTBu7kA7YUq/OPQ6dxnSHd
# FMoVXZJB2vkPgdGZdA0mxA5/G7X1oPHGdwYoFenYk+VVFvC7Cqsc21xIJ2bIo4sK
# HOWV2q7ELlmgYd3a822iYemKC23sEhi991VUQAOSK2vCUcIKSK+w1G7g9BQKOhvj
# jz3Kr2qNe9zYRDCCBs0wggW1oAMCAQICEAb9+QOWA63qAArrPye7uhswDQYJKoZI
# hvcNAQEFBQAwZTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZ
# MBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNz
# dXJlZCBJRCBSb290IENBMB4XDTA2MTExMDAwMDAwMFoXDTIxMTExMDAwMDAwMFow
# YjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
# d3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBD
# QS0xMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6IItmfnKwkKVpYBz
# QHDSnlZUXKnE0kEGj8kz/E1FkVyBn+0snPgWWd+etSQVwpi5tHdJ3InECtqvy15r
# 7a2wcTHrzzpADEZNk+yLejYIA6sMNP4YSYL+x8cxSIB8HqIPkg5QycaH6zY/2DDD
# /6b3+6LNb3Mj/qxWBZDwMiEWicZwiPkFl32jx0PdAug7Pe2xQaPtP77blUjE7h6z
# 8rwMK5nQxl0SQoHhg26Ccz8mSxSQrllmCsSNvtLOBq6thG9IhJtPQLnxTPKvmPv2
# zkBdXPao8S+v7Iki8msYZbHBc63X8djPHgp0XEK4aH631XcKJ1Z8D2KkPzIUYJX9
# BwSiCQIDAQABo4IDejCCA3YwDgYDVR0PAQH/BAQDAgGGMDsGA1UdJQQ0MDIGCCsG
# AQUFBwMBBggrBgEFBQcDAgYIKwYBBQUHAwMGCCsGAQUFBwMEBggrBgEFBQcDCDCC
# AdIGA1UdIASCAckwggHFMIIBtAYKYIZIAYb9bAABBDCCAaQwOgYIKwYBBQUHAgEW
# Lmh0dHA6Ly93d3cuZGlnaWNlcnQuY29tL3NzbC1jcHMtcmVwb3NpdG9yeS5odG0w
# ggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAAdQBzAGUAIABvAGYAIAB0AGgA
# aQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAAYwBvAG4AcwB0AGkAdAB1AHQA
# ZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8AZgAgAHQAaABlACAARABpAGcA
# aQBDAGUAcgB0ACAAQwBQAC8AQwBQAFMAIABhAG4AZAAgAHQAaABlACAAUgBlAGwA
# eQBpAG4AZwAgAFAAYQByAHQAeQAgAEEAZwByAGUAZQBtAGUAbgB0ACAAdwBoAGkA
# YwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBpAGwAaQB0AHkAIABhAG4AZAAgAGEA
# cgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQAIABoAGUAcgBlAGkAbgAgAGIA
# eQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wCwYJYIZIAYb9bAMVMBIGA1UdEwEB/wQI
# MAYBAf8CAQAweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
# cC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgw
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwHQYDVR0OBBYEFBUAEisTmLKZB+0e36K+
# Vw0rZwLNMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3
# DQEBBQUAA4IBAQBGUD7Jtygkpzgdtlspr1LPUukxR6tWXHvVDQtBs+/sdR90OPKy
# XGGinJXDUOSCuSPRujqGcq04eKx1XRcXNHJHhZRW0eu7NoR3zCSl8wQZVann4+er
# Ys37iy2QwsDStZS9Xk+xBdIOPRqpFFumhjFiqKgz5Js5p8T1zh14dpQlc+Qqq8+c
# dkvtX8JLFuRLcEwAiR78xXm8TBJX/l/hHrwCXaj++wc4Tw3GXZG5D2dFzdaD7eeS
# DY2xaYxP+1ngIw/Sqq4AfO6cQg7PkdcntxbuD8O9fAqg7iwIVYUiuOsYGk38KiGt
# STGDR5V3cdyxG0tLHBCcdxTBnU8vWpUIKRAmMYIEOzCCBDcCAQEwgYYwcjELMAkG
# A1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRp
# Z2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENv
# ZGUgU2lnbmluZyBDQQIQAkpwj7JyQh8pn8abOhJIUDAJBgUrDgMCGgUAoHgwGAYK
# KwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
# BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU
# tI1liOZUbONpldmcupzXDzz0mHowDQYJKoZIhvcNAQEBBQAEggEAb5iEIVAskmtd
# EvSnnhntiOhz4ZXhU6EgvwROHte7R1r9fMucD/rMulafoqU/0uZGCyqMOFg0vt2i
# KWOL0P/cxQKoHkbU6fRVrQVX00aNPmxcaSVpd/Lqyj3m5fs69UwR6ggBsCPmfxuT
# Tt7xWjVfleTx/A1ONKNN00n+TXyZnrFcKJHGMepFuZFV+n6FT157GZ3BHSIeM6eX
# sE9ey2joE9IGzONlW3GycAoD4i6zgovlBdyn6B9kYSy3KuzImg10UWLXngqXedIx
# qXIlCoCuC1KdfW11szWLckQLuVdlmAtwGVzAv+pAHgtdeXyDBjjqyiiV5BvdjFvX
# z7j/mO31KqGCAg8wggILBgkqhkiG9w0BCQYxggH8MIIB+AIBATB2MGIxCzAJBgNV
# BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
# Y2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMQIQAwGa
# Ajr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3
# DQEHATAcBgkqhkiG9w0BCQUxDxcNMTkwOTA4MDg1NDAxWjAjBgkqhkiG9w0BCQQx
# FgQU+6BB3O6xUtiC2NiQWkZJjHoUv3MwDQYJKoZIhvcNAQEBBQAEggEAJY5p+TSM
# yqjoBf997gpWba90Qilp1q1X1uhdVMl2i1LZQugYVYEpPsSRLRr0IILQeB198QIX
# 8am3K2RTR+wsYwv6ggetREycaf2Ic9JunYJp3e1e6hsUw5NY4dPa5773ZjzgIbRp
# ThI+jMSb9t9csSTXjF8TP6xJyWuNfTnhiEp49cb1nnhmG9sqM8JxABIqABhIKF32
# /C8UXHize2622qua2qruZ2YTH3LVBV0Ooh/DzciaSKr4DjI4e5s3DPAOOK4P/9gM
# bCI3Wxk5o4kaLygYNigQPFGzgvbCGfr/J6X0/ocsqf80VVkns7c2BKtuK5N9sTzw
# J/39wjgZhysscQ==
# SIG # End signature block
