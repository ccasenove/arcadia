craft_enabler = {}

function craft_enabler.enable_item(player_name, item_name)
    local player = minetest.get_player_by_name(player_name)
    local player_meta = player:get_meta()
    local player_items = minetest.deserialize(player_meta:get_string("invguide:items")) or {}
    player_items[item_name] = true
    player_meta:set_string("invguide:items", minetest.serialize(player_items))
end

minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
	print("register_craft_predict -------------")
	print("name: "..itemstack:get_name())
	local player_meta = player:get_meta()
	local player_items = minetest.deserialize(player_meta:get_string("invguide:items")) or {}
	if not player_items[itemstack:get_name()] then
		itemstack:clear()
	end
end)

minetest.register_chatcommand("enable_craft", {
	func = function(player_name, item_name)
		craft_enabler.enable_item(player_name, item_name)
		return true
	end
})
