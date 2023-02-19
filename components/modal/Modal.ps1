. .\components\modal\Form.ps1

function Invoke-SetError($Message){
    $MessageLabel.Text = $Message
    $ModalForm.ShowDialog()
}

function ExitButton_Click() {
    $ModalForm.Close()
    $WelcomeForm.Close()
}

function MessageLabel_SizeChanged(){
    $MessageLabel.Left = ($ModalForm.Width - $MessageLabel.Width) / 2;
}
 