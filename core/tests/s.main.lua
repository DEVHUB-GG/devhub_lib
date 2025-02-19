if not Shared.CompatibilityTest then return end

testResults = {
    playerLoadedClient = { message = "dh_lib:client:playerLoaded event not triggered.", results = false, ignoreXPlayerWipe = true },
    playerLoadedServer = { message = "dh_lib:server:playerLoaded event not triggered.", results = false, ignoreXPlayerWipe = true },
    playerUnloadedClient = { message = "dh_lib:client:playerUnloaded event not triggered.", results = false, ignoreXPlayerWipe = true },
    playerUnloadedServer = { message = "dh_lib:server:playerUnloaded event not triggered.", results = false, ignoreXPlayerWipe = true },
    playerDiedClient = { message = "dh_lib:client:setDeathStatus VALUE true event not triggered.", results = false, ignoreXPlayerWipe = true },
    playerRevivedClient = { message = "dh_lib:client:setDeathStatus VALUE false event not triggered.", results = false, ignoreXPlayerWipe = true },
    GetIdentifier = { message = "", results = false, ignoreXPlayerWipe = true },
    GetCash = { message = "", results = false },
    AddCash = { message = "", results = false },
    RemoveCash = { message = "", results = false },
    GetBank = { message = "", results = false },
    AddBank = { message = "", results = false },
    RemoveBank = { message = "", results = false },
    CanCarry = { message = "", results = false },
    CanCarryOverweight = { message = "", results = false },
    AddItem = { message = "", results = false },
    GetItemCount = { message = "", results = false },
    RemoveItem = { message = "", results = false },
    GetJob = { message = "", results = false },
    GetFullName = { message = "", results = false },
    TargetResource = { message = "", results = false, ignoreXPlayerWipe = true },
    FrameworkResource = { message = "", results = false, ignoreXPlayerWipe = true },
    SqlResource = { message = "", results = false, ignoreXPlayerWipe = true },
    SqlAction = { message = "", results = false, ignoreXPlayerWipe = true },
    SqlActionAwait = { message = "", results = false, ignoreXPlayerWipe = true },
    RegisterItem = { message = "Item was not used in time.", results = false, ignoreXPlayerWipe = true },
}

print("^3DEVHUB:^7 Compatibility tests enabled, type /dh_startTest to start the test.")
print("^3DEVHUB:^7 Test results will be displayed in the server console.")
print("^3DEVHUB:^1 MAKE SURE^7 you added new item ^1dh_test^7")
print("^3DEVHUB:^1 MAKE SURE^7 you have ^1Shared.CompatibilityTest DISABLED^7 on main server^7")

test_waitForAction = false

RegisterNetEvent('dh_lib:server:startTest',function()
    local source = source
    print("^3DEVHUB:^7 Starting compatibility tests. It may take a while.")

    test_target()
    test_framework()
    test_sql()
    test_identifier(source)
    if testResults['GetIdentifier'].results then
        test_cash(source)
        test_bank(source)
        test_item(source)
        test_user(source)
    end

    print("^3DEVHUB:^7 Compatibility tests finished.")
    print("^3DEVHUB:^7 Test results:")
    local amountOfPassedTests = 0
    local amountOfFailedTests = 0
    local requireAction = 0
    local failedTips = {}
    for k,v in pairs(testResults) do
        if v.results then
            print("^3DEVHUB:^2 "..k.." test passed. ✅ ^7. "..v.message)
            amountOfPassedTests = amountOfPassedTests + 1
        else
            print("^3DEVHUB:^1 "..k.." test failed. ❌ .^7 "..v.message)
            if v.failedTips then
                for _,message in pairs(v.failedTips) do
                    table.insert(failedTips,"⚠️ ^6 "..message..'\n')
                end
            end
            if v.manualCheckRequired then
                for _,message in pairs(v.manualCheckRequired) do
                    print("\t\t 🛠️ ^5 "..message)
                    requireAction = requireAction + 1
                end
            end
            amountOfFailedTests = amountOfFailedTests + 1
        end
    end
    print('----------------------------')
    print("^3DEVHUB:^2 Passed tests: ^7"..amountOfPassedTests)
    print("^3DEVHUB:^1 Failed tests: ^7"..amountOfFailedTests)
    print("^3DEVHUB:^5 Required actions: ^7"..requireAction)
    print('----------------------------')
    if amountOfFailedTests > 0 then
        print("^3DEVHUB:^1 Some tests ^1failed^7, check the console for more information.")
    else
        print("^3DEVHUB:^2 All tests ^2passed^7, you can now disable compatibility tests.")
    end
    if #failedTips > 0 then
        print('----------------------------')
        print("^3DEVHUB:^5 Tips:")
        for _,message in pairs(failedTips) do
            print(message)
        end
        print('^7----------------------------')
    end
end)

function executeWithErrorHandling(func, ...)
    local success, result = pcall(func, ...)
    if success then
        return result
    else
        return "Error: " .. tostring(result) , true
    end
end

RegisterNetEvent('dh_lib:server:transferClientTestResults',function(results, testName)
    local source = source
    testResults[testName].results = results
    testResults[testName].message = ""
    if testName == 'playerRevivedClient' then
        TriggerClientEvent('dh_lib:client:testRequestAction', source, 'revive', true)
        test_waitForAction = false
        testResults['playerRevivedClient'].results = true
        testResults['playerRevivedClient'].message = "Player revived"
    end
end)

RegisterNetEvent('dh_lib:server:playerUnloaded', function()
    testResults['playerUnloadedServer'].results = true
    testResults['playerUnloadedServer'].message = ""
    -- we can assume that playerUnloadedClient will also be triggered, it is only used in situations when player is switching character without leaving the server
    testResults['playerUnloadedClient'].results = true
    testResults['playerUnloadedClient'].message = ""
end)

RegisterNetEvent('dh_lib:server:playerLoaded', function()
    testResults['playerLoadedServer'].results = true
    testResults['playerLoadedServer'].message = ""
end)