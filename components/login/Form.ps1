#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$loginForm = New-Object System.Windows.Forms.Form
$loginForm.StartPosition = "Manual"
$loginForm.ClientSize = '350, 155'
$loginForm.BackColor = "#eeeeee"
$loginForm.StartPosition = "CenterScreen"
$loginForm.FormBorderStyle = "None"
$loginForm.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$UsernameLabel = New-Object System.Windows.Forms.Label
$UsernameLabel.Text = "Username:"
$UsernameLabel.AutoSize = $true
$UsernameLabel.Size = '25, 20'
$UsernameLabel.Location = '20, 20'
$UsernameLabel.Font = 'Century Gothic, 10, style=Bold'
$UsernameLabel.BackColor = "Transparent"
$UsernameLabel.ForeColor = "#ffffff"

$UsernameTextBox = New-Object System.Windows.Forms.TextBox
$UsernameTextBox.Multiline = $false
$UsernameTextBox.Size = '100, 20'
$UsernameTextBox.Location = '20, 40'
$UsernameTextBox.Font = 'Century Gothic, 10'

$TokenLabel = New-Object System.Windows.Forms.Label
$TokenLabel.Text = "Token:"
$TokenLabel.AutoSize = $true
$TokenLabel.Size = '25, 20'
$TokenLabel.Height = 20
$TokenLabel.Location = '140, 20'
$TokenLabel.Font = 'Century Gothic, 10, style=Bold'
$TokenLabel.BackColor = "Transparent"
$TokenLabel.ForeColor = "#ffffff"

$TokenTextBox = New-Object System.Windows.Forms.TextBox
$TokenTextBox.Multiline = $false
$TokenTextBox.Size = '180, 20'
$TokenTextBox.Location = '140, 40'
$TokenTextBox.Font = 'Century Gothic, 10'

$loginButton = New-Object System.Windows.Forms.Button
$loginButton.BackColor = "#555555"
$loginButton.Text = "Login"
$loginButton.Size = "70, 30"
$loginButton.Location = "255, 100"
$loginButton.Font = 'Century Gothic, 15'
$loginButton.ForeColor = "#ffffff"
$loginButton.FlatStyle = "Flat"
$loginButton.FlatAppearance.BorderSize = 0;
$loginButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$loginButton.Region = [System.Drawing.Region]::FromHrgn($roundObject::CreateRoundRectRgn(0, 0, $loginButton.Width, $loginButton.Height, 8, 8))

$loginForm.Controls.AddRange(@($UsernameLabel, $UsernameTextBox, $TokenLabel, $TokenTextBox, $loginButton))

$loginButton.Add_Click({ loginButton_Click })

