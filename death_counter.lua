obs = obslua
source_name = "DeathCounter"
file_path = "D:/Video Projects/OBS_Files/Scripts/death_counter.txt"

count = 0
increment_hotkey_id = nil
decrement_hotkey_id = nil

function script_description()
    return "A script to increment and decrement a death counter and save it to a file."
end

function update_text_source()
    local source = obs.obs_get_source_by_name(source_name)
    local settings = obs.obs_data_create()
    obs.obs_data_set_string(settings, "text", "Deaths: " .. count)
    obs.obs_source_update(source, settings)
    obs.obs_data_release(settings)
    obs.obs_source_release(source)
end

function increment_death_counter(pressed)
    if pressed then
        count = count + 1
        update_text_source()
        save_counter_value()
    end
end

function decrement_death_counter(pressed)
    if pressed then
        count = count - 1
        update_text_source()
        save_counter_value()
    end
end

function save_counter_value()
    local file = io.open(file_path, "w")
    if file then
        file:write("Deaths: " .. count)
        file:close()
    end
end

function load_counter_value()
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*all")
        count = tonumber(content:match("Deaths: (%d+)")) or 0
        file:close()
    end
end

function script_load(settings)
    load_counter_value()
    update_text_source()

    increment_hotkey_id = obs.obs_hotkey_register_frontend("increment_death_counter", "Increment Death Counter", increment_death_counter)
    decrement_hotkey_id = obs.obs_hotkey_register_frontend("decrement_death_counter", "Decrement Death Counter", decrement_death_counter)
    
    local hotkey_save_array = obs.obs_data_get_array(settings, "increment_death_counter")
    obs.obs_hotkey_load(increment_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)

    hotkey_save_array = obs.obs_data_get_array(settings, "decrement_death_counter")
    obs.obs_hotkey_load(decrement_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
    local hotkey_save_array = obs.obs_hotkey_save(increment_hotkey_id)
    obs.obs_data_set_array(settings, "increment_death_counter", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)

    hotkey_save_array = obs.obs_hotkey_save(decrement_hotkey_id)
    obs.obs_data_set_array(settings, "decrement_death_counter", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

function script_defaults(settings)
    obs.obs_data_set_default_int(settings, "count", 0)
end