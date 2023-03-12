$result = $checkLogs[$name]["Result"]

if ($result.Contains("VERSION") -or $result.Contains("UBUNTU")) {

  if ($result.Contains("VERSION")) {
    if (-not (invoke-executeInstallCommand "wsl --set-default-version 2" "Errore durante il settaggio della default version di wsl")) { return "KO" }
  }
  
  if (-not (invoke-executeInstallCommand "Start-Process powershell { wsl --install -d Ubuntu-$($requirement['MaxVersion']) } -Wait" "Errore durante l'installazione di Ubuntu-$($requirement['MaxVersion'])")) { return "KO" }
}

$versionToSet = if ($result.Contains("SET")) { ($result -split ("SET"))[1] } else { $requirement['MaxVersion'] }
if (-not (invoke-executeInstallCommand "wsl --set-default $versionToSet" "Errore durante il settaggio della default distro di wsl")) { return "KO" }

return "OK"