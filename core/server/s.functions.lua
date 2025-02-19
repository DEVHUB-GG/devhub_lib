function Core.Notify(source, text, duration, notificationType)
    TriggerClientEvent("dh_lib:client:notify", source, text, duration, notificationType)
end
function Core.DumpTable(table, nb)
    if nb == nil then 
        nb = 0
    end 
    if type(table) == 'table' then
        local s = ''
        for i = 1, nb + 1, 1 do
            s = s .. "    "
        end
        s = '{\n'
        for k,v in pairs(table) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            for i = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. '['..k..'] = ' .. Core.DumpTable(v, nb + 1) .. '",\n'
        end
        for i = 1, nb, 1 do
            s = s .. "    "
        end
        return s .. '}'
    else
        return tostring(table)
    end
end
Core.SendLog = function(source, webhook, data)
    TriggerEvent("dh_lib:server:sendLog", source, webhook, data)
end

Core.GetPlayerPicture = function(source)
    if not GetPlayerName(source) then return false end

    local steam = GetIdentifier(source, "steam")
    if not steam then
        return "https://winaero.com/blog/wp-content/uploads/2018/08/Windows-10-user-icon-big.png"
    end
    local url
    PerformHttpRequest("https://steamcommunity.com/profiles/" .. tonumber(steam, 16), function(_, text, _) 
        if not text then url = false end
        url = text:match('<meta name="twitter:image" content="(.-)"')
    end, "GET")
    while url == nil do
        Wait(0)
    end
    return url
end

Core.GenerateUid = function(serverId)
    if not serverId then  
        serverId = math.random(1000, 9999)
    end
    return serverId..'DHS'..os.time()
end