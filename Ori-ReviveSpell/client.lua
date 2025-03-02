RegisterNetEvent('Ori-ReviveSpell:checkIfDead', function()
    local playerPed = PlayerPedId()

    if not IsEntityDead(playerPed) then
        TriggerEvent('ox_lib:notify', {type = 'error', description = 'You can only use this command while dead!'})
    else
        TriggerServerEvent('Ori-ReviveSpell:requestRevive')
    end
end)

RegisterNetEvent('Ori-ReviveSpell:revivePlayer', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    SetEntityHealth(playerPed, 200)
    NetworkResurrectLocalPlayer(playerCoords, true, true, false)

    ClearPedBloodDamage(playerPed)

    if IsScreenFadedOut() then
        DoScreenFadeIn(1000)
    end

    TriggerServerEvent('Ori-ReviveSpell:syncEffect', playerCoords)
end)

RegisterNetEvent('Ori-ReviveSpell:playEffect', function(coords)
    if type(coords) == "table" and coords.x and coords.y and coords.z then
        UseParticleFxAssetNextCall("core")
        local effect = StartParticleFxLoopedAtCoord("exp_grd_flare", coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false, false)  -- if you want change the effect change the "exp_grd_flare"
        Citizen.Wait(5000)
        StopParticleFxLooped(effect, false)
    end
end)
