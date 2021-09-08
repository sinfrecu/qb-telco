isLoggedIn = false
PlayerData = {}

local BuilderData = {
    ShowDetails = false,
    CurrentTask = nil,
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    GetCurrentProject()
    TriggerEvent('qb-telco:client:UpdateBlip', Config.CurrentProject)
end)

Citizen.CreateThread(function()
    Wait(1000)
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    GetCurrentProject()
end)

function GetCurrentProject()
    QBCore.Functions.TriggerCallback('qb-telco:server:GetCurrentProject', function(BuilderConfig)
    Config = BuilderConfig
    end)
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



Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        local OffsetZ = 0.2
        
        if Config.CurrentProject ~= 0 then
            local data = Config.Projects[Config.CurrentProject].ProjectLocations["main"]
            local MainDistance = #(pos - vector3(data.coords.x, data.coords.y, data.coords.z))
            
            -- Main blip
            if MainDistance < 10 then
                inRange = true
                DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 55, 155, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                if MainDistance < 2 then
                    local TaskData = GetCompletedTasks()
                    if TaskData ~= nil then
                        if not BuilderData.ShowDetails then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Detail view')
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + 0.2, 'Exercises: '..TaskData.completed..' / '..TaskData.total)
                        else
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Details hide')
                            for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
                                if v.completed then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, v.label..': Completed')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z + OffsetZ, v.label..': Not completed')
                                end
                                OffsetZ = OffsetZ + 0.2
                            end
                        end

                        if TaskData.completed == TaskData.total then
                            DrawText3Ds(data.coords.x, data.coords.y, data.coords.z - 0.2, '[G] End project')
                            if IsControlJustPressed(0, 47) then
                                TriggerServerEvent('qb-telco:server:FinishProject')
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
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 55, 155, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        if TaskDistance < 1.5 then

                            -- this is shit, I already have plans
                            local requiredItems = {
                                [1] = {name = QBCore.Shared.Items["screwdriverset"]["name"], image = QBCore.Shared.Items["screwdriverset"]["image"]},
                                [2] = {name = QBCore.Shared.Items["copper"]["name"], image = QBCore.Shared.Items["copper"]["image"]},
                            }
                            -- end shit

                            DrawText3Ds(v.coords.x, v.coords.y, v.coords.z + 0.25, '[E] Complete task')

                            if IsControlJustPressed(0, 38) then
                                QBCore.Functions.TriggerCallback('qb-telco:server:HasToolkit', function(hasItem)
                                    if hasItem then
                                        -- Prevent sticky panel 
                                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                                        BuilderData.CurrentTask = k
                                        DoTask()
                                    else    
                                        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                                    end
                                end)
                            end
                        else
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

function DoTask()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local TaskData = Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][BuilderData.CurrentTask]
    TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, true, false)

    if TaskData.type == "hammer" then
        TouchAnim()
    TouchProcess()
        TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, true, true)
    end

    if TaskData.type == "PickAnim" then
        PickAnim()
        TouchProcess()
        TriggerServerEvent('qb-telco:server:SetTaskState', BuilderData.CurrentTask, true, true)
    end

end


function TouchProcess()
    QBCore.Functions.Progressbar("touch_process", "Reparando ..", math.random(6000,8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())

    end, function() -- Cancel

        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Process Canceled", "error")
    end)
end


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


function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end


RegisterNetEvent('qb-telco:client:SetTaskState')
AddEventHandler('qb-telco:client:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
end)

RegisterNetEvent('qb-telco:client:FinishProject')
AddEventHandler('qb-telco:client:FinishProject', function(BuilderConfig)
    Config = BuilderConfig
end)




RegisterNetEvent('qb-telco:client:UpdateBlip')
AddEventHandler('qb-telco:client:UpdateBlip', function(id)
    DeleteBlip()
    Citizen.Wait(5)
--  if PlayerJob.name == "tow" then
    TelcoBlip = AddBlipForCoord(Config.Projects[id].ProjectLocations["main"].coords.x, Config.Projects[id].ProjectLocations["main"].coords.y, Config.Projects[id].ProjectLocations["main"].coords.z)
    SetBlipSprite(TelcoBlip, 354)
    SetBlipDisplay(TelcoBlip, 4)
    SetBlipScale(TelcoBlip, 0.6)
    SetBlipAsShortRange(TelcoBlip, true)
    SetBlipColour(TelcoBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Projects[id].ProjectLocations["main"].label)
    EndTextCommandSetBlipName(TelcoBlip)
--  end

end)

function DeleteBlip()
    if DoesBlipExist(TelcoBlip) then
        RemoveBlip(TelcoBlip)
    end
end



