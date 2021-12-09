# escape=`
#FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019
FROM mcr.microsoft.com/windows/servercore:ltsc2019 

#Install AzCli
RUN Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; `
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; `
    Remove-Item -Path .\AzureCLI.msi;
    
# # Set up environment to collect install errors.
# COPY Install.cmd C:\TEMP\
# ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# # # Download channel for fixed install.
# ARG CHANNEL_URL=https://aka.ms/vs/16/release/channel
# ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# # Download and install Build Tools for Visual Studio 2019.
# ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
# RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
#     --channelUri C:\TEMP\VisualStudio.chman `
#     --installChannelUri C:\TEMP\VisualStudio.chman `
#     --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
#     --add Microsoft.Net.Component.3.5.DeveloperTools `
#     --add Microsoft.Net.ComponentGroup.4.8.DeveloperTools `
#     --add Microsoft.Net.ComponentGroup.TargetingPacks.Common `
#     --add Microsoft.VisualStudio.Component.TestTools.BuildTools `
#     --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.WinXP `
#     --add Microsoft.VisualStudio.Workload.NodeBuildTools `
#     --add Microsoft.VisualStudio.Component.TypeScript.4.3 `
#     --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `    
#     --add Microsoft.VisualStudio.Workload.WebBuildTools `
#     --add Microsoft.VisualStudio.Workload.VCTools `
#     --add Microsoft.VisualStudio.Workload.UniversalBuildTools `
#     --add Microsoft.VisualStudio.Workload.MSBuildTools `
#     --add Microsoft.VisualStudio.Workload.DataBuildTools

# SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install Chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


# Install node, WebDeploy and NuGet with Chocolatey
RUN choco install nodejs.install --version=14.18.1 -y --force; `
    choco install webdeploy --version=3.6.20170627 -y --force --ignore-checksums; `
    choco install python --version=3.10.0 -y --force; `
    choco install git -y --force; `
    choco install openjdk --version=15.0.2 -y --force; `
    choco install terraform --version=1.0.11 -y --force; `
    choco install kubernetes-cli -y --force; `
    choco install nuget.commandline --version=6.0.0 -y --force; 

#Install AzCli
RUN Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; `
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; `
    Remove-Item -Path .\AzureCLI.msi;

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 3.1.415

RUN Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$Env:DOTNET_SDK_VERSION/dotnet-sdk-$Env:DOTNET_SDK_VERSION-win-x64.zip; `
    $dotnet_sha512 = '4b4a58a77d052a0a9b585feaefa782dce278bbb0f3de20c71f08762269bdbfe44e18ab8600295146c9b422cf7d9c131fd8b5f43025a15efbb219b4355801963d'; `
    if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Expand-Archive dotnet.zip -force -DestinationPath $Env:ProgramFiles\dotnet; `
    Remove-Item -Force dotnet.zip

RUN setx /M PATH $($Env:PATH + ';' + $Env:ProgramFiles + '\dotnet')

# Download Azure DevOps agent 2.195.1
WORKDIR c:/setup
ADD https://vstsagentpackage.azureedge.net/agent/2.195.1/vsts-agent-win-x64-2.195.1.zip .

COPY InstallAgent.ps1 .
COPY Install-DockerServer.ps1 .
COPY ConfigureAgent.ps1 .

# Reset the shell.
SHELL ["cmd", "/S", "/C"]
RUN powershell -noexit "& "".\Install-DockerServer.ps1"""

RUN powershell -noexit "& "".\InstallAgent.ps1"""

# Configure agent on startup 
CMD powershell -noexit .\ConfigureAgent.ps1

