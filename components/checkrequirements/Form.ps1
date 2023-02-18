#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$InstallForm                                        = New-Object System.Windows.Forms.Form
$InstallForm.StartPosition                          = "Manual"
$InstallForm.Text                                   = "Installing!"
$InstallForm.Location                               = '700, 250'
$InstallForm.ClientSize                             = '1000, 550'
$InstallForm.Icon                                   = New-Object System.Drawing.Icon(".\assets\icon.ico")
# $InstallForm.BackColor                              = "#63A7DC"
$InstallForm.StartPosition                          = "CenterScreen"
$InstallForm.FormBorderStyle                        = "FixedSingle"; #The window size can't be changed by the user
$InstallForm.BackgroundImage                        =[System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$Panel                                              = New-Object System.Windows.Forms.Panel
$Panel.Location                                     = "0, 0"
$Panel.Size                                         = "150, 600"
$Panel.BackColor                                    = "#00254d"
$Panel.BackgroundImage                              = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$tabOutputButton                               = New-Object System.Windows.Forms.Button
$tabOutputButton.BackColor                     = "#00ffffff"
$tabOutputButton.Text                          = "Output"
$tabOutputButton.Size                          = "150, 75"
$tabOutputButton.Location                      = "0, 100"
$tabOutputButton.Font                          = 'Roboto,10'
$tabOutputButton.ForeColor                     = "#ffffff"
$tabOutputButton.FlatStyle                     = "Flat"
$tabOutputButton.FlatAppearance.BorderSize     = 0;ScrollBars 
$tabOutputButton.FlatAppearance.MouseOverBackColor = "#0055b3"

$tabCheckRequirementsResultsButton                               = New-Object System.Windows.Forms.Button
$tabCheckRequirementsResultsButton.BackColor                     = "#00ffffff"
$tabCheckRequirementsResultsButton.Text                          = "Requirements Results"
$tabCheckRequirementsResultsButton.Size                          = "150, 75"
$tabCheckRequirementsResultsButton.Location                      = "0, 175"
$tabCheckRequirementsResultsButton.Font                          = 'Roboto,10'
$tabCheckRequirementsResultsButton.ForeColor                     = "#ffffff"
$tabCheckRequirementsResultsButton.FlatStyle                     = "Flat"
$tabCheckRequirementsResultsButton.FlatAppearance.BorderSize     = 0;
$tabCheckRequirementsResultsButton.FlatAppearance.MouseOverBackColor = "#0055b3"

$OutputLabel                                        = New-Object System.Windows.Forms.TextBox
$OutputLabel.Text                                   = ""
$OutputLabel.Size                                   = "750, 500"
$OutputLabel.Multiline                              = $true
$OutputLabel.Location                               = "200, 25"
$OutputLabel.Font                                   = 'Roboto,12'
$OutputLabel.ScrollBars                             = "Vertical"
$OutputLabel.ReadOnly                               = $true

$DataGrid                                           = New-Object System.Windows.Forms.DataGridView
$DataGrid.Name                                      = "Grid"
$DataGrid.BorderStyle                               = 0
$DataGrid.RowHeadersVisible                         = $false
$DataGrid.EnableHeadersVisualStyles                 = $false
$DataGrid.BackgroundColor                           = "#ffffff"
$DataGrid.ColumnCount                               = 2
$DataGrid.AdvancedCellBorderStyle.All               = "None"
$DataGrid.ColumnHeadersBorderStyle                  = 4
$DataGrid.ColumnHeadersDefaultCellStyle.Font        = "Century Gothic, 15"
$DataGrid.ColumnHeadersDefaultCellStyle.ForeColor   = "#ffffff"
$DataGrid.ColumnHeadersDefaultCellStyle.BackColor   = "#2f5a84"
$DataGrid.DefaultCellStyle.Font                     = "Century Gothic, 13"
$DataGrid.DefaultCellStyle.BackColor                = "#ffffff"
$DataGrid.Columns[0].Name                           = "Requirement";
$DataGrid.Columns[1].Name                           = "Status";
$DataGrid.AutoSizeColumnsMode                       = "Fill"
$DataGrid.Size                                      = "750, 500"
$DataGrid.Location                                  = "200, 25"
$DataGrid.MultiSelect                               = $false
$DataGrid.AllowUserToAddRows                        = $false

$Panel.Controls.AddRange(@($tabOutputButton, $tabCheckRequirementsResultsButton))
$InstallForm.Controls.AddRange(@($Panel, $OutputLabel))
$tabCheckRequirementsResultsButton.Add_Click({tabCheckRequirementsResultsButton_Click})
$tabOutputButton.Add_Click({tabOutputButton_Click})
