# escape=`

# Tag of executing host
# ltsc2019, ltsc2016, ...etc
ARG HOST_TAG=ltsc2019

FROM mcr.microsoft.com/windows/servercore:${HOST_TAG}

# Directory that bundle should be installed to
ARG BUNDLE_DESTINATION=C:\bundle

# URL that can download bundle archive
ARG BUNDLE_URL=https://github.com/PowerShell/PowerShell/releases/download/v6.2.4/PowerShell-6.2.4-win-x64.zip

# Command that is used to verify installation
ARG VERIFY_COMMAND="pwsh -Version"

SHELL [ "powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

RUN $newPath = ('{0};{1}' -f $env:BUNDLE_DESTINATION, $env:PATH); `
	Write-Host ('Updating PATH: {0}' -f $newPath); `
	setx /M PATH $newPath

RUN Write-Host ('Downloading {0} ...' -f $env:BUNDLE_URL); `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest -UseBasicParsing -Uri $env:BUNDLE_URL -OutFile bundle.zip; `
    `
    Write-Host 'Expanding ...'; `
    New-Item -ItemType Directory -Path C:\temp | Out-Null; `
    Expand-Archive bundle.zip -DestinationPath C:\temp; `
    Move-Item -Path C:\temp\* -Destination $env:BUNDLE_DESTINATION; `
    Remove-Item C:\temp; `
    `
    Write-Host 'Removing ...'; `
    Remove-Item bundle.zip -Force; `
    `
    Write-Host 'Verifying install ...'; `
    Write-Host ('  {0}' -f $env:VERIFY_COMMAND); `
    Invoke-Expression -Command $env:VERIFY_COMMAND; `
    `
    Write-Host 'Complete.'
