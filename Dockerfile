# escape=`

# ltsc2019, ltsc2016, ...etc
ARG TAG=ltsc2019

FROM mcr.microsoft.com/windows/servercore:${TAG} AS pwsh

SHELL [ "powershell", "-c", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

ENV PWSH_HOME C:\pwsh
ENV PWSH_URL https://github.com/PowerShell/PowerShell/releases/download/v6.2.4/PowerShell-6.2.4-win-x64.zip

RUN $newPath = ('{0};{1}' -f $env:PWSH_HOME, $env:PATH); `
	Write-Host ('Updating PATH: {0}' -f $newPath); `
	setx /M PATH $newPath

RUN Write-Host ('Downloading {0} ...' -f $env:PWSH_URL); `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest -UseBasicParsing -Uri $env:PWSH_URL -OutFile pwsh.zip; `
    `
    Write-Host 'Expanding ...'; `
    New-Item -ItemType Directory -Path C:\temp | Out-Null; `
    Expand-Archive pwsh.zip -DestinationPath C:\temp; `
    Move-Item -Path C:\temp\* -Destination $env:PWSH_HOME; `
    Remove-Item C:\temp; `
    `
    Write-Host 'Removing ...'; `
    Remove-Item pwsh.zip -Force; `
    `
    Write-Host 'Verifying install ...'; `
    Write-Host '  pwsh -Version'; pwsh -Version; `
    `
    Write-Host 'Complete.'

SHELL [ "pwsh", "-c", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]


FROM pwsh AS java

ENV JAVA_HOME C:\openjdk
ENV JAVA_URL https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jre_x64_windows_8u242b08.zip

RUN $newPath = ('{0}\bin;{1}' -f $env:JAVA_HOME, $env:PATH); `
	Write-Host ('Updating PATH: {0}' -f $newPath); `
	setx /M PATH $newPath

RUN Write-Host ('Downloading {0} ...' -f $env:JAVA_URL); `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest -Uri $env:JAVA_URL -OutFile openjdk.zip; `
    `
    Write-Host 'Expanding ...'; `
    New-Item -ItemType Directory -Path C:\temp | Out-Null; `
    Expand-Archive openjdk.zip -DestinationPath C:\temp; `
    Move-Item -Path C:\temp\* -Destination $env:JAVA_HOME; `
    Remove-Item C:\temp; `
    `
    Write-Host 'Removing ...'; `
    Remove-Item openjdk.zip -Force; `
    `
    Write-Host 'Verifying install ...'; `
    Write-Host '  java -version'; java -version; `
    `
    Write-Host 'Complete.'

