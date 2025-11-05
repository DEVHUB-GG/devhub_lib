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

RegisterNetEvent('devhub_lib:server:setPlayerRoutingBucket', function(routingBucket, target)
    local source = target or source
    if routingBucket and routingBucket >= 0 then
        SetPlayerRoutingBucket(source, routingBucket)
        TriggerEvent('devhub_lib:server:setBucket', source, routingBucket)
    end
end)

RegisterNetEvent('devhub_lib:server:resetPlayerRoutingBucket', function(target)
    local source = target or source
    SetPlayerRoutingBucket(source, 0)
    TriggerEvent('devhub_lib:server:setBucket', source, 0)
end)