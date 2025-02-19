if not Shared.CompatibilityTest then return end

local item = "dh_test"
local amount = 1

Citizen.CreateThread(function()
    while not Core.Loaded do
        Wait(100)
    end
    Wait(1000)
    Core.RegisterItem(item, function(source)
        TriggerClientEvent('dh_lib:client:testRequestAction', source, 'useItem' , true)
        test_waitForAction = false
        testResults['RegisterItem'].results = true
        testResults['RegisterItem'].message = "Item used"
    end)
end)


function test_item(source)
    local canCarry = Core.CanCarry(source, item, amount)
    if canCarry then
        testResults['CanCarry'].results = true
    end
    testResults['CanCarry'].message = "Returned "..tostring(canCarry)

    local CanCarryOverweight = Core.CanCarry(source, item, 10000)
    if not CanCarryOverweight then
        testResults['CanCarryOverweight'].results = true
    end
    testResults['CanCarryOverweight'].message = "Returned "..tostring(CanCarryOverweight)

    if not testResults['CanCarry'].results then
        testResults['AddItem'].message = "CanCarry failed cannot check AddItem"
        testResults['RemoveItem'].message = "CanCarry failed cannot check RemoveItem"
        testResults['GetItemCount'].message = "CanCarry failed cannot check GetItemCount"
        if not testResults['AddItem'].failedTips then testResults['AddItem'].failedTips = {} end
        table.insert(testResults['AddItem'].failedTips,"Make sure you added item "..item.." to items table in your server.")
    else
        local itemCount , errorFound = executeWithErrorHandling(Core.GetItemCount,source, item)
        if not errorFound then
            Core.AddItem(source, item, amount)
            local itemCountAfterAdd = executeWithErrorHandling(Core.GetItemCount,source, item)
            if itemCountAfterAdd == itemCount + amount then
                testResults['AddItem'].results = true
                testResults['GetItemCount'].results = true
                testResults['GetItemCount'].message = "Returned "..tostring(itemCount)
            end
            testResults['AddItem'].message = "Added "..amount..", item count before: "..tostring(itemCount)..", item count after: "..tostring(itemCountAfterAdd)
            test_waitForAction = true
            TriggerClientEvent('dh_lib:client:testRequestAction', source, 'useItem')
            local time = 20
            while test_waitForAction do
                time = time - 1
                if time <= 0 then
                    test_waitForAction = false
                end 
                Wait(1000)
            end
            Core.RemoveItem(source, item, amount)
            local itemCountAfterRemove = executeWithErrorHandling(Core.GetItemCount,source, item)
            if itemCountAfterRemove == itemCount then
                testResults['RemoveItem'].results = true
            end
            testResults['RemoveItem'].message = "Removed "..amount..", item count before: "..tostring(itemCountAfterAdd)..", item count after: "..tostring(itemCountAfterRemove)
        else
            testResults['AddItem'].message = "GetItemCount failed cannot check AddItem"
            testResults['RemoveItem'].message = "GetItemCount failed cannot check RemoveItem"
            testResults['RegisterItem'].message = "GetItemCount failed cannot check RegisterItem"
            testResults['GetItemCount'].message = "GetItemCount "..itemCount..". \n^1 IS ITEM "..item.." ADDED TO ITEMS TABLE?^7"
        end
    end
end