#^!s:: ; Windows + Ctrl + Alt + S to swap windows
    SwapAllWindows()
return

#^!t::  ; Ctrl + Alt + Windows + T 
    OpenTranslate()
return

SwapAllWindows() {
    ; Ekran çözünürlüklerini al
    ; SysGet, Monitor1X, Monitor, 1, Left
    ;SysGet, Monitor1Width, Monitor, 1, Width
    ;SysGet, Monitor2X, Monitor, 2, Left
    ;SysGet, Monitor2Width, Monitor, 2, Width
    ;MsgBox , %Monitor1X% , %Monitor2X% , %Monitor1Width%

    ;;;; İMPORTANT !! my first screent DPI setting is %125 and second is %100

    SysGet, MonitorCount, MonitorCount
    MsgBox, There is %MonitorCount% monitor
    if (MonitorCount < 2){
        return
    }
    ; Monitor configurations (adjust as needed)
    Monitor1X := 0
    Monitor1Width := 1920
    Monitor2X := Round(1920 *1.25) 
    Monitor2Width := Round(1680 *1.25)

    Monitor1EndX := Monitor1X + Monitor1Width
    Monitor2EndX := Monitor2X +Monitor2Width

    ; Get all windows
    WinGet, WindowList, List
    Loop %WindowList% {
        thisID := WindowList%A_Index%

        ; Get window position & size
        WinGetPos, WinX, WinY, WinWidth, WinHeight, ahk_id %thisID%
        
        WinGetTitle, Title, ahk_id %thisID%
            
       
        ; Skip hidden or invalid windows
        if (WinX < -20000 || WinY < -20000) {
            continue
        }

        WinGet, Style, Style, ahk_id %thisID%
        if !(Style & 0x10000000) ; Skip invisible windows
            continue

        
        if (Title = "" || Title = "Program Manager")
            continue

        MsgBox, Title: %Title% ,Width: %WinWidth%, Height: %WinHeight%   
        ; Move from Monitor 1 to Monitor 2
        if (WinX >= Monitor1X && WinX <= Monitor1EndX) {
            SwapToScreen(thisID, Monitor2X, WinX, WinY, Monitor1X)
            MsgBox , 1 to 2, %Title%
        }
        
        ; Move from Monitor 2 to Monitor 1
        else if (WinX >= Monitor2X && WinX <=Monitor2EndX) {
            SwapToScreen(thisID, Monitor1X, WinX, WinY, Monitor2X)
            MsgBox, 2 to 1, %Title%
        }
        
        ; Handle fullscreen cases (X = -9)
        ;else if (WinX < 0 && WinY < 0) 

        ; Check if the window is maximized
        else {
            WinGet, IsMaximized, MinMax, ahk_id %thisID%
            if (IsMaximized) {
                WinRestore, ahk_id %thisID%
                
                WinGetPos, WinX, WinY, WinWidth, WinHeight, ahk_id %thisID%
                MsgBox, Handling fullscreen window: %Title% - X: %WinX%, Y: %WinY%

                SwapToScreen(thisID, Monitor2X, Monitor1X, WinY, Monitor1X)
                if (IsMaximized) {
                    WinMaximize, ahk_id %thisID%
                }

            } else {
                MsgBox, Active window is not within defined screen boundaries.
            }
        }
    }
}

SwapToScreen(ActiveWinID, TargetMonitorX, CurrentX, CurrentY, SourceMonitorX) {
    NewX := TargetMonitorX + (CurrentX - SourceMonitorX)
    WinGetPos, OldX, OldY, OldWidth, OldHeight, ahk_id %ActiveWinID%

    ; Adjust size based on scaling factor
    if (TargetMonitorX = 0) {  
        ScaleFactor := 1.25  ; Moving to Monitor 1  
    } else {  
        ScaleFactor := 0.8 ; Moving to Monitor 2  
    }
    ;As ı see actualy it doesnt change height and width and ı thought ı don't need to change NewX or height
    ;NewX := Round(NewX * ScaleFactor)
    ;NewY := Round(CurrentY * ScaleFactor)
    ;NewWidth := Round(NewWidth * ScaleFactor)
    ;NewHeight := Round(NewHeight * ScaleFactor)
    ;NewWidth := Round(OldWidth * ScaleFactor)
    ;NewHeight := Round(OldHeight * ScaleFactor)

    ; Move the window and report success    
    WinMove, ahk_id %ActiveWinID% ,, %NewX% , %CurrentY% , %NewWidth%, %NewHeight%
    MsgBox, moved successfully to X: %OldX%,%NewX%, Y: %OldY%,%CurrentY%, Width: %OldWidth%,%NewWidth%, Height: %OldHeight%,%NewHeight%.
}

OpenTranslate(){
    Run, https://translate.google.com
    }
