local isLoggedIn = false
local PlayerData = {}
local PlayerJob = {}
local BuilderData = {
    ShowDetails = false,
    CurrentTask = nil,
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
end)





-- // BIG FIX //


function GetCurrentProject()
    local CurProject = nil
    for k, v in pairs(Config.Projects) do
        if v.IsActive then
            CurProject = k
            break
        end
    end

    if CurProject == nil then
        math.randomseed(os.time())
        CurProject = math.random(1, #Config.Projects)
        Config.Projects[CurProject].IsActive = true
        Config.CurrentProject = CurProject
    end
    return Config
end


function getNewLocation()
    local location = getNextClosestLocation()
    if location ~= 0 then
        CurrentLocation = {}
        CurrentLocation.id = location
        CurrentLocation.dropcount = math.random(1, 3)
        CurrentLocation.store = Config.Locations["stores"][location].name
        CurrentLocation.x = Config.Locations["stores"][location].coords.x
        CurrentLocation.y = Config.Locations["stores"][location].coords.y
        CurrentLocation.z = Config.Locations["stores"][location].coords.z

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
    else
        QBCore.Functions.Notify("You Went To All The Shops .. Time For Your Payslip!")
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
	    ClearAllBlipRoutes()
            CurrentBlip = nil
        end
    end
end


function getNextClosestLocation()
    local current = 0
    local ramd = nil
    local sorteo = {}
      for k, _ in pairs(Config.Projects) do
        if not hasDoneLocation(k) then
          table.insert(sorteo, k)
        end
      end
    local rand = math.random(1,#sorteo)
    current = sorteo[rand]
    return current
end


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
    -- TriggerServerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, true, false)
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
        TriggerServerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, false, false)
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
            currentCount = currentCount + 1

            --TriggerServerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, true, true)
            ClearPedTasks(PlayerPedId())    
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            --TriggerServerEvent('qb-telco:client:SetTaskState', BuilderData.CurrentTask, false, false)
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
function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end


-- // Blips //

RegisterNetEvent('qb-telco:client:UpdateBlip')
AddEventHandler('qb-telco:client:UpdateBlip', function(id)
    DeleteBlip()
    Citizen.Wait(5)
    if PlayerJob.name == "telco" then
        TelcoBlip = AddBlipForCoord(Config.Projects[id].ProjectLocations["main"].coords.x, Config.Projects[id].ProjectLocations["main"].coords.y, Config.Projects[id].ProjectLocations["main"].coords.z)
        SetBlipSprite(TelcoBlip, 161)
        SetBlipDisplay(TelcoBlip, 4)
        SetBlipScale(TelcoBlip, 0.6)
        SetBlipAsShortRange(TelcoBlip, true)
        SetBlipColour(TelcoBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Projects[id].ProjectLocations["main"].label)
        EndTextCommandSetBlipName(TelcoBlip)
    end
end)


-- // Requirements Inventory //
function ClearNeed(requiredItems)
    Citizen.Wait(1500)
    TriggerEvent('inventory:client:requiredItems', requiredItems, false)   
end

-- // Delete the Blip //
function DeleteBlip()
    if DoesBlipExist(TelcoBlip) then
        RemoveBlip(TelcoBlip)
    end
end

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



-- // Threads //
Citizen.CreateThread(function()
    Wait(1000)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        local OffsetZ = 0.2
        if PlayerJob.name == "telco" then
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

                            if currentCount < CurrentLocation.dropcount then 
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, '[G] Finish Job, send report to base.')
                                if IsControlJustPressed(0, 47) then
                                    -- Clear task's location
                                    currentCount = 0

                                    -- table.insert(LocationsDone, CurrentLocation.id)

                                            -- TriggerServerEvent('qb-telco:server:FinishProject') // Reemplace a pay sistem.
                                    -- Update to new project ?
                                    -- UPDATE: GetCurrentProject()


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
                                    -- TriggerServerEvent('qb-telco:server:CurrenTaskupdate', k )
                                    QBCore.Functions.TriggerCallback('qb-telco:server:HasToolkit', function(hasItem)
                                        if hasItem then
                                            -- Prevent sticky panel
                                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                            -- BuilderData.CurrentTask = k
                                            DoTask()
                                        else
                                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                                            ClearNeed(requiredItems)
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            
            else
                QBCore.Functions.Notify("DEBUG: genero el primero", "error", 4000)
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
