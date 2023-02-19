param(
    [Diagnostics.Stopwatch]$timer
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Invoke-Main() {
  $DebugPreference = 'Continue'
  $VerbosePreference = 'Continue'
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
    invoke-writeOutputRequirements("$downloadExeFolder not found. Creating it...")
    New-Item -Path $downloadExeFolder -ItemType Directory
  }

  #Resolve the Requirement's dependencies
  Resolve-Dependencies
  Invoke-OverrideRequirement
  Invoke-LoadRequirementGrid
  $BackofficeProjectPath = "C:\dev\scarface\back-office"
  if (Test-Path $BackofficeProjectPath) { Remove-Item -Path $BackofficeProjectPath -Force -Recurse }
  New-StartupCmd
  $mainform.Visible = $false
  $mainform.ShowDialog()
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
    invoke-writeOutputRequirements("No override found")
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

  invoke-writeOutputRequirements("downloading $ScarConfig")
  $a = Invoke-WebRequest -Uri $ScarConfig -UseBasicParsing
  $overrideRequirement = (((Invoke-WebRequest -Uri $ScarConfig -UseBasicParsing).Content) | ConvertFrom-Json).overrideRequirement
  if (!$overrideRequirement) { return $false }
  invoke-writeOutputRequirements("downloading " + $overrideRequirement)
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
      $Requirements.Remove($Name)
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

  foreach ($Name in $RequirementsNotMet | Sort-Object) {
    Invoke-CreateRow  @($Name, "KO") $Red
  }

  foreach ($Name in $RequirementsMet | Sort-Object) {
    Invoke-CreateRow  @($Name, "OK") $Green
  }
  
  Button_MouseLeave($tabOutputRequirementsButton)
  Button_MouseEnter($tabRequirementsResultsButton)
  tabRequirementsResultsButton_Click
  Start-Sleep 5
  Button_MouseLeave($tabRequirementsResultsButton)
  Button_MouseEnter($tabOutputInstallationsButton)
  tabOutputInstallationsButton_Click
  . .\installation.ps1
}

function Invoke-CreateRow($Value, $Color) {
  $Row = New-Object System.Windows.Forms.DataGridViewRow
  $Row.CreateCells($gridRequirements, $Value)
  $Row.DefaultCellStyle.BackColor = $Color
  $gridRequirements.Rows.Add($Row);
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

function invoke-writeOutputRequirements($message){
  writeOutput $outputRequirementsLabel $message
}

function invoke-writeOutputInstallations($message){
  writeOutput $outputInstallationLabel $message
}

function writeOutput($label, $message){
  $label.AppendText("$message`r`n")
  $label.AppendText([System.Environment]::NewLine)
}

function tabRequirementsResultsButton_Click{
  $mainform.Controls.Remove($outputRequirementsLabel)
  $mainform.Controls.Remove($outputInstallationLabel)
  $mainform.Controls.Remove($gridInstallation)
  $mainform.Controls.AddRange($gridRequirements)
}

function tabOutputRequirementsButton_Click{
  $mainform.Controls.Remove($gridRequirements)
  $mainform.Controls.Remove($outputInstallationLabel)
  $mainform.Controls.Remove($gridInstallation)
  $mainform.Controls.Add($outputRequirementsLabel)
}

function tabOutputInstallationsButton_Click{
  $mainform.Controls.Remove($gridRequirements)
  $mainform.Controls.Remove($outputRequirementsLabel)
  $mainform.Controls.Remove($gridInstallation)
  $mainform.Controls.Add($outputInstallationLabel)
}

function tabInstallationsResultsButton_Click{
  $mainform.Controls.Remove($gridRequirements)
  $mainform.Controls.Remove($outputInstallationLabel)
  $mainform.Controls.Remove($outputRequirementsLabel)
  $mainform.Controls.Add($gridInstallation)
}

function Button_MouseEnter($button){
  $button.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")
  $button.ForeColor = "#000000"
}

function Button_MouseLeave ($button){
  $button.BackgroundImage = $null
  $button.ForeColor = "#ffffff"
}

#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------
. .\components\checkrequirements\Form.ps1
$mainform.Show()
Button_MouseEnter($tabOutputRequirementsButton)
Invoke-Main