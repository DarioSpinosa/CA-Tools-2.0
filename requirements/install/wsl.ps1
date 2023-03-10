$result = $checkLogs[$name]["Result"]

if ($result.Contains("VERSION") -or $result.Contains("UBUNTU")) {

  if ($result.Contains("VERSION")) {
    if (-not (invoke-executeInstallCommand "wsl --set-default-version 2")) { return "KO" }
  }
  
  if (-not (invoke-executeInstallCommand "Start-Process powershell { wsl --install -d Ubuntu-$($requirement['MaxVersion']) } -Wait")) { return "KO" }
}

$versionToSet = if ($result.Contains("SET")) { ($result -split ("SET"))[1] } else { $requirement['MaxVersion'] }
if (-not (invoke-executeInstallCommand "wsl --set-default $versionToSet")) { return "KO" }

return "OK"