function Invoke-Modal($message){
    $newString = ""
    for ($i = 0; $i -lt $message.length; $i++){
        $newString += $message[$i]
        if ((($i + 1) % 40 -eq 0)) { $newString += "`n"}
    }
    $messageLabel.Text = $newString
    $messageLabel.Location = "10, 10"
    $modalForm.ShowDialog()
}

function ExitButton_Click() {
    $modalForm.Close()
}

function MessageLabel_SizeChanged(){
    $messageLabel.Left = ($modalForm.Width - $messageLabel.Width) / 2;
}

 . .\components\modal\Form.ps1