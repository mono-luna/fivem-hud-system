nAOP = Config.sAOP
nPrio = "~r~Unavailable"
cdTimer = 0

function startTimer(duration)
    local startTime = GetGameTimer()
    Citizen.CreateThread(function()
        while true do
            local remainingTime = duration - ((GetGameTimer() - startTime) / 60000)
            local remainingTimeR = math.floor(remainingTime)
            cdTimer = remainingTimeR
            TriggerClientEvent('updateHUD', -1, nAOP, nPrio, cdTimer)
            Citizen.Wait(1000)
            if remainingTimeR <= 0 then
                nPrio = "~g~Available"
                TriggerClientEvent('updateHUD', -1, nAOP, nPrio, cdTimer)
                TriggerClientEvent('chatMessage', -1, "^5^*[Priority System] ^r^0Priority is now available. You can now kill, rob, run from the police, and more!")
                break
            end
        end
    end)
end

RegisterNetEvent('rHUD', function()
    TriggerClientEvent('updateHUD', -1, nAOP, nPrio, cdTimer)
end)

RegisterServerEvent("startCDTimer")
AddEventHandler("startCDTimer", function(duration)
  startTimer(duration)
end)

RegisterCommand('aop', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.AOP) then
        local aop = table.concat(args, " ")
        if aop == "" then
            TriggerClientEvent('chatMessage', source, "^1ERROR^0: Please chose an AOP!")
        else
            nAOP = aop
            TriggerClientEvent('chatMessage', -1, "^4^*[AOP System] ^r^0The AOP has been switched to ~h~" .. aop .. "~s~! Please finish up any scenes you are involved in, and move to the new AOP.")
            TriggerClientEvent('updateHUD', -1, nAOP, nPrio, cdTimer)
        end
    else
        TriggerClientEvent('chatMessage', source, "^1ERROR^0: Insufficient Permissions!")
    end
end, false)

RegisterCommand('setp', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, Config.Priority) then
        prio = table.concat(args, " ")
        if prio == "available" then
            TriggerClientEvent('chatMessage', -1, "^5^*[Priority System] ^r^0Priority is now available. You can now kill, rob, run from the police, and more!")
            nPrio = "~g~Available"
        elseif prio == "inprogress" then
            TriggerClientEvent('chatMessage', -1, "^5^*[Priority System] ^r^0Priority is now in progress. You can not kill, rob, run from police, etc, unless your apart of the priority.")
            nPrio = "~y~In Progress"
        elseif prio == "unavailable" then
            TriggerClientEvent('chatMessage', -1, "^5^*[Priority System] ^r^0Priority is now unavailable. Please keep acts of violence  to minimum.")
            nPrio = "~r~Unavailable"
        elseif prio == "pending" then
            TriggerClientEvent('chatMessage', -1, "^5^*[Priority System] ^r^0Priority is now pending, please wait until further notice.")
            nPrio = "~o~Pending"
        elseif prio == "cooldown" then
            TriggerClientEvent('chatMessage', -1, "^5^*[Priority System] ^r^0Priority is now on cooldown. Please give law enforcement and other departments time to recuperate.")
            TriggerEvent('startCDTimer', Config.Time + 1)
            nPrio = "~t~Cooldown"
        elseif prio == "" then
            TriggerClientEvent('chatMessage', source, "^5^*[Priority System] ^r^1ERROR^0: Please enter a priority type!")
        end
        TriggerClientEvent('updateHUD', -1, nAOP, nPrio, cdTimer)
    else
        TriggerClientEvent('chatMessage', source, "^5^*[Priority System] ^r^1ERROR^0: Insufficient Permissions!")
    end
end, false)

RegisterCommand('pt', function(source, rawCommand)
    if IsPlayerAceAllowed(source, Config.PT) then
        TriggerClientEvent('peacetime', -1)
    else
        TriggerClientEvent('chatMessage', source, "^2^*[Peacetime System] ^r^1ERROR^0: Insufficient Permissions!")
    end
end, false)
