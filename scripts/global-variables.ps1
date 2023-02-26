$StartupPath = "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caep-startup.cmd"
$ScarVersion = ""
$ScarConfig = "https://castorybookbloblwebsite.blob.core.windows.net/scar-configs/scarface.config.json"
$addNodeBuildTools = ""
$requirements = Get-Content ".\requirements.json" | ConvertFrom-Json | ConvertPSObjectToHashtable
#don't indent inline. It'll break 
$LIBRARY = @"
[System.Runtime.InteropServices.DllImport("gdi32.dll")] public static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect, int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
"@
$RoundObject = Add-Type -MemberDefinition $LIBRARY -Name "Win32Helpers" -PassThru

$red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
$green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)

$currentDate = (Get-Date -Format yyyyMMdd-HHmmss).ToString()
$checkLogs = @{}
$installationLogs = @{}
$logFilePath = "~\.ca\$currentDate\caep.log"
$capturedPath = "~\.ca\$currentDate\npmErrCheck.txt"
$checkRequirementsLogFile = "~\.ca\$currentDate\requirementsLogs.json" 
$installRequirementsLogfile = "~\.ca\$currentDate\install_requirements.log"
$sortedRequirements = @('WSL', 'Node.js', 'DotNet', 'Visual Studio', 'Visual Studio Code', 'Git', 'Setup CATools', 'NPM', 'Docker', 'Npm Login', 'Install CAEP', 'Execute Scarface')

