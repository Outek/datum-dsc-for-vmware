# Script to import some Esxi Host configurations

param (
    [ValidateSet("Lab","NonProd","Prod")]
    [System.String]
    $Context = 'Lab',

    [System.Int16]
    $Nodes = 1,

    [System.String]
    $Role = 'vCenter',

    [System.String]
    $vCenterServer
)

if (!($vCenterServer)) {
    switch ($Context) {
        "Lab" {
            $vCenterServer = 'vcenter-lab.domain'
        }
        "NonProd"  {
            $vCenterServer = 'vcenter-nonprod.domain'
        }
        "Prod" {
            $vCenterServer = 'vcenter-prod.domain'
        }
    }
}

$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ParentScriptDir = Split-Path -Path $ScriptDir -Parent

$yml = @"
NodeName: 
Environment: 
Role: 
Description: 

vCenter:
    Server: 
    Name: 

PSDscAllowPlainTextPassword: True
PSDscAllowDomainUser: True
"@

$i = 1
do {
    $Nodename = $Context + "_vCenter" + $i
    $Content = $yml | ConvertFrom-Yaml
    $Content.nodename = $Nodename
    $Content.Role = $Context+'_'+$Role
    $Content.vCenter.Server = $vCenterServer
    $Content.vCenter.Name = $Nodename
    $Content.Description = 'This is a vCenter description'
    $Content.Environment = $Context
    Write-Output "Creating Server yaml file in path $ParentScriptDir\DSCConfigData\AllNodes\$Context"
    New-Item -Path $ParentScriptDir\DSCConfigData\AllNodes\$Context\$Nodename.yml -ItemType "file"  -Force
    ConvertTo-Yaml $Content | Set-Content $ParentScriptDir\DSCConfigData\AllNodes\$Context\$Nodename.yml -Force
    ++$i
}
until ($i -gt $Nodes)