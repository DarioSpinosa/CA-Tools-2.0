#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.StartPosition = "Manual"
$mainForm.Text = "Installing!"
$mainForm.Location = '700, 250'
$mainForm.ClientSize = '1000, 550'
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = "None"; #The window size can't be changed by the user

#---------------------------------------------------------------------------[SIDEBAR]---------------------------------------------------------------------------
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
$tabOutputRequirementsButton.Text = "Requirements"
$tabOutputRequirementsButton.Size = "150, 75"
$tabOutputRequirementsButton.Location = "0, 100"
$tabOutputRequirementsButton.Font = 'Roboto,10'
$tabOutputRequirementsButton.ForeColor = "#ffffff"
$tabOutputRequirementsButton.FlatStyle = "Flat"
$tabOutputRequirementsButton.FlatAppearance.BorderSize = 0 

$tabOutputInstallationsButton = New-Object System.Windows.Forms.Button
$tabOutputInstallationsButton.BackColor = "#00ffffff"
$tabOutputInstallationsButton.Text = "Installation Output"
$tabOutputInstallationsButton.Size = "150, 75"
$tabOutputInstallationsButton.Location = "0, 175"
$tabOutputInstallationsButton.Font = 'Roboto,10'
$tabOutputInstallationsButton.ForeColor = "#ffffff"
$tabOutputInstallationsButton.FlatStyle = "Flat"
$tabOutputInstallationsButton.FlatAppearance.BorderSize = 0 

$tabInstallationsResultsButton = New-Object System.Windows.Forms.Button
$tabInstallationsResultsButton.BackColor = "#00ffffff"
$tabInstallationsResultsButton.Text = "Installations Results"
$tabInstallationsResultsButton.Size = "150, 75"
$tabInstallationsResultsButton.Location = "0, 250"
$tabInstallationsResultsButton.Font = 'Roboto,10'
$tabInstallationsResultsButton.ForeColor = "#ffffff"
$tabInstallationsResultsButton.FlatStyle = "Flat"
$tabInstallationsResultsButton.FlatAppearance.BorderSize = 0;

#---------------------------------------------------------------------------[TABS]---------------------------------------------------------------------------
$tabRequirements = New-Object System.Windows.Forms.Panel
$tabRequirements.Location = "150, 0"
$tabRequirements.Size = "850, 600"
$tabRequirements.BackColor = "#00ffffff"
$tabRequirements.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$selectedRequirement = New-Object System.Windows.Forms.Label
$selectedRequirement.Text = ""
$selectedRequirement.AutoSize = $true
$selectedRequirement.Location = "607, 15"
$selectedRequirement.Font = 'Location, 20'
$selectedRequirement.BackColor = "Transparent"
$selectedRequirement.ForeColor = "#000000"
$selectedRequirement.Bold

$outputRequirementsLabel = New-Object System.Windows.Forms.TextBox
$outputRequirementsLabel.Text = ""
$outputRequirementsLabel.Size = "435, 440"
$outputRequirementsLabel.Multiline = $true
$outputRequirementsLabel.Location = "390, 55"
$outputRequirementsLabel.Font = 'Century Gothic, 13'
$outputRequirementsLabel.ScrollBars = "Vertical"
$outputRequirementsLabel.ReadOnly = $true

$gridRequirements = New-Object System.Windows.Forms.DataGridView
$gridRequirements.Name = "Grid"
$gridRequirements.BorderStyle = 0
$gridRequirements.RowHeadersVisible = $false
$gridRequirements.EnableHeadersVisualStyles = $false
$gridRequirements.BackgroundColor = "#FFFFFF"
$gridRequirements.DefaultCellStyle.Font = "Century Gothic, 13"
$gridRequirements.DefaultCellStyle.BackColor = "#ffffff"
$gridRequirements.AdvancedCellBorderStyle.All = "None"
$gridRequirements.AllowUserToResizeRows = $false
$gridRequirements.ColumnCount = 2
$gridRequirements.Columns[0].Name = "Requirement";
$gridRequirements.Columns[0].Width = 240;
$gridRequirements.Columns[1].Name = "Status";
$gridRequirements.Columns[1].Width = 82;
$gridRequirements.ColumnHeadersBorderStyle = 4
$gridRequirements.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridRequirements.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridRequirements.ColumnHeadersDefaultCellStyle.BackColor = "#555555"
$gridRequirements.Size = "340, 500"
$gridRequirements.Location = "25, 25"
$gridRequirements.MultiSelect = $false
$gridRequirements.AllowUserToAddRows = $false
$gridRequirements.ReadOnly = $true
$gridRequirements.BackgroundImage = [System.Drawing.Image]::Fromfile(".\assets\background.jpg")

$tabRequirements.Controls.AddRange(@($selectedRequirement, $outputRequirementsLabel, $gridRequirements))

$outputInstallationLabel = New-Object System.Windows.Forms.TextBox
$outputInstallationLabel.Text = ""
$outputInstallationLabel.Size = "750, 500"
$outputInstallationLabel.Multiline = $true
$outputInstallationLabel.Location = "200, 25"
$outputInstallationLabel.Font = 'Roboto,12'
$outputInstallationLabel.ScrollBars = "Vertical"
$outputInstallationLabel.ReadOnly = $true
$outputInstallationLabel.visible = $false

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
$gridInstallation.visible = $false

$postActionButton = New-Object System.Windows.Forms.Button
$postActionButton.BackColor = "#000000"
$postActionButton.Text = ""
$postActionButton.Size = "90, 30"
$postActionButton.Location = "850, 500"
$postActionButton.Font = 'roboto, 13'
$postActionButton.ForeColor = "#ffffff"
$postActionButton.Visible = $false

$installButton = New-Object System.Windows.Forms.Button
$installButton.BackColor = "#000000"
$installButton.Text = "Install"
$installButton.Size = "90, 30"
$installButton.Location = "850, 500"
$installButton.Font = 'roboto, 13'
$installButton.ForeColor = "#ffffff"
$installButton.Visible = $false

$nextButton = New-Object System.Windows.Forms.Button
$nextButton.BackColor = "#000000"
$nextButton.Text = "Install"
$nextButton.Size = "90, 30"
$nextButton.Location = "850, 500"
$nextButton.Font = 'roboto, 13'
$nextButton.ForeColor = "#ffffff"
$nextButton.Visible = $false

$sidebar.Controls.AddRange(@($logo, $tabOutputRequirementsButton, $tabOutputInstallationsButton, $tabInstallationsResultsButton))
$mainForm.Controls.AddRange(@($sidebar, $installButton, $nextButton, $postActionButton, $tabRequirements, $outputInstallationLabel, $gridInstallation))

#---------------------------------------------------------------------------[EVENTS]---------------------------------------------------------------------------
$tabOutputRequirementsButton.Add_Click({ tabButton_Click $tabRequirements })
$tabOutputRequirementsButton.Add_MouseEnter({ Button_MouseEnter $tabOutputRequirementsButton })
$tabOutputRequirementsButton.Add_MouseLeave({ Button_MouseLeave $tabOutputRequirementsButton })

$tabOutputInstallationsButton.Add_Click({ tabButton_Click $outputInstallationLabel })
$tabOutputInstallationsButton.Add_MouseEnter({ Button_MouseEnter $tabOutputInstallationsButton })
$tabOutputInstallationsButton.Add_MouseLeave({ Button_MouseLeave $tabOutputInstallationsButton })

$tabInstallationsResultsButton.Add_Click({ tabButton_Click $gridInstallation })
$tabInstallationsResultsButton.Add_MouseEnter({ Button_MouseEnter $tabInstallationsResultsButton })
$tabInstallationsResultsButton.Add_MouseLeave({ Button_MouseLeave $tabInstallationsResultsButton })

$postActionButton.Add_Click({ postAction_Click })
$installButton.Add_Click({ installButton_Click })
$nextButton.Add_Click({ nextButton_Click })
$gridRequirements.Add_Click({ gridRequirementrs_Click })
$selectedRequirement.Add_SizeChanged({ selectedRequirement_SizeChanged })