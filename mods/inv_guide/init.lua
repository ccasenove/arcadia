local modpath = minetest.get_modpath(minetest.get_current_modname())

inv_guide = {
	tab = 1
}

local function build_formspec(tab)
	local formspec = "size[8,8] real_coordinates[true]"
	if tab == 1 then
		formspec = formspec .. "list[current_player;main;0,0;8,1]"
	elseif tab == 2 then
		formspec = formspec .. "label[0,4;Here]"
	end
	formspec = formspec .. "tabheader[0,0;tab;Craft,Guide,Equipement;" .. tab .. "]"
	
	return formspec
end

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