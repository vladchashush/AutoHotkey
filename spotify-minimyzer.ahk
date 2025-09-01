; Горячая клавиша: Ctrl+Alt+S
^!s:: {
    spotifyPath := "C:\Users\" A_UserName "\AppData\Roaming\Spotify\Spotify.exe"
    winTitle := "ahk_exe Spotify.exe"

    ; Если Spotify не запущен – запускаем
    if !WinExist(winTitle) {
        Run(spotifyPath)
        WinWait(winTitle)
        WinMaximize(winTitle)
        return
    }

    ; Если окно существует – проверяем состояние
    if WinActive(winTitle) {
        ; Если активно – сворачиваем
        WinMinimize(winTitle)
    } else {
        ; Если свернуто – разворачиваем и активируем
        WinRestore(winTitle)
        WinActivate(winTitle)
        WinMaximize(winTitle)
    }
}
