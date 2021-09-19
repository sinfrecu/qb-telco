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
    GetCurrentProject()
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
end)

function GetCurrentProject()
    QBCore.Functions.TriggerCallback('qb-telco:server:GetCurrentProject', function(BuilderConfig)
        Config = BuilderConfig
    end)
end

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


-- Animation Selecction

function DoTask()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local TaskData = Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][BuilderData.CurrentTask]
    TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, true, false)

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


-- Progress Bar and confirm end task

function TouchProcess()
    if not BuilderData.ShowDetails then
        -- death
        Citizen.Wait(200)
        ClearPedTasks(PlayerPedId())
        TasserAnim()
        TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, false, false)
        QBCore.Functions.Notify("You received an electric shock and materials were damaged", "error")
        Citizen.Wait(4000)
        QBCore.Functions.Notify("DEBUG: PASO", "error")
        math.randomseed(os.time())
        if (math.random() >= 0.5)  then
            QBCore.Functions.Notify("DEBUG: ENTRO 1", "error")
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify("you are alive for a miracle, be more careful next time", "success")
        else
            QBCore.Functions.Notify("DEBUG: ENTRO 2", "error")
            QBCore.Functions.Notify("The shock was lethal", "error")
            TriggerEvent('hospital:client:KillPlayer', PlayerPedId())
        end

        QBCore.Functions.Notify("DEBUG: FIN", "error")
    else    
        QBCore.Functions.Progressbar("touch_process", "Reparando ..", math.random(6000,8000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, true, true)
            ClearPedTasks(PlayerPedId())    
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, false, false)
            QBCore.Functions.Notify("Process Canceled, you lost materials", "error")
        end)
    end
end


-- Animations

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


-- State Task

RegisterNetEvent('qb-telco:client:SetTaskState')
AddEventHandler('qb-telco:client:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
end)


-- Finish Project

RegisterNetEvent('qb-telco:client:FinishProject')
AddEventHandler('qb-telco:client:FinishProject', function(BuilderConfig)
    Config = BuilderConfig
end)


-- Blips

RegisterNetEvent('qb-telco:client:UpdateBlip')
AddEventHandler('qb-telco:client:UpdateBlip', function(id)
    DeleteBlip()
    Citizen.Wait(5)
    if PlayerJob.name == "telco" then
        
        TelcoBlip = AddBlipForCoord(Config.Projects[id].ProjectLocations["main"].coords.x, Config.Projects[id].ProjectLocations["main"].coords.y, Config.Projects[id].ProjectLocations["main"].coords.z)
        SetBlipSprite(TelcoBlip, 354)
        SetBlipDisplay(TelcoBlip, 4)
        SetBlipScale(TelcoBlip, 0.6)
        SetBlipAsShortRange(TelcoBlip, true)
        SetBlipColour(TelcoBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Projects[id].ProjectLocations["main"].label)
        EndTextCommandSetBlipName(TelcoBlip)
    end
end)


function ClearNeed(requiredItems)
    Citizen.Wait(1500)
    TriggerEvent('inventory:client:requiredItems', requiredItems, false)   
end

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


-- Threads

Citizen.CreateThread(function()
    Wait(1000)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    GetCurrentProject()
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
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Turn off site')
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
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, '[G] Finish, send report to base.')
                                if IsControlJustPressed(0, 47) then
                                    TriggerServerEvent('qb-telco:server:FinishProject')
                                    -- fix close details or turn off antenna at the end of the location
                                    BuilderData.ShowDetails = false
                                end
                            end

                            if IsControlJustPressed(0, 38) then
                                BuilderData.ShowDetails = not BuilderData.ShowDetails
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
                                    TriggerServerEvent('qb-telco:server:CurrenTaskupdate', k )
                                    QBCore.Functions.TriggerCallback('qb-telco:server:HasToolkit', function(hasItem)
                                        if hasItem then
                                            -- Prevent sticky panel
                                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                            BuilderData.CurrentTask = k
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
