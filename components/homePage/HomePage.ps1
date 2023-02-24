param(
  [Diagnostics.Stopwatch]$timer
)

function selectedRequirement_SizeChanged(){
  $selectedRequirement.Left = 607 - ($selectedRequirement.Width / 2)
}

function tabButton_Click($button) {
  foreach ($element in $buttonTabs.Keys) {
    $buttonTabs[$element].visible = $false
    Button_MouseLeave $element
  }

  Button_MouseEnter $button
  $buttonTabs[$button].visible = $true
}

function Button_MouseEnter($button) {
  $button.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")
  $button.ForeColor = "#000000"
}

function Button_MouseLeave ($button) {
  if ($buttonTabs[$button].visible) {return }
  $button.BackgroundImage = $null
  $button.ForeColor = "#ffffff"
}

function installButton_Click {
  . .\services\installation.service.ps1
  $mainForm.controls.remove($installButton)
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

# function postAction_Click {
#   switch ($postActionButton.Text) {
#     "Login" {
#       Invoke-LoginNpm
#     }
#     "Logout" {
#       logoff.exe 
#     }
#     "Restart" {
#       Restart-Computer -Force
#     }
#     "End" {
#       Close-Installer
#     }
#   }
#   $postActionButton.visible = $false
# }

function invoke-writeOutputInstallations($message, $newLine) {
  writeOutput $outputInstallationLabel $message $newLine
}

function writeOutput($label, $message, $newLine) {
  $label.AppendText("$message`r`n")
  if ($newLine) { $label.AppendText([System.Environment]::NewLine) }
}


function gridRequirementrs_Click {
  $key = $gridRequirements.CurrentRow.Cells[0].Value
  $gridRequirements.ClearSelection()
  $selectedRequirement.Text = $key
  $outputRequirementsLabel.Text = ""

  if (-not $requirementsLogs[$key]["Logs"]) {
    writeOutput $outputRequirementsLabel "Nessun log disponibile"
    return
  }
  
  foreach ($row in ($requirementsLogs[$key]["Logs"]).split(";").replace(";", "")) {
    writeOutput $outputRequirementsLabel $row $true
  }

}
#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------
. .\components\homePage\Form.ps1
$indexRequirement = 0

#Definito poiche durante la fase di installazione non si puo accedere con indice alle keys dell'hashtable
$keysRequirements = @()

$mainForm.Show()
. .\services\check.service.ps1
$mainForm.ShowDialog()
