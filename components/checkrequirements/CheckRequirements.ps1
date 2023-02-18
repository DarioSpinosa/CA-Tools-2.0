Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Invoke-Main() {
  $DebugPreference = 'Continue'
  $VerbosePreference = 'Continue'
  $InformationPreference = 'Continue'
  New-Item -Path $ "~\.ca\$currentDate" -ItemType Directory
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
    writeText("$downloadExeFolder not found. Creating it...")
    New-Item -Path $downloadExeFolder -ItemType Directory
  }

  #Resolve the Requirement's dependencies
  Resolve-Dependencies
  Invoke-OverrideRequirement
  Invoke-LoadRequirementGrid
  $BackofficeProjectPath = "C:\dev\scarface\back-office"
  if (Test-Path $BackofficeProjectPath) { Remove-Item -Path $BackofficeProjectPath -Force -Recurse }
  New-StartupCmd
  $InstallForm.Visible = $false
  $InstallForm.ShowDialog()
}

function Resolve-Dependencies() {
  foreach ($Name in $Requirements.Keys) {
    $Dependencies = $Requirements[$Name]["Dependencies"]
    if ($Dependencies.Count -eq 0) { break }
    $Requirements[$Name]["Dependencies"] = Resolve-SingleDependency $Dependencies
  } 
}

function Resolve-SingleDependency($Dependencies) {
  <#
.SYNOPSIS
Resolve the dependencies of all the Requirements
.DESCRIPTION
Creates a new list of Requirements with their dependencies resolved
#>
  $TempDependencies = $Dependencies
  foreach ($Dependency in $Dependencies) {
    $ResolvedDependecy = Resolve-SingleDependency $Requirements[$Dependency]["Dependencies"]
    if (!$TempDependencies.Contains($ResolvedDependecy)) { $TempDependencies += $ResolvedDependecy }
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
    writeText("No override found")
    return
  }

  foreach ($Name in $overrideJson.Keys) {
    foreach ($Property in $overrideJson[$Name].Keys) {
      $Requirements[$Name][$Property] = $overrideJson[$Name][$Property]
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

  writeText("downloading $ScarConfig")
  $overrideRequirement = (((Invoke-WebRequest -Uri $ScarConfig -UseBasicParsing).Content) | ConvertFrom-Json).overrideRequirement
  if (!$overrideRequirement) { return $false }
  writeText("downloading " + $overrideRequirement)
  return ((Invoke-WebRequest -Uri $overrideRequirement -UseBasicParsing).Content | ConvertFrom-Json | ConvertPSObjectToHashtable)
}

function Invoke-OrderRequirements {
  $DependenciesCount = @{}
  foreach ($Name in $Requirements.Keys) {
    $DependenciesCount.Add($Name, $Requirements[$Name]["Dependencies"].Count)
  }

  $SortedNames = @()
  foreach ($Element in $DependenciesCount.GetEnumerator() | Sort-Object Value) {
    $SortedNames += $Element.Name 
  }

  [array]::Reverse($SortedNames)
  return $SortedNames
}

function Invoke-CheckRequirements {
  <#
.SYNOPSIS
Check if the Requirement was satisfied or not
.DESCRIPTION
For each Requirement it will check if it's satisfied or not,
if the Requirement isn't satisfied then add it to the list of Requirements that have to be satisfied through the installer
#>
  $SortedRequirements = Invoke-OrderRequirements
  $RequirementsNotMet = @()
  $RequirementsMet = @()
  # List of Requirements that have to be executed, no matter what
  foreach ($Name in $SortedRequirements) {
    if (!$Requirements[$Name]["CheckRequirement"]) { break }
    $Result = $Requirements[$Name]["CheckRequirement"] | Invoke-Expression
    if (!$Result[0] -or $Result[1] -eq 'KO') { 
      $RequirementsNotMet += $Name 
    }
    else{
      $RequirementsMet += $Name
    }
  }

  return @($RequirementsNotMet, $RequirementsMet)
}

function Invoke-LoadRequirementGrid {
  <#
.SYNOPSIS
Show on the GUI, each Requirement and their status
.DESCRIPTION
Shows each Requirement and their status that indicates if they were satisfied (OK) or not satisfied (KO) on the GUI
#>
  $Lists = Invoke-CheckRequirements
  $RequirementsNotMet = @()
  $RequirementsMet = @()
  $RequirementsNotMet += $Lists[0]
  $RequirementsMet += $Lists[1]
  $Red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
  $Green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)

  foreach ($Name in $RequirementsNotMet) {
    Invoke-CreateRow  @($Name, "KO") $Red
  }

  foreach ($Name in $RequirementsMet) {
    Invoke-CreateRow  @($Name, "OK") $Green
  }
}

function Invoke-CreateRow($Value, $Color) {
  $Row = New-Object System.Windows.Forms.DataGridViewRow
  $Row.CreateCells($DataGrid, $Value)
  $Row.DefaultCellStyle.BackColor = $Color
  $DataGrid.Rows.Add($Row);
}
function New-StartupCmd() {
  <#
.SYNOPSIS
Create a .cmd that will execute the CAEP installer at startup
.DESCRIPTION
Creates a .cmd that will execute the CAEP installer at startup until they won't complete it
#>

  $ScriptArgs = "\`"$(Join-Path $(Get-Location) "caep-main.ps1")\`""

  if ($ScarConfig) { $ScriptArgs += " -ScarConfig " + $ScarConfig }
  if ($ScarVersion) { $ScriptArgs += " -ScarVersion " + $ScarVersion }

  if (!(Test-Path $StartupPath)) {
    New-Item -Path $StartupPath | Out-Null
    Add-Content -Path $StartupPath -Value "start powershell -Command `"Start-Process powershell -verb runas -ArgumentList '-NoExit -file " + $ScriptArgs + "'`""
  }
}

function writeText($Message){
  $OutputLabel.AppendText("$Message`r`n")
}

function tabCheckRequirementsResultsButton_Click{
  $InstallForm.Controls.Remove($OutputLabel)
  $InstallForm.Controls.Add($DataGrid)
}

function tabOutputButton_Click{
  $InstallForm.Controls.Remove($DataGrid)
  $InstallForm.Controls.Add($OutputLabel)
}

#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------
. .\components\checkrequirements\Form.ps1
$InstallForm.Show()
Invoke-Main