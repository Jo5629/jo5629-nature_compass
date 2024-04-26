local input = nil
if minetest.get_modpath("default") then
    input = "default:mese_crystal_fragment"
end
if minetest.get_modpath("nextgen_compass") then
    input = "nextgen_compass:compass"
end

if input == nil then return end
minetest.register_craft({
    output = "nature_compass:compass",
    recipe = {
        {"", "group:tree", ""},
        {"group:tree", input, "group:tree"},
        {"", "group:tree", ""}
    }
})