--[[
     Teleport-To-Train-Station
     a Factorio mod.
     (C) SyDream - 2020 - v1.0.1
     MIT License
     https://github.com/tommasodargenio/syd-teleport-to-train-station
     https://mods.factorio.com/mod/syd-teleport-to-train-station
     
    
    CONTROL.LUA
    -- Core of the mod includes all the runtime scripting
--]]
teleport_ts_win = {type="frame",  name="teleport-ts-gui", direction="vertical", header_filler_style={type="empty_widget_style", parent="draggable_space_header", height=24}, use_header_filler=true}

train_station_filter = ""
teleport_gui = nil
gui_location = nil


function train_station_teleport(player_idx, station_selected)
    local train_stations_list = get_train_stations_list()
    local train_station_position = nil
    local player = game.players[player_idx]
    local destination_surface = game.surfaces["nauvis"]
    local destination_pos = nil
    if (station_selected > table_size(train_stations_list)) then return end
   
    train_station_position = train_stations_list[station_selected].position

    if train_station_position ~= nil then 
        if player.vehicle and player.vehicle.valid and player.vehicle.type=="spider-vehicle" then
            player.surface.play_sound({path="utility/cannot_build"})
        elseif player.vehicle and player.vehicle.valid and player.vehicle.type=="car" then
            if math.floor(player.vehicle.position.x + 0.5) ~= math.floor(train_station_position.x + 0.5) or
               math.floor(player.vehicle.position.y + 0.5) ~= math.floor(train_station_position.y + 0.5) then
                destination_pos = destination_surface.find_non_colliding_position(player.vehicle.prototype.name, train_station_position, 10, 1)
                if not destination_pos then destination_pos = train_station_position end                
                player.vehicle.teleport(destination_pos, destination_surface)
            end
        elseif player.character and player.character.valid then
			if math.floor(player.position.x + 0.5) ~= math.floor(train_station_position.x + 0.5) or
               math.floor(player.position.y + 0.5) ~= math.floor(train_station_position.y + 0.5) then
                destination_pos =  destination_surface.find_non_colliding_position(player.character.prototype.name, train_station_position, 10, 1)
                if not  destination_pos then  destination_pos = train_station_position end
                player.teleport(destination_pos, destination_surface)
            end
        elseif player and player.valid then
			player.teleport(train_station_position)            
        end
    end    
end


function get_train_stations_list(train_filter) 
    local train_stations = {}
    local train_stations_ordered = {}
    local train_station_names = {}
    local surface = game.surfaces["nauvis"]
    local t = surface.get_train_stops()

    for _, train_station in pairs(t) do
        table.insert(train_stations, {name=train_station.backer_name, position=train_station.position})
        table.insert(train_station_names, train_station.backer_name)
    end
    table.sort(train_station_names)

    for _, name in pairs(train_station_names) do 
        for _, train_station in pairs(train_stations) do 
            if (train_station.name == name) then
                if (train_filter and train_filter ~= "") then 
                    if (string.match(train_station.name:lower(), train_filter:lower())) then
                        table.insert(train_stations_ordered, train_station)
                    end
                else
                    table.insert(train_stations_ordered, train_station)
                end
                
                break
            end
        end
    end

    return train_stations_ordered
end

function get_train_stations_name(train_stations_list)
    local train_stations_names = {}

    if (table_size(train_stations_list)>0) then
        for _, train_station in pairs(train_stations_list) do
            table.insert(train_stations_names, train_station.name)
        end 
    end
    return train_stations_names
end


function teleport_ts_shortcut(event) 
    if event.prototype_name == "teleport-ts-button-shortcut" then
        on_hotkey_main(event)
    end
end

function on_hotkey_main(event)
    local gui = game.players[event.player_index].gui
    if not gui.screen["teleport-ts-gui"] then       
        teleport_gui_draw(gui,get_train_stations_name(get_train_stations_list()), false, true)
    end    
end



function teleport_gui_draw(gui,train_stations_list,filter_toggle,firstLoad)
    
    local teleport_ts_btn = {type="button", name="teleport-ts-gui-btn", caption={"mod-interface.teleport-ts-button"}}

    teleport_gui = gui.screen.add(teleport_ts_win)

    local title_flow = teleport_gui.add{type = "flow", name="title_flow"}
    local title = title_flow.add{type = "label", name="teleport-ts-gui-title-label", caption={"mod-interface.teleport-ts-gui-title-caption"}, style="frame_title"}
    title.drag_target = teleport_gui

    local pusher = nil
    pusher = title_flow.add{type = "empty-widget", name="teleport-ts-gui-draggable-space-header",style="draggable_space_header"}
    pusher.style.vertically_stretchable = true
    pusher.style.horizontally_stretchable = true
    pusher.drag_target = teleport_gui

    if (filter_toggle == true) then
        title_flow.add{type="textfield", name="teleport-ts-gui-dd-filter-query", style="teleport_ts_gui_dd_filter_query"}
        title_flow["teleport-ts-gui-dd-filter-query"].focus()
        title_flow["teleport-ts-gui-dd-filter-query"].text = train_station_filter
    end

    title_flow.add{type="sprite-button", style="frame_action_button", sprite="utility/search_white", name="teleport-ts-gui-toggle-filter"}
    title_flow.add{type="sprite-button", style="frame_action_button", sprite="utility/close_white", name="close-teleport-ts-window"}

    if (table_size(train_stations_list)>0) then
        local teleport_ts_dropdown = {type="drop-down", name="teleport-ts-gui-dd", items=train_stations_list, selected_index=1}
        local dd_flow = teleport_gui.add{type="flow", name="dd_flow"}            
        dd_flow.add{type="label", name="teleport-ts-gui-dd-label", caption={"mod-interface.teleport-ts-gui-dd-caption"}}
        dd_flow.add(teleport_ts_dropdown)
        dd_flow.add(teleport_ts_btn)      
    else 
        local dd_flow = teleport_gui.add{type="flow", name="dd_flow"}
        dd_flow.add{type="label",  caption={"mod-interface.teleport-ts-gui-dd-empty-caption"}}
    end 
    
    if (firstLoad==true) then  
        teleport_gui.location = {300, 250}    
    elseif (gui_location ~= nil) then 
        teleport_gui.location = gui_location
    end
end


function guiElementContains(haystack, needle)
    for _, item in pairs(haystack) do
        if (item.name==needle) then 
            return true        
        end 
    end  
    return false
end

function cleanGUI()
    local screenGui = game.players[1].gui.screen
    if table_size(screenGui.children)>0 then      
        if screenGui["teleport-ts-gui"] ~= nil then   
            local leftoverTSGui = screenGui.children[1]
            leftoverTSGui.destroy()
        end
    end    
    train_station_filter = ""
end

function resyncTeleportGui(player_index)
    if game.players[player_index].gui.screen["teleport-ts-gui"] ~= nil then
        teleport_gui = game.players[player_index].gui.screen["teleport-ts-gui"]
    end
end


script.on_event(defines.events.on_gui_text_changed, function(event)
    if (event.element.name=="teleport-ts-gui-dd-filter-query") then         
        train_station_filter = event.element.text
        gui_location = teleport_gui.location
        teleport_gui.destroy()
        local gui = game.players[event.player_index].gui
        teleport_gui_draw(gui,get_train_stations_name(get_train_stations_list(train_station_filter)), true, false)        
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    resyncTeleportGui(event.player_index)
    if (event.element.name=="teleport-ts-gui-btn") then
        local gui_win = game.players[event.player_index].gui.screen["teleport-ts-gui"]
        train_station_teleport(event.player_index, gui_win.dd_flow["teleport-ts-gui-dd"].selected_index)    
    elseif (event.element.name=="teleport-ts-gui-toggle-filter") then
		game.players[event.player_index].print("toggle filter")
        local gui_win = game.players[event.player_index].gui.screen["teleport-ts-gui"].title_flow
        if (guiElementContains(gui_win.children, "teleport-ts-gui-dd-filter-query")) then
			game.players[event.player_index].print("contains")
            gui_location = teleport_gui.location
            teleport_gui.destroy()
            local gui = game.players[event.player_index].gui
            teleport_gui_draw(gui,get_train_stations_name(get_train_stations_list()), false, false)
        else
			game.players[event.player_index].print("not contains")
            gui_location = teleport_gui.location
            teleport_gui.destroy()
            local gui = game.players[event.player_index].gui
            teleport_gui_draw(gui,get_train_stations_name(get_train_stations_list(train_station_filter)), true, false)            
        end
    elseif (event.element.name=="close-teleport-ts-window") then
        if (teleport_gui ~= nil) then 
            teleport_gui.destroy()
            train_station_filter = ""
        else 
            cleanGUI()
        end
    elseif (event.element.name=="toggleTeleportTS") then
        local gui = game.players[event.player_index].gui
        if not gui.screen["teleport-ts-gui"] then       
            teleport_gui_draw(gui,get_train_stations_name(get_train_stations_list()), false, true)
        end        
    end    
end)

script.on_configuration_changed(function (changes)
    cleanGUI() 
end)

script.on_event("teleport-to-train-station-hotkey", on_hotkey_main)

script.on_event(defines.events.on_lua_shortcut, teleport_ts_shortcut)