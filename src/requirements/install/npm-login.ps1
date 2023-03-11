$type = "LOGIN"
#Nel caso in cui NPM non fosse installato, durante i  check non ha potuto eseguire
#il login npm con i dati inseriti durane lo start. Tale operazione viene tentata ora
if ($requirements.Contains("NPM") -and (invoke-login)) {return "OK"}
initialize-login
return "OK"