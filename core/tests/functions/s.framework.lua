if not Shared.CompatibilityTest then return end

function test_framework()
    local frameworkCheckFailed = true
    if Shared.Framework ~= "custom" and FRAMEWORK_RESOURCES[Shared.Framework] then
        local resourcesToCheck = FRAMEWORK_RESOURCES[Shared.Framework]
        local found = 0
        for i=1, #resourcesToCheck do
            if GetResourceState(resourcesToCheck[i]) == "started" then
                found = found + 1
            end
        end
        if found == #resourcesToCheck then
            testResults['FrameworkResource'].results = true
            frameworkCheckFailed = false
        end
        testResults['FrameworkResource'].message = "Found resources: "..tostring(found).."/ "..#resourcesToCheck..". Most compatible: "..Shared.Framework
    end
    if frameworkCheckFailed then
        testResults['FrameworkResource'].manualCheckRequired = {"Custom frameworks cannot be tested. Make sure you configured it correctly."}
    end
end