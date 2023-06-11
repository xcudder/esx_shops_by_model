ESX.RegisterServerCallback("esx_model_shops:register_shop", function(source, cb, id, inventory, v3)
	if GetResourceState('ox_inventory') == 'started' then
		exports.ox_inventory:RegisterShop(id, {
		    id = id,
		    name = 'Stand / Vending Machine',
		    inventory = inventory,
		    locations = { v3 },
		})
	end
	cb(true)
end)