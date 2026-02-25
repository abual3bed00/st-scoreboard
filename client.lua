local QBCore = exports['qb-core']:GetCoreObject()
local scoreboardOpen = false
local playerOptin = {}

local function DrawText3D(x, y, z, text)
    SetTextFont(4)
    SetTextScale(0.4, 0.4)
    SetTextColour(255, 107, 26, 255)  --لون ال id 
    SetTextCentre(true)
    
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z + 1, 0) 
    EndTextCommandDisplayText(0.0, 0.0)
    
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players + 1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}
    coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or 5.0
    for i = 1, #players do
        local player = players[i]
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = player
        end
    end
    return closePlayers
end

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    if Config.IllegalActions[activity] then
        Config.IllegalActions[activity].busy = busy
    elseif Config.KidnapSettings[activity] then
        Config.KidnapSettings[activity].busy = busy
    end
end)

if Config.Toggle then
    RegisterCommand('scoreboard', function()
        if not scoreboardOpen then
            QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetScoreboardData', function(players, cops, playerList, jobCounts, uptime, allActions)
                playerOptin = playerList or {}
                local playerPing = NetworkGetAverageLatencyForPlayer(PlayerId())
                SendNUIMessage({
                    action = 'open',
                    players = players,
                    maxPlayers = Config.MaxPlayers,
                    currentCops = cops,
                    ping = playerPing,
                    jobCounts = jobCounts or {},
                    uptime = uptime,
                    allActions = allActions or {}
                })
                scoreboardOpen = true
            end)
        else
            SendNUIMessage({ action = 'close' })
            scoreboardOpen = false
        end
    end, false)
    RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
else
    RegisterCommand('+scoreboard', function()
        if scoreboardOpen then return end
        QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetScoreboardData', function(players, cops, playerList, jobCounts, uptime, allActions)
            playerOptin = playerList or {}
            local playerPing = NetworkGetAverageLatencyForPlayer(PlayerId())
            SendNUIMessage({
                action = 'open',
                players = players,
                maxPlayers = Config.MaxPlayers,
                currentCops = cops,
                ping = playerPing,
                jobCounts = jobCounts or {},
                uptime = uptime,
                allActions = allActions or {}
            })
            scoreboardOpen = true
        end)
    end, false)
    RegisterCommand('-scoreboard', function()
        if not scoreboardOpen then return end
        SendNUIMessage({ action = 'close' })
        scoreboardOpen = false
    end, false)
    RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
end

CreateThread(function()
    Wait(5000)
    while true do
        if scoreboardOpen then
            QBCore.Functions.TriggerCallback('qb-scoreboard:server:GetScoreboardData', function(players, cops, playerList, jobCounts, uptime, allActions)
                local playerPing = NetworkGetAverageLatencyForPlayer(PlayerId())
                SendNUIMessage({
                    action = 'update',
                    players = players,
                    maxPlayers = Config.MaxPlayers,
                    currentCops = cops,
                    ping = playerPing,
                    jobCounts = jobCounts or {},
                    uptime = uptime,
                    allActions = allActions or {}
                })
            end)
        end
        Wait(5000)
    end
end)

CreateThread(function()
    while true do
        local loop = 100
        if scoreboardOpen then
            local playersNearby = GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 20.0)
            for _, player in pairs(playersNearby) do
                local playerId = GetPlayerServerId(player)
                local playerPed = GetPlayerPed(player)
                local playerCoords = GetEntityCoords(playerPed)
                if Config.ShowIDforALL or (playerOptin[playerId] and playerOptin[playerId].optin) then
                    loop = 0
                    DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z, '' .. playerId .. '')
                end
            end
        end
        Wait(loop)
    end
end)