--[[
     Teleport-To-Train-Station
     a Factorio mod.
     (C) SyDream - 2020 - v1.0.1
     MIT License
     https://github.com/tommasodargenio/syd-teleport-to-train-station
     https://mods.factorio.com/mod/syd-teleport-to-train-station
     
    
    DATA.LUA
    -- Defining the mod prototypes
--]]
local mod_path = "__syd-teleport-to-train-station__/"
require(mod_path.."prototypes/style.lua")


data:extend({
	{
        type = "custom-input",
        name = "teleport-to-train-station-hotkey",		
        key_sequence = "CONTROL + SHIFT + ALT + X",
        consuming = "none",
        order = "a"
    },    

})
