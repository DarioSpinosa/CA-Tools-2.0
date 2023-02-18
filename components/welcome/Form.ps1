#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

[System.Windows.Forms.Application]::EnableVisualStyles()

$WelcomeForm                                 = New-Object System.Windows.Forms.Form
$WelcomeForm.StartPosition                   = "Manual"
$WelcomeForm.Location                        = '600, 200'
$WelcomeForm.ClientSize                      = '325, 425'
$WelcomeForm.Text                            = "Install CAEP"
$WelcomeForm.Icon                            = New-Object System.Drawing.Icon(".\assets\icon.ico")              
$WelcomeForm.BackColor                       = "#ffffff"
$WelcomeForm.StartPosition                   = "CenterScreen"
$WelcomeForm.FormBorderStyle                 = "FixedSingle"; #The window size can't be changed by the user
$WelcomeForm.BackgroundImage                 = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$Logo                                        = New-Object System.Windows.Forms.PictureBox
$Logo.Image                                  = [System.Drawing.Image]::Fromfile(".\assets\logo.png")
$Logo.Size                                   = "200, 45"
$Logo.Location                               = '63, 20'
$Logo.BackColor                              = "Transparent"

$HorizontalLine                              = New-Object System.Windows.Forms.Label
$HorizontalLine.Text                         = ""
$HorizontalLine.BorderStyle                  = "Fixed3D"
$HorizontalLine.AutoSize                     = $false
$HorizontalLine.Width                        = $WelcomeForm.ClientSize.Width
$HorizontalLine.Height                       = 2
$HorizontalLine.Location                     = "0, 90"

$Panel                                       = New-Object System.Windows.Forms.Panel
$Panel.Location                              = "0, 91"
$Panel.Size                                  = "325, 336"
$Panel.BackColor                             = "#eeeeee"
$Panel.BackgroundImage                       =[System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$WelcomeLabel                                = New-Object System.Windows.Forms.Label
$WelcomeLabel.Text                           = "Welcome to the Code Architects`n      Enterprise Platform Setup"
$WelcomeLabel.AutoSize                       = $true
$WelcomeLabel.Location                       = "20, 10"
$WelcomeLabel.Font                           = 'Roboto,14'
$WelcomeLabel.BackColor                      = "Transparent"

$InstallButton                               = New-Object System.Windows.Forms.Button
$InstallButton.BackColor                     = "#ffffff"
$InstallButton.Text                          = "Install"
$InstallButton.Size                          = "125, 40"
$InstallButton.Location                      = "100, 143"
$InstallButton.Font                          = 'Roboto,15'
$InstallButton.ForeColor                     = "#0a0a0a"
$InstallButton.FlatStyle                     = "Flat"
$InstallButton.FlatAppearance.BorderSize     = 0;
$InstallButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$InstallButton.Region = [System.Drawing.Region]::FromHrgn($RoundObject::CreateRoundRectRgn(0, 0, $InstallButton.Width, $InstallButton.Height, 8, 8))

$Panel.controls.AddRange(@($WelcomeLabel, $InstallButton))
$WelcomeForm.controls.AddRange(@($Logo, $Panel, $HorizontalLine))

#---------------------------------------------------------[Events]--------------------------------------------------------

$InstallButton.Add_Click({ InstallButton_Click })