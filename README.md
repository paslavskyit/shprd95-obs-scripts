# TarasAVG OBS Lua Scripts Collection

This repository contains a collection of Lua scripts for OBS Studio to enhance your streaming experience with timers, counters, and other useful tools.

## Available Scripts

### 1. Demo Timer (tarasavg_demo_timer.lua)
- **Description**: A customizable countdown timer with UI controls and visual display
- **Features**:
   - Set custom duration (1-180 minutes)
   - Start, pause, stop, and reset timer
   - Quick time adjustments (+/- 5 minutes)
   - Custom prefix and completion text
   - Automatic formatting of time display (HH:MM:SS or MM:SS)
   - Visibility control of timer source
- **Usage**:
   1. Add the script in OBS: Scripts → + → Select demo_timer.lua
   2. Select a text source from the dropdown
   3. Configure timer settings and text options
   4. Use the UI buttons to control the timer

### 2. Countdown Timer (countdown_timer.lua) Deprecated
- **Description**: Timer that reads numbers from a text source and counts down from that value
- **Features**:
   - Automatically extracts the timer value from text content
   - Preserves the original text while updating only the time display
   - Shows customizable completion message when timer finishes
   - Start, pause, and stop controls
- **Usage**:
   1. Add the script in OBS: Scripts → + → Select countdown_timer.lua
   2. Select a text source that contains a number (e.g., "Challenge: 30")
   3. Use the buttons to start, pause, or stop the countdown
   4. The timer will extract "30" and count down from there

### 3. Death Counter (tarasavg_death_counter.lua)
- **Description**: Tracks death counts or other incremental values during gameplay
- **Features**:
   - Increment/decrement counter via hotkeys
   - Persistent count between OBS sessions
   - Customizable display text prefix
   - Easy reset and adjustment
- **Usage**:
   1. Add the script in OBS: Scripts → + → Select death_counter.lua
   2. Select a text source for displaying the count
   3. Set a prefix text (e.g., "Deaths: ")
   4. Configure hotkeys in OBS settings to increment/decrement the counter

## Installation

1. **Download Scripts**:
    - Clone this repository or download individual .lua files

2. **Add to OBS**:
    - Open OBS Studio
    - Go to Tools → Scripts
    - Click the + button and navigate to the downloaded .lua file
    - Select the script to add it

3. **Configure Settings**:
    - Select a text source for the script to use
    - Adjust other settings as needed
    - Set up hotkeys if applicable (in OBS Settings → Hotkeys)

## Requirements

- OBS Studio (version 27.0 or later recommended)
- Text sources (GDI+ or FreeType 2) created in your OBS scenes

## Troubleshooting

- If a timer or counter is not updating, check that the correct text source is selected
- Ensure the text source exists and is properly named in your scene
- Check OBS Script Log for error messages (Tools → Scripts → Script Log)
- Verify that the text format matches what the script expects to parse


## License

These scripts are provided as-is. Feel free to use and modify them as needed for your streaming setup. No warranty is provided regarding their functionality or suitability for any particular purpose.

## Contact

For any issues or questions, please open an issue on the GitLab repository or contact me on <a href="https://t.me/paslavskyit">Telegram</a>.

<p align="center">
  Like this script? <a href="https://www.twitch.tv/tarasavg">Follow my Twitch channel💜</a> or <a href="https://donatello.to/tarasavg">tip some money💸</a>!
</p>