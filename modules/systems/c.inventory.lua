CreateThread( function()  
    if Shared.InventorySystem == "ox_inventory" then
        Core.GetItemData = function(itemName) 
            local itemData = exports.ox_inventory:Items(itemName)
            return { 
                name = itemName,
                label = itemData?.label,
                img = string.format("https://cfx-nui-ox_inventory/web/images/%s.png", itemName),
            }
        end
    elseif Shared.InventorySystem == "qb-inventory" then
        local inventoryQBCore = exports['qb-core']:GetCoreObject()
        Core.GetItemData = function(itemName) 
            local itemData = inventoryQBCore.Shared.Items[itemName]
            return { 
                name = itemName,
                label = itemData?.name,
                img = string.format("https://cfx-nui-qb-inventory/html/images/%s", itemData?.image),
            }
        end
    elseif Shared.InventorySystem == "custom" then
        Core.GetItemData = function(itemName) 
            local itemData = {
                label = itemName,
                image = itemName .. ".png",
            }
            return { 
                name = itemName,
                label = itemData?.label,
                img = string.format("https://cfx-nui-custom-inventory/html/images/%s", itemData?.image),
            }
        end
    else
        Debug("Error", "Invalid inventory system selected")
    end

end)