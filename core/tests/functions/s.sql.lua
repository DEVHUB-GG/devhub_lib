if not Shared.CompatibilityTest then return end

function test_sql()
    local sqlResource = "oxmysql"
    if GetResourceState(sqlResource) == "started" then
        testResults['SqlResource'].results = true
    else
        testResults['FrameworkResource'].manualCheckRequired = {"Custom SQL resources state cannot be tested. Make sure you configured it correctly."}
    end
    testResults['SqlResource'].message = "Status of resource: "..tostring(GetResourceState(sqlResource)).." : "..sqlResource

    Core.SQL.Execute("SELECT ?", {5}, function(cbSql)
        if cbSql and cbSql[1]["5"] == 5 then
            testResults['SqlAction'].results = true
        end
        testResults['SqlAction'].message = "Returned "..json.encode(cbSql)
    end)

    Wait(200)

    local cbSql = Core.SQL.AwaitExecute("SELECT ?", {10})
    if cbSql and cbSql[1]["10"] == 10 then
        testResults['SqlActionAwait'].results = true
    end
    testResults['SqlActionAwait'].message = "Returned "..json.encode(cbSql)
end