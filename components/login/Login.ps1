param(
  [string]$type = "START"
)

function loginButton_Click {
  <#
    .SYNOPSIS
    Login to npm
    .DESCRIPTION
    Takes the input inserted by the user and will try to login to npm
    #>
  # Check if the fields are empty it won't login
  if (!($usernameTextBox.Text -ne "") -or !($TokenTextBox.Text -ne "")) {
    Write-Host "Username and Token can't be NULL! Please enter the Username and Password."
    return
  }
    
  
  if ($type -eq "LOGIN") {
    if (-not (invoke-login)) { return }
  }

  $loginForm.Hide()
}
  
function invoke-login {
  $errorLabel.Visible = $false
  $npmRegistry = "https://devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/"
  
  # Execute the login
  # http request setting
  $password = ConvertTo-SecureString $($TokenTextBox.Text) -AsPlainText -Force
  $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $($usernameTextBox.Text), $($TokenTextBox.Text))))

  try {
    Invoke-RestMethod -TimeoutSec 1000 `
      -Uri (New-Object System.Uri "https://devops.codearchitects.com:444/Code%20Architects/_apis/packaging/feeds/ca-npm/npm/packages/%40ca%2Fcli/versions/0.1.1/content") `
      -Method "get" `
      -Credential (New-Object System.Management.Automation.PSCredential($($usernameTextBox.Text), $password)) `
      -Headers @{"Accept" = "*/*"; Authorization = ("Basic {0}" -f $base64AuthInfo) } `
      -ContentType 'application/json'
  }
  catch {
    Write-Host "http request failed, Error: $_.Exception"
    $errorLabel.Visible = $true
    return $false
  }
  
  Remove-Item $npmrcPath
  Start-Process powershell.exe -ArgumentList "npm-login.ps1 -token $($TokenTextBox.Text) -registry $npmRegistry -scope @ca -user $($usernameTextBox.Text) " -NoNewWindow -Wait
  npm config set '@ca:registry' $npmRegistry
  npm config set '@ca-codegen:registry' $npmRegistry
  
  "npm view @ca/cli 2>&1 > $capturedPath" | Invoke-Expression
  "npm view @ca-codegen/core 2>&1 >> $capturedPath" | Invoke-Expression
  $npmErrCheck = Get-Content $capturedPath

  invoke-WriteCheckLogs "$capturedPath content: "
  foreach ($element in $npmErrCheck) {
    invoke-WriteCheckLogs "$element"
  }

  # Double check if the credentials inserted are correct or not, if they are then go to the next step of the installation, otherwise ask for the correct credentials.
  foreach ($item in $npmErrCheck) {
    if ( ($item -like '*ERR!*') -or ($item -like '*error*') ) {
      invoke-WriteCheckLogs "Npm Login Error!`r`nThe Token or the Username are wrong. Check again your Username and Token.`r`nPS: Be sure that the token is setted as 'All Accessible Organization'."
      return $false
    }
  }

  Remove-WrongToken($TokenTextBox.Text)
  return $true

}

function Remove-WrongToken($correctToken) {
  <#
    .SYNOPSIS
    Remove the wrong tokens from the .tokens.json
    .DESCRIPTION
    If the login to npm was successful it will remove all the wrong tokens in the .tokens.json file
    #>
  $TokenList = Get-Content $tokenPath | ConvertFrom-Json
  $newTokenList = @()
  foreach ($t in $TokenList) {
    if ($t.token -eq $correctToken) {
      $newTokenList += $t
    }
  }
  $newTokenList | ConvertTo-Json | Set-Content -Path $tokenPath -Force
}

. .\components\login\Form.ps1
if ($type -eq "START") {
  if (-not (Test-Path $npmrcPath)) { return }
  $npmrcContent = (Get-Content $npmrcPath)
  $target = "//devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/:"
  for ($i = 0; $i -lt $npmrcContent.Count; $i++) {
    if ($npmrcContent[$i].Contains($target)) {
      $usernameTextBox.Text = $npmrcContent[$i].Split("=")[1]
      $TokenTextBox.Text = ([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String((($npmrcContent[$i + 1] -split "password=")[1] -replace '"', ''))))
      loginButton_Click
      return
    }
  }
}

$loginForm.ShowDialog()

