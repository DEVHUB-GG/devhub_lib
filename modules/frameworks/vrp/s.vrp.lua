if Shared.Framework ~= "VRP" then return end  

-- Before using vRP make sure to uncomment @vrp/lib/utils.lua in fxmanifest.lua !!!
-- vRP support is currently in beta. Please report any issues you encounter, check before using in production environments.

CreateThread(function()
    Wait(5000)
    local Tunnel = module("vrp", "lib/Tunnel")
    local Proxy = module("vrp", "lib/Proxy")
    
    vRP = Proxy.getInterface("vRP")

    Core.GetIdentifier = function(source)
        return vRP.getUserId({source})
    end
    
    Core.RegisterItem = function(item, func)
        vRP.defInventoryItem(
            item, 
            "",
            item..".png",
            function(source)
                local user_id = vRP.getUserId({source})
                if user_id then
                    func(source)
                end
            end
        )
    end
    
    Core.AddCash = function(source, amount)
        local user_id = vRP.getUserId({source})
        return vRP.giveMoney(user_id, amount)
    end
    
    Core.RemoveCash = function(source, amount)
        local user_id = vRP.getUserId({source})
        return vRP.tryPayment(user_id, amount)
    end
    
    Core.GetCash = function(source)
        local user_id = vRP.getUserId({source})
        return vRP.getMoney(user_id)
    end

    Core.GetBank = function(source)
        local user_id = vRP.getUserId({source})
        return vRP.getBankMoney(user_id)
    end
    
    Core.AddBank = function(source, amount)
        local user_id = vRP.getUserId({source})
        return vRP.giveBankMoney(user_id, amount)
    end

    Core.RemoveBank = function(source, amount)
        local user_id = vRP.getUserId({source})
        return vRP.tryWithdraw(user_id, amount)
    end

    Core.AddItem = function(source, item, amount, metadata)
        local user_id = vRP.getUserId({source})
        return vRP.giveInventoryItem(user_id, item, amount)	 -- metadata is not supported by vRP by default
    end

    Core.RemoveItem = function(source, item, amount)
        local user_id = vRP.getUserId({source})
        return vRP.tryGetInventoryItem(user_id, item, amount)	
    end

    Core.GetItemCount = function(source, item)
        local user_id = vRP.getUserId({source})
        return vRP.getInventoryItemAmount(user_id, item)	
    end

    Core.CanCarry = function(source, item, amount)
        local user_id = vRP.getUserId({source})
        local weight = vRP.getItemWeight(item)
        local currentWeight = vRP.getInventoryWeight(user_id)
        local maxWeight = vRP.getInventoryMaxWeight(user_id)
        local newWeight = weight * amount
        if currentWeight + newWeight <= maxWeight then
            return true
        else
            return false
        end
    end

    Core.GetJob = function(source)
        local user_id = vRP.getUserId({source})
        local job = vRP.getUserGroupByType(user_id, "job")
        local jobData = {
            name = job or "unemployed",
            label = job and Core.String.Capitalize(job) or "Unemployed",
            grade = 0, -- vRP doesn't support it by default; implement this if needed
            gradeLabel = "Unemployed", -- vRP doesn't support it by default; implement this if needed
            onDuty = true -- Assuming onDuty is always true unless custom handling
        }
        return jobData
    end

    Core.IsPolice = function(source)
        local user_id = vRP.getUserId({source})
        local job = vRP.getUserGroupByType(user_id, "job")
        if job == "police" or job == "sheriff" or job == "state" then 
            return true
        end
        return false
    end

    Core.GetFullName = function(source)
        local user_id = vRP.getUserId({source})
        local identity = vRP.getUserIdentity({user_id})
        if identity then
            return identity.firstname .. " " .. identity.name
        end
        return "Firstname Lastname" 
    end

    Core.GetUserInfo = function(source)
        local user_id = vRP.getUserId({source})
        local identity = vRP.getUserIdentity({user_id})
        local userInfo = {
            dateOfBirth = "Unknown", -- vRP doesn't support it by default; implement this if needed
            sex = "Unknown", -- vRP doesn't support it by default; implement this if needed
            height = "Unknown", -- vRP doesn't support it by default; implement this if needed
            nationality = "Unknown", -- vRP doesn't support it by default; implement this if needed
        }
        return userInfo
    end

    Core.GetUserSkin = function(source)
        local user_id = vRP.getUserId({source})
        return {
            eyesColor = 0, -- number
            skinColor = 0, -- number
        }
    end

    AddEventHandler("vRP:playerLeave", function(user_id, source)
        if user_id then
            TriggerClientEvent("dh_lib:client:playerUnloaded", source)
            TriggerEvent("dh_lib:server:playerUnloaded", source)
        end
    end)
    
    Core.Loaded = true
end)