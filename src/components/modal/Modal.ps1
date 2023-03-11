function invoke-modal($message) {
  $newString = ""
  for ($i = 0; $i -lt $message.length; $i++) {
    $newString += $message[$i]
    if ((($i + 1) % 40 -eq 0)) { $newString += "`n" }
  }
  $messageLabel.Text = $newString
  $messageLabel.Location = "10, 10"
  $modalForm.ShowDialog() | Out-Null
}

function exitButton_Click {
  $modalForm.Close()
}

. .\src\components\modal\Form.ps1