@{
    PSDependOptions = @{
        AddToPath      = $true
        Target         = 'DscConfigurations'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository = 'PSGallery'
        }
    }

    CommonvSphereTasks = 'latest'
}
