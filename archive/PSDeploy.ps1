    Deploy DeployMofs {
        By FileSystem {
            FromSource 'BuildOutput\MOF'
            To '\\pfnas\windows_iac$\dsc-vsphere\mof_files'
        }
    }