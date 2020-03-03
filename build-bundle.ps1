param (
  # Tag of bundle host
  [Parameter(Position=0, Mandatory)]
  [string]
  $HostTag,
  # Name of bundle image
  [Parameter(Position=1)]
  [string]
  $ImageName,
  # Extra options for docker build
  [Parameter(ValueFromRemainingArguments)]
  [string[]]
  $Options
)
$ErrorActionPreference = 'Stop';

$imageName = (($ImageName, 'bundle') -ne $null)[0]
$options = $Options -join ' '

Write-Host 'Pull latest image of bundle host' -ForegroundColor Green
docker pull mcr.microsoft.com/windows/servercore:$HostTag

Write-Host ('Build {0}:pwsh' -f $imageName) -ForegroundColor Green
docker build -t ${imageName}:pwsh `
  --build-arg HOST_TAG=$HostTag `
  --build-arg BUNDLE_URL=https://github.com/PowerShell/PowerShell/releases/download/v6.2.4/PowerShell-6.2.4-win-x64.zip `
  --build-arg BUNDLE_DESTINATION=C:\pwsh `
  --build-arg VERIFY_COMMAND="pwsh -Version" `
  $options bundle

Write-Host ('Build {0}:java' -f $imageName) -ForegroundColor Green
docker build -t ${imageName}:java `
  --build-arg HOST_TAG=$HostTag `
  --build-arg BUNDLE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_x64_windows_8u242b08.zip `
  --build-arg BUNDLE_DESTINATION=C:\java `
  --build-arg BUNDLE_HOME=C:\java\bin `
  --build-arg ENVIRONMENT_VARIABLES="JAVA_HOME=C:\java\bin" `
  --build-arg VERIFY_COMMAND="java -version" `
  $options bundle
