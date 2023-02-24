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

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = "0, 91"
$panel.Size = "325, 336"
$panel.BackColor = "#eeeeee"
$panel.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Text = "Welcome to the Code Architects`n      Enterprise Platform Setup"
$welcomeLabel.AutoSize = $true
$welcomeLabel.Location = "20, 10"
$welcomeLabel.Font = 'Century Gothic, 13'
$welcomeLabel.BackColor = "Transparent"

$startButton = New-Object System.Windows.Forms.Button
$startButton.BackColor = "#ffffff"
$startButton.Text = "Start"
$startButton.Size = "125, 40"
$startButton.Location = "100, 70"
$startButton.Font = 'Century Gothic,15'
$startButton.ForeColor = "#0a0a0a"
$startButton.FlatStyle = "Flat"
$startButton.FlatAppearance.BorderSize = 0;
$startButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$startButton.Region = [System.Drawing.Region]::FromHrgn($roundObject::CreateRoundRectRgn(0, 0, $startButton.Width, $startButton.Height, 8, 8))

$azureLabel = New-Object System.Windows.Forms.Label
$azureLabel.Text = "CA Azure Devops"
$azureLabel.AutoSize = $true
$azureLabel.Location = "90, 170"
$azureLabel.Font = 'Century Gothic, 13'
$azureLabel.BackColor = "Transparent"
$azureLabel.Cursor = "Hand"

$azureCheck = New-Object System.Windows.Forms.PictureBox
$azureCheck.Size = "30, 24"
$azureCheck.Location = "55, 170"
$azureCheck.SizeMode = "Zoom"
$azureCheck.BackColor = "Transparent"

$nugetLabel = New-Object System.Windows.Forms.Label
$nugetLabel.Text = "NuGet Registry"
$nugetLabel.AutoSize = $true
$nugetLabel.Location = "102, 210"
$nugetLabel.Font = 'Century Gothic, 13'
$nugetLabel.BackColor = "Transparent"
$nugetLabel.Cursor = "Hand"

$nugetCheck = New-Object System.Windows.Forms.PictureBox
$nugetCheck.Size = "30, 24"
$nugetCheck.Location = "55, 210"
$nugetCheck.SizeMode = "Zoom"
$nugetCheck.BackColor = "Transparent"

$npmLabel = New-Object System.Windows.Forms.Label
$npmLabel.Text = "Npm Registry"
$npmLabel.AutoSize = $true
$npmLabel.Location = "108, 250"
$npmLabel.Font = 'Century Gothic, 13'
$npmLabel.BackColor = "Transparent"
$npmLabel.Cursor = "Hand"

$npmCheck = New-Object System.Windows.Forms.PictureBox
$npmCheck.Size = "30, 24"
$npmCheck.Location = "55, 250"
$npmCheck.SizeMode = "Zoom"
$npmCheck.BackColor = "Transparent"

$logLabel = New-Object System.Windows.Forms.Label
$logLabel.Text = "CA Log Repository"
$logLabel.AutoSize = $true
$logLabel.Location = "90, 290"
$logLabel.Font = 'Century Gothic, 13'
$logLabel.BackColor = "Transparent"

$logCheck = New-Object System.Windows.Forms.PictureBox
$logCheck.Size = "30, 24"
$logCheck.Location = "55, 290"
$logCheck.SizeMode = "Zoom"
$logCheck.BackColor = "Transparent"

$connectionButton = New-Object System.Windows.Forms.Button
$connectionButton.BackColor = "#ffffff"
$connectionButton.Text = "Test Connections"
$connectionButton.Size = "180, 25"
$connectionButton.Location = "70, 140"
$connectionButton.Font = 'Century Gothic,15'
$connectionButton.ForeColor = "#0a0a0a"
$connectionButton.FlatStyle = "Flat"
$connectionButton.FlatAppearance.BorderSize = 0;
$connectionButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$connectionButton.Region = [System.Drawing.Region]::FromHrgn($roundObject::CreateRoundRectRgn(0, 0, $connectionButton.Width, $connectionButton.Height, 8, 8))
$connectionButton.Enabled = $false

$panel.controls.AddRange(@($welcomeLabel, $startButton, $azureLabel, $azureCheck, $nugetLabel, $nugetCheck, $npmLabel, $npmCheck, $logLabel, $logCheck, $connectionButton))
$welcomeForm.controls.AddRange(@($logo, $panel, $HorizontalLine))

#---------------------------------------------------------[Events]--------------------------------------------------------

$startButton.Add_Click({ startButton_Click })
$connectionButton.Add_Click({ connectionButton_Click })
$azureLabel.Add_Click({ label_Click "https://devops.codearchitects.com:444/" })
$npmLabel.Add_Click({ label_Click "https://registry.npmjs.org" })
$nugetLabel.Add_Click({ label_Click "https://api.nuget.org/v3/index.json" })