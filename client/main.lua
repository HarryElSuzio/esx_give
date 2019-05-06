local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["INSERT"] = 121,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData 	= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while true do
		Wait(0)

		if IsControlJustReleased(0, Keys['F3']) and GetLastInputMethod(2) then
			OpenMainActions()
		end
	end
	
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

--== Main Actions ==--
function OpenMainActions()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_actions', {
		title    = _U('main_actions'),
		align    = 'top-left',
		elements = {
			{label = _U('ineraction_actions'),	value = 'ineraction_actions'}
		}
	}, function(data, menu)
		--menu.close()
		local action = data.current.value
		
		--== Interactions Actions ==--
		if action == 'ineraction_actions' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ineraction_actions', {
				title    = _U('ineraction_actions'),
				align    = 'top-left',
				elements = {
					{label = _U('give_phone'),	value = 'give_phone'},
					{label = _U('show_id'),		value = 'show_id'}
				}
			}, function(data2, menu2)
				local action2 = data2.current.value

				if action2 == 'give_phone' then
					print('Triggered give_phone 1')
					SendProximityMessageGivePhone()
				elseif action2 == 'show_id' then
					print('Triggered show_id 1')
					SendProximityMessageShowID()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function (data, menu)
		menu.close()
	end)
end

--== Interactions Actions GUI ==--
-- give_phone
RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	if pid == myId then
		TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
		print('Show Phone 1')
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
		print('Show Phone 2')
	end
end)

function SendProximityMessageGivePhone()
	print('Triggered give_phone 2')
	TriggerEvent('esx_give:give_phone')
	
	--[[ESX.TriggerServerCallback('esx_give:getPlayerData', function(data)
		local nameLabel   = _U('name', data.name)
		local phoneLabel  = nil
		
		nameLabel  = _U('name', data.firstname .. ' ' .. data.lastname)
		phoneLabel = _U('phone', data.phone)
		
		local myId = PlayerId()
		local pid = GetPlayerFromServerId(id)
		
		if pid == myId then
			TriggerEvent('chatMessage', "^*^3" .. nameLabel .. "^*^7 | ^*^5" .. phoneLabel)
			print('Show Phone 1')
		elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
			TriggerEvent('chatMessage', "^*^3" .. nameLabel .. "^*^7 | ^*^5" .. phoneLabel)
			print('Show Phone 2')
		end
	end)]]--
end

-- show_id
RegisterNetEvent('sendProximityMessageID')
AddEventHandler('sendProximityMessageID', function(id, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	
	if pid == myId then
		TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
		print('Show ID 1')
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
		print('Show ID 2')
	end
end)

function SendProximityMessageShowID()
	print('Triggered show_id 2')
	TriggerEvent('esx_give:show_id')
	
	--[[ESX.TriggerServerCallback('esx_give:getPlayerData', function(data)
		local nameLabel   = _U('name', data.name)
		nameLabel  = _U('name', data.firstname .. ' ' .. data.lastname)
		
		local myId = PlayerId()
		local pid = GetPlayerFromServerId(id)
		
		if pid == myId then
			TriggerEvent('chatMessage', "^*^3" .. nameLabel)
			print('Show ID 1')
		elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
			TriggerEvent('chatMessage', "^*^3" .. nameLabel)
			print('Show ID 2')
		end
	end)]]--
end
