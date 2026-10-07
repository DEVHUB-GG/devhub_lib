local function installLicenseSystem()
    --[[
        This file defines the license system connection
        It contains the following data properties:
        - @source: The player server id.
        - @name: The license type. Whatever the license system calls it -- an ESX
                 license type ("drive"), a QB metadata key ("driver"), or a
                 devhub_licenses template name ("driving_license_car"). Names are
                 NOT translated between systems.
        - @opts: Add only, and devhub_licenses only -- every other system takes
                 the name and ignores the table.
                 `grantOnly = true` approves the player without handing over the
                 card. Anything else is passed through to issueLicense, so
                 `takePhoto = false`, `expirationDays` and `avatarUrl` all work.
        - @reason: Remove only. Free text, recorded where the system supports it.

        Core.GetLicenses(source)              -> { ['driving_license_car'] = true }
        Core.HasLicense(source, name)         -> boolean
        Core.SetLicense(source, name, opts)   -> boolean
        Core.RemoveLicense(source, name, why) -> boolean

        The systems do not agree on what a license IS:
        - devhub_licenses  a record with provenance -- issued when, expires when,
                           and a status (active / suspended / revoked / lost).
        - ESX              a row in `user_licenses`. Held or not, nothing else.
        - QBCore / QBOX    a boolean in PlayerData.metadata.licences. Note the
                           spelling, QB uses "licences" and it is easy to miss.
        - vRP              no native concept. Stored as JSON in user data, because
                           vRP groups are for jobs and a license put there reads
                           as one.

        So GetLicenses returns a SET OF NAMES and nothing more -- the only shape
        all of them can honestly answer. Expiry and suspension exist in
        devhub_licenses alone; a script that needs them should ask it directly.
    ]]
    if Shared.LicenseSystem == "devhub_licenses" then
        print("^3devhub_lib:^2 licenses: using devhub_licenses^7")
        local function tryExport(what, fn)
            local packed = table.pack(pcall(fn))

            if not packed[1] then
                print(("^3devhub_lib:^1 licenses: devhub_licenses:%s raised an error -- %s^7")
                    :format(what, tostring(packed[2])))
                return nil
            end

            return table.unpack(packed, 2, packed.n)
        end

       
        Core.GetLicenses = function(source)
            local licenses, success = tryExport('getPlayerOwnedLicenses', function()
                return exports['devhub_licenses']:getPlayerOwnedLicenses(tonumber(source))
            end)

            if type(licenses) ~= 'table' or success == false then
                print("^3devhub_lib:^1 licenses: could not list licenses -- returning nothing^7")
                return {}
            end

            local held = {}
            for _, license in pairs(licenses) do
             
                if type(license) == 'table'
                   and (license.status == nil or license.status == 'active')
                   and not license.isFake then
                  
                    local name = license.templateName or license.template
                    if name then held[name] = true end
                end
            end
            return held
        end
        Core.HasLicense = function(source, name)
            if not name then return false end

            local has = tryExport('playerHasLicense', function()
                return exports['devhub_licenses']:playerHasLicense(tonumber(source), name)
            end)
            return has and true or false
        end
        Core.SetLicense = function(source, name, opts)
            if not name then return false end
            opts = opts or {}

            if opts.grantOnly then
                local granted = tryExport('grantPermission', function()
                    return exports['devhub_licenses']:grantPermission(nil, tonumber(source), name)
                end)
                return granted and true or false
            end

            local licenseId, success = tryExport('issueLicense', function()
                return exports['devhub_licenses']:issueLicense(nil, tonumber(source), name, opts)
            end)
            return licenseId ~= nil and success ~= false
        end
        Core.RemoveLicense = function(source, name, why)
            if not name then return false end

            local revoked = tryExport('revokeLicense', function()
                return exports['devhub_licenses']:revokeLicense(
                    nil, tonumber(source), name, why or 'Revoked')
            end)
            return revoked and true or false
        end
    elseif Shared.LicenseSystem == "ESX" then
        local function esxLicenseHandled()
            return GetResourceState('esx_license') == 'started'
        end
        Core.GetLicenses = function(source)
            local identifier = Core.GetIdentifier(source)
            if not identifier then return {} end
            local rows = Core.SQL.AwaitExecute(
                'SELECT `type` FROM `user_licenses` WHERE `owner` = ?', { identifier }) or {}
            local held = {}
            for _, row in ipairs(rows) do held[row.type] = true end
            return held
        end
        Core.HasLicense = function(source, name)
            if not name then return false end
            return Core.GetLicenses(source)[name] == true
        end
        Core.SetLicense = function(source, name)
            if not name then return false end
            if esxLicenseHandled() then
                TriggerEvent('esx_license:addLicense', tonumber(source), name)
                return true
            end
            local identifier = Core.GetIdentifier(source)
            if not identifier then return false end
            Core.SQL.AwaitExecute(
                'INSERT IGNORE INTO `user_licenses` (`type`, `owner`) VALUES (?, ?)',
                { name, identifier })
            return true
        end
        Core.RemoveLicense = function(source, name)
            if not name then return false end
            if esxLicenseHandled() then
                TriggerEvent('esx_license:removeLicense', tonumber(source), name)
                return true
            end
            local identifier = Core.GetIdentifier(source)
            if not identifier then return false end
            Core.SQL.AwaitExecute(
                'DELETE FROM `user_licenses` WHERE `owner` = ? AND `type` = ?',
                { identifier, name })
            return true
        end
    elseif Shared.LicenseSystem == "QBCore" or Shared.LicenseSystem == "QBOX" then
        local function getPlayer(source)
            if Shared.LicenseSystem == "QBOX" then
                return exports.qbx_core:GetPlayer(tonumber(source))
            end
            return QBCore and QBCore.Functions.GetPlayer(tonumber(source))
        end
        local function getLicences(player)
            local meta = player.PlayerData and player.PlayerData.metadata
            return (meta and meta['licences']) or {}
        end
        Core.GetLicenses = function(source)
            local player = getPlayer(source)
            if not player then return {} end
            local held = {}
            for name, value in pairs(getLicences(player)) do
                if value then held[name] = true end
            end
            return held
        end
        Core.HasLicense = function(source, name)
            if not name then return false end
            local player = getPlayer(source)
            if not player then return false end
            return getLicences(player)[name] == true
        end
        Core.SetLicense = function(source, name)
            if not name then return false end
            local player = getPlayer(source)
            if not player then return false end
            local licences = getLicences(player)
            licences[name] = true
            player.Functions.SetMetaData('licences', licences)
            return true
        end
        Core.RemoveLicense = function(source, name)
            if not name then return false end
            local player = getPlayer(source)
            if not player then return false end
            local licences = getLicences(player)
            licences[name] = false
            player.Functions.SetMetaData('licences', licences)
            return true
        end
    elseif Shared.LicenseSystem == "VRP" then
        local LICENSE_KEY = 'dh_lib:licenses'
        local function read(userId)
            local raw = vRP.getUData({ userId, LICENSE_KEY })
            if type(raw) ~= 'string' or raw == '' then return {} end
            local ok, decoded = pcall(json.decode, raw)
            return (ok and type(decoded) == 'table') and decoded or {}
        end
        Core.GetLicenses = function(source)
            local userId = Core.GetIdentifier(source)
            if not userId then return {} end
            local held = {}
            for name, value in pairs(read(userId)) do
                if value then held[name] = true end
            end
            return held
        end
        Core.HasLicense = function(source, name)
            if not name then return false end
            local userId = Core.GetIdentifier(source)
            if not userId then return false end
            return read(userId)[name] == true
        end
        Core.SetLicense = function(source, name)
            if not name then return false end
            local userId = Core.GetIdentifier(source)
            if not userId then return false end
            local held = read(userId)
            held[name] = true
            vRP.setUData({ userId, LICENSE_KEY, json.encode(held) })
            return true
        end
        Core.RemoveLicense = function(source, name)
            if not name then return false end
            local userId = Core.GetIdentifier(source)
            if not userId then return false end
            local held = read(userId)
            held[name] = nil
            vRP.setUData({ userId, LICENSE_KEY, json.encode(held) })
            return true
        end
    else
        Core.GetLicenses = function(source)
            -- Add your custom "list this player's licenses" logic here
            print("^3devhub_lib:^1 licenses: no license system -- GetLicenses returned nothing^7")
            return {}
        end
        Core.HasLicense = function(source, name)
            -- Add your custom "does this player hold it" logic here
            print("^3devhub_lib:^1 licenses: no license system -- HasLicense answered false^7")
            return false
        end
        Core.SetLicense = function(source, name, opts)
            -- Add your custom grant logic here
            print(("^3devhub_lib:^1 licenses: no license system -- \"%s\" was NOT granted^7")
                :format(tostring(name)))
            return false
        end
        Core.RemoveLicense = function(source, name, why)
            -- Add your custom revoke logic here
            print(("^3devhub_lib:^1 licenses: no license system -- \"%s\" was NOT removed^7")
                :format(tostring(name)))
            return false
        end
    end
end

CreateThread(function()
    installLicenseSystem()

    AddEventHandler('devhub_lib:licenseSystemChanged', installLicenseSystem)
end)