#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$ModalForm                                   = New-Object System.Windows.Forms.Form
$ModalForm.StartPosition                     = "Manual"
$ModalForm.Text                              = "Error!"
$ModalForm.Location                          = '700, 250'
$ModalForm.ClientSize                        = '400, 100'
$ModalForm.Icon                              = New-Object System.Drawing.Icon(".\assets\icon.ico")
$ModalForm.BackColor                         = "#eeeeee"
$ModalForm.StartPosition                     = "CenterScreen"
$ModalForm.FormBorderStyle                   = "FixedSingle"; #The window size can't be changed by the user

$MessageLabel                                = New-Object System.Windows.Forms.Label
$MessageLabel.Text                           = ""
$MessageLabel.AutoSize                       = $true
$MessageLabel.Location                       = "30, 10"
$MessageLabel.Font                           = 'Helvetica,9'

$ExitButton                                  = New-Object System.Windows.Forms.Button
$ExitButton.BackColor                        = "#ffffff"
$ExitButton.Text                             = "Close"
$ExitButton.Size                             = "80, 25"
$ExitButton.Location                         = "160, 50"
$ExitButton.Font                             = 'Helvetica,12'
$ExitButton.ForeColor                        = "#0a0a0a"
$ExitButton.FlatStyle                        = "Flat"
$ExitButton.FlatAppearance.BorderColor       = "#45b6fe";

$ModalForm.controls.AddRange(@($MessageLabel, $ExitButton))

#---------------------------------------------------------[Events]--------------------------------------------------------

$ExitButton.Add_Click({ ExitButton_Click })
$MessageLabel.Add_SizeChanged({ MessageLabel_SizeChanged })
 