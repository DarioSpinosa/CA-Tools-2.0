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

$mainForm.controls.AddRange(@($outputInstallationLabel, $gridInstallation))