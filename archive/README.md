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

```powershell

[10:12] [189.39ms] D:\git\datum-dsc-for-vmware\Tools [origin/master]
PS> .\CreateHosts.ps1 -Context Lab -Nodes 10 -Role EsxHosts

```

```powershell

# Import all modules
 .\Build.ps1 -ResolveDependency

# Build your mof Files from your Lab Environment
 .\Build.ps1 -Environment Lab

# Build your mofs for a specific Role
 .\Build.ps1 -RoleName EsxHosts


```