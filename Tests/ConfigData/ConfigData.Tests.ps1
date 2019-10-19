$here = $PSScriptRoot

$datumDefinitionFile = Join-Path $here ..\..\DSC_ConfigData\Datum.yml
$nodeDefinitions = Get-ChildItem $here\..\..\DSC_ConfigData\AllNodes -Recurse -Include *.yml
$environments = (Get-ChildItem $here\..\..\DSC_ConfigData\AllNodes -Directory).BaseName
$roleDefinitions = Get-ChildItem $here\..\..\DSC_ConfigData\Roles -Recurse -Include *.yml
$datum = New-DatumStructure -DefinitionFile $datumDefinitionFile
$configurationData = Get-FilteredConfigurationData -Environment $environment -Datum $datum -Filter $filter

$nodeNames = [System.Collections.ArrayList]::new()

Describe 'Datum Tree Definition' -Tag Integration {
    It 'Exists in DSC_ConfigData Folder' {
        Test-Path $datumDefinitionFile | Should -Be $true
    }

    $datumYamlContent = Get-Content $datumDefinitionFile -Raw
    It 'is Valid Yaml' {
        { $datumYamlContent | ConvertFrom-Yaml } | Should -Not -Throw
    }
}

Describe 'Node Definition Files' -Tag Integration {
    $nodeDefinitions.ForEach{
        # A Node cannot be empty
        $content = Get-Content -Path $_ -Raw

        if ($_.BaseName -ne 'AllNodes') {
            It "$($_.FullName) Should not be duplicated" {
                $nodeNames -contains $_.BaseName | Should -Be $false
            }
        }
        $null = $nodeNames.Add($_.BaseName)

        It "Should have a valid yaml file for $($_.Name)" {
            { $content | ConvertFrom-Yaml } | Should -Not -Throw
        }

        It "Should be in the right environment $($_.Name)" {
            $node = $content | ConvertFrom-Yaml
            $pathElements = $_.FullName.Split('\')
            $pathElements -contains $node.Environment | Should Be $true
        }
    }
}


Describe 'Roles Definition Files' -Tag Integration {
    $nodes = if ($Environment) {
        $configurationData.AllNodes | Where-Object { $_.NodeName -ne '*' -and $_.Environment -eq $Environment }
    }
    else {
        $configurationData.AllNodes | Where-Object { $_.NodeName -ne '*' }
    }

    $nodeRoles = $nodes | ForEach-Object -MemberName Role
    $usedRolesDefinitions = foreach ($nodeRole in $nodeRoles) {
        $roleDefinitions.Where( { $_.FullName -like "*$($nodeRole)*" })
    }

    $usedRolesDefinitions = $usedRolesDefinitions | Group-Object -Property FullName | ForEach-Object { $_.Group[0] }
    
    $usedRolesDefinitions.Foreach{
        $content = Get-Content -Path $_ -Raw
        if ($content) {
            It "Should have a valid yaml file for node $($_.FullName)" {
                { $null = $content | ConvertFrom-Yaml } | Should -Not -Throw
            }
        }
    }
}

Describe 'Role Composition' -Tag Integration {
    foreach ($environment in $environments) {
        Context "When environment $environment" {
            $nodes = if ($Environment) {
                $configurationData.AllNodes | Where-Object { $_.NodeName -ne '*' -and $_.Environment -eq $Environment }
            }
            else {
                $configurationData.AllNodes | Where-Object { $_.NodeName -ne '*' }
            }

            foreach ($node in $nodes) {
                It "Should have a valid Configurations Setting on node $($node.Name) (!`$null)" {
                    { Lookup Configurations -Node $node -DatumTree $datum } | Should -Not -Throw
                }
            }
        }
    }
}
