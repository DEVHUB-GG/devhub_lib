RegisterNetEvent('dh_lib:server:sendLog',function(_source, webhook, data)
    local identifier = Core.GetIdentifier(_source)
    local message = ""
    message = message .. "**Player:** " .. Core.GetFullName(_source) .. " (".._source..")\n**Identifier: **" .. identifier .. "\n\n"
    for k,v in pairs(data) do
        message = message .. "**"..firstToUpper(k)..":** " .. v .. "\n"
    end

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = { {
            ["color"] = 16640286,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "DEVHUB.GG "..os.date("%H:%M:%S"),
            },
        } },
    }), {['Content-Type'] = 'application/json'})
end)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end