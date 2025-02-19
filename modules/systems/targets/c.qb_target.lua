if Shared.Target ~= "qb-target" then return end 
CreateThread( function() 
 
    Core.AddModelToTarget = function(model, data)
        exports['qb-target']:AddTargetModel({model}, {
            options = {
                {
                    event = data.event,
                    icon = data.icon,
                    label = data.label,
                    canInteract = data.handler
                },
            },
            distance = 2.5,
        })
    end
    Core.AddCoordsToTarget = function(coords, data)
        exports['qb-target']:AddCircleZone(data.name, coords, data.radius or 2.0, {
            name = data.name,
            useZ = true,
        }, {
            options = {
                {
                    event = data.event,
                    icon = data.icon,
                    label = data.label,
                    canInteract = data.handler
                }
            },
            distance = data.radius or 2.0
        })
    end
end)