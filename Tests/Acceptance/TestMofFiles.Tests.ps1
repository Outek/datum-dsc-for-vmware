$here = $PSScriptRoot

$datumDefinitionFile = Join-Path $here ..\..\DSC_ConfigData\Datum.yml
$nodeDefinitions = Get-ChildItem $here\..\..\DSC_ConfigData\AllNodes -Recurse -Include *.yml
$environments = (Get-ChildItem $here\..\..\DSC_ConfigData\AllNodes -Directory).BaseName
$roleDefinitions = Get-ChildItem $here\..\..\DSC_ConfigData\Roles -Recurse -Include *.yml
$datum = New-DatumStructure -DefinitionFile $datumDefinitionFile
$configurationData = Get-FilteredConfigurationData -Environment $environment -Datum $datum -Filter $filter

$nodeNames = [System.Collections.ArrayList]::new()

Describe 'Pull Server Deployment' -Tag BuildAcceptance, PullServer {

    $environmentNodes = $configurationData.AllNodes | Where-Object Environment -eq $env:RELEASE_ENVIRONMENTNAME

    foreach ($node in $environmentNodes) {
        It "MOF file for node $($node.NodeName) was deployed to $($env:DscConfiguration)" {
        
            Get-ChildItem -Path $env:DscConfiguration -Filter "$($node.NodeName).mof" | Select-String -Pattern ">>$($env:BHBuildNumber)<<" | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'MOF Files' -Tag BuildAcceptance {
    BeforeAll {
        $mofFiles = Get-ChildItem -Path "$buildOutput\MOF" -Filter *.mof
        $metaMofFiles = Get-ChildItem -Path "$buildOutput\MetaMOF" -Filter *.mof
        $nodes = $configurationData.AllNodes
    }

    It 'All nodes have a MOF file' {
        Write-Verbose "MOF File Count $($mofFiles.Count)"
        Write-Verbose "Node Count $($nodes.Count)"
        $mofFiles.Count | Should -Be $nodes.Count
    }

    foreach ($node in $nodes) {
        It "Node '$($node.NodeName)' should have a MOF file" {
            $mofFiles | Where-Object BaseName -eq $node.NodeName | Should -BeOfType System.IO.FileSystemInfo 
        }
    }

    if ($metaMofFiles) {
        It 'All nodes have a Meta MOF file' {
            Write-Verbose "Meta MOF File Count $($metaMofFiles.Count)"
            Write-Verbose "Node Count $($nodes.Count)"
    
            $metaMofFiles.Count | Should -BeIn $nodes.Count
        }

        foreach ($node in $nodes) {
            It "Node '$($node.NodeName)' should have a Meta MOF file" {       
                $metaMofFiles | Where-Object BaseName -eq "$($node.NodeName).meta" | Should -BeOfType System.IO.FileSystemInfo 
            }
        }
    }
}