if Shared.Framework ~= "QBOX" then return end  

CreateThread(function()
    Wait(5000)

    Core.GetIdentifier = function(source)
        local Player = exports.qbx_core:GetPlayer(source)
        if not Player then return false end
        return Player.PlayerData.citizenid
    end
    
    Core.RegisterItem = function(item, func)
        exports.qbx_core:CreateUseableItem(item, function(source, item)
            func(source)
        end)
    end
    
    Core.AddCash = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(source)
        return Player.Functions.AddMoney('cash', amount)
    end
    
    Core.RemoveCash = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(source)
        return Player.Functions.RemoveMoney('cash', amount)
    end
    
    Core.GetCash = function(source)
        local Player = exports.qbx_core:GetPlayer(source)
        return Player.Functions.GetMoney('cash')
    end

    Core.GetBank = function(source)
        local Player = exports.qbx_core:GetPlayer(source)
        return Player.Functions.GetMoney('bank')
    end
    
    Core.AddBank = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(source)
        return Player.Functions.AddMoney('bank', amount)
    end

    Core.RemoveBank = function(source, amount)
        local Player = exports.qbx_core:GetPlayer(source)
        return Player.Functions.RemoveMoney('bank', amount)
    end

    Core.AddItem = function(source, item, amount)
        return exports.ox_inventory:AddItem(source, item, amount)
    end

    Core.RemoveItem = function(source, item, amount)
        return exports.ox_inventory:RemoveItem(source, item, amount)
    end

    Core.GetItemCount = function(source, item)
        return exports.ox_inventory:GetItemCount(source, item)
    end

    Core.CanCarry = function(source, item, amount)
        return exports.ox_inventory:CanCarryItem(source, item, amount)
    end

    Core.GetJob = function(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        local jobData = {
            name = xPlayer.PlayerData?.job?.name or "unemployed",
            label = xPlayer.PlayerData?.job?.label or "Unemployed",
            grade = xPlayer.PlayerData.job?.grade?.level or 0,
            onDuty = xPlayer.PlayerData?.job?.onduty or false,
        }
        return jobData
    end

    Core.GetFullName = function(source)
        local xPlayer = exports.qbx_core:GetPlayer(source)
        return xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
    end

    Core.Loaded = true
end)