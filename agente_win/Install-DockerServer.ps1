Write-Host "Start Install docker"

Write-Host "Enabled Microsoft-Hyper-V"
# Ensure the feature is enabled (this was taken care of by the Docker Installer, but for completeness sake) ... 
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V, Containers -All -NoRestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Host "Enabled WSL"
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
#

Write-Host "Install-PackageProvider NuGet"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false -Verbose

# Para Instalar Docker
Write-Host "Install-Module DockerMsftProvider"
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force -Confirm:$false

Write-Host "Get-PackageProvider -ListAvailable"
Get-PackageProvider -ListAvailable

Write-Host "Get-PackageSource DockerMsftProvider"
Get-PackageSource -ProviderName DockerMsftProvider
# Set the TLS version used by the PowerShell client to TLS 1.2.
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

Write-Host "Install-Package docker"
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -Confirm:$false
#Write-Host "Start-Service Docker"
#Start-Service Docker

Write-Host "docker version"
docker version

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Install Docker-compose
Write-Host "Install Docker-compose"
Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Windows-x86_64.exe" -UseBasicParsing -OutFile $Env:ProgramFiles\Docker\docker-compose.exe

Write-Host "Finish Installation."

#Install Ubuntu WSL
Write-Host "Install Ubuntu WSL"
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing

#Rename-Item .\Ubuntu.appx .\Ubuntu.zip
#Expand-Archive .\Ubuntu.zip .\Ubuntu
#Add your Linux distribution path to the Windows environment PATH
Write-Host "SetEnvironmentVariable "
#$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
#[System.Environment]::SetEnvironmentVariable("PATH", $userenv + ";C:\setup\Ubuntu", "User")

Add-AppxPackage .\Ubuntu.appx 

# Write-Host "wsl set-default"
# wsl --set-default-version 2
# Write-Host "wsl install"
# wsl --install
# Write-Host "wsl abrir ubuntu"
# wsl -d Ubuntu-18.04 -u root