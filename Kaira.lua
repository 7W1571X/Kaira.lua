local Kaira = {
    _VERSION       = 'Kaira 0.0.1',
    _LINK          = 'https://github.com/Twis7ed/Kaira',
    _DESCRIPTION   = 'Anti-aimbot Lua for https://legions.win/.',
    _LICENSE       = [[
        Kaira (c) by Twis7ed

        Kaira is licensed under a
        Creative Commons Attribution 1.0 Universal.

        You should have received a copy of the license along with this
        work. If not, see http://creativecommons.org/licenses/by/1.0/.
    ]]
}

local set_table_visible = function(table, show_flag)
    for _, object in pairs(table) do
        object:set_should_show(show_flag)
    end
end

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
local enable_checkbox = main_child.add_checkbox('Enable', '_AA_ENABLE_CHECKBOX_')

local aa_conditions = { 'General', 'Stand', 'Run', 'Walk', 'Duck', 'Air' }
local aa_condition_combo = main_child:add_combo('Condition', aa_conditions, '_AA_CONDITION_COMBO_')

local aa_condition_objects = {}
for i, condition in pairs(aa_conditions) do
    local format_name = function(name)
        return string.format('[%s] %s', condition, name)
    end

    local new_condition_objects = {
        override_general = (i ~= 1) and main_child.add_checkbox(format_name('Override general'), '_AA_OVERRIDE_GENERAL_',)
        pitch = main_child.add_combo(format_name('Pitch'), { 'Zero', 'Up', 'Down' }, '_AA_PITCH_'),
        yaw = main_child.add_combo(format_name('Yaw'), { 'Forward', 'Back' }, '_AA_YAW_'),
        yaw_add = main_child.add_slider_int(format_name('Yaw add'), -180, 180, 0, '_AA_YAW_ADD_'),
        spin_range = main_child.add_slider_int(format_name('Spin range'), 0, 360, 0, '_AA_SPIN_RANGE_'),
        spin_speed = main_child.add_slider_int(format_name('Spin speed'), 0, 100, 0, '_AA_SPIN_SPEED_'),
        jitter_range = main_child.add_slider_int(format_name('Jitter range'), 0, 180, 0, '_AA_JITTER_RANGE_'),
        jitter_random_checkbox = main_child.add_checkbox(format_name('Random jitter'), '_AA_RANDOM_JITTER_'),
        callback = {}
    }

    aa_condition_objects[condition] = new_condition_objects
end

aa_condition_combo:add_callback(function(value))
    for  i, objects in pairs(aa_condition_objects) do
        set_table_visible(objects, aa_conditions[value +1] == i)
        for _, callback in pairs(objects.callback) do
            if callback then
                callback()
            end
        end
    end 
end, true)

local freestand = main_child.add_checkbox('Freestand', '_AA_FREESTAND_')
