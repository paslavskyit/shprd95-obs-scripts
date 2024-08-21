obs = obslua

local source_name = "-"
local countdown = 0
local original_text = ""
local timer_running = false
local timer_paused = false
local finish_text = "Вимога виконана, Shepherd завжди дотримується слова"  -- Default finish text

-- Function to populate the dropdown with text sources
function populate_text_sources(combo)
    local sources = obs.obs_enum_sources()
    if sources == nil then
        print("Failed to enumerate sources")
        return
    end

    for _, source in ipairs(sources) do
        local source_name = obs.obs_source_get_name(source)
        local source_id = obs.obs_source_get_id(source)

        if string.match(source_id, "^text_gdiplus") or string.match(source_id, "^text_ft2") then
            obs.obs_property_list_add_string(combo, source_name, source_name)
        end
    end
    obs.source_list_release(sources)
end

-- Function to read the text from the selected source
function get_text_from_source()
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        local settings = obs.obs_source_get_settings(source)
        local text = obs.obs_data_get_string(settings, "text")
        obs.obs_source_release(source)
        obs.obs_data_release(settings)
        return text
    end
    return nil
end

-- Function to set the timer based on the last number in the text
function set_timer_based_on_text()
    local text = get_text_from_source()
    if text then
        obs.script_log(obs.LOG_INFO, "Text from source: " .. text)

        local timer_value = text:match("(%d+)%s*$")

        if timer_value then
            obs.script_log(obs.LOG_INFO, "Extracted timer value: " .. timer_value)

            if timer_running then
                obs.timer_remove(timer_callback)
                timer_running = false
            end
            
            countdown = tonumber(timer_value) * 60  -- Convert minutes to seconds
            original_text = text:match("^(.-)%s*%d+%s*$") or text
            obs.script_log(obs.LOG_INFO, "Timer started for " .. countdown / 60 .. " minutes.")
            
            obs.timer_add(timer_callback, 1000)  -- Update every second
            timer_running = true
        end
    else
        obs.script_log(obs.LOG_WARNING, "Text source not found or empty.")
    end
end

-- Function to update only the last part of the text source with the remaining time
function update_text_source()
    local source = obs.obs_get_source_by_name(source_name)
    if source then
        obs.obs_source_set_enabled(source, true)  -- Ensure source is enabled

        local minutes = math.floor(countdown / 60)
        local seconds = countdown % 60
        local timer_text = string.format("%02d:%02d", minutes, seconds)
        
        local full_text = original_text .. " " .. timer_text

        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", full_text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    else
        print("Failed to get source by name: " .. source_name)
    end
end

-- Timer callback function
function timer_callback()
    if not timer_paused and countdown > 0 then
        countdown = countdown - 1
        update_text_source()
    elseif countdown <= 0 then
        obs.script_log(obs.LOG_INFO, "Timer finished.")
        obs.timer_remove(timer_callback)
        timer_running = false

        -- Set final text without hiding the source
        local source = obs.obs_get_source_by_name(source_name)
        if source then
            local settings = obs.obs_data_create()
            obs.obs_data_set_string(settings, "text", finish_text)
            obs.obs_source_update(source, settings)
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
        end
    end
end

-- Function to toggle pause/resume the timer
function toggle_pause_timer()
    if timer_running then
        if timer_paused then
            timer_paused = false
            obs.script_log(obs.LOG_INFO, "Timer resumed.")
        else
            timer_paused = true
            obs.script_log(obs.LOG_INFO, "Timer paused.")
        end
    else
        obs.script_log(obs.LOG_WARNING, "Timer is not running.")
    end
end

-- Function to start the timer manually
function start_timer()
    if not timer_running then
        local source = obs.obs_get_source_by_name(source_name)
        if source then
            obs.obs_source_set_enabled(source, true)  -- Re-enable source before starting
            obs.obs_source_release(source)
        end
        set_timer_based_on_text()
    else
        obs.script_log(obs.LOG_WARNING, "Timer is already running.")
    end
end

-- Function to stop the timer and update text
function stop_timer()
    timer_running = false
    timer_paused = false
    countdown = 0

    local source = obs.obs_get_source_by_name(source_name)
    if source then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", finish_text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)

        obs.obs_source_release(source)
    end

    obs.timer_remove(timer_callback)
    obs.script_log(obs.LOG_INFO, "Timer stopped.")
end

-- Script description shown in OBS
function script_description()
    return "This script reads the text from a selected source and starts a countdown timer based on the last number in the text. The countdown is displayed on screen, preserving the original text. Includes buttons to start, pause/resume, and stop the timer."
end

-- Script properties
function script_properties()
    local props = obs.obs_properties_create()
    local text_sources = obs.obs_properties_add_list(props, "text_source", "Text Source", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    populate_text_sources(text_sources)

    obs.obs_properties_add_text(props, "finish_text", "Finish Text", obs.OBS_TEXT_DEFAULT)  -- Use obs_properties_add_text for custom text
    obs.obs_properties_add_button(props, "start_button", "Start Timer", start_timer)
    obs.obs_properties_add_button(props, "pause_button", "Pause/Resume Timer", toggle_pause_timer)
    obs.obs_properties_add_button(props, "stop_button", "Stop Timer", stop_timer)

    return props
end

-- Script update function
function script_update(settings)
    source_name = obs.obs_data_get_string(settings, "text_source")
    finish_text = obs.obs_data_get_string(settings, "finish_text")  -- Get the custom finish text
end

-- Script load function
function script_load(settings)
    source_name = obs.obs_data_get_string(settings, "text_source")
    finish_text = obs.obs_data_get_string(settings, "finish_text")  -- Get the custom finish text
end