--[[
     Teleport-To-Train-Station
     a Factorio mod.
     (C) SyDream - 2020 - v1.0.1
     MIT License
     https://github.com/tommasodargenio/syd-teleport-to-train-station
     https://mods.factorio.com/mod/syd-teleport-to-train-station
     
    
    SETTINGS.LUA
    -- define internal settings used by the mod  
--]]
data:extend({
	{
        type = "int-setting",
        name = "teleport-ts-x-distance-displacement",
        setting_type = "runtime-per-user",
		minimum_value = 0,
		maximum_value = 100,
        default_value = 1,
		order = "a"
    },
    {
        type = "int-setting",
        name = "teleport-ts-y-distance-displacement",
        setting_type = "runtime-per-user",
		minimum_value = 0,
		maximum_value = 100,
        default_value = 1,
		order = "b"
    },
    {
        type = "int-setting",
        name = "teleport-ts-station-list-vertical-size",
        setting_type = "runtime-per-user",
        default_value = 10,
        allowed_values = {10, 20, 30, 40},
        per_user = true,
		order = "c"
    }
})
