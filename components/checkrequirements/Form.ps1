#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

$mainform = New-Object System.Windows.Forms.Form
$mainform.StartPosition = "Manual"
$mainform.Text = "Installing!"
$mainform.Location = '700, 250'
$mainform.ClientSize = '1000, 550'
$mainform.Icon = New-Object System.Drawing.Icon(".\assets\icon.ico")
$mainform.StartPosition = "CenterScreen"
$mainform.FormBorderStyle = "None"; #The window size can't be changed by the user
$mainform.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$sidebar = New-Object System.Windows.Forms.Panel
$sidebar.Location = "0, 0"
$sidebar.Size = "150, 600"
$sidebar.BackColor = "#00254d"
$sidebar.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background2.png")

$logo = New-Object System.Windows.Forms.PictureBox
$logo.Image = [System.Drawing.Image]::Fromfile(".\assets\logo.png")
$logo.Size = "120, 45"
$logo.Location = '15, 20'
$logo.BackColor = "Transparent"

$tabOutputRequirementsButton = New-Object System.Windows.Forms.Button
$tabOutputRequirementsButton.BackColor = "#00ffffff"
$tabOutputRequirementsButton.Text = "Output Requirements"
$tabOutputRequirementsButton.Size = "150, 75"
$tabOutputRequirementsButton.Location = "0, 100"
$tabOutputRequirementsButton.Font = 'Roboto,10'
$tabOutputRequirementsButton.ForeColor = "#ffffff"
$tabOutputRequirementsButton.FlatStyle = "Flat"
$tabOutputRequirementsButton.FlatAppearance.BorderSize = 0 

$tabRequirementsResultsButton = New-Object System.Windows.Forms.Button
$tabRequirementsResultsButton.BackColor = "#00ffffff"
$tabRequirementsResultsButton.Text = "Results Requirements"
$tabRequirementsResultsButton.Size = "150, 75"
$tabRequirementsResultsButton.Location = "0, 175"
$tabRequirementsResultsButton.Font = 'Roboto,10'
$tabRequirementsResultsButton.ForeColor = "#ffffff"
$tabRequirementsResultsButton.FlatStyle = "Flat"
$tabRequirementsResultsButton.FlatAppearance.BorderSize = 0;

$tabOutputInstallationsButton = New-Object System.Windows.Forms.Button
$tabOutputInstallationsButton.BackColor = "#00ffffff"
$tabOutputInstallationsButton.Text = "Installation Output"
$tabOutputInstallationsButton.Size = "150, 75"
$tabOutputInstallationsButton.Location = "0, 250"
$tabOutputInstallationsButton.Font = 'Roboto,10'
$tabOutputInstallationsButton.ForeColor = "#ffffff"
$tabOutputInstallationsButton.FlatStyle = "Flat"
$tabOutputInstallationsButton.FlatAppearance.BorderSize = 0 

$tabInstallationsResultsButton = New-Object System.Windows.Forms.Button
$tabInstallationsResultsButton.BackColor = "#00ffffff"
$tabInstallationsResultsButton.Text = "Installations Results"
$tabInstallationsResultsButton.Size = "150, 75"
$tabInstallationsResultsButton.Location = "0, 325"
$tabInstallationsResultsButton.Font = 'Roboto,10'
$tabInstallationsResultsButton.ForeColor = "#ffffff"
$tabInstallationsResultsButton.FlatStyle = "Flat"
$tabInstallationsResultsButton.FlatAppearance.BorderSize = 0;

$outputRequirementsLabel = New-Object System.Windows.Forms.TextBox
$outputRequirementsLabel.Text = ""
$outputRequirementsLabel.Size = "750, 500"
$outputRequirementsLabel.Multiline = $true
$outputRequirementsLabel.Location = "200, 25"
$outputRequirementsLabel.Font = 'Roboto,12'
$outputRequirementsLabel.ScrollBars = "Vertical"
$outputRequirementsLabel.ReadOnly = $true

$gridRequirements = New-Object System.Windows.Forms.DataGridView
$gridRequirements.Name = "Grid"
$gridRequirements.BorderStyle = 0
$gridRequirements.RowHeadersVisible = $false
$gridRequirements.EnableHeadersVisualStyles = $false
$gridRequirements.BackgroundColor = "#ffffff"
$gridRequirements.DefaultCellStyle.Font = "Century Gothic, 13"
$gridRequirements.DefaultCellStyle.BackColor = "#ffffff"
$gridRequirements.AdvancedCellBorderStyle.All = "None"
$gridRequirements.ColumnCount = 2
$gridRequirements.Columns[0].Name = "Requirement";
$gridRequirements.Columns[1].Name = "Status";
$gridRequirements.ColumnHeadersBorderStyle = 4
$gridRequirements.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridRequirements.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridRequirements.ColumnHeadersDefaultCellStyle.BackColor = "#2f5a84"
$gridRequirements.AutoSizeColumnsMode = "Fill"
$gridRequirements.Size = "750, 450"
$gridRequirements.Location = "200, 25"
$gridRequirements.MultiSelect = $false
$gridRequirements.AllowUserToAddRows = $false

$outputInstallationLabel = New-Object System.Windows.Forms.TextBox
$outputInstallationLabel.Text = ""
$outputInstallationLabel.Size = "750, 500"
$outputInstallationLabel.Multiline = $true
$outputInstallationLabel.Location = "200, 25"
$outputInstallationLabel.Font = 'Roboto,12'
$outputInstallationLabel.ScrollBars = "Vertical"
$outputInstallationLabel.ReadOnly = $true

$gridInstallation = New-Object System.Windows.Forms.DataGridView
$gridInstallation.Name = "Grid"
$gridInstallation.BorderStyle = 0
$gridInstallation.RowHeadersVisible = $false
$gridInstallation.EnableHeadersVisualStyles = $false
$gridInstallation.BackgroundColor = "#ffffff"
$gridInstallation.DefaultCellStyle.Font = "Century Gothic, 13"
$gridInstallation.DefaultCellStyle.BackColor = "#ffffff"
$gridInstallation.AdvancedCellBorderStyle.All = "None"
$gridInstallation.ColumnCount = 2
$gridInstallation.Columns[0].Name = "Requirement";
$gridInstallation.Columns[1].Name = "Status";
$gridInstallation.ColumnHeadersBorderStyle = 4
$gridInstallation.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridInstallation.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridInstallation.ColumnHeadersDefaultCellStyle.BackColor = "#2f5a84"
$gridInstallation.AutoSizeColumnsMode = "Fill"
$gridInstallation.Size = "750, 450"
$gridInstallation.Location = "200, 25"
$gridInstallation.MultiSelect = $false
$gridInstallation.AllowUserToAddRows = $false

$sidebar.Controls.AddRange(@($logo, $tabOutputRequirementsButton, $tabRequirementsResultsButton, $tabOutputInstallationsButton, $tabInstallationsResultsButton))
$mainform.Controls.AddRange(@($sidebar, $outputRequirementsLabel))

$tabRequirementsResultsButton.Add_Click({ tabRequirementsResultsButton_Click })
$tabRequirementsResultsButton.Add_MouseEnter({ Button_MouseEnter($tabRequirementsResultsButton) })
$tabRequirementsResultsButton.Add_MouseLeave({ Button_MouseLeave($tabRequirementsResultsButton) })

$tabOutputRequirementsButton.Add_Click({ tabOutputRequirementsButton_Click })
$tabOutputRequirementsButton.Add_MouseEnter({ Button_MouseEnter($tabOutputRequirementsButton) })
$tabOutputRequirementsButton.Add_MouseLeave({ Button_MouseLeave($tabOutputRequirementsButton) })

$tabOutputInstallationsButton.Add_Click({ tabOutputInstallationsButton_Click })
$tabOutputInstallationsButton.Add_MouseEnter({ Button_MouseEnter($tabOutputInstallationsButton) })
$tabOutputInstallationsButton.Add_MouseLeave({ Button_MouseLeave($tabOutputInstallationsButton) })

$tabInstallationsResultsButton.Add_Click({ tabInstallationsResultsButton_Click })
$tabInstallationsResultsButton.Add_MouseEnter({ Button_MouseEnter($tabInstallationsResultsButton) })
$tabInstallationsResultsButton.Add_MouseLeave({ Button_MouseLeave($tabInstallationsResultsButton) })
