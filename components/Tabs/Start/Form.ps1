#---------------------------------------------------------[Initialisations]--------------------------------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$tabStart = New-Object System.Windows.Forms.Panel
$tabStart.Location = "175, 25"
$tabStart.Size = "800, 500"
$tabStart.BackColor = "White"
$tabStart.BorderStyle = "1"
$tabStart.BackColor = "#00ffffff"

$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Text = "Benvenuti nel setup del Code Architects Enterprise Platform"
$welcomeLabel.AutoSize = $true
$welcomeLabel.Location = "75, 15"
$welcomeLabel.Font = 'Century Gothic, 17'
$welcomeLabel.BackColor = "Transparent"

$startButton = New-Object System.Windows.Forms.Button
$startButton.BackColor = "#19c5ff"
$startButton.Text = "Inizia"
$startButton.Size = "125, 40"
$startButton.Location = "337, 55"
$startButton.Font = 'Century Gothic, 15'
$startButton.ForeColor = "#ffffff"
$startButton.FlatStyle = "Flat"
$startButton.FlatAppearance.BorderSize = 0;
$startButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$horizontalLine = New-Object System.Windows.Forms.Label
$horizontalLine.Text = ""
$horizontalLine.BorderStyle = "Fixed3D"
$horizontalLine.AutoSize = $false
$horizontalLine.Width = $tabStart.ClientSize.Width
$horizontalLine.Height = 3
$horizontalLine.Location = "0, 110"

$gridConnections = New-Object System.Windows.Forms.DataGridView
$gridConnections.Name = "Grid"
$gridConnections.BorderStyle = 0
$gridConnections.RowHeadersVisible = $false
$gridConnections.EnableHeadersVisualStyles = $false
$gridConnections.BackgroundColor = "#ededed"
$gridConnections.DefaultCellStyle.Font = "Century Gothic, 13"
$gridConnections.DefaultCellStyle.BackColor = "#ffffff"
$gridConnections.DefaultCellStyle.SelectionBackColor = "Transparent"
$gridConnections.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridConnections.DefaultCellStyle.Alignment = "MiddleCenter"
$gridConnections.AdvancedCellBorderStyle.All = "None"
$gridConnections.AllowUserToResizeRows = $false
$gridConnections.AutoSizeRowsMode = "AllCells";
$gridConnections.ColumnCount = 1
$gridConnections.Columns[0].Name = "Connessione a";
$gridConnections.Columns[0].Width = "200";
$gridConnections.Columns[0].SortMode = "NotSortable";
$gridConnections.AllowUserToResizeColumns = $false;
$imageColumn = New-Object System.Windows.Forms.DataGridViewImageColumn
$imageColumn.Width = "100";
$imageColumn.HeaderText = "Status"
$gridConnections.Columns.Insert(1, $imageColumn)
$gridConnections.ColumnHeadersBorderStyle = 4
$gridConnections.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridConnections.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridConnections.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridConnections.ColumnHeadersDefaultCellStyle.Alignment = "MiddleCenter"
$gridConnections.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridConnections.Size = "300, 125"
$gridConnections.Location = "25, 120"
$gridConnections.MultiSelect = $false
$gridConnections.AllowUserToAddRows = $false
$gridConnections.ReadOnly = $true

$gridEnvVar = New-Object System.Windows.Forms.DataGridView
$gridEnvVar.Name = "Grid"
$gridEnvVar.BorderStyle = 0
$gridEnvVar.RowHeadersVisible = $false
$gridEnvVar.EnableHeadersVisualStyles = $false
$gridEnvVar.BackgroundColor = "#ededed"
$gridEnvVar.DefaultCellStyle.Font = "Century Gothic, 13"
$gridEnvVar.DefaultCellStyle.BackColor = "#ffffff"
$gridEnvVar.DefaultCellStyle.SelectionBackColor = "Transparent"
$gridEnvVar.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridEnvVar.AdvancedCellBorderStyle.All = "None"
$gridEnvVar.AllowUserToResizeRows = $false
$gridEnvVar.AutoSizeRowsMode = "AllCells";
$gridEnvVar.ColumnCount = 2
$gridEnvVar.Columns[0].Name = "Variabile d'ambiente";
$gridEnvVar.Columns[0].Width = "450";
$gridEnvVar.Columns[0].SortMode = "NotSortable";
$gridEnvVar.Columns[1].Name = "Stato";
$gridEnvVar.Columns[1].Width = "135";
$gridEnvVar.Columns[1].SortMode = "NotSortable";
$gridEnvVar.AllowUserToResizeColumns = $false;
$gridEnvVar.ColumnHeadersBorderStyle = 4
$gridEnvVar.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridEnvVar.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridEnvVar.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridEnvVar.ColumnHeadersDefaultCellStyle.Alignment = "MiddleCenter"
$gridEnvVar.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridEnvVar.Size = "585, 225"
$gridEnvVar.Location = "25, 255"
$gridEnvVar.MultiSelect = $false
$gridEnvVar.AllowUserToAddRows = $false
$gridEnvVar.ReadOnly = $true

$infoProxyButton = New-Object System.Windows.Forms.Button
$infoProxyButton.BackColor = "#19c5ff"
$infoProxyButton.Text = "?"
$infoProxyButton.Size = "25, 25"
$infoProxyButton.Location = "365, 130"
$infoProxyButton.Font = 'Century Gothic, 11'
$infoProxyButton.ForeColor = "#ffffff"
$infoProxyButton.FlatStyle = "Flat"
$infoProxyButton.FlatAppearance.BorderSize = 0;
$infoProxyButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$proxyLabel = New-Object System.Windows.Forms.Label
$proxyLabel.Text = "Proxy:"
$proxyLabel.AutoSize = $true
$proxyLabel.Location = "400, 130"
$proxyLabel.Font = 'Century Gothic, 15'
$proxyLabel.BackColor = "Transparent"

$proxyCheck = New-Object System.Windows.Forms.PictureBox
$proxyCheck.Size = "30, 24"
$proxyCheck.Location = "460, 130"
$proxyCheck.SizeMode = "Zoom"
$proxyCheck.BackColor = "Transparent"

$infoVmButton = New-Object System.Windows.Forms.Button
$infoVmButton.BackColor = "#19c5ff"
$infoVmButton.Text = "?"
$infoVmButton.Size = "25, 25"
$infoVmButton.Location = "520, 130"
$infoVmButton.Font = 'Century Gothic, 11'
$infoVmButton.ForeColor = "#ffffff"
$infoVmButton.FlatStyle = "Flat"
$infoVmButton.FlatAppearance.BorderSize = 0;
$infoVmButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$vmLabel = New-Object System.Windows.Forms.Label
$vmLabel.Text = "Virtual machine:"
$vmLabel.AutoSize = $true
$vmLabel.Location = "555, 130"
$vmLabel.Font = 'Century Gothic, 15'
$vmLabel.BackColor = "Transparent"

$vmCheck = New-Object System.Windows.Forms.PictureBox
$vmCheck.Size = "30, 24"
$vmCheck.Location = "720, 130"
$vmCheck.SizeMode = "Zoom"
$vmCheck.BackColor = "Transparent"

$infoWSLButton = New-Object System.Windows.Forms.Button
$infoWSLButton.BackColor = "#19c5ff"
$infoWSLButton.Text = "?"
$infoWSLButton.Size = "25, 25"
$infoWSLButton.Location = "365, 170"
$infoWSLButton.Font = 'Century Gothic, 11'
$infoWSLButton.ForeColor = "#ffffff"
$infoWSLButton.FlatStyle = "Flat"
$infoWSLButton.FlatAppearance.BorderSize = 0;
$infoWSLButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$WSLLabel = New-Object System.Windows.Forms.Label
$WSLLabel.Text = "Windows Subsystem for Linux:"
$WSLLabel.AutoSize = $true
$WSLLabel.Location = "400, 170"
$WSLLabel.Font = 'Century Gothic, 15'
$WSLLabel.BackColor = "Transparent"

$WSLCheck = New-Object System.Windows.Forms.PictureBox
$WSLCheck.Size = "30, 24"
$WSLCheck.Location = "700, 170"
$WSLCheck.SizeMode = "Zoom"
$WSLCheck.BackColor = "Transparent"

$infoVMPlatformButton = New-Object System.Windows.Forms.Button
$infoVMPlatformButton.BackColor = "#19c5ff"
$infoVMPlatformButton.Text = "?"
$infoVMPlatformButton.Size = "25, 25"
$infoVMPlatformButton.Location = "365, 210"
$infoVMPlatformButton.Font = 'Century Gothic, 11'
$infoVMPlatformButton.ForeColor = "#ffffff"
$infoVMPlatformButton.FlatStyle = "Flat"
$infoVMPlatformButton.FlatAppearance.BorderSize = 0;
$infoVMPlatformButton.FlatAppearance.MouseOverBackColor = "#0463ca"

$VMPlatformLabel = New-Object System.Windows.Forms.Label
$VMPlatformLabel.Text = "Virtual Machine Platform:"
$VMPlatformLabel.AutoSize = $true
$VMPlatformLabel.Location = "400, 210"
$VMPlatformLabel.Font = 'Century Gothic, 15'
$VMPlatformLabel.BackColor = "Transparent"

$VMPlatformCheck = New-Object System.Windows.Forms.PictureBox
$VMPlatformCheck.Size = "30, 24"
$VMPlatformCheck.Location = "657, 210"
$VMPlatformCheck.SizeMode = "Zoom"
$VMPlatformCheck.BackColor = "Transparent"

$tabStart.controls.AddRange(@($welcomeLabel, $startButton, $horizontalLine, $gridConnections, $gridEnvVar, $infoProxyButton, $proxyLabel, $proxyCheck, $infoVmButton, $vmLabel, $vmCheck, $infoWSLButton, $WSLLabel, $WSLCheck, $infoVMPlatformButton, $VMPlatformLabel, $VMPlatformCheck))
# $welcomeForm.controls.AddRange(@($logo, $panel, $horizontalLine))

#---------------------------------------------------------[Events]--------------------------------------------------------

$tabStart.Add_VisibleChanged({ tabStart_VisibleChanged })
$startButton.Add_Click({ startButton_Click })
$infoVmButton.Add_Click({ infoVmButton_Click })
$infoProxyButton.Add_Click({ infoProxyButton_Click })
$infoVMPLatformButton.Add_Click({ infoVMPLatformButton_Click })
$infoWSLButton.Add_Click({ infoWSLButton_Click })