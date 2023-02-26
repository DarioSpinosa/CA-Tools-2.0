. .\components\modal\Form.ps1
function Invoke-Modal($message, $action){
    $messageLabel.Text = $message
    $postAction = $action
    $modalForm.ShowDialog()
}

function ExitButton_Click() {
    $modalForm.Close()
    switch ($postAction){
        "CLOSE" {
            $mainForm.Close()
        }
        "RESTART" {
            Restart-Computer -Force
        }
    }
}

function MessageLabel_SizeChanged(){
    $messageLabel.Left = ($modalForm.Width - $messageLabel.Width) / 2;
}

 $postAction = ""