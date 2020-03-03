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
# Not actually stop on local execution
$ErrorActionPreference = 'Stop';

$ImageName = if ($ImageName) { $ImageName } else { 'bundle' }
$Options = $Options -join ' '

Write-Host 'Pull latest image of bundle host' -ForegroundColor Green
docker pull mcr.microsoft.com/windows/servercore:$HostTag

$bundle = Get-Content '.\bundle.json' | ConvertFrom-Json
foreach ($item in $bundle.items) {
  $tag = '{0}:{1}-{2}' -f $ImageName, $item.name, $HostTag
  Write-Host ('Build {0}' -f $tag) -ForegroundColor Green

  $directory = '{0}' -f $item.directory
  $homeDirectory = '{0}' -f $item.home
  $url = '{0}' -f $item.url
  $verifyCommand = '{0}' -f $item.verify_command

  $sb = [System.Text.StringBuilder]::new()
  foreach ($var in $item.environment_variables) {
    if ($sb.Length) {
      [void]$sb.Append('|')
    }
    [void]$sb.AppendFormat('{0}={1}', $var.name, $var.value)
  }
  $environmentVariables = $sb.ToString()

  docker build -t $tag `
    --build-arg HOST_TAG=$HostTag `
    --build-arg BUNDLE_URL=$url `
    --build-arg BUNDLE_DESTINATION=$directory `
    --build-arg BUNDLE_HOME=$homeDirectory `
    --build-arg ENVIRONMENT_VARIABLES=$environmentVariables `
    --build-arg VERIFY_COMMAND=$verifyCommand `
    $Options bundle
}
