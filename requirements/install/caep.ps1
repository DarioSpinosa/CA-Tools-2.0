if ($checkLogs[$name]["Result"].Contains("FOLDER")) {
  invoke-WriteInstallLogs "Creazione directory $("$env:PROGRAMFILES/Ca-Tools") in corso..."
  New-Item -Path "$env:PROGRAMFILES/Ca-Tools" -ItemType Directory
  invoke-WriteInstallLogs "Creazione directory $("$env:PROGRAMFILES/Ca-Tools") terminata"
}

if ($checkLogs[$name]["Result"].Contains("FILE")) {
  invoke-WriteInstallLogs "Download npm login tool $("$env:PROGRAMFILES/Ca-Tools") in corso..."
  Copy-Item "./components/login/npm-login.ps1" -Destination "$env:PROGRAMFILES/Ca-Tools/npm-login.ps1"
  invoke-WriteInstallLogs "Download npm login tool $("$env:PROGRAMFILES/Ca-Tools") terminato"
}

if ($checkLogs[$name]["Result"].Contains("CLI")) {
  invoke-WriteInstallLogs 'Installando @ca/cli...'
  npm install -g @ca/cli
  invoke-WriteInstallLogs 'Installazione di @ca/cli completata'
}

if ($checkLogs[$name]["Result"].Contains("PLUGIN")) {
  invoke-WriteInstallLogs 'Installando @ca/cli-plugin-scarface...'
  ca plugins:install @ca/cli-plugin-scarface@$($requirement['PluginVersion'])
  invoke-WriteInstallLogs 'Installazione di @ca/cli-plugin-scarface completata'
}

return "OK"