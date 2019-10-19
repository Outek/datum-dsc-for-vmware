# Script to import some Esxi Host configurations

param (
    [ValidateSet("Lab","NonProd","Prod")]
    [System.String]
    $Context = 'Lab',

    [System.Int16]
    $Nodes = 1,

    [System.String]
    $Role = 'EsxHosts',

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

$i = 1
do {
    $Nodename = $Context + "_ESXiHost" + $i
    Copy-item $ParentScriptDir\Template\serverconfig.yml $ParentScriptDir\DSC_ConfigData\AllNodes\$Context\$Nodename.yml

    $Content = Get-Content $ParentScriptDir\DSC_ConfigData\AllNodes\$Context\$Nodename.yml -Raw | ConvertFrom-Yaml
    $Content.nodename = $Nodename
    $Content.Role = $Context+'_'+$Role
    $Content.EsxHost.Server = $vCenterServer
    $Content.EsxHost.Name = $Nodename
    $Content.Description = 'This is a ESXI Host description'
    $Content.Environment = $Context

    ConvertTo-Yaml $Content | Set-Content $ParentScriptDir\DSC_ConfigData\Allnodes\$Context\$Nodename.yml -force
    ++$i
}
until ($i -gt $Nodes)