[CmdletBinding()]
param (
    [string]
    $BuildOutput = 'BuildOutput',

    [string]
    $ResourcesFolder = 'DscResources',

    [string]
    $ConfigDataFolder = 'DscConfigData',

    [String]
    $Environment = $(
        $branch = (&git @('rev-parse', '--abbrev-ref', 'HEAD'))
        $branch = if ($branch -eq 'master') { 'Prod' } else { 'Dev' }
        if (Test-Path -Path ".\$ConfigDataFolder\AllNodes\$branch") {
            $branch
        }
    ),

    [String]
    $RoleName,

    [string]
    $ConfigurationsFolder = 'DscConfigurations',

    [string]
    $TestFolder = 'Tests',

    [ScriptBlock]
    $Filter = {},

    [int]
    $MofCompilationTaskCount = 1,

    [string]
    $GalleryRepository = 'PSGallery',

    [uri]
    $GalleryProxy,
    
    [Parameter(Position = 0)]
    $Tasks,

    [switch]
    $ResolveDependency,

    [string]
    $ProjectPath,

    [switch]
    $DownloadResourcesAndConfigurations,

    [switch]
    $Help,

    [ScriptBlock]
    $TaskHeader = {
        Param($Path)
        ''
        '=' * 79
        Write-Build Cyan "`t`t`t$($Task.Name.Replace('_',' ').ToUpper())"
        Write-Build DarkGray "$(Get-BuildSynopsis $Task)"
        '-' * 79
        Write-Build DarkGray "  $Path"
        Write-Build DarkGray "  $($Task.InvocationInfo.ScriptName):$($Task.InvocationInfo.ScriptLineNumber)"
        ''
    }
)

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Add-Type -AssemblyName System.Threading
$m = [System.Threading.Mutex]::new($false, 'DscBuildProcessMutex')

if ($RoleName) {
    if ((Get-ChildItem -Path ".\$ConfigDataFolder\DSC_ConfigData\Roles" -Filter "$RoleName*" -ErrorAction SilentlyContinue)) {
        Write-Output "Role found with name $RoleName"
    }
    else {
        Write-Output "No role found with the given name $RoleName"
    }
}

$env:BHBuildStartTime = Get-Date
Write-Host "Current Process ID is '$PID'"

#changing the path is required to make PSDepend run without internet connection. It is required to download nutget.exe once first:
#Invoke-WebRequest -Uri 'https://aka.ms/psget-nugetexe' -OutFile C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet\nuget.exe -ErrorAction Stop
$pathElements = $env:Path -split ';'
$pathElements += 'C:\ProgramData\Microsoft\Windows\PowerShell\PowerShellGet'
$env:Path = $pathElements -join ';'

#cannot be a default parameter value due to https://github.com/PowerShell/PowerShell/issues/4688
if (-not $ProjectPath) {
    $ProjectPath = $PSScriptRoot
}

if (-not ([System.IO.Path]::IsPathRooted($BuildOutput))) {
    $BuildOutput = Join-Path -Path $ProjectPath -ChildPath $BuildOutput
}

$buildModulesPath = Join-Path -Path $BuildOutput -ChildPath 'Modules'
if (-not (Test-Path -Path $buildModulesPath)) {
    $null = mkdir -Path $buildModulesPath -Force
}

$configurationPath = Join-Path -Path $ProjectPath -ChildPath $ConfigurationsFolder
$resourcePath = Join-Path -Path $ProjectPath -ChildPath $ResourcesFolder
$configDataPath = Join-Path -Path $ProjectPath -ChildPath $ConfigDataFolder
$testsPath = Join-Path -Path $ProjectPath -ChildPath $TestFolder

$psModulePathElemets = $env:PSModulePath -split ';'
if ($buildModulesPath -notin $psModulePathElemets) {
    $env:PSModulePath = $psModulePathElemets -join ';'
    $env:PSModulePath += ";$buildModulesPath"
}

#importing all resources from .build directory
Get-ChildItem -Path "$PSScriptRoot/.build" -Recurse -Include *.ps1 |
    ForEach-Object {
    Write-Verbose "Importing file $($_.BaseName)"
    try {
        . $_.FullName
    }
    catch { }
}

if (-not (Get-Module -Name InvokeBuild -ListAvailable) -and -not $ResolveDependency) {
    Write-Error "Requirements are missing. Please call the script again with the switch 'ResolveDependency'"
    return
}

if ($ResolveDependency) {
    . $PSScriptRoot/.build/BuildHelpers/Resolve-Dependency.ps1
    Resolve-Dependency
}

if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1') {
    if ($ResolveDependency -or $PSBoundParameters['ResolveDependency']) {
        $PSBoundParameters.Remove('ResolveDependency')
        $PSBoundParameters['DownloadResourcesAndConfigurations'] = $true
    }

    if ($Help) {
        Invoke-Build ?
    }
    else {
        $PSBoundParameters.Remove('Tasks') | Out-Null
        Invoke-Build -Tasks $Tasks -File $MyInvocation.MyCommand.Path @PSBoundParameters

        if ($MofCompilationTaskCount -gt 1) {
            $global:splittedNodes = Split-Array -List $ConfigurationData.AllNodes -ChunkCount $MofCompilationTaskCount

            $mofCompilationTasks = foreach ($nodeSet in $global:splittedNodes) {
                $nodeNamesInSet = "'$($nodeSet.Name -join "', '")'"
                $filterString = '$_.NodeName -in {0}' -f $nodeNamesInSet
                $PSBoundParameters.Filter = [scriptblock]::Create($filterString)

                @{
                    File                    = $MyInvocation.MyCommand.Path
                    Task                    = 'WaitForMutex',
                    'TestDscResources',
                    'LoadDatumConfigData',
                    # 'CompileDatumRsop',
                    'CompileRootConfiguration' #,
                    #'CompileRootMetaMof'
                    Filter                  = [scriptblock]::Create($filterString)
                    MofCompilationTaskCount = $MofCompilationTaskCount
                    ProjectPath             = $ProjectPath
                    BuildOutput             = $buildOutput
                    ResourcesFolder         = $ResourcesFolder
                    ConfigDataFolder        = $ConfigDataFolder
                    ConfigurationsFolder    = $ConfigurationsFolder
                    TestFolder              = $TestFolder
                }
            }
            Build-Parallel $mofCompilationTasks
        }
    }

    if (($Tasks -contains 'CompileRootConfiguration' -or $Tasks -contains 'CompileRootMetaMof') -or -not $Tasks) {
        Invoke-Build -File "$ProjectPath\PostBuild.ps1"
    }

    $m.Dispose()
    Write-Host "Created $((Get-ChildItem -Path "$BuildOutput\MOF" -Filter *.mof).Count) MOF files in '$BuildOutput/MOF'" -ForegroundColor Green

    #Debug Output
    Write-Host "------------------------------------" -ForegroundColor Magenta
    Write-Host "PowerShell Variables" -ForegroundColor Magenta
    Get-Variable | Out-String | Write-Host -ForegroundColor Magenta
    Write-Host "------------------------------------" -ForegroundColor Magenta
    Write-Host "Environment Variables" -ForegroundColor Magenta
    Get-ChildItem env: | Out-String | Write-Host -ForegroundColor Magenta
    Write-Host "------------------------------------" -ForegroundColor Magenta
    
    return
}

if ($TaskHeader) {
    Set-BuildHeader $TaskHeader
}

if ($MofCompilationTaskCount -gt 1) {
    task . Init,
    CleanBuildOutput,
    SetPsModulePath,
    DownloadDependencies,
    TestConfigData,
    VersionControl,
    LoadDatumConfigData
}
else {
    if (-not $Tasks) {
        task . Init,
        CleanBuildOutput,
        SetPsModulePath,
        TestConfigData,
        VersionControl,
        LoadDatumConfigData,
        # CompileDatumRsop,
        TestDscResources,
        CompileRootConfiguration #,
        # CompileRootMetaMof
    }
    else {
        task . $Tasks
    }
}

Write-Host "Running the folling tasks:" -ForegroundColor Magenta
${*}.All[-1].Jobs | ForEach-Object { "`t$_" } | Write-Host
Write-Host
