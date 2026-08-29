local function DebugPrint(msg)
    if Config.Debug then
        print(msg)
    end
end

local function updatePlayerCount(reason)
    local players = GetPlayers()
    local count = #players

    GlobalState.playerCount = count

    DebugPrint("^2[RPC SERVER]^7 Mise à jour du nombre de joueurs")
    DebugPrint(("[RPC SERVER] reason = %s"):format(reason or "unknown"))
    DebugPrint(("[RPC SERVER] playerCount = %s"):format(count))

    if count > 0 then
        DebugPrint(("[RPC SERVER] players = %s"):format(table.concat(players, ", ")))
    else
        DebugPrint("[RPC SERVER] players = aucun joueur connecté")
    end
end

CreateThread(function()
    Wait(Config.ServerStartDelay)
    updatePlayerCount("server_start")

    while true do
        updatePlayerCount("interval")
        Wait(Config.ServerRefreshInterval)
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    DebugPrint("^3[RPC SERVER]^7 playerConnecting détecté")
    DebugPrint(("[RPC SERVER] playerName = %s"):format(playerName or "unknown"))

    SetTimeout(1000, function()
        updatePlayerCount("player_connecting")
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local playerName = GetPlayerName(src)

    DebugPrint("^1[RPC SERVER]^7 playerDropped détecté")
    DebugPrint(("[RPC SERVER] source = %s"):format(src or "unknown"))
    DebugPrint(("[RPC SERVER] playerName = %s"):format(playerName or "unknown"))
    DebugPrint(("[RPC SERVER] reason = %s"):format(reason or "unknown"))

    SetTimeout(1000, function()
        updatePlayerCount("player_dropped")
    end)
end)
