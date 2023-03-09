
function invoke-initialize {
  tabButton_Click($startTabButton)
  $mainForm.ShowDialog() | Out-Null
}

function tabButton_Click($button) {
  if ($buttonTabs[$button].visible) { return }
  foreach ($element in $buttonTabs.Keys) {
    $buttonTabs[$element].visible = $false
    Button_MouseLeave $element
  }

  Button_MouseEnter $button
  $buttonTabs[$button].visible = $true
  $mainForm.Refresh()
}

function Button_MouseEnter($button) {
  $button.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")
  $button.ForeColor = "#000000"
}

function Button_MouseLeave ($button) {
  if ($buttonTabs[$button].visible) { return }
  $button.BackgroundImage = $null
  $button.ForeColor = "#ffffff"
}

function Invoke-CreateRow($grid, $name, $color) {
  $row = New-Object System.Windows.Forms.DataGridViewRow
  $row.CreateCells($grid, $name)
  $grid.Rows.Add($row);
  $grid.ClearSelection()
  $mainForm.Refresh()
}

function invoke-setColor($grid, $color){
  $grid.Rows[$grid.Rows.Count - 1].DefaultCellStyle.BackColor = $color
  $mainForm.Refresh()
}
#---------------------------------------------------------------------[LOGIC]-------------------------------------------------------

. .\components\Tabs\Start\Start.ps1
. .\components\modal\Modal.ps1
. .\components\login\Login.ps1
. .\components\Tabs\Check\Check.ps1
. .\components\Tabs\Install\Install.ps1
. .\components\homePage\Form.ps1

$buttonTabs = @{}
$buttonTabs.Add($startTabButton, $tabStart)
$buttonTabs.Add($requirementsTabButton, $tabRequirements)
$buttonTabs.Add($InstallTabButton, $tabInstall)

