if Shared.Target ~= "ox_target" then return end 
CreateThread( function() 

    Core.AddModelToTarget = function(model, data)
        exports.ox_target:addModel(model, {
            name = data.name, 
            event = data.event,
            icon = data.icon,
            label = data.label,
            canInteract = data.handler
        })
    end
    Core.AddCoordsToTarget = function(coords, data)
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = data.radius or 2.0,
            options = {
                {
                    name = data.name, 
                    event = data.event,
                    icon = data.icon,
                    label = data.label,
                    canInteract = data.handler
                }
            }
        })
    end
end)