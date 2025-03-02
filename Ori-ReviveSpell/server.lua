local QBCore = exports['qb-core']:GetCoreObject()
local Config = {
    BotToken = "your bot token", -- your bot token
    GuildID = "your server id", -- your server id
    RoleID = "your role id" -- your role id
}

local function GetDiscordID(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.match(id, "discord:") then
            return string.gsub(id, "discord:", "")
        end
    end
    return nil
end

local function HasDiscordRole(discordID, callback)
    if not discordID then return callback(false) end

    local url = ("https://discord.com/api/guilds/%s/members/%s"):format(Config.GuildID, discordID)
    local headers = {
        ["Authorization"] = "Bot " .. Config.BotToken,
        ["Content-Type"] = "application/json"
    }

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.roles then
                for _, role in pairs(data.roles) do
                    if role == Config.RoleID then
                        return callback(true)
                    end
                end
            end
        end
        return callback(false)
    end, "GET", "", headers)
end

RegisterCommand("r", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('Ori-ReviveSpell:checkIfDead', src)
end, false)

RegisterNetEvent('Ori-ReviveSpell:requestRevive')
AddEventHandler('Ori-ReviveSpell:requestRevive', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if not player then return end

    local discordID = GetDiscordID(src)
    HasDiscordRole(discordID, function(hasRole)
        if hasRole then
            TriggerClientEvent('Ori-ReviveSpell:revivePlayer', src)
            TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = 'You have been revived!'})
            TriggerClientEvent('Ori-ReviveSpell:playEffect', -1, GetEntityCoords(GetPlayerPed(src)))
        else
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'You do not have permission to use this command!'})
        end
    end)
end)

RegisterNetEvent('Ori-ReviveSpell:syncEffect')
AddEventHandler('Ori-ReviveSpell:syncEffect', function(coords)
    if type(coords) == "vector3" then
        coords = { x = coords.x, y = coords.y, z = coords.z }
    end
    TriggerClientEvent('Ori-ReviveSpell:playEffect', -1, coords)
end)
