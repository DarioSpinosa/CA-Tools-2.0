#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.StartPosition = "Manual"
$mainForm.Text = "Installing!"
$mainForm.Location = '700, 250'
$mainForm.ClientSize = '1000, 550'
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = "None"; #The window size can't be changed by the user
$mainForm.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

#---------------------------------------------------------------------------[SIDEBAR]---------------------------------------------------------------------------
$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Location = "0, 0"
$sidebar.Size = "149, 550"
$sidebar.BackColor = "#00254d"
$sidebar.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$logo = New-Object System.Windows.Forms.PictureBox
$logo.Image = [System.Drawing.Image]::Fromfile(".\assets\logo.png")
$logo.Size = "120, 45"
$logo.Location = '15, 20'
$logo.BackColor = "Transparent"

$startTabButton = New-Object System.Windows.Forms.Button
$startTabButton.BackColor = "#00ffffff"
$startTabButton.Text = "Check Preliminari"
$startTabButton.Size = "150, 75"
$startTabButton.Location = "0, 100"
$startTabButton.Font = 'Roboto,10'
$startTabButton.ForeColor = "#ffffff"
$startTabButton.FlatStyle = "Flat"
$startTabButton.FlatAppearance.BorderSize = 0 

$requirementsTabButton = New-Object System.Windows.Forms.Button
$requirementsTabButton.BackColor = "#00ffffff"
$requirementsTabButton.Text = "Requirements"
$requirementsTabButton.Size = "150, 75"
$requirementsTabButton.Location = "0, 175"
$requirementsTabButton.Font = 'Roboto,10'
$requirementsTabButton.ForeColor = "#ffffff"
$requirementsTabButton.FlatStyle = "Flat"
$requirementsTabButton.FlatAppearance.BorderSize = 0 

$installationTabButton = New-Object System.Windows.Forms.Button
$installationTabButton.BackColor = "#00ffffff"
$installationTabButton.Text = "Installation"
$installationTabButton.Size = "150, 75"
$installationTabButton.Location = "0, 250"
$installationTabButton.Font = 'Roboto,10'
$installationTabButton.ForeColor = "#ffffff"
$installationTabButton.FlatStyle = "Flat"
$installationTabButton.FlatAppearance.BorderSize = 0 

$sidebar.Controls.AddRange(@($logo, $startTabButton, $requirementsTabButton, $installationTabButton))
$mainForm.Controls.AddRange(@($sidebar, $tabStart, $tabRequirements, $tabInstallation))

#---------------------------------------------------------------------------[EVENTS]---------------------------------------------------------------------------
$requirementsTabButton.Add_Click({ tabButton_Click $requirementsTabButton })
$requirementsTabButton.Add_MouseEnter({ Button_MouseEnter $requirementsTabButton })
$requirementsTabButton.Add_MouseLeave({ Button_MouseLeave $requirementsTabButton })

$startTabButton.Add_Click({ tabButton_Click $startTabButton })
$startTabButton.Add_MouseEnter({ Button_MouseEnter $startTabButton })
$startTabButton.Add_MouseLeave({ Button_MouseLeave $startTabButton })

$installationTabButton.Add_Click({ tabButton_Click $installationTabButton })
$installationTabButton.Add_MouseEnter({ Button_MouseEnter $installationTabButton })
$installationTabButton.Add_MouseLeave({ Button_MouseLeave $installationTabButton })
