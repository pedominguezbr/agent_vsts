# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/16/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2019.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    --add Microsoft.Net.Component.3.5.DeveloperTools `
    --add Microsoft.Net.ComponentGroup.4.8.DeveloperTools `
    --add Microsoft.Net.ComponentGroup.TargetingPacks.Common `
    --add Microsoft.VisualStudio.Component.TestTools.BuildTools `
    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.WinXP `
    --add Microsoft.VisualStudio.Workload.NodeBuildTools `
    --add Microsoft.VisualStudio.Component.TypeScript.4.3 `
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `    
    --add Microsoft.VisualStudio.Workload.WebBuildTools `
    --add Microsoft.VisualStudio.Workload.VCTools `
    --add Microsoft.VisualStudio.Workload.UniversalBuildTools `
    --add Microsoft.VisualStudio.Workload.MSBuildTools `
    --add Microsoft.VisualStudio.Workload.DataBuildTools

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install WebDeploy and NuGet with Chocolatey
RUN Install-PackageProvider -Name chocolatey -RequiredVersion 2.8.5.130 -Force; `
    Install-Package -Name nodejs.install -RequiredVersion 14.18.1 -Force; `
    Install-Package -Name webdeploy -RequiredVersion 3.6.20170627 -Force; `
    Install-Package nuget.commandline -RequiredVersion 6.0.0 -Force; 

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

#Download Azure DevOps agent 2.195.1
WORKDIR c:/setup
ADD https://vstsagentpackage.azureedge.net/agent/2.195.1/vsts-agent-win-x64-2.195.1.zip .

COPY InstallAgent.ps1 .
COPY ConfigureAgent.ps1 .

# Reset the shell.
SHELL ["cmd", "/S", "/C"]
RUN powershell -noexit "& "".\InstallAgent.ps1"""

# Configure agent on startup 
CMD powershell -noexit .\ConfigureAgent.ps1

