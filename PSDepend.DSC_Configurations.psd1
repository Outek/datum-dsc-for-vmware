@{
    PSDependOptions = @{
        AddToPath      = $true
        Target         = 'DSC_Configurations'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository = 'Artifactory_PowershellGallery'
        }
    }

    vSpherePFDsc = 'latest'
}
