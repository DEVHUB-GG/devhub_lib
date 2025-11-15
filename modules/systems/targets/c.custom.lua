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
            - @data.handler: The function to call when the target is interacted with. handler = function(entity, distance, coords, name, bone)
        ]]
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
            - @data.handler: The function to call when the target is interacted with. handler = function(entity, distance, coords, name, bone)
            - @data.radius: The radius of the sphere zone
        ]]
        -- Implementation for custom target system would go here
    end

    Core.RemoveCoordsFromTarget = function(name)
        --[[
            This function removes a coords based target zone by its name.
            It contains the following data properties:
            - @name: The unique identifier for the target to be removed
        ]]
        -- Implementation for removing target zone would go here
    end
end)