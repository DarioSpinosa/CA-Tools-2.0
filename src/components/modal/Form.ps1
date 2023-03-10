#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$modalForm = New-Object System.Windows.Forms.Form
$modalForm.StartPosition = "Manual"
$modalForm.Text = "Error!"
$modalForm.Location = '700, 250'
$modalForm.ClientSize = '350, 180'
$modalForm.BackColor = "#eeeeee"
$modalForm.StartPosition = "CenterScreen"
$modalForm.FormBorderStyle = "None"
$modalForm.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = "5, 5"
$panel.Size = "340, 170"
$panel.BackColor = "#00254d"
$panel.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$messageLabel = New-Object System.Windows.Forms.TextBox
$messageLabel.Text = ""
$messageLabel.Size = "320, 120"
$messageLabel.Location = "10, 10"
$messageLabel.Font = 'Century Gothic, 11'
$messageLabel.ForeColor = "#000000"
$messageLabel.Multiline = $true
$messageLabel.Enabled = $false

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.BackColor = "#19c5ff"
$exitButton.Text = "Ok"
$exitButton.Size = "80, 25"
$exitButton.Location = "135, 135"
$exitButton.Font = 'Century Gothic, 13'
$exitButton.ForeColor = "#ffffff"
$exitButton.FlatStyle = "Flat"
$exitButton.FlatAppearance.BorderSize = 0;
$exitButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$panel.controls.AddRange(@($messageLabel, $exitButton))
$modalForm.controls.Add($panel)


$exitButton.Add_Click({ exitButton_Click })