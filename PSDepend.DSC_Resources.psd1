@{
    PSDependOptions              = @{
        AddToPath      = $true
        Target         = 'DSC_Resources'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
    }

    xPSDesiredStateConfiguration = 'latest'
    xDSCResourceDesigner         = 'latest'
    'VMware.vSphereDSC'          = 'latest'
}
