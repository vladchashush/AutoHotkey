#Requires AutoHotkey v2.0

SendSpotifyKey(key) {
    hwnd := WinExist("ahk_exe Spotify.exe")
    if hwnd {
        ControlSend(key, , hwnd)
    } else {
        MsgBox("Spotify не запущен.")
    }
}

^!Up::SendSpotifyKey("{Media_Play_Pause}")   ; Ctrl + Alt + Up → Воспроизвести/Пауза
^!Right::SendSpotifyKey("{Media_Next}")      ; Ctrl + Alt + Right → Следующий трек
^!Left::SendSpotifyKey("{Media_Prev}")       ; Ctrl + Alt + Left → Предыдущий трек
