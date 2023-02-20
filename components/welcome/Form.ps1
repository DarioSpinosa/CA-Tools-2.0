#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

[System.Windows.Forms.Application]::EnableVisualStyles()

$welcomeForm = New-Object System.Windows.Forms.Form
$welcomeForm.StartPosition = "Manual"
$welcomeForm.Location = '600, 200'
$welcomeForm.ClientSize = '325, 425'
$welcomeForm.Text = "Install CAEP"        
$welcomeForm.BackColor = "#ffffff"
$welcomeForm.StartPosition = "CenterScreen"
$welcomeForm.FormBorderStyle = "None"
$welcomeForm.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$logo = New-Object System.Windows.Forms.PictureBox
$logo.Image = [System.Drawing.Image]::Fromfile(".\assets\logo.png")
$logo.Size = "200, 45"
$logo.Location = '63, 20'
$logo.BackColor = "Transparent"

$HorizontalLine = New-Object System.Windows.Forms.Label
$HorizontalLine.Text = ""
$HorizontalLine.BorderStyle = "Fixed3D"
$HorizontalLine.AutoSize = $false
$HorizontalLine.Width = $welcomeForm.ClientSize.Width
$HorizontalLine.Height = 2
$HorizontalLine.Location = "0, 90"

$line = New-Object System.Windows.Forms.Panel
$line.Location = "0, 91"
$line.Size = "325, 336"
$line.BackColor = "#eeeeee"
$line.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Text = "Welcome to the Code Architects`n      Enterprise Platform Setup"
$welcomeLabel.AutoSize = $true
$welcomeLabel.Location = "20, 10"
$welcomeLabel.Font = 'Roboto,14'
$welcomeLabel.BackColor = "Transparent"

$startButton = New-Object System.Windows.Forms.Button
$startButton.BackColor = "#ffffff"
$startButton.Text = "Start"
$startButton.Size = "125, 40"
$startButton.Location = "100, 143"
$startButton.Font = 'Roboto,15'
$startButton.ForeColor = "#0a0a0a"
$startButton.FlatStyle = "Flat"
$startButton.FlatAppearance.BorderSize = 0;
$startButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$startButton.Region = [System.Drawing.Region]::FromHrgn($roundObject::CreateRoundRectRgn(0, 0, $startButton.Width, $startButton.Height, 8, 8))

$line.controls.AddRange(@($welcomeLabel, $startButton))
$welcomeForm.controls.AddRange(@($logo, $line, $HorizontalLine))

#---------------------------------------------------------[Events]--------------------------------------------------------

$startButton.Add_Click({ startButton_Click })