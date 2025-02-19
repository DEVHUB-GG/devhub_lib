if Shared.Framework ~= "custom" then return end  

CreateThread(function()
    -- Retrieves the identifier of a player.
    -- @param source The player's source ID.
    -- @return The identifier of the player.
    Core.GetIdentifier = function(source)
        -- code here
        -- check if there is steam, if not get license 
        local steam = GetPlayerIdentifiers(source)[1]
        if steam then
            return steam
        end
        return GetPlayerIdentifiers(source)[2]
    end

    -- Registers an item with a corresponding function.
    -- @param item The item to register.
    -- @param func The function to be called when the item is used.
    -- The function should take a single parameter, the player's source ID.
    -- @return void
    Core.RegisterItem = function(item, func)
        -- RegisterUsableItem(item, function(playerId)
        --     func(playerId)
        -- end)
    end

    -- Adds cash to the player's account.
    -- @param source The player's source ID.
    -- @param amount The amount of cash to add.
    -- @return True if the cash was successfully added, false otherwise.
    Core.AddCash = function(source, amount)
        return true 
    end

    -- Removes cash from the player's account.
    -- @param source The player's source ID.
    -- @param amount The amount of cash to remove.
    -- @return True if the cash was successfully removed, false otherwise.
    Core.RemoveCash = function(source, amount)
        return true
    end

    -- Gets the amount of cash in the player's account.
    -- @param source The player's source ID.
    -- @return The amount of cash in the player's account.
    Core.GetCash = function(source)
        return 0
    end

    -- Gets the amount of money in the player's bank account.
    -- @param source The player's source ID.
    -- @return The amount of money in the player's bank account.
    Core.GetBank = function(source)
        return 0
    end

    -- Adds an amount to the player's bank account.
    -- @param source The player's source ID.
    -- @param amount The amount to add to the player's bank account.
    -- @return True if the operation was successful, false otherwise.
    Core.AddBank = function(source, amount)
        return true
    end

    -- Removes an amount from the player's bank account.
    -- @param source The player's source ID.
    -- @param amount The amount to remove from the player's bank account.
    -- @return True if the operation was successful, false otherwise.
    Core.RemoveBank = function(source, amount)
        return true
    end

    -- Adds an item to the player's inventory.
    -- @param source The player's source ID.
    -- @param item The item to add to the player's inventory.
    -- @param amount The amount of the item to add.
    -- @return True if the operation was successful, false otherwise.
    Core.AddItem = function(source, item, amount)
        return true
    end

    -- Removes an item from the player's inventory.
    -- @param source The player's source ID.
    -- @param item The item to remove from the player's inventory.
    -- @param amount The amount of the item to remove.
    -- @return True if the operation was successful, false otherwise.
    Core.RemoveItem = function(source, item, amount)
        return true
    end

    -- Gets the count of a specific item in the player's inventory.
    -- @param source The player's source ID.
    -- @param item The item to count in the player's inventory.
    -- @return The count of the specified item in the player's inventory.
    Core.GetItemCount = function(source, item)
        return 0
    end

    -- Checks if the player can carry a specific amount of an item.
    -- @param source The player's source ID.
    -- @param item The item to check.
    -- @param amount The amount of the item to check.
    -- @return True if the player can carry the specified amount, false otherwise.
    Core.CanCarry = function(source, item, amount)
        return true
    end

    -- Gets the job data of the player.
    -- @param source The player's source ID.
    -- @return A table containing the player's job data (name, label, grade, onDuty).
    Core.GetJob = function(source)
        local jobData = {
            name = "unemployed",
            label = "Unemployed",
            grade = 0,
            onDuty = false,
        }
        return jobData
    end

    -- Gets the full name of the player.
    -- @param source The player's source ID.
    -- @return The full name of the player.
    Core.GetFullName = function(source)
        return "Firstname Lastname"
    end

    Core.Loaded = true
end)