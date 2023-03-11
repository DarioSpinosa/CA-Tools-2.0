$tabInstall = New-Object System.Windows.Forms.Panel
$tabInstall.Location = "150, 0"
$tabInstall.Size = "850, 600"
$tabInstall.BackColor = "#00ffffff"
$tabInstall.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$selectedInstall = New-Object System.Windows.Forms.Label
$selectedInstall.Text = ""
$selectedInstall.AutoSize = $true
$selectedInstall.Location = "407, 15"
$selectedInstall.Font = 'Location, 20'
$selectedInstall.BackColor = "Transparent"
$selectedInstall.ForeColor = "#000000"
$selectedInstall.Bold

$outputInstallLabel = New-Object System.Windows.Forms.TextBox
$outputInstallLabel.Text = ""
$outputInstallLabel.Size = "535, 440"
$outputInstallLabel.Multiline = $true
$outputInstallLabel.Location = "290, 55"
$outputInstallLabel.Font = 'Century Gothic, 13'
$outputInstallLabel.ScrollBars = "Vertical"
$outputInstallLabel.ReadOnly = $true

$gridInstall = New-Object System.Windows.Forms.DataGridView
$gridInstall.Name = "Grid"
$gridInstall.BorderStyle = 0
$gridInstall.RowHeadersVisible = $false
$gridInstall.EnableHeadersVisualStyles = $false
$gridInstall.BackgroundColor = "#ededed"
$gridInstall.DefaultCellStyle.Font = "Century Gothic, 13"
$gridInstall.DefaultCellStyle.BackColor = "#bfbfbf"
$gridInstall.DefaultCellStyle.SelectionBackColor = "Transparent"
$gridInstall.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridInstall.DefaultCellStyle.Alignment = "MiddleCenter"
$gridInstall.AdvancedCellBorderStyle.All = "None"
$gridInstall.AllowUserToResizeRows = $false
$gridInstall.AutoSizeRowsMode = "AllCells";
$gridInstall.ColumnCount = 1
$gridInstall.Columns[0].Name = "Requisito";
$gridInstall.Columns[0].Width = 240;
$gridInstall.Columns[0].SortMode = "NotSortable";
$gridInstall.AllowUserToResizeColumns = $false;
$gridInstall.ColumnHeadersBorderStyle = 4
$gridInstall.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridInstall.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridInstall.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridInstall.ColumnHeadersDefaultCellStyle.Alignment = "MiddleCenter"
$gridInstall.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridInstall.Size = "240, 500"
$gridInstall.Location = "25, 25"
$gridInstall.MultiSelect = $false
$gridInstall.AllowUserToAddRows = $false
$gridInstall.ReadOnly = $true

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.BackColor = "#19c5ff"
$closeButton.Text = "Finish"
$closeButton.Size = "90, 30"
$closeButton.Location = "735, 505"
$closeButton.Font = 'Century Gothic, 15'
$closeButton.ForeColor = "#ffffff"
$closeButton.FlatStyle = "Flat"
$closeButton.FlatAppearance.BorderSize = 0;
$closeButton.FlatAppearance.MouseOverBackColor = "#0463ca"
$closeButton.Enabled = $false

$tabInstall.Controls.AddRange(@($selectedInstall, $outputInstallLabel, $gridInstall, $closeButton))

$tabInstall.Add_VisibleChanged({ gridInstall_VisibleChanged })
$gridInstall.Add_Click({ gridInstall_Click })
$closeButton.Add_Click({ closeButton_Click })