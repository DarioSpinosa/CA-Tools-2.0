param(
  [Diagnostics.Stopwatch]$timer
)

function selectedRequirement_SizeChanged(){
  $selectedRequirement.Left = 607 - ($selectedRequirement.Width / 2)
}

function invoke-writeOutputRequirements($message, $newLine) {
  writeOutput $outputRequirementsLabel $message $newLine
}

function invoke-writeOutputInstallations($message, $newLine) {
  writeOutput $outputInstallationLabel $message $newLine
}

function writeOutput($label, $message, $newLine) {
  $label.AppendText("$message`r`n")
  if ($newLine) { $label.AppendText([System.Environment]::NewLine) }
}

function tabButton_Click($newTab) {
  foreach ($element in @($outputRequirementsLabel, $gridRequirements, $outputInstallationLabel, $gridInstallation)) {
    $element.visible = $false
  }

  $newTab.visible = $true
}

function Button_MouseEnter($button) {
  $button.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")
  $button.ForeColor = "#000000"
}

function Button_MouseLeave ($button) {
  $button.BackgroundImage = $null
  $button.ForeColor = "#ffffff"
}

function installButton_Click {
  $mainForm.controls.remove($installButton)
  Button_MouseLeave($tabRequirementsResultsButton)
  Button_MouseEnter($tabOutputInstallationsButton)
  tabButton_Click($outputInstallationLabel)
  foreach ($element in $requirements.Keys) {
    $keysRequirements += $element
  }
  nextButton_Click
}

function nextButton_Click {
  installRequirement $keysRequirements[$indexRequirement]
  $indexRequirement = $indexRequirement + 1
  $nextButton.visible = $false
}

function postAction_Click {
  switch ($postActionButton.Text) {
    "Login" {
      Invoke-LoginNpm
    }
    "Logout" {
      logoff.exe 
    }
    "Restart" {
      Restart-Computer -Force
    }
    "End" {
      Close-Installer
    }
  }
  $postActionButton.visible = $false
}

function gridRequirementrs_Click {
  $key = $gridRequirements.CurrentRow.Cells[0].Value
  $gridRequirements.ClearSelection()
  $selectedRequirement.Text = $key
  $outputRequirementsLabel.Text = ""

  if (-not $requirementsLogs.Contains($key)) {
    invoke-writeOutputRequirements "Nessun log trovato per questo requirement"
    return
  }

  $log = ($requirementsLogs[$key]).split(";").replace(";", "")
  foreach ($row in $log) {
    invoke-writeOutputRequirements $row $true
  }

}
#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------
. .\components\homePage\Form.ps1
$indexRequirement = 0
$keysRequirements = @()
$mainForm.Show()
. .\services\requirements.service.ps1
. .\services\installation.service.ps1
