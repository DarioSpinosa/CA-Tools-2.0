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

$DataGrid                       = New-Object System.Windows.Forms.DataGridView
$DataGrid.Name                  = "Grid"
$DataGrid.ColumnCount           = 2
$DataGrid.Columns[0].Name       = "Requirement";
$DataGrid.Columns[0].Width      = 160 # TODO Set auto resize width columns
$DataGrid.Columns[1].Name       = "Status";
$DataGrid.Size                  = New-Object System.Drawing.Size(265, 300)
$DataGrid.Location              = New-Object System.Drawing.Point(10, 50)
$DataGrid.MultiSelect           = $false
$DataGrid.RowHeadersVisible     = $false
$DataGrid.AllowUserToAddRows    = $false

$InstallForm.Controls.Add($OutputLabel)
