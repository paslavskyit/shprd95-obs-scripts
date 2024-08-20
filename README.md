# SHPRD95's OBS Countdown Timer Script

This OBS Lua script allows you to display a countdown timer on a text source in OBS Studio. The timer is based on the last number found in the text of the selected source. It includes features to start, pause/resume, and stop the timer, with options to automatically hide the source after the countdown ends.

## Features

- **Read and Start Timer**: Extracts the last number from the selected text source and starts a countdown timer based on that value.
- **Pause/Resume Timer**: Toggle between pausing and resuming the timer.
- **Stop Timer**: Stops the timer and updates the text to a final message.
- **Automatic Source Hiding**: Automatically hides the text source 10 seconds after the countdown finishes.

## Installation

1. Open OBS Studio.
2. Go to `Tools` > `Scripts`.
3. Click the `+` button to add a new script.
4. Browse to the location of the `countdown_timer.lua` file and select it.

## Configuration

1. **Text Source**: Select the text source from which the script will read the countdown value.
2. **Start Timer**: Click the "Start Timer" button to begin the countdown or trigger it with streamer bot.
3. **Pause/Resume Timer**: Click the "Pause/Resume Timer" button to toggle the timer's state.
4. **Stop Timer**: Click the "Stop Timer" button to stop the timer and update the text to the final message.

## Script Description

The script reads the text from the selected source, extracting the last number to determine the countdown duration. The countdown is displayed on the screen, preserving the original text except for the updated timer portion. Includes buttons for manual control of the timer.

## Example Usage

1. **Configure Text Source**: Ensure the selected text source ends with the countdown value (e.g., "Remaining Time: 15").
2. **Start Timer**: Click the "Start Timer" button to initialize the countdown or trigger it with streamer bot.
3. **Pause/Resume Timer**: Use the "Pause/Resume Timer" button to pause or resume the countdown as needed.
4. **Stop Timer**: Click the "Stop Timer" button to end the countdown and display the final message.