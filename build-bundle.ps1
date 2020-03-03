param (
  # Tag of bundle host
  [Parameter(Position=0, Mandatory)]
  [string]
  $HostTag,
  # Extra options for docker build
  [Parameter(ValueFromRemainingArguments)]
  [string[]]
  $Options
)

$options = $Options -join ' '

Write-Host 'Pull latest image of bundle host' -ForegroundColor Green
docker pull mcr.microsoft.com/windows/servercore:$HostTag

Write-Host 'Build bundle:pwsh' -ForegroundColor Green
docker build -t bundle:pwsh `
  --build-arg HOST_TAG=$HostTag `
  --build-arg BUNDLE_URL=https://github.com/PowerShell/PowerShell/releases/download/v6.2.4/PowerShell-6.2.4-win-x64.zip `
  --build-arg BUNDLE_DESTINATION=C:\pwsh `
  --build-arg VERIFY_COMMAND="pwsh -Version" `
  $options bundle

Write-Host 'Build bundle:java' -ForegroundColor Green
docker build -t bundle:java `
  --build-arg HOST_TAG=$HostTag `
  --build-arg BUNDLE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_x64_windows_8u242b08.zip `
  --build-arg BUNDLE_DESTINATION=C:\java `
  --build-arg BUNDLE_HOME=C:\java\bin `
  --build-arg ENVIRONMENT_VARIABLES="JAVA_HOME=C:\java\bin" `
  --build-arg VERIFY_COMMAND="java -version" `
  $options bundle
