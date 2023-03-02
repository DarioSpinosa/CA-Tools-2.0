param(
  [Diagnostics.Stopwatch]$timer
)

function tabButton_Click($button) {
  if ($buttonTabs[$button].visible) { return }
  foreach ($element in $buttonTabs.Keys) {
    $buttonTabs[$element].visible = $false
    Button_MouseLeave $element
  }

  Button_MouseEnter $button
  $buttonTabs[$button].visible = $true
  $gridInstallation.ClearSelection()
  $gridRequirements.ClearSelection()
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

function Invoke-CreateRow($grid, $name, $color) {
  $row = New-Object System.Windows.Forms.DataGridViewRow
  $row.CreateCells($grid, $name)
  $row.DefaultCellStyle.BackColor = $color
  $grid.Rows.Add($row);
  $grid.ClearSelection()
}
#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------

. .\components\Tabs\Start\Start.ps1
. .\components\Tabs\Check\Check.ps1
. .\components\Tabs\Installation\Installation.ps1
. .\components\homePage\Form.ps1

$buttonTabs = @{}
$buttonTabs.Add($startTabButton, $tabStart)
$buttonTabs.Add($requirementsTabButton, $tabRequirements)
$buttonTabs.Add($installationTabButton, $tabInstallation)
tabButton_Click($startTabButton)
$mainForm.ShowDialog()

