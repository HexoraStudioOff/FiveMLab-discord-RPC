local function DebugPrint(msg)
    if Config.Debug then
        print(msg)
    end
end

CreateThread(function()
    Wait(Config.ClientStartDelay)

    DebugPrint("^3[RPC CLIENT]^7 Initialisation du Rich Presence...")
    DebugPrint(("[RPC CLIENT] AppId = %s"):format(Config.AppId))
    DebugPrint(("[RPC CLIENT] ServerName = %s"):format(Config.ServerName))
    DebugPrint(("[RPC CLIENT] StoreUrl = %s"):format(Config.StoreUrl))
    DebugPrint(("[RPC CLIENT] DiscordUrl = %s"):format(Config.DiscordUrl))
    DebugPrint(("[RPC CLIENT] LargeAsset = %s"):format(Config.LargeAsset))
    DebugPrint(("[RPC CLIENT] SmallAsset = %s"):format(Config.SmallAsset))

    while true do
        local count = GlobalState.playerCount
        if count == nil then
            count = 0
            DebugPrint("^1[RPC CLIENT]^7 GlobalState.playerCount est nil, fallback sur 0")
        end

        SetDiscordAppId(Config.AppId)

        local richText = ("En jeu sur %s | %s joueurs en ligne"):format(Config.ServerName, count)
        SetRichPresence(richText)

        SetDiscordRichPresenceAsset(Config.LargeAsset)
        SetDiscordRichPresenceAssetText(Config.ServerName)

        SetDiscordRichPresenceAssetSmall(Config.SmallAsset)
        SetDiscordRichPresenceAssetSmallText(("%s joueurs en ligne"):format(count))

        SetDiscordRichPresenceAction(0, "🛒 Boutique", Config.StoreUrl)
        SetDiscordRichPresenceAction(1, "❤️ Discord", Config.DiscordUrl)

        DebugPrint("^2[RPC CLIENT]^7 Mise à jour envoyée à Discord")
        DebugPrint(("[RPC CLIENT] playerCount = %s"):format(count))
        DebugPrint(("[RPC CLIENT] richText = %s"):format(richText))
        DebugPrint(("[RPC CLIENT] button[0] Boutique = %s"):format(Config.StoreUrl))
        DebugPrint(("[RPC CLIENT] button[1] Discord = %s"):format(Config.DiscordUrl))

        Wait(Config.ClientRefreshInterval)
    end
end)
