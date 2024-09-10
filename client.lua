local MPH = true 
local KPH = false
local uiopen = false
if MPH then
  factor = 3.6
else
  factor = 3.6 
end
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(10)
	end
end)

local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,17,18,19,20};


local function Roundto5(to_round)
    local divided = to_round / 5
    local rounded = 5 * math.floor(divided)
    return rounded
end

local vehicleSpeedSource = 0
local vehicleSpeedSourceKMH = 0
local vehicleCruiser
local showtimer = false

 

 
local function TransformToKm(speed) return math.floor(speed *factor) end -- Uncomment me for km/h

 
RegisterKeyMapping('speedup', 'Tempo erhöhen', 'keyboard', 'UP')
RegisterCommand('speedup',function()
	local player = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(player, false)
	local vehicleClass = GetVehicleClass(vehicle)
	if GetPedInVehicleSeat(vehicle, -1) == player and (has_value(vehiclesCars, vehicleClass) == true)  and vehicleCruiser == 'on'  then
		local usespeed = Roundto5((vehicleSpeedSource * factor ) + 5)
		if usespeed > 250 then
			TriggerEvent('notifications', "error", 'Cruiser-System', 'Der Cruiser kann nur bis 250km/h erhöht werden!')
		else
			vehicleSpeedSource=usespeed / factor
			SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
			SendNUIMessage({
				type = 'tempomat', state = 1, speed = TransformToKm(vehicleSpeedSource),
			})
		end
	end
end)


RegisterKeyMapping('speeddown', 'Tempo verringern', 'keyboard', 'DOWN')
RegisterCommand('speeddown',function()
	local player = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(player, false)
	local vehicleClass = GetVehicleClass(vehicle)
	if GetPedInVehicleSeat(vehicle, -1) == player and (has_value(vehiclesCars, vehicleClass) == true) and vehicleCruiser == 'on' then
		local usespeed = Roundto5((vehicleSpeedSource * factor ) - 5)
		if usespeed < 30 then
			TriggerEvent('notifications', "error", 'Cruiser-System', 'Der Cruiser kann nur bis 30 km/h reduziert werden!')
		else
			vehicleSpeedSource=usespeed / factor
			SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
			SendNUIMessage({
				type = 'tempomat', state = 1, speed = TransformToKm(vehicleSpeedSource),
			})
		end
		
	end
end)


RegisterKeyMapping('togglecruiser', 'Cruiser an/aus verringern', 'keyboard', 'LSHIFT')
RegisterCommand('togglecruiser',function()
	local player = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(player, false)
	local vehicleClass = GetVehicleClass(vehicle)
	if GetPedInVehicleSeat(vehicle, -1) == player and (has_value(vehiclesCars, vehicleClass) == true) then
		vehicleSpeedSource = GetEntitySpeed(vehicle)
		if vehicleCruiser == 'on' then
			vehicleCruiser = 'off'
			SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
			TriggerEvent('notifications', "error", 'Cruiser-System', 'Cruiser wurde deaktiviert!')
			SendNUIMessage({
				type = 'tempomat', state = 0, speed = TransformToKm(vehicleSpeedSource),
			})
		else

			local usespeed = Roundto5((vehicleSpeedSource * factor ) )
			if usespeed > 250 or usespeed < 30 then
				TriggerEvent('notifications', "error", 'Cruiser-System', 'Der Cruiser kann nur von 30 bis 250 km/h genutzt werden!')
			else
				vehicleCruiser = 'on'
				SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
				TriggerEvent('notifications', "success", 'Cruiser-System', 'Cruiser aktiviert: '..TransformToKm(vehicleSpeedSource)..' km/h!') 
				SendNUIMessage({
					type = 'tempomat', state = 1, speed = TransformToKm(vehicleSpeedSource),
				})
			end
			
		end
	end
end)


Citizen.CreateThread(function()
	while false do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(player, false)
		local vehicleClass = GetVehicleClass(vehicle)
		if IsControlJustPressed(1, 172) and GetPedInVehicleSeat(vehicle, -1) == player and (has_value(vehiclesCars, vehicleClass) == true)  and vehicleCruiser == 'on'  then
			local usespeed = Roundto5((vehicleSpeedSource * factor ) + 5)
			if usespeed > 250 then
				TriggerEvent('notifications', "error", 'Cruiser-System', 'Der Cruiser kann nur bis 250km/h erhöht werden!')
			else
				vehicleSpeedSource=usespeed / factor
				SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
				SendNUIMessage({
					type = 'tempomat', state = 1, speed = TransformToKm(vehicleSpeedSource),
				})
			end
		end
		if IsControlJustPressed(1, 173) and GetPedInVehicleSeat(vehicle, -1) == player and (has_value(vehiclesCars, vehicleClass) == true) and vehicleCruiser == 'on' then
			local usespeed = Roundto5((vehicleSpeedSource * factor ) - 5)
			if usespeed < 30 then
				TriggerEvent('notifications', "error", 'Cruiser-System', 'Der Cruiser kann nur bis 30 km/h reduziert werden!')
			else
				vehicleSpeedSource=usespeed / factor
				SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
				SendNUIMessage({
					type = 'tempomat', state = 1, speed = TransformToKm(vehicleSpeedSource),
				})
			end
			
		end
		-- Vehicle Cruiser
		if IsControlJustPressed(1, 209) and GetPedInVehicleSeat(vehicle, -1) == player and (has_value(vehiclesCars, vehicleClass) == true) then
			vehicleSpeedSource = GetEntitySpeed(vehicle)
			

			if vehicleCruiser == 'on' then
				vehicleCruiser = 'off'
				SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
				TriggerEvent('notifications', "error", 'Cruiser-System', 'Cruiser wurde deaktiviert!')
				SendNUIMessage({
					type = 'tempomat', state = 0, speed = TransformToKm(vehicleSpeedSource),
				})
			else

				local usespeed = Roundto5((vehicleSpeedSource * factor ) )
				if usespeed > 250 or usespeed < 30 then
					TriggerEvent('notifications', "error", 'Cruiser-System', 'Der Cruiser kann nur von 30 bis 250 km/h genutzt werden!')
				else
					vehicleCruiser = 'on'
					SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
					TriggerEvent('notifications', "success", 'Cruiser-System', 'Cruiser aktiviert: '..TransformToKm(vehicleSpeedSource)..' km/h!') 
					SendNUIMessage({
						type = 'tempomat', state = 1, speed = TransformToKm(vehicleSpeedSource),
					})
				end
				
			end
		end
	end
end)


function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local vehicleisin

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		
		if(IsPedInAnyVehicle(ped)) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			vehicleisin = vehicle
			if vehicle then
				carSpeed = math.ceil(GetEntitySpeed(vehicle) * factor)
				carRPM = GetVehicleCurrentRpm(vehicle)
				carFuel = GetVehicleFuelLevel(vehicle)
				local isLocked  = GetVehicleDoorLockStatus(vehicle)
				local isEngine = GetIsVehicleEngineRunning(vehicle)
				SendNUIMessage({
					type = 'active',
					speed = carSpeed,
					fuel = ESX.Math.Round(carFuel),
					isLocked = isLocked,
					isEngine = isEngine				
				})
				Citizen.Wait(50)
				if uiopen == false then 
					uiopen = true
					
					SendNUIMessage({
						type = 'showui',
					})
				--	ESX.ShowHelpNotification('Drücke ~INPUT_SPRINT~ um den Cruiser zu de- und aktivieren und ~INPUT_CELLPHONE_UP~ / ~INPUT_CELLPHONE_DOWN~ um die Geschwindkeit zu regulieren!',false,true,5000) --
				end
			else
				if uiopen == true then
					uiopen = false
					SendNUIMessage({
						type = 'tempomat', state = 0, speed = TransformToKm(vehicleSpeedSource),
					})
					vehicleCruiser = 'off'
					SetEntityMaxSpeed(vehicleisin, GetVehicleHandlingFloat(vehicleisin,"CHandlingData","fInitialDriveMaxFlatVel"))
					SendNUIMessage({
						type = 'deactive',
					})
				end
				Citizen.Wait(1000)
			end
		else
			if uiopen == true then 
				uiopen = false
				SendNUIMessage({
					type = 'tempomat', state = 0, speed = TransformToKm(vehicleSpeedSource),
				})
				vehicleCruiser = 'off'
				SetEntityMaxSpeed(vehicleisin, GetVehicleHandlingFloat(vehicleisin,"CHandlingData","fInitialDriveMaxFlatVel"))
				SendNUIMessage({
					type = 'deactive',
				})
			end
			Citizen.Wait(100)
		end

		Citizen.Wait(10)
	end
end)



RegisterNetEvent('carhud:toggle')
AddEventHandler('carhud:toggle', function(show)
	if(IsPedInAnyVehicle(PlayerPedId())) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if vehicle then
			SendNUIMessage({action = "toggle", show = show})
		end
	end
end)
