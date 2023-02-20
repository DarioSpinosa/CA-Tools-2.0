function Invoke-SetError($message){
    $messageLabel.Text = $message
    $modalForm.ShowDialog()
}

function ExitButton_Click() {
    $modalForm.Close()
    $welcomeForm.Close()
}

function MessageLabel_SizeChanged(){
    $messageLabel.Left = ($modalForm.Width - $messageLabel.Width) / 2;
}

. .\components\modal\Form.ps1
 