local Kaira = {
    _VERSION = 'Kaira 0.0.1',
    _URL = 'https://github.com/Twis7ed/Kaira',
    _DESCRIPTION = 'Anti-aimbot Lua for https://legions.win/.',
    _LICENSE = [[
        Kaira (c) by Twis7ed

        Kaira is licensed under a
        Creative Commons Attribution 1.0 Universal.

        You should have received a copy of the license along with this
        work. If not, see http://creativecommons.org/licenses/by/1.0/.
    ]]
}

local default_tab = menu.add_tab('AntiAim', 'General')
local first_default_child = default_tab:get_child('', 0)
first_default_child:set_should_show(false)
local second_default_child = default_tab:get_child('', 1)
second_default_child:set_should_show(false)

local main_tab = menu.add_tab('AntiAim', 'General')
local main_child = main_tab:add_child('Anti-aimbot', 0, 0, 0.5, 1.0)
local fakelag_child = main_tab:add_child('Fake lag', 0, 0, 1.0, 0.5, true)
local misc_child = main_tab:add_child('Misc', 0, 0, 1.0, 1.0, true)

main_child:add_text('Kaira - ' .. client.get_username())
local enable_checkbox = main_child.add_checkbox('Enable', '_ENABLE_CHECKBOX_')

local aa_conditions = { 'General', 'Stand', 'Run', 'Walk', 'Duck', 'Air' }
local aa_condition_combo = main_child:add_combo('Condition', aa_conditions, '_CONDITION_COMBO_')

local aa_condition_objects = {}
for i, condition in pairs(aa_conditions) do
    local format_string = function(string)
        return string.format('[%s] %s', condition, string)
    end

    local new_condition_objects = {
        override_general_checkbox = (i ~= 1) and main_child.add_checkbox(format_string('Override general'), format_string('_OVERRIDE_GENERAL_')),
        pitch_combo = main_child.add_combo(format_string('Pitch'), { 'Zero', 'Up', 'Down' }, format_string('_PITCH_')),
        yaw_combo = main_child.add_combo(format_string('Yaw'), { 'Forward', 'Back' }, format_string('_YAW_')),
        yaw_add_slider = main_child.add_slider_int(format_string('Yaw add'), -180, 180, 0, format_string('_YAW_ADD_')),
        spin_range_slider = main_child.add_slider_int(format_string('Spin range'), 0, 360, 0, format_string('_SPIN_RANGE_')),
        spin_speed_slider = main_child.add_slider_int(format_string('Spin speed'), 0, 100, 0, format_string('_SPIN_SPEED_')),
        jitter_range_slider = main_child.add_slider_int(format_string('Jitter range'), 0, 180, 0, format_string('_JITTER_RANGE_')),
        jitter_random_checkbox = main_child.add_checkbox(format_string('Random jitter'), format_string('_RANDOM_JITTER_')),
        desync_range_slider = main_child.add_slider_int(format_string('Desync range'), -60, 60, 0, format_string('_DESYNC_RANGE_')),
        desync_jitter_slider = main_child.add_slider_int(format_string('Desync jitter'), -60, 60, 0, format_string('_DESYNC_JITTER_')),
        slider_checkbox = main_child.add_checkbox(format_string('Slider'), format_string('_SLIDER_'))
        callback = {}
    }

    local show_bind = function(object1, object2, compare)
        local binding = function()
            local current_condition = aa_conditions[aa_condition_combo:get()] == condition
            if compare then
                object1:set_should_show(compare(object2:get()) and current_condition)
            else
                object1:set_should_show(object2:get() and current_condition)
            end
        end
    end

    aa_condition_objects[condition] = new_condition_objects
end

aa_condition_combo:add_callback(function(value)
    for  i, objects in pairs(aa_condition_objects) do
        set_table_visible(objects, aa_conditions[value +1] == i)
        for _, callback in pairs(objects.callback) do
            if callback then
                callback()
            end
        end
    end 
end, true)

local aa_refrences = {
    enable_checkbox = menu.find_control('::AntiAim;;General Enable'),
    freestanding_checkbox = menu.find_control('::AntiAim::General Freestanding'),
    offset_slider = menu.find_control('::AntiAim::General Offset'),
    sway_slider = menu.find_control('::AntiAim::General Sway'),
    sway_speed_slider = menu.find_control('::AntiAim::General Sway speed'),
    jitter_slider = menu.find_control('::AntiAim::General Jitter'),
    slider_checkbox = menu.find_control('::AntiAim::General Slide'),
    roll_checkbox = menu.find_control('::AntiAim::General Roll'),
    desync_amount_slider = menu.find_control('::AntiAim::General Desync amount'),
    desync_jitter_slider = menu.find_control('::AntiAim::General Desync jitter'),
    fakelag_checkbox = menu.find_control('::AntiAim::General Fakelag'),
    fakelag_standing_slider = menu.find_control('::AntiAim::General Standing'),
    fakelag_moving_slider = menu.find_control('::AntiAim::General Moving'),
    fakelag_in_air_slider = menu.find_control('::AntiAim::General InAir')
}

local misc_refrences = {
    slowwalk_checkbox = menu.find_control('::Misc::General::Movement SlowWalk')
}

local at_target_checkbox = misc_child.add_checkbox('At target', '_AT_TARGET_')
local freestand_checkbox = misc_child.add_checkbox('Freestand', aa_refrences.freestanding_checkbox)

client.add_callback('on_create_move', function(cmd)
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end 

    local condition = 'General'
    local buttons = cmd:buttons()
    local on_ground = bit.band(local_player:get_prop('m_fFlags') or 0, 1) == 1
    local velocity = math.vector(local_player:get_prop('m_vecVelocity[0]') or 0, local_player:get_prop('m_vecVelocity[1]') or 0, local_player:get_prop('m_vecVelocity[2]') or 0)
    local speed = velocity:length_2d()
    local crouching = bit.band(buttons)
end)
