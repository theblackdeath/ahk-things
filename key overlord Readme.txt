==============================================
         Automated Key Actions Script
             README / Documentation
==============================================

Overview:
-----------
This AutoHotkey script automates various keyboard actions by offering three main modes:
1. Enter Commands – Configure dynamic hotkey sequences that send custom text.
2. Key Holder – Toggle and hold down a selected key.
3. Key Presser – Automate repeated key presses with customizable delays, hold times, and repetition limits.

All user settings are saved in "settings.ini" and loaded automatically at startup.
A small Status Box (colored red or green) indicates whether any automation is active.

------------------------------------------------
Main Menu (GUI #1)
------------------------------------------------
When the script is launched, the Main Menu appears with the following buttons:
• Enter Commands
  - Opens the Enter Commands mode (GUI #4) to configure hotkey-triggered text sequences.
• Key Holder
  - Opens the Key Holder mode (GUI #3) to select and toggle a key to hold down.
• Key Presser
  - Opens the Key Presser mode (GUI #2) to automate repeated key presses.
• Exit
  - Saves settings and exits the script.

------------------------------------------------
Mode 1: Enter Commands (GUI #4)
------------------------------------------------
Purpose:
Configure up to three separate command sequences that are activated by specific trigger keys.

For Each Sequence (First, Second, Third):
• First Key (DropDownList)
  - Select the key to press at the beginning of the sequence.
  - (Special note: if “grave” is selected, it is internally mapped to “SC029”.)
• Enter Text to Type (Edit Field)
  - Input the text that will be sent immediately after the first key is pressed.
• Second Key (DropDownList)
  - Select the key to press after the text is sent.
• Trigger Key (DropDownList)
  - Choose a function key (F8, F9, F10, etc.) that will activate this sequence.

Buttons:
• Activate
  - Submits the current settings, saves them, unbinds any previous triggers,
    and binds the new trigger hotkeys so that pressing them runs the corresponding sequence.
• Back
  - Saves any changes, unbinds the active hotkeys, and returns to the Main Menu.

------------------------------------------------
Mode 2: Key Holder (GUI #3)
------------------------------------------------
Purpose:
Allow the user to select one key to “hold down” (simulate continuously pressing the key).

Elements:
• Key Selection (DropDownList)
  - Choose a key from a predefined list (e.g., up, down, letters, function keys, mouse buttons).
• Reset Button
  - Resets the drop-down to the default value (usually "e").
• Status Display (Text)
  - Shows “Stopped” or “Holding Key” based on whether the key is currently held.
• Back Button
  - Exits Key Holder mode, releases the held key (if active), saves settings, and returns to Main Menu.

Hotkey:
• F8 is used to toggle the holding action on and off.

------------------------------------------------
Mode 3: Key Presser (GUI #2)
------------------------------------------------
Purpose:
Automate the pressing of up to four different keys with customizable parameters.

For Each Key (Key 1 to Key 4):
• Key Choice (DropDownList)
  - Select which key should be automatically pressed.
• Delay (Edit Field)
  - Specify the delay (in milliseconds) between each cycle of key presses.
• Hold Time (Edit Field)
  - Define how long (in milliseconds) the key is held down during each press.
• Max Count (Edit Field)
  - Set the maximum number of times the key will be pressed before the automation stops.
• Enforce Checkbox
  - When checked, the script will enforce the max count limit; once the limit is reached, the key’s automation stops.
• Toggle Button (Next to Each Key)
  - Displays “Enabled” or “Disabled.” Clicking the button toggles the automation state for that key.
  
Additional Elements:
• Repeat Continuously Checkbox
  - When checked, the key press sequences repeat indefinitely until manually stopped.
• Status Label (Text)
  - Shows “Started” when automation is running and “Stopped” when it is not.
• Back Button
  - Saves all changes, stops any active automation, and returns to the Main Menu.

Hotkey:
• F8 toggles the overall Key Presser automation on or off.
• Individual key timers use the specified delay values to send key presses.
• When a key’s max count (if enforced) reaches zero, its automation stops and the corresponding toggle button is disabled.

------------------------------------------------
Settings and Global Functions:
------------------------------------------------
• The script uses a settings.ini file to store all user preferences (keys, delays, counts, etc.).
• LoadSettings() and SaveSettings() are called on startup and exit to maintain user settings.
• The Status Box:
  - A small window on the screen that displays a red color when inactive and green when any automation is running.
• Global variables are used to keep track of previous trigger keys and current automation states.

------------------------------------------------
Usage Instructions:
------------------------------------------------
1. Run the script to display the Main Menu.
2. Choose your desired mode:
   - Use Enter Commands for hotkey-based text sequences.
   - Use Key Holder to simulate holding down a key.
   - Use Key Presser for repeated key presses with customizable timing.
3. Adjust the dropdowns, text fields, check boxes, and buttons to suit your needs.
4. Activate the desired automation using the provided buttons or hotkeys.
5. Return to the Main Menu using the “Back” buttons. Settings are saved automatically.
6. Exit the script by clicking “Exit” on the Main Menu.

------------------------------------------------
Important Notes:
------------------------------------------------
• This script simulates keyboard input and may affect other running applications.
• Ensure that the selected keys and settings do not interfere with your normal computer operations.
• The “Enforce” checkboxes in Key Presser mode help limit the number of key presses.
• The script includes error checking (e.g., ensuring a key is selected before holding it down).

==============================================
                End of Documentation
==============================================
