if not Shared.CompatibilityTest then return end

function test_identifier(source)
    local identifier , errorFound = executeWithErrorHandling(Core.GetIdentifier,source)
    if identifier and not errorFound then
        testResults['GetIdentifier'].results = true
    end
    testResults['GetIdentifier'].message = "Returned "..tostring(identifier)

    if not testResults['GetIdentifier'].results then
        for k,v in pairs(testResults) do
            if not v.ignoreXPlayerWipe  then
                testResults[k].message = "GetIdentifier failed"
            end
        end
    end
end