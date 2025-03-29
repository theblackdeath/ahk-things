#NoEnv
#SingleInstance Force

; -------------------------------------------------------------------
; 1) Define global lists for dropdowns.
;    (Using pipe-delimited strings for manual parsing.)
; -------------------------------------------------------------------
global EnterCommandsKeyList := "grave|one|two|three|four|five|six|seven|eight|nine|zero|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|enter|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2"

global EnterCommandsTriggerList := "F8|F1|F2|F3|F4|F5|F6|F7|F9|F10|F11|F12"

global KeyHolderList := "up|down|left|right|space|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|lbutton|rbutton|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9"

; For Key Presser – note the added "enter" and "ctrl+v" at the end.
global KeyPresserList := "|up|down|left|right|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|lbutton|rbutton|space|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|one|two|three|four|five|six|seven|eight|nine|zero|enter|ctrl+v"

; -------------------------------------------------------------------
; Helper: Convert words for digits to numeric keys.
; -------------------------------------------------------------------
ConvertKey(key) {
    key := Trim(key)
    StringLower, keyLower, key
    if (keyLower = "one")
        return "1"
    else if (keyLower = "two")
        return "2"
    else if (keyLower = "three")
        return "3"
    else if (keyLower = "four")
        return "4"
    else if (keyLower = "five")
        return "5"
    else if (keyLower = "six")
        return "6"
    else if (keyLower = "seven")
        return "7"
    else if (keyLower = "eight")
        return "8"
    else if (keyLower = "nine")
        return "9"
    else if (keyLower = "zero")
        return "0"
    else
        return key
}

; -------------------------------------------------------------------
; Helper: SetExactChoice - manually select the saved value.
; -------------------------------------------------------------------
SetExactChoice(controlName, savedValue, itemList) {
    if (SubStr(itemList,1,1) = "|")
        itemList := SubStr(itemList,2)
    index := 0, found := false
    Loop, Parse, itemList, |
    {
        index++
        if (A_LoopField = savedValue) {
            GuiControl, Choose, %controlName%, %index%
            found := true
            break
        }
    }
    if (!found)
        GuiControl, Choose, %controlName%, 1
}

; -------------------------------------------------------------------
; Global variables to track previous trigger keys.
; -------------------------------------------------------------------
Prev_TriggerKey1 := ""
Prev_TriggerKey2 := ""
Prev_TriggerKey3 := ""

; -------------------------------------------------------------------
; INI file and Load/Save functions (removed repeat-related settings)
; -------------------------------------------------------------------
IniFile := "settings.ini"
LoadSettings()

LoadSettings() {
    global IniFile, EC_FirstKey1, EC_InputText1, EC_SecondKey1, EC_TriggerKey1
    global EC_FirstKey2, EC_InputText2, EC_SecondKey2, EC_TriggerKey2
    global EC_FirstKey3, EC_InputText3, EC_SecondKey3, EC_TriggerKey3
    global DefaultKHKey
    global DefaultKey1, DefaultDelay1, DefaultHold1, DefaultMaxCount1, DefaultEnabled1
    global DefaultKey2, DefaultDelay2, DefaultHold2, DefaultMaxCount2, DefaultEnabled2
    global DefaultKey3, DefaultDelay3, DefaultHold3, DefaultMaxCount3, DefaultEnabled3
    global DefaultKey4, DefaultDelay4, DefaultHold4, DefaultMaxCount4, DefaultEnabled4
    global DefaultEnforce1, DefaultEnforce2, DefaultEnforce3, DefaultEnforce4

    ; --- Enter Commands ---
    IniRead, EC_FirstKey1,  %IniFile%, EnterCommands, FirstKey1, grave
    EC_FirstKey1 := Trim(EC_FirstKey1)
    if (EC_FirstKey1 = "")
        EC_FirstKey1 := "grave"

    IniRead, EC_InputText1, %IniFile%, EnterCommands, InputText1, Your Text Here.
    if (EC_InputText1 = "")
        EC_InputText1 := "Your Text Here."

    IniRead, EC_SecondKey1, %IniFile%, EnterCommands, SecondKey1, enter
    EC_SecondKey1 := Trim(EC_SecondKey1)
    if (EC_SecondKey1 = "")
        EC_SecondKey1 := "enter"

    IniRead, EC_TriggerKey1, %IniFile%, EnterCommands, TriggerKey1, F8
    EC_TriggerKey1 := Trim(EC_TriggerKey1)
    if (EC_TriggerKey1 = "")
        EC_TriggerKey1 := "F8"

    IniRead, EC_FirstKey2,  %IniFile%, EnterCommands, FirstKey2, grave
    EC_FirstKey2 := Trim(EC_FirstKey2)
    if (EC_FirstKey2 = "")
        EC_FirstKey2 := "grave"

    IniRead, EC_InputText2, %IniFile%, EnterCommands, InputText2, Your Text Here.
    if (EC_InputText2 = "")
        EC_InputText2 := "Your Text Here."

    IniRead, EC_SecondKey2, %IniFile%, EnterCommands, SecondKey2, enter
    EC_SecondKey2 := Trim(EC_SecondKey2)
    if (EC_SecondKey2 = "")
        EC_SecondKey2 := "enter"

    IniRead, EC_TriggerKey2, %IniFile%, EnterCommands, TriggerKey2, F9
    EC_TriggerKey2 := Trim(EC_TriggerKey2)
    if (EC_TriggerKey2 = "")
        EC_TriggerKey2 := "F9"

    IniRead, EC_FirstKey3,  %IniFile%, EnterCommands, FirstKey3, grave
    EC_FirstKey3 := Trim(EC_FirstKey3)
    if (EC_FirstKey3 = "")
        EC_FirstKey3 := "grave"

    IniRead, EC_InputText3, %IniFile%, EnterCommands, InputText3, Your Text Here.
    if (EC_InputText3 = "")
        EC_InputText3 := "Your Text Here."

    IniRead, EC_SecondKey3, %IniFile%, EnterCommands, SecondKey3, enter
    EC_SecondKey3 := Trim(EC_SecondKey3)
    if (EC_SecondKey3 = "")
        EC_SecondKey3 := "enter"

    IniRead, EC_TriggerKey3, %IniFile%, EnterCommands, TriggerKey3, F10
    EC_TriggerKey3 := Trim(EC_TriggerKey3)
    if (EC_TriggerKey3 = "")
        EC_TriggerKey3 := "F10"

    ; --- Key Holder ---
    IniRead, DefaultKHKey, %IniFile%, KeyHolder, KeyChoice, e
    DefaultKHKey := Trim(DefaultKHKey)
    if (DefaultKHKey = "")
        DefaultKHKey := "e"

    ; --- Key Presser (4 keys) ---
    IniRead, DefaultKey1,  %IniFile%, KeyPresser, Key1, e
    if (DefaultKey1 = "")
        DefaultKey1 := "e"

    IniRead, DefaultDelay1, %IniFile%, KeyPresser, Delay1, 11000
    if (DefaultDelay1 = "")
        DefaultDelay1 := 11000

    IniRead, DefaultHold1, %IniFile%, KeyPresser, Hold1, 500
    if (DefaultHold1 = "")
        DefaultHold1 := 500

    IniRead, DefaultMaxCount1, %IniFile%, KeyPresser, MaxCount1, 10
    if (DefaultMaxCount1 = "")
        DefaultMaxCount1 := 10

    IniRead, DefaultEnabled1, %IniFile%, KeyPresser, Enabled1, 1
    if (DefaultEnabled1 = "")
        DefaultEnabled1 := 1

    ; Key2
    IniRead, DefaultKey2,  %IniFile%, KeyPresser, Key2, lbutton
    if (DefaultKey2 = "")
        DefaultKey2 := "lbutton"

    IniRead, DefaultDelay2, %IniFile%, KeyPresser, Delay2, 550
    if (DefaultDelay2 = "")
        DefaultDelay2 := 550

    IniRead, DefaultHold2, %IniFile%, KeyPresser, Hold2, 790
    if (DefaultHold2 = "")
        DefaultHold2 := 790

    IniRead, DefaultMaxCount2, %IniFile%, KeyPresser, MaxCount2, 10
    if (DefaultMaxCount2 = "")
        DefaultMaxCount2 := 10

    IniRead, DefaultEnabled2, %IniFile%, KeyPresser, Enabled2, 0
    if (DefaultEnabled2 = "")
        DefaultEnabled2 := 0

    ; Key3
    IniRead, DefaultKey3,  %IniFile%, KeyPresser, Key3, c
    if (DefaultKey3 = "")
        DefaultKey3 := "c"

    IniRead, DefaultDelay3, %IniFile%, KeyPresser, Delay3, 1000
    if (DefaultDelay3 = "")
        DefaultDelay3 := 1000

    IniRead, DefaultHold3, %IniFile%, KeyPresser, Hold3, 500
    if (DefaultHold3 = "")
        DefaultHold3 := 500

    IniRead, DefaultMaxCount3, %IniFile%, KeyPresser, MaxCount3, 10
    if (DefaultMaxCount3 = "")
        DefaultMaxCount3 := 10

    IniRead, DefaultEnabled3, %IniFile%, KeyPresser, Enabled3, 0
    if (DefaultEnabled3 = "")
        DefaultEnabled3 := 0

    ; Key4
    IniRead, DefaultKey4,  %IniFile%, KeyPresser, Key4, 6
    if (DefaultKey4 = "")
        DefaultKey4 := "6"

    IniRead, DefaultDelay4, %IniFile%, KeyPresser, Delay4, 1000
    if (DefaultDelay4 = "")
        DefaultDelay4 := 1000

    IniRead, DefaultHold4, %IniFile%, KeyPresser, Hold4, 500
    if (DefaultHold4 = "")
        DefaultHold4 := 500

    IniRead, DefaultMaxCount4, %IniFile%, KeyPresser, MaxCount4, 10
    if (DefaultMaxCount4 = "")
        DefaultMaxCount4 := 10

    IniRead, DefaultEnabled4, %IniFile%, KeyPresser, Enabled4, 0
    if (DefaultEnabled4 = "")
        DefaultEnabled4 := 0

    ; Enforce checkboxes
    IniRead, DefaultEnforce1, %IniFile%, KeyPresser, Enforce1, 1
    if (DefaultEnforce1 = "")
        DefaultEnforce1 := 1

    IniRead, DefaultEnforce2, %IniFile%, KeyPresser, Enforce2, 1
    if (DefaultEnforce2 = "")
        DefaultEnforce2 := 1

    IniRead, DefaultEnforce3, %IniFile%, KeyPresser, Enforce3, 1
    if (DefaultEnforce3 = "")
        DefaultEnforce3 := 1

    IniRead, DefaultEnforce4, %IniFile%, KeyPresser, Enforce4, 1
    if (DefaultEnforce4 = "")
        DefaultEnforce4 := 1

    global KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    KeyEnabled1 := DefaultEnabled1
    KeyEnabled2 := DefaultEnabled2
    KeyEnabled3 := DefaultEnabled3
    KeyEnabled4 := DefaultEnabled4
}

SaveSettings() {
    global IniFile, EC_FirstKey1, EC_InputText1, EC_SecondKey1, EC_TriggerKey1
    global EC_FirstKey2, EC_InputText2, EC_SecondKey2, EC_TriggerKey2
    global EC_FirstKey3, EC_InputText3, EC_SecondKey3, EC_TriggerKey3
    global DefaultKHKey
    global DefaultKey1, DefaultDelay1, DefaultHold1, DefaultMaxCount1, DefaultEnabled1
    global DefaultKey2, DefaultDelay2, DefaultHold2, DefaultMaxCount2, DefaultEnabled2
    global DefaultKey3, DefaultDelay3, DefaultHold3, DefaultMaxCount3, DefaultEnabled3
    global DefaultKey4, DefaultDelay4, DefaultHold4, DefaultMaxCount4, DefaultEnabled4
    global DefaultEnforce1, DefaultEnforce2, DefaultEnforce3, DefaultEnforce4

    ; --- Save Enter Commands ---
    IniWrite, %EC_FirstKey1%,  %IniFile%, EnterCommands, FirstKey1
    IniWrite, %EC_InputText1%, %IniFile%, EnterCommands, InputText1
    IniWrite, %EC_SecondKey1%, %IniFile%, EnterCommands, SecondKey1
    IniWrite, %EC_TriggerKey1%,%IniFile%, EnterCommands, TriggerKey1

    IniWrite, %EC_FirstKey2%,  %IniFile%, EnterCommands, FirstKey2
    IniWrite, %EC_InputText2%, %IniFile%, EnterCommands, InputText2
    IniWrite, %EC_SecondKey2%, %IniFile%, EnterCommands, SecondKey2
    IniWrite, %EC_TriggerKey2%,%IniFile%, EnterCommands, TriggerKey2

    IniWrite, %EC_FirstKey3%,  %IniFile%, EnterCommands, FirstKey3
    IniWrite, %EC_InputText3%, %IniFile%, EnterCommands, InputText3
    IniWrite, %EC_SecondKey3%, %IniFile%, EnterCommands, SecondKey3
    IniWrite, %EC_TriggerKey3%,%IniFile%, EnterCommands, TriggerKey3

    ; --- Save Key Holder ---
    IniWrite, %DefaultKHKey%, %IniFile%, KeyHolder, KeyChoice

    ; --- Save Key Presser ---
    IniWrite, %DefaultKey1%,     %IniFile%, KeyPresser, Key1
    IniWrite, %DefaultDelay1%,   %IniFile%, KeyPresser, Delay1
    IniWrite, %DefaultHold1%,    %IniFile%, KeyPresser, Hold1
    IniWrite, %DefaultMaxCount1%,%IniFile%, KeyPresser, MaxCount1
    IniWrite, %DefaultEnabled1%, %IniFile%, KeyPresser, Enabled1

    IniWrite, %DefaultKey2%,     %IniFile%, KeyPresser, Key2
    IniWrite, %DefaultDelay2%,   %IniFile%, KeyPresser, Delay2
    IniWrite, %DefaultHold2%,    %IniFile%, KeyPresser, Hold2
    IniWrite, %DefaultMaxCount2%,%IniFile%, KeyPresser, MaxCount2
    IniWrite, %DefaultEnabled2%, %IniFile%, KeyPresser, Enabled2

    IniWrite, %DefaultKey3%,     %IniFile%, KeyPresser, Key3
    IniWrite, %DefaultDelay3%,   %IniFile%, KeyPresser, Delay3
    IniWrite, %DefaultHold3%,    %IniFile%, KeyPresser, Hold3
    IniWrite, %DefaultMaxCount3%,%IniFile%, KeyPresser, MaxCount3
    IniWrite, %DefaultEnabled3%, %IniFile%, KeyPresser, Enabled3

    IniWrite, %DefaultKey4%,     %IniFile%, KeyPresser, Key4
    IniWrite, %DefaultDelay4%,   %IniFile%, KeyPresser, Delay4
    IniWrite, %DefaultHold4%,    %IniFile%, KeyPresser, Hold4
    IniWrite, %DefaultMaxCount4%,%IniFile%, KeyPresser, MaxCount4
    IniWrite, %DefaultEnabled4%, %IniFile%, KeyPresser, Enabled4

    ; Enforce checkboxes
    IniWrite, %DefaultEnforce1%, %IniFile%, KeyPresser, Enforce1
    IniWrite, %DefaultEnforce2%, %IniFile%, KeyPresser, Enforce2
    IniWrite, %DefaultEnforce3%, %IniFile%, KeyPresser, Enforce3
    IniWrite, %DefaultEnforce4%, %IniFile%, KeyPresser, Enforce4
}

; -------------------------------------------------------------------
; Create Status Box
; -------------------------------------------------------------------
StatusBox_Create() {
    Gui, StatusBox:New, +AlwaysOnTop -Caption +ToolWindow, Status
    Gui, StatusBox:Color, FF0000
    SysGet, MonitorWorkArea, MonitorWorkArea
    xPos := ((MonitorWorkAreaRight - MonitorWorkAreaLeft) - 20) // 2 + MonitorWorkAreaLeft
    yPos := MonitorWorkAreaTop + 5
    Gui, StatusBox:Show, x%xPos% y%yPos% w20 h20, Status
}
StatusBox_Create()

UpdateStatusBox() {
    global KH_Running, KP_Running
    if (KH_Running or KP_Running)
        Gui, StatusBox:Color, 00FF00
    else
        Gui, StatusBox:Color, FF0000
    Gui, StatusBox:Show, NA
}

; -------------------------------------------------------------------
; MAIN GUI (#1)
; -------------------------------------------------------------------
Gui 1:Default
Gui 1:Add, Text, x20 y20 w360 h20, Main Menu - Choose a mode:
Gui 1:Add, Button, x20 y60  w140 h30 gOpenEnterCommands, Enter Commands
Gui 1:Add, Button, x20 y100 w140 h30 gOpenKeyHolder,     Key Holder
Gui 1:Add, Button, x20 y140 w140 h30 gOpenKeyPresser,    Key Presser
Gui 1:Add, Button, x20 y200 w140 h30 gExitScript,        Exit
Gui 1:Show, x100 y100 w400 h250, Main Menu
Return

ExitScript:
    SaveSettings()
    ExitApp
Return

; -------------------------------------------------------------------
; MODE 1: ENTER COMMANDS (#4)
; -------------------------------------------------------------------
OpenEnterCommands:
    Gui 1:Hide
    Gui 4:Destroy
    Gui 4:Default

    ; FIRST SEQUENCE
    Gui 4:Add, Text, x20 y20 w200 h20, **First Sequence**
    Gui 4:Add, Text, x20 y50 w200 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey1 x150 y50 w200, %EnterCommandsKeyList%
    Gui 4:Add, Text, x20 y80 w200 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText1 x150 y80 w200 h20, %EC_InputText1%
    Gui 4:Add, Text, x20 y110 w200 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey1 x150 y110 w200, %EnterCommandsKeyList%
    Gui 4:Add, Text, x20 y140 w200 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey1 x150 y140 w200, %EnterCommandsTriggerList%

    ; SECOND SEQUENCE
    Gui 4:Add, Text, x20 y180 w200 h20, **Second Sequence**
    Gui 4:Add, Text, x20 y210 w200 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey2 x150 y210 w200, %EnterCommandsKeyList%
    Gui 4:Add, Text, x20 y240 w200 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText2 x150 y240 w200 h20, %EC_InputText2%
    Gui 4:Add, Text, x20 y270 w200 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey2 x150 y270 w200, %EnterCommandsKeyList%
    Gui 4:Add, Text, x20 y300 w200 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey2 x150 y300 w200, %EnterCommandsTriggerList%

    ; THIRD SEQUENCE
    Gui 4:Add, Text, x20 y340 w200 h20, **Third Sequence**
    Gui 4:Add, Text, x20 y370 w200 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey3 x150 y370 w200, %EnterCommandsKeyList%
    Gui 4:Add, Text, x20 y400 w200 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText3 x150 y400 w200 h20, %EC_InputText3%
    Gui 4:Add, Text, x20 y430 w200 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey3 x150 y430 w200, %EnterCommandsKeyList%
    Gui 4:Add, Text, x20 y460 w200 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey3 x150 y460 w200, %EnterCommandsTriggerList%

    ; Restore saved selections exactly:
    SetExactChoice("EC_FirstKey1",   EC_FirstKey1,   EnterCommandsKeyList)
    SetExactChoice("EC_SecondKey1",  EC_SecondKey1,  EnterCommandsKeyList)
    SetExactChoice("EC_TriggerKey1", EC_TriggerKey1, EnterCommandsTriggerList)
    SetExactChoice("EC_FirstKey2",   EC_FirstKey2,   EnterCommandsKeyList)
    SetExactChoice("EC_SecondKey2",  EC_SecondKey2,  EnterCommandsKeyList)
    SetExactChoice("EC_TriggerKey2", EC_TriggerKey2, EnterCommandsTriggerList)
    SetExactChoice("EC_FirstKey3",   EC_FirstKey3,   EnterCommandsKeyList)
    SetExactChoice("EC_SecondKey3",  EC_SecondKey3,  EnterCommandsKeyList)
    SetExactChoice("EC_TriggerKey3", EC_TriggerKey3, EnterCommandsTriggerList)

    ; Buttons
    Gui 4:Add, Button, x20 y500 w120 h30 gActivateEnterCmds, Activate
    Gui 4:Add, Button, x160 y500 w80  h30 gCloseEnter,       Back

    Gui 4:Show, w500 h550, Enter Commands Automation
Return

ActivateEnterCmds:
{
    Gui 4:Submit, NoHide
    SaveSettings()
    if (Prev_TriggerKey1 != "")
        Hotkey, *%Prev_TriggerKey1%, Off
    Prev_TriggerKey1 := EC_TriggerKey1
    if (Prev_TriggerKey2 != "")
        Hotkey, *%Prev_TriggerKey2%, Off
    Prev_TriggerKey2 := EC_TriggerKey2
    if (Prev_TriggerKey3 != "")
        Hotkey, *%Prev_TriggerKey3%, Off
    Prev_TriggerKey3 := EC_TriggerKey3
    if (EC_TriggerKey1 != "" and EC_TriggerKey1 != "grave")
        Hotkey, *%EC_TriggerKey1%, EC_Sequence1, On
    if (EC_TriggerKey2 != "" and EC_TriggerKey2 != "grave")
        Hotkey, *%EC_TriggerKey2%, EC_Sequence2, On
    if (EC_TriggerKey3 != "" and EC_TriggerKey3 != "grave")
        Hotkey, *%EC_TriggerKey3%, EC_Sequence3, On
}
Return

CloseEnter:
    Gui 4:Submit, NoHide
    SaveSettings()
    Try Hotkey, *%EC_TriggerKey1%, Off
    Try Hotkey, *%EC_TriggerKey2%, Off
    Try Hotkey, *%EC_TriggerKey3%, Off
    Gui 4:Destroy
    Gui 1:Show
Return

EC_Sequence1:
{
    if (EC_FirstKey1 = "grave")
        key1 := "SC029"
    else
        key1 := ConvertKey(EC_FirstKey1)
    if (EC_SecondKey1 = "grave")
        key2 := "SC029"
    else
        key2 := ConvertKey(EC_SecondKey1)
    Send, {%key1% down}
    Sleep, 50
    Send, {%key1% up}
    Sleep, 150
    SendInput, %EC_InputText1%
    Sleep, 150
    Send, {%key2% down}
    Sleep, 50
    Send, {%key2% up}
}
Return

EC_Sequence2:
{
    if (EC_FirstKey2 = "grave")
        key1 := "SC029"
    else
        key1 := ConvertKey(EC_FirstKey2)
    if (EC_SecondKey2 = "grave")
        key2 := "SC029"
    else
        key2 := ConvertKey(EC_SecondKey2)
    Send, {%key1% down}
    Sleep, 50
    Send, {%key1% up}
    Sleep, 150
    SendInput, %EC_InputText2%
    Sleep, 150
    Send, {%key2% down}
    Sleep, 50
    Send, {%key2% up}
}
Return

EC_Sequence3:
{
    if (EC_FirstKey3 = "grave")
        key1 := "SC029"
    else
        key1 := ConvertKey(EC_FirstKey3)
    if (EC_SecondKey3 = "grave")
        key2 := "SC029"
    else
        key2 := ConvertKey(EC_SecondKey3)
    Send, {%key1% down}
    Sleep, 50
    Send, {%key1% up}
    Sleep, 150
    SendInput, %EC_InputText3%
    Sleep, 150
    Send, {%key2% down}
    Sleep, 50
    Send, {%key2% up}
}
Return

; -------------------------------------------------------------------
; MODE 2: KEY HOLDER (#3)
; -------------------------------------------------------------------
OpenKeyHolder:
    Gui 1:Hide
    Gui 3:Destroy
    Gui 3:Default
    KH_Running := false

    Gui 3:Add, Text, x20 y20 w200 h20, Select Key to Hold Down: F8 Toggles
    ; Use the global KeyHolderList
    Gui 3:Add, DropDownList, vKH_KeyChoice x20 y50 w140, %KeyHolderList%
    Gui 3:Add, Button, x170 y50 w60 h20 gKH_Reset, Reset
    Gui 3:Add, Text, vKH_Status x20 y90 w200 h30, Stopped
    Gui 3:Add, Button, x20 y140 w100 h30 gCloseKeyHolder, Back

    ; Use SetExactChoice to restore the saved value exactly:
    SetExactChoice("KH_KeyChoice", DefaultKHKey, KeyHolderList)

    
    Gui 3:Show, w250 h200, Key Hold Automation
    Hotkey, F8, KH_Toggle, On
Return


CloseKeyHolder:
    Gui 3:Submit, NoHide
    DefaultKHKey := KH_KeyChoice
    SaveSettings()
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

; -------------------------------------------------------------------
; MODE 3: KEY PRESSER (#2)
; -------------------------------------------------------------------
OpenKeyPresser:
    Gui 1:Hide
    Gui 2:Destroy
    Gui 2:Default

    KeyOptions := KeyPresserList  ; Global variable including "enter" and "ctrl+v"
    Gui 2:Add, Text, x20 y20 w200 h20, Press F8 to start/stop key presses:

    ; --- KEY 1 ---
    Gui 2:Add, Text, x20 y40 w100 h20, Key 1:
    Gui 2:Add, DropDownList, vKP_KeyChoice1 x120 y40 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y70 w100 h20, Delay 1 (ms):
    Gui 2:Add, Edit, vKP_DelayInput1 x120 y70 w100 h20, %DefaultDelay1%
    Gui 2:Add, Text, x20 y100 w100 h20, Hold Time 1 (ms):
    Gui 2:Add, Edit, vKP_HoldTime1 x120 y100 w100 h20, %DefaultHold1%
    Gui 2:Add, Text, x20 y130 w100 h20, Max Count 1:
    Gui 2:Add, Edit, vKP_MaxCount1 x120 y130 w100 h20, %DefaultMaxCount1%
    enforceState1 := (DefaultEnforce1 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled1 x230 y130 w120 h20 %enforceState1%, Enforce
    Gui 2:Add, Button, vKP_Button1 gKP_ToggleKey1 x120 y160 w100 h20, % (KeyEnabled1 ? "Enabled" : "Disabled")

    ; --- KEY 2 ---
    Gui 2:Add, Text, x20 y200 w100 h20, Key 2:
    Gui 2:Add, DropDownList, vKP_KeyChoice2 x120 y200 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y230 w100 h20, Delay 2 (ms):
    Gui 2:Add, Edit, vKP_DelayInput2 x120 y230 w100 h20, %DefaultDelay2%
    Gui 2:Add, Text, x20 y260 w100 h20, Hold Time 2 (ms):
    Gui 2:Add, Edit, vKP_HoldTime2 x120 y260 w100 h20, %DefaultHold2%
    Gui 2:Add, Text, x20 y290 w100 h20, Max Count 2:
    Gui 2:Add, Edit, vKP_MaxCount2 x120 y290 w100 h20, %DefaultMaxCount2%
    enforceState2 := (DefaultEnforce2 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled2 x230 y290 w120 h20 %enforceState2%, Enforce
    Gui 2:Add, Button, vKP_Button2 gKP_ToggleKey2 x120 y320 w100 h20, % (KeyEnabled2 ? "Enabled" : "Disabled")

    ; --- KEY 3 ---
    Gui 2:Add, Text, x20 y360 w100 h20, Key 3:
    Gui 2:Add, DropDownList, vKP_KeyChoice3 x120 y360 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y390 w100 h20, Delay 3 (ms):
    Gui 2:Add, Edit, vKP_DelayInput3 x120 y390 w100 h20, %DefaultDelay3%
    Gui 2:Add, Text, x20 y420 w100 h20, Hold Time 3 (ms):
    Gui 2:Add, Edit, vKP_HoldTime3 x120 y420 w100 h20, %DefaultHold3%
    Gui 2:Add, Text, x20 y450 w100 h20, Max Count 3:
    Gui 2:Add, Edit, vKP_MaxCount3 x120 y450 w100 h20, %DefaultMaxCount3%
    enforceState3 := (DefaultEnforce3 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled3 x230 y450 w120 h20 %enforceState3%, Enforce
    Gui 2:Add, Button, vKP_Button3 gKP_ToggleKey3 x120 y480 w100 h20, % (KeyEnabled3 ? "Enabled" : "Disabled")

    ; --- KEY 4 ---
    Gui 2:Add, Text, x20 y520 w100 h20, Key 4:
    Gui 2:Add, DropDownList, vKP_KeyChoice4 x120 y520 w100, %KeyOptions%
    Gui 2:Add, Text, x20 y550 w100 h20, Delay 4 (ms):
    Gui 2:Add, Edit, vKP_DelayInput4 x120 y550 w100 h20, %DefaultDelay4%
    Gui 2:Add, Text, x20 y580 w100 h20, Hold Time 4 (ms):
    Gui 2:Add, Edit, vKP_HoldTime4 x120 y580 w100 h20, %DefaultHold4%
    Gui 2:Add, Text, x20 y610 w100 h20, Max Count 4:
    Gui 2:Add, Edit, vKP_MaxCount4 x120 y610 w100 h20, %DefaultMaxCount4%
    enforceState4 := (DefaultEnforce4 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled4 x230 y610 w120 h20 %enforceState4%, Enforce
    Gui 2:Add, Button, vKP_Button4 gKP_ToggleKey4 x120 y640 w100 h20, % (KeyEnabled4 ? "Enabled" : "Disabled")

    ; --- Back Button ---
    Gui 2:Add, Button, gCloseKeyPresser x20 y750 w80 h30, Back

    ; Force the dropdowns to show the stored values:
    GuiControl, ChooseString, KP_KeyChoice1, %DefaultKey1%
    GuiControl, ChooseString, KP_KeyChoice2, %DefaultKey2%
    GuiControl, ChooseString, KP_KeyChoice3, %DefaultKey3%
    GuiControl, ChooseString, KP_KeyChoice4, %DefaultKey4%

    Gui 2:Show, w370 h800, Key Press Automation
    Hotkey, F8, KP_Toggle, On
Return

CloseKeyPresser:
    Gui 2:Submit, NoHide

    ; Save current Key Presser settings from the GUI controls:
    DefaultKey1 := KP_KeyChoice1
    DefaultDelay1 := KP_DelayInput1
    DefaultHold1  := KP_HoldTime1
    DefaultMaxCount1 := KP_MaxCount1

    DefaultKey2 := KP_KeyChoice2
    DefaultDelay2 := KP_DelayInput2
    DefaultHold2  := KP_HoldTime2
    DefaultMaxCount2 := KP_MaxCount2

    DefaultKey3 := KP_KeyChoice3
    DefaultDelay3 := KP_DelayInput3
    DefaultHold3  := KP_HoldTime3
    DefaultMaxCount3 := KP_MaxCount3

    DefaultKey4 := KP_KeyChoice4
    DefaultDelay4 := KP_DelayInput4
    DefaultHold4  := KP_HoldTime4
    DefaultMaxCount4 := KP_MaxCount4

    DefaultEnabled1 := KeyEnabled1
    DefaultEnabled2 := KeyEnabled2
    DefaultEnabled3 := KeyEnabled3
    DefaultEnabled4 := KeyEnabled4

    GuiControlGet, DefaultEnforce1, 2:, KP_MaxCountEnabled1
    GuiControlGet, DefaultEnforce2, 2:, KP_MaxCountEnabled2
    GuiControlGet, DefaultEnforce3, 2:, KP_MaxCountEnabled3
    GuiControlGet, DefaultEnforce4, 2:, KP_MaxCountEnabled4

    SaveSettings()
    if (KP_Running) {
        KP_StopAutomation()
    }
    Hotkey, F8, Off
    Gui 2:Destroy
    Gui 1:Show
    UpdateStatusBox()
Return


; F8 toggles Key Presser automation
KP_Toggle:
    global KP_Running, KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    if (KeyEnabled1 = 0 and KeyEnabled2 = 0 and KeyEnabled3 = 0 and KeyEnabled4 = 0) {
         GuiControl, 2:, KP_Status, All Keys Disabled
         return
    }
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
    global KP_Running
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

; Timer routines – note: removed repeat-check logic.
KP_KeyPress1:
    global KP_Running, KeyEnabled1
    if (!KP_Running or KeyEnabled1 = 0) {
         SetTimer, KP_KeyPress1, Off
         Return
    }
    KP_SendKey(1)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled1
    if (enforce = 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount1
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount1, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress1, Off
              KeyEnabled1 := 0
              GuiControl, 2:, KP_Button1, Disabled
         }
    }
    KP_CheckAutoStop()
Return

KP_KeyPress2:
    global KP_Running, KeyEnabled2
    if (!KP_Running or KeyEnabled2 = 0) {
         SetTimer, KP_KeyPress2, Off
         Return
    }
    KP_SendKey(2)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled2
    if (enforce = 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount2
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount2, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress2, Off
              KeyEnabled2 := 0
              GuiControl, 2:, KP_Button2, Disabled
         }
    }
    KP_CheckAutoStop()
Return

KP_KeyPress3:
    global KP_Running, KeyEnabled3
    if (!KP_Running or KeyEnabled3 = 0) {
         SetTimer, KP_KeyPress3, Off
         Return
    }
    KP_SendKey(3)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled3
    if (enforce = 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount3
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount3, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress3, Off
              KeyEnabled3 := 0
              GuiControl, 2:, KP_Button3, Disabled
         }
    }
    KP_CheckAutoStop()
Return

KP_KeyPress4:
    global KP_Running, KeyEnabled4
    if (!KP_Running or KeyEnabled4 = 0) {
         SetTimer, KP_KeyPress4, Off
         Return
    }
    KP_SendKey(4)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled4
    if (enforce = 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount4
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount4, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress4, Off
              KeyEnabled4 := 0
              GuiControl, 2:, KP_Button4, Disabled
         }
    }
    KP_CheckAutoStop()
Return

; -------------------------------------------------------------------
; KP_SendKey: Sends the key press, with special handling for "ctrl+v"
; -------------------------------------------------------------------
KP_SendKey(n) {
    GuiControlGet, curKey, 2:, KP_KeyChoice%n%
    curKey := Trim(curKey)
    if (curKey != "") {
        StringLower, lcKey, curKey
        ; Special handling for "ctrl+v" to simulate paste:
        if (lcKey = "ctrl+v") {
            SendInput, {Ctrl down}
            Sleep, 50
            SendInput, v
            Sleep, 50
            SendInput, {Ctrl up}
            return
        }
        curKey := ConvertKey(curKey)
        GuiControlGet, holdTime, 2:, KP_HoldTime%n%
        SendInput, {%curKey% down}
        Sleep, %holdTime%
        SendInput, {%curKey% up}
    }
}

GuiControlGetDelay(n) {
    GuiControlGet, out, 2:, KP_DelayInput%n%
    return out
}

KP_CheckAutoStop() {
    global KP_Running, KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    hasNonEnforcedActive := false, enforcedCount := 0, enforcedDoneCount := 0
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

; -------------------------------------------------------------------
; ToggleKey and its labels for Key Presser
; -------------------------------------------------------------------
ToggleKey(n) {
    global KP_Running, KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    currentState := (n = 1 ? KeyEnabled1
                  : n = 2 ? KeyEnabled2
                  : n = 3 ? KeyEnabled3
                          : KeyEnabled4)
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

; -------------------------------------------------------------------
; Universal Close
; -------------------------------------------------------------------
GuiClose:
1GuiClose:
2GuiClose:
3GuiClose:
4GuiClose:
    SaveSettings()
    ExitApp
