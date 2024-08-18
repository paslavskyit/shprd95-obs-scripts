obs = obslua

source_name = "-" -- Default text source name
prefix = "-" -- Default prefix text
count = 0
increment_hotkey_id = nil
decrement_hotkey_id = nil

function script_description()
    return "A script to increment and decrement a death counter and save it persistently."
end

function script_properties()
    local props = obs.obs_properties_create()

    -- Dropdown for source name
    local source_list = obs.obs_properties_add_list(props, "source_name", "Text Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    populate_source_list(source_list)

    -- Input for prefix text
    obs.obs_properties_add_text(props, "prefix", "Prefix Text", obs.OBS_TEXT_DEFAULT)

    -- Input for death count
    obs.obs_properties_add_int(props, "count", "Death Count", 0, 1000000, 1)
    
    return props
end

function populate_source_list(source_list)
    -- Clear existing items
    obs.obs_property_list_clear(source_list)

    -- Get all sources from the current scene collection
    local scenes = obs.obs_frontend_get_scene_collections()
    for _, scene_name in ipairs(scenes) do
        local scene = obs.obs_get_source_by_name(scene_name)
        if scene then
            local sources = obs.obs_source_enum_sources(scene)
            for _, source in ipairs(sources) do
                if obs.obs_source_get_type(source) == obs.OBS_SOURCE_TYPE_INPUT then
                    local source_type = obs.obs_source_get_type(source)
                    if source_type == obs.OBS_SOURCE_TYPE_TEXT then
                        local name = obs.obs_source_get_name(source)
                        obs.obs_property_list_add_string(source_list, name, name)
                    end
                end
            end
            obs.obs_source_list_release(sources)
            obs.obs_source_release(scene)
        end
    end
end

function script_update(settings)
    source_name = obs.obs_data_get_string(settings, "source_name")
    prefix = obs.obs_data_get_string(settings, "prefix")
    count = obs.obs_data_get_int(settings, "count")
    update_text_source()
end

function update_text_source()
    local source = obs.obs_get_source_by_name(source_name)
    if source then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", prefix .. count)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
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
    local settings = obs.obs_data_create()
    obs.obs_data_set_int(settings, "count", count)
    obs.obs_data_release(settings)
end

function script_load(settings)
    source_name = obs.obs_data_get_string(settings, "source_name")
    prefix = obs.obs_data_get_string(settings, "prefix")
    count = obs.obs_data_get_int(settings, "count")
    update_text_source()

    increment_hotkey_id = obs.obs_hotkey_register_frontend("increment_death_counter", "Increment Death Counter", increment_death_counter)
    decrement_hotkey_id = obs.obs_hotkey_register_frontend("decrement_death_counter", "Decrement Death Counter", decrement_death_counter)

    local hotkey_save_array = obs.obs_data_get_array(settings, "increment_hotkey_id")
    obs.obs_hotkey_load(increment_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)

    hotkey_save_array = obs.obs_data_get_array(settings, "decrement_hotkey_id")
    obs.obs_hotkey_load(decrement_hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
    obs.obs_data_set_string(settings, "source_name", source_name)
    obs.obs_data_set_string(settings, "prefix", prefix)
    obs.obs_data_set_int(settings, "count", count)

    local hotkey_save_array = obs.obs_hotkey_save(increment_hotkey_id)
    obs.obs_data_set_array(settings, "increment_hotkey_id", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)

    hotkey_save_array = obs.obs_hotkey_save(decrement_hotkey_id)
    obs.obs_data_set_array(settings, "decrement_hotkey_id", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end