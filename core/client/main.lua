Core = {} 

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