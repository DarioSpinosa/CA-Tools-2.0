function InstallButton_Click() {
    # Main checks
    # Check if the user opened PowerShell as Admin, if not then stop the installation, otherwise check the requirements
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
      Invoke-CallError "PLEASE OPEN POWERSHELL AS ADMINISTRATOR!!!"
      return
    }
    
    # if (-not (Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*") -and ($_.Status -eq "Up") })) {
    #   Invoke-CallError "PLEASE CONNECT TO INTERNET!!!"
    #   return
    # }
  
    $WelcomeForm.Hide()
    . .\components\checkrequirements\CheckRequirements.ps1
}

function Invoke-CallError($Message) {
  . .\components\modal\Modal.ps1
  Invoke-SetError $Message
}

#---------------------------------------------------------------------------------------------------------[LOGIC]---------------------------------------------------------------------------------------------------------
. .\components\welcome\Form.ps1
$WelcomeForm.ShowDialog()