if not Shared.CompatibilityTest then return end

-- Set when the test starts, auto detect can switch the license system after load.
local TEST_LICENSE = "dh_test"

-- Some systems write in the background (esx_license saves through an async query),
-- so HasLicense is polled for a moment instead of read once.
local function waitForHasLicense(source, expected)
    local has
    for _ = 1, 10 do
        has = TestHelper.Execute(Core.HasLicense, source, TEST_LICENSE)
        if has == expected then return has end
        Wait(300)
    end
    return has
end

local function licenseTips()
    if Shared.LicenseSystem == "devhub_licenses" then
        return {
            manualCheckRequired = { "Make sure devhub_licenses has a license template named " .. TEST_LICENSE .. " to pass the test." },
        }
    end
    if Shared.LicenseSystem == "custom" then
        return {
            failedTips = { "Shared.LicenseSystem is custom, add your license logic in modules/systems/s.licenses.lua" },
        }
    end
end

function test_license(source)
    local system = tostring(Shared.LicenseSystem)
    -- devhub_licenses can only issue licenses that have a template, so it is tested on the
    -- driving license instead of a made-up one.
    TEST_LICENSE = system == "devhub_licenses" and "driving_license" or "dh_test"
    local functionsReady = type(Core.GetLicenses) == "function" and type(Core.HasLicense) == "function"
        and type(Core.SetLicense) == "function" and type(Core.RemoveLicense) == "function"
    if not functionsReady then
        TestHelper.SetResult("LicenseSystem", false, "License functions are missing, system: " .. system)
        TestHelper.SetResult("GetLicenses", false, "LicenseSystem failed, cannot check GetLicenses")
        TestHelper.SetResult("SetLicense", false, "LicenseSystem failed, cannot check SetLicense")
        TestHelper.SetResult("HasLicense", false, "LicenseSystem failed, cannot check HasLicense")
        TestHelper.SetResult("RemoveLicense", false, "LicenseSystem failed, cannot check RemoveLicense")
        return
    end
    TestHelper.SetResult("LicenseSystem", system ~= "custom", "Using " .. system,
        system == "custom" and licenseTips() or nil)

    -- Get
    local licenses, getError = TestHelper.Execute(Core.GetLicenses, source)
    if getError or type(licenses) ~= "table" then
        TestHelper.SetResult("GetLicenses", false, getError and licenses or "Returned " .. tostring(licenses))
    else
        TestHelper.SetResult("GetLicenses", true, "Returned " .. json.encode(licenses))
    end

    -- A real license the player already holds is left alone, removing it would revoke it.
    local alreadyHeld = TestHelper.Execute(Core.HasLicense, source, TEST_LICENSE)
    if alreadyHeld == true then
        TestHelper.SetResult("HasLicense", true, "Player already holds " .. TEST_LICENSE)
        TestHelper.SkipTests({ "SetLicense", "RemoveLicense" },
            "player already holds " .. TEST_LICENSE .. ", test on a character without it to check SetLicense and RemoveLicense")
        return
    end

    -- Set
    local granted, setError = TestHelper.Execute(Core.SetLicense, source, TEST_LICENSE, { takePhoto = false })
    if setError or not granted then
        TestHelper.SetResult("SetLicense", false, setError and granted or "Returned " .. tostring(granted), licenseTips())
        TestHelper.SetResult("HasLicense", false, "SetLicense failed, cannot check HasLicense")
        TestHelper.SetResult("RemoveLicense", false, "SetLicense failed, cannot check RemoveLicense")
        return
    end
    TestHelper.SetResult("SetLicense", true, "Granted " .. TEST_LICENSE)

    -- Has
    local hasAfterSet = waitForHasLicense(source, true)
    TestHelper.SetResult("HasLicense", hasAfterSet == true,
        "HasLicense after SetLicense: " .. tostring(hasAfterSet))

    Wait(100)

    -- Remove
    local removed, removeError = TestHelper.Execute(Core.RemoveLicense, source, TEST_LICENSE, "Compatibility test")
    if removeError or not removed then
        TestHelper.SetResult("RemoveLicense", false, removeError and removed or "Returned " .. tostring(removed))
        return
    end
    local hasAfterRemove = waitForHasLicense(source, false)
    TestHelper.SetResult("RemoveLicense", hasAfterRemove == false,
        "HasLicense after RemoveLicense: " .. tostring(hasAfterRemove))
end
