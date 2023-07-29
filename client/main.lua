VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
end)

TriggerEvent("menuapi:getData", function(call)
  MenuData = call
end)

BccUtils = exports['bcc-utils'].initiate()
progressbar = exports.vorp_progressbar:initiate()

CreateThread(function()
    TriggerEvent('s:BarMusic')
    local audioplay = false
    local PromptGroup = VORPutils.Prompts:SetupPromptGroup()
    local firstprompt = PromptGroup:RegisterPrompt(_U("openBarMenu"), 0x760A9C6F, 1, 1, true, 'hold',
        { timedeventhash = "MEDIUM_TIMED_EVENT" })
    while true do
        Wait(5)
        local sleep = true
        local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
        for k, v in pairs(Config.Bars) do
            if GetDistanceBetweenCoords(v.coords.x, v.coords.y, v.coords.z, px, py, pz, true) < v.radius then
                sleep = false
                PromptGroup:ShowGroup(_U("Bar"))
                if firstprompt:HasCompleted() then
                    TriggerServerEvent("s:checkjob")
                end
            end
        end
        if sleep then
            Wait(1500)
        end
    end
end)

RegisterNetEvent('s:BarMusic', function()
    while true do
        Wait(5)
        for k, v in pairs(Config.Bars) do
        local playercoord = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(playercoord.x, playercoord.y, playercoord.z, v.coords.x, v.coords.y, v.coords.z, true)
        if dist < 10 then
            if Config.BarMusic.Music then
                if not audioplay then
                    audioplay = true
                    BccUtils.YtAudioPlayer.PlayAudio('https://www.youtube.com/embed/0SIizvT5Bk8', '0SIizvT5Bk8', Config.BarMusic.MusicVolume, 1)
                end
            end
        else
            if Config.BarMusic.Music then
                if audioplay then
                    audioplay = false
                    BccUtils.YtAudioPlayer.StopAudio()
                end
            end
        end
        end
    end
end)

local blips = {}
CreateThread(function()
    for k, v in pairs(Config.Bars) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords.x, v.coords.y, v.coords.z) -- This create a blip with a defualt blip hash we given
        SetBlipSprite(blip, Config.BarBlipHash, 1) -- This sets the blip hash to the given in config.
        SetBlipScale(blip, 0.8)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, joaat(Config.BarBlipColor))
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.BarName) -- Sets the blip Name
        table.insert(blips, blip)
    end
end)

