if ($checkLogs[$name]["Result"].Contains("FOLDER")) {
  New-Item -Path "$env:PROGRAMFILES/Ca-Tools" -ItemType Directory
}

if ($checkLogs[$name]["Result"].Contains("FILE")) {
  Copy-Item "./../../login/npm-login.ps1" -Destination "$env:PROGRAMFILES/Ca-Tools/npm-login.ps1"
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