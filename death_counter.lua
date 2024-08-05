obs = obslua

-- Text source name
source_name = "DeathCounter"

-- File path to save the counter value
file_path = "D:/Video Projects/OBS_Files/Scripts/death_counter.txt"

-- Death counter value
counter = 0

-- Function to update the text source
function update_counter()
    local source = obs.obs_get_source_by_name(source_name)
    if source then
        local settings = obs.obs_data_create()
        local display_text = "Deaths: " .. tostring(counter) -- Full text with prefix
        obs.obs_data_set_string(settings, "text", display_text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

-- Function to save the counter value to a file
function save_counter()
    local file, err = io.open(file_path, "w")
    if file then
        file:write(tostring(counter)) -- Save only the counter value
        file:close()
    else
        print("Error opening file for writing: " .. err)
    end
end

-- Function to load the counter value from a file
function load_counter()
    local file, err = io.open(file_path, "r")
    if file then
        local value = file:read("*n") -- Read the numeric value
        if value then
            counter = value
        end
        file:close()
    else
        print("Error opening file for reading: " .. err)
    end
end

-- Function to handle increment key press
function increment_hotkey_callback(pressed)
    if pressed then
        counter = counter + 1
        update_counter()
        save_counter()
    end
end

-- Function to handle decrement key press
function decrement_hotkey_callback(pressed)
    if pressed then
        if counter > 0 then
            counter = counter - 1
            update_counter()
            save_counter()
        end
    end
end

-- Script description
function script_description()
    return "Increments or decrements a text source each time the hotkey is pressed, with a prefix. Saves and loads the counter value from a file."
end

-- Function to load script settings
function script_load(settings)
    increment_hotkey_id = obs.obs_hotkey_register_frontend("increment_death_counter", "Increment Death Counter", increment_hotkey_callback)
    decrement_hotkey_id = obs.obs_hotkey_register_frontend("decrement_death_counter", "Decrement Death Counter", decrement_hotkey_callback)

    local increment_hotkey_save_array = obs.obs_data_get_array(settings, "increment_death_counter")
    obs.obs_hotkey_load(increment_hotkey_id, increment_hotkey_save_array)
    obs.obs_data_array_release(increment_hotkey_save_array)

    local decrement_hotkey_save_array = obs.obs_data_get_array(settings, "decrement_death_counter")
    obs.obs_hotkey_load(decrement_hotkey_id, decrement_hotkey_save_array)
    obs.obs_data_array_release(decrement_hotkey_save_array)

    load_counter() -- Load the counter value from the file
    update_counter() -- Update the text source with the loaded counter value
end

-- Function to save script settings
function script_save(settings)
    local increment_hotkey_save_array = obs.obs_hotkey_save(increment_hotkey_id)
    obs.obs_data_set_array(settings, "increment_death_counter", increment_hotkey_save_array)
    obs.obs_data_array_release(increment_hotkey_save_array)

    local decrement_hotkey_save_array = obs.obs_hotkey_save(decrement_hotkey_id)
    obs.obs_data_set_array(settings, "decrement_death_counter", decrement_hotkey_save_array)
    obs.obs_data_array_release(decrement_hotkey_save_array)

    save_counter() -- Save the counter value to the file
end

-- Function to set script defaults
function script_defaults(settings)
    obs.obs_data_set_default_int(settings, "counter", 0)
end