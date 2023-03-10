#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------

function startButton_Click {
  $startButton.Enabled = $false
  
  # Check if the user opened PowerShell as Admin, if not then stop the Install, otherwise check the requirements
  if (-not ((invoke-executeCommand "Get-LocalGroupMember -Group Administrators") -like "*$(whoami)*")) {
    invoke-modal  "L'utente attuale non risulta essere l'amministratore della macchina"
    $mainForm.Close()
    return
  }
  
  if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    invoke-modal  "L'applicazione non e' stata aperta come amministratore"
    $mainForm.Close()
    return
  }
    
  if (-not (Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*") -and ($_.Status -eq "Up") })) {
    invoke-modal  "Nessuna connessione ad internet rilevata"
    $mainForm.Close()
    return
  }

  #Check delle connessioni ad AzureDevops, Nuget e Npm Registry, e log repository (opzionale)
  $gridConnections.DataSource = $null
  $gridConnections.Rows.Clear()

  $results = @{}
  $results.Add('CA Azure Devops', $(if ((Test-NetConnection devops.codearchitects.com -port 444).TcpTestSucceeded) { $true } else { $false }))
  $results.Add('Npm Registry', $(if (((Invoke-WebRequest -Uri https://registry.npmjs.org -UseBasicParsing -DisableKeepAlive).StatusCode -eq 200)) { $true } else { $false }))
  $results.Add('Nuget Registry', $(if ((((Invoke-WebRequest -Uri https://api.nuget.org/v3/index.json -UseBasicParsing -DisableKeepAlive).StatusCode) -eq 200 )) { $true } else { $false }))
  $results.Add('Log Repo(Opzionale)', $(if ((Test-NetConnection casftp.blob.core.windows.net -port 22).TcpTestSucceeded) { $true } else { $false }))
   
  foreach ($row in $results.Keys) { 
    Invoke-CreateRow $gridConnections @($row, $(if($results[$row]) { [System.Drawing.Image]::Fromfile('./assets/IconV.png')} else {[System.Drawing.Image]::Fromfile('./assets/IconX.png')}))
    $gridConnections.ClearSelection()
  }

  if (-not ($results['CA Azure Devops'] -and $results['Npm Registry'] -and $results['Nuget Registry'])) { 
    invoke-modal "Una o piu connessioni ai server sono fallite, riprovare"
    $startButton.Enabled = $true
    return 
  }
  
  #Check presenza di variabili d'ambiente fondamentali. In caso manchino vengono aggiunte nell'immediato
  $gridEnvVar.DataSource = $null
  $gridEnvVar.Rows.Clear()
  $envVar = @("C:\Windows", "C:\Windows\System32", "C:\Windows\System32\Wbem", "C:\Windows\System32\WindowsPowerShell\v1.0\", "$env:PROGRAMFILES\Ca-Tools", "$env:PROGRAMFILES\Git\cmd", "$env:PROGRAMFILES\Git\Users\bin\", "$env:PROGRAMFILES\Nodejs\")
  $envInPath = $env:PATH.ToLower().Split(';')

  foreach ($var in $envVar) {
    $result = "Presente"
    if (-not ($envInPath.Contains($var.ToLower()))) {
      [System.Environment]::SetEnvironmentVariable("PATH", (("$Env:PATH;$var") -replace ";;", ";"), "Machine")
      $result = "Aggiunta"
    }

    Invoke-CreateRow $gridEnvVar @($var, $result)
  }

  #Check presenza di un proxy
  $proxyCheck.Image = $(if (invoke-checkProxy) { [System.Drawing.Image]::Fromfile(".\assets\V.png") } else { [System.Drawing.Image]::Fromfile(".\assets\X.png") })
  $proxyCheck.Refresh()
  
  #Check se l'ambiente di running ?? una Virtual machine
  $vmCheck.Image = $(if (invoke-checkVM) { [System.Drawing.Image]::Fromfile(".\assets\V.png") } else { [System.Drawing.Image]::Fromfile(".\assets\X.png") })
  $vmCheck.Refresh()
  
  # Check Abilitazione Windows Features
  if (-not ($scarConfig.Contains('terranova'))) {
    $message = ""
    $state = (Get-WindowsOptionalFeature -Online -FeatureName *Windows-Subsystem-Linux*).State
    if (($state -eq 'Disabled') -or ($state -eq 'Disattivata')) {
      $message = "Microsoft Windows Feature"
      invoke-executeCommand "& dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"
      $WSLCheck.Image = [System.Drawing.Image]::Fromfile(".\assets\X.png") 
    }
    else {
      $WSLCheck.Image = [System.Drawing.Image]::Fromfile(".\assets\V.png") 
    }
    $WSLCheck.Refresh()

    $state = (Get-WindowsOptionalFeature -Online -FeatureName *VirtualMachinePlatform*).State
    if (($state -eq 'Disabled') -or ($state -eq 'Disattivata')) {
      if ($message) { $message += " e " }
      $message += "Virtual Machine Platform "
      invoke-executeCommand "& dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"
      $VMPlatformCheck.Image = [System.Drawing.Image]::Fromfile(".\assets\X.png") 
    }
    else {
      $VMPlatformCheck.Image = [System.Drawing.Image]::Fromfile(".\assets\V.png") 
    }
    $VMPlatformCheck.Refresh()

    if ($message) {
      $message += "non risulta/risultano abilitata/e. Il sistema procedera all'attivazione e il sistema verra riavviato. Premere OK per procedere"
      invoke-modal  $message
      Restart-Computer -Force
      return
    }
  }

  #inserimento Credenziali login npm
  initialize-login
  
  New-Item -Path "~\.ca\$currentDate" -ItemType Directory
  tabButton_Click($requirementsTabButton)
  Invoke-CheckRequirements
}


function tabStart_VisibleChanged {
  $gridConnections.ClearSelection()
  $gridEnvVar.ClearSelection()
}

function infoEnvVarutton_Click {
  invoke-modal "Cliccando su una variabile d'ambiente essa verra' copiata negli appunti"
}
function infoVmButton_Click {
  invoke-modal "In caso affermativo accertarsi che sia abilitata la nested virtualization prima di proseguire"
}

function infoProxyButton_Click {
  invoke-modal "Notifica se e' stato rilevato un proxy o meno"
}

function infoVMPLatformButton_Click {
  invoke-modal "Notifica se la windows feature 'Virtual Machine Platform' e' abilitata"
}

function infoWSLButton_Click {
  invoke-modal "Notifica se la windows feature 'Windows Subsystem for Linux' e' abilitata"
}

function gridConnections_CellContentClick {
  $cellClicked = $gridConnections.CurrentRow.Cells[0].Value.ToString()
  if ($cellClicked -eq "Log Repo(Opzionale)") { return }
  Start-Process $connections[$gridConnections.CurrentRow.Cells[0].Value.ToString()]
}

function gridEnvVar_Click {
  Set-Clipboard -Value ($gridEnvVar.CurrentRow.Cells[0].Value)
}

. .\src\components\Tabs\Start\Form.ps1
$connections = @{}
$connections.Add('CA Azure Devops', "https:\\devops.codearchitects.com:444")
$connections.Add('Npm Registry', "https://registry.npmjs.org")
$connections.Add('Nuget Registry', "https://api.nuget.org/v3/index.json")
$connections.Add('Log Repo(Opzionale)', "https:\\casftp.blob.core.windows.net:22")