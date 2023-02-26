$tabInstallation = New-Object System.Windows.Forms.Panel
$tabInstallation.Location = "150, 0"
$tabInstallation.Size = "850, 600"
$tabInstallation.BackColor = "#00ffffff"
$tabInstallation.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$selectedInstallation = New-Object System.Windows.Forms.Label
$selectedInstallation.Text = ""
$selectedInstallation.AutoSize = $true
$selectedInstallation.Location = "407, 15"
$selectedInstallation.Font = 'Location, 20'
$selectedInstallation.BackColor = "Transparent"
$selectedInstallation.ForeColor = "#000000"
$selectedInstallation.Bold

$outputInstallationLabel = New-Object System.Windows.Forms.TextBox
$outputInstallationLabel.Text = ""
$outputInstallationLabel.Size = "535, 440"
$outputInstallationLabel.Multiline = $true
$outputInstallationLabel.Location = "290, 55"
$outputInstallationLabel.Font = 'Century Gothic, 13'
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
# $gridInstallation.DefaultCellStyle.SelectionBackColor = "Transparent"
# $gridInstallation.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridInstallation.DefaultCellStyle.Alignment = "MiddleCenter"
$gridInstallation.AdvancedCellBorderStyle.All = "None"
$gridInstallation.AllowUserToResizeRows = $false
$gridInstallation.AutoSizeRowsMode = "AllCells";
$gridInstallation.ColumnCount = 1
$gridInstallation.Columns[0].Name = "Installation";
$gridInstallation.Columns[0].Width = 240;
$gridInstallation.Columns[0].SortMode = "NotSortable";
$gridInstallation.ColumnHeadersBorderStyle = 4
$gridInstallation.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridInstallation.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridInstallation.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridInstallation.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridInstallation.Size = "240, 500"
$gridInstallation.Location = "25, 25"
$gridInstallation.MultiSelect = $false
$gridInstallation.AllowUserToAddRows = $false
$gridInstallation.ReadOnly = $true

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.BackColor = "#555555"
$closeButton.Text = "Finish"
$closeButton.Size = "90, 30"
$closeButton.Location = "735, 505"
$closeButton.Font = 'Century Gothic, 15'
$closeButton.ForeColor = "#ffffff"
$closeButton.FlatStyle = "Flat"
$closeButton.FlatAppearance.BorderSize = 0;
$closeButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$closeButton.Region = [System.Drawing.Region]::FromHrgn($roundObject::CreateRoundRectRgn(0, 0, $closeButton.Width, $closeButton.Height, 8, 8))
$closeButton.Enabled = $false

$tabInstallation.Controls.AddRange(@($selectedInstallation, $outputInstallationLabel, $gridInstallation, $closeButton))

$closeButton.Add_Click({ closeButton_Click })
# $gridInstallation.Add_Click({ gridInstallation_Click })
# $selectedInstallation.Add_SizeChanged({ selectedInstallation_SizeChanged })