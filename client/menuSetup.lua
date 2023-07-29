local myInput = {
    type = "enableinput", -- dont touch
    inputType = "input", -- or text area for sending messages
    button = _U("confirm"), -- button name
    placeholder =_U("qty"), --placeholdername
    style = "block", --- dont touch
    attributes = {
        inputHeader = _U("menuTitle"), -- header 1
        type = "number", -- inputype text, number,date.etc if number comment out the pattern
        pattern = "[0-9]{1,20}", -- regular expression validated for only numbers "[0-9]", for letters only [A-Za-z]+   with charecter limit  [A-Za-z]{5,20}     with chareceter limit and numbers [A-Za-z0-9]{5,}
        title = "must be only numbers min 1 max 20", -- if input doesnt match show this message
        style = "border-radius: 10px; background-color: ; border:none;", -- style  the inptup
    }
}

AddEventHandler('s:MenuClose', function()
    while inMenu do
        Wait(5)
        if IsControlJustReleased(0, 0x156F7119) then
            inMenu = false
            MenuData.CloseAll()
            break
        end
    end
end)

RegisterNetEvent('s:OpenBarMenu', function()
    inMenu = true
    TriggerEvent('s:MenuClose')
    MenuData.CloseAll()

    local elements = {
        { label = _U("drinks"),     value = 'drinks',     desc = _U("drinks_desc") },
        { label = _U("foods"),       value = 'foods',       desc = _U("foods_desc") },
        { label = _U("other"), value = 'other', desc = _U("other_desc") }
    }

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi',
        {
            title =
                "<img style='max-height:5vh;max-width:7vh; float: left;text-align: center; margin-top: 4vh; position:relative; right: 8vh;' src='nui://s-barmen/images/bar.png'>"
                .. "<div style='position: relative; right: 6vh; margin-top: 4vh;'>" .. _U("menuTitle") .. "</div>",
            align = 'top-left',
            elements = elements,
        },
        function(data)
            if data.current == 'backup' then
                _G[data.trigger]()
            end
            local selectedOption = {
                ['drinks'] = function()
                    MenuData.CloseAll()
                    TriggerEvent('s:BuyDrink')
                end,
                ['foods'] = function()
                    MenuData.CloseAll()
                    TriggerEvent('s:BuyFood')
                end,
                ['other'] = function()
                    MenuData.CloseAll()
                    TriggerEvent('s:BuyOther')
                end,
            }

            if selectedOption[data.current.value] then
                selectedOption[data.current.value]()
            end
        end)
end)

RegisterNetEvent('s:BuyDrink', function()
    MenuData.CloseAll()
    local elements, elementindex = {}, 1
    Wait(100)
    for k, items in pairs(Config.Drinks) do
        elements[elementindex] = { --sets the elemnents to this table
            label = "<img style='max-height:45px;max-width:45px;float: left;text-align: center; margin-top: -5px;'" ..
            items.itemdbname .. ".png'>" .. items.displayname .. ' - ' .. items.price .. ' $ ' .. '<span style="color: Yellow;">  ' .. items.currencytype .. '</span>',--sets the label -- added currency color and image added by mrtb
            value = 'sell' .. tostring(elementindex), --sets the value
            desc = '', --empty desc
            info = items --sets info to the table(this will allow you too open the table in the menu setup below)
        }
        elementindex = elementindex + 1 --adds 1 to the var
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
        title =
        "<img style='max-height:5vh;max-width:7vh; float: left;text-align: center; margin-top: 4vh; position:relative; right: 8vh;' src='nui://s-barmen/images/bar.png'>"
        .. "<div style='position: relative; right: 6vh; margin-top: 4vh;'>" .. _U("menuTitle") .. "</div>",
        align = 'top-left',
        elements = elements,
        lastmenu = "MainMenu"
    },
        function(data)
            if (data.current == "backup") then
                _G[data.trigger]()
            else
                Iitemname = data.current.info.itemdbname --sets the varible to whatever option is clicked (since we set info to = the table)
                Pprice = data.current.info.price
                Scurrencytype = data.current.info.currencytype -- Get the currencytype from config.shop added by mrtb
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput),function(result)
                    local qty = tonumber(result)
                    if qty > 0 then
                        progressbar.start(_U("drinkprepare"), 7000)
                        RequestAnimDict("amb_work@world_human_bartender@serve_player")
                        while not HasAnimDictLoaded("amb_work@world_human_bartender@serve_player") do
                            Wait(100)
                        end
                        TaskPlayAnim(PlayerPedId(), "amb_work@world_human_bartender@serve_player","take_beer_trans_pour_whiskey", 8.0, 8.0, 100000000000000, 1, 0, true, 0, false, 0, false)
                        Wait(7000) --waits until the anim / progressbar above is over
                        StopAnimTask(PlayerPedId(), "amb_work@world_human_bartender@serve_player","take_beer_trans_pour_whiskey")
                       TriggerServerEvent('s:BuyDrinks', qty, Iitemname, Pprice, Scurrencytype)
                       MenuData.CloseAll()
                    else
                        TriggerEvent("vorp:TipRight", "insertamount", 3000)
                    end
                end)
            end
        end)
end)

RegisterNetEvent('s:BuyFood', function()
    MenuData.CloseAll()
    local elements, elementindex = {}, 1
    Wait(100)
    for k, items in pairs(Config.Foods) do
        elements[elementindex] = { --sets the elemnents to this table
            label = "<img style='max-height:45px;max-width:45px;float: left;text-align: center; margin-top: -5px;'" ..
            items.itemdbname .. ".png'>" .. items.displayname .. ' - ' .. items.price .. ' $ ' .. '<span style="color: Yellow;">  ' .. items.currencytype .. '</span>',--sets the label -- added currency color and image added by mrtb
            value = 'sell' .. tostring(elementindex), --sets the value
            desc = '', --empty desc
            info = items --sets info to the table(this will allow you too open the table in the menu setup below)
        }
        elementindex = elementindex + 1 --adds 1 to the var
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
        title =
        "<img style='max-height:5vh;max-width:7vh; float: left;text-align: center; margin-top: 4vh; position:relative; right: 8vh;' src='nui://s-barmen/images/bar.png'>"
        .. "<div style='position: relative; right: 6vh; margin-top: 4vh;'>" .. _U("menuTitle") .. "</div>",
        align = 'top-left',
        elements = elements,
        lastmenu = "MainMenu"
    },
        function(data)
            if (data.current == "backup") then
                _G[data.trigger]()
            else
                Iitemname = data.current.info.itemdbname --sets the varible to whatever option is clicked (since we set info to = the table)
                Pprice = data.current.info.price
                Scurrencytype = data.current.info.currencytype -- Get the currencytype from config.shop added by mrtb
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput),function(result)
                    local qty = tonumber(result)
                    if qty > 0 then
                        progressbar.start(_U("foodprepare"), 7000)
                        RequestAnimDict("amb_work@world_human_bartender@serve_player")
                        while not HasAnimDictLoaded("amb_work@world_human_bartender@serve_player") do
                            Wait(100)
                        end
                        TaskPlayAnim(PlayerPedId(), "amb_work@world_human_bartender@serve_player","take_beer_trans_pour_whiskey", 8.0, 8.0, 100000000000000, 1, 0, true, 0, false, 0, false)
                        Wait(7000) --waits until the anim / progressbar above is over
                        StopAnimTask(PlayerPedId(), "amb_work@world_human_bartender@serve_player","take_beer_trans_pour_whiskey")
                       TriggerServerEvent('s:BuyFoods', qty, Iitemname, Pprice, Scurrencytype)
                       MenuData.CloseAll()
                    else
                        TriggerEvent("vorp:TipRight", "insertamount", 3000)
                    end
                end)
            end
        end)
end)

RegisterNetEvent('s:BuyOther', function()
    MenuData.CloseAll()
    local elements, elementindex = {}, 1
    Wait(100)
    for k, items in pairs(Config.Others) do
        elements[elementindex] = { --sets the elemnents to this table
            label = "<img style='max-height:45px;max-width:45px;float: left;text-align: center; margin-top: -5px;'" ..
            items.itemdbname .. ".png'>" .. items.displayname .. ' - ' .. items.price .. ' $ ' .. '<span style="color: Yellow;">  ' .. items.currencytype .. '</span>',--sets the label -- added currency color and image added by mrtb
            value = 'sell' .. tostring(elementindex), --sets the value
            desc = '', --empty desc
            info = items --sets info to the table(this will allow you too open the table in the menu setup below)
        }
        elementindex = elementindex + 1 --adds 1 to the var
    end
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
        title =
        "<img style='max-height:5vh;max-width:7vh; float: left;text-align: center; margin-top: 4vh; position:relative; right: 8vh;' src='nui://s-barmen/images/bar.png'>"
        .. "<div style='position: relative; right: 6vh; margin-top: 4vh;'>" .. _U("menuTitle") .. "</div>",
        align = 'top-left',
        elements = elements,
        lastmenu = "MainMenu"
    },
        function(data)
            if (data.current == "backup") then
                _G[data.trigger]()
            else
                Iitemname = data.current.info.itemdbname --sets the varible to whatever option is clicked (since we set info to = the table)
                Pprice = data.current.info.price
                Scurrencytype = data.current.info.currencytype -- Get the currencytype from config.shop added by mrtb
                TriggerEvent("vorpinputs:advancedInput", json.encode(myInput),function(result)
                    local qty = tonumber(result)
                    if qty > 0 then
                        progressbar.start(_U("otherprepare"), 7000)
                        RequestAnimDict("amb_work@world_human_bartender@serve_player")
                        while not HasAnimDictLoaded("amb_work@world_human_bartender@serve_player") do
                            Wait(100)
                        end
                        TaskPlayAnim(PlayerPedId(), "amb_work@world_human_bartender@serve_player","take_beer_trans_pour_whiskey", 8.0, 8.0, 100000000000000, 1, 0, true, 0, false, 0, false)
                        Wait(7000) --waits until the anim / progressbar above is over
                        StopAnimTask(PlayerPedId(), "amb_work@world_human_bartender@serve_player","take_beer_trans_pour_whiskey")
                       TriggerServerEvent('s:BuyOthers', qty, Iitemname, Pprice, Scurrencytype)
                       MenuData.CloseAll()
                    else
                        TriggerEvent("vorp:TipRight", "insertamount", 3000)
                    end
                end)
            end
        end)
end)

