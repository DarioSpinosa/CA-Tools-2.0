#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------

function startButton_Click {
  $startButton.Enabled = $false
  
  # Check if the user opened PowerShell as Admin, if not then stop the installation, otherwise check the requirements
  if (-not ((invoke-executeCommand "Get-LocalGroupMember -Group Administrators") -like "*$(whoami)*")) {
    Invoke-Modal "L'utente attuale non risulta essere l'amministratore della macchina"
    $mainForm.Close()
    return
  }
  
  if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Invoke-Modal "L'applicazione non e' stata aperta come amministratore"
    $mainForm.Close()
    return
  }
      
  if (-not (Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*") -and ($_.Status -eq "Up") })) {
    Invoke-Modal "Nessuna connessione ad internet rilevata"
    $mainForm.Close()
    return
  }

  #Check delle connessioni ad AzureDevops, Nuget e Npm Registry, e log repository (opzionale)
  $gridConnections.DataSource = $null
  $gridConnections.Rows.Clear()

  $results = @{}
  $results.Add('CA Azure Devops', $(if ((Test-NetConnection devops.codearchitects.com -port 444).TcpTestSucceeded) { $white } else { $red }))
  $results.Add('Npm Registry', $(if (((Invoke-WebRequest -Uri https://registry.npmjs.org -UseBasicParsing -DisableKeepAlive).StatusCode -eq 200)) { $white } else { $red }))
  $results.Add('Nuget Registry', $(if ((((Invoke-WebRequest -Uri https://api.nuget.org/v3/index.json -UseBasicParsing -DisableKeepAlive).StatusCode) -eq 200 )) { $white } else { $red }))
  $results.Add('Log Repo(Opzionale)', $(if ((Test-NetConnection casftp.blob.core.windows.net -port 22).TcpTestSucceeded) { $white } else { $red }))
   
  foreach ($row in $results.Keys) { 
    Invoke-CreateRow $gridConnections @($row, [System.Drawing.Image]::Fromfile('./assets/V.png')) $results[$row] 
    $gridConnections.ClearSelection()
  }
  if (-not ($results['CA Azure Devops'] -and $results['Npm Registry'] -and $results['Nuget Registry'])) { 
    $startButton.Enabled = $true
    return 
  }
  
  #Check presenza di variabili d'ambiente fondamentali. In caso manchino vengono aggiunte nell'immediato
  $envVar = @{}
  $envVar.Add("C:\Windows", "Gia' presente")
  $envVar.Add("C:\Windows\System32", "Gia' presente")
  $envVar.Add("C:\Windows\System32\Wbem", "Gia' presente")
  $envVar.Add("C:\Windows\System32\WindowsPowerShell\v1.0\", "Gia' presente")
  $envVar.Add("$env:PROGRAMFILES\Git\Users\bin\", "Gia' presente")
  $envVar.Add("$env:PROGRAMFILES\Git\cmd", "Gia' presente")
  $envVar.Add("$env:PROGRAMFILES\Nodejs", "Gia' presente")
  $envVar.Add("$env:PROGRAMFILES\Ca-Tools", "Gia' presente")

  $envInPath = $env:PATH.ToLower().Split(';')
  foreach ($var in $envVar.Keys) {
    if (-not ($envInPath.Contains($var.ToLower()))) {
      [System.Environment]::SetEnvironmentVariable("PATH", (("$Env:PATH;$var") -replace ";;", ";"), "Machine")
      $envVar[$var] = "Aggiunta"
    }
  }

  $gridEnvVar.DataSource = $null
  $gridEnvVar.Rows.Clear()
  foreach ($env in $envVar.Keys) { 
    Invoke-CreateRow $gridEnvVar @($env, $envVar[$env]) $white
  }

  #Check presenza di un proxy
  $proxyCheck.Image = $(if (invoke-checkProxy) { [System.Drawing.Image]::Fromfile(".\assets\V.png") } else { [System.Drawing.Image]::Fromfile(".\assets\X.png") })
  
  #Check se l'ambiente di running è una Virtual machine
  $vmCheck.Image = $(if (invoke-checkVM) { [System.Drawing.Image]::Fromfile(".\assets\V.png") } else { [System.Drawing.Image]::Fromfile(".\assets\X.png") })

  # Check Abilitazione Windows Features
  if (-not ($scarConfig.Contains('terranova'))) {
    $message = ""
    $state = (Get-WindowsOptionalFeature -Online -FeatureName *Windows-Subsystem-Linux*).State
    if (($state -eq 'Disabled') -or ($state -eq 'Disattivata')) {
      $message = "Microsoft Windows Feature"
      invoke-executeCommand "& dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"
    }
  
    $state = (Get-WindowsOptionalFeature -Online -FeatureName *VirtualMachinePlatform*).State
    if (($state -eq 'Disabled') -or ($state -eq 'Disattivata')) {
      if ($message) { $message += " e " }
      $message += "Virtual Machine Platform "
      invoke-executeCommand "& dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"
    }
  
    if ($message) {
      $message += "non risulta/risultano abilitata/e. Il sistema procedera all'attivazione e il sistema verra riavviato. Premere OK per procedere"
      Invoke-Modal $message
      Restart-Computer -Force
      return
    }
  }

  #inserimento Credenziali login npm
  . .\components\login\Login.ps1
  
  New-Item -Path "~\.ca\$currentDate" -ItemType Directory
  tabButton_Click($requirementsTabButton)
  Invoke-CheckRequirements
}

function infoVmButton_Click {
  Invoke-Modal "In caso affermativo accertarsi che sia abilitata la nested virtualization prima di proseguire"
}

function infoProxyButton_Click {
  Invoke-Modal "Notifica se e' stato rilevato un proxy o meno"
}

. .\components\Tabs\Start\Form.ps1