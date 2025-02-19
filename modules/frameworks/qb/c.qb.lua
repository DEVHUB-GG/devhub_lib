if Shared.Framework ~= "QBCore" then return end
   
CreateThread( function()
    RegisterNetEvent("QBCore:Client:OnPlayerLoaded",function()
        TriggerEvent("dh_lib:client:playerLoaded")
        TriggerServerEvent("dh_lib:server:playerLoaded", GetPlayerServerId(PlayerId()))
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        TriggerEvent("dh_lib:client:playerUnloaded")
        TriggerServerEvent("dh_lib:server:playerUnloaded", GetPlayerServerId(PlayerId()))
    end)

    Core.Loaded = true
end)