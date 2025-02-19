if not Shared.CompatibilityTest then return end

RegisterCommand('dh_startTest', function()
    print("^3dh_lib:^7 Starting compatibility tests. It may take a while.")
    TriggerServerEvent('dh_lib:server:startTest')
end)