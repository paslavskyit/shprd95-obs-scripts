# SHPRD95's OBS Death Counter Script

This repository contains a Lua script for OBS Studio to manage a death counter with a text source. The script allows you to increment and decrement the counter using hotkeys and persists the counter value across OBS sessions.

## Features

- Increment and decrement the counter with hotkeys.
- Text source displays "Смертей: X", where X is the current counter value.
- Counter value is saved to and loaded from a file to persist across sessions.

## Prerequisites

- **OBS Studio**: Make sure OBS Studio is installed on your system.
- **OBS Lua Scripting**: OBS must support Lua scripting. This is usually included by default.

## Setup Instructions

### 1. Download the Script

1. Download the `death_counter.lua` script from this repository.

### 2. Place the Script in the OBS Scripts Folder

1. **Open OBS Studio**.
2. Go to **Tools** > **Scripts**.
3. Click **Open Scripts Folder**.
4. Place the `death_counter.lua` file in this folder.

### 3. Create the Counter Value File

1. Open a text editor (e.g., Notepad).
2. Create a new file and save it as `death_counter.txt` in the same directory as your Lua script (`C:/Project Files/OBS_Files/Scripts/`).
3. Leave the file empty; it will be populated with the counter value by the script.

### 4. Configure the Script in OBS

1. **Open OBS Studio**.
2. Go to **Tools** > **Scripts**.
3. Click **+** to add a new script.
4. Select `death_counter.lua` from the Scripts folder.
5. Ensure that the `file_path` variable in the script matches the location of `death_counter.txt`.

### 5. Set Up the Text Source

1. In OBS, add a new **Text (GDI+)** source to your scene.
2. Name the text source `DeathCounter`.
3. Adjust the font and size as needed.
4. Make sure this text source is visible in your scene.

### 6. Configure Hotkeys

1. In OBS, go to **File** > **Settings** > **Hotkeys**.
2. Scroll down to find the hotkeys for "Increment Death Counter" and "Decrement Death Counter".
3. Assign desired key combinations for these actions.

### 7. Script Configuration

1. Open the Lua script file (`death_counter.lua`) in a text editor.
2. Update the `source_name` variable if your text source has a different name.
3. Ensure the `file_path` variable in the script is set to the location where `death_counter.txt` is saved.

### 8. Test the Script

1. **Increment/Decrement**: Use the assigned hotkeys to test the increment and decrement functionality.
2. **Check Display**: Verify that the text source updates correctly to show "Смертей: X" where X is the counter value.
3. **Persistence**: Close and restart OBS to ensure the counter value persists correctly.

## Troubleshooting

- **Text Source Not Updating**: Ensure the text source name in the script matches the name in OBS. Check for any typos.
- **Script Errors**: Review the OBS log for any script errors and ensure the Lua script is correctly formatted.
- **File Path Issues**: Make sure the file path specified in the script has the correct permissions and is accessible. Ensure `death_counter.txt` exists and is in the correct location.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any issues or questions, please open an issue on the GitLab repository or contact me on Telegram.
<a href="https://t.me/shprd95"><img src="https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" height="20"/></a>