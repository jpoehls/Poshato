$voice = New-Object -Com SAPI.SpVoice

function Set-VoiceSpeed([int]$speed) {
    $voice.Rate = $speed;
}

Set-VoiceSpeed -2

function Invoke-VoiceSpeech([string]$what) {

    # replace some common stuff so that it is pronounced right
    $what = $what -replace "iphone", "i-phone"

    $voice.Speak($what, 1) | Out-Null
}
Set-Alias say Invoke-Speech