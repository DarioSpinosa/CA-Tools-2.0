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
$requirementsTabButton.Text = "Check Requisiti"
$requirementsTabButton.Size = "150, 75"
$requirementsTabButton.Location = "0, 175"
$requirementsTabButton.Font = 'Roboto,10'
$requirementsTabButton.ForeColor = "#ffffff"
$requirementsTabButton.FlatStyle = "Flat"
$requirementsTabButton.FlatAppearance.BorderSize = 0 

$InstallTabButton = New-Object System.Windows.Forms.Button
$InstallTabButton.BackColor = "#00ffffff"
$InstallTabButton.Text = "Installazione`nrequisiti mancanti"
$InstallTabButton.Size = "150, 75"
$InstallTabButton.Location = "0, 250"
$InstallTabButton.Font = 'Roboto,10'
$InstallTabButton.ForeColor = "#ffffff"
$InstallTabButton.FlatStyle = "Flat"
$InstallTabButton.FlatAppearance.BorderSize = 0 

$sidebar.Controls.AddRange(@($logo, $startTabButton, $requirementsTabButton, $InstallTabButton))
$mainForm.Controls.AddRange(@($sidebar, $tabStart, $tabRequirements, $tabInstall))

#---------------------------------------------------------------------------[EVENTS]---------------------------------------------------------------------------
$requirementsTabButton.Add_Click({ tabButton_Click $requirementsTabButton })
$requirementsTabButton.Add_MouseEnter({ Button_MouseEnter $requirementsTabButton })
$requirementsTabButton.Add_MouseLeave({ Button_MouseLeave $requirementsTabButton })

$startTabButton.Add_Click({ tabButton_Click $startTabButton })
$startTabButton.Add_MouseEnter({ Button_MouseEnter $startTabButton })
$startTabButton.Add_MouseLeave({ Button_MouseLeave $startTabButton })

$InstallTabButton.Add_Click({ tabButton_Click $InstallTabButton })
$InstallTabButton.Add_MouseEnter({ Button_MouseEnter $InstallTabButton })
$InstallTabButton.Add_MouseLeave({ Button_MouseLeave $InstallTabButton })
