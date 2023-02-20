param(
  [Diagnostics.Stopwatch]$timer
)

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
  foreach ($element in @($outputRequirementsLabel, $gridRequirements, $outputInstallationLabel, $gridInstallation)){
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

function installButton_Click{
  $mainForm.controls.remove($installButton)
  Button_MouseLeave($tabRequirementsResultsButton)
  Button_MouseEnter($tabOutputInstallationsButton)
  tabButton_Click($outputInstallationLabel)
  foreach ($element in $requirements.Keys) {
    $keysRequirements += $element
  }
  nextButton_Click
}

function nextButton_Click{
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

#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------
. .\components\homePage\Form.ps1
$indexRequirement = 0
$keysRequirements = @()
Button_MouseEnter($tabOutputRequirementsButton)
. .\services\requirements.service.ps1
. .\services\installation.service.ps1
$mainForm.ShowDialog()
