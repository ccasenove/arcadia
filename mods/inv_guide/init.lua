local modpath = minetest.get_modpath(minetest.get_current_modname())

inv_guide = {
	tab = 1,
	player_recipes = {} -- table indexed by player name
}

local function get_item_recipes(item_name)
	local item_recipes = {}
	for i, recipe in ipairs(minetest.get_all_craft_recipes(item_name) or {}) do
		if recipe.method ~= "normal" then
			table.insert(item_recipes, recipe)
		end
	end

	return item_recipes
end

local function get_all_item_names()
	local item_names = {}
	for item_name,_ in pairs(minetest.registered_items) do
		if item_name ~= "" then
			table.insert(item_names, item_name)
			local item_recipes = get_item_recipes(item_name)
			if #item_recipes > 0 then
				table.insert(item_names, item_name)
			end
		end	
	end
end

local function build_items_formspec()
	get_all_item_names()

	return ""
end

local function build_craft_formspec()
	local formspec = ""

	for k,v in pairs(minetest.registered_items) do
		if k ~= "" then
			local recipes = minetest.get_all_craft_recipes(k)
			if recipes and #recipes > 0 then
				local recipe = recipes[1]
				if recipe.method == "normal" then
					print(dump(recipe))
					for i, item in ipairs(recipe.items) do
						print(i)
						print(dump(item))
						formspec = formspec..string.format("item_image_button[%d,%d;1,1;%s;%s;a]",
							math.floor((i-1) / 3), (i-1) % 3, item, item)
					end
				end
			end
		end 
	end

	return formspec
end

local function build_formspec(tab)
	local formspec = "size[8,8] real_coordinates[true]"
	if tab == 1 then
		formspec = formspec .. "list[current_player;main;0,0;8,1]"
	elseif tab == 2 then
		formspec = formspec .. build_items_formspec()
	end
	formspec = formspec .. "tabheader[0,0;tab;Craft,Guide,Equipement;" .. tab .. "]"
	
	return formspec
end

--[[
minetest.register_on_joinplayer(function(player)
	player:set_inventory_formspec(build_formspec(1))
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" then
		return false
	end

	if fields.tab then
		inv_guide.tab = tonumber(fields.tab)
		player:set_inventory_formspec(build_formspec(inv_guide.tab))
	end
end)
]]

minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
	print("register_craft_predict -------------")
	print("name: "..itemstack:get_name())
	local player_meta = player:get_meta()
	local player_items = minetest.deserialize(player_meta:get_string("invguide:items")) or {}
	if not player_items[itemstack:get_name()] then
		itemstack:clear()
	end
end)

minetest.register_chatcommand("unlock_craft", {
	func = function(playername, itemname)
		local player = minetest.get_player_by_name(playername)
		local player_meta = player:get_meta()
		local player_items = minetest.deserialize(player_meta:get_string("invguide:items")) or {}
		player_items[itemname] = true
		player_meta:set_string("invguide:items", minetest.serialize(player_items))
		return true
	end
})