if ($checkLogs[$name]["Result"].Contains("FOLDER")) {
  invoke-WriteInstallLogs "Creazione directory $("$env:PROGRAMFILES/Ca-Tools") in corso..."
  if (-not (invoke-executeInstallCommand "New-Item -Path '$env:PROGRAMFILES/Ca-Tools' -ItemType Directory")) { return "KO"}
  invoke-WriteInstallLogs "Creazione directory $("$env:PROGRAMFILES/Ca-Tools") terminata"
}

if ($checkLogs[$name]["Result"].Contains("FILE")) {
  invoke-WriteInstallLogs "Download npm login tool $("$env:PROGRAMFILES/Ca-Tools") in corso..."
  if (-not (invoke-executeInstallCommand "Copy-Item './components/login/npm-login.ps1' -Destination '$env:PROGRAMFILES/Ca-Tools/npm-login.ps1'")) { return "KO"}
  invoke-WriteInstallLogs "Download npm login tool $("$env:PROGRAMFILES/Ca-Tools") terminato"
}

if ($checkLogs[$name]["Result"].Contains("CLI")) {
  invoke-WriteInstallLogs 'Installando @ca/cli...'
  if (-not (invoke-executeInstallCommand "npm install -g @ca/cli")) { return "KO"}
  invoke-WriteInstallLogs 'Installazione di @ca/cli completata'
}

if ($checkLogs[$name]["Result"].Contains("PLUGIN")) {
  invoke-WriteInstallLogs 'Installando @ca/cli-plugin-scarface...'
  if (-not (invoke-executeInstallCommand "ca plugins:install @ca/cli-plugin-scarface@$($requirement['PluginVersion']))")) { return "KO"}
  invoke-WriteInstallLogs 'Installazione di @ca/cli-plugin-scarface completata'
}

return "OK"