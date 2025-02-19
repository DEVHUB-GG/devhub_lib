AddEventHandler('onResourceStop', function(resourceName)
    TriggerEvent("dh_lib:server:resourceStop", resourceName)
end)

RegisterNetEvent('txAdmin:events:serverShuttingDown',function()
    TriggerEvent("dh_lib:server:resourceStop", 'dh_all')
end)

AddEventHandler('playerDropped', function (reason)
    local source = source
    TriggerClientEvent("dh_lib:client:playerUnloaded", source)
    TriggerEvent("dh_lib:server:playerUnloaded", source)
end)