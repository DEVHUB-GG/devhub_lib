if Shared.InventorySystem ~= "ak47_inventory" then return end  

Core.GetItemData = function(itemName) 
    local item = exports['ak47_inventory']:Items(itemName)
    return { 
        name = itemName,
        label = item.label or itemName,
        img = item.img or ('nui://ak47_inventory/html/img/%s.png'):format(itemName),
    }
end


RegisterNetEvent('ak47_inventory:onEquipWeapon', function(currentWeapon)
    --TODO if you have this inventory and need help, open a ticket  

    -- local metadata = data?.metadata
    -- TriggerEvent("devhub_lib:client:currentWeapon", {
    --     weapon = data.name,
    --     metadata = metadata,
    -- })
end)

RegisterNetEvent('ak47_inventory:onUnEquipWeapon', function(currentWeapon)
    TriggerEvent("devhub_lib:client:currentWeapon")
end)

LoadedSystems['inventory'] = true