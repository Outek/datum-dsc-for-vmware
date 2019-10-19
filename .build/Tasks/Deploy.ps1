Task Deploy {
    Set-BuildEnvironment -VariableNamePrefix $null -ErrorAction SilentlyContinue
    $Params = @{
        Path    = "$PSScriptRoot\PSDeploy.ps1"
        Force   = $true
        Recurse = $false
        Verbose = $false
    }
    Invoke-PSDeploy @Params
}