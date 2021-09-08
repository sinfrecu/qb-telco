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
    PayTelco()
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
    TriggerClientEvent('qb-telco:client:UpdateBlip', -1, NewProject)
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


function PayTelco()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local drops = tonumber(#ProjectDone)
    local bonus = 0
    local DropPrice = math.random(100, 120)
    if drops > 2 then 
        bonus = math.ceil((DropPrice / 10) * 5) + 100
    elseif drops > 3 then
        bonus = math.ceil((DropPrice / 10) * 7) + 300
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 10) * 10) + 400
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 10) * 12) + 500
    end
    local price = (DropPrice * drops) + bonus
    local payment = price 
    Player.Functions.AddMoney("bank", payment, "telco-salary")
    TriggerClientEvent('QBCore:Notify', src, 'You Earned $'..payment, 'success')
end


QBCore.Functions.CreateCallback('qb-telco:server:recurses', function(source, cb, item)
  local src = source
  local xPlayer = QBCore.Functions.GetPlayer(src)
  local toolkit = {}
  local toolkit = xPlayer.Functions.GetItemsByName('screwdriversetashdhas')
  local retval = false
  if toolkit ~= nil then
    if xPlayer.Functions.RemoveItem("copper", 2) then
      TriggerClientEvent('QBCore:Notify', src, 'Valido se desconto', 'success')
      retval = true
    else
      TriggerClientEvent('QBCore:Notify', src, 'No tienes la cantidad necesaria de cobre', 'error')
      retval = false
    end
  else
    TriggerClientEvent('QBCore:Notify', src, 'No tienes toolkit', 'error')
    retval = false
  end
  return retval
end)



