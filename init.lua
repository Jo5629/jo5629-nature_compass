local biomes_table, biome_pos, biome_name = {}, "", ""
local index = 1

local function get_formspec()
    local formspec = {
        "formspec_version[4]",
        "size[8,5]",
        "label[0.375,0.5;Nature Compass]",
        "dropdown[0.375,1;4,1;biomes_list;" .. table.concat(biomes_table, ",") ..";" .. index .. "]",
        "button[0.8,3;3,1.5;locate;Locate]",
        "textarea[4.6,2;3,3;;Biome Found:;" .. biome_pos .."]",
    }
    return table.concat(formspec, "")
end

local function biome_waypoint(player_obj, pos, name)
    name = name or "Located Biome"
    return player_obj:hud_add({
        hud_elem_type = "waypoint",
        name = name,
        text = "m",
        number = 0x85FF00,
        world_pos = pos,
    })
end

minetest.register_tool("nature_compass:compass", {
    description = "Nature Compass",
    inventory_image = "nature_compass.png",
    on_use = function(itemstack, user, pointed_thing)
        local success, biomes = findbiome.list_biomes()
        if success then
            biomes_table = biomes
        end
        minetest.show_formspec(user:get_player_name(), "nature_compass:compass", get_formspec())
    end,
    on_rightclick = function(itemstack, placer, pointed_thing)
        local id = biome_waypoint(placer, minetest.string_to_pos(biome_pos), biome_name)
        minetest.after(15, function()
            placer:hud_remove(id)
        end)
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "nature_compass:compass" then
        return
    end
    if fields.locate then
        local pos, success = findbiome.find_biome(player:get_pos(), {fields.biomes_list})
        if success then
            biome_pos = minetest.pos_to_string(pos, 1)
            biome_name = fields.biomes_list
            local id = biome_waypoint(player, pos, biome_name)
            minetest.after(10, function()
                player:hud_remove(id)
            end)
            for i = 1, #biomes_table do
                if biomes_table[i] == biome_name then
                    index = i
                    break
                end
            end
        else
            biome_pos = minetest.colorize("#FF0000", "ERROR")
        end
        minetest.show_formspec(player:get_player_name(), "nature_compass:compass", get_formspec())
    end
end)

dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/crafts.lua")