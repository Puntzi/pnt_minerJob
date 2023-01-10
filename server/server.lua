local ox_inventory = exports.ox_inventory
lib.locale()

RegisterNetEvent('pnt_minerJob:changeToGiveItem', function()
    local randomItem = Config.Items[math.random(1, #Config.Items)]
    if math.random(0, 100) <= Config.GiveItemProbability then
        if ox_inventory:CanCarryItem(source, randomItem, 1) then 
            ox_inventory:AddItem(source, randomItem, 1)
        else
            TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = locale('cant_carry_more')})
        end
    end
end)

RegisterNetEvent('pnt_minerJob:sellItems', function(args)
    local count = ox_inventory:Search(source, 'count', args.item)
    local success = ox_inventory:RemoveItem(source, args.item, count)

    if success then 
        ox_inventory:AddItem(source, 'money', (args.price*count))
        TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = locale('items_sold', args.item, count, (args.price*count))})
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = locale('no_items')})
    end

end)