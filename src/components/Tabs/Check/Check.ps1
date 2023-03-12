Add-Type -Assemblyname System.Windows.Forms
Add-Type -Assemblyname System.Drawing
#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------
function Invoke-CheckRequirements {
  $debugPreference = 'Continue'
  $verbosePreference = 'Continue'
  $InformationPreference = 'Continue'
  Start-Transcript $logFilePath

  # Unlocks all the scripts needed for the Install
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
  
  $override = invoke-DownloadScarConfigJson
  Invoke-OverrideRequirement $override
  Invoke-ExecuteChecks
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
  $overrideJson = ConvertPSObjectToHashtable ((Invoke-WebRequest -Uri $override -UseBasicParsing).Content | ConvertFrom-Json )
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

  foreach ($name in $sortedRequirements) {
    Invoke-CreateRow $gridRequirements $name
    $selectedCheck.Text = $name
    writeOutputRequirements($name)

    $requirement = $requirements[$name]
    $checkLogs[$name]["Result"] = $(if (invoke-Dependencies "CHECK" $requirement) { $requirement["Check"] | Invoke-Expression } else { "KO" })

    if ($checkLogs[$name]["Result"] -eq 'OK') { 
      $requirements.Remove($name)
      invoke-setColor $gridRequirements $green
    } 
    elseif ($checkLogs[$name]["Result"] -eq 'VER'){
      $requirements.Remove($name)
      invoke-setColor $gridRequirements $yellow
    }
    else { 
      invoke-setColor $gridRequirements $red
    }
  }
  
  ($checkLogs  | ConvertTo-Json) > $checkRequirementsLogFile
}

function selectedRequirement_SizeChanged() {
  $selectedCheck.Left = 552 - ($selectedCheck.Width / 2)
}

function tabRequirements_VisibleChanged {
  $gridRequirements.ClearSelection()
}

function gridRequirements_Click {
  if (-not $gridRequirements.Rows.Count) { return }
  $name = $gridRequirements.CurrentRow.Cells[0].Value
  if ($name -eq $selectedCheck.Text) { return }  #Se si seleziona il requirement attualmente visualizzato, il click non caricherà nulla
  $selectedCheck.Text = $name
  writeOutputRequirements($name)
}

function writeOutputRequirements($name) {
  $outputRequirementsLabel.Text = ""
  $mainForm.Refresh()
  $log = $(if (-not $checkLogs[$name]["Logs"]) { "Nessun log disponibile" } else { ($checkLogs[$name]["Logs"]).replace(";", [System.Environment]::NewLine).replace('\r\n', [System.Environment]::NewLine) })
  $outputRequirementsLabel.AppendText($log)
  $mainForm.Refresh()
}

function installButton_Click {
  tabButton_Click($InstallTabButton)
  Invoke-installRequirements
}

. .\src\components\Tabs\Check\Form.ps1