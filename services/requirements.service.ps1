Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------
function Invoke-Main() {
  $debugPreference = 'Continue'
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
  $backofficeProjectPath = "C:\dev\scarface\back-office"
  if (Test-Path $backofficeProjectPath) { Remove-Item -Path $backofficeProjectPath -Force -Recurse }
  New-StartupCmd
}

function Resolve-Dependencies() {
  foreach ($Name in $requirements.Keys) {
    $dependencies = $requirements[$Name]["Dependencies"]
    if ($dependencies.Count -eq 0) { break }
    $requirements[$Name]["Dependencies"] = Resolve-SingleDependency $dependencies
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
    $ResolvedDependecy = Resolve-SingleDependency $requirements[$dependency]["Dependencies"]
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
      $requirements[$Name][$Property] = $overrideJson[$Name][$Property]
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
  $overrideRequirement = (((Invoke-WebRequest -Uri $ScarConfig -UseBasicParsing).Content) | ConvertFrom-Json).overrideRequirement
  if (!$overrideRequirement) { return $false }
  invoke-writeOutputRequirements("downloading " + $overrideRequirement)
  return ((Invoke-WebRequest -Uri $overrideRequirement -UseBasicParsing).Content | ConvertFrom-Json | ConvertPSObjectToHashtable)
}

function Invoke-OrderRequirements {
  $dependenciesCount = @{}
  foreach ($Name in $requirements.Keys) {
    $dependenciesCount.Add($Name, $requirements[$Name]["Dependencies"].Count)
  }

  $SortedNames = @()
  foreach ($element in $dependenciesCount.GetEnumerator() | Sort-Object Value) {
    $SortedNames += $element.Name 
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
  $requirementsNotMet = @()
  $requirementsMet = @()
  # List of Requirements that have to be executed, no matter what
  foreach ($Name in $SortedRequirements) {
    if (!$requirements[$Name]["CheckRequirement"]) { break }
    $result = $requirements[$Name]["CheckRequirement"] | Invoke-Expression
    $requirements[$Name].Add("Result", $result)
    if ($result -eq 'OK') { 
      $requirements.Remove($Name)
      $requirementsMet += $Name 
    }
    else{
      $requirementsNotMet += $Name 
    }
  }

  return @($requirementsNotMet, $requirementsMet)
}

function Invoke-LoadRequirementGrid {
  <#
.SYNOPSIS
Show on the GUI, each Requirement and their status
.DESCRIPTION
Shows each Requirement and their status that indicates if they were satisfied (OK) or not satisfied (KO) on the GUI
#>
  $Lists = Invoke-CheckRequirements
  $requirementsNotMet = @()
  $requirementsMet = @()
  $requirementsNotMet += $Lists[0]
  $requirementsMet += $Lists[1]
  $Red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
  $green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)

  foreach ($Name in $requirementsNotMet | Sort-Object) {
    Invoke-CreateRow  @($Name, $requirements[$name]["Result"]) $Red
  }

  foreach ($Name in $requirementsMet | Sort-Object) {
    Invoke-CreateRow  @($Name, "OK") $green
  }
  
  Button_MouseLeave($tabOutputRequirementsButton)
  Button_MouseEnter($tabRequirementsResultsButton)
  tabButton_Click($gridRequirements)
  $installButton.visible = $true
}

function Invoke-CreateRow($Value, $color) {
  $Row = New-Object System.Windows.Forms.DataGridViewRow
  $Row.CreateCells($gridRequirements, $Value)
  $Row.DefaultCellStyle.BackColor = $color
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

#--------------------------------------------------------[LOGIC]--------------------------------------------------------
Invoke-Main