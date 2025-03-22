Key Automation Script – User Guide
====================================

Overview:
---------
This AutoHotkey script automates keyboard actions. It has three main modes:

1. Enter Commands Mode
   - Create custom sequences that simulate key presses and type text.
2. Key Holder Mode
   - Hold down a chosen key continuously (toggled with F8).
3. Key Presser Mode
   - Automatically press one or more keys repeatedly using user-defined settings such as delay, hold time, maximum count, and enable/disable toggles.

A small status box appears at the top of your screen:
   - Red means automation is inactive.
   - Green means automation is active.

How to Run the Script:
----------------------
1. Install AutoHotkey:
   - Download and install AutoHotkey from https://www.autohotkey.com/.
2. Save the Script:
   - Save the provided script as a file with a “.ahk” extension (for example, KeyAutomation.ahk).
3. Run the Script:
   - Double-click the .ahk file to launch the script. The main menu will appear.

Main Menu:
----------
When you run the script, you see a main menu with these options:
   - Enter Commands: Opens the mode for creating custom key sequences.
   - Key Holder: Opens the mode for holding a selected key down.
   - Key Presser: Opens the mode for automatically pressing keys repeatedly.
   - Exit: Closes the script.

Mode Descriptions and Functions:
----------------------------------

1. Enter Commands Mode (GUI #4):
   - Purpose:
     * Create sequences that simulate key presses and type text.
   - How It Works:
     * You choose a “First Key” to press.
     * You enter text that you want the script to type.
     * You choose a “Second Key” to press after the text.
     * You select a trigger key (such as F8) that, when pressed, runs this sequence.
   - Usage:
     * Set up your sequence, click “Activate,” and then press the trigger key to run it.

2. Key Holder Mode (GUI #3):
   - Purpose:
     * Hold down a chosen key continuously.
   - How It Works:
     * You select a key from a drop-down list.
     * Pressing F8 toggles the key “down” (held) or “up” (released).
   - Usage:
     * Choose your key, press F8 to hold it down, and press F8 again to release it.

3. Key Presser Mode (GUI #2):
   - Purpose:
     * Automatically press one or more keys repeatedly.
   - How It Works:
     * For up to four keys, you set the following options:
         - Key Choice: Which key to press.
         - Delay (ms): Time between key presses.
         - Hold Time (ms): How long the key is held down.
         - Max Count: The number of times the key is pressed.
         - Enforce Checkbox: When checked, the script will stop pressing that key once the maximum count is reached.
         - Enable/Disable Button: Lets you manually turn a key’s automation on or off.
     * The script uses timers to send the key presses.
     * An auto-stop function monitors keys that are set to “Enforce” a maximum count. When all such keys reach their maximum count, the automation stops automatically.
   - Usage:
     * Set your desired options for each key.
     * Use the enable/disable buttons to control each key.
     * Press F8 to start or stop the automated key pressing.
     * The status box will change to green when automation is active.

• Universal Close:
  - If any window is closed (for example, clicking the “X” button), the script exits completely.

Important Notes:
----------------
• No Coding Experience Needed:
  - You do not need to modify the script. Simply choose the mode you want and use the provided drop-down menus and buttons.
  
• Customization:
  - Advanced users may edit the script in AutoHotkey if needed, but the default settings are pre-configured for typical use.

• Status Indicators:
  - Always check the status box at the top:
      - Red indicates automation is off.
      - Green indicates automation is running.

Troubleshooting:
----------------
• If a key continues to be pressed even when it appears disabled:
  - Ensure that you have clicked the correct enable/disable button.
  - Make sure you are using F8 to start/stop automation in the respective modes.
  - Check the “Enforce” option in Key Presser mode if you want the automation to stop after a set number of presses.

Enjoy your automated key control and refer to this guide whenever you need assistance with the script.

End of README
