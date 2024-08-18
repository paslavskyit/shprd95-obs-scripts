# SHPRD95's OBS Counter Script

This repository contains a Lua script for OBS Studio to manage a death/kill(any) counter with a text source. The script allows you to increment and decrement the counter using hotkeys and automatically updates the selected source with the current counter value. 

## Features

- Increment and decrement the counter with hotkeys.
- The text source displays "Deaths: X", where X is the current counter value. You can add any prefix, for example "Kills".
- The counter value is persistant and doesen't require any external file to store the information.
- Source, prefix text, and counter updates automatically upon selection change.

**Note:** This version of the script automatically updates changes when you select a new source or modify the counter or prefix.

## Prerequisites

- **OBS Studio**: Ensure OBS Studio is installed on your system.
- **OBS Lua Scripting**: OBS must support Lua scripting, typically included by default.

## Setup Instructions

### 1. Download the Script

1. Download the `death_counter.lua` script from this repository.

### 2. Place the Script somewhere in your PC to be albe to add it to OBS

1. **Open OBS Studio**.
2. Go to **Tools** > **Scripts**.
3. Click **Open Scripts Folder**.
4. Find the path `death_counter.lua` to the file where you've placed it.

### 3. Set Up the Text Source

1. In OBS, add a new **Text (GDI+)** source to your scene.
2. Adjust the font, color and size as needed.
3. The source will automatically update with the counter value when selected.

### 4. Configure the Script in OBS

1. **Open OBS Studio**.
2. Go to **Tools** > **Scripts**.
3. Click **+** to add a new script.
4. Select `death_counter.lua` from the Scripts folder.
5. Set up the source selection, prefix, and file path in the script properties.

### 5. Configure Hotkeys

1. In OBS, go to **File** > **Settings** > **Hotkeys**.
2. Scroll down to find the hotkeys for "Increment SHPRD95's Counter" and "Decrement SHPRD95's Counter".
3. Assign desired key combinations for these actions.

### 6. Script Configuration

1. The script automatically detects text sources and lets you pick from available **Text (GDI+)** sources.
2. You can specify a custom prefix (e.g., "Deaths: ").
3. Changes are applied automatically when you pick a new source, modify the counter, or change the prefix.

### 7. Test the Script

1. **Increment/Decrement**: Use the assigned hotkeys to test the increment and decrement functionality.
2. **Check Display**: Verify that the text source updates correctly to show "your_prefix: X" where X is the counter value.
3. **Persistence**: Close and restart OBS to ensure the counter value persists correctly.

## Troubleshooting

- **Text Source Not Updating**: Ensure the text source name in the script matches the name in OBS. Check for any typos.
- **Script Errors**: Review the OBS log for any script errors and ensure the Lua script is correctly formatted.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any issues or questions, please open an issue on the GitLab repository or contact me on Telegram. Click >>  
<a href="https://t.me/yourusername">
  <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTEyIDI0YzYuNjI3IDAgMTItNS4zNzMgMTItMTJTMTguNjI3IDAgMTIgMCAwIDUuMzczIDAgMTJzNS4zNzMgMTIgMTIgMTJaIiBmaWxsPSJ1cmwoI2FpIi8+PHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik01LjQyNSAxMS44NzFhNzk2LjQxNCA3OTYuNDE0IDAgMCAxIDYuOTk0LTMuMDE4YzMuMzI4LTEuMzg4IDQuMDI3LTEuNjI4IDQuNDc3LTEuNjM4LjEgMCAuMzIuMDIuNDcuMTQuMTIuMS4xNS4yMy4xNy4zMy4wMi4xLjA0LjMxLjAyLjQ3LS4xOCAxLjg5OC0uOTYgNi41MDQtMS4zNiA4LjYyMi0uMTcuOS0uNSAxLjE5OS0uODE5IDEuMjI5LS43LjA2LTEuMjI5LS40Ni0xLjg5OC0uOS0xLjA2LS42ODktMS42NDktMS4xMTktMi42NzgtMS43OTgtMS4xOS0uNzgtLjQyLTEuMjA5LjI2LTEuOTA4LjE4LS4xOCAzLjI0Ny0yLjk3OCAzLjMwNy0zLjIyOC4wMS0uMDMuMDEtLjE1LS4wNi0uMjEtLjA3LS4wNi0uMTctLjA0LS4yNS0uMDItLjExLjAyLTEuNzg4IDEuMTQtNS4wNTYgMy4zNDgtLjQ4LjMzLS45MDkuNDktMS4yOTkuNDgtLjQzLS4wMS0xLjI0OC0uMjQtMS44NjgtLjQ0LS43NS0uMjQtMS4zNDktLjM3LTEuMjk5LS43OS4wMy0uMjIuMzMtLjQ0Ljg5LS42NjlaIiBmaWxsPSIjZmZmIi8+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJhIiB4MT0iMTEuOTkiIHkxPSIwIiB4Mj0iMTEuOTkiIHkyPSIyMy44MSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIHN0b3AtY29sb3I9IiMyQUFCRUUiLz48c3RvcCBvZmZzZXQ9IjEiIHN0b3AtY29sb3I9IiMyMjlFRDkiLz48L2xpbmVhckdyYWRpZW50PjwvZGVmcz48L3N2Zz4K" alt="Telegram" style="width: 20px; height: 20px;"/>
</a>.