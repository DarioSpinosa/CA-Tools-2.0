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

$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Text = "Username:"
$usernameLabel.AutoSize = $true
$usernameLabel.Size = '25, 20'
$usernameLabel.Location = '20, 18'
$usernameLabel.Font = 'Century Gothic, 10, style=Bold'
$usernameLabel.BackColor = "Transparent"
$usernameLabel.ForeColor = "#ffffff"

$usernameTextBox = New-Object System.Windows.Forms.TextBox
$usernameTextBox.Multiline = $false
$usernameTextBox.Size = '100, 20'
$usernameTextBox.Location = '20, 40'
$usernameTextBox.Font = 'Century Gothic, 10'
$usernameTextBox.TabStop = $false

$usernameWarning = New-Object System.Windows.Forms.Label
$usernameWarning.Text = "NON inserire 'COLLABORATION\nomeutente'`no 'nomeutente@domain.com'"
$usernameWarning.AutoSize = $true
$usernameWarning.Size = '25, 20'
$usernameWarning.Location = '20, 80'
$usernameWarning.Font = 'Century Gothic, 8, style=Bold'
$usernameWarning.BackColor = "Transparent"
$usernameWarning.ForeColor = "#ffffff"

$TokenLabel = New-Object System.Windows.Forms.Label
$TokenLabel.Text = "Token:"
$TokenLabel.AutoSize = $true
$TokenLabel.Size = '25, 20'
$TokenLabel.Height = 20
$TokenLabel.Location = '140, 18'
$TokenLabel.Font = 'Century Gothic, 10, style=Bold'
$TokenLabel.BackColor = "Transparent"
$TokenLabel.ForeColor = "#ffffff"

$TokenTextBox = New-Object System.Windows.Forms.TextBox
$TokenTextBox.Multiline = $false
$TokenTextBox.Size = '180, 20'
$TokenTextBox.Location = '140, 40'
$TokenTextBox.Font = 'Century Gothic, 10'
$TokenTextBox.TabStop = $false

$errorLabel = New-Object System.Windows.Forms.Label
$errorLabel.Text = "Password o Token Errati"
$errorLabel.AutoSize = $true
$errorLabel.Size = '25, 20'
$errorLabel.Location = '20, 115'
$errorLabel.Font = 'Century Gothic, 10, style=Bold'
$errorLabel.BackColor = "Transparent"
$errorLabel.ForeColor = "#bb0a1e"
$errorLabel.Visible = $false

$loginButton = New-Object System.Windows.Forms.Button
$loginButton.BackColor = "#19c5ff"
$loginButton.Text = "Login"
$loginButton.Size = "60, 25"
$loginButton.Location = "255, 115"
$loginButton.Font = 'Century Gothic, 15'
$loginButton.ForeColor = "#ffffff"
$loginButton.FlatStyle = "Flat"
$loginButton.FlatAppearance.BorderSize = 0;
$loginButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$loginForm.Controls.AddRange(@($usernameLabel, $usernameTextBox, $usernameWarning, $TokenLabel, $TokenTextBox, $errorLabel, $loginButton))

$loginButton.Add_Click({ loginButton_Click })

