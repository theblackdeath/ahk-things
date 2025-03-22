#Requires AutoHotkey v2
#SingleInstance Force
SetWorkingDir(A_ScriptDir)

; ---------- GLOBAL VARIABLES ----------
global isQuickRollerMode := false
global isTierUpgradeMode := false
global isTierUpgradeLoopRunning := false

global configDone := false
global isLooping := false
global isSearching := false

; GDI+ references
global pToken := 0
global hModule := 0

; Coordinates for clicking
global clickX := 0
global clickY := 0

; For red dot overlay
global redDotGui := ""
global redDotIsVisible := false

; For the region capture (normal OCR mode)
global startX := 497
global startY := 1
global endX   := 1909
global endY   := 977

; For normal mode searching
global searchOptions := [
    "Movement Speed Increased By %:",
	"Melee Damage Increased By %:",
    "Chance To Dodge %:",
    "Magic Find Increased By %:"
]
global searchText1 := "Melee Damage Increased By %:"
global searchRange1 := [50.0, 180.0]
global searchText2 := "Chance To Dodge %:"
global searchRange2 := [150.0, 600.0]

; For failed search logic
global failedSearchCount := 0
global failedSearchLimit := 200

; GUIs / Controls
global configGui := ""
global overlayGui := ""
global overlayTextControl := ""
global failedCountGui := ""
global failedCountTextControl := ""
global spaceBarIndicatorGui := ""

; For auto loop (normal mode)
global loopOriginX := 0
global loopOriginY := 0

; For the config GUI
global Option1Ctrl, MinValue1Ctrl, Option2Ctrl, MinValue2Ctrl
global failedSearchLimitCtrl

; Ensure imgcheck folder exists
global imgcheckPath := A_ScriptDir . "\imgcheck"
if !DirExist(imgcheckPath)
    DirCreate(imgcheckPath)

; ========================================================================
; ===========================  SCRIPT START  ==============================
; ========================================================================

ShowConfigGui()
ShowOverlay()
ShowFailedCountGui()
ShowSpaceBarIndicator()
LoadGDIplus()

OnExit(ShutdownGDI)

; ========== HOTKEYS ==========

F1:: {
    global
    SetClickPosition()
}

; SPACE does single click+OCR in normal mode or quick roll in QuickRoller mode
Space:: {
    global isLooping, isSearching, configDone, isQuickRollerMode, isTierUpgradeMode
    
    ; If in Tier Upgrade mode, do nothing with SPACE
    if (isTierUpgradeMode)
        return

    if (!configDone && !isQuickRollerMode) {
        ToolTip("⚠️ Please complete the configuration first.")
        Sleep(1000)
        ToolTip()
        return
    }
    if (!isLooping && isSearching)
        return

    if (!isLooping) {
        isSearching := true
        SetSpaceBarIndicatorColor("FF0000")
    }

    PerformClick()

    if (!isLooping) {
        isSearching := false
        SetSpaceBarIndicatorColor("00FF00")
    }
}

; F8: Start Tier Upgrade loop if in Tier mode, else start normal auto loop
F8:: {
    global isTierUpgradeMode
    if (isTierUpgradeMode)
        TierUpgrade_StartLoop()
    else
        StartAutoLoop()
}

; F9: Stop Tier Upgrade loop if in Tier mode, else stop normal auto loop
F9:: {
    global isTierUpgradeMode
    if (isTierUpgradeMode)
        TierUpgrade_StopLoop()
    else
        StopAutoLoop()
}

; F10: Return to config or exit special modes
F10:: {
    global isQuickRollerMode, isTierUpgradeMode, isTierUpgradeLoopRunning, isLooping
    if (isQuickRollerMode) {
        isQuickRollerMode := false
        ShowConfigGui()
        ShowOverlay()
        ShowFailedCountGui()
        ShowSpaceBarIndicator()
        ToolTip("Returned to normal mode.")
        Sleep(1000)
        ToolTip()
    }
    else if (isTierUpgradeMode) {
        isTierUpgradeMode := false
        isTierUpgradeLoopRunning := false
        SetClickPosition()  ; Re-init red dot
        ShowConfigGui()
        ShowOverlay()
        ShowFailedCountGui()
        ShowSpaceBarIndicator()
        ToolTip("Returned to selection mode.")
        Sleep(1000)
        ToolTip()
    }
    else if (!isLooping)
        ShowConfigGui()
}

^Esc::ExitApp()

; ========================================================================
; ===========================  F1 POSITION  ===============================
; ========================================================================
SetClickPosition() {
    global clickX, clickY, redDotGui, redDotIsVisible
    MouseGetPos(&clickX, &clickY)
    
    if IsObject(redDotGui) {
        redDotGui.Destroy()
        redDotGui := ""
    }
    redDotGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    redDotGui.BackColor := "FF0000"
    redDotGui.Show("x" (clickX - 5) " y" (clickY - 5) " w10 h10 NoActivate")
    redDotIsVisible := true
    
    SetTimer(RedDotMonitor, 100, 0)
}

RedDotMonitor() {
    global clickX, clickY, redDotGui, redDotIsVisible, isTierUpgradeMode
    if (isTierUpgradeMode) {
        if IsObject(redDotGui)
            redDotGui.Hide()
        redDotIsVisible := false
        return
    }
    if !IsObject(redDotGui) {
        SetTimer(RedDotMonitor)
        return
    }
    local curX, curY
    MouseGetPos(&curX, &curY)
    local distance := Sqrt((curX - clickX)**2 + (curY - clickY)**2)
    
    if (distance < 10) {
        if redDotIsVisible {
            redDotGui.Hide()
            redDotIsVisible := false
        }
    } else {
        if (!redDotIsVisible) {
            redDotGui.Show()
            redDotIsVisible := true
        }
    }
    try WinSetExStyle(0x20, "ahk_id " redDotGui.Hwnd)
}

; ========================================================================
; =====================  CLICK (SPACE) FOR BOTH MODES  ===================
; ========================================================================
PerformClick() {
    global isQuickRollerMode, clickX, clickY, redDotGui
    if (clickX = 0 || clickY = 0) {
        ToolTip("⚠️ You must press F1 to set a click position first.")
        Sleep(1000)
        ToolTip()
        return
    }
    
    if IsObject(redDotGui)
        redDotGui.Hide()
    
    local origX, origY
    MouseGetPos(&origX, &origY)
    
    ; Left-click at the F1 position
    DllCall("SetCursorPos", "Int", clickX, "Int", clickY)
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0) ; mouse down
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0) ; mouse up
    Sleep(100)
    
    ; Return to original position
    DllCall("SetCursorPos", "Int", origX, "Int", origY)
    if IsObject(redDotGui)
        redDotGui.Show()
    
    ; If not in quick roller mode, do OCR
    if (!isQuickRollerMode) {
        Sleep(1500)
        CaptureScreenAndRunOCR()
    }
}

; ========================================================================
; ===========================  QUICK MODE  ================================
; ========================================================================
QuickRollerModeButton() {
    global isQuickRollerMode, configGui, overlayGui, failedCountGui, spaceBarIndicatorGui
    isQuickRollerMode := true
    
    if IsObject(configGui)
        configGui.Destroy()
    
    if IsObject(overlayGui)
        overlayGui.Show("NoActivate")
    UpdateOverlayText()
    
    if IsObject(failedCountGui)
        failedCountGui.Hide()
    if IsObject(spaceBarIndicatorGui)
        spaceBarIndicatorGui.Hide()
    
    ToolTip("Quick Roller Mode activated. Press F10 to return to selection.")
    Sleep(1000)
    ToolTip()
}

; ========================================================================
; ======================  TIER UPGRADE MODE FUNCTIONS  ====================
; ========================================================================
TierUpgradeModeButton() {
    global isTierUpgradeMode, configGui, overlayGui, failedCountGui, spaceBarIndicatorGui, redDotGui
    isTierUpgradeMode := true
    
    if IsObject(configGui)
        configGui.Destroy()
    
    if IsObject(overlayGui)
        overlayGui.Show("NoActivate")
    
    if IsObject(failedCountGui)
        failedCountGui.Hide()
    if IsObject(spaceBarIndicatorGui)
        spaceBarIndicatorGui.Hide()
    if IsObject(redDotGui)
        redDotGui.Hide()
    
    ToolTip("Tier Upgrade Mode activated. Press F10 to return to selection.")
    Sleep(1000)
    ToolTip()
    UpdateOverlayText()
}

TierUpgrade_StartLoop() {
    global isTierUpgradeLoopRunning
    if (isTierUpgradeLoopRunning)
        return  ; Already running
    isTierUpgradeLoopRunning := true
    Notify("Tier Upgrade Loop Started")
    SetTimer(() => TierUpgrade_LoopIteration(), -10)
}

TierUpgrade_StopLoop() {
    global isTierUpgradeLoopRunning
    isTierUpgradeLoopRunning := false
    Notify("Tier Upgrade Loop Stopped")
    SetTimer(() => TierUpgrade_LoopIteration(), 0)
}

TierUpgrade_LoopIteration() {
    global isTierUpgradeLoopRunning, clickX, clickY, redDotGui
    if (!isTierUpgradeLoopRunning)
        return

    ; 1) Get current (original) mouse position
    local origX, origY
    MouseGetPos(&origX, &origY)
    
    ; Hide the red dot so it does not interfere
    if IsObject(redDotGui)
        redDotGui.Hide()
    
    ; 2) Left-click at the original position (mouse_event approach)
    DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0) ; mouse down
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0) ; mouse up
    Sleep(500)
    
    ; 3) Move to F1 position, wait 500 ms
    MouseMove(clickX, clickY, 10)
    Sleep(500)
    
    ; 4) Left-click 9 times with 1500 ms delay
    Loop 9 {
        DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
        Sleep(100)
        DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
        Sleep(1500)
    }
    
    ; 5) Move back to original position, wait 1000 ms
    MouseMove(origX, origY, 10)
    Sleep(1000)
    
    ; 6) Press "T", wait 1000 ms, then left-click
    Send("t")
    Sleep(1000)
    DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
	Sleep(1000)
    
    ; Repeat if still running
    if (isTierUpgradeLoopRunning)
        SetTimer(() => TierUpgrade_LoopIteration(), -10)
}

Notify(msg) {
    CoordMode "ToolTip", "Screen"
    ToolTip(msg, A_ScreenWidth / 2, A_ScreenHeight / 2)
    SetTimer(() => ToolTip(), -1500)
}

; ========================================================================
; ==========================  NORMAL OCR LOGIC  ===========================
; ========================================================================
CaptureScreenAndRunOCR() {
    global startX, startY, endX, endY, pToken, imgcheckPath
    x := startX, y := startY
    width := endX - startX
    height := endY - startY
    if (width <= 0 || height <= 0) {
        MsgBox("⚠️ Invalid region dimensions. Check coordinates.", "Error", 16)
        return
    }
    local hdc := DllCall("GetDC", "Ptr", 0, "Ptr")
    local hdcMem := DllCall("gdi32\CreateCompatibleDC", "Ptr", hdc, "Ptr")
    local hbm := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", hdc, "Int", width, "Int", height, "Ptr")
    DllCall("gdi32\SelectObject", "Ptr", hdcMem, "Ptr", hbm)
    DllCall("gdi32\BitBlt", "Ptr", hdcMem, "Int", 0, "Int", 0, "Int", width, "Int", height, "Ptr", hdc, "Int", x, "Int", y, "UInt", 0x00CC0020)
    
    local pBitmap := 0
    local result := DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hbm, "Ptr", 0, "Ptr*", &pBitmap)
    if (result != 0 || !pBitmap) {
        MsgBox("❌ Failed to create GDI+ Bitmap. Error Code: " result, "Error", 16)
        goto Cleanup
    }
    local capturedImagePath := imgcheckPath . "\Captured_Image.png"
    local CLSID := Buffer(16, 0)
    DllCall("ole32\CLSIDFromString", "WStr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "Ptr", CLSID)
    local saveResult := DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "WStr", capturedImagePath, "Ptr", CLSID, "Ptr", 0)
    if (saveResult != 0) {
        MsgBox("❌ Failed to save captured image. Error Code: " saveResult, "Error", 16)
    } else {
        RunTesseractOCR(capturedImagePath, pBitmap)
    }
Cleanup:
    DllCall("gdi32\DeleteObject", "Ptr", hbm)
    DllCall("gdi32\DeleteDC", "Ptr", hdcMem)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdc)
}

RunTesseractOCR(imagePath, pBitmap) {
    global searchText1, searchRange1, searchText2, searchRange2
    global imgcheckPath, isLooping, isSearching, failedSearchCount, failedSearchLimit
    outputBase := imgcheckPath . "\Captured_Image"
    local ocrOutput := outputBase . "_1.txt"
    
    RunWait("tesseract.exe " . '"' . imagePath . '" "' . outputBase . '_1" --psm 6 --oem 1 -l eng', , "Hide")
    if (FileExist(ocrOutput)) {
        local extractedText := Trim(FileRead(ocrOutput, "UTF-8"))
        local foundMatch := false
        
        if RegExMatch(extractedText, "(?i)" . searchText1 . "\s*(\d+(\.\d+)?)", &match1) {
            local value1 := match1[1]
            if (value1 >= searchRange1[1] && value1 <= searchRange1[2]) {
                foundMatch := true
            }
        }
        if RegExMatch(extractedText, "(?i)" . searchText2 . "\s*(\d+(\.\d+)?)", &match2) {
            local value2 := match2[1]
            if (value2 >= searchRange2[1] && value2 <= searchRange2[2]) {
                foundMatch := true
            }
        }
        
        if (foundMatch) {
            failedSearchCount := 0
            UpdateFailedCountGui()
            FlashGreenCountGui(4000)
            SoundBeep(750,300)
            Sleep(1500)
            ; left-click again
            DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
            Sleep(100)
            DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
            Sleep(1500)
            Send("t")
            Sleep(1500)
            ; left-click again
            DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
            Sleep(100)
            DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
            Sleep(1200)
            
            Sleep(2000)
            if (AdditionalSuccessCheck()) {
                RunTesseractOCR(imagePath, pBitmap)
                return
            }
        } else {
            if (isLooping) {
                failedSearchCount++
                UpdateFailedCountGui()
            }
        }
        
        if (failedSearchCount >= failedSearchLimit) {
            isLooping := false
            MsgBox("⚠️ Search failed " failedSearchLimit " times. Stopping auto loop.", "Loop Stopped", 16)
            return
        }
        
        Sleep(500)
        if (isLooping) {
            SetTimer(PerformClickAndOCR, -200)
        } else {
            isSearching := false
        }
    } else {
        MsgBox("❌ Tesseract OCR failed or returned no text.", "Error", 16)
        if (!isLooping)
            isSearching := false
    }
}

AdditionalSuccessCheck() {
    global imgcheckPath, searchText1, searchRange1, searchText2, searchRange2
    global startX, startY, endX, endY
    Sleep(1500)
    local tempCaptured := imgcheckPath . "\Temp_Captured_Image.png"
    
    local hdc := DllCall("GetDC", "Ptr", 0, "Ptr")
    local hdcMem := DllCall("gdi32\CreateCompatibleDC", "Ptr", hdc, "Ptr")
    local width := endX - startX
    local height := endY - startY
    if (width <= 0 || height <= 0) {
        return false
    }
    local x := startX, y := startY
    local hbm := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", hdc, "Int", width, "Int", height, "Ptr")
    DllCall("gdi32\SelectObject", "Ptr", hdcMem, "Ptr", hbm)
    DllCall("gdi32\BitBlt", "Ptr", hdcMem, "Int", 0, "Int", 0, "Int", width, "Int", height, "Ptr", hdc, "Int", x, "Int", y, "UInt", 0x00CC0020)
    
    local pBitmap := 0
    local result := DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hbm, "Ptr", 0, "Ptr*", &pBitmap)
    DllCall("gdi32\DeleteObject", "Ptr", hbm)
    DllCall("gdi32\DeleteDC", "Ptr", hdcMem)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdc)
    if (result != 0 || !pBitmap) {
        return false
    }
    local CLSID := Buffer(16, 0)
    DllCall("ole32\CLSIDFromString", "WStr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "Ptr", CLSID)
    local tempCapturedOcr := imgcheckPath . "\Temp_Captured_Image_1.txt"
    local saveResult := DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "WStr", tempCaptured, "Ptr", CLSID, "Ptr", 0)
    if (saveResult != 0) {
        return false
    }
    RunWait("tesseract.exe " . '"' . tempCaptured . '" "' . imgcheckPath . "\Temp_Captured_Image_1" . '" --psm 6 --oem 1 -l eng', , "Hide")
    
    local ocrText := ""
    local tempOCR := imgcheckPath . "\Temp_Captured_Image_1.txt"
    if (FileExist(tempOCR)) {
        ocrText := Trim(FileRead(tempOCR, "UTF-8"))
        FileDelete(tempOCR)
    }
    FileDelete(tempCaptured)
    
    local matchFound := false
    if RegExMatch(ocrText, "(?i)" . searchText1 . "\s*(\d+(\.\d+)?)", &m1) {
        local val1 := m1[1]
        if (val1 >= searchRange1[1] && val1 <= searchRange1[2])
            matchFound := true
    }
    if RegExMatch(ocrText, "(?i)" . searchText2 . "\s*(\d+(\.\d+)?)", &m2) {
        local val2 := m2[1]
        if (val2 >= searchRange2[1] && val2 <= searchRange2[2])
            matchFound := true
    }
    return matchFound
}

; ========================================================================
; ==========================  AUTO LOOP (Normal Mode)  ====================
; ========================================================================
StartAutoLoop() {
    global isLooping, configDone, clickX, clickY, loopOriginX, loopOriginY
    if (!configDone) {
        ToolTip("⚠️ Please complete the configuration first.")
        Sleep(1000)
        ToolTip()
        return
    }
    if (clickX = 0 || clickY = 0) {
        ToolTip("⚠️ Set F1 Position First (Press F1)")
        Sleep(1000)
        ToolTip()
        return
    }
    if (isLooping) {
        ToolTip("🔄 Loop already running...")
        Sleep(1000)
        ToolTip()
        return
    }
    MouseGetPos(&loopOriginX, &loopOriginY)
    isLooping := true
    ToolTip("🔄 Auto Loop Started (Press F9 to stop)")
    Sleep(1000)
    ToolTip()
    SetTimer(PerformClickAndOCR, -100)
    HideSpaceBarIndicator()
}

StopAutoLoop() {
    global isLooping, failedSearchCount, loopOriginX, loopOriginY
    isLooping := false
    failedSearchCount := 0
    loopOriginX := 0
    loopOriginY := 0
    UpdateFailedCountGui()
    ShowSpaceBarIndicator()
    ToolTip("⛔ Auto Loop Stopped. Failed searches reset.")
    Sleep(1500)
    ToolTip()
}

PerformClickAndOCR() {
    global clickX, clickY, isLooping, loopOriginX, loopOriginY, redDotGui
    if (clickX = 0 || clickY = 0) {
        ToolTip("⚠️ Set F1 Position First (Press F1)")
        Sleep(1000)
        ToolTip()
        return
    }
    if IsObject(redDotGui)
        redDotGui.Hide()
    
    local origX := loopOriginX
    local origY := loopOriginY
    
    DllCall("SetCursorPos", "Int", clickX, "Int", clickY)
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0002, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
    Sleep(100)
    DllCall("mouse_event", "UInt", 0x0004, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr", 0)
    Sleep(100)
    DllCall("SetCursorPos", "Int", origX, "Int", origY)
    
    if IsObject(redDotGui)
        redDotGui.Show()
    
    Sleep(1500)
    CaptureScreenAndRunOCR()
}

; ========================================================================
; ========================  CONFIGURATION GUI  ============================
; ========================================================================
ShowConfigGui() {
    global configGui, searchOptions, failedSearchLimit
    global Option1Ctrl, MinValue1Ctrl, Option2Ctrl, MinValue2Ctrl, failedSearchLimitCtrl
    
    if IsObject(configGui)
        configGui.Destroy()
    
    configGui := Gui("+AlwaysOnTop", "Search Criteria Configuration")
    
    configGui.Add("Text", "x10 y10 w150", "Search Option 1:")
    Option1Ctrl := configGui.Add("DropDownList", "x10 y30 w250 Choose1", searchOptions)
    
    configGui.Add("Text", "x10 y60 w150", "Minimum Value 1:")
    MinValue1Ctrl := configGui.Add("Edit", "x10 y80 w250", "")
    
    configGui.Add("Text", "x10 y120 w150", "Search Option 2:")
    Option2Ctrl := configGui.Add("DropDownList", "x10 y140 w250 Choose1", searchOptions)
    
    configGui.Add("Text", "x10 y170 w150", "Minimum Value 2:")
    MinValue2Ctrl := configGui.Add("Edit", "x10 y190 w250", "")
    
    configGui.Add("Text", "x10 y220 w150", "Failed Search Limit:")
    failedSearchLimitCtrl := configGui.Add("Edit", "x10 y240 w250", failedSearchLimit)
    
    local ButtonSubmit := configGui.Add("Button", "x10 y280 w100", "Submit")
    ButtonSubmit.OnEvent("Click", (*) => SubmitConfig())
    
    local ButtonQuickRoller := configGui.Add("Button", "x120 y280 w150", "Quick Roller Mode")
    ButtonQuickRoller.OnEvent("Click", (*) => QuickRollerModeButton())
    
    local ButtonTierUpgrade := configGui.Add("Button", "x280 y280 w150", "Tier upgrade")
    ButtonTierUpgrade.OnEvent("Click", (*) => TierUpgradeModeButton())
    
    configGui.Show("NoActivate AutoSize Center")
    configGui.OnEvent("Escape", (*) => configGui.Destroy())
}

SubmitConfig() {
    global configGui, configDone, searchText1, searchRange1, searchText2, searchRange2
    global Option1Ctrl, MinValue1Ctrl, Option2Ctrl, MinValue2Ctrl, failedSearchLimitCtrl
    global failedSearchLimit
    
    local Option1 := Option1Ctrl.Text
    local MinValue1 := MinValue1Ctrl.Value
    local Option2 := Option2Ctrl.Text
    local MinValue2 := MinValue2Ctrl.Value
    local failedLimitInput := failedSearchLimitCtrl.Value
    
    if (!RegExMatch(MinValue1, "^\d+(\.\d+)?$")) {
        MsgBox("Invalid number entered for Minimum Value 1.")
        return
    }
    if (!RegExMatch(MinValue2, "^\d+(\.\d+)?$")) {
        MsgBox("Invalid number entered for Minimum Value 2.")
        return
    }
    if (!RegExMatch(failedLimitInput, "^\d+$")) {
        MsgBox("Invalid number entered for Failed Search Limit.")
        return
    }
    
    local min1 := MinValue1 + 0.0
    local min2 := MinValue2 + 0.0
    failedSearchLimit := failedLimitInput + 0
    
    searchText1 := Option1
    searchRange1 := [min1, 600.0]
    searchText2 := Option2
    searchRange2 := [min2, 600.0]
    
    configDone := true
    configGui.Destroy()
    
    UpdateOverlayText()
    
    ToolTip("✅ Configuration Saved")
    Sleep(1000)
    ToolTip()
}

; ========================================================================
; ======================  OVERLAY + FAILED COUNT  ========================
; ========================================================================
ShowOverlay() {
    global overlayGui, overlayTextControl
    if IsObject(overlayGui)
        overlayGui.Destroy()
    
    overlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Info Overlay")
    overlayGui.BackColor := "000000"
    overlayGui.SetFont("s10 cFFFFFF", "Segoe UI")
    WinSetTransparent(102, overlayGui.Hwnd)
    
    overlayTextControl := overlayGui.Add("Text", "w260 h280")
    UpdateOverlayText()
    overlayGui.Show("x10 y10 NoActivate")
}

UpdateOverlayText() {
    global overlayTextControl, isQuickRollerMode, isTierUpgradeMode
    global searchText1, searchRange1, searchText2, searchRange2
    if !IsObject(overlayTextControl)
        return
    
    if (isQuickRollerMode) {
        local overlayText := "📋 Quick Roller Mode`n"
            . "-------------------------------`n"
            . "F1: Set click position`n"
            . "SPACE: Single click (no OCR) `n"
            . "F10: Return to selection`n"
            . "CTRL+ESC: Exit`n"
            . "-------------------------------`n"
        overlayTextControl.Text := overlayText
    }
    else if (isTierUpgradeMode) {
        local overlayText := "📋 Tier Upgrade Mode`n"
            . "-------------------------------`n"
            . "F1: Set click position`n"
            . "F8: Start loop`n"
            . "F9: Stop loop`n"
            . "F10: Return to selection`n"
        overlayTextControl.Text := overlayText
    }
    else {
        local overlayText := "📋 Universal Roller v1`n" 
            . "-------------------------------`n"
            . "🔍 Searching for:`n"
            . "   - " . searchText1 . " " . searchRange1[1] . " - " . searchRange1[2] . "`n"
            . "   - " . searchText2 . " " . searchRange2[1] . " - " . searchRange2[2] . "`n"
            . "(Configured via GUI)`n`n"
            . "🖱️ Controls:`n"
            . "   - F1: Set Click Position`n"
            . "   - SPACE: Single click+OCR (normal mode)`n"
            . "   - F8: Start Auto Loop (Normal)`n"
            . "   - F9: Stop Auto Loop (Normal)`n"
            . "   - F10: Reopen Config / exit QuickRoller / exit TierUpgrade`n"
            . "   - CTRL+ESC: Exit`n"
            . "-------------------------------`n"
        overlayTextControl.Text := overlayText
    }
}

ShowFailedCountGui() {
    global failedCountGui, failedCountTextControl, failedSearchCount
    if IsObject(failedCountGui)
        failedCountGui.Destroy()
    
    failedCountGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Failed Count")
    failedCountGui.BackColor := "FF0000"
    failedCountGui.SetFont("s40 c000000", "Segoe UI")
    failedCountTextControl := failedCountGui.Add("Text", "w200 h60 Center")
    failedCountGui.Show("x10 y295 NoActivate")
    UpdateFailedCountGui()
}

UpdateFailedCountGui() {
    global failedCountTextControl, failedSearchCount, failedSearchLimit
    if IsObject(failedCountTextControl) {
        failedCountTextControl.Text := failedSearchCount "/" failedSearchLimit
    }
}

FlashGreenCountGui(duration := 4000) {
    global failedCountGui
    if !IsObject(failedCountGui)
        return
    failedCountGui.BackColor := "00FF00"
    SetTimer(() => failedCountGui.BackColor := "FF0000", -duration)
}

; ========================================================================
; ======================  SPACE BAR INDICATOR  ===========================
; ========================================================================
ShowSpaceBarIndicator() {
    global spaceBarIndicatorGui
    if (!IsObject(spaceBarIndicatorGui)) {
        spaceBarIndicatorGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "SpaceBarIndicator")
        spaceBarIndicatorGui.BackColor := "00FF00"
        spaceBarIndicatorGui.Add("Text", "w20 h20")
        spaceBarIndicatorGui.Show("x" (A_ScreenWidth - 1000) " y120 NoActivate")
    } else {
        spaceBarIndicatorGui.Show()
    }
}

HideSpaceBarIndicator() {
    global spaceBarIndicatorGui
    if IsObject(spaceBarIndicatorGui)
        spaceBarIndicatorGui.Hide()
}

SetSpaceBarIndicatorColor(color) {
    global spaceBarIndicatorGui
    if IsObject(spaceBarIndicatorGui)
        spaceBarIndicatorGui.BackColor := color
}

; ========================================================================
; ========================  GDI+ LOADING / SHUTDOWN  ======================
; ========================================================================
LoadGDIplus() {
    global pToken, hModule
    if (pToken != 0) {
        DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
        pToken := 0
    }
    if (hModule != 0) {
        DllCall("FreeLibrary", "Ptr", hModule)
        hModule := 0
    }
    Sleep(100)
    
    local attempts := 0
    local maxAttempts := 3
    Loop {
        attempts++
        local gdiplusPath := "C:\Windows\System32\Gdiplus.dll"
        hModule := DllCall("LoadLibrary", "Str", gdiplusPath, "Ptr")
        if (!hModule) {
            local errorCode := DllCall("GetLastError")
            if (attempts >= maxAttempts) {
                MsgBox("❌ Failed to load Gdiplus.dll after " maxAttempts " attempts. Error Code: " errorCode, "Error", 16)
                ExitApp()
            }
            Sleep(200)
            continue
        }
        local GdiplusStartupInput := Buffer(16, 0)
        NumPut("UInt", 1, GdiplusStartupInput, 0)
        local initResult := DllCall("gdiplus\GdiplusStartup", "Ptr*", &pToken, "Ptr", GdiplusStartupInput, "Ptr", 0)
        if (initResult == 0)
            break
        if (attempts >= maxAttempts) {
            MsgBox("❌ Failed to initialize GDI+ after " maxAttempts " attempts. Error Code: " initResult, "Error", 16)
            ExitApp()
        }
        Sleep(200)
    }
}

ShutdownGDI(*) {
    global pToken, hModule, redDotGui, imgcheckPath
    if (pToken != 0)
        DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
    if (hModule != 0)
        DllCall("FreeLibrary", "Ptr", hModule)
    
    if IsObject(redDotGui)
        redDotGui.Destroy()
    
    if FileExist(imgcheckPath . "\Captured_Image.png")
        FileDelete(imgcheckPath . "\Captured_Image.png")
    if FileExist(imgcheckPath . "\Captured_Image_1.txt")
        FileDelete(imgcheckPath . "\Captured_Image_1.txt")
    
    ExitApp()
}
