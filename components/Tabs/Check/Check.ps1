Add-Type -Assemblyname System.Windows.Forms
Add-Type -Assemblyname System.Drawing
#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------
function Invoke-CheckRequirements {
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
  Write-Host "Cancellazione $downloadExeFolder e creazione di una nuova cartella vuota..."
  if (Test-Path -Path $downloadExeFolder) { Remove-Item $downloadExeFolder -Recurse -Force }
  New-Item -Path $downloadExeFolder -ItemType Directory

  $backofficeProjectPath = "C:\dev\scarface\back-office"
  if (Test-Path $backofficeProjectPath) { Remove-Item -Path $backofficeProjectPath -Force -Recurse }
  New-StartupCmd
  
  $override = invoke-DownloadScarConfigJson
  Invoke-OverrideRequirement $override
  Invoke-ExecuteChecks

  $gridRequirements.Rows[0].Selected = $true
  gridRequirements_Click
  $installButton.Enabled = $true
}

function invoke-DownloadScarConfigJson() {
  <#
.SYNOPSIS
Download scarface.config.json
.DESCRIPTION
Download scarface.config.json
#>

  if ( Test-Path $scarConfigPath) { Remove-Item -Path $scarConfigPath -Force }
  New-Item -Path $scarConfigPath -Force | Out-Null

  Write-Host "Download $scarConfig in corso"
  $scarConfigObj = (Invoke-WebRequest -Uri $scarConfig -UseBasicParsing)
  Set-Content -Path $scarConfigPath -Value $scarConfigObj
  Write-Host "Download $scarConfig terminato"
  return ($scarConfigObj | ConvertFrom-Json).overrideRequirement
}

function Invoke-OverrideRequirement($override) {
  <#
.SYNOPSIS
Override custom json to Requirements
.DESCRIPTION
Override custom json to Requirements
#>

  if (!$override) { return $false }

  Write-Host "Download di $override in corso..."
  $overrideJson =  ((Invoke-WebRequest -Uri $override -UseBasicParsing).Content | ConvertFrom-Json | ConvertPSObjectToHashtable)
  if (!($overrideJson)) {
    Write-Host "Non è stato trovato alcun override"
    return
  }

  foreach ($name in $overrideJson.Keys) {
    foreach ($property in $overrideJson[$name].Keys) {
      $requirements[$name][$property] = $overrideJson[$name][$property]
    }
  }
}

function Invoke-ExecuteChecks {
  <#
.SYNOPSIS
Check if the Requirement was satisfied or not
.DESCRIPTION
For each Requirement it will check if it's satisfied or not,
if the Requirement isn't satisfied then add it to the list of Requirements that have to be satisfied through the installer
#>
  invoke-CreateLogs $checkLogs
  $red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
  $green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)

  foreach ($name in $sortedRequirements) {
    if (invoke-checkDependencies) {
      Write-Host $requirements[$name]["Check"]
      $result = $requirements[$name]["Check"] | Invoke-Expression
    }
    else {
      $result = "KO"
    }

    $checkLogs[$name]["Result"] = $result
    if ($result -eq 'OK') { 
      $requirements.Remove($name)
      Invoke-CreateRow $gridRequirements $name $green
    }
    else { 
      Invoke-CreateRow $gridRequirements $name $red
    }
  }
  
  ($checkLogs  | ConvertTo-Json) > $checkRequirementsLogFile
}

function invoke-checkDependencies {
  $dependenciesFailed = ""
  if (-not ($requirements[$name].Contains("Dependencies"))) { return $true }

  foreach ($dependency in $requirements[$name]["Dependencies"]) {
    if (($checkLogs[$dependency]["Result"] -ne "OK") -and ($checkLogs[$dependency]["Result"] -ne "VER")) {
      $dependenciesFailed += "`n$dependency"
    }
  }
  

  if ($dependenciesFailed) {
    $checkLogs[$name]["Logs"] = "KO A causa di: $dependenciesFailed"
    return $false
  }

  return $true

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

function selectedRequirement_SizeChanged() {
  $selectedRequirement.Left = 552 - ($selectedRequirement.Width / 2)
}

function tabRequirements_VisibleChanged {
  $gridRequirements.ClearSelection()
}

function gridRequirements_Click {
  if (-not $gridRequirements.Rows.Count) { return }
  $key = $gridRequirements.CurrentRow.Cells[0].Value
  if ($key -eq $selectedRequirement.Text) { return }  #Se si seleziona il requirement attualmente visualizzato, il click non caricherà nulla
  $selectedRequirement.Text = $key
  $outputRequirementsLabel.Text = ""
  $log = $(if (-not $checkLogs[$key]["Logs"]) { "Nessun log disponibile" } else { ($checkLogs[$key]["Logs"]).replace(";", [System.Environment]::NewLine).replace('\r\n', [System.Environment]::NewLine) })
  $outputRequirementsLabel.AppendText($log)
}

function installButton_Click {
  tabButton_Click($installationTabButton)
  Invoke-installRequirements
}