@{
    PSDependOptions              = @{
        AddToPath      = $true
        Target         = 'DSC_Resources'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'Artifactory_PowershellGallery'
            SkipPublisherCheck = $true
        }
    }

    xPSDesiredStateConfiguration = 'latest'
    xDSCResourceDesigner         = 'latest'
    'VMware.vSphereDSC'          = 'latest'
}
