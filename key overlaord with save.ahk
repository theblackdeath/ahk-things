#NoEnv
#SingleInstance Force

; -------------------------------------------------------------------
; Global Lists for Dropdowns (using pipe-delimited strings)
; -------------------------------------------------------------------
global EnterCommandsKeyList := "grave|one|two|three|four|five|six|seven|eight|nine|zero|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|enter|tab|space|shift|ctrl|alt|esc|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|up|down|left|right|home|end|pgup|pgdn|insert|delete|backspace|capslock|numlock|scrolllock|printscreen|pause|appskey|browser_back|browser_forward|browser_refresh|browser_stop|browser_search|browser_favorites|browser_home|volume_mute|volume_down|volume_up|media_next|media_prev|media_stop|media_play_pause|launch_mail|launch_media|launch_app1|launch_app2"
global EnterCommandsTriggerList := "F8|F1|F2|F3|F4|F5|F6|F7|F9|F10|F11|F12"
global KeyHolderList := "up|down|left|right|space|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|lbutton|rbutton|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|0|1|2|3|4|5|6|7|8|9"
global KeyPresserList := "|up|down|left|right|f1|f2|f3|f4|f5|f6|f7|f8|f9|f10|f11|f12|lbutton|rbutton|space|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|one|two|three|four|five|six|seven|eight|nine|zero|enter|ctrl+v"
global KP_TriggerKeyList := "F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12"

; Default trigger keys for Key Presser (per-key)
global DefaultKPTriggerKey1 := "F8"
global DefaultKPTriggerKey2 := "F9"
global DefaultKPTriggerKey3 := "F10"
global DefaultKPTriggerKey4 := "F11"

; Global running flags for each Key Presser key (for independent timers)
global KP_Running1 := false
global KP_Running2 := false
global KP_Running3 := false
global KP_Running4 := false

; Global variable to track previous trigger keys for Enter Commands mode
Prev_TriggerKey1 := ""
Prev_TriggerKey2 := ""
Prev_TriggerKey3 := ""

; --- New: Enter Commands Loop & Used flags and state flags ---
; (For each sequence, we add variables for: Loop (checkbox), Delay (ms), Used for FirstKey, Text and SecondKey.)
; Also, state flags (EC_Running1, EC_Running2, EC_Running3) to track if the sequence is looping.
global EC_Running1 := false
global EC_Running2 := false
global EC_Running3 := false

; -------------------------------------------------------------------
; Helper: ConvertKey - converts word digits to numeric keys
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
; Helper: makes sure if all key presser loops are done it stops the loop
; -------------------------------------------------------------------
CheckKPStatus() {
    global KP_Running1, KP_Running2, KP_Running3, KP_Running4
    if (!KP_Running1 && !KP_Running2 && !KP_Running3 && !KP_Running4) {
        UpdateStatusBox()
    }
}

; -------------------------------------------------------------------
; Helper: SetExactChoice - manually selects the saved value in a dropdown
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
; INI file and Load/Save functions
; -------------------------------------------------------------------
IniFile := A_ScriptDir "\settings.ini"
LoadSettings()

LoadSettings() {
    global IniFile
    global EC_FirstKey1, EC_InputText1, EC_SecondKey1, EC_TriggerKey1
    global EC_FirstKey2, EC_InputText2, EC_SecondKey2, EC_TriggerKey2
    global EC_FirstKey3, EC_InputText3, EC_SecondKey3, EC_TriggerKey3
    global DefaultKHKey
    global DefaultKey1, DefaultDelay1, DefaultHold1, DefaultMaxCount1, DefaultEnabled1
    global DefaultKey2, DefaultDelay2, DefaultHold2, DefaultMaxCount2, DefaultEnabled2
    global DefaultKey3, DefaultDelay3, DefaultHold3, DefaultMaxCount3, DefaultEnabled3
    global DefaultKey4, DefaultDelay4, DefaultHold4, DefaultMaxCount4, DefaultEnabled4
    global DefaultEnforce1, DefaultEnforce2, DefaultEnforce3, DefaultEnforce4
    global DefaultKPTriggerKey1, DefaultKPTriggerKey2, DefaultKPTriggerKey3, DefaultKPTriggerKey4
    ; --- New: Loop and Used settings for Enter Commands sequences ---
    global Loop1, Delay1, Used1Key1, Used1Text, Used1Key2
    global Loop2, Delay2, Used2Key1, Used2Text, Used2Key2
    global Loop3, Delay3, Used3Key1, Used3Text, Used3Key2

    ; Sequence 1:
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
    ; Sequence 2:
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
    ; Sequence 3:
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

    ; --- New: Loop and Used settings for Enter Commands sequences ---
    ; Sequence 1:
    IniRead, Loop1, %IniFile%, EnterCommands, Loop1, 0
    IniRead, Delay1, %IniFile%, EnterCommands, Delay1, 1000
    IniRead, Used1Key1, %IniFile%, EnterCommands, Used1Key1, 1
    IniRead, Used1Text, %IniFile%, EnterCommands, Used1Text, 1
    IniRead, Used1Key2, %IniFile%, EnterCommands, Used1Key2, 1
    ; Sequence 2:
    IniRead, Loop2, %IniFile%, EnterCommands, Loop2, 0
    IniRead, Delay2, %IniFile%, EnterCommands, Delay2, 1000
    IniRead, Used2Key1, %IniFile%, EnterCommands, Used2Key1, 1
    IniRead, Used2Text, %IniFile%, EnterCommands, Used2Text, 1
    IniRead, Used2Key2, %IniFile%, EnterCommands, Used2Key2, 1
    ; Sequence 3:
    IniRead, Loop3, %IniFile%, EnterCommands, Loop3, 0
    IniRead, Delay3, %IniFile%, EnterCommands, Delay3, 1000
    IniRead, Used3Key1, %IniFile%, EnterCommands, Used3Key1, 1
    IniRead, Used3Text, %IniFile%, EnterCommands, Used3Text, 1
    IniRead, Used3Key2, %IniFile%, EnterCommands, Used3Key2, 1

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
    ; Key 2
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
    ; Key 3
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
    ; Key 4
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
    ; --- Key Presser trigger keys (per-key) ---
    IniRead, DefaultKPTriggerKey1, %IniFile%, KeyPresser, TriggerKey1, F8
    DefaultKPTriggerKey1 := Trim(DefaultKPTriggerKey1)
    if (DefaultKPTriggerKey1 = "")
        DefaultKPTriggerKey1 := "F8"
    IniRead, DefaultKPTriggerKey2, %IniFile%, KeyPresser, TriggerKey2, F9
    DefaultKPTriggerKey2 := Trim(DefaultKPTriggerKey2)
    if (DefaultKPTriggerKey2 = "")
        DefaultKPTriggerKey2 := "F9"
    IniRead, DefaultKPTriggerKey3, %IniFile%, KeyPresser, TriggerKey3, F10
    DefaultKPTriggerKey3 := Trim(DefaultKPTriggerKey3)
    if (DefaultKPTriggerKey3 = "")
        DefaultKPTriggerKey3 := "F10"
    IniRead, DefaultKPTriggerKey4, %IniFile%, KeyPresser, TriggerKey4, F11
    DefaultKPTriggerKey4 := Trim(DefaultKPTriggerKey4)
    if (DefaultKPTriggerKey4 = "")
        DefaultKPTriggerKey4 := "F11"
    global KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    KeyEnabled1 := DefaultEnabled1
    KeyEnabled2 := DefaultEnabled2
    KeyEnabled3 := DefaultEnabled3
    KeyEnabled4 := DefaultEnabled4
}

SaveSettings() {
    global IniFile
    global EC_FirstKey1, EC_InputText1, EC_SecondKey1, EC_TriggerKey1
    global EC_FirstKey2, EC_InputText2, EC_SecondKey2, EC_TriggerKey2
    global EC_FirstKey3, EC_InputText3, EC_SecondKey3, EC_TriggerKey3
    global DefaultKHKey
    global DefaultKey1, DefaultDelay1, DefaultHold1, DefaultMaxCount1, DefaultEnabled1
    global DefaultKey2, DefaultDelay2, DefaultHold2, DefaultMaxCount2, DefaultEnabled2
    global DefaultKey3, DefaultDelay3, DefaultHold3, DefaultMaxCount3, DefaultEnabled3
    global DefaultKey4, DefaultDelay4, DefaultHold4, DefaultMaxCount4, DefaultEnabled4
    global DefaultEnforce1, DefaultEnforce2, DefaultEnforce3, DefaultEnforce4
    global DefaultKPTriggerKey1, DefaultKPTriggerKey2, DefaultKPTriggerKey3, DefaultKPTriggerKey4
    ; --- New: Loop and Used settings for Enter Commands sequences ---
    global Loop1, Delay1, Used1Key1, Used1Text, Used1Key2
    global Loop2, Delay2, Used2Key1, Used2Text, Used2Key2
    global Loop3, Delay3, Used3Key1, Used3Text, Used3Key2

    ; --- Save Enter Commands ---
    IniWrite, %EC_FirstKey1%, %IniFile%, EnterCommands, FirstKey1
    IniWrite, %EC_InputText1%, %IniFile%, EnterCommands, InputText1
    IniWrite, %EC_SecondKey1%, %IniFile%, EnterCommands, SecondKey1
    IniWrite, %EC_TriggerKey1%, %IniFile%, EnterCommands, TriggerKey1
    IniWrite, %EC_FirstKey2%, %IniFile%, EnterCommands, FirstKey2
    IniWrite, %EC_InputText2%, %IniFile%, EnterCommands, InputText2
    IniWrite, %EC_SecondKey2%, %IniFile%, EnterCommands, SecondKey2
    IniWrite, %EC_TriggerKey2%, %IniFile%, EnterCommands, TriggerKey2
    IniWrite, %EC_FirstKey3%, %IniFile%, EnterCommands, FirstKey3
    IniWrite, %EC_InputText3%, %IniFile%, EnterCommands, InputText3
    IniWrite, %EC_SecondKey3%, %IniFile%, EnterCommands, SecondKey3
    IniWrite, %EC_TriggerKey3%, %IniFile%, EnterCommands, TriggerKey3
    ; --- Save new Loop and Used settings for Enter Commands sequences ---
    ; Sequence 1:
    IniWrite, %Loop1%, %IniFile%, EnterCommands, Loop1
    IniWrite, %Delay1%, %IniFile%, EnterCommands, Delay1
    IniWrite, %Used1Key1%, %IniFile%, EnterCommands, Used1Key1
    IniWrite, %Used1Text%, %IniFile%, EnterCommands, Used1Text
    IniWrite, %Used1Key2%, %IniFile%, EnterCommands, Used1Key2
    ; Sequence 2:
    IniWrite, %Loop2%, %IniFile%, EnterCommands, Loop2
    IniWrite, %Delay2%, %IniFile%, EnterCommands, Delay2
    IniWrite, %Used2Key1%, %IniFile%, EnterCommands, Used2Key1
    IniWrite, %Used2Text%, %IniFile%, EnterCommands, Used2Text
    IniWrite, %Used2Key2%, %IniFile%, EnterCommands, Used2Key2
    ; Sequence 3:
    IniWrite, %Loop3%, %IniFile%, EnterCommands, Loop3
    IniWrite, %Delay3%, %IniFile%, EnterCommands, Delay3
    IniWrite, %Used3Key1%, %IniFile%, EnterCommands, Used3Key1
    IniWrite, %Used3Text%, %IniFile%, EnterCommands, Used3Text
    IniWrite, %Used3Key2%, %IniFile%, EnterCommands, Used3Key2
    ; --- Save Key Holder ---
    IniWrite, %DefaultKHKey%, %IniFile%, KeyHolder, KeyChoice
    ; --- Save Key Presser ---
    IniWrite, %DefaultKey1%, %IniFile%, KeyPresser, Key1
    IniWrite, %DefaultDelay1%, %IniFile%, KeyPresser, Delay1
    IniWrite, %DefaultHold1%, %IniFile%, KeyPresser, Hold1
    IniWrite, %DefaultMaxCount1%, %IniFile%, KeyPresser, MaxCount1
    IniWrite, %DefaultEnabled1%, %IniFile%, KeyPresser, Enabled1
    IniWrite, %DefaultKey2%, %IniFile%, KeyPresser, Key2
    IniWrite, %DefaultDelay2%, %IniFile%, KeyPresser, Delay2
    IniWrite, %DefaultHold2%, %IniFile%, KeyPresser, Hold2
    IniWrite, %DefaultMaxCount2%, %IniFile%, KeyPresser, MaxCount2
    IniWrite, %DefaultEnabled2%, %IniFile%, KeyPresser, Enabled2
    IniWrite, %DefaultKey3%, %IniFile%, KeyPresser, Key3
    IniWrite, %DefaultDelay3%, %IniFile%, KeyPresser, Delay3
    IniWrite, %DefaultHold3%, %IniFile%, KeyPresser, Hold3
    IniWrite, %DefaultMaxCount3%, %IniFile%, KeyPresser, MaxCount3
    IniWrite, %DefaultEnabled3%, %IniFile%, KeyPresser, Enabled3
    IniWrite, %DefaultKey4%, %IniFile%, KeyPresser, Key4
    IniWrite, %DefaultDelay4%, %IniFile%, KeyPresser, Delay4
    IniWrite, %DefaultHold4%, %IniFile%, KeyPresser, Hold4
    IniWrite, %DefaultMaxCount4%, %IniFile%, KeyPresser, MaxCount4
    IniWrite, %DefaultEnabled4%, %IniFile%, KeyPresser, Enabled4
    ; Enforce checkboxes
    IniWrite, %DefaultEnforce1%, %IniFile%, KeyPresser, Enforce1
    IniWrite, %DefaultEnforce2%, %IniFile%, KeyPresser, Enforce2
    IniWrite, %DefaultEnforce3%, %IniFile%, KeyPresser, Enforce3
    IniWrite, %DefaultEnforce4%, %IniFile%, KeyPresser, Enforce4
    ; --- Save Key Presser Trigger Keys (per-key) ---
    IniWrite, %DefaultKPTriggerKey1%, %IniFile%, KeyPresser, TriggerKey1
    IniWrite, %DefaultKPTriggerKey2%, %IniFile%, KeyPresser, TriggerKey2
    IniWrite, %DefaultKPTriggerKey3%, %IniFile%, KeyPresser, TriggerKey3
    IniWrite, %DefaultKPTriggerKey4%, %IniFile%, KeyPresser, TriggerKey4
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
    global KH_Running, KP_Running1, KP_Running2, KP_Running3, KP_Running4, EC_Running1, EC_Running2, EC_Running3
    if (KH_Running || KP_Running1 || KP_Running2 || KP_Running3 || KP_Running4 || EC_Running1 || EC_Running2 || EC_Running3)
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

    ; Create local "checked" variables for each checkbox:
    checked1Key1 := (Used1Key1 = 1 ? "Checked" : "")
    checked1Text := (Used1Text = 1 ? "Checked" : "")
    checked1Key2 := (Used1Key2 = 1 ? "Checked" : "")
    checkedLoop1 := (Loop1 = 1 ? "Checked" : "")

    checked2Key1 := (Used2Key1 = 1 ? "Checked" : "")
    checked2Text := (Used2Text = 1 ? "Checked" : "")
    checked2Key2 := (Used2Key2 = 1 ? "Checked" : "")
    checkedLoop2 := (Loop2 = 1 ? "Checked" : "")

    checked3Key1 := (Used3Key1 = 1 ? "Checked" : "")
    checked3Text := (Used3Text = 1 ? "Checked" : "")
    checked3Key2 := (Used3Key2 = 1 ? "Checked" : "")
    checkedLoop3 := (Loop3 = 1 ? "Checked" : "")

    ; --- FIRST SEQUENCE ---
    Gui 4:Add, Text, x20 y20 w200 h20, **First Sequence**
    Gui 4:Add, Text, x20 y50 w120 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey1 x150 y50 w200, %EnterCommandsKeyList%
    Gui 4:Add, CheckBox, vUsed1Key1 x360 y50 w50 h20 %checked1Key1%, Used

    Gui 4:Add, Text, x20 y80 w120 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText1 x150 y80 w200 h20, %EC_InputText1%
    Gui 4:Add, CheckBox, vUsed1Text x360 y80 w50 h20 %checked1Text%, Used

    Gui 4:Add, Text, x20 y110 w120 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey1 x150 y110 w200, %EnterCommandsKeyList%
    Gui 4:Add, CheckBox, vUsed1Key2 x360 y110 w50 h20 %checked1Key2%, Used

    Gui 4:Add, Text, x20 y140 w120 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey1 x150 y140 w200, %EnterCommandsTriggerList%

    Gui 4:Add, CheckBox, vLoop1 x370 y140 w60 h20 %checkedLoop1%, Loop
    Gui 4:Add, Text, x430 y140 w60 h20, Delay (ms):
    Gui 4:Add, Edit, vDelay1 x500 y140 w60 h20, %Delay1%

    ; --- SECOND SEQUENCE ---
    Gui 4:Add, Text, x20 y180 w200 h20, **Second Sequence**
    Gui 4:Add, Text, x20 y210 w120 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey2 x150 y210 w200, %EnterCommandsKeyList%
    Gui 4:Add, CheckBox, vUsed2Key1 x360 y210 w50 h20 %checked2Key1%, Used

    Gui 4:Add, Text, x20 y240 w120 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText2 x150 y240 w200 h20, %EC_InputText2%
    Gui 4:Add, CheckBox, vUsed2Text x360 y240 w50 h20 %checked2Text%, Used

    Gui 4:Add, Text, x20 y270 w120 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey2 x150 y270 w200 h20, %EnterCommandsKeyList%
    Gui 4:Add, CheckBox, vUsed2Key2 x360 y270 w50 h20 %checked2Key2%, Used

    Gui 4:Add, Text, x20 y300 w120 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey2 x150 y300 w200 h20, %EnterCommandsTriggerList%

    Gui 4:Add, CheckBox, vLoop2 x370 y300 w60 h20 %checkedLoop2%, Loop
    Gui 4:Add, Text, x430 y300 w60 h20, Delay (ms):
    Gui 4:Add, Edit, vDelay2 x500 y300 w60 h20, %Delay2%

    ; --- THIRD SEQUENCE ---
    Gui 4:Add, Text, x20 y340 w200 h20, **Third Sequence**
    Gui 4:Add, Text, x20 y370 w120 h20, Select First Key:
    Gui 4:Add, DropDownList, vEC_FirstKey3 x150 y370 w200 h20, %EnterCommandsKeyList%
    Gui 4:Add, CheckBox, vUsed3Key1 x360 y370 w50 h20 %checked3Key1%, Used

    Gui 4:Add, Text, x20 y400 w120 h20, Enter Text to Type:
    Gui 4:Add, Edit, vEC_InputText3 x150 y400 w200 h20, %EC_InputText3%
    Gui 4:Add, CheckBox, vUsed3Text x360 y400 w50 h20 %checked3Text%, Used

    Gui 4:Add, Text, x20 y430 w120 h20, Select Second Key:
    Gui 4:Add, DropDownList, vEC_SecondKey3 x150 y430 w200 h20, %EnterCommandsKeyList%
    Gui 4:Add, CheckBox, vUsed3Key2 x360 y430 w50 h20 %checked3Key2%, Used

    Gui 4:Add, Text, x20 y460 w120 h20, Select Trigger Key:
    Gui 4:Add, DropDownList, vEC_TriggerKey3 x150 y460 w200 h20, %EnterCommandsTriggerList%

    Gui 4:Add, CheckBox, vLoop3 x370 y460 w60 h20 %checkedLoop3%, Loop
    Gui 4:Add, Text, x430 y460 w60 h20, Delay (ms):
    Gui 4:Add, Edit, vDelay3 x500 y460 w60 h20, %Delay3%

    ; Buttons (placed below the sequences)
    Gui 4:Add, Button, x20 y520 w120 h30 gActivateEnterCmds, Activate
    Gui 4:Add, Button, x160 y520 w80  h30 gCloseEnter,       Back

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

    Gui 4:Show, w600 h580, Enter Commands Automation
Return


ActivateEnterCmds:
{
    Gui 4:Submit, NoHide
    SaveSettings()
    ; Unregister previous hotkeys for Enter Commands mode
    if (Prev_TriggerKey1 != "")
        Hotkey, *%Prev_TriggerKey1%, Off
    Prev_TriggerKey1 := EC_TriggerKey1
    if (Prev_TriggerKey2 != "")
        Hotkey, *%Prev_TriggerKey2%, Off
    Prev_TriggerKey2 := EC_TriggerKey2
    if (Prev_TriggerKey3 != "")
        Hotkey, *%Prev_TriggerKey3%, Off
    Prev_TriggerKey3 := EC_TriggerKey3
    ; Register new hotkeys – these now call our updated EC_Sequence# routines
    if (EC_TriggerKey1 != "" && EC_TriggerKey1 != "grave")
        Hotkey, *%EC_TriggerKey1%, EC_Sequence1, On
    if (EC_TriggerKey2 != "" && EC_TriggerKey2 != "grave")
        Hotkey, *%EC_TriggerKey2%, EC_Sequence2, On
    if (EC_TriggerKey3 != "" && EC_TriggerKey3 != "grave")
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

; --- Updated Enter Commands hotkey routines with looping logic ---
EC_Sequence1:
{
    Gui 4:Submit, NoHide
    SaveSettings()
    if (Loop1) {
         if (!EC_Running1) {
              EC_Running1 := true
              ; Run one iteration immediately
              Gosub, DoEC_Sequence1
              delayVal := Delay1 ? Delay1 : 0
              SetTimer, EC_Loop1, % delayVal
         } else {
              EC_Running1 := false
              SetTimer, EC_Loop1, Off
         }
         UpdateStatusBox()
    } else {
         Gosub, DoEC_Sequence1
    }
}
Return

EC_Loop1:
    if (!EC_Running1) {
         SetTimer, EC_Loop1, Off
         return
    }
    Gosub, DoEC_Sequence1
Return

EC_Sequence2:
{
    Gui 4:Submit, NoHide
    SaveSettings()
    if (Loop2) {
         if (!EC_Running2) {
              EC_Running2 := true
              Gosub, DoEC_Sequence2
              delayVal := Delay2 ? Delay2 : 0
              SetTimer, EC_Loop2, % delayVal
         } else {
              EC_Running2 := false
              SetTimer, EC_Loop2, Off
         }
         UpdateStatusBox()
    } else {
         Gosub, DoEC_Sequence2
    }
}
Return

EC_Loop2:
    if (!EC_Running2) {
         SetTimer, EC_Loop2, Off
         return
    }
    Gosub, DoEC_Sequence2
Return

EC_Sequence3:
{
    Gui 4:Submit, NoHide
    SaveSettings()
    if (Loop3) {
         if (!EC_Running3) {
              EC_Running3 := true
              Gosub, DoEC_Sequence3
              delayVal := Delay3 ? Delay3 : 0
              SetTimer, EC_Loop3, % delayVal
         } else {
              EC_Running3 := false
              SetTimer, EC_Loop3, Off
         }
         UpdateStatusBox()
    } else {
         Gosub, DoEC_Sequence3
    }
}
Return

EC_Loop3:
    if (!EC_Running3) {
         SetTimer, EC_Loop3, Off
         return
    }
    Gosub, DoEC_Sequence3
Return

; --- New subroutines to execute each sequence, checking “Used” flags ---
DoEC_Sequence1:
{
    if (Used1Key1) {
         if (EC_FirstKey1 = "grave")
             key1 := "SC029"
         else
             key1 := ConvertKey(EC_FirstKey1)
         Send, {%key1% down}
         Sleep, 50
         Send, {%key1% up}
         Sleep, 150
    }
    if (Used1Text) {
         SendInput, %EC_InputText1%
         Sleep, 150
    }
    if (Used1Key2) {
         if (EC_SecondKey1 = "grave")
             key2 := "SC029"
         else
             key2 := ConvertKey(EC_SecondKey1)
         Send, {%key2% down}
         Sleep, 50
         Send, {%key2% up}
    }
    Return
}

DoEC_Sequence2:
{
    if (Used2Key1) {
         if (EC_FirstKey2 = "grave")
             key1 := "SC029"
         else
             key1 := ConvertKey(EC_FirstKey2)
         Send, {%key1% down}
         Sleep, 50
         Send, {%key1% up}
         Sleep, 150
    }
    if (Used2Text) {
         SendInput, %EC_InputText2%
         Sleep, 150
    }
    if (Used2Key2) {
         if (EC_SecondKey2 = "grave")
             key2 := "SC029"
         else
             key2 := ConvertKey(EC_SecondKey2)
         Send, {%key2% down}
         Sleep, 50
         Send, {%key2% up}
    }
    Return
}

DoEC_Sequence3:
{
    if (Used3Key1) {
         if (EC_FirstKey3 = "grave")
             key1 := "SC029"
         else
             key1 := ConvertKey(EC_FirstKey3)
         Send, {%key1% down}
         Sleep, 50
         Send, {%key1% up}
         Sleep, 150
    }
    if (Used3Text) {
         SendInput, %EC_InputText3%
         Sleep, 150
    }
    if (Used3Key2) {
         if (EC_SecondKey3 = "grave")
             key2 := "SC029"
         else
             key2 := ConvertKey(EC_SecondKey3)
         Send, {%key2% down}
         Sleep, 50
         Send, {%key2% up}
    }
    Return
}

; -------------------------------------------------------------------
; MODE 2: KEY HOLDER (#3)
; -------------------------------------------------------------------
OpenKeyHolder:
    Gui 1:Hide
    Gui 3:Destroy
    Gui 3:Default
    KH_Running := false

    Gui 3:Add, Text, x20 y20 w200 h20, Select Key to Hold Down: F8 Toggles
    Gui 3:Add, DropDownList, vKH_KeyChoice x20 y50 w140, %KeyHolderList%
    Gui 3:Add, Button, x170 y50 w60 h20 gKH_Reset, Reset
    Gui 3:Add, Text, vKH_Status x20 y90 w200 h30, Stopped
    Gui 3:Add, Button, x20 y140 w100 h30 gCloseKeyHolder, Back

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
; MODE 3: KEY PRESSER (with per-key trigger dropdowns and behavior)
; -------------------------------------------------------------------
OpenKeyPresser:
    Gui 1:Hide
    Gui 2:Destroy
    Gui 2:Default

    ; --- KEY 1 Block ---
    Gui 2:Add, Text, x20 y20 w100 h20, Trigger Key 1:
    Gui 2:Add, DropDownList, vKP_TriggerKey1 x120 y20 w100, %KP_TriggerKeyList%
    Gui 2:Add, Text, x20 y50 w100 h20, Key 1:
    Gui 2:Add, DropDownList, vKP_KeyChoice1 x120 y50 w100, %KeyPresserList%
    Gui 2:Add, Text, x20 y80 w100 h20, Delay 1 (ms):
    Gui 2:Add, Edit, vKP_DelayInput1 x120 y80 w100 h20, %DefaultDelay1%
    Gui 2:Add, Text, x20 y110 w100 h20, Hold Time 1 (ms):
    Gui 2:Add, Edit, vKP_HoldTime1 x120 y110 w100 h20, %DefaultHold1%
    Gui 2:Add, Text, x20 y140 w100 h20, Max Count 1:
    Gui 2:Add, Edit, vKP_MaxCount1 x120 y140 w100 h20, %DefaultMaxCount1%
    enforceState1 := (DefaultEnforce1 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled1 x230 y140 w120 h20 %enforceState1%, Enforce
    Gui 2:Add, Button, vKP_Button1 gKP_ToggleKey1 x120 y170 w100 h20, % (KeyEnabled1 ? "Enabled" : "Disabled")
    Gui 2:Add, Text, x20 y195 w400 h10,  ; break line

    ; --- KEY 2 Block ---
    Gui 2:Add, Text, x20 y210 w100 h20, Trigger Key 2:
    Gui 2:Add, DropDownList, vKP_TriggerKey2 x120 y210 w100, %KP_TriggerKeyList%
    Gui 2:Add, Text, x20 y240 w100 h20, Key 2:
    Gui 2:Add, DropDownList, vKP_KeyChoice2 x120 y240 w100, %KeyPresserList%
    Gui 2:Add, Text, x20 y270 w100 h20, Delay 2 (ms):
    Gui 2:Add, Edit, vKP_DelayInput2 x120 y270 w100 h20, %DefaultDelay2%
    Gui 2:Add, Text, x20 y300 w100 h20, Hold Time 2 (ms):
    Gui 2:Add, Edit, vKP_HoldTime2 x120 y300 w100 h20, %DefaultHold2%
    Gui 2:Add, Text, x20 y330 w100 h20, Max Count 2:
    Gui 2:Add, Edit, vKP_MaxCount2 x120 y330 w100 h20, %DefaultMaxCount2%
    enforceState2 := (DefaultEnforce2 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled2 x230 y330 w120 h20 %enforceState2%, Enforce
    Gui 2:Add, Button, vKP_Button2 gKP_ToggleKey2 x120 y360 w100 h20, % (KeyEnabled2 ? "Enabled" : "Disabled")
    Gui 2:Add, Text, x20 y385 w400 h10,  ; break line

    ; --- KEY 3 Block ---
    Gui 2:Add, Text, x20 y400 w100 h20, Trigger Key 3:
    Gui 2:Add, DropDownList, vKP_TriggerKey3 x120 y400 w100, %KP_TriggerKeyList%
    Gui 2:Add, Text, x20 y430 w100 h20, Key 3:
    Gui 2:Add, DropDownList, vKP_KeyChoice3 x120 y430 w100, %KeyPresserList%
    Gui 2:Add, Text, x20 y460 w100 h20, Delay 3 (ms):
    Gui 2:Add, Edit, vKP_DelayInput3 x120 y460 w100 h20, %DefaultDelay3%
    Gui 2:Add, Text, x20 y490 w100 h20, Hold Time 3 (ms):
    Gui 2:Add, Edit, vKP_HoldTime3 x120 y490 w100 h20, %DefaultHold3%
    Gui 2:Add, Text, x20 y520 w100 h20, Max Count 3:
    Gui 2:Add, Edit, vKP_MaxCount3 x120 y520 w100 h20, %DefaultMaxCount3%
    enforceState3 := (DefaultEnforce3 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled3 x230 y520 w120 h20 %enforceState3%, Enforce
    Gui 2:Add, Button, vKP_Button3 gKP_ToggleKey3 x120 y550 w100 h20, % (KeyEnabled3 ? "Enabled" : "Disabled")
    Gui 2:Add, Text, x20 y575 w400 h10,  ; break line

    ; --- KEY 4 Block ---
    Gui 2:Add, Text, x20 y590 w100 h20, Trigger Key 4:
    Gui 2:Add, DropDownList, vKP_TriggerKey4 x120 y590 w100, %KP_TriggerKeyList%
    Gui 2:Add, Text, x20 y620 w100 h20, Key 4:
    Gui 2:Add, DropDownList, vKP_KeyChoice4 x120 y620 w100, %KeyPresserList%
    Gui 2:Add, Text, x20 y650 w100 h20, Delay 4 (ms):
    Gui 2:Add, Edit, vKP_DelayInput4 x120 y650 w100 h20, %DefaultDelay4%
    Gui 2:Add, Text, x20 y680 w100 h20, Hold Time 4 (ms):
    Gui 2:Add, Edit, vKP_HoldTime4 x120 y680 w100 h20, %DefaultHold4%
    Gui 2:Add, Text, x20 y710 w100 h20, Max Count 4:
    Gui 2:Add, Edit, vKP_MaxCount4 x120 y710 w100 h20, %DefaultMaxCount4%
    enforceState4 := (DefaultEnforce4 = 1 ? "Checked" : "")
    Gui 2:Add, CheckBox, vKP_MaxCountEnabled4 x230 y710 w120 h20 %enforceState4%, Enforce
    Gui 2:Add, Button, vKP_Button4 gKP_ToggleKey4 x120 y740 w100 h20, % (KeyEnabled4 ? "Enabled" : "Disabled")
    Gui 2:Add, Text, x20 y765 w400 h10,  ; break line
	; --- Activate All Button (moved to bottom) ---
	Gui 2:Add, Button, x20 y770 w160 h30 gUpdateKPTriggerKeys, Activate All Trigger Keys

    ; --- Back Button (moved to bottom) ---
    Gui 2:Add, Button, gCloseKeyPresser x20 y800 w80 h30, Back

    ; --- Force stored values into controls ---
    GuiControl, ChooseString, KP_KeyChoice1, %DefaultKey1%
    GuiControl, ChooseString, KP_KeyChoice2, %DefaultKey2%
    GuiControl, ChooseString, KP_KeyChoice3, %DefaultKey3%
    GuiControl, ChooseString, KP_KeyChoice4, %DefaultKey4%
    GuiControl, ChooseString, KP_TriggerKey1, %DefaultKPTriggerKey1%
    GuiControl, ChooseString, KP_TriggerKey2, %DefaultKPTriggerKey2%
    GuiControl, ChooseString, KP_TriggerKey3, %DefaultKPTriggerKey3%
    GuiControl, ChooseString, KP_TriggerKey4, %DefaultKPTriggerKey4%

    ; --- Register hotkeys for each trigger key ---
    Hotkey, %DefaultKPTriggerKey1%, KP_ToggleByTrigger, On
    Hotkey, %DefaultKPTriggerKey2%, KP_ToggleByTrigger, On
    Hotkey, %DefaultKPTriggerKey3%, KP_ToggleByTrigger, On
    Hotkey, %DefaultKPTriggerKey4%, KP_ToggleByTrigger, On

    Gui 2:Show, w500 h850, Key Press Automation
Return

UpdateKPTriggerKeys:
    Gui 2:Submit, NoHide
    ; Unregister previous hotkeys
    Hotkey, %DefaultKPTriggerKey1%, Off
    Hotkey, %DefaultKPTriggerKey2%, Off
    Hotkey, %DefaultKPTriggerKey3%, Off
    Hotkey, %DefaultKPTriggerKey4%, Off
    ; Get new trigger key values from the GUI
    GuiControlGet, newKey1,, KP_TriggerKey1
    GuiControlGet, newKey2,, KP_TriggerKey2
    GuiControlGet, newKey3,, KP_TriggerKey3
    GuiControlGet, newKey4,, KP_TriggerKey4
    DefaultKPTriggerKey1 := newKey1
    DefaultKPTriggerKey2 := newKey2
    DefaultKPTriggerKey3 := newKey3
    DefaultKPTriggerKey4 := newKey4
    ; Register new hotkeys
    Hotkey, %DefaultKPTriggerKey1%, KP_ToggleByTrigger, On
    Hotkey, %DefaultKPTriggerKey2%, KP_ToggleByTrigger, On
    Hotkey, %DefaultKPTriggerKey3%, KP_ToggleByTrigger, On
    Hotkey, %DefaultKPTriggerKey4%, KP_ToggleByTrigger, On
Return



; -----------------------------------------------------------
; Trigger Hotkey Handler: Starts/stops key automation (toggle behavior)
KP_ToggleByTrigger:
    trigger := A_ThisHotkey
    if (trigger == DefaultKPTriggerKey1)
         KP_TriggerKey(1)
    if (trigger == DefaultKPTriggerKey2)
         KP_TriggerKey(2)
    if (trigger == DefaultKPTriggerKey3)
         KP_TriggerKey(3)
    if (trigger == DefaultKPTriggerKey4)
         KP_TriggerKey(4)
Return

; New function: Toggle key automation for a given key if already running, or start if not running.
KP_TriggerKey(n) {
    global KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    if (n == 1) {
         if (KP_Running1) {
              SetTimer, KP_KeyPress1, Off
              KP_Running1 := false
         } else if (KeyEnabled1) {
              delayVal := GuiControlGetDelay(1)
              KP_Running1 := true
              SetTimer, KP_KeyPress1, % delayVal
         }
    } else if (n == 2) {
         if (KP_Running2) {
              SetTimer, KP_KeyPress2, Off
              KP_Running2 := false
         } else if (KeyEnabled2) {
              delayVal := GuiControlGetDelay(2)
              KP_Running2 := true
              SetTimer, KP_KeyPress2, % delayVal
         }
    } else if (n == 3) {
         if (KP_Running3) {
              SetTimer, KP_KeyPress3, Off
              KP_Running3 := false
         } else if (KeyEnabled3) {
              delayVal := GuiControlGetDelay(3)
              KP_Running3 := true
              SetTimer, KP_KeyPress3, % delayVal
         }
    } else if (n == 4) {
         if (KP_Running4) {
              SetTimer, KP_KeyPress4, Off
              KP_Running4 := false
         } else if (KeyEnabled4) {
              delayVal := GuiControlGetDelay(4)
              KP_Running4 := true
              SetTimer, KP_KeyPress4, % delayVal
         }
    }
    UpdateStatusBox()
}

; -----------------------------------------------------------
; ToggleKey and its labels for Key Presser (manual enable/disable via buttons)
ToggleKey(n) {
    global KeyEnabled1, KeyEnabled2, KeyEnabled3, KeyEnabled4
    currentState := (n == 1 ? KeyEnabled1
                   : n == 2 ? KeyEnabled2
                   : n == 3 ? KeyEnabled3
                            : KeyEnabled4)
    if (currentState == 1) {
        newState := 0
        newText := "Disabled"
        ; If the loop is currently running, stop it.
        if (n == 1 && KP_Running1) {
            SetTimer, KP_KeyPress1, Off
            KP_Running1 := false
        } else if (n == 2 && KP_Running2) {
            SetTimer, KP_KeyPress2, Off
            KP_Running2 := false
        } else if (n == 3 && KP_Running3) {
            SetTimer, KP_KeyPress3, Off
            KP_Running3 := false
        } else if (n == 4 && KP_Running4) {
            SetTimer, KP_KeyPress4, Off
            KP_Running4 := false
        }
    } else {
        newState := 1
        newText := "Enabled"
        ; Do not auto-start the timer here.
    }
    if (n == 1)
        KeyEnabled1 := newState
    else if (n == 2)
        KeyEnabled2 := newState
    else if (n == 3)
        KeyEnabled3 := newState
    else if (n == 4)
        KeyEnabled4 := newState
    GuiControl, 2:, KP_Button%n%, %newText%
    UpdateStatusBox()
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

; -----------------------------------------------------------
; Helper: Get Delay value from GUI control
GuiControlGetDelay(n) {
    GuiControlGet, out, 2:, KP_DelayInput%n%
    return out
}

; -----------------------------------------------------------
; KP_SendKey: Sends the key press, with special handling for "ctrl+v"
KP_SendKey(n) {
    GuiControlGet, curKey, 2:, KP_KeyChoice%n%
    curKey := Trim(curKey)
    if (curKey != "") {
        StringLower, lcKey, curKey
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

; -----------------------------------------------------------
; KP_KeyPress routines using per-key running flags
KP_KeyPress1:
    global KP_Running1, KeyEnabled1
    if (!KP_Running1 || KeyEnabled1 = 0) {
         SetTimer, KP_KeyPress1, Off
         KP_Running1 := false
         Return
    }
    KP_SendKey(1)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled1
    if (enforce == 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount1
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount1, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress1, Off
              KeyEnabled1 := 0
              KP_Running1 := false
              GuiControl, 2:, KP_Button1, Disabled
			  CheckKPStatus()  ; Check if all key presser loops have stopped
         }
    }
Return

KP_KeyPress2:
    global KP_Running2, KeyEnabled2
    if (!KP_Running2 || KeyEnabled2 = 0) {
         SetTimer, KP_KeyPress2, Off
         KP_Running2 := false
         Return
    }
    KP_SendKey(2)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled2
    if (enforce == 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount2
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount2, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress2, Off
              KeyEnabled2 := 0
              KP_Running2 := false
              GuiControl, 2:, KP_Button2, Disabled
			  CheckKPStatus()  ; Check if all key presser loops have stopped
         }
    }
Return

KP_KeyPress3:
    global KP_Running3, KeyEnabled3
    if (!KP_Running3 || KeyEnabled3 = 0) {
         SetTimer, KP_KeyPress3, Off
         KP_Running3 := false
         Return
    }
    KP_SendKey(3)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled3
    if (enforce == 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount3
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount3, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress3, Off
              KeyEnabled3 := 0
              KP_Running3 := false
              GuiControl, 2:, KP_Button3, Disabled
			  CheckKPStatus()  ; Check if all key presser loops have stopped
         }
    }
Return

KP_KeyPress4:
    global KP_Running4, KeyEnabled4
    if (!KP_Running4 || KeyEnabled4 = 0) {
         SetTimer, KP_KeyPress4, Off
         KP_Running4 := false
         Return
    }
    KP_SendKey(4)
    GuiControlGet, enforce, 2:, KP_MaxCountEnabled4
    if (enforce == 1) {
         GuiControlGet, remaining, 2:, KP_MaxCount4
         remaining := remaining - 1
         GuiControl, 2:, KP_MaxCount4, %remaining%
         if (remaining <= 0) {
              SetTimer, KP_KeyPress4, Off
              KeyEnabled4 := 0
              KP_Running4 := false
              GuiControl, 2:, KP_Button4, Disabled
			  CheckKPStatus()  ; Check if all key presser loops have stopped
         }
    }
Return

; -----------------------------------------------------------
; KP_StopAutomation: Stops all key press sequences
KP_StopAutomation() {
    SetTimer, KP_KeyPress1, Off
    KP_Running1 := false
    SetTimer, KP_KeyPress2, Off
    KP_Running2 := false
    SetTimer, KP_KeyPress3, Off
    KP_Running3 := false
    SetTimer, KP_KeyPress4, Off
    KP_Running4 := false

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
    GuiControl, 2:, KP_Status, Stopped
    UpdateStatusBox()
}

; -------------------------------------------------------------------
; Universal Close
; -------------------------------------------------------------------
GuiClose:
1GuiClose:
2GuiClose:
3GuiClose:
4GuiClose:
    if (A_Gui == 2)
        Gui, 2:Submit, NoHide
    else if (A_Gui == 3)
        Gui, 3:Submit, NoHide
    else if (A_Gui == 4)
        Gui, 4:Submit, NoHide
    SaveSettings()
    ExitApp

; -------------------------------------------------------------------
; CloseKeyPresser: 
; -------------------------------------------------------------------
CloseKeyPresser:
    Gui 2:Submit, NoHide
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
    if (KP_Running1 || KP_Running2 || KP_Running3 || KP_Running4) {
        KP_StopAutomation()
    }
    Hotkey, %DefaultKPTriggerKey1%, Off
    Hotkey, %DefaultKPTriggerKey2%, Off
    Hotkey, %DefaultKPTriggerKey3%, Off
    Hotkey, %DefaultKPTriggerKey4%, Off
    Gui 2:Destroy
    Gui 1:Show
    UpdateStatusBox()
Return
