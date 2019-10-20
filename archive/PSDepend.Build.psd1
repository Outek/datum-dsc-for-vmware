@{
    PSDependOptions   = @{
        AddToPath      = $true
        Target         = 'BuildOutput\Modules'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository = 'PSGallery'
        }
    }

    InvokeBuild       = 'latest'
    PSDeploy          = 'latest'
    BuildHelpers      = 'latest'
    Pester            = 'latest'
    PSScriptAnalyzer  = 'latest'
    DscBuildHelpers   = 'latest'
    Datum             = 'latest'
    'powershell-yaml' = 'latest'
}