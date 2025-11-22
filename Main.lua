local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Run = game:GetService("RunService")

local Config = {
    AutoCast = true,
    AutoReel = true,
    AutoSell = true,
    FastReelSpeed = 5,
    FastCatchSpeed = 5,
    AutoHop = true
}

pcall(function()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
end)

task.spawn(function()
    while task.wait(.4) do
        if Config.AutoCast then
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Cast:FireServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(.1) do
        pcall(function()
            if Player:FindFirstChild("Fishing") then
                Player.Fishing.ReelSpeed.Value = Config.FastReelSpeed
                Player.Fishing.CatchSpeed.Value = Config.FastCatchSpeed
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(.2) do
        if Config.AutoReel then
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Reel:FireServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if Config.AutoSell then
            pcall(function()
                game:GetService("ReplicatedStorage").Events.SellFish:FireServer()
            end)
        end
    end
end)

function Hop()
    pcall(function()
        local TP = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local S = game:HttpGet(TP)
        local Data = game:GetService("HttpService"):JSONDecode(S)
        for _,v in pairs(Data.data) do
            if v.playing < v.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
    end)
end

task.spawn(function()
    while task.wait(10) do
        if Config.AutoHop then
            if #Players:GetPlayers() >= game.Players.MaxPlayers then
                Hop()
            end
        end
    end
end)

print("Fish It X5 Speed Loaded Successfully!")
