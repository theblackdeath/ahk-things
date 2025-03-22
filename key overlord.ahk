#NoEnv
#SingleInstance Force

; -- Global default states for Key Presser mode (numeric: 1 = enabled, 0 = disabled)
KP_Running := false
KeyEnabled1 := 1
KeyEnabled2 := 1
KeyEnabled3 := 1
KeyEnabled4 := 1

; ---------------------------
; Create a separate Status Box
; ---------------------------
StatusBox_Create() {
    Gui, StatusBox:New, +AlwaysOnTop -Caption +ToolWindow, Status
    Gui, StatusBox:Color, FF0000
    SysGet, MonitorWorkArea, MonitorWorkArea
    xPos := ((MonitorWorkAreaRight - MonitorWorkAreaLeft) - 20) // 2 + MonitorWorkAreaLeft
    yPos := MonitorWorkAreaTop + 5
    Gui, StatusBox:Show, x%xPos% y%yPos% w20 h20, Status
}
StatusBox_Create()

; ---------------------------
; Update Status Box Color
; ---------------------------
UpdateStatusBox() {
    global KH_Running, KP_Running
    if (KH_Running or KP_Running)
        Gui, StatusBox:Color, 00FF00  ; Green when active
    else
        Gui, StatusBox:Color, FF0000  ; Red when inactive
    Gui, StatusBox:Show, NA
}

; -------------------------------------------------
; MAIN GUI (GUI #1)
; -------------------------------------------------
Gui 1:Default
Gui 1:Add, Text, x20 y20 w360 h20, Main Menu - Choose a mode:
Gui 1:Add, Button, x20 y60  w140 h30 gOpenEnterCommands, Enter Commands
Gui 1:Add, Button, x20 y100 w140 h30 gOpenKeyHolder,     Key Holder
Gui 1:Add, Button, x20 y140 w140 h30 gOpenKeyPresser,    Key Presser
Gui 1:Add, Button, x20 y200 w140 h30 gExitScript,        Exit
Gui 1:Show, x100 y100 w400 h250, Main Menu
Return

ExitScript:
    ExitApp
Return

; -----------------------------------------------------
; MODE 1: ENTER COMMANDS (GUI #4) - Dynamic Hotkeys
; -----------------------------------------------------
OpenEnterCommands:
    Gui 1:Hide
    Gui 4:Destroy
    Gui 4:Default
    ; --- First Sequence ---
    Gui 4:Add, Text, x20 y20 w200 h20, **First Sequence**
    Gui 4:Add, Text, x20 y50 w200 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey1 x150 y50 w200 Choose1, grave|1|2|3|4|5|6|7|8|9|0|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|enter|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2
    Gui 4:Add, Text, x20 y80 w200 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText1 x150 y80 w200 h20, Your Text Here.
    Gui 4:Add, Text, x20 y110 w200 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey1 x150 y110 w200 Choose1, enter|1|2|3|4|5|6|7|8|9|0|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2
    Gui 4:Add, Text, x20 y140 w200 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey1 x150 y140 w200 Choose1, F8|F1|F2|F3|F4|F5|F6|F7|F9|F10|F11|F12
    ; --- Second Sequence ---
    Gui 4:Add, Text, x20 y180 w200 h20, **Second Sequence**
    Gui 4:Add, Text, x20 y210 w200 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey2 x150 y210 w200 Choose1, grave|1|2|3|4|5|6|7|8|9|0|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|enter|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2
    Gui 4:Add, Text, x20 y240 w200 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText2 x150 y240 w200 h20, Your Text Here.
    Gui 4:Add, Text, x20 y270 w200 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey2 x150 y270 w200 Choose1, enter|1|2|3|4|5|6|7|8|9|0|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2
    Gui 4:Add, Text, x20 y300 w200 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey2 x150 y300 w200 Choose1, F9|F1|F2|F3|F4|F5|F6|F7|F8|F10|F11|F12
    ; --- Third Sequence ---
    Gui 4:Add, Text, x20 y340 w200 h20, **Third Sequence**
    Gui 4:Add, Text, x20 y370 w200 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey3 x150 y370 w200 Choose1, grave|1|2|3|4|5|6|7|8|9|0|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|enter|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2
    Gui 4:Add, Text, x20 y400 w200 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText3 x150 y400 w200 h20, Your Text Here.
    Gui 4:Add, Text, x20 y430 w200 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey3 x150 y430 w200 Choose1, enter|1|2|3|4|5|6|7|8|9|0|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2
    Gui 4:Add, Text, x20 y460 w200 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey3 x150 y460 w200 Choose1, F10|F1|F2|F3|F4|F5|F6|F7|F8|F9|F11|F12
    ; --- Buttons ---
    Gui 4:Add, Button, x20 y500 w120 h30 gActivateEnterCmds, Activate
    Gui 4:Add, Button, x160 y500 w80 h30 gCloseEnter, Back
    Gui 4:Show, w500 h550, Enter Commands Automation
Return

ActivateEnterCmds:
    Gui 4:Submit, NoHide
    Try Hotkey, *%EC_TriggerKey1%, Off
    Try Hotkey, *%EC_TriggerKey2%, Off
    Try Hotkey, *%EC_TriggerKey3%, Off
    if (EC_TriggerKey1 != "" and EC_TriggerKey1 != "grave")
        Try Hotkey, *%EC_TriggerKey1%, EC_Sequence1, On
    if (EC_TriggerKey2 != "" and EC_TriggerKey2 != "grave")
        Try Hotkey, *%EC_TriggerKey2%, EC_Sequence2, On
    if (EC_TriggerKey3 != "" and EC_TriggerKey3 != "grave")
        Try Hotkey, *%EC_TriggerKey3%, EC_Sequence3, On
    MsgBox, 64, Info, Triggers activated. Press the chosen function keys to run each sequence.
Return

CloseEnter:
    Try Hotkey, *%EC_TriggerKey1%, Off
    Try Hotkey, *%EC_TriggerKey2%, Off
    Try Hotkey, *%EC_TriggerKey3%, Off
    Gui 4:Destroy
    Gui 1:Show
Return

EC_Sequence1:
{
    if (EC_FirstKey1 = "grave")
        EC_FirstKey1 := "``"
    if (EC_SecondKey1 = "grave")
        EC_SecondKey1 := "``"
    Send, {%EC_FirstKey1% down}
    Sleep, 50
    Send, {%EC_FirstKey1% up}
    Sleep, 150
    SendInput, %EC_InputText1%
    Sleep, 150
    Send, {%EC_SecondKey1% down}
    Sleep, 50
    Send, {%EC_SecondKey1% up}
}
Return

EC_Sequence2:
{
    if (EC_FirstKey2 = "grave")
        EC_FirstKey2 := "``"
    if (EC_SecondKey2 = "grave")
        EC_SecondKey2 := "``"
    Send, {%EC_FirstKey2% down}
    Sleep, 50
    Send, {%EC_FirstKey2% up}
    Sleep, 150
    SendInput, %EC_InputText2%
    Sleep, 150
    Send, {%EC_SecondKey2% down}
    Sleep, 50
    Send, {%EC_SecondKey2% up}
}
Return

EC_Sequence3:
{
    if (EC_FirstKey3 = "grave")
        EC_FirstKey3 := "``"
    if (EC_SecondKey3 = "grave")
        EC_SecondKey3 := "``"
    Send, {%EC_FirstKey3% down}
    Sleep, 50
    Send, {%EC_FirstKey3% up}
    Sleep, 150
    SendInput, %EC_InputText3%
    Sleep, 150
    Send, {%EC_SecondKey3% down}
    Sleep, 50
    Send, {%EC_SecondKey3% up}
}
Return

; -------------------------------------------------
; MODE 2: KEY HOLDER (GUI #3)
; -------------------------------------------------
OpenKeyHolder:
    Gui 1:Hide
    Gui 3:Destroy
    Gui 3:Default
    DefaultKey := "e"
    KH_Running := false
    Gui 3:Add, Text, x20 y20 w200 h20, Select Key to Hold Down: F8 Toggles
    Gui 3:Add, DropDownList, vKH_KeyChoice x20 y50 w140, |up|down|left|right|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|lbutton|rbutton|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9
    Gui 3:Add, Button, gKH_Reset x170 y50 w60 h20, Reset
    Gui 3:Add, Text, vKH_Status x20 y90 w200 h30, Stopped
    Gui 3:Add, Button, x20 y140 w100 h30 gCloseKeyHolder, Back
    Gui 3:Show, w250 h200, Key Hold Automation
    GuiControl, 3:, KH_KeyChoice, %DefaultKey%
    Hotkey, F8, KH_Toggle, On
Return

CloseKeyHolder:
    if (KH_Running) {
        GuiControlGet, sKey, 3:, KH_KeyChoice
        if (sKey != "")
            Send, {%sKey% up}
    }
    KH_Running := false
    Hotkey, F8, Off
    Gui 3:Destroy
    Gui 1:Show
    UpdateStatusBox()
Return

KH_Reset:
    GuiControl, 3:, KH_KeyChoice, e
Return

KH_Toggle:
    global KH_Running
    KH_Running := !KH_Running
    Gui 3:Submit, NoHide
    GuiControlGet, selectedKey, 3:, KH_KeyChoice
    GuiControl, 3:, KH_Status, % KH_Running ? "Holding Key" : "Stopped"
    if (selectedKey = "")
    {
        MsgBox, 48, Error, Please select a key first.
        KH_Running := false
        GuiControl, 3:, KH_Status, Stopped
        return
    }
    if (KH_Running) {
        Send, {%selectedKey% down}
    } else {
        Send, {%selectedKey% up}
    }
    UpdateStatusBox()
Return

; -------------------------------------------------
; MODE 3: KEY PRESSER (GUI #2)
; -------------------------------------------------
OpenKeyPresser:
    Gui 1:Hide
    Gui 2:Destroy
    Gui 2:Default
    ; Defaults (numeric enabled state: 1 = enabled)
    DefaultKey1 := "e"
    DefaultDelay1 := 11000
    DefaultHold1  := 500
    DefaultMaxCount1 := 10
    DefaultEnabled1 := 1
    DefaultKey2 := "lbutton"
    DefaultDelay2 := 550
    DefaultHold2  := 790
    DefaultMaxCount2 := 10
    DefaultEnabled2 := 0
    DefaultKey3 := "c"
    DefaultDelay3 := 1000
    DefaultHold3  := 500
    DefaultMaxCount3 := 10
    DefaultEnabled3 := 0
    DefaultKey4 := "6"
    DefaultDelay4 := 1000
    DefaultHold4  := 500
    DefaultMaxCount4 := 10
    DefaultEnabled4 := 0

    ; Set key enable flags (numeric)
    KeyEnabled1 := DefaultEnabled1
    KeyEnabled2 := DefaultEnabled2
    KeyEnabled3 := DefaultEnabled3
    KeyEnabled4 := DefaultEnabled4

    KeyOptions := "|up|down|left|right|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|lbutton|rbutton|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9"
    Gui 2:Add, Text, x20 y20 w200 h20, Press F8 to start/stop key presses:
    ; --- Key 1 ---
    Gui 2:Add, Text, x20 y40 w100 h20, Key 1:
    Gui 2:Add, DropDownList, vKP_KeyChoice1 x120 y40 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y70 w100 h20, Delay 1 (ms):
    Gui 2:Add, Edit, vKP_DelayInput1 x120 y70 w100 h20, %DefaultDelay1%
    Gui 2:Add, Text, x20 y100 w100 h20, Hold Time 1 (ms):
    Gui 2:Add, Edit, vKP_HoldTime1 x120 y100 w100 h20, %DefaultHold1%
    Gui 2:Add, Text, x20 y130 w100 h20, Max Count 1:
    Gui 2:Add, Edit, vKP_MaxCount1 x120 y130 w100 h20, %DefaultMaxCount1%
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled1 x230 y130 w120 h20 Checked, Enforce
    Gui 2:Add, Button, vKP_Button1 gKP_ToggleKey1 x120 y160 w100 h20, % (KeyEnabled1 ? "Enabled" : "Disabled")
    ; --- Key 2 ---
    Gui 2:Add, Text, x20 y200 w100 h20, Key 2:
    Gui 2:Add, DropDownList, vKP_KeyChoice2 x120 y200 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y230 w100 h20, Delay 2 (ms):
    Gui 2:Add, Edit, vKP_DelayInput2 x120 y230 w100 h20, %DefaultDelay2%
    Gui 2:Add, Text, x20 y260 w100 h20, Hold Time 2 (ms):
    Gui 2:Add, Edit, vKP_HoldTime2 x120 y260 w100 h20, %DefaultHold2%
    Gui 2:Add, Text, x20 y290 w100 h20, Max Count 2:
    Gui 2:Add, Edit, vKP_MaxCount2 x120 y290 w100 h20, %DefaultMaxCount2%
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled2 x230 y290 w120 h20 Checked, Enforce
    Gui 2:Add, Button, vKP_Button2 gKP_ToggleKey2 x120 y320 w100 h20, % (KeyEnabled2 ? "Enabled" : "Disabled")
    ; --- Key 3 ---
    Gui 2:Add, Text, x20 y360 w100 h20, Key 3:
    Gui 2:Add, DropDownList, vKP_KeyChoice3 x120 y360 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y390 w100 h20, Delay 3 (ms):
    Gui 2:Add, Edit, vKP_DelayInput3 x120 y390 w100 h20, %DefaultDelay3%
    Gui 2:Add, Text, x20 y420 w100 h20, Hold Time 3 (ms):
    Gui 2:Add, Edit, vKP_HoldTime3 x120 y420 w100 h20, %DefaultHold3%
    Gui 2:Add, Text, x20 y450 w100 h20, Max Count 3:
    Gui 2:Add, Edit, vKP_MaxCount3 x120 y450 w100 h20, %DefaultMaxCount3%
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled3 x230 y450 w120 h20 Checked, Enforce
    Gui 2:Add, Button, vKP_Button3 gKP_ToggleKey3 x120 y480 w100 h20, % (KeyEnabled3 ? "Enabled" : "Disabled")
    ; --- Key 4 ---
    Gui 2:Add, Text, x20 y520 w100 h20, Key 4:
    Gui 2:Add, DropDownList, vKP_KeyChoice4 x120 y520 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y550 w100 h20, Delay 4 (ms):
    Gui 2:Add, Edit, vKP_DelayInput4 x120 y550 w100 h20, %DefaultDelay4%
    Gui 2:Add, Text, x20 y580 w100 h20, Hold Time 4 (ms):
    Gui 2:Add, Edit, vKP_HoldTime4 x120 y580 w100 h20, %DefaultHold4%
    Gui 2:Add, Text, x20 y610 w100 h20, Max Count 4:
    Gui 2:Add, Edit, vKP_MaxCount4 x120 y610 w100 h20, %DefaultMaxCount4%
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled4 x230 y610 w120 h20 Checked, Enforce
    Gui 2:Add, Button, vKP_Button4 gKP_ToggleKey4 x120 y640 w100 h20, % (KeyEnabled4 ? "Enabled" : "Disabled")
    Gui 2:Add, CheckBox, vKP_RepeatCheckBox x20 y670 w200 h20 Checked, Repeat Continuously (check to repeat sequence)
    Gui 2:Font, s16 Bold
    Gui 2:Add, Text, vKP_Status x110 y700 w100 h40 +Center, Stopped
    Gui 2:Font
    Gui 2:Add, Button, gKP_ResetDefaults x120 y750 w100 h30, Reset Defaults
    Gui 2:Add, Button, gCloseKeyPresser x20 y750 w80 h30, Back
    GuiControl, 2:, KP_KeyChoice1, %DefaultKey1%
    GuiControl, 2:, KP_KeyChoice2, %DefaultKey2%
    GuiControl, 2:, KP_KeyChoice3, %DefaultKey3%
    GuiControl, 2:, KP_KeyChoice4, %DefaultKey4%
    Gui 2:Show, w370 h800, Key Press Automation
    Hotkey, F8, KP_Toggle, On
Return

CloseKeyPresser:
    if (KP_Running) {
        KP_StopAutomation()
    }
    Hotkey, F8, Off
    Gui 2:Destroy
    Gui 1:Show
    UpdateStatusBox()
Return

; ------------------------
; F8 toggles Key Presser automation
; ------------------------
KP_Toggle:
    global KP_Running
    KP_Running := !KP_Running
    Gui 2:Submit, NoHide
    GuiControl, 2:, KP_Status, % KP_Running ? "Started" : "Stopped"
    if (KP_Running) {
        KP_StartAutomation()
    } else {
        KP_StopAutomation()
    }
    UpdateStatusBox()
Return

KP_StartAutomation() {
    global KP_Running, KP_Counter1, KP_Counter2, KP_Counter3, KP_Counter4
    global KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    KP_Counter1 := 0, KP_Counter2 := 0, KP_Counter3 := 0, KP_Counter4 := 0
    ; Do not reset key states here – leave them as toggled.
    delayVal := GuiControlGetDelay(1)
    SetTimer, KP_KeyPress1, % delayVal
    delayVal := GuiControlGetDelay(2)
    SetTimer, KP_KeyPress2, % delayVal
    delayVal := GuiControlGetDelay(3)
    SetTimer, KP_KeyPress3, % delayVal
    delayVal := GuiControlGetDelay(4)
    SetTimer, KP_KeyPress4, % delayVal
}

KP_StopAutomation() {
    global KP_Running
    KP_Running := false
    GuiControl, 2:, KP_Status, Stopped
    SetTimer, KP_KeyPress1, Off
    SetTimer, KP_KeyPress2, Off
    SetTimer, KP_KeyPress3, Off
    SetTimer, KP_KeyPress4, Off
    GuiControlGet, k1, 2:, KP_KeyChoice1
    GuiControlGet, k2, 2:, KP_KeyChoice2
    GuiControlGet, k3, 2:, KP_KeyChoice3
    GuiControlGet, k4, 2:, KP_KeyChoice4
    if (k1 != "")
        Send, {%k1% up}
    if (k2 != "")
        Send, {%k2% up}
    if (k3 != "")
        Send, {%k3% up}
    if (k4 != "")
        Send, {%k4% up}
    UpdateStatusBox()
}

; --- Timer Routines ---
KP_KeyPress1:
    global KP_Running, KeyEnabled1, KP_Counter1
    if (!KP_Running or KeyEnabled1 = 0) {
         SetTimer, KP_KeyPress1, Off
         Return
    }
    KP_SendKey(1)
    KP_Counter1++
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled1
    if (enforce = 1) {
         GuiControlGet, maxCount, 2:, KP_MaxCount1
         if (KP_Counter1 >= maxCount) {
              SetTimer, KP_KeyPress1, Off
              KeyEnabled1 := 0
              GuiControl, 2:, KP_Button1, Disabled
         }
    }
    if (!KP_RepeatCheck())
         SetTimer, KP_KeyPress1, Off
    KP_CheckAutoStop()
Return

KP_KeyPress2:
    global KP_Running, KeyEnabled2, KP_Counter2
    if (!KP_Running or KeyEnabled2 = 0) {
         SetTimer, KP_KeyPress2, Off
         Return
    }
    KP_SendKey(2)
    KP_Counter2++
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled2
    if (enforce = 1) {
         GuiControlGet, maxCount, 2:, KP_MaxCount2
         if (KP_Counter2 >= maxCount) {
              SetTimer, KP_KeyPress2, Off
              KeyEnabled2 := 0
              GuiControl, 2:, KP_Button2, Disabled
         }
    }
    if (!KP_RepeatCheck())
         SetTimer, KP_KeyPress2, Off
    KP_CheckAutoStop()
Return

KP_KeyPress3:
    global KP_Running, KeyEnabled3, KP_Counter3
    if (!KP_Running or KeyEnabled3 = 0) {
         SetTimer, KP_KeyPress3, Off
         Return
    }
    KP_SendKey(3)
    KP_Counter3++
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled3
    if (enforce = 1) {
         GuiControlGet, maxCount, 2:, KP_MaxCount3
         if (KP_Counter3 >= maxCount) {
              SetTimer, KP_KeyPress3, Off
              KeyEnabled3 := 0
              GuiControl, 2:, KP_Button3, Disabled
         }
    }
    if (!KP_RepeatCheck())
         SetTimer, KP_KeyPress3, Off
    KP_CheckAutoStop()
Return

KP_KeyPress4:
    global KP_Running, KeyEnabled4, KP_Counter4
    if (!KP_Running or KeyEnabled4 = 0) {
         SetTimer, KP_KeyPress4, Off
         Return
    }
    KP_SendKey(4)
    KP_Counter4++
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled4
    if (enforce = 1) {
         GuiControlGet, maxCount, 2:, KP_MaxCount4
         if (KP_Counter4 >= maxCount) {
              SetTimer, KP_KeyPress4, Off
              KeyEnabled4 := 0
              GuiControl, 2:, KP_Button4, Disabled
         }
    }
    if (!KP_RepeatCheck())
         SetTimer, KP_KeyPress4, Off
    KP_CheckAutoStop()
Return

; --- Helper functions for Key Presser ---
KP_SendKey(n) {
    global KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    if ((n = 1 and KeyEnabled1 = 0) or (n = 2 and KeyEnabled2 = 0) or (n = 3 and KeyEnabled3 = 0) or (n = 4 and KeyEnabled4 = 0))
        return
    GuiControlGet, curKey, 2:, KP_KeyChoice%n%
    curKey := Trim(curKey)
    if (curKey != "")
        SendInput, {%curKey%}
}

GuiControlGetDelay(n) {
    GuiControlGet, out, 2:, KP_DelayInput%n%
    return out
}

KP_RepeatCheck() {
    GuiControlGet, chk, 2:, KP_RepeatCheckBox
    return (chk = 1)
}

; --- Revised ToggleKey using numeric state ---
ToggleKey(n) {
    global KP_Running, KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    currentState := (n = 1 ? KeyEnabled1 : n = 2 ? KeyEnabled2 : n = 3 ? KeyEnabled3 : KeyEnabled4)
    if (currentState = 1) {
        newState := 0
        newText := "Disabled"
    } else {
        newState := 1
        newText := "Enabled"
    }
    if (n = 1)
        KeyEnabled1 := newState
    else if (n = 2)
        KeyEnabled2 := newState
    else if (n = 3)
        KeyEnabled3 := newState
    else if (n = 4)
        KeyEnabled4 := newState
    GuiControl, 2:, KP_Button%n%, %newText%
    SetTimer, % "KP_KeyPress" n, Off
    if (KP_Running and newState = 1) {
        delayVal := GuiControlGetDelay(n)
        SetTimer, % "KP_KeyPress" n, % delayVal
    }
}

KP_ToggleKey1:
    ToggleKey(1)
Return
KP_ToggleKey2:
    ToggleKey(2)
Return
KP_ToggleKey3:
    ToggleKey(3)
Return
KP_ToggleKey4:
    ToggleKey(4)
Return

KP_ResetDefaults:
    GuiControl, 2:, KP_KeyChoice1, %DefaultKey1%
    GuiControl, 2:, KP_DelayInput1, %DefaultDelay1%
    GuiControl, 2:, KP_HoldTime1, %DefaultHold1%
    GuiControl, 2:, KP_MaxCount1, %DefaultMaxCount1%
    
    GuiControl, 2:, KP_KeyChoice2, %DefaultKey2%
    GuiControl, 2:, KP_DelayInput2, %DefaultDelay2%
    GuiControl, 2:, KP_HoldTime2, %DefaultHold2%
    GuiControl, 2:, KP_MaxCount2, %DefaultMaxCount2%
    
    GuiControl, 2:, KP_KeyChoice3, %DefaultKey3%
    GuiControl, 2:, KP_DelayInput3, %DefaultDelay3%
    GuiControl, 2:, KP_HoldTime3, %DefaultHold3%
    GuiControl, 2:, KP_MaxCount3, %DefaultMaxCount3%
    
    GuiControl, 2:, KP_KeyChoice4, %DefaultKey4%
    GuiControl, 2:, KP_DelayInput4, %DefaultDelay4%
    GuiControl, 2:, KP_HoldTime4, %DefaultHold4%
    GuiControl, 2:, KP_MaxCount4, %DefaultMaxCount4%
Return

; --- Auto-stop helper function ---
KP_CheckAutoStop() {
    global KP_Running, KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    hasNonEnforcedActive := false
    enforcedCount := 0
    enforcedDoneCount := 0
    GuiControlGet, enforce1, 2:, KP_MaxCountEnabled1
    if (enforce1 = 1) {
         enforcedCount++
         if (KeyEnabled1 = 0)
             enforcedDoneCount++
    } else {
         if (KeyEnabled1 = 1)
             hasNonEnforcedActive := true
    }
    GuiControlGet, enforce2, 2:, KP_MaxCountEnabled2
    if (enforce2 = 1) {
         enforcedCount++
         if (KeyEnabled2 = 0)
             enforcedDoneCount++
    } else {
         if (KeyEnabled2 = 1)
             hasNonEnforcedActive := true
    }
    GuiControlGet, enforce3, 2:, KP_MaxCountEnabled3
    if (enforce3 = 1) {
         enforcedCount++
         if (KeyEnabled3 = 0)
             enforcedDoneCount++
    } else {
         if (KeyEnabled3 = 1)
             hasNonEnforcedActive := true
    }
    GuiControlGet, enforce4, 2:, KP_MaxCountEnabled4
    if (enforce4 = 1) {
         enforcedCount++
         if (KeyEnabled4 = 0)
             enforcedDoneCount++
    } else {
         if (KeyEnabled4 = 1)
             hasNonEnforcedActive := true
    }
    if (hasNonEnforcedActive)
         return false
    if (enforcedCount > 0 and enforcedCount = enforcedDoneCount) {
         if (KP_Running) {
             KP_Running := false
             KP_StopAutomation()
         }
         return true
    }
    return false
}

; -------------------------------
; Universal Close
; -------------------------------
GuiClose:
1GuiClose:
2GuiClose:
3GuiClose:
4GuiClose:
ExitApp
