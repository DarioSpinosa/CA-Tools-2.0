$startLocation = (Get-Location)
$startupPath = "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caep-startup.cmd"

$scarVersion = ""
$scarConfig = "https://castorybookbloblwebsite.blob.core.windows.net/scar-configs/scarface.config.json"
$scarConfigPath = "C:\dev\scarface\scarface.config.json"
$addNodeBuildTools = ""

$tokenPath = "~\.token.json"
$npmrcPath = "~\.npmrc"
$currentDate = (Get-Date -Format yyyyMMdd-HHmmss).ToString()
$checkLogs = @{}
$installLogs = @{}
$logFilePath = "~\.ca\$currentDate\caep.log"
$capturedPath = "~\.ca\$currentDate\npmErrCheck.txt"
$requirements = Get-Content ".\requirements.json" | ConvertFrom-Json | ConvertPSObjectToHashtable
$checkRequirementsLogFile = "~\.ca\$currentDate\checkLogs.json" 
$installRequirementsLogfile = "~\.ca\$currentDate\installLogs.json"
$sortedRequirements = @('WSL', 'Node', 'DotNet', 'Visual Studio', 'Visual Studio Code', 'Git', 'NPM', 'Npm Login', 'CAEP')
#don't indent inline. It'll break 
# $LIBRARY = @"
# [System.Runtime.InteropServices.DllImport("gdi32.dll")] public static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect, int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
# "@
# $RoundObject = Add-Type -MemberDefinition $LIBRARY -Name "Win32Helpers" -PassThru
$red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
$green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)
$white = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)