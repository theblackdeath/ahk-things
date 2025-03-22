#Requires AutoHotkey v2.0

global toggle := false

F8:: {
    global toggle

    toggle := !toggle
    if toggle
        SetTimer(PressE, 11000)  ; Start calling PressE() every 11 seconds
    else
        SetTimer(PressE, -1)     ; Turn off the timer
}

PressE() {
    Send "e"
	DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
}
