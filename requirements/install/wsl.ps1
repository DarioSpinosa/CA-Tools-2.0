$result = $requirement["Result"]

if ($result.Contains("VERSION")) {
  if (-not (invoke-executeInstallCommand "wsl --set-default-version 2")) { return "KO" }
}

if ($result.Contains("UBUNTU")) {
  if (-not (invoke-executeInstallCommand "wsl --install -d Ubuntu-$($requirement['MaxVersion'])")) { return "KO" }
}

if ($result.Contains("MAIN")) {
   
  if (-not $result.Contains("VER AVAILABLE")) {
    if (-not (invoke-executeInstallCommand "wsl --install -d Ubuntu-$($requirement['MaxVersion'])")) { return "KO" }
  }

  $minVersion = $requirements[$name]["MinVersion"].split(".")
  $minVersion = [Version]::new($minVersion[0], $minVersion[1], $minVersion[2])

  $maxVersion = $requirements[$name]["MaxVersion"].split(".")
  $maxVersion = [Version]::new($maxVersion[0], $maxVersion[1], $maxVersion[2])

  $output = invoke-executeInstallCommand "wsl -l -v" 
  if (-not $output) { return "KO" }

  foreach ($version in $output.split('')) {
    if (($version -le $minVersion) -or ($version -ge $maxVersion)) { 
      if (-not (invoke-executeInstallCommand " wsl --set-default $version")) { return "KO" }
      break
    }
    
  }
}

return "OK"