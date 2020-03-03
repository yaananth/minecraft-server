# escape=`

# Tag of executing host
# ltsc2019, ltsc2016, ...etc
ARG HOST_TAG=ltsc2019

FROM mcr.microsoft.com/windows/servercore:${HOST_TAG}

# URL that can download bundle archive
ARG BUNDLE_URL=https://github.com/PowerShell/PowerShell/releases/download/v6.2.4/PowerShell-6.2.4-win-x64.zip

# Directory that bundle should be installed to
ARG BUNDLE_DESTINATION=C:\bundle

# Directory that bundle binary located in
ARG BUNDLE_HOME

# List of key=value environment variable that delimited with |
ARG ENVIRONMENT_VARIABLES

# Command that is used to verify installation
ARG VERIFY_COMMAND="pwsh -Version"

SHELL [ "powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]

RUN $bundleHome = (($env:BUNDLE_HOME, $env:BUNDLE_DESTINATION) -ne $null)[0]; `
  $newPath = ('{0};{1}' -f $bundleHome, $env:PATH); `
  Write-Host ('Updating PATH: {0}' -f $newPath); `
  setx /M PATH $newPath; `
  `
  if ($env:ENVIRONMENT_VARIABLES) { `
    Write-Host 'Setting environmet variables ...'; `
    foreach ($item in ($env:ENVIRONMENT_VARIABLES -split '\|')) { `
      Write-Host ('  {0}' -f $item); `
      setx /M ($item -split '=', 2); `
    } `
  }

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
