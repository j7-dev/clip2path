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
        ; Wait for physical modifier keys to be released — characters sent
        ; while Ctrl/Alt are still held down can be swallowed or reinterpreted
        ; as shortcut combinations by the receiving app.
        KeyWait 'Ctrl'
        KeyWait 'Alt'
        KeyWait 'Shift'
        ; Type the path as Unicode packets in small chunks, without touching
        ; the clipboard at all:
        ; - real virtual-key injection (SendEvent / synthetic ^v) gets
        ;   silently dropped by some setups (observed with VS Code + CJK IME);
        ;   Unicode packets (SendInput {Text}) are the only channel that
        ;   reliably reaches consoles, classic controls and Electron apps
        ; - 8 chars per chunk with a 25ms pause avoids overflowing slow text
        ;   controls (e.g. Windows 11 Notepad); the whole path lands in ~0.2s
        i := 1
        while (i <= StrLen(path)) {
            SendInput '{Text}' SubStr(path, i, 8)
            i += 8
            Sleep 25
        }
        TrayTip(path, 'clip2path: image saved', 1)
    } else {
        TrayTip('No image in clipboard', 'clip2path', 2)
    }
}
