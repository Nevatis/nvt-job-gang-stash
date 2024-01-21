local QBCore = exports['qb-core']:GetCoreObject()


Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    while true do
    wait = 5
    local ped = PlayerPedId()
    local inZone = false

    for k, v in pairs(Config.Stash) do

        local dist = #(GetEntityCoords(ped)-vector3(Config.Stash[k].coords.x, Config.Stash[k].coords.y, Config.Stash[k].coords.z))
        if dist <= 3.0 then
        wait = 5
        inZone  = true

        if IsControlJustReleased(0, 38) then
            TriggerEvent('qb-business:client:openStash', k, Config.Stash[k].stashName)
        end
        break
        else
        wait = 2000
        end
    end

    if inZone and not alreadyEnteredZone then
        alreadyEnteredZone = true
        TriggerEvent('nvt-drawtext:ShowUI', 'show', Config.Text)
    end

    if not inZone and alreadyEnteredZone then
        alreadyEnteredZone = false
        TriggerEvent('nvt-drawtext:HideUI')
    end
    Citizen.Wait(wait)
    end
end)

RegisterNetEvent('qb-business:client:openStash', function(currentstash, stash)

    local PlayerData = QBCore.Functions.GetPlayerData()
    local PlayerJob = PlayerData.job.name
    local PlayerGang = PlayerData.gang.name
    local canOpen = false

    if Config.PoliceOpen then 
        if PlayerJob == "police" then
            canOpen = true
        end
    end

    if Config.Stash[currentstash].jobrequired then 
        if PlayerJob == Config.Stash[currentstash].job then
            canOpen = true
        end
    end

    if Config.Stash[currentstash].requirecid then
        for k, v in pairs (Config.Stash[currentstash].cid) do 
            if QBCore.Functions.GetPlayerData().citizenid == v then
                canOpen = true
            end
        end
    end

    if Config.Stash[currentstash].gangrequired then
        if PlayerGang == Config.Stash[currentstash].gang then
            canOpen = true
        end
    end

    if canOpen then 
        TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.Stash[currentstash].stashName, {maxweight = Config.Stash[currentstash].stashSize, slots = Config.Stash[currentstash].stashSlots})
        TriggerEvent("inventory:client:SetCurrentStash", Config.Stash[currentstash].stashName)
    else
        QBCore.Functions.Notify('You dont have access', 'error')
    end

end)
