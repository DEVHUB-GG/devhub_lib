
CreateThread( function() 
    --[[
        This file defines a custom vehicle keys system
        It contains the following data properties:
        - @plate: The vehicle plate.
        - @vehicle: The vehicle entity.
    ]]  
    if Shared.VehicleKeys == "qb-vehiclekeys" then
        Core.AddVehicleKeys = function(plate, vehicle)
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        end
    elseif Shared.VehicleKeys == "qs-vehiclekeys" then
        Core.AddVehicleKeys = function(plate, vehicle)
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            exports['qs-vehiclekeys']:GiveKeys(plate, model)
        end
    elseif Shared.VehicleKeys == "ak47_vehiclekeys" then
        Core.AddVehicleKeys = function(plate, vehicle)
            exports['ak47_vehiclekeys']:GiveKey(plate, false)
        end
    elseif Shared.VehicleKeys == "t1ger_keys" then
        Core.AddVehicleKeys = function(plate, vehicle)
            print("Adding keys for plate: " .. plate)
            local name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            exports['t1ger_keys']:GiveJobKeys(plate, name, true)
        end
    elseif Shared.VehicleKeys == "Renewed-Vehiclekeys" then
        Core.AddVehicleKeys = function(plate, vehicle)
            exports['Renewed-Vehiclekeys']:addKey(plate)
        end
    elseif Shared.VehicleKeys == "cd_garage" then
        Core.AddVehicleKeys = function(plate, vehicle)
            TriggerEvent('cd_garage:AddKeys', plate)
        end
    else -- custom or default
        Core.AddVehicleKeys = function(plate, vehicle)
            -- Add your custom vehicle keys logic here
        end
    end
end)