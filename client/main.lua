local used_v3s = {}

Citizen.CreateThread(function()
    debug_message("Started main thread")
    local pped = PlayerPedId()
    while true do
        Wait(5000) -- check every 5 seconds
        if IsPedOnFoot(pped) then
            debug_message("Check!")
            check_for_store_props()
        end
    end
end)

function check_for_store_props()
    debug_message("Checking for store props close by")
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    debug_message("Player is at " .. x .. " , " .. y .. " , " .. z)
    local shop_type = ''
    for is = 1, #Config.shop_types do
        shop_type = Config.shop_types[is]
        debug_message("Looking for type: " .. shop_type)

        for i = 1, #Config[shop_type] do
            debug_message("Looking for model: " .. Config[shop_type][i])
            shop = GetClosestObjectOfType(x, y, z, 200.0, Config[shop_type][i])
            if(shop ~= 0) then
                debug_message("Prop found for type: " .. shop_type .. ", model: " .. Config[shop_type][i])
                create_shop(shop, shop_type)
            end
        end
    end
end

function create_shop(shop, shop_type)
    local inventory_key = shop_type .. "_items"
    local v3 = GetEntityCoords(shop)
    debug_message("Shop at: " .. v3)

    if table_contains(used_v3s, v3) then return end
    debug_message("Proper unused coordinates")

    local name = 'Vending Machine'
    local blip_id = 374
    
    if shop_type == 'fruits' or shop_type == 'sandwiches' then
        name = 'Goods Stand'
        blip_id = 473
    end

    setupBlip({ title="Goods Stand", colour=69, id=blip_id }, v3)
    debug_message("Blip configured, About to create ox inventory shop")
    TriggerServerEvent('esx_model_shops:register_shop', 'Goods Stand', Config[inventory_key], v3)
    table.insert(used_v3s, v3)
end

function setupBlip(info, v3)
    info.blip = AddBlipForCoord(v3.x, v3.y, v3.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.9)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
end

function debug_message(msg)
    if(Config.debug) then
        ESX.ShowHelpNotification(msg)
        Wait(1000)
    end
end

function table_contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end