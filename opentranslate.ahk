; -------------------------------------------------
; Sabit pencere boyutu ve pozisyon
newW := 1200
newH := 800
x    := 360
y    := 140

; Her key için saklayacağımız process ID (PID) tablosu
Windows := {}

; -------------------------------------------------
; url ile Chrome'da yeni pencere açar veya kayıtlı pencereyi getirir
OpenOrPosition(url, key){
    global x, y, newW, newH, Windows

    ; Eğer daha önce kaydettiğimiz PID hâlâ açık bir pencereye sahipse
    if ( Windows.HasKey(key) && WinExist("ahk_pid " . Windows[key]) ) {
        ; Mevcut pencereyi öne getir
        WinActivate, % "ahk_id " . Windows[key]
    }
    else {
        ; Yeni Chrome penceresini --new-window parametresiyle aç ve PID’ini al
        Run, chrome.exe --new-window "%url%", , , newPID
        ; O pencerenin hazır olmasını bekle
        WinWait, ahk_pid %newPID%, , 5
        if ErrorLevel {
            MsgBox, %key% penceresi açılırken zaman aşımına uğradı!
            return
        }
        ; Yeni pencerenin PID’sini kaydet
        Windows[key] := newPID
    }

    ; Pencereyi hep aynı pozisyon & boyuta getir
    WinMove, ahk_pid . Windows[key], , x, y, newW, newH
}

; -------------------------------------------------
; Ctrl+Alt+G → ChatGPT
^!g::
    OpenOrPosition("https://chatgpt.com/", "ChatGPT")
return

; Ctrl+Alt+T → Google Translate
^!t::
    OpenOrPosition("https://translate.google.com/", "Translate")
return
