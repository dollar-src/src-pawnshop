---@diagnostic disable: undefined-global, missing-parameter
if Config.Core == "qb" then
    Core = exports["qb-core"]:GetCoreObject()
    SetConvar("ox:primaryColor", "red")
elseif Config.Core == "esx" then
    Core = exports["es_extended"]:getSharedObject()
end

local item = 's'
AddItem = function(source, item, count)
    if Config.Core == "qb" then
        local src = source
        local Player = Core.Functions.GetPlayer(src)
        local function add_qb()
            TriggerClientEvent("inventory:client:ItemBox", src, Core.Shared.Items[item], "add", count)
            Player.Functions.AddItem(item, count)
        end
        return add_qb()
    else
        local src = source
        local Player = Core.GetPlayerFromId(src)

        return Player.addInventoryItem(item, count)
    end
end

AddMoney = function(source, type, amount)
    if Config.Core == "qb" then
        local src = source
        local Player = Core.Functions.GetPlayer(src)
        local function add_qb()
            Player.Functions.AddMoney(type, amount) 
        end
        return add_qb()
    else
        local src = source
        local Player = Core.GetPlayerFromId(src)

        return Player.addAccountMoney(type,amount)
    end
end



RemoveItem = function(source,item, count)
    if Config.Core == "qb" then
        local src = source
        local Player = Core.Functions.GetPlayer(src)
        local function remove_qb()
            local itemName = Player.Functions.GetItemByName(item)
            if itemName ~= nil  then
                if itemName.amount >= count then
                    TriggerClientEvent("inventory:client:ItemBox", source, Core.Shared.Items[item], "remove", count)
                    Player.Functions.RemoveItem(item, count)
                else
                    local message = string.format(Config.ItemNotify.RemoveItem.description, count, item)
                end
            else
                local message = string.format(Config.ItemNotify.RemoveItem.title, count, item)
            end
        end 
        return remove_qb()
    else
        local src = source
        local Player = Core.GetPlayerFromId(src)

        return Player.removeInventoryItem (item, count)
    end
end



lib.callback.register('src-pawnshop:getItemCount', function(_, cb)
    if Config.Core == 'qb' then
    local src = _
    local inventory = nil
    local Player = Core.Functions.GetPlayer(src)
    local materialItem = Player.Functions.GetItemByName(item)
    if materialItem ~= nil then
        inventory = materialItem.amount
    else
        inventory = 0
    end
    return inventory
else
    local src = _
    local inventory = nil
    local Player = Core.GetPlayerFromId(src)
    local materialItem = Player.getInventoryItem(item)
    if materialItem ~= nil then
        inventory = materialItem.count
    else
        inventory = 0
    end
    return inventory
end
end)


RegisterNetEvent('src-pawnshop:sync', function(data)
    item = data
 
 end)

RegisterNetEvent('src-pawn:sellitem', function (shop)

 if Config.Core == 'qb' then
    local data = shop.data
    local input = shop.input
    local itemName = data[2]
    local price = data[1].price
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    local materialItem = Player.Functions.GetItemByName(itemName)

    if materialItem ~= nil then
        if tonumber(materialItem.amount) >= tonumber(input) then
            if input <= 0 then
            else

            RemoveItem(src, itemName, input)
            Citizen.Wait(500)
            AddMoney(src, 'bank', input * price)
            TextData={id='errorr',title=Config.Lang.SellItem.title,description=Config.Lang.SellItem.description..' '..input..'x'..' '..data[1].label,position=Config.Lang.SellItem.position,style={backgroundColor= Config.Lang.SellItem.style.backgroundColor ,color='white',['.description']={color='white'}},icon=Config.Lang.SellItem.icon,iconColor=Config.Lang.SellItem.iconColor}
            TriggerClientEvent('ox_lib:notify', src, TextData)

            end
        else
            TriggerClientEvent('ox_lib:notify', source, Config.Lang.ErrorSell)

        end
      
    else
        TriggerClientEvent('ox_lib:notify', source, Config.Lang.ErrorSell)
        
    end
else
    local data = shop.data
    local input = shop.input
    local itemName = data[2]
    local price = data[1].price
    local src = source
    local Player = Core.GetPlayerFromId(src)
    local materialItem = Player.getInventoryItem(itemName)


    if materialItem ~= nil then
        if tonumber(materialItem.count) >= tonumber(input) then
            if input <= 0 then
            else

            RemoveItem(src, itemName, input)
            Citizen.Wait(500)
            AddMoney(src, 'bank', input * price)
            TextData={id='errorr',title=Config.Lang.SellItem.title,description=Config.Lang.SellItem.description..' '..input..'x'..' '..data[1].label,position=Config.Lang.SellItem.position,style={backgroundColor= Config.Lang.SellItem.style.backgroundColor ,color='white',['.description']={color='white'}},icon=Config.Lang.SellItem.icon,iconColor=Config.Lang.SellItem.iconColor}
            TriggerClientEvent('ox_lib:notify', src, TextData)

            end
        else
            TriggerClientEvent('ox_lib:notify', source, Config.Lang.ErrorSell)

        end
      
    else
        TriggerClientEvent('ox_lib:notify', source, Config.Lang.ErrorSell)
        
    end

end

end)






local function CheckVersion()
    PerformHttpRequest(
        "https://raw.githubusercontent.com/dollar-src/src-pawnshop/main/version.txt",
        function(err, newestVersion, headers)
            local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
            if not newestVersion then
                print("probably github down follow update on discord / discord.gg/tebex")
                return
            end
            local advice = "^6You are currently running an outdated version^7, ^0please update"
            if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then
                advice = "^6You are running the latest version."
            else
                if currentVersion > newestVersion then
                    advice = "^6You are running the latest version."

                else
                print("^3Version Check^7: ^2Current^7: " .. currentVersion .. " ^2Latest^7: " .. newestVersion)
                end
            end
            print(advice)
        end
    )
end

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CheckVersion()

 
    end
end)
