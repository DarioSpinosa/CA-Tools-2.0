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
$requirements = ConvertPSObjectToHashtable (Get-Content ".\requirements.json" | ConvertFrom-Json)
$checkRequirementsLogFile = "~\.ca\$currentDate\checkLogs.json" 
$installRequirementsLogfile = "~\.ca\$currentDate\installLogs.json"
$sortedRequirements = @('WSL', 'Node', 'DotNet', 'Visual Studio', 'Visual Studio Code', 'Git', 'NPM', 'Docker', 'Npm Login', 'CAEP')
$red = [System.Drawing.Color]::FromArgb(255, 236, 84, 84)
$yellow = [System.Drawing.Color]::FromArgb(255, 255, 223, 0)
$green = [System.Drawing.Color]::FromArgb(255, 13, 173, 141)
$white = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)