obs = obslua

-- Settings
local source_name = "Timer_demo_source"
local countdown = 15 * 60 -- Default 15 minutes in seconds
local original_text = "Time remaining: "
local timer_running = false
local timer_paused = false
local finish_text = "Time's up!"
local interval = 1000 -- Update interval in milliseconds
local version = "1.3.0" -- Version tracking

-- Function to populate the dropdown with text sources
function populate_text_sources(combo)
    obs.script_log(obs.LOG_INFO, "Populating text source dropdown")
    local sources = obs.obs_enum_sources()
    if sources == nil then
        obs.script_log(obs.LOG_WARNING, "Failed to enumerate sources")
        return
    end

    local count = 0
    for _, source in ipairs(sources) do
        local source_name = obs.obs_source_get_name(source)
        local source_id = obs.obs_source_get_id(source)

        if string.match(source_id, "^text_gdiplus") or string.match(source_id, "^text_ft2") then
            obs.obs_property_list_add_string(combo, source_name, source_name)
            count = count + 1
        end
    end
    obs.source_list_release(sources)
    obs.script_log(obs.LOG_INFO, string.format("Found %d text sources", count))
end

-- Format time as MM:SS with optional hour display for times > 60 minutes
function format_time(seconds)
    if seconds <= 0 then
        return "00:00"
    end
    
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

-- Safe function to get a source with logging
function get_source_safe(name)
    obs.script_log(obs.LOG_DEBUG, "Getting source: " .. name)
    local source = obs.obs_get_source_by_name(name)
    if not source then
        obs.script_log(obs.LOG_WARNING, "Source not found: " .. name)
        return nil
    end
    return source
end

-- Update the text source with current time
function update_text_source()
    local source = get_source_safe(source_name)
    if source then
        local timer_text = format_time(countdown)
        local full_text = original_text .. " " .. timer_text

        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", full_text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
        
        -- Log only when significant time changes (every 5 seconds) to avoid log spam
        if countdown % 5 == 0 or countdown <= 10 then
            obs.script_log(obs.LOG_INFO, "Timer updated: " .. timer_text)
        end
    else
        obs.script_log(obs.LOG_WARNING, "Failed to update timer - source not found: " .. source_name)
    end
end

-- Timer callback function
function timer_callback()
    if not timer_running then
        obs.script_log(obs.LOG_WARNING, "Timer callback called but timer is not running. Stopping timer.")
        obs.timer_remove(timer_callback)
        return
    end
    
    if not timer_paused and countdown > 0 then
        countdown = countdown - 1
        update_text_source()
        
        -- Log more frequently in the final countdown
        if countdown <= 5 then
            obs.script_log(obs.LOG_INFO, string.format("Final countdown: %d seconds remaining", countdown))
        end
    elseif countdown <= 0 then
        obs.script_log(obs.LOG_INFO, "Timer finished")
        obs.timer_remove(timer_callback)
        timer_running = false

        -- Set final text
        local source = get_source_safe(source_name)
        if source then
            local settings = obs.obs_data_create()
            obs.obs_data_set_string(settings, "text", finish_text)
            obs.obs_source_update(source, settings)
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
            obs.script_log(obs.LOG_INFO, "Set finish text: " .. finish_text)
        end
    end
end

-- Function to start the timer
function start_timer()
    obs.script_log(obs.LOG_INFO, "Start timer requested")
    
    if timer_running then
        obs.script_log(obs.LOG_INFO, "Timer is already running with " .. countdown .. " seconds remaining")
        return false
    end
    
    -- Make sure source is visible
    local source = get_source_safe(source_name)
    if source then
        local visible = obs.obs_source_enabled(source)
        if not visible then
            obs.script_log(obs.LOG_INFO, "Enabling source visibility")
            obs.obs_source_set_enabled(source, true)
        end
        obs.obs_source_release(source)
    else
        obs.script_log(obs.LOG_WARNING, "Failed to get source for timer start")
        return false
    end
    
    timer_running = true
    timer_paused = false
    update_text_source()
    
    obs.script_log(obs.LOG_INFO, string.format("Timer started for %d minutes %d seconds", 
        math.floor(countdown / 60), countdown % 60))
    obs.timer_add(timer_callback, interval)
    
    return true
end

-- Function to toggle pause/resume the timer
function toggle_pause_timer()
    if not timer_running then
        obs.script_log(obs.LOG_WARNING, "Cannot pause - timer is not running")
        return false
    end
    
    timer_paused = not timer_paused
    
    if timer_paused then
        obs.script_log(obs.LOG_INFO, string.format("Timer paused with %d seconds remaining", countdown))
    else
        obs.script_log(obs.LOG_INFO, string.format("Timer resumed with %d seconds remaining", countdown))
    end
    
    return true
end

-- Function to stop the timer
function stop_timer()
    obs.script_log(obs.LOG_INFO, "Stop timer requested")
    
    if not timer_running then
        obs.script_log(obs.LOG_INFO, "Timer is not running, nothing to stop")
        return false
    end
    
    timer_running = false
    timer_paused = false
    
    local source = get_source_safe(source_name)
    if source then
        -- Hide the source when stopped
        obs.obs_source_set_enabled(source, false)
        obs.obs_source_release(source)
        obs.script_log(obs.LOG_INFO, "Source hidden")
    end

    obs.timer_remove(timer_callback)
    obs.script_log(obs.LOG_INFO, "Timer stopped with " .. countdown .. " seconds remaining")
    
    return true
end

-- Function to reset the timer to initial value
function reset_timer()
    obs.script_log(obs.LOG_INFO, "Reset timer requested")
    
    -- Stop the timer if it's running
    if timer_running then
        obs.timer_remove(timer_callback)
        timer_running = false
    end
    
    -- Reset to default 15 minutes
    countdown = 15 * 60
    timer_paused = false
    
    update_text_source()
    obs.script_log(obs.LOG_INFO, "Timer reset to 15:00")
    
    return true
end

-- Function to adjust the timer (add or subtract time)
function adjust_timer(minutes)
    obs.script_log(obs.LOG_INFO, "Adjust timer requested: " .. minutes .. " minutes")
    
    local seconds_to_adjust = minutes * 60
    local old_countdown = countdown
    countdown = countdown + seconds_to_adjust
    
    -- Ensure timer doesn't go negative
    if countdown < 0 then
        obs.script_log(obs.LOG_INFO, "Timer would be negative, clamping to 0")
        countdown = 0
    end
    
    update_text_source()
    
    -- Format the time nicely for logging
    local old_formatted = format_time(old_countdown)
    local new_formatted = format_time(countdown)
    obs.script_log(obs.LOG_INFO, string.format("Timer adjusted from %s to %s (%+d minutes)", 
        old_formatted, new_formatted, minutes))
    
    -- If timer is not running, consider starting it
    if not timer_running and countdown > 0 then
        obs.script_log(obs.LOG_INFO, "Timer was adjusted but not running - starting timer")
        start_timer()
    end
    
    return true
end

-- Script description
function script_description()
    return "Countdown Timer v" .. version .. " - Controls a countdown timer with UI buttons and hotkeys"
end

-- Script properties
function script_properties()
    local props = obs.obs_properties_create()
    
    -- Source selection
    local text_sources = obs.obs_properties_add_list(props, "text_source", "Text Source", 
        obs.OBS_COMBO_TYPE_LIST, 
        obs.OBS_COMBO_FORMAT_STRING)
    populate_text_sources(text_sources)
    
    -- Timer settings
    obs.obs_properties_add_int(props, "duration", "Timer Duration (minutes)", 1, 180, 1)
    obs.obs_properties_add_text(props, "prefix_text", "Prefix Text", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "finish_text", "Finish Text", obs.OBS_TEXT_DEFAULT)
    
    -- Control buttons
    obs.obs_properties_add_button(props, "start_button", "Start Timer", start_timer)
    obs.obs_properties_add_button(props, "pause_button", "Pause/Resume Timer", toggle_pause_timer)
    obs.obs_properties_add_button(props, "stop_button", "Stop Timer", stop_timer)
    obs.obs_properties_add_button(props, "reset_button", "Reset Timer", reset_timer)
    
    -- Adjustment buttons
    local adjustment_group = obs.obs_properties_create()
    obs.obs_properties_add_button(adjustment_group, "add_5min", "Add 5 Minutes", function() adjust_timer(5); return true end)
    obs.obs_properties_add_button(adjustment_group, "sub_5min", "Subtract 5 Minutes", function() adjust_timer(-5); return true end)
    obs.obs_properties_add_group(props, "adjustments", "Add manually", obs.OBS_GROUP_NORMAL, adjustment_group)
    
    return props
end

-- Script update
function script_update(settings)
    local new_source = obs.obs_data_get_string(settings, "text_source")
    local new_prefix = obs.obs_data_get_string(settings, "prefix_text")
    local new_finish = obs.obs_data_get_string(settings, "finish_text")
    
    -- Log changes to settings
    if new_source ~= source_name then
        obs.script_log(obs.LOG_INFO, "Source changed from '" .. source_name .. "' to '" .. new_source .. "'")
    end
    
    if new_prefix ~= original_text then
        obs.script_log(obs.LOG_INFO, "Prefix text changed from '" .. original_text .. "' to '" .. new_prefix .. "'")
    end
    
    if new_finish ~= finish_text then
        obs.script_log(obs.LOG_INFO, "Finish text changed from '" .. finish_text .. "' to '" .. new_finish .. "'")
    end
    
    source_name = new_source
    original_text = new_prefix
    finish_text = new_finish
    
    -- Only update countdown if timer is not running
    if not timer_running then
        local new_duration = obs.obs_data_get_int(settings, "duration")
        countdown = new_duration * 60
        obs.script_log(obs.LOG_INFO, "Duration set to " .. new_duration .. " minutes")
    end
end

-- Script save
function script_save(settings)
    obs.obs_data_set_string(settings, "text_source", source_name)
    obs.obs_data_set_string(settings, "prefix_text", original_text)
    obs.obs_data_set_string(settings, "finish_text", finish_text)
    obs.obs_data_set_int(settings, "duration", math.floor(countdown / 60))
    obs.script_log(obs.LOG_INFO, "Timer settings saved")
end

-- Script defaults
function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "text_source", "Timer_demo_source")
    obs.obs_data_set_default_string(settings, "prefix_text", "Time remaining:")
    obs.obs_data_set_default_string(settings, "finish_text", "Time's up!")
    obs.obs_data_set_default_int(settings, "duration", 15)
end

-- Script load
function script_load(settings)
    obs.script_log(obs.LOG_INFO, "Timer script v" .. version .. " loading")
    
    source_name = obs.obs_data_get_string(settings, "text_source")
    original_text = obs.obs_data_get_string(settings, "prefix_text")
    finish_text = obs.obs_data_get_string(settings, "finish_text")
    countdown = obs.obs_data_get_int(settings, "duration") * 60
    
    obs.script_log(obs.LOG_INFO, string.format("Loaded with source: '%s', prefix: '%s', duration: %d minutes", 
        source_name, original_text, countdown / 60))
    
    obs.script_log(obs.LOG_INFO, "Timer script successfully loaded")
end
