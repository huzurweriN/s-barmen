local VORPcore = {}
local VORPinv

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPinv = exports.vorp_inventory:vorp_inventoryApi()

BccUtils = exports['bcc-utils'].initiate()


RegisterServerEvent("s:checkjob")
AddEventHandler("s:checkjob", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local job = Character.job
    for k,v in pairs(Config.Bars) do
        if job == v.Job then
            TriggerClientEvent('s:OpenBarMenu', _source)
        else
            TriggerClientEvent("vorp:TipRight", _source, "You not work here :)", 4000) 
        end
    end
end)

RegisterServerEvent('s:BuyDrinks', function(qty, Itemnamee, Priceee, Scurrencyy)
    local _source = source
    local totalamountmultiplied = 	qty * Priceee 
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local currmoney
    if (Scurrencyy == 'cash') then 
      ScurrencyT = 0
      currmoney = Character.money
    elseif (Scurrencyy == 'gold') then
      ScurrencyT = 1
      currmoney = Character.gold
    end 
    if currmoney >= totalamountmultiplied then
      VORPinv.addItem(_source, Itemnamee, qty)
      TriggerClientEvent("vorp:TipRight", _source, _U("buy"), 4000) 
      Character.removeCurrency(ScurrencyT, totalamountmultiplied)
      VORPcore.AddWebhook(Character.firstname .. " " .. Character.lastname .. " " .. Character.identifier, BarWebhook, 'Items bought ' .. Itemnamee .. ' Item price ' .. tostring(Priceee) .. ' Amount bought ' .. tostring(qty))
    elseif currmoney < totalamountmultiplied then
      if (Scurrencyy == 'cash') then 
        VORPcore.NotifyBottomRight(_source, _U("buyerror"), 4000)
      elseif (Scurrencyy == 'gold') then
        VORPcore.NotifyBottomRight(_source, _U("buyerror"), 4000)
      end 
    end
  end)

  RegisterServerEvent('s:BuyFoods', function(qty, Itemnamee, Priceee, Scurrencyy)
    local _source = source
    local totalamountmultiplied = 	qty * Priceee 
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local currmoney
    if (Scurrencyy == 'cash') then 
      ScurrencyT = 0
      currmoney = Character.money
    elseif (Scurrencyy == 'gold') then
      ScurrencyT = 1
      currmoney = Character.gold
    end 
    if currmoney >= totalamountmultiplied then
      VORPinv.addItem(_source, Itemnamee, qty)
      TriggerClientEvent("vorp:TipRight", _source, _U("buy"), 4000) 
      Character.removeCurrency(ScurrencyT, totalamountmultiplied)
      VORPcore.AddWebhook(Character.firstname .. " " .. Character.lastname .. " " .. Character.identifier, BarWebhook, 'Items bought ' .. Itemnamee .. ' Item price ' .. tostring(Priceee) .. ' Amount bought ' .. tostring(qty))
    elseif currmoney < totalamountmultiplied then
      if (Scurrencyy == 'cash') then 
        VORPcore.NotifyBottomRight(_source, _U("buyerror"), 4000)
      elseif (Scurrencyy == 'gold') then
        VORPcore.NotifyBottomRight(_source, _U("buyerror"), 4000)
      end 
    end
  end)

  RegisterServerEvent('s:BuyOthers', function(qty, Itemnamee, Priceee, Scurrencyy)
    local _source = source
    local totalamountmultiplied = 	qty * Priceee 
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local currmoney
    if (Scurrencyy == 'cash') then 
      ScurrencyT = 0
      currmoney = Character.money
    elseif (Scurrencyy == 'gold') then
      ScurrencyT = 1
      currmoney = Character.gold
    end 
    if currmoney >= totalamountmultiplied then
      VORPinv.addItem(_source, Itemnamee, qty)
      TriggerClientEvent("vorp:TipRight", _source, _U("buy"), 4000) 
      Character.removeCurrency(ScurrencyT, totalamountmultiplied)
      VORPcore.AddWebhook(Character.firstname .. " " .. Character.lastname .. " " .. Character.identifier, BarWebhook, 'Items bought ' .. Itemnamee .. ' Item price ' .. tostring(Priceee) .. ' Amount bought ' .. tostring(qty))
    elseif currmoney < totalamountmultiplied then
      if (Scurrencyy == 'cash') then 
        VORPcore.NotifyBottomRight(_source, _U("buyerror"), 4000)
      elseif (Scurrencyy == 'gold') then
        VORPcore.NotifyBottomRight(_source, _U("buyerror"), 4000)
      end 
    end
  end)
  

