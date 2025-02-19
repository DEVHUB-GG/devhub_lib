if not Shared.CompatibilityTest then return end

function test_cash(source)
    local cash = Core.GetCash(source)
    if cash then
        testResults['GetCash'].results = true
    end
    testResults['GetCash'].message = "Returned "..tostring(cash)

    if not testResults['GetCash'].results then
        testResults['AddCash'].results = "GetCash failed cannot check AddCash"
        testResults['RemoveCash'].results = "GetCash failed cannot check RemoveCash"
    else
        local cash = Core.GetCash(source)
        Core.AddCash(source, 100)
        local cashAfterAdd = Core.GetCash(source)
        if cashAfterAdd == cash + 100 then
            testResults['AddCash'].results = true
        end
        testResults['AddCash'].message = "Added 100, cash before: "..tostring(cash)..", cash after: "..tostring(cashAfterAdd)
        Wait(100)
        Core.RemoveCash(source, 100)
        local cashAfterRemove = Core.GetCash(source)
        if cashAfterRemove == cash and cashAfterAdd ~= cashAfterRemove then
            testResults['RemoveCash'].results = true
        end
        testResults['RemoveCash'].message = "Removed 100, cash before: "..tostring(cashAfterAdd)..", cash after: "..tostring(cashAfterRemove)
    end
end