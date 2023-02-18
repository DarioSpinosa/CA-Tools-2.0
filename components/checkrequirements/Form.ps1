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

$tabOutputButton = New-Object System.Windows.Forms.Button
$tabOutputButton.BackColor = "#00ffffff"
$tabOutputButton.Text = "Output"
$tabOutputButton.Size = "150, 75"
$tabOutputButton.Location = "0, 100"
$tabOutputButton.Font = 'Roboto,10'
$tabOutputButton.ForeColor = "#ffffff"
$tabOutputButton.FlatStyle = "Flat"
$tabOutputButton.FlatAppearance.BorderSize = 0 
# $tabOutputButton.FlatAppearance.MouseOverBackColor = "#cccccc"

$tabCheckRequirementsResultsButton = New-Object System.Windows.Forms.Button
$tabCheckRequirementsResultsButton.BackColor = "#00ffffff"
$tabCheckRequirementsResultsButton.Text = "Requirements Results"
$tabCheckRequirementsResultsButton.Size = "150, 75"
$tabCheckRequirementsResultsButton.Location = "0, 175"
$tabCheckRequirementsResultsButton.Font = 'Roboto,10'
$tabCheckRequirementsResultsButton.ForeColor = "#ffffff"
$tabCheckRequirementsResultsButton.FlatStyle = "Flat"
$tabCheckRequirementsResultsButton.FlatAppearance.BorderSize = 0;
# $tabCheckRequirementsResultsButton.FlatAppearance.MouseOverBackColor = "#cccccc"

$outputLabel = New-Object System.Windows.Forms.TextBox
$outputLabel.Text = ""
$outputLabel.Size = "750, 500"
$outputLabel.Multiline = $true
$outputLabel.Location = "200, 25"
$outputLabel.Font = 'Roboto,12'
$outputLabel.ScrollBars = "Vertical"
$outputLabel.ReadOnly = $true

$gridResults = New-Object System.Windows.Forms.DataGridView
$gridResults.Name = "Grid"
$gridResults.BorderStyle = 0
$gridResults.RowHeadersVisible = $false
$gridResults.EnableHeadersVisualStyles = $false
$gridResults.BackgroundColor = "#ffffff"
$gridResults.DefaultCellStyle.Font = "Century Gothic, 13"
$gridResults.DefaultCellStyle.BackColor = "#ffffff"
$gridResults.AdvancedCellBorderStyle.All = "None"
$gridResults.ColumnCount = 2
$gridResults.Columns[0].Name = "Requirement";
$gridResults.Columns[1].Name = "Status";
$gridResults.ColumnHeadersBorderStyle = 4
$gridResults.ColumnHeadersDefaultCellStyle.Font = "Century Gothic, 15"
$gridResults.ColumnHeadersDefaultCellStyle.ForeColor = "#ffffff"
$gridResults.ColumnHeadersDefaultCellStyle.BackColor = "#2f5a84"
$gridResults.AutoSizeColumnsMode = "Fill"
$gridResults.Size = "750, 450"
$gridResults.Location = "200, 25"
$gridResults.MultiSelect = $false
$gridResults.AllowUserToAddRows = $false

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.BackColor = "#ffffff"
$closeButton.Text = "End"
$closeButton.Size = "125, 40"
$closeButton.Location = "650, 485"
$closeButton.Font = 'Roboto, 14'
$closeButton.ForeColor = "#000000"
$closeButton.FlatStyle = "Flat"
$closeButton.FlatAppearance.BorderSize = 0 
$closeButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$nextButton = New-Object System.Windows.Forms.Button
$nextButton.BackColor = "#ffffff"
$nextButton.Text = "Next"
$nextButton.Size = "125, 40"
$nextButton.Location = "800, 485"
$nextButton.Font = 'Roboto,14'
$nextButton.ForeColor = "#000000"
$nextButton.FlatStyle = "Flat"
$nextButton.FlatAppearance.BorderSize = 0 

$sidebar.Controls.AddRange(@($logo, $tabOutputButton, $tabCheckRequirementsResultsButton, $closeButton, $nextButton))
$mainform.Controls.AddRange(@($sidebar, $outputLabel))

$tabCheckRequirementsResultsButton.Add_Click({ tabCheckRequirementsResultsButton_Click })
$tabCheckRequirementsResultsButton.Add_MouseEnter({ Button_MouseEnter($tabCheckRequirementsResultsButton) })
$tabCheckRequirementsResultsButton.Add_MouseLeave({ Button_MouseLeave($tabCheckRequirementsResultsButton) })

$tabOutputButton.Add_Click({ tabOutputButton_Click })
$tabOutputButton.Add_MouseEnter({ Button_MouseEnter($tabOutputButton) })
$tabOutputButton.Add_MouseLeave({ Button_MouseLeave($tabOutputButton) })

$closeButton.Add_MouseEnter({ Button2_MouseEnter($closeButton) })
$closeButton.Add_MouseLeave({ Button2_MouseLeave($closeButton) })

$nextButton.Add_Click({ nextButton_Click })
$nextButton.Add_MouseEnter({ Button2_MouseEnter($nextButton) })
$nextButton.Add_MouseLeave({ Button2_MouseLeave($nextButton) })
