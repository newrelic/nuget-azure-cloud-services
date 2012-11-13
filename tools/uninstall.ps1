param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath NewRelicHelper.psm1)

Write-Host "***Cleaning up the Windows Azure ServiceDefinition.csdef ***"
cleanup_azure_service_config $project

Write-Host "***Cleaning up the project's .config file ***"
cleanup_project_config $project