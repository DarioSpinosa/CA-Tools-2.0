Add-Type -Assemblyname System.Windows.Forms
Add-Type -Assemblyname System.Drawing
#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------
function Invoke-Main() {
  $debugPreference = 'Continue'
  $verbosePreference = 'Continue'
  $InformationPreference = 'Continue'
  New-Item -Path "~\.ca\$currentDate" -ItemType Directory
  Start-Transcript $logFilePath

  # Unlocks all the scripts needed for the installation
  foreach ($ps1File in Get-ChildItem *.ps1 -Recurse) {
    Unblock-File -Path $ps1File
  }

  # Create scar folder beforehand with download directory and delete previouses files inside of it
  $downloadExeFolder = "C:\dev\scarface\download\"
  Remove-Item $downloadExeFolder* -Recurse -Force
  if (!(Test-Path -Path $downloadExeFolder)) {
    Remove-Item 
    invoke-WriteRequirementsLogs("$downloadExeFolder not found. Creating it...")
    New-Item -Path $downloadExeFolder -ItemType Directory
  }

  #Resolve the Requirement's dependencies
  Resolve-Dependencies
  Invoke-OverrideRequirement
  Invoke-CheckRequirements
  $mainForm.Hide()
  $mainForm.ShowDialog()
  $backofficeProjectPath = "C:\dev\scarface\back-office"
  if (Test-Path $backofficeProjectPath) { Remove-Item -Path $backofficeProjectPath -Force -Recurse }
  New-StartupCmd
}

function Resolve-Dependencies() {
  foreach ($name in $requirements.Keys) {
    $dependencies = $requirements[$name]["Dependencies"]
    if ($dependencies.Count -eq 0) { break }
    $requirements[$name]["Dependencies"] = Resolve-SingleDependency $dependencies
  } 
}

function Resolve-SingleDependency($dependencies) {
  <#
.SYNOPSIS
Resolve the dependencies of all the Requirements
.DESCRIPTION
Creates a new list of Requirements with their dependencies resolved
#>
  $TempDependencies = $dependencies
  foreach ($dependency in $dependencies) {
    $resolvedDependecy = Resolve-SingleDependency $requirements[$dependency]["Dependencies"]
    if (!$TempDependencies.Contains($resolvedDependecy)) { $TempDependencies += $resolvedDependecy }
  }

  return $TempDependencies
}

function Invoke-OverrideRequirement() {
  <#
.SYNOPSIS
Override custom json to Requirements
.DESCRIPTION
Override custom json to Requirements
#>

  $overrideJson = DownloadScarConfigJson
  if (!($overrideJson)) {
    # invoke-WriteRequirementsLogs("No override found")
    return
  }

  foreach ($name in $overrideJson.Keys) {
    foreach ($Property in $overrideJson[$name].Keys) {
      $requirements[$name][$Property] = $overrideJson[$name][$Property]
    }
  }
}

function DownloadScarConfigJson() {
  <#
.SYNOPSIS
Download scarface.config.json
.DESCRIPTION
Download scarface.config.json
#>

  $scarConfigPath = "C:\dev\scarface\scarface.config.json"
  if ( Test-Path $scarConfigPath) { Remove-Item -Path $scarConfigPath -Force }
  New-Item -Path $scarConfigPath -Force | Out-Null

  # invoke-WriteRequirementsLogs("downloading $scarConfig")
  $overrideRequirement = (((Invoke-WebRequest -Uri $scarConfig -UseBasicParsing).Content) | ConvertFrom-Json).overrideRequirement
  if (!$overrideRequirement) { return $false }
  # invoke-WriteRequirementsLogs("downloading " + $overrideRequirement)
  return ((Invoke-WebRequest -Uri $overrideRequirement -UseBasicParsing).Content | ConvertFrom-Json | ConvertPSObjectToHashtable)
}

function Invoke-OrderRequirements {
  $dependenciesCount = @{}
  foreach ($name in $requirements.Keys) {
    $dependenciesCount.Add($name, $requirements[$name]["Dependencies"].Count)
  }

  $sortednames = @()
  foreach ($element in $dependenciesCount.GetEnumerator() | Sort-Object Value) {
    $sortednames += $element.name 
  }

  # [array]::Reverse($sortednames)
  return $sortednames
}

function Invoke-CheckRequirements {
  <#
.SYNOPSIS
Check if the Requirement was satisfied or not
.DESCRIPTION
For each Requirement it will check if it's satisfied or not,
if the Requirement isn't satisfied then add it to the list of Requirements that have to be satisfied through the installer
#>
  $sortedRequirements = Invoke-OrderRequirements
  invoke-CreateRequirementsLogs
  $red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
  $green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)

  # List of Requirements that have to be executed, no matter what
  foreach ($name in $sortedRequirements) {
    $result = $requirements[$name]["CheckRequirement"] | Invoke-Expression
    $requirementsLogs[$name]["Result"] = $result
    if ($result -eq 'OK') { 
      $requirements.Remove($name)
      Invoke-CreateRow $name $result $green
    }
    else{ 
      Invoke-CreateRow $name $result $red
    }
  }
  
  ($requirementsLogs  | ConvertTo-Json) > "~\.ca\$currentDate\requirementsLogs.json" 
  $installButton.visible = $true
}

function Invoke-CreateRow($name, $result, $color) {
  $row = New-Object System.Windows.Forms.DataGridViewRow
  $row.CreateCells($gridRequirements, @($name, $result))
  $row.DefaultCellStyle.BackColor = $color
  $gridRequirements.Rows.Add($row);
  $gridRequirements.ClearSelection()
}

function New-StartupCmd() {
  <#
.SYNOPSIS
Create a .cmd that will execute the CAEP installer at startup
.DESCRIPTION
Creates a .cmd that will execute the CAEP installer at startup until they won't complete it
#>

  $scriptArgs = "\`"$(Join-Path $(Get-Location) "caep-main.ps1")\`""

  if ($scarConfig) { $scriptArgs += " -ScarConfig " + $scarConfig }
  if ($scarVersion) { $scriptArgs += " -ScarVersion " + $scarVersion }

  if (!(Test-Path $startupPath)) {
    New-Item -Path $startupPath | Out-Null
    Add-Content -Path $startupPath -Value "start powershell -Command `"Start-Process powershell -verb runas -ArgumentList '-NoExit -file " + $scriptArgs + "'`""
  }
}

#--------------------------------------------------------[LOGIC]--------------------------------------------------------
Invoke-Main