$tabRequirements = New-Object System.Windows.Forms.Panel
$tabRequirements.Location = "150, 0"
$tabRequirements.Size = "850, 600"
$tabRequirements.BackColor = "#00ffffff"
$tabRequirements.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$selectedRequirement = New-Object System.Windows.Forms.Label
$selectedRequirement.Text = ""
$selectedRequirement.AutoSize = $true
$selectedRequirement.Location = "407, 15"
$selectedRequirement.Font = 'Location, 20'
$selectedRequirement.BackColor = "Transparent"
$selectedRequirement.ForeColor = "#000000"
$selectedRequirement.Bold

$outputRequirementsLabel = New-Object System.Windows.Forms.TextBox
$outputRequirementsLabel.Text = ""
$outputRequirementsLabel.Size = "535, 440"
$outputRequirementsLabel.Multiline = $true
$outputRequirementsLabel.Location = "290, 55"
$outputRequirementsLabel.Font = 'Century Gothic, 13'
$outputRequirementsLabel.ScrollBars = "Vertical"
$outputRequirementsLabel.ReadOnly = $true

$gridRequirements = New-Object System.Windows.Forms.DataGridView
$gridRequirements.Name = "Grid"
$gridRequirements.BorderStyle = 0
$gridRequirements.RowHeadersVisible = $false
$gridRequirements.EnableHeadersVisualStyles = $false
$gridRequirements.BackgroundColor = "#bfbfbf"
$gridRequirements.DefaultCellStyle.Font = "Century Gothic, 13"
$gridRequirements.DefaultCellStyle.BackColor = "#ffffff"
$gridRequirements.DefaultCellStyle.SelectionBackColor = "Transparent"
$gridRequirements.DefaultCellStyle.SelectionForeColor = "Transparent"
$gridRequirements.DefaultCellStyle.Alignment = "MiddleCenter"
$gridRequirements.AdvancedCellBorderStyle.All = "None"
$gridRequirements.AllowUserToResizeRows = $false
$gridRequirements.AutoSizeRowsMode = "AllCells";
$gridRequirements.ColumnCount = 1
$gridRequirements.Columns[0].Name = "Requisito";
$gridRequirements.Columns[0].Width = 240;
$gridRequirements.Columns[0].SortMode = "NotSortable";
$gridRequirements.ColumnHeadersBorderStyle = 4
$gridRequirements.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridRequirements.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridRequirements.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridRequirements.ColumnHeadersHeightSizeMode = "DisableResizing"
$gridRequirements.Size = "240, 500"
$gridRequirements.Location = "25, 25"
$gridRequirements.MultiSelect = $false
$gridRequirements.AllowUserToAddRows = $false
$gridRequirements.ReadOnly = $true

$installButton = New-Object System.Windows.Forms.Button
$installButton.BackColor = "#0062cc"
$installButton.Text = "Install"
$installButton.Size = "90, 30"
$installButton.Location = "735, 505"
$installButton.Font = 'Century Gothic, 15'
$installButton.ForeColor = "#ffffff"
$installButton.FlatStyle = "Flat"
$installButton.FlatAppearance.BorderSize = 0;
$installButton.FlatAppearance.MouseOverBackColor = "#003166"
$installButton.Enabled = $false

$tabRequirements.Controls.AddRange(@($selectedRequirement, $outputRequirementsLabel, $gridRequirements, $installButton))

$gridRequirements.Add_Click({ gridRequirements_Click })
$installButton.Add_Click({ installButton_Click })
$selectedRequirement.Add_SizeChanged({ selectedRequirement_SizeChanged })