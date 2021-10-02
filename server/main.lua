-- // Finish project //

RegisterServerEvent('qb-telco:server:cWJ0ZWxjbw')
AddEventHandler('qb-telco:server:cWJ0ZWxjbw', function(TaskDones)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local projectsEnd = TaskDones
    local bonus = 0
    local DropPrice = math.random(100, 120)

    -- TODO: add Player.Functions.AddJobReputation(drops) and use it as a payout multiplier
    if projectsEnd > 1 then 
        bonus = math.ceil((DropPrice / 10) * 5) + 100
    elseif projectsEnd > 2 then
        bonus = math.ceil((DropPrice / 10) * 7) + 300
    elseif projectsEnd > 3 then
        bonus = math.ceil((DropPrice / 10) * 10) + 400
    elseif projectsEnd > 5 then
        bonus = math.ceil((DropPrice / 10) * 12) + 500
    end

    local price = (DropPrice * projectsEnd) + bonus
    local payment = price 
    Player.Functions.AddMoney("bank", payment, "telco-salary")
    TriggerClientEvent('QBCore:Notify', src, 'You Earned $'..payment, 'success')


-- // Callback //

QBCore.Functions.CreateCallback('qbtelco:CbHas', function(source, cb, CurrentTask, CurrentProject)
    TriggerClientEvent('QBCore:Notify', source, 'debug: '..CurrentProject..'es el CurrentProject y CurrentTask es: '..CurrentTask , 'error')
    local Ply = QBCore.Functions.GetPlayer(source)
    local TaskData = Config.Projects[CurrentProject].ProjectLocations["tasks"][CurrentTask]
    local Toolkit = Ply.Functions.GetItemByName(TaskData.requiredTool)
    if Toolkit ~= nil then
        if Ply.Functions.RemoveItem(TaskData.requiredItem, TaskData.requiredItemAmount) then
            TriggerClientEvent('QBCore:Notify', source, 'Using '..TaskData.requiredItemAmount..' of '..QBCore.Shared.Items[TaskData.requiredItem]["label"] , 'success')
            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Dont have enough of '..QBCore.Shared.Items[TaskData.requiredItem]["label"]..' x'..TaskData.requiredItemAmount, 'error')
            cb(false)
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'Dont have the tool '..QBCore.Shared.Items[TaskData.requiredTool]["label"] , 'error')
        cb(false) 
    end
end)


