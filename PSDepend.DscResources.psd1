@{
    PSDependOptions              = @{
        AddToPath      = $true
        Target         = 'DscResources'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository = 'PSGallery'
        }
    }

    xPSDesiredStateConfiguration = 'latest'
    xDSCResourceDesigner         = 'latest'
    'VMware.vSphereDSC'          = 'latest'
}
