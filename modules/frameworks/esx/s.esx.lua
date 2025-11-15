if Shared.Framework ~= "ESX" then return end  
ESX = nil

CreateThread(function()
    Wait(5000)
    ESX = exports["es_extended"]:getSharedObject()

    Core.GetIdentifier = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        return xPlayer.identifier
    end

    Core.RegisterItem = function(item, func)
        ESX.RegisterUsableItem(item, function(playerId)
            func(playerId)
        end)
    end

    Core.GetCash = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getMoney()
    end
    
    Core.AddCash = function(source, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(amount) 
        return true 
    end

    Core.RemoveCash = function(source, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() < amount then 
            return false
        end
        xPlayer.removeMoney(amount)
        return true
    end

    Core.GetBank = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getAccount("bank").money
    end
    
    Core.AddBank = function(source, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("bank", amount)
        return true
    end

    Core.RemoveBank = function(source, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getAccount("bank").money < amount then 
            return false
        end
        xPlayer.removeAccountMoney("bank", amount)
        return true
    end


    Core.AddItem = function(source, item, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not Core.CanCarry(source, item, amount) then
            return false
        end
        xPlayer.addInventoryItem(item, amount)
        return true
    end

    Core.RemoveItem = function(source, item, amount)
        if Core.GetItemCount(source, item) < amount then
            return false
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(item, amount)
        return true
    end
    Core.CanCarry = function(source, item, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer.canCarryItem then return true end
        return xPlayer.canCarryItem(item, amount)
    end

    Core.GetItemCount = function(source, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(item)?.count or 0
    end

    Core.GetJob = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local jobData = {
            name = xPlayer?.job?.name or "unemployed",
            label = xPlayer?.job?.label or "Unemployed",
            grade = xPlayer?.job?.grade or 0,
            onDuty = xPlayer?.job?.onDuty or true,
        }
        return jobData
    end

    Core.IsPolice = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer?.job?.name == "police" or xPlayer?.job?.name == "sheriff" or xPlayer?.job?.name == "state" then 
            return true
        end
        return false
    end

    Core.GetFullName = function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getName()
    end
    
    RegisterNetEvent("esx:playerLoaded",function(source)
        TriggerClientEvent("dh_lib:client:playerLoaded", source)
        TriggerEvent("dh_lib:server:playerLoaded", source)
    end)

    RegisterNetEvent('esx:playerDropped', function(source, reason)
        TriggerEvent("dh_lib:server:playerUnloaded", source)
        TriggerClientEvent("dh_lib:client:playerUnloaded", source)
    end)

    AddEventHandler('esx:onAddInventoryItem', function(source, itemName, itemCount)
        TriggerClientEvent("devhub_lib:itemCarry:addItem:client", source, itemName)
    end)

    AddEventHandler('esx:onRemoveInventoryItem', function(source, itemName, itemCount)
        TriggerClientEvent("devhub_lib:itemCarry:removeItem:client", source, itemName)
    end)

    Core.Loaded = true
end)