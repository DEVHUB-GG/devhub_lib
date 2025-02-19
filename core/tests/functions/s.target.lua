if not Shared.CompatibilityTest then return end

function test_target()
    local targetCheckFailed = true
    if Shared.Target == 'standalone' then
        testResults['TargetResource'].results = true
        return
    end
    if Shared.Target ~= 'custom' and TARGET_RESOURCES[Shared.Target] then
        if GetResourceState(TARGET_RESOURCES[Shared.Target]) == "started" then
            testResults['TargetResource'].results = true
            targetCheckFailed = false
        end
        testResults['TargetResource'].message = "Status of resource: "..tostring(GetResourceState(Shared.Target)).." : "..Shared.Target
    end
    if targetCheckFailed then
        testResults['TargetResource'].manualCheckRequired = {"Custom targets cannot be tested. Make sure you configured it correctly."}
    end
end