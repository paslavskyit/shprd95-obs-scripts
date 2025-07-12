obs = obslua

source_name = "-" -- Default text source name
prefix = "-" -- Default prefix text
count = 0
increment_hotkey_id = nil
decrement_hotkey_id = nil

function script_description()
    return [[
        A script to increment and decrement a death counter and save it persistently.
    ]]
end

function script_properties()
    local props = obs.obs_properties_create()
    local text_sources = obs.obs_properties_add_list(props, "text_source", "Text Source", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    populate_text_sources(text_sources)

    obs.obs_properties_add_text(props, "prefix", "Prefix Text", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_int(props, "count", "Death Count", 0, 1000000, 1)

    local support_text = obs.obs_properties_add_text(props, "support", "Support", obs.OBS_TEXT_INFO)
    obs.obs_property_set_description(support_text, "Like this script? <a href='https://www.twitch.tv/tarasavg'>Follow my Twitch channel💜 </a> or <a href='https://donatello.to/tarasavg'>tip some money💸</a>!")

    return props
end

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
end

function script_defaults(settings)
    obs.obs_data_set_default_string(settings, "text_source", "-")
    obs.obs_data_set_default_string(settings, "prefix", "-")
    obs.obs_data_set_default_int(settings, "count", 0)
end

function script_update(settings)
    local new_source_name = obs.obs_data_get_string(settings, "text_source")
    if new_source_name ~= source_name then
        source_name = new_source_name
        update_text_source()
    end

    local new_prefix = obs.obs_data_get_string(settings, "prefix")
    if new_prefix ~= prefix then
        prefix = new_prefix
        update_text_source()
    end

    local new_count = obs.obs_data_get_int(settings, "count")
    if new_count ~= count then
        count = new_count
        update_text_source()
    end
end

function update_text_source()
    local source = obs.obs_get_source_by_name(source_name)
    if source then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", prefix .. count)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    else
        print("Failed to get source by name: " .. source_name)
    end
end

function increment_death_counter(pressed)
    if pressed then
        count = count + 1
        print("Incrementing count: " .. count)
        update_text_source()
        save_counter_value()
    end
end

function decrement_death_counter(pressed)
    if pressed then
        count = count - 1
        print("Decrementing count: " .. count)
        update_text_source()
        save_counter_value()
    end
end

function save_counter_value()
    local settings = obs.obs_data_create()
    obs.obs_data_set_int(settings, "count", count)
    obs.obs_data_release(settings)
end

function script_load(settings)
    source_name = obs.obs_data_get_string(settings, "text_source")
    prefix = obs.obs_data_get_string(settings, "prefix")
    count = obs.obs_data_get_int(settings, "count")
    update_text_source()

    increment_hotkey_id = obs.obs_hotkey_register_frontend("increment_death_counter", "Increment SHPRD95's Counter", increment_death_counter)
    decrement_hotkey_id = obs.obs_hotkey_register_frontend("decrement_death_counter", "Decrement SHPRD95's Counter", decrement_death_counter)

    local hotkey_save_array = obs.obs_data_get_array(settings, "increment_hotkey_id")
    obs.obs_hotkey_load(increment_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)

    hotkey_save_array = obs.obs_data_get_array(settings, "decrement_hotkey_id")
    obs.obs_hotkey_load(decrement_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
    obs.obs_data_set_string(settings, "text_source", source_name)
    obs.obs_data_set_string(settings, "prefix", prefix)
    obs.obs_data_set_int(settings, "count", count)

    local hotkey_save_array = obs.obs_hotkey_save(increment_hotkey_id)
    obs.obs_data_set_array(settings, "increment_hotkey_id", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)

    hotkey_save_array = obs.obs_hotkey_save(decrement_hotkey_id)
    obs.obs_data_set_array(settings, "decrement_hotkey_id", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end