#--------------------------------------------------------[FUNCTIONS]--------------------------------------------------------
function invoke-checks {
  # Main checks
  # Check if the user opened PowerShell as Admin, if not then stop the installation, otherwise check the requirements
  $whoAmI = whoami
  # if (-not ((invoke-executeCommand "Get-LocalGroupMember -Group Administrators") -like "*$whoAmI*")) {
  #   Invoke-CallError "L'UTENTE ATTUALE NON E' L'AMMINISTRATORE DELLA MACCHINA"
  #   return $false
  # }

  # if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  #   Invoke-CallError "L'APPLICAZIONE NON E' STATA APERTA COME AMMINISTRATORE!!!"
  #   return $false
  # }
    
  if (-not (Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*") -and ($_.Status -eq "Up") })) {
    Invoke-CallError "NESSUNA CONNESSIONE AD INTERNET RILEVATA"
    return $false
  }

  return $true
}

function invoke-check-connections {
  $failedImage = [System.Drawing.Image]::Fromfile(".\assets\X.png")
  $succedImage = [System.Drawing.Image]::Fromfile(".\assets\V.png")
  $azureResult = (Test-NetConnection devops.codearchitects.com -port 444).TcpTestSucceeded
  $npmResult = ((Invoke-WebRequest -Uri https://registry.npmjs.org -UseBasicParsing -DisableKeepAlive).StatusCode -eq 200)
  $nugetResult = (((Invoke-WebRequest -Uri https://api.nuget.org/v3/index.json -UseBasicParsing -DisableKeepAlive).StatusCode) -eq 200)
  $logResult = ((Test-NetConnection casftp.blob.core.windows.net -port 22).TcpTestSucceeded)

  $azureCheck.Image = $(if ($azureResult) { $succedImage } else { $failedImage })
  $npmCheck.Image = $(if ($npmResult) { $succedImage } else { $failedImage })
  $nugetCheck.Image = $(if ($nugetResult) { $succedImage } else { $failedImage })
  $logCheck.Image = $(if ($logResult) { $succedImage } else { $failedImage })

  return ($azureResult -and $npmResult -and $nugetResult)
}

function startButton_Click {

  #Check delle connessioni ad AzureDevops, Nuget e Npm Registry, e log repository (opzionale)
  if (-not (invoke-check-connections)) { 
    $connectionButton.Enabled = $true 
    $startButton.Enabled = $false
    return
  }

  #Check Abilitazione Windows Features
  if (-not ($scarConfig.Contains('terranova'))) {
    $message = ""
    $state = (Get-WindowsOptionalFeature -Online -FeatureName *Windows-Subsystem-Linux*).State
    if (($state -like '*Disabled*') -or ($state -like '*Disattivata*')) {
      $message = "Microsoft Windows Feature"
      invoke-executeCommand "& dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"
    }

    $state = (Get-WindowsOptionalFeature -Online -FeatureName *VirtualMachinePlatform*).State
    if (($state -like '*Disabled*') -or ($state -like '*Disattivata*')) {
      if ($message) { $message += " e " }
      $message = "Virtual Machine Platform "
      invoke-executeCommand "& dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"
    }

    if ($message) {
      $message += "non risultava/risultavano abilitata/e. Il sistema procedera all'attivazione e il sistema verra riavviato. Premere OK per procedere"
      Invoke-CallError $message
      Wait-Event -SourceIdentifier $modalForm.Close()
      Restart-Computer
    }
  }

  #Check presenza di variabili d'ambiente fondamentali. In caso manchino vengono aggiunte nell'immediato
  $missingEnvVars = (Get-MissingEnvironmentVariablePath @("C:\windows", "C:\windows\system32", "C:\windows\system32\wbem", "C:\windows\system32\windowspowershell\v1.0"))
  if ($missingEnvVars) { 
    [System.Environment]::SetEnvironmentVariable("PATH", (($Env:PATH + $missingEnvVars) -replace ";;", ";"), "Machine")
    Invoke-CallError "Sono state aggiunte le seguenti variabili d'ambiente mancanti $missingEnvVars"
    Wait-Event -SourceIdentifier $modalForm.Close()
  }

  invoke-checkProxy

  #Check se l'ambiente di running è una Virtual machine
  if (@('VMware Virtual Platform', 'Virtual Machine', 'Macchina Virtuale').Contains((Get-CimInstance win32_computersystem).model)) {
    Invoke-CallError "L'ambiente in cui si sta cercando di installare il CAEP e' una macchina virtuale. Prima di proseguire accertarsi che la nested virtualization sia stata abilitata"
    Wait-Event -SourceIdentifier $modalForm.Close()
  }

    
  #Carico la form principale
  $welcomeForm.Hide()
  . .\components\homePage\HomePage.ps1 -timer $timer
}

function connectionButton_Click {
  $startButton.Enabled = invoke-check-connections
}

function label_Click($url) {
  Start-Process $url
}

function Invoke-CallError($Message) {
  . .\components\modal\Modal.ps1
  Invoke-Modal $Message
}

#--------------------------------------------------------[LOGIC]--------------------------------------------------------
. .\components\welcome\Form.ps1
if (-not (invoke-checks)) { return }
New-Item -Path "~\.ca\$currentDate" -ItemType Directory
$welcomeForm.ShowDialog()