if Shared.Target ~= "standalone" then return end

local coordsTargets = {}
local modelTargets = {}
local targetsThread = {}
local threadStarted = false
local cachedPed = {
    ped = nil,
    coords = nil
} 

CreateThread(function() 
    Core.AddModelToTarget = function(model, data)
        table.insert(modelTargets, {
            model = model,
            event = data.event,
            label = data.label,
            handler = data.handler,
            resource = GetInvokingResource(),
        })
    end

    Core.AddCoordsToTarget = function(coords, data)
        table.insert(coordsTargets, {
            coords = coords,
            radius = data.radius or 2.0,
            event = data.event,
            label = data.label,
            handler = data.handler,
            resource = GetInvokingResource(),
        })
    end

    -- Core.AddCoordsToTarget(vec3(2832.7373, 2796.4502, 57.4704), {
    --     radius = 2.0,
    --     event = "test:coords",
    --     label = "Test coords",
    --     handler = function()
    --         return true
    --     end
    -- })

    while true do
        cachedPed.ped = PlayerPedId()
        cachedPed.coords = GetEntityCoords(cachedPed.ped)
        local threadShouldStart = false

        for _k, v in pairs(coordsTargets) do
            local k = tostring(_k)
            local distance = #(cachedPed.coords - v.coords)
            if not v.started and distance < v.radius + 3.0 and (not v.handler or v.handler()) then
                threadShouldStart = true 
                v.started = true
                local _, groundZ = GetGroundZFor_3dCoord(v.coords.x, v.coords.y, v.coords.z, 0)
                table.insert(targetsThread, {
                    event = v.event,
                    label = v.label,
                    coords = vec3(v.coords.x, v.coords.y, groundZ + 0.05),
                    radius = v.radius,
                    id = k
                })
                CreateThread(TargetThread)
            elseif v.started and distance < v.radius + 3.0 then
                threadShouldStart = true
            elseif v.started and distance > v.radius + 3.0 then
                v.started = false
                RemoveTarget(k)
            end
            Wait(1)
        end

        for k, v in pairs(modelTargets) do
            local model = GetHashKey(v.model)
            local peds = GetGamePool('CPed')
            for i = 1, #peds do
                local ped = peds[i]
                if DoesEntityExist(ped) then
                    local pedModel = GetEntityModel(ped)
                    if pedModel == model then
                        local pedCoords = GetEntityCoords(ped)
                        local distance = #(cachedPed.coords - pedCoords)
                        if not v.started and distance < 5.0 and (not v.handler or v.handler(ped, distance)) then
                            threadShouldStart = true
                            v.started = true
                            local _, groundZ = GetGroundZFor_3dCoord(pedCoords.x, pedCoords.y, pedCoords.z, 0)
                            table.insert(targetsThread, {
                                event = v.event,
                                label = v.label,
                                coords = vec3(pedCoords.x, pedCoords.y, groundZ + 0.05),
                                radius = 2.5,
                                id = k + 10000
                            })
                            CreateThread(TargetThread)
                        elseif v.started and distance < 5.0 then
                            threadShouldStart = true
                        elseif v.started and distance > 5.0 then
                            v.started = false
                            RemoveTarget(k + 10000)
                        end
                    end
                end
            end
            Wait(1)
        end

        if not threadShouldStart and threadStarted then
            threadStarted = false
        end

        Wait(threadShouldStart and 250 or 1000)
    end
end)

function RemoveTarget(id)
    for k, v in pairs(targetsThread) do
        if v.id == id then
            if v.uiDisplayed then
                Core.ShowStaticMessage()
            end
            table.remove(targetsThread, k)
            break
        end
    end
end

function TargetThread()
    if threadStarted then return end
    threadStarted = true
    while threadStarted do
        for _k, v in pairs(targetsThread) do
            DrawMarker(23, v.coords.x, v.coords.y, v.coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 253, 209, 64, 200, false, false, 2, false, false, false, false)
            local dist = #(cachedPed.coords - v.coords)
            if dist < v.radius and not v.uiDisplayed then
                v.uiDisplayed = true
                Core.ShowStaticMessage("<kbd>E</kbd> " .. v.label)
            elseif dist > v.radius and v.uiDisplayed then
                v.uiDisplayed = false
                Core.ShowStaticMessage()
            end
            if IsControlJustPressed(0, 38) then
                if dist < v.radius then 
                    TriggerEvent(v.event)
                end
            end
        end
        Wait(1)
    end
    Core.ShowStaticMessage()
end

AddEventHandler("onResourceStop", function(resourceName)
    local tableToRemove = {}
    for k, v in pairs(coordsTargets) do
        if v.resource == resourceName then
            RemoveTarget(k)
            table.insert(tableToRemove, k)
        end
    end
    for i = #tableToRemove, 1, -1 do
        table.remove(coordsTargets, tableToRemove[i])
    end
    tableToRemove = {}
    for k, v in pairs(modelTargets) do
        if v.resource == resourceName then
            RemoveTarget(k + 10000)
            table.insert(tableToRemove, k)
        end
    end
    for i = #tableToRemove, 1, -1 do
        table.remove(modelTargets, tableToRemove[i])
    end
end)
