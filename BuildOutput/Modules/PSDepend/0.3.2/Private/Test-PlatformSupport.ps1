﻿function Test-PlatformSupport {
    [cmdletbinding()]
    param(
        $Type,
        [string[]]$Support
    )

    # test core/full
    if('Core' -eq $PSVersionTable.PSEdition) {
        if($Support -notcontains 'core') {
            Write-Verbose "Supported platforms [$Support] for type [$Type] does not contain [core].  Pull requests welcome!"
            return $false
        }
    }
    else { # full windows powershell
        if($Support -notcontains 'windows') {
            Write-Verbose "Supported platforms [$Support] for type [$Type] does not contain [windows].  Pull requests welcome!"
            return $false
        }
    }

    if($IsLinux) {
        if($Support -notcontains 'linux') {
            Write-Verbose "Supported platforms [$Support] for type [$Type] does not contain [linux].  Pull requests welcome!"
            return $false
        }
    }
    if($IsMacOS) {
        if($Support -notcontains 'macos') {
            Write-Verbose "Supported platforms [$Support] for type [$Type] does not contain [macos].  Pull requests welcome!"
            return $false
        }
    }
    if($IsWindows) {
        # covers support for core powershell on windows
        if($Support -notcontains 'windows') {
            Write-Verbose "Supported platforms [$Support] for type [$Type] does not contain [windows].  Pull requests welcome!"
            return $false
        }
    }
    $true
}