local x, y, z
local pped
local current_shop_id = false
local created_shops = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	Citizen.CreateThread(function() -- continuously scour for props, this can be more spaced
		pped = PlayerPedId()
		while true do
			debug_message("Checking player surroundings... ")
			Wait(1000)
			if IsPedOnFoot(pped) then
				x, y, z = table.unpack(GetEntityCoords(pped))
				check_for_store_props()
			end
		end
	end)

	Citizen.CreateThread(function() -- offer interactivity when proper
		while true do
			Wait(0)
			if IsPedOnFoot(pped) and current_shop_id then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to interact")

				if(IsControlJustReleased(1, 38)) then
					debug_message("Tried to open " .. current_shop_id)
					exports.ox_inventory:openInventory('shop', {id = current_shop_id , type = current_shop_id })
				end
			end
		end
	end)
end)

-- two main functions
function check_for_store_props()
	local shop_type = ''
	local shop_prop, close_by_shop = false, false

	for type_index = 1, #Config.shop_types do
		shop_type = Config.shop_types[type_index]

		for prop_index = 1, #Config[shop_type] do
			shop_prop = GetClosestObjectOfType(x, y, z, 0.85, Config[shop_type][prop_index])

			if (shop_prop ~= 0) then
				if not current_shop_id or (current_shop_id ~= p_to_id(shop_prop)) then --no shop or new shop
					close_by_shop = get_or_create_shop(shop_prop, shop_type)
					current_shop_id = close_by_shop
				elseif current_shop_id and (current_shop_id == p_to_id(shop_prop)) then -- same shop
					close_by_shop = current_shop_id
				end
			end
		end
	end

	if not close_by_shop then current_shop_id = false end
end

function get_or_create_shop(shop_prop, shop_type)
	local id = p_to_id(shop_prop)
	debug_message("get or create shop (" .. id .. ")")
	if created_shops[id] then return id end

	ESX.TriggerServerCallback('esx_model_shops:register_shop', function(success)
		created_shops[id] = true
	end, id, Config[shop_type .. "_items"]) --id, inventory and coords

	if not created_shops[id] then Wait(100) end -- wait on callback

	debug_message("created a shop (" .. id .. ")", 500)

	return id
end

-- helpers
function debug_message(msg, timing)
	if not timing then timing = 500 end
	if(Config.debug) then
		ESX.ShowNotification(msg)
		Wait(timing)
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function p_to_id(shop_prop)
	return "id_" .. tostring(shop_prop)
end