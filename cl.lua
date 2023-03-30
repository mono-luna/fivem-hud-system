local dAOP = Config.sAOP
local dPrio = "~r~Unavailable"
local time = 0
local dPT = Config.sPT

function DrawText(x,y,txt)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.0, 0.35)
    SetTextColour(255, 255, 255, 150)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(txt)
    EndTextCommandDisplayText(x,y)
end

RegisterNetEvent('updateHUD', function(nAOP, nPrio, cdTimer)
    dAOP = nAOP
    dPrio = nPrio
    time = cdTimer
end)

RegisterNetEvent('peacetime', function()
    if dPT then
        dPT = false
        TriggerEvent('chatMessage', "^2^*[Peacetime System] ^r^0Peacetime is now enabled. Please refrain from using weapons.")
    else
        dPT = true
        TriggerEvent('chatMessage', "^2^*[Peacetime System] ^r^0Peacetime is now enabled. You can no longer use weapons until further notice.")
        Citizen.CreateThread(function()
            local player = GetPlayerPed(-1)
            while dPT do
                SetPlayerCanDoDriveBy(player, false)
                DisablePlayerFiring(player, true)
                DisableControlAction(0,24)
                DisableControlAction(0,69)
                DisableControlAction(0,70)
                DisableControlAction(0,92)
                DisableControlAction(0,114)
                DisableControlAction(0,140)
                DisableControlAction(0,257)
                DisableControlAction(0,331)
                Citizen.Wait(0)
            end
        end)
    end
end)

AddEventHandler('playerSpawned', function(spawnInfo)
    TriggerServerEvent('rHUD')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DrawText(0.014, 0.71, "AOP: " .. dAOP)
        if dPrio ~= "~t~Cooldown" then
            DrawText(0.014, 0.74, "Priority: " .. dPrio)
        else
            DrawText(0.014, 0.74, "Priority: " .. dPrio .. " (" .. time .. " Minutes Remaining)")
        end
        if dPT then
            DrawText(0.014, 0.77, "Peacetime: ~g~Enabled")
        else
            DrawText(0.014, 0.77, "Peacetime: ~r~Disabled")
        end
    end
end)

TriggerEvent('chat:addSuggestion', '/aop', 'Change the area of play',{{name="location",help="A general location for all players to go roleplay at"}})
TriggerEvent('chat:addSuggestion', '/pt', 'Turn peacetime on or off')
TriggerEvent('chat:addSuggestion', '/setp', 'Set priority for available police and fire',{{name="type",help="Available Options: available, inprogress, cooldown, pending, or unavailable"}})
