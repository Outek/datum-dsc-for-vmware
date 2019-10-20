# Datum-Dsc-for-VMware

This project is heavily borowed or 'inspired' from here:

[DSC Workshop](https://github.com/AutomatedLab/DscWorkshop)

[Automated Lab](https://github.com/AutomatedLab/AutomatedLab)

[datum](https://github.com/gaelcolas/datum)

[DSC Infra sample](https://github.com/gaelcolas/DscInfraSample)

## Datum

Datum is a PowerShell module used to aggregate DSC configuration data from multiple sources allowing you to define generic information (Roles) and specific overrides (i.e. per Node, Location, Environment) without repeating yourself.

A Sample repository of an Infrastructure, managed from code using Datum is available in the DscInfraSample project, along with more explanations of its usage and the recommended Control repository layout

## VMWare.vSphere

## Note

It is a small PoC to show the benefits with Datum and Infrastructure as Code.

## Usage

You can build some Node Configurations with the script in Tools / CreateHosts.ps1

```Powershell

[10:12] [189.39ms] .\datum-dsc-for-vmware\Tools [origin/master]
PS> .\CreateHosts.ps1 -Context Lab -Nodes 10 -Role EsxHosts

```

## Steps to build your Mof Files

```Powershell
# 1. Import all modules and Dependencies
 .\Build.ps1 -ResolveDependency

# 2. Build some Test Hosts to generate configurations
 .\Tools\CreateHosts.ps1 -Context Lab -Nodes 10
 .\Tools\CreateHosts.ps1 -Context NonProd -Nodes 10
 .\Tools\CreateHosts.ps1 -Context Prod -Nodes 10

# 3a. Build your mof Files from your Lab Environment
 .\Build.ps1 -Environment Lab

# 3b. Build your mof for a specific Role
 .\Build.ps1 -RoleName Lab_EsxHosts

# 3c. or build'em all!
 .\Build.ps1

```
