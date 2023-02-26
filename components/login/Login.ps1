function loginButton_Click {
    <#
    .SYNOPSIS
    Login to npm
    .DESCRIPTION
    Takes the input inserted by the user and will try to login to npm
    #>
    # Variables Login npm
    $NpmRegistry = "https://devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/"
    # Check if the fields are empty it won't login
    if (!($UsernameTextBox.Text -ne "") -or !($TokenTextBox.Text -ne "")) {
      $outputInstallationLabel.SelectionColor = "Red"
      Write-Host "Username and Token can't be NULL! Please enter the Username and Password."
      return
    }
  
    # Correct the Username inserted by the User
    $UsernameSplitBS = ($UsernameTextBox.Text).split("@")[0].split("\")
    $UsernameSplitS = $UsernameSplitBS[$UsernameSplitBS.Length - 1].split("/")
    $UsernameFinal = $UsernameSplitS[$UsernameSplitS.Length - 1]
  
    # Execute the login
    Start-Process powershell.exe -ArgumentList "npm-login.ps1 -user $UsernameFinal -token $($TokenTextBox.Text) -registry $NpmRegistry -scope @ca" -NoNewWindow -Wait
    npm config set '@ca:registry' $NpmRegistry
    npm config set '@ca-codegen:registry' $NpmRegistry
    $NpmViewCli = (npm view @ca/cli 2>&1) -join " "
    $doubleCheck = ($NpmViewCli -like "*ERR!*")
    
    # Double check if the credentials inserted are correct or not, if they are then go to the next step of the installation, otherwise ask for the correct credentials.
    if ($doubleCheck) {
      $outputInstallationLabel.SelectionColor = "Red"
      Write-Host "Npm Login Error!`r`nThe Token or the Username are wrong. Check again your Username and Token.`r`nPS: Be sure that the token is setted as 'All Accessible Organization'."
      return
    }
  
    #hide dell'interfaccia mancante
    $outputInstallationLabel.Lines = $NpmViewCli
    Remove-WrongToken($TokenTextBox.Text)
    
    #Start della fase dei requirements
    $loginForm.Close()
    New-Item -Path "~\.ca\$currentDate" -ItemType Directory
    tabButton_Click($requirementsTabButton)
    Invoke-CheckRequirements
    
  }
  
  function Remove-WrongToken($correctToken) {
    <#
    .SYNOPSIS
    Remove the wrong tokens from the .tokens.json
    .DESCRIPTION
    If the login to npm was successful it will remove all the wrong tokens in the .tokens.json file
    #>
    $TokenPath = "~\.token.json"
    $TokenList = Get-Content $TokenPath | ConvertFrom-Json
    $NewTokenList = @()
    foreach ($t in $TokenList) {
      if ($t.token -eq $correctToken) {
        $NewTokenList += $t
      }
    }
    $NewTokenList | ConvertTo-Json | Set-Content -Path $TokenPath -Force
  }

  . .\components\login\Form.ps1
  $loginForm.ShowDialog()