if not Shared.CompatibilityTest then return end

function test_user(source)
    -- Player job
    local job = Core.GetJob(source)
    if job then
        local canPass = 0
        if job.name then
            if job.name == "unemployed" then
                if not testResults['GetJob'].manualCheckRequired then testResults['GetJob'].manualCheckRequired = {} end
                table.insert(testResults['GetJob'].manualCheckRequired,"Job name: unemployed, change job to pass the test.")
            else
                canPass = canPass + 1
            end
        end
        if job.grade then
            if job.grade == 0 then
                if not testResults['GetJob'].manualCheckRequired then testResults['GetJob'].manualCheckRequired = {} end
                table.insert(testResults['GetJob'].manualCheckRequired,"Job grade: 0, change job grade to pass the test.")
            else
                canPass = canPass + 1
            end
        end
        if job.label then
            if job.label == "Unemployed" then
                if not testResults['GetJob'].manualCheckRequired then testResults['GetJob'].manualCheckRequired = {} end
                table.insert(testResults['GetJob'].manualCheckRequired,"Job label: Unemployed, change job to pass the test.")
            else
                canPass = canPass + 1
            end
        end
        if job.onDuty then
            canPass = canPass + 1
        else
            if not testResults['GetJob'].manualCheckRequired then testResults['GetJob'].manualCheckRequired = {} end
            table.insert(testResults['GetJob'].manualCheckRequired,"Job onDuty: false, go on duty to pass the test.")
            if not testResults['GetJob'].failedTips then testResults['GetJob'].failedTips = {} end
            table.insert(testResults['GetJob'].failedTips,"If you are not using job duty, go to server side of your framework and do following actions \n\t1.Find Core.GetJob \n\t2. change onDuty = xPlayer.job.onDuty to onDuty = true")
        end
        if canPass == 4 then
            testResults['GetJob'].results = true
        end
        testResults['GetJob'].message = "Returned "..json.encode(job)
    end

    local function splitName(fullName)
        local names = {}
        for word in fullName:gmatch("%S+") do
            table.insert(names, word)
        end
        return names
    end

    -- Full name
    local fullName = Core.GetFullName(source)
    if fullName and fullName ~= "Firstname Lastname" then
        local words = splitName(fullName)
        if words[1] and words[2] then
            testResults['GetFullName'].results = true
        else
            testResults['GetFullName'].manualCheckRequired = {"GetFullName has not returned string with first and last name."}
        end
    end
    testResults['GetFullName'].message = "Returned "..tostring(fullName)

    -- Player revive
    Wait(1000)
    test_waitForAction = true
    TriggerClientEvent('dh_lib:client:testRequestAction', source, 'revive')
    Wait(1100)
    local time = 20
    while test_waitForAction do
        time = time - 1
        if time <= 0 then
            test_waitForAction = false
        end 
        Wait(1000)
    end
    Wait(1000)

    -- Player left the server
    DropPlayer(source, 'dh_lib: Testing player leaving the server.')
    Wait(3000)
end