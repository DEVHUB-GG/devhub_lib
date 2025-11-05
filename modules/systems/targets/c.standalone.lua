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
            name = data.name,
            resource = GetInvokingResource(),
        })
    end

    Core.RemoveCoordsFromTarget = function(name)
        for k, v in pairs(coordsTargets) do
            if v.name == name then
                table.remove(coordsTargets, k)
                break
            end
        end
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

        local closestTargetIndex = nil
        local closestEntity = nil
        local closestDist = math.huge
        local closestIsObject = false

        if not modelTargets._prevEntities then
            modelTargets._prevEntities = {}
        end

        for k, v in pairs(modelTargets) do
            local model = GetHashKey(v.model)
            local peds = GetGamePool('CPed')
            local objects = GetGamePool('CObject')

            for i = 1, #objects do
                local object = objects[i]
                if DoesEntityExist(object) then
                    local objectModel = GetEntityModel(object)
                    if objectModel == model then
                        local objectCoords = GetEntityCoords(object)
                        local distance = #(cachedPed.coords - objectCoords)
                        if distance < closestDist then
                            closestDist = distance
                            closestEntity = object
                            closestTargetIndex = k
                            closestIsObject = true
                        end
                    end
                end
            end

            for i = 1, #peds do
                local ped = peds[i]
                if DoesEntityExist(ped) then
                    local pedModel = GetEntityModel(ped)
                    if pedModel == model then
                        local pedCoords = GetEntityCoords(ped)
                        local distance = #(cachedPed.coords - pedCoords)
                        if distance < closestDist then
                            closestDist = distance
                            closestEntity = ped
                            closestTargetIndex = k
                            closestIsObject = false
                        end
                    end
                end
            end
        end

        for k, v in pairs(modelTargets) do
            local numericK = tonumber(k) or k
            local id = (type(numericK) == "number" and numericK + 10000) or tostring(numericK) .. "_model"
            local prevEntity = modelTargets._prevEntities[k]
            if k == closestTargetIndex and closestEntity and closestDist < 5.0 then
                local entityCoords = GetEntityCoords(closestEntity)
                local radius = math.min(2.0, v.radius or 2.0)
                if prevEntity and prevEntity ~= closestEntity then
                    v.started = false
                    RemoveTarget(id)
                end
                if (not v.started or prevEntity ~= closestEntity) and (not v.handler or v.handler(closestEntity, closestDist)) then
                    for kk, vv in pairs(modelTargets) do
                        if kk ~= k and vv.started then
                            vv.started = false
                            RemoveTarget(kk + 10000)
                            modelTargets._prevEntities[kk] = nil
                        end
                    end
                    threadShouldStart = true
                    v.started = true
                    modelTargets._prevEntities[k] = closestEntity
                    local _, groundZ = GetGroundZFor_3dCoord(entityCoords.x, entityCoords.y, entityCoords.z, 0)
                    table.insert(targetsThread, {
                        event = v.event,
                        label = v.label,
                        coords = vec3(entityCoords.x, entityCoords.y, groundZ + 0.05),
                        radius = radius,
                        id = id
                    })
                    CreateThread(TargetThread)
                elseif v.started then
                    threadShouldStart = true
                end
            elseif v.started then
                v.started = false
                RemoveTarget(id)
                modelTargets._prevEntities[k] = nil
            end
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
