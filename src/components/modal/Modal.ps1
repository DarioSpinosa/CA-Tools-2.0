function invoke-modal($message) {
  $messageLabel.Text = $message
  $modalForm.ShowDialog() | Out-Null
}

function exitButton_Click {
  $modalForm.Close()
}

. .\src\components\modal\Form.ps1