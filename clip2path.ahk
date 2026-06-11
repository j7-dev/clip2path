#Requires AutoHotkey v2.0
#SingleInstance Force

; clip2path — https://github.com/j7-dev/clip2path
;
; Ctrl + Alt + V:
;   1. Save the clipboard image as a PNG file (clipboard is left untouched)
;   2. Type the saved file path at the current cursor position
;
; To change the hotkey, edit the line below. Examples:
;   ^!v   = Ctrl + Alt + V
;   ^!+v  = Ctrl + Alt + Shift + V
;   #v    = Win + V (not recommended, conflicts with Windows clipboard history)
^!v:: {
    ; To change the save folder, replace A_Temp with any folder path,
    ; e.g. 'C:\screenshots\clipboard_' ...
    path := A_Temp '\clipboard_' FormatTime(A_Now, 'yyyyMMdd_HHmmss') '.png'
    ps := 'powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden'
        . ' -File "' A_ScriptDir '\save-clipboard-image.ps1" -Path "' path '"'
    RunWait(ps, , 'Hide')
    if FileExist(path) {
        ; Wait for physical modifier keys to be released — sending ^v while
        ; Alt is still held becomes Ctrl+Alt+V, re-triggering this hotkey in
        ; an endless loop.
        KeyWait 'Ctrl'
        KeyWait 'Alt'
        KeyWait 'Shift'
        ; Back up the full clipboard (including the image), put the path on
        ; it, paste, then restore. The path appears instantly and is immune
        ; to IME interception and slow text controls.
        backup := ClipboardAll()
        A_Clipboard := path
        if ClipWait(1)
            Send '^v'
        Sleep 500  ; let the target app finish processing the paste before restoring
        A_Clipboard := backup
        TrayTip(path, 'clip2path: image saved', 1)
    } else {
        TrayTip('No image in clipboard', 'clip2path', 2)
    }
}
