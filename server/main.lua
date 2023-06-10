RegisterNetEvent("esx_model_shops:register_shop")
AddEventHandler("esx_model_shops:register_shop", function(name, inventory, v3)
	local created_shop
	if Config.debug then ESX.ShowNotification("Server side got event") end
	if GetResourceState('ox_inventory') == 'started' then
		created_shop = exports.ox_inventory:RegisterShop({
		    name = name,
		    inventory = Config[inventory_key],
		    locations = { v3 },
		})
	end
	if Config.debug then ESX.ShowNotification(json.encode(created_shop)) end
end