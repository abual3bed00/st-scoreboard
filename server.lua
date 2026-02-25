local QBCore = exports['qb-core']:GetCoreObject()
local ServerStartTime = os.time() -- وقت بدء تشغيل السيرفر

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetScoreboardData', function(_, cb)
    local totalPlayers = 0
    local policeCount = 0
    local players = {}
    local jobCounts = {}

    for job, _ in pairs(Config.TrackedJobs) do
        jobCounts[job] = 0
    end

    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v then
            totalPlayers = totalPlayers + 1
            local jobName = v.PlayerData.job.name
            local onduty = v.PlayerData.job.onduty

            if jobName == 'police' and onduty then
                policeCount = policeCount + 1
            end

            if Config.TrackedJobs[jobName] and onduty then
                jobCounts[jobName] = jobCounts[jobName] + 1
            end

            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = QBCore.Functions.IsOptin(v.PlayerData.source)
        end
    end

    local uptimeSeconds = os.time() - ServerStartTime
    local uptimeHours = math.floor(uptimeSeconds / 3600)
    local uptimeMinutes = math.floor((uptimeSeconds % 3600) / 60)
    local uptimeString = string.format("%dh %dm", uptimeHours, uptimeMinutes)

    -- دمج جميع الإجراءات (الأنشطة + الخطف)
    local allActions = {}
    for k, v in pairs(Config.IllegalActions) do
        allActions[k] = v
    end
    for k, v in pairs(Config.KidnapSettings) do
        allActions[k] = v
    end

    cb(totalPlayers, policeCount, players, jobCounts, uptimeString, allActions)
end)

RegisterNetEvent('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    if Config.IllegalActions[activity] then
        Config.IllegalActions[activity].busy = bool
    elseif Config.KidnapSettings[activity] then
        Config.KidnapSettings[activity].busy = bool
    end
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)