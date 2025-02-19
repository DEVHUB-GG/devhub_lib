Shared = {}

-- This module contains shared configuration settings for the dh_lib.
-- vRP support is currently in beta. Please report any issues you encounter, check before using in production environments.

-- The framework being used. Possible frameworks: "AUTO DETECT", "ESX", "QBCore", "QBOX" , "VRP" , "custom"
Shared.Framework = "AUTO DETECT"

-- The target system being used. Possible targets: "AUTO DETECT", "ox_target", "qb-target", "standalone", "custom" 
Shared.Target = "AUTO DETECT"

-- Vehicle keys system being used. Possible vehicle keys: "AUTO DETECT", "qb-vehiclekeys", "qs-vehiclekeys", "ak47_vehiclekeys", "t1ger_keys", "Renewed-Vehiclekeys", "cd_garage", "custom"
Shared.VehicleKeys = "AUTO DETECT" 

-- Fuel system being used. Possible fuel systems: "AUTO DETECT", "LegacyFuel", "ps-fuel", "ox_fuel", "cd_fuel", "custom"
Shared.VehicleFuel = "AUTO DETECT"

-- Enable compatibility tests for the selected framework. !!WARNING!! This must be turned off in production environments.
Shared.CompatibilityTest = false
-- 1. Add new item dh_test
-- 2. Restart your server
-- 3. Join the server and type /dh_startTest to start the test
-- 4. Use item dh_test
-- 5. Revive yourself when you die
-- 6. You will be kicked from the server
-- 7. Check the server console for the test results

-- ESX
-- INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('dh_test', 'DEVHUB TEST', 1, 0, 1);

-- QBOX
--	['dh_test'] 			 = {['name'] = 'dh_test', 				['label'] = 'Dh test', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'dh_test.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'DEVHUB TEST ITEM'},

-- qb-core/shared/items.lua 
-- ["dh_test"] = {
--     ["name"] = "dh_test",                                                        
--     ["label"] = "DEVHUB TEST",
--     ["weight"] = 1,
--     ["type"] = "item",
--     ["image"] = "dh_test.png",
--     ["unique"] = false,
--     ["useable"] = true,
--     ["shouldClose"] = true,
--     ["combinable"] = nil,
--     ["description"] = ""
-- },

-- ox_inventory/data/items.lua
-- ['dh_test'] = {
--     label = 'DEVHUB TEST',
--     weight = 1,
--     stack = true,
--     close = true,
--     description = ""
-- },