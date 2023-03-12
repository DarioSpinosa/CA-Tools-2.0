function initialize-login {
  if ($type -eq "START") {
    if (Test-Path $npmrcPath) {
      $npmrcContent = (Get-Content $npmrcPath)
      $target = "//devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/:"
      for ($i = 0; $i -lt $npmrcContent.Count; $i++) {
        if ($npmrcContent[$i].Contains($target)) {
          $usernameTextBox.Text = $npmrcContent[$i].Split("=")[1]
          $TokenTextBox.Text = ([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String((($npmrcContent[$i + 1] -split "password=")[1] -replace '"', ''))))
          if (loginButton_Click) { return }
          else { break }
        }
      }
    }
  }
  
  $loginForm.ShowDialog() | Out-Null
}

function loginButton_Click {
  <#
    .SYNOPSIS
    Login to npm
    .DESCRIPTION
    Takes the input inserted by the user and will try to login to npm
    #>
  # Check if the fields are empty it won't login
  if (!($usernameTextBox.Text) -or !($TokenTextBox.Text)) {
    invoke-modal  "L'username e la password non possono essere vuoti"
    return $false
  }
    
  
  if ($type -eq "LOGIN") {
    if (-not (invoke-login)) { return }
  }

  $loginForm.Hide()
  return $true
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
  . ./src/components/login/npm-login.ps1 -user $($usernameTextBox.Text) -token $($TokenTextBox.Text) -registry $npmRegistry -scope @ca
  npm config set '@ca:registry' $npmRegistry
  npm config set '@ca-codegen:registry' $npmRegistry

  if ($type -eq "START") {
    $result = invoke-executeCheckCommand "npm view @ca/cli 2>&1" "Errore dell'esecuzione di npm view @ca/cli 2>&1"
    if (!$result) { return $false }
    $result += invoke-executeCheckCommand "npm view @ca-codegen/core 2>&1" "Errore dell'esecuzione di npm view @ca-codegen/core 2>&1"
    if (!$result) { return $false }

    foreach ($item in $result) { invoke-WriteCheckLogs $item }
    if ($checkLogs["Npm Login"]["Result"].Contains("ERR")) { return $false}
  }
  else {
    $result = invoke-executeInstallCommand "npm view @ca/cli 2>&1" "Errore dell'esecuzione di npm view @ca/cli 2>&1"
    if (!$result) { return $false }
    $result += invoke-executeInstallCommand "npm view @ca-codegen/core 2>&1" "Errore dell'esecuzione di npm view @ca-codegen/core 2>&1"
    if (!$result) { return $false }

    foreach ($item in $result) { invoke-WriteCheckLogs $item }
    if ($installLogs["Npm Login"]["Result"].Contains("ERR")) { return $false}
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

. .\src\components\login\Form.ps1
$type = "START"

