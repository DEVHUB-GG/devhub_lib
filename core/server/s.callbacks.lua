Core.ServerCallbacks = {}
Core.RegisterServerCallback = function(name, cb)
	Core.ServerCallbacks[name] = cb
end

Core.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if Core.ServerCallbacks[name] ~= nil then
		Core.ServerCallbacks[name](source, cb, ...)
	end
end

RegisterServerEvent('dh_lib:server:triggerServerCallback', function(name, requestId, ...)
	local source = source
	Core.TriggerServerCallback(name, requestID, source, function(...)
		TriggerClientEvent('dh_lib:client:serverCallback', source, requestId, ...)
	end, ...)
end)