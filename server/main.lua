ESX = nil
local ismysqlloaded = false

AddEventHandler('onMySQLReady', function()
	ismysqlloaded = true
end)
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:on')
AddEventHandler('duty:on', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == 'offpolice' then
            xPlayer.setJob('police', grade)
			TriggerClientEvent('esx:showNotification', _source, _U('ondutylspd'))
			TriggerClientEvent('duty:addWeapons', _source, 'police')
    elseif job == 'offambulance' then
            xPlayer.setJob('ambulance', grade)
			TriggerClientEvent('esx:showNotification', _source, _U('ondutyems'))
			TriggerClientEvent('duty:addWeapons', _source, 'ambulance')
    end
	TriggerClientEvent("duty:setFlyingSkill", _source, 100)

end)

RegisterServerEvent('duty:off')
AddEventHandler('duty:off', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == 'police' or job == 'ambulance' then
        xPlayer.setJob('off' ..job, grade)
        -- TriggerClientEvent('esx:showNotification', _source, _U('offduty'))
		TriggerClientEvent('duty:removeWeapons', _source, job)
    end
	TriggerClientEvent("duty:setFlyingSkill", _source, 0)

end)

function SavePlayerInfo(xPlayer)
	Citizen.Wait(3000)
	ESX.SavePlayer(xPlayer)
end

function SaveJob(id, job)
	while not ismysqlloaded do
		Citizen.Wait(1000) -- wait a sec
	end
	MySQL.Async.execute(
		"UPDATE `users` SET `users`.`job` = '@job' WHERE `users`.`identifier` = '@identifier'",
		{["@job"] = job, ["@identifier"] = GetPlayerIdentifiers(id)[1]}
	)
end
