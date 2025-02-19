if not Shared.CompatibilityTest then return end

function test_bank(source)
    local bank = Core.GetBank(source)
    if bank then
        testResults['GetBank'].results = true
    end
    testResults['GetBank'].message = "Returned "..tostring(bank)

    if not testResults['GetBank'].results then
        testResults['AddBank'].results = "GetBank failed cannot check AddBank"
        testResults['RemoveBank'].results = "GetBank failed cannot check RemoveBank"
    else
        local bank = Core.GetBank(source)
        Core.AddBank(source, 100)
        local bankAfterAdd = Core.GetBank(source)
        if bankAfterAdd == bank + 100 then
            testResults['AddBank'].results = true
        end
        testResults['AddBank'].message = "Added 100, bank before: "..tostring(bank)..", bank after: "..tostring(bankAfterAdd)
        Wait(100)
        Core.RemoveBank(source, 100)
        local bankAfterRemove = Core.GetBank(source)
        if bankAfterRemove == bank and bankAfterAdd ~= bankAfterRemove then
            testResults['RemoveBank'].results = true
        end
        testResults['RemoveBank'].message = "Removed 100, bank before: "..tostring(bankAfterAdd)..", bank after: "..tostring(bankAfterRemove)
    end
end