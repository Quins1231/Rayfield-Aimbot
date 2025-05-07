-- Safe Jailbreak Aimbot by Exunys + ChatGPT (modified)
-- Last updated: 2025

--// 🛑 Safety Checks
if game.PlaceId ~= 606849621 then
    warn("Not in Jailbreak. Exiting aimbot.")
    return
end

--// 🌐 Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// 🚧 Delay Start (mimics natural loading)
task.wait(5 + math.random())

--// 👮 Admin Check (auto disable)
local knownAdmins = {"badcc", "asimo3089"}
for _, player in ipairs(Players:GetPlayers()) do
    if table.find(knownAdmins, player.Name:lower()) then
        warn("Admin detected ("..player.Name.."). Aimbot disabled.")
        return
    end
end

--// 📦 Load Aimbot
local envName = "_aim_env_" .. tostring(math.random(1000, 9999))
getgenv()[envName] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/UniversalAimbot/main/Aimbot.lua"))()
local Aimbot = getgenv()[envName]
Aimbot:Load()

--// 🧠 Jailbreak-Specific TeamCheck
function Aimbot.IsEnemy(player)
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or "Unknown"
    local otherTeam = player.Team and player.Team.Name or "Unknown"
    return (myTeam == "Police" and (otherTeam == "Criminal" or otherTeam == "Prisoner")) or
           ((myTeam == "Criminal" or myTeam == "Prisoner") and otherTeam == "Police")
end

--// 🎯 Safe GetClosestPlayer (rate-limited)
local lastUpdate = 0
local function SafeGetClosestPlayer()
    local now = tick()
    if now - lastUpdate < 0.1 then return end
    lastUpdate = now

    local cam = workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer, shortestDist = nil, Aimbot.FOVSettings.Radius or 150

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Aimbot.Settings.LockPart) then
            if not Aimbot.IsEnemy(player) then continue end
            local headPos, onScreen = cam:WorldToViewportPoint(player.Character[Aimbot.Settings.LockPart].Position)
            if onScreen then
                local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closestPlayer = player
                end
            end
        end
    end

    Aimbot.Locked = closestPlayer
end

-- Override with safe version
Aimbot.GetClosestPlayer = SafeGetClosestPlayer

--// 🧰 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Jailbreak Aimbot",
    LoadingTitle = "Safe Aimbot Init",
    LoadingSubtitle = "by Exunys + ChatGPT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JailbreakAimbot",
        FileName = "Settings"
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Aimbot Settings", 4483362458)

Tab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = Aimbot.Settings.Enabled,
    Callback = function(Value)
        Aimbot.Settings.Enabled = Value
    end
})

Tab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = Aimbot.FOVSettings.Enabled,
    Callback = function(Value)
        Aimbot.FOVSettings.Enabled = Value
    end
})

Tab:CreateToggle({
    Name = "Rainbow FOV",
    CurrentValue = Aimbot.FOVSettings.RainbowColor,
    Callback = function(Value)
        Aimbot.FOVSettings.RainbowColor = Value
    end
})

Tab:CreateDropdown({
    Name = "Target Lock Part",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = Aimbot.Settings.LockPart,
    Callback = function(Option)
        Aimbot.Settings.LockPart = Option
    end
})

Tab:CreateSlider({
    Name = "Camera Sensitivity",
    Range = {0, 3},
    Increment = 0.1,
    CurrentValue = Aimbot.Settings.Sensitivity,
    Callback = function(Value)
        Aimbot.Settings.Sensitivity = Value
    end
})

Tab:CreateSlider({
    Name = "Mouse Sensitivity (Mode 2)",
    Range = {1, 5},
    Increment = 0.1,
    CurrentValue = Aimbot.Settings.Sensitivity2,
    Callback = function(Value)
        Aimbot.Settings.Sensitivity2 = Value
    end
})

Tab:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = Aimbot.FOVSettings.Color,
    Callback = function(Color)
        Aimbot.FOVSettings.Color = Color
    end
})

Tab:CreateButton({
    Name = "Clear Blacklist",
    Callback = function()
        table.clear(Aimbot.Blacklisted)
    end
})
