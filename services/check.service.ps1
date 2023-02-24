Add-Type -Assemblyname System.Windows.Forms
Add-Type -Assemblyname System.Drawing
#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------
function Invoke-Main() {
  $debugPreference = 'Continue'
  $verbosePreference = 'Continue'
  $InformationPreference = 'Continue'
  Start-Transcript $logFilePath

  # Unlocks all the scripts needed for the installation
  foreach ($ps1File in Get-ChildItem *.ps1 -Recurse) {
    Unblock-File -Path $ps1File
  }

  # Create scar folder beforehand with download directory and delete previouses files inside of it
  $downloadExeFolder = "C:\dev\scarface\download"
  Write-Host "Removing $downloadExeFolder and Creating a new empty folder..."
  if (Test-Path -Path $downloadExeFolder) { Remove-Item $downloadExeFolder -Recurse -Force }
  New-Item -Path $downloadExeFolder -ItemType Directory

  $backofficeProjectPath = "C:\dev\scarface\back-office"
  if (Test-Path $backofficeProjectPath) { Remove-Item -Path $backofficeProjectPath -Force -Recurse }
  New-StartupCmd
  
  Invoke-OverrideRequirement
  Invoke-CheckRequirements
  $mainForm.Hide()
  $mainForm.ShowDialog()
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
    Write-Host "No override found"
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

  Write-Host "downloading $scarConfig"
  $overrideRequirement = (((Invoke-WebRequest -Uri $scarConfig -UseBasicParsing).Content) | ConvertFrom-Json).overrideRequirement
  if (!$overrideRequirement) { return $false }
  Write-Host "downloading " + $overrideRequirement
  return ((Invoke-WebRequest -Uri $overrideRequirement -UseBasicParsing).Content | ConvertFrom-Json | ConvertPSObjectToHashtable)
}

function Invoke-CheckRequirements {
  <#
.SYNOPSIS
Check if the Requirement was satisfied or not
.DESCRIPTION
For each Requirement it will check if it's satisfied or not,
if the Requirement isn't satisfied then add it to the list of Requirements that have to be satisfied through the installer
#>
  $sortedRequirements = @('WSL', 'Node.js', 'DotNet', 'Visual Studio', 'Visual Studio Code', 'Git', 'Setup CATools', 'NPM', 'Docker', 'Npm Login', 'Install CAEP', 'Execute Scarface')
  invoke-CreateRequirementsLogs
  $red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
  $green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)

  # List of Requirements that have to be executed, no matter what
  foreach ($name in $sortedRequirements) {
    Write-Host $requirements[$name]["CheckRequirement"]
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
  
  ($requirementsLogs  | ConvertTo-Json) > $checkRequirementsLogFile
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