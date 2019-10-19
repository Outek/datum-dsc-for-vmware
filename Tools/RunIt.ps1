Param (
    [Parameter( Mandatory = $True )]
    [ValidateSet("Labor","NonProd","Prod")]
    $Context
)

switch ($Context) {
    "Labor" {
        $Filter = "e1*"
    }
    "NonProd" {
        $Filter = "t1*"
    }
    "Prod" {
        $Filter = "p1*"
    }
}

$Filter = $Filter+".mof"

$Mofs = Get-ChildItem -Path $PSScriptPath -Filter e1*.mof -Recurse
Write-Output "Mofs found: $($Mofs.Count)"

foreach ($Mof in $Mofs) {
    if (!(Test-Path .\Temp)) {
        New-Item .\Temp -ItemType Directory
    }

    if (Test-Path .\Temp\localhost.mof) {
        Remove-Item .\Temp\localhost.mof -Force
    }

    Copy-Item $Mof.FullName .\Temp
    Rename-Item .\Temp\$Mof "localhost.mof"
    Start-DscConfiguration -Path .\Temp -Wait -Force
}
