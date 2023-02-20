#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$modalForm = New-Object System.Windows.Forms.Form
$modalForm.StartPosition = "Manual"
$modalForm.Text = "Error!"
$modalForm.Location = '700, 250'
$modalForm.ClientSize = '400, 100'
$modalForm.BackColor = "#eeeeee"
$modalForm.StartPosition = "CenterScreen"
$modalForm.FormBorderStyle = "None"
$modalForm.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = "5, 5"
$panel.Size = "390, 90"
$panel.BackColor = "#00254d"
$panel.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = ""
$messageLabel.AutoSize = $true
$messageLabel.Location = "30, 10"
$messageLabel.Font = 'Roboto, 10'
$messageLabel.BackColor = "Transparent"
$messageLabel.ForeColor = "#000000"

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.BackColor = "#ffffff"
$exitButton.Text = "Close"
$exitButton.Size = "80, 25"
$exitButton.Location = "160, 40"
$exitButton.Font = 'Roboto, 13'
$exitButton.ForeColor = "#0a0a0a"
$exitButton.ForeColor = "#0a0a0a"
$exitButton.FlatStyle = "Flat"
$exitButton.FlatAppearance.BorderSize = 0;
$exitButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$exitButton.Region = [System.Drawing.Region]::FromHrgn($RoundObject::CreateRoundRectRgn(0, 0, $exitButton.Width, $exitButton.Height, 8, 8))

$panel.controls.AddRange(@($messageLabel, $exitButton))
$modalForm.controls.Add($panel)

#---------------------------------------------------------[Events]--------------------------------------------------------

$exitButton.Add_Click({ exitButton_Click })
$messageLabel.Add_SizeChanged({ messageLabel_SizeChanged })
 