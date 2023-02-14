#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$InstallForm                                   = New-Object System.Windows.Forms.Form
$InstallForm.StartPosition                     = "Manual"
$InstallForm.Text                              = "Installing!"
$InstallForm.Location                          = '700, 250'
$InstallForm.ClientSize                        = '500, 350'
$InstallForm.BackColor                         = "#eeeeee"
$InstallForm.StartPosition                     = "CenterScreen"
$InstallForm.FormBorderStyle                   = "FixedSingle"; #The window size can't be changed by the user

$OutputLabel                                = New-Object System.Windows.Forms.Label
$OutputLabel.Text                           = ""
$OutputLabel.AutoSize                       = $true
$OutputLabel.Location                       = "80, 100"
$OutputLabel.Font                           = 'Helvetica,9'

$InstallForm.Controls.Add($OutputLabel)
