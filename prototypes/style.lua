--[[
     Teleport-To-Train-Station
     a Factorio mod.
     (C) SyDream - Nov 2020 - v1.0.0
     MIT License
     https://github.com/tommasodargenio/syd-teleport-to-train-station
     https://mods.factorio.com/mod/syd-teleport-to-train-station
     
    
    STYLE.LUA
    -- Defining the various styles and icons used
--]]
data.raw["gui-style"].default["teleport_ts_gui_dd_filter_query"] = {
    type = "textbox_style",
    minimal_width = 70,
    maximal_width = 80
}

data:extend({
    {
        type = "shortcut",
        name = "teleport-ts-button-shortcut",
        action = "lua",
        toggleable = false,
        icon = {
            filename = "__syd-teleport-to-train-station__/graphics/icons/teleport-ts-button-icon-64.png",        
            priority = "extra-high-no-scale",
            size = 64,
            scale = 1,
            flags = { "gui-icon" }
        }        
    }
})
