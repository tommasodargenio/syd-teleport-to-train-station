--[[
     Teleport-To-Train-Station
     a Factorio mod.
     (C) SyDream - Nov 2020 - v1.0.0
     MIT License
     https://github/....repo
     https://factorio mod link   
     
    
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
