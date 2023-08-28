---@diagnostic disable: undefined-global, param-type-mismatch, missing-parameter



local hasHiddenUI = false -- Declare a flag to keep track of whether we've hidden the UI

Citizen.CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        pcord = GetEntityCoords(PlayerPedId())

        local isPlayerNearUi = false

        for k, v in pairs(Config.SellLocations) do
            local Locations = v
            
            dst = GetDistanceBetweenCoords(pcord, Locations)
            if dst < 5 and not pressed then
                isPlayerNearUi = true
                sleep = 5

                if dst < 1 then
                    textUI(Config.Lang.sell.text,Config.Lang.sell.position, Config.Lang.sell.icon, Config.Lang.sell.style.borderRadius, Config.Lang.sell.style.backgroundColor, Config.Lang.sell.style.color )
              
                    
                    if IsControlJustReleased(1, 51) then
                        SellMenu()
                    end
                else
                    
                    textUI(Config.Lang.selldistance.text..' ('..math.floor(dst)..')',Config.Lang.sell.position, Config.Lang.sell.icon, Config.Lang.sell.style.borderRadius, Config.Lang.sell.style.backgroundColor, Config.Lang.sell.style.color )

                end

                sleep = 0
            end
        end

        -- Only hide the UI once if the player isn't near and the UI hasn't been hidden already
        if not isPlayerNearUi and not hasHiddenUI then
            lib.hideTextUI()
            hasHiddenUI = true
        end
        
        -- If the player is near the UI, set the flag to false to allow hiding the UI again later
        if isPlayerNearUi then
            hasHiddenUI = false
        end

        Citizen.Wait(sleep)
    end
end)


function SellMenu()
    local options = {}

    for k, v in pairs(Config.Items) do
        local 
        test = {v, k}
        table.insert(options, {
            arrow = true,
            icon = 'shopping-cart',
            header = k,
            title = v.label .. ' ($' .. v.price .. ')',
            description = Config.Lang.Header .. ' ' .. v.price .. ' $',
            image = Config.ImagePath .. k .. '.png',
            args = {
                data = test,
            },
            event = 'src-pawn:parttwo'
        })
    end

    lib.registerContext({
        id = 'gunshop_menu',
        title = 'Pawn Shop',
        options = options,
    })

    lib.showContext('gunshop_menu')
end


RegisterNetEvent('src-pawn:parttwo', function(data)
    local color = 'white'
    local kullanim = 0
    local src = source
    TriggerServerEvent('src-pawnshop:sync', data.data[2])

    lib.callback('src-pawnshop:getItemCount', src, function(count)
        kullanim = count
        local optionss = {}

        local kapasite = Config.InventoryHeight
        local oran = (kullanim / kapasite) * 100
        
        if count > 80 and count <= Config.InventoryHeight then
            color = 'green'
        elseif count >= 60 and count <= 79 then
            color = 'yellow'
        else
            color = 'red'
        end

        for k, v in pairs(data) do
            table.insert(optionss, {
                arrow = true,
                icon = 'shopping-cart',
                header = data,
                title = v[1].label,
                progress = oran,
                event = 'src-spawn:input',
                colorScheme = color,
                args = data
            })
        end

        lib.registerContext({
            id = 'part2',
            title = 'Items On You ' .. kullanim .. '/' .. Config.InventoryHeight,
            options = optionss,
            onBack = function()
                kullanim = 0
            end,
            menu = 'gunshop_menu',
        })

        lib.showContext('part2')
    end)
end)



RegisterNetEvent('src-spawn:input', function (data)
if Config.SkillSystem then
    local input = lib.inputDialog(Config.Lang.Dialog.Title, {
        {type = 'number', label = Config.Lang.Dialog.label, description = Config.Lang.Dialog.description, icon = Config.Lang.Dialog.icon, required = true, min = 0, },
      })
    if input ~= nil then
      local items = {
        data = data.data,   
        input = input[1],
        level = 0
    }
 
     if input[1] ~= nil and items.data  ~= nil then
        if input[1] < 0 then
        else
            local skillName =  GetCurrentSkill(data.data[1].level)
            items.level = skillName["Current"]
            TriggerServerEvent('src-pawn:sellitem',items)
        end
      
     else

     end
    end
else
    local input = lib.inputDialog(Config.Lang.Dialog.Title, {
        {type = 'number', label = Config.Lang.Dialog.label, description = Config.Lang.Dialog.description, icon = Config.Lang.Dialog.icon, required = true, min = 0, },
      })
    if input ~= nil then
      local items = {
        data = data.data,   
        input = input[1],
    }
 
     if input[1] ~= nil and items.data  ~= nil then
        if input[1] < 0 then
        else
            TriggerServerEvent('src-pawn:sellitem',items)
        end
    end
end
end
end)




-- Citizen.CreateThread(function()
--     for _, v in pairs(Config.Peds) do
--         RequestModel(GetHashKey(v.pedname))
--         while not HasModelLoaded(GetHashKey(v.pedname)) do
--             Wait(1)
--         end
--         Peds = CreatePed(4, v.pedname, v.coords.x, v.coords.y, v.coords.z, 3374176, false, true)
--         SetEntityHeading(Peds, v.heading)
--         FreezeEntityPosition(Peds, true)
--         SetEntityInvincible(Peds, true)
--         SetBlockingOfNonTemporaryEvents(Peds, true)
--         TaskStartScenarioInPlace(Peds, v.scenario, 0, true)
--     end
-- end)

function textUI(text, position, icon , borderRadius, backgroundColor, color)
    lib.showTextUI(text, {
        position = position,
        icon = icon,
        style = {
            borderRadius = borderRadius,
            backgroundColor = backgroundColor,
            color = color
        }
    })
    
end
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

