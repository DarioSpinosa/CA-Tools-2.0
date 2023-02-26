#---------------------------------------------------------[Initialisations]--------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$tabStart = New-Object System.Windows.Forms.Panel
$tabStart.Location = "175, 25"
$tabStart.Size = "800, 500"
$tabStart.BackColor = "White"
$tabStart.BorderStyle = "1"
$tabStart.BackColor = "#e8e8e8"

$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Text = "Welcome to the Code Architects Enterprise Platform Setup"
$welcomeLabel.AutoSize = $true
$welcomeLabel.Location = "100, 25"
$welcomeLabel.Font = 'Century Gothic, 17'
$welcomeLabel.BackColor = "Transparent"

$startButton = New-Object System.Windows.Forms.Button
$startButton.BackColor = "#555555"
$startButton.Text = "Start"
$startButton.Size = "125, 40"
$startButton.Location = "337, 70"
$startButton.Font = 'Century Gothic, 15'
$startButton.ForeColor = "#ffffff"
$startButton.FlatStyle = "Flat"
$startButton.FlatAppearance.BorderSize = 0;
$startButton.FlatAppearance.MouseOverBackColor = "#2daae1"
$startButton.Region = [System.Drawing.Region]::FromHrgn($roundObject::CreateRoundRectRgn(0, 0, $startButton.Width, $startButton.Height, 8, 8))

$HorizontalLine = New-Object System.Windows.Forms.Label
$HorizontalLine.Text = ""
$HorizontalLine.BorderStyle = "Fixed3D"
$HorizontalLine.AutoSize = $false
$HorizontalLine.Width = $tabStart.ClientSize.Width
$HorizontalLine.Height = 3
$HorizontalLine.Location = "0, 130"

$gridConnections = New-Object System.Windows.Forms.DataGridView
$gridConnections.Name = "Grid"
$gridConnections.BorderStyle = 0
$gridConnections.RowHeadersVisible = $false
$gridConnections.EnableHeadersVisualStyles = $false
$gridConnections.BackgroundColor = "#666666"
$gridConnections.DefaultCellStyle.Font = "Century Gothic, 13"
$gridConnections.DefaultCellStyle.BackColor = "#ffffff"
# $gridConnections.DefaultCellStyle.SelectionBackColor = "Transparent"
# $gridConnections.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridConnections.DefaultCellStyle.Alignment = "MiddleCenter"
$gridConnections.AdvancedCellBorderStyle.All = "None"
$gridConnections.AllowUserToResizeRows = $false
$gridConnections.AutoSizeRowsMode = "AllCells";
$gridConnections.ColumnCount = 1
$gridConnections.Columns[0].Name = "Connessione a";
$gridConnections.Columns[0].Width = "200";
$gridConnections.Columns[0].SortMode = "NotSortable";
$imageColumn = New-Object System.Windows.Forms.DataGridViewImageColumn
$imageColumn.Width = "100";
$imageColumn.HeaderText = "Status"
$gridConnections.Columns.Insert(1, $imageColumn)
$gridConnections.ColumnHeadersBorderStyle = 4
$gridConnections.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridConnections.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridConnections.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridConnections.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridConnections.Size = "300, 123"
$gridConnections.Location = "25, 150"
$gridConnections.MultiSelect = $false
$gridConnections.AllowUserToAddRows = $false
$gridConnections.ReadOnly = $true

$gridEnvVar = New-Object System.Windows.Forms.DataGridView
$gridEnvVar.Name = "Grid"
$gridEnvVar.BorderStyle = 0
$gridEnvVar.RowHeadersVisible = $false
$gridEnvVar.EnableHeadersVisualStyles = $false
$gridEnvVar.BackgroundColor = "#666666"
$gridEnvVar.DefaultCellStyle.Font = "Century Gothic, 13"
$gridEnvVar.DefaultCellStyle.BackColor = "#ffffff"
# $gridEnvVar.DefaultCellStyle.SelectionBackColor = "Transparent"
# $gridEnvVar.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridEnvVar.AdvancedCellBorderStyle.All = "None"
$gridEnvVar.AllowUserToResizeRows = $false
$gridEnvVar.AutoSizeRowsMode = "AllCells";
$gridEnvVar.ColumnCount = 2
$gridEnvVar.Columns[0].Name = "Variabile d'ambiente";
$gridEnvVar.Columns[0].Width = "450";
$gridEnvVar.Columns[0].SortMode = "NotSortable";
$gridEnvVar.Columns[1].Name = "Stato";
$gridEnvVar.Columns[1].Width = "150";
$gridEnvVar.Columns[1].SortMode = "NotSortable";
$gridEnvVar.ColumnHeadersBorderStyle = 4
$gridEnvVar.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridEnvVar.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridEnvVar.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridEnvVar.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridEnvVar.Size = "600, 123"
$gridEnvVar.Location = "25, 298"
$gridEnvVar.MultiSelect = $false
$gridEnvVar.AllowUserToAddRows = $false
$gridEnvVar.ReadOnly = $true

$proxyLabel = New-Object System.Windows.Forms.Label
$proxyLabel.Text = "Presenza di un proxy:"
$proxyLabel.AutoSize = $true
$proxyLabel.Location = "400, 160"
$proxyLabel.Font = 'Century Gothic, 15'
$proxyLabel.BackColor = "Transparent"

$proxyCheck = New-Object System.Windows.Forms.PictureBox
$proxyCheck.Size = "30, 24"
$proxyCheck.Location = "550, 163"
$proxyCheck.SizeMode = "Zoom"
$proxyCheck.BackColor = "Transparent"

$infoVmButton = New-Object System.Windows.Forms.Button
$infoVmButton.BackColor = "#000000"
$infoVmButton.Text = "?"
$infoVmButton.Size = "25, 25"
$infoVmButton.Location = "365, 200"
$infoVmButton.Font = 'Century Gothic, 11'
$infoVmButton.ForeColor = "#ffffff"
$infoVmButton.FlatStyle = "Flat"
$infoVmButton.FlatAppearance.BorderSize = 0;
$infoVmButton.FlatAppearance.MouseOverBackColor = "#2daae1"

$vmLabel = New-Object System.Windows.Forms.Label
$vmLabel.Text = "Siamo su una virtual machine:`n"
$vmLabel.AutoSize = $true
$vmLabel.Location = "400, 200"
$vmLabel.Font = 'Century Gothic, 15'
$vmLabel.BackColor = "Transparent"

$vmCheck = New-Object System.Windows.Forms.PictureBox
$vmCheck.Size = "30, 24"
$vmCheck.Location = "485, 200"
$vmCheck.SizeMode = "Zoom"
$vmCheck.BackColor = "Transparent"

$vmWarning = New-Object System.Windows.Forms.Label
$vmWarning.Text = "In caso affermativo accertarsi che sia abilitata`nla nested virtualization prima di proseguire"
$vmWarning.AutoSize = $true
$vmWarning.Location = "400, 225"
$vmWarning.Font = 'Century Gothic, 13'
$vmWarning.BackColor = "Transparent"

$tabStart.controls.AddRange(@($welcomeLabel, $startButton, $HorizontalLine, $gridConnections, $gridEnvVar, $proxyLabel, $proxyCheck, $infoVmButton, $vmLabel, $vmWarning, $vmCheck))
# $welcomeForm.controls.AddRange(@($logo, $panel, $HorizontalLine))

#---------------------------------------------------------[Events]--------------------------------------------------------

$startButton.Add_Click({ startButton_Click })
$infoVmButton.Add_Click({ infoVmButton_Click })