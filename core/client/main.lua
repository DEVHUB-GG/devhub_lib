Core = {} 

LoadedSystems = {
    ["framework"] = false,
    ['inventory'] = false,
    ['targets'] = false,
    ['callbacks'] = false,
}

local function areSystemsLoaded()
    for _, loaded in pairs(LoadedSystems) do
        if not loaded then
            return false
        end
    end
    return true 
end

-- PolyZone functionality
Core.CreatePolyZone = function(points, options)
    return PolyZone:Create(points, options)
end

Core.PolyZone = PolyZone

createExport("GetCoreObject", function()
    return Core
end)

-- Direct PolyZone exports for easier usage
createExport("CreatePolyZone", function(points, options)
    return PolyZone:Create(points, options)
end)

createExport("GetPolyZoneClass", function()
    return PolyZone
end)

Citizen.CreateThread(function()
    Wait(15000)
    while not areSystemsLoaded() do
        print("^1-------------------WARNING---------------------^7")
        print("^1Not all systems have loaded yet. Please check the console for any errors. devhub_lib is not ready to use. Scripts might not work properly^7")
        for system, loaded in pairs(LoadedSystems) do
            if not loaded then
                print("^1System not loaded: ^3"..system.."^7")
            end
        end
        print("^1-------------------WARNING---------------------^7")
        Wait(15000)
    end
end)

Citizen.CreateThread(function()
    while not areSystemsLoaded() do
        Wait(100)
    end

    Core.Loaded = true
    TriggerServerEvent("dh_lib:server:clientReady")
    print("^1----------------------------------------^7")
    print("^3devhub_lib:^2  All client systems loaded Core.Loaded is ready^7")
    print("^1----------------------------------------^7")
end)