ProjectDone = {}


QBCore.Functions.CreateCallback('qb-telco:server:GetCurrentProject', function(source, cb)
    local CurProject = nil
    for k, v in pairs(Config.Projects) do
        if v.IsActive then
            CurProject = k
            break
        end
    end

    if CurProject == nil then
        CurProject = math.random(1, #Config.Projects)
        Config.Projects[CurProject].IsActive = true
        Config.CurrentProject = CurProject
    end
    cb(Config)
end)

RegisterServerEvent('qb-telco:server:SetTaskState')
AddEventHandler('qb-telco:server:SetTaskState', function(Task, IsBusy, IsCompleted)
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
    Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
    TriggerClientEvent('qb-telco:client:SetTaskState', -1, Task, IsBusy, IsCompleted)
end)

RegisterServerEvent('qb-telco:server:FinishProject')
AddEventHandler('qb-telco:server:FinishProject', function()
    Config.Projects[Config.CurrentProject].IsActive = false
    for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
        v.completed = false
        v.IsBusy = false
    end
    table.insert(ProjectDone, Config.CurrentProject)
    if #ProjectDone == #Config.Projects then
      ProjectDone = {}
      -- Fix repeat last job after reset
      table.insert(ProjectDone, Config.CurrentProject)
    end
    local sorteo = {}
      for k, _ in pairs(Config.Projects) do
        if not hasDoneLocation(k) then
          table.insert(sorteo, k)
        end
      end
    local rand = math.random(1,#sorteo)
    local NewProject = sorteo[rand] 
    Config.CurrentProject = NewProject
    Config.Projects[NewProject].IsActive = true
    TriggerClientEvent('qb-telco:client:FinishProject', -1, Config)
end)


function hasDoneLocation(locationId)
    local retval = false
    if ProjectDone ~= nil and next(ProjectDone) ~= nil then 
        for k, v in pairs(ProjectDone) do
            if v == locationId then
                retval = true
            end
        end
    end
    return retval
end
