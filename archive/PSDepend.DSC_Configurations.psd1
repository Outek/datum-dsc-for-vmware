@{
    PSDependOptions = @{
        AddToPath      = $true
        Target         = 'DSC_Configurations'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository = 'PSGallery'
        }
    }

    CommonvSphereTasks = 'latest'
}
