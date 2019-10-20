task CompileRootConfiguration {

    $tid = [System.Threading.Thread]::CurrentThread.ManagedThreadId
    Start-Transcript -Path "$BuildOutput\Logs\CompileRootConfiguration$tid-Log.txt"

    try {
        $mofs = . (Join-Path -Path $ProjectPath -ChildPath 'RootConfiguration.ps1')
        if ($ConfigurationData.AllNodes.Count -ne $mofs.Count) {
            Write-Warning "Compiled MOF file count <> node count"
        }
        Write-Build Green "Successfully compiled $($mofs.Count) MOF files"
    }
    catch {
        Write-Build Red "ERROR OCCURED DURING COMPILATION: $($_.Exception.Message)"
        $relevantErrors = $Error | Where-Object {
            $_.Exception -isnot [System.Management.Automation.ItemNotFoundException]
        }
        $relevantErrors[0..2] | Out-String | ForEach-Object { Write-Warning $_ }
    }

    Stop-Transcript
    
}