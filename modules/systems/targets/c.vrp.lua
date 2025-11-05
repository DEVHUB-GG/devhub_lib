if Shared.Target ~= "custom" then return end 
CreateThread( function() 

    Core.AddModelToTarget = function(model, data)
        --[[
            This file defines a custom target for the DH framework.
            It contains the following data properties:
            - @data.name: The unique identifier for the target.
            - @data.event: The event that triggers the target.
            - @data.icon: The icon to display for the target (using FontAwesome).
            - @data.label: The label to display on the target.
            - @data.handler: The function to call when the target is interacted with.
        ]]
        exports["target"]:AddTargetModel(model, {
            options = {
                {
                    event = data.event,
				    label = data.label,
				    tunnel = "client"  
                }
            },
            Distance = 1.5
        })
    end

    Core.AddCoordsToTarget = function(coords, data)
        --[[
            This function adds a spherical target zone at specified coordinates.
            It contains the following data properties:
            - @coords: Vector3 coordinates where to place the target zone
            - @data.name: The unique identifier for the target
            - @data.event: The event that triggers the target
            - @data.icon: The icon to display for the target (using FontAwesome)
            - @data.label: The label to display on the target
            - @data.handler: The function to call when the target is interacted with
            - @data.radius: The radius of the sphere zone
        ]]
        -- Implementation for custom target system would go here
        exports["target"]:AddCircleZone(data.name, coords.xyz, 0.5, {
            name = data.name,
            heading = 0.0
        }, {
            Distance = 1.5,
            options = {
                {
                    event = data.event,
                    label = data.label,
                    tunnel = "client",
                },
            }
        })
    end
    Core.RemoveCoordsFromTarget = function(name)
        exports["target"]:RemoveZone(name)
    end
end)