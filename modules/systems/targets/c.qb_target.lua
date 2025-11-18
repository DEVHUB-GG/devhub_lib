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
        local options = {}
        if data and data[1] then
            for _, v in pairs(data) do
                options[#options + 1] = {
                    event = v.event,
                    icon = v.icon,
                    label = v.label,
                    canInteract = v.handler,
                    name = v.name,
                    radius = v.radius,
                }
            end
        else
            options = {
                {
                    event = data.event,
                    icon = data.icon,
                    label = data.label,
                    canInteract = data.handler,
                    name = data.name,
                    radius = data.radius,
                }
            }
        end
        exports['qb-target']:AddCircleZone(options[1].name, coords, options[1].radius or 2.0, {
            name = options[1].name,
            useZ = true,
        }, {
            options = options,
            distance = options[1].radius or 2.0
        })
    end
    Core.RemoveCoordsFromTarget = function(name)
        exports['qb-target']:RemoveZone(name)
    end
end)