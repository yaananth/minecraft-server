param (
  # Tag of bundle host
  [Parameter(Mandatory=$true)]
  [string]
  $HostTag
)

Write-Host 'Pull image of bundle host'
docker pull mcr.microsoft.com/windows/servercore:$HostTag

Write-Host 'Build bundle:pwsh'
docker build -t bundle:pwsh `
  --build-arg HOST_TAG=$HostTag `
  --build-arg BUNDLE_DESTINATION=C:\pwsh `
  --build-arg BUNDLE_URL=https://github.com/PowerShell/PowerShell/releases/download/v6.2.4/PowerShell-6.2.4-win-x64.zip `
  --build-arg VERIFY_COMMAND="pwsh -Version" `
  bundle

Write-Host 'Build bundle:java'
docker build -t bundle:java `
  --build-arg HOST_TAG=$HostTag `
  --build-arg BUNDLE_DESTINATION=C:\java `
  --build-arg BUNDLE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_x64_windows_8u242b08.zip `
  --build-arg VERIFY_COMMAND="java -version" `
  bundle
