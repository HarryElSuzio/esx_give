ESX	= nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- getPlayerData
function getPlayerData(source, cb)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(source)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height, phone_number FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height
		local phone     = result[1].phone_number
		local data = {
			name      = GetPlayerName(source),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			phone     = phone
		}

		TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', source, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		local data = {
			name       = GetPlayerName(source),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', source, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end

-- give_phone
RegisterServerEvent('esx_give:give_phone')
AddEventHandler('esx_give:give_phone', function(source)
	getPlayerData(source, function(data)
		print(data.firstname .. " " .. data.lastname .. " " .. data.phone)
		if data ~= nil then
			local name = data.firstname .. " " .. data.lastname
			name = data.firstname .. " " .. data.lastname
			TriggerClientEvent('sendProximityMessagePhone', -1, source, name, data.phone)
		end
	end)
end)

-- give_id
RegisterServerEvent('esx_give:show_id') 
AddEventHandler('esx_give:show_id', function(source)
	getPlayerData(source, function(data)
		print(data.firstname .. " " .. data.lastname)
		--if data ~= nil then
			local name = data.firstname .. " " .. data.lastname
			TriggerClientEvent('sendProximityMessageID', -1, source, name)
		--end
	end)
end)

-- my_id
ESX.RegisterServerCallback('esx_give:getPlayerData', function(source, cb)
	getPlayerData(source, function(data)
		print(data.firstname .. " " .. data.lastname .. " " .. data.phone)
		if data ~= nil then
			cb(data)
		end
	end)
end)
