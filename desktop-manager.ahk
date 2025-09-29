; Загружаем DLL
global hVirtualDesktop := DllCall("LoadLibrary", "Str", "VirtualDesktopAccessor.dll", "Ptr")
global LastActive := Map()  ; словарь: DesktopIndex -> HWND

; Получить количество рабочих столов
GetDesktopCount() {
    return DllCall("VirtualDesktopAccessor\GetDesktopCount", "Int")
}

; Получить индекс текущего рабочего стола
GetCurrentDesktopNumber() {
    return DllCall("VirtualDesktopAccessor\GetCurrentDesktopNumber", "Int")
}

; Перейти к рабочему столу по номеру (0-based)
GoToDesktopNumber(n) {
    return DllCall("VirtualDesktopAccessor\GoToDesktopNumber", "Int", n)
}

; Принудительная активация окна
; Принудительная активация окна (без изменения размера)
ForceActivateWindow(hwnd) {
    if !hwnd
        return
    DllCall("BringWindowToTop", "Ptr", hwnd)
    DllCall("SetForegroundWindow", "Ptr", hwnd)
    DllCall("SetFocus", "Ptr", hwnd)
}

; Переключение рабочего стола с учётом последнего активного окна
SwitchToDesktop(n) {
    ; сохраняем активное окно текущего стола
    currDesktop := GetCurrentDesktopNumber()
    hwnd := WinExist("A")
    if hwnd
        LastActive[currDesktop] := hwnd

    ; переключаемся
    if (n < GetDesktopCount()) {
        GoToDesktopNumber(n)

        ; восстанавливаем окно для нового стола
        if LastActive.Has(n) {
            target := LastActive[n]
            SetTimer(() => ForceActivateWindow(target), -50)  ; задержка
        }
    } else {
        MsgBox("Рабочего стола #" (n+1) " не существует!")
    }
}

; ---- Горячие клавиши ----
^#1::SwitchToDesktop(0)
^#2::SwitchToDesktop(1)
^#3::SwitchToDesktop(2)
^#4::SwitchToDesktop(3)
^#5::SwitchToDesktop(4)
^#6::SwitchToDesktop(5)
^#7::SwitchToDesktop(6)
^#8::SwitchToDesktop(7)
^#9::SwitchToDesktop(8)
