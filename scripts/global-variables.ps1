$StartupPath = "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caep-startup.cmd"
$ScarVersion = ""
$ScarConfig = "https://castorybookbloblwebsite.blob.core.windows.net/scar-configs/scarface.config.json"
$addNodeBuildTools = ""
$Requirements = Get-Content ".\requirements.json" | ConvertFrom-Json | ConvertPSObjectToHashtable
#don't indent inline. It'll break 
$LIBRARY = @"
[System.Runtime.InteropServices.DllImport("gdi32.dll")] public static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect, int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
"@
$RoundObject = Add-Type -MemberDefinition $LIBRARY -Name "Win32Helpers" -PassThru
$currentDate = (Get-Date -Format yyyyMMdd-HHmm).ToString()
$logFilePath = "~\.ca\$currentDate\caep.log"
$InstallRequirementsLogfile = "$($HOME)\.ca\$currentDate\install_requirements.log"
$IndexRequirement = 0
