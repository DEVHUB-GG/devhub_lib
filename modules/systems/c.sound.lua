CreateThread( function()
    local hasXSound = function()
        return GetResourceState('xsound') == 'started'
    end

    local formatVolume = function(volume)
        if volume == nil or volume == false or not tonumber(volume) then
            volume = 0.5
            print("Invalid volume, setting to 0.5")
        end
        if volume > 1.0 then
            volume = 1.0
        elseif volume < 0.0 then
            volume = 0.0
        end
        return volume + 0.0
    end

    Core.PlaySoundLocally = function(uid, url, volume, loop)
        if not hasXSound() then return false end
        exports['xsound']:PlayUrl(uid, url, formatVolume(volume), loop)
    end
    Core.PlaySoundCoords = function(uid, url, volume, coords, loop)
        if not hasXSound() then return false end
        exports['xsound']:PlayUrlPos(uid, url, formatVolume(volume), coords, loop, false)
    end
    Core.FadeIn = function(uid, time, volume)
        if not hasXSound() then return false end
        exports['xsound']:fadeIn(uid, time, formatVolume(volume))
    end
    Core.FadeOut = function(uid, time)
        if not hasXSound() then return false end
        if Core.SoundExists(uid) then
            exports['xsound']:fadeOut(uid, time)
        end
    end
    Core.ChangeDistance = function(uid, distance)
        if not hasXSound() then return false end
        exports['xsound']:Distance(uid, distance)
    end
    Core.StopSound = function(uid)
        if not hasXSound() then return false end
        exports['xsound']:Destroy(uid)
    end
    Core.SoundExists = function(uid)
        if not hasXSound() then return false end
        return exports['xsound']:soundExists(uid)
    end
end)