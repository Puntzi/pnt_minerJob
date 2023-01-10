lib.locale()
LocalPlayer.state.isWorking = false
local rocksBlip = {}
local rocksMined = {}

local function AddBlips(coords, sprite, scale, colour, name)
    local rock = AddBlipForCoord(coords)

    SetBlipSprite (rock, sprite)
    SetBlipDisplay(rock, 4)
    SetBlipScale  (rock, scale)
    SetBlipColour (rock, colour)
    SetBlipAsShortRange(rock, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(locale('rock'))
    EndTextCommandSetBlipName(rock)

    table.insert(rocksBlip, rock)
end

local function startTimer(rock)
    SetTimeout((Config.CoolDoownForEachRock * 1000), function()
        rocksMined[rock] = false
    end)
end

local function startMining(rock)
    if rocksMined[rock] then 
        return lib.notify({type = 'error', description = locale("rock_already_mined")})
    end

    rocksMined[rock] = true

    local dict = lib.requestAnimDict('melee@hatchet@streamed_core')

    FreezeEntityPosition(cache.ped, true)

    for i = 1, Config.RockSkillCheck.repeatTimes do
        local success = lib.skillCheck({Config.RockSkillCheck.difficulty})
        if success then 
            TaskPlayAnim(cache.ped, dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
            local timer = GetGameTimer() + 1200
            while GetGameTimer() <= timer do Wait(0) end
            ClearPedTasks(cache.ped)
            TriggerServerEvent('pnt_minerJob:changeToGiveItem')
        else
            lib.notify({type = 'error', description = locale("mined_failed")})
            break
        end
    end

    ClearPedTasks(cache.ped)
    FreezeEntityPosition(cache.ped, false)
    startTimer(rock)
end

local function startWorking()
    lib.notify({type = 'success', description = locale("started_working")})
    LocalPlayer.state.isWorking = true

    local playerPed = cache.ped

    lib.requestModel(GetHashKey('prop_tool_pickaxe'))
    pickAxe = CreateObject(GetHashKey('prop_tool_pickaxe'), GetEntityCoords(playerPed), true, false, false)
    AttachEntityToEntity(pickAxe, playerPed, GetPedBoneIndex(playerPed, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)

    for _, rock in pairs(Config.MiningZones) do
        for i = 1, #rock.rocksPositions do
            AddBlips(rock.rocksPositions[i], Config.RockBlips.sprite, Config.RockBlips.scale, Config.RockBlips.colour)
            local rocks = lib.points.new(rock.rocksPositions[i], 10)

            function rocks:nearby()
                DrawMarker(Config.DrawMarkers.Type, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, Config.DrawMarkers.Size.x, Config.DrawMarkers.Size.y, Config.DrawMarkers.Size.z, Config.DrawMarkers.Color.r, Config.DrawMarkers.Color.g, Config.DrawMarkers.Color.b, 255, false, true, 2, nil, nil, false)
                
                if self.currentDistance < 1.2 then 
                    lib.showTextUI(locale("start_mining"))
                    if IsControlJustPressed(0, 38) then
                        startMining(self.coords.xyz)
                    end
                else
                    lib.hideTextUI()
                end
            
            end
        end
    end
end

local function stopWorking()
    lib.notify({type = 'success', description = locale("stoped_working")})
    LocalPlayer.state.isWorking = false

    for _, existingBlip in pairs(rocksBlip) do
		RemoveBlip(existingBlip)
	end
    DeleteEntity(pickAxe)
end

CreateThread(function()
    for _, zone in pairs(Config.MiningZones) do 
        local peds = lib.points.new(zone.ped.coords.xyz, 2)

        function peds:nearby()
            if self.currentDistance < 1.0 and not LocalPlayer.state.isWorking then 
                lib.showTextUI(locale("start_working"))
                if IsControlJustPressed(0, 38) then 
                    startWorking()
                end
            elseif self.currentDistance < 1.0 and LocalPlayer.state.isWorking then 
                lib.showTextUI(locale("stop_working"))
                if IsControlJustPressed(0, 38) then 
                    stopWorking()
                end
            else
                lib.hideTextUI() 
            end
            
        end
    end

    for _, zone in pairs(Config.SellZones) do 
        local peds = lib.points.new(zone.ped.coords.xyz, 2)

        function peds:nearby()
            if self.currentDistance < 1.0 then 
                lib.showTextUI(locale("sell"))
                if IsControlJustPressed(0, 38) then 
                    lib.showContext('sell_menu')
                end
            else
                lib.hideTextUI() 
            end
            
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then 
        for _, zone in pairs(Config.MiningZones) do
            CreateThread(function()
                lib.requestModel(GetHashKey(zone.ped.model))
                ped = CreatePed(0, GetHashKey(zone.ped.model), zone.ped.coords, true, true)
                while not DoesEntityExist(ped) do Wait(50) end 
                Wait(2000)
                SetEntityAsMissionEntity(ped, true, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
                FreezeEntityPosition(ped, true)

                pedBlip = AddBlipForCoord(zone.ped.coords.xyz)

                SetBlipSprite (pedBlip, zone.ped.spriteBlip)
                SetBlipScale  (pedBlip, zone.ped.scaleBlip)
                SetBlipColour (pedBlip, zone.ped.colourBlip)
                SetBlipDisplay(pedBlip, 4)
            
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(locale('ped_blip_name'))
                EndTextCommandSetBlipName(pedBlip)
            end)
        end

        for _, zone in pairs(Config.SellZones) do 
            CreateThread(function()
                lib.requestModel(GetHashKey(zone.ped.model))
                ped = CreatePed(0, GetHashKey(zone.ped.model), zone.ped.coords, true, true)
                while not DoesEntityExist(ped) do Wait(50) end 
                Wait(2000)
                SetEntityAsMissionEntity(ped, true, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
                FreezeEntityPosition(ped, true)

                pedBlip = AddBlipForCoord(zone.ped.coords.xyz)

                SetBlipSprite (pedBlip, zone.ped.spriteBlip)
                SetBlipScale  (pedBlip, zone.ped.scaleBlip)
                SetBlipColour (pedBlip, zone.ped.colourBlip)
                SetBlipDisplay(pedBlip, 4)
            
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(locale('ped_blip_name'))
                EndTextCommandSetBlipName(pedBlip)
            end)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    DeleteEntity(ped)
    DeleteEntity(pickAxe)
    RemoveBlip(pedBlip)
end)



CreateThread(function()
    local options = {}
    for item, price in pairs(Config.Prices) do 
        table.insert(options, {
            title = locale("sell_item", item),
            arrow = true,
            args = {item = item, price = price},
            onSelect = function(args)
                TriggerServerEvent('pnt_minerJob:sellItems', args)
            end,
        })
    end

    lib.registerContext({
        id = 'sell_menu',
        title = locale("title_sell_menu"),
        options = options,
    })
    
end)

