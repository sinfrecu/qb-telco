local isLoggedIn = false
local LocationsDone = {}
local PlayerData = {}
local PlayerJob = {}
local BuilderData = {
    ShowDetails = false,
    CurrentTask = nil,
}
local BildingBlip = nil
local labelname = nill
local isColddown = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
    BlipBilding()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
    BlipBilding()
end)




function ColdDown()
    Citizen.CreateThread(function()
    QBCore.Functions.Notify("Debug: entro en ColdDown:"..isColddown , "error")
    -- 600000 (10 minutos)
    Citizen.Wait(120000)
    isColddown = false
    QBCore.Functions.Notify("Debug: salgo en ColdDown:"..isColddown , "error")
    end)
end

-- // es un vehicle //
function isTruckerVehicle(vehicle)
    local retval = false
        if GetEntityModel(vehicle) == GetHashKey(Config.Vehicle) then
            retval = true
        end
    return retval
end

-- // BIG FIX //
-- // count and output number of task completed //

function GetCompletedTasks()
    local retval = {
        completed = 0,
        total = #Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]
    }
    for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
        if v.completed then
            retval.completed = retval.completed + 1
        end
    end
    return retval
end

-- // Get Current Project and frist project random //

function GetCurrentProject()
    local CurProject = nil
    for k, v in pairs(Config.Projects) do
        if v.IsActive then
            CurProject = k
            break
        end
    end
    -- first project random
    if CurProject == nil then
        math.randomseed(GetGameTimer())
        CurProject = math.random(1, #Config.Projects)
        Config.Projects[CurProject].IsActive = true
        Config.CurrentProject = CurProject
    end
    return Config
end

-- ######## FIX IT

function getNewLocation()
    local location = getNextClosestLocation()
    if location ~= 0 then
        QBCore.Functions.Notify("next location"..location)
        Config.Projects[Config.CurrentProject].IsActive = false
        Config.Projects[location].IsActive = true
        -- se new location
        Config.CurrentProject = location
        TriggerEvent('qb-telco:client:UpdateBlip', location)
    else
        LocationsDone = {}
        table.insert(LocationsDone, Config.CurrentProject)
        local location = getNextClosestLocation()
        QBCore.Functions.Notify("END: next location"..location)
        Config.Projects[Config.CurrentProject].IsActive = false
        Config.Projects[location].IsActive = true
        Config.CurrentProject = location
        TriggerEvent('qb-telco:client:UpdateBlip', location)
        --QBCore.Functions.Notify("You Went To All The Shops .. Time For Your Payslip!")
        --Config.Projects[Config.CurrentProject].IsActive = false
        --Config.CurrentProject = 0
        -- Force blip update to return to base with 0
        --TriggerEvent('qb-telco:client:UpdateBlip', 0)
        
    end
end

-- // Get random location //

function getNextClosestLocation()
    local current = 0
    local ramd = nil
    local sorteo = {}
      for k, _ in pairs(Config.Projects) do
        if not hasDoneLocation(k) then
          table.insert(sorteo, k)
        end
      end
    
    if #sorteo < 1 then
        current = 0
    else
        local rand = math.random(1,#sorteo)
        current = sorteo[rand]
    end
    return current
end

-- // Done location list //

function hasDoneLocation(locationId)
    local retval = false
    if LocationsDone ~= nil and next(LocationsDone) ~= nil then 
        for k, v in pairs(LocationsDone) do
            if v == locationId then
                retval = true
            end
        end
    end
    return retval
end

RegisterNetEvent('qb-telco:client:SetTaskState')
AddEventHandler('qb-telco:client:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
end)
-- // END BIG FIX //

-- // Animations //
function DoTask()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local TaskData = Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][BuilderData.CurrentTask]
    TriggerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, true, false)
    if TaskData.type == "TouchAnim" then
        TouchAnim()
        TouchProcess()
    end
    if TaskData.type == "PickAnim" then
        PickAnim()
        TouchProcess()
    end
    if TaskData.type == "TouchLight" then
        TouchLight()
        TouchProcess()
    end
    if TaskData.type == "TouchUp" then
        TouchUp()
        TouchProcess()
    end
end

-- // Progressbars & Progression //

function TouchProcess()
    if not BuilderData.ShowDetails then
        -- death
        Citizen.Wait(200)
        ClearPedTasks(PlayerPedId())
        TasserAnim()
        TriggerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, false, false)
        QBCore.Functions.Notify("You received an electric shock and materials were damaged", "error", 4000)
        Citizen.Wait(4000)
        if (math.random() >= 0.5)  then
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify("You're still alive! be more careful next time.", "success", 4000)
        else
            QBCore.Functions.Notify("The shock was lethal.", "error", 4000)
            TriggerEvent('hospital:client:KillPlayer', PlayerPedId())
        end
    else
        QBCore.Functions.Progressbar("touch_process", "Repairing ..", math.random(6000,8000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, true, true)
            QBCore.Functions.Notify("Done!"..BuilderData.CurrentTask , "success", 4000)
            ClearPedTasks(PlayerPedId())
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            TriggerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, false, false)
            QBCore.Functions.Notify("Process canceled, you wasted some job materials", "error")
        end)
    end
end

-- // Animations //

function PickAnim()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_bum_bin@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bum_bin@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

function TouchAnim()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_parking_meter@male@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

function TouchLight()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_movie_studio_light@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_movie_studio_light@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

function TouchUp()
    local ped = PlayerPedId()
    LoadAnim('amb@prop_human_movie_bulb@base')
    TaskPlayAnim(ped, 'amb@prop_human_movie_bulb@base', 'base', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

function TasserAnim()
    local ped = PlayerPedId()
    LoadAnim('melee@unarmed@streamed_variations')
    TaskPlayAnim(ped, 'melee@unarmed@streamed_variations', 'victim_takedown_front_slap', 6.0, -6.0, 6000, 2, 0, 0, 0, 0)
end

-- // Load Animations //
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end


-- // Blips //
RegisterNetEvent('qb-telco:client:UpdateBlip')
AddEventHandler('qb-telco:client:UpdateBlip', function(id)
    if DoesBlipExist(TelcoBlip) then
        RemoveBlip(TelcoBlip)
    end
    Citizen.Wait(5)
    if PlayerJob.name == "telco" then
        if id == 0 then
            -- Retun to base (not in use)
            TelcoBlip = AddBlipForCoord(Config.JobLocations["npc"].coords.x, Config.JobLocations["npc"].coords.y, Config.JobLocations["npc"].coords.z)
            labelname = Config.JobLocations["npc"].label
        else
            -- Normal job
            labelname = Config.Projects[id].ProjectLocations["main"].label
            TelcoBlip = AddBlipForCoord(Config.Projects[id].ProjectLocations["main"].coords.x, Config.Projects[id].ProjectLocations["main"].coords.y, Config.Projects[id].ProjectLocations["main"].coords.z)        
        end
        SetBlipSprite(TelcoBlip, 161)
        SetBlipDisplay(TelcoBlip, 4)
        SetBlipScale(TelcoBlip, 0.6)
        SetBlipAsShortRange(TelcoBlip, true)
        SetBlipColour(TelcoBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(labelname)
        EndTextCommandSetBlipName(TelcoBlip)
    end
end)

-- // Blip Location base //

function BlipBilding()
    if DoesBlipExist(BildingBlip) then
        RemoveBlip(BildingBlip)
    end
    Citizen.Wait(5)
    if PlayerJob.name == "telco" then
        BildingBlip = AddBlipForCoord(Config.JobLocations["npc"].coords.x, Config.JobLocations["npc"].coords.y, Config.JobLocations["npc"].coords.z)
        SetBlipSprite(BildingBlip, 498)
        SetBlipDisplay(BildingBlip, 4)
        SetBlipScale(BildingBlip, 0.6)
        SetBlipAsShortRange(BildingBlip, true)
        SetBlipColour(BildingBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("NAP - Network Access Point")
        EndTextCommandSetBlipName(BildingBlip)
    end
end

-- // Requirements Inventory //

function ClearNeed(requiredItems)
    Citizen.Wait(1500)
    TriggerEvent('inventory:client:requiredItems', requiredItems, false)   
end


-- // DrawText

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- // NUICallback //
-- Start code of Tinus_NL
RegisterNUICallback("main", function(RequestData)
	if RequestData.ReturnType == "EXIT" then
		SetNuiFocus(false, false)
		SendNUIMessage({RequestType = "Visibility", RequestData = false})
	elseif RequestData.ReturnType == "DONE" then
		SetNuiFocus(false, false)
		SendNUIMessage({RequestType = "Visibility", RequestData = false})
        BuilderData.ShowDetails = not BuilderData.ShowDetails
	end
end)--End code RegisterNUICallback of Tinus_NL



-- // START - Spanw vehicle //
RegisterNetEvent('qb-telco:client:SpawnVehicle')
AddEventHandler('qb-telco:client:SpawnVehicle', function()
    isColddown = true
    ColdDown()
    QBCore.Functions.Notify('DEBUG: trigger SpawnVehicle')
    local vehicleInfo = Config.Vehicle
    local coords = Config.JobLocations["vehicle"].coords 
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "TLCO"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end)
-- // END - Spanw vehicle //

-- // Thread update 1s //
Citizen.CreateThread(function()
    Wait(1000)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    GetCurrentProject()
end)

-- // Thread loop //
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        local OffsetZ = 0.2
        if PlayerJob.name == "telco" then

            -- // START - Thread for blip vehicle //
            local data = Config.JobLocations["vehicle"]
            local MainDistance = #(pos - vector3(data.coords.x, data.coords.y, data.coords.z))
            if MainDistance < 10 then
                inRange = true
                if not BuilderData.ShowDetails then
                    DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 77, 57, 255, 0, 0, 0, 1, 0, 0, 0)
                else
                    DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 57, 255, 110, 255, 0, 0, 0, 1, 0, 0, 0)
                end
                if MainDistance < 2 then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '~g~E~w~ - Store Vehicle')
                    else
                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '~g~E~w~ - Vehicle')
                    end
                end

                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Notify('DEBUG: colddown value: '..isColddown , 'error')
                    if not isColddown then
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                if isTruckerVehicle(GetVehiclePedIsIn(PlayerPedId(), false)) then
                                    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    TriggerServerEvent('qb-telco:server:SuretyBond', false)
                                else
                                    QBCore.Functions.Notify('This is not a commercial vehicle!', 'error')
                                end
                            else
                                QBCore.Functions.Notify('You must be the driver to do this..')
                            end
                        else

                            TriggerServerEvent('qb-telco:server:SuretyBond', true, Config.Vehicle)
                        end
                    else 
                        QBCore.Functions.Notify('You have taken out a vehicle very recently.', 'error')
                    end -- end of colddown
                end
            end -- // END - Thread for blip vehicle //

            if Config.CurrentProject ~= 0 then
                local data = Config.Projects[Config.CurrentProject].ProjectLocations["main"]
                local MainDistance = #(pos - vector3(data.coords.x, data.coords.y, data.coords.z))

                -- Main blip
                if MainDistance < 10 then
                    inRange = true
                    if not BuilderData.ShowDetails then
                        DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 77, 57, 255, 0, 0, 0, 1, 0, 0, 0)
                    else
                        DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 57, 255, 110, 255, 0, 0, 0, 1, 0, 0, 0)
                    end

                    if MainDistance < 2 then
                        local TaskData = GetCompletedTasks()
                        if TaskData ~= nil then
                            if not BuilderData.ShowDetails then
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Turn off electricity')
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + 0.2, 'Works: '..TaskData.completed..' / '..TaskData.total)
                            else
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Turn on electricity')
                                for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                                    if v.completed then
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, v.label..': Completed')
                                    else
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, v.label..': Pending')
                                    end
                                    OffsetZ = OffsetZ + 0.2
                                end
                            end

                            if TaskData.completed == TaskData.total then 
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, '[G] Finish Job, send report to base.')
                                if IsControlJustPressed(0, 47) then
                                    -- Reset status task 
                                    local ResetTask = 1
                                    while ResetTask < TaskData.total+1 do
                                        -- QBCore.Functions.Notify("DEBUG: SetTaskState "..ResetTask.." de "..TaskData.total , "error", 4000)
                                        TriggerEvent('qb-telco:client:SetTaskState', ResetTask, false, false)  
                                        ResetTask = ResetTask+1
                                    end
                                    table.insert(LocationsDone, Config.CurrentProject)
                                    -- Update to new project
                                    getNewLocation()
                                    -- Paysistem
                                    TriggerServerEvent('qb-telco:server:cWJ0ZWxjbw', TaskData.completed) 
                                    -- fix close details or turn off antenna at the end of the location
                                    BuilderData.ShowDetails = false
                                end
                            end

                            if IsControlJustPressed(0, 38) then
                                if not BuilderData.ShowDetails then
                                    SetNuiFocus(true, true)
                                    SendNUIMessage({RequestType = "Visibility", RequestData = true})
                                else
                                    BuilderData.ShowDetails = not BuilderData.ShowDetails
                                end
                            end
                        end
                    end
                end

                for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                    if not v.completed or not v.IsBusy then
                        local TaskDistance = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                        if TaskDistance < 10 then
                            inRange = true
                            if not BuilderData.ShowDetails then
                                -- red  255, 77, 57
                                DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 77, 57, 255, 0, 0, 0, 1, 0, 0, 0)
                            else
                                -- green 57, 255, 110
                                DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 57, 255, 110, 255, 0, 0, 0, 1, 0, 0, 0)
                            end
                            if TaskDistance < 1.5 then
                                -- this is shit, I already have plans
                                local requiredItems = {
                                    [1] = {name = QBCore.Shared.Items[v.requiredTool]["name"], image = QBCore.Shared.Items[v.requiredTool]["image"]},
                                    [2] = {name = QBCore.Shared.Items[v.requiredItem]["name"], image = QBCore.Shared.Items[v.requiredItem]["image"]},
                                }
                                -- end shit
                                DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, '[E] '..v.label )                
                                if IsControlJustPressed(0, 38) then
                                    local CurrentTask = k
                                    local CurrentProject = Config.CurrentProject
                                    QBCore.Functions.TriggerCallback('qbtelco:CbHas', function(result)
                                        --QBCore.Functions.Notify("DEBUG: entro en trigger", "error", 4000)
                                        if result then
                                            --QBCore.Functions.Notify("DEBUG: salio arriba", "error", 4000)
                                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                            BuilderData.CurrentTask = k
                                            DoTask()   
                                        else                                        
                                            --QBCore.Functions.Notify("DEBUG: salio el abajo", "error", 4000)
                                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                                            ClearNeed(requiredItems)
                                        end
                                    end, CurrentTask, CurrentProject)   
                                end
                            end
                        end
                    end
                end
            
            else
                --QBCore.Functions.Notify("DEBUG: genero el primero", "error", 4000)
                GetCurrentProject()
            end
        else
            Citizen.Wait(1000)
        end
        if not inRange then
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)
