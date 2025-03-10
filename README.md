# SHPRD95's OBS Demo Timer Script

This OBS Lua script provides a fully-featured countdown timer with a clean user interface, customizable display settings, and multiple control options. The timer displays the remaining time on a text source in OBS Studio with various formatting options and controls to start, pause, stop, reset, and adjust the timer value.

## Features

- **Customizable Timer Duration**: Set a timer from 1 to 180 minutes.
- **Multiple Control Options**: Start, pause/resume, stop, and reset the timer with simple button clicks.
- **Time Adjustments**: Quickly add or subtract 5 minutes from the current timer value.
- **Smart Time Formatting**: Automatically displays time in MM:SS format, switching to HH:MM:SS for durations over 60 minutes.
- **Custom Text Options**: Set prefix text and finish text to personalize the timer display.
- **Source Visibility Control**: Timer automatically shows and hides the source when appropriate.
- **Persistent Settings**: All configuration options are saved between OBS sessions.

## Installation

1. Download the `demo_timer.lua` script from this repository.
2. Open OBS Studio.
3. Go to **Tools** > **Scripts**.
4. Click the **+** button to add a new script.
5. Navigate to and select the `demo_timer.lua` file.

## Configuration

### Basic Settings

1. **Text Source**: Select the text source that will display the timer. The script automatically detects all text sources in your scenes.
2. **Timer Duration**: Set the initial duration for the timer in minutes (1-180).
3. **Prefix Text**: Enter the text to display before the timer (e.g., "Time remaining:").
4. **Finish Text**: Enter the text to display when the timer reaches zero (e.g., "Time's up!").

### Control Buttons

The script provides several control buttons directly in the script properties panel:

- **Start Timer**: Begins the countdown from the set duration.
- **Pause/Resume Timer**: Toggles the timer between paused and running states.
- **Stop Timer**: Stops the timer and hides the source.
- **Reset Timer**: Resets the timer to the initial duration.

### Time Adjustments

In the **Quick Adjustments** section:

- **Add 5 Minutes**: Adds 5 minutes to the current timer value.
- **Subtract 5 Minutes**: Subtracts 5 minutes from the current timer value (won't go below zero).

## Usage Instructions

### Setting Up the Timer

1. Create a **Text (GDI+)** or **Text (FreeType 2)** source in your OBS scene.
2. In the script settings, select this source from the dropdown menu.
3. Set your desired timer duration, prefix text, and finish text.

### Controlling the Timer

1. **Start the Timer**:
   - Click the "Start Timer" button in the script properties.
   - The timer will begin counting down, and the source will become visible.

2. **Pause/Resume the Timer**:
   - Click the "Pause/Resume Timer" button to temporarily halt the countdown.
   - Click again to resume from the paused time.

3. **Stop the Timer**:
   - Click the "Stop Timer" button to end the countdown.
   - The timer source will be hidden.

4. **Reset the Timer**:
   - Click the "Reset Timer" button to return to the initial duration.
   - This will not start the timer automatically.

5. **Adjust the Timer**:
   - Use the "Add 5 Minutes" or "Subtract 5 Minutes" buttons to quickly modify the timer value.
   - If the timer is not running when adjusted, it will start automatically.

### Timer Display

- The timer displays in **MM:SS** format for durations under 60 minutes.
- For durations over 60 minutes, it switches to **HH:MM:SS** format.
- When the timer reaches zero, it displays the custom finish text.

## Troubleshooting

- **Timer Not Appearing**: Ensure the selected text source exists in your current scene.
- **Timer Not Starting**: Check that the source is properly selected in the script settings.
- **Incorrect Formatting**: If the timer display looks incorrect, try resetting the timer or adjusting the prefix text.
- **Script Errors**: Review the OBS Script Log (Tools → Scripts → Script Log) for any error messages.

## License

This script is provided as-is. Feel free to use and modify it as needed for your streaming setup. No warranty is provided regarding its functionality or suitability for any particular purpose.
