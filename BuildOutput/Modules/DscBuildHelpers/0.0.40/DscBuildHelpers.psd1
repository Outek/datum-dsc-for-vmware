@{
    RootModule        = 'DscBuildHelpers.psm1'

    ModuleVersion     = '0.0.40'

    GUID              = '23ccd4bf-0a52-4077-986f-c153893e5a6a'

    Author            = 'Gael Colas'

    Copyright         = '(c) 2017 Gael Colas. All rights reserved.'

    Description       = 'Build Helpers for DSC Resources and Configurations'

    PowerShellVersion = '5.0'

    RequiredModules = @(
        @{ ModuleName = 'xDscResourceDesigner'; ModuleVersion = '1.9.0.0'} #tested with 1.9.0.0
    )

    ScriptsToProcess = @('.\ScriptsToProcess\Get-DscSplattedResource.ps1')

    FunctionsToExport = @('Clear-CachedDscResource','Compress-DscResourceModule','Find-ModuleToPublish','Get-DscFailedResource','Get-DscResourceFromModuleInFolder','Get-DscResourceWmiClass','Get-DscSplattedResource','Get-ModuleFromFolder','Publish-DscConfiguration','Publish-DscResourceModule','Push-DscConfiguration','Push-DscModuleToNode','Remove-DscResourceWmiClass','Test-DscResourceFromModuleInFolderIsValid')
}
