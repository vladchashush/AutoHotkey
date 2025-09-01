#Requires AutoHotkey v2.0

; --- Загрузка DLL для работы с виртуальными рабочими столами ---
hVD := DllCall("LoadLibrary", "Str", A_ScriptDir "\VirtualDesktopAccessor.dll", "Ptr")

MoveToDesktop(hwnd, deskNumber) {
    DllCall("VirtualDesktopAccessor\MoveWindowToDesktopNumber", "Ptr", hwnd, "Int", deskNumber)
}

SwitchDesktop(deskNumber) {
    DllCall("VirtualDesktopAccessor\GoToDesktopNumber", "Int", deskNumber)
}

; --- Получаем рабочую область экрана без панели задач через WinAPI ---
VarSetCapacity(workArea, 16)  ; RECT = 4*4 bytes
DllCall("SystemParametersInfo", "UInt", 48, "UInt", 0, "Ptr", &workArea, "UInt", 0)  ; SPI_GETWORKAREA = 48

workX := NumGet(workArea, 0, "Int")
workY := NumGet(workArea, 4, "Int")
workW := NumGet(workArea, 8, "Int") - workX
workH := NumGet(workArea, 12, "Int") - workY

; --- Obsidian (слева) ---
Run '"C:\Program Files\Obsidian\Obsidian.exe"'
WinWait("ahk_exe Obsidian.exe")
WinActivate("ahk_exe Obsidian.exe")
WinMove(workX, workY, workW // 2, workH, "ahk_exe Obsidian.exe")

; --- Zen Browser (справа) ---
Run '"C:\Program Files\Zen Browser\zen.exe"'
WinWait("ahk_exe zen.exe")
WinActivate("ahk_exe zen.exe")
WinMove(workX + workW // 2, workY, workW // 2, workH, "ahk_exe zen.exe")

; --- Alacritty (второй рабочий стол, полный экран) ---
Run '"C:\Program Files\Alacritty\alacritty.exe"'
WinWait("ahk_exe alacritty.exe")
alacrittyHwnd := WinExist("ahk_exe alacritty.exe")

; Переносим на второй рабочий стол
MoveToDesktop(alacrittyHwnd, 1)
Sleep 300  ; даём системе время переместить окно

; Переключаемся на второй рабочий стол
SwitchDesktop(1)
Sleep 200  ; ждём отображения окна

; Активируем и разворачиваем на весь экран
WinActivate("ahk_id " alacrittyHwnd)
WinMaximize("ahk_id " alacrittyHwnd)

; --- Возвращаемся на первый рабочий стол ---
SwitchDesktop(0)
