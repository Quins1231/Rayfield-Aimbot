--[[
    Loader: Aimbot + UI by Exunys + Rayfield GUI
    Make sure to run this in an executor that supports `HttpGet`
--]]

--// Load Aimbot Module
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/UniversalAimbot/main/Aimbot.lua"))()
Aimbot:Load()

--// Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Create GUI Window
local Window = Rayfield:CreateWindow({
    Name = "Exunys Aimbot",
    LoadingTitle = "Loading Aimbot...",
    LoadingSubtitle = "by Exunys & ChatGPT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ExunysAimbot",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

--// Main Controls
local Tab = Window:CreateTab("Main", 4483362458)

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
    Name = "FOV Rainbow Color",
    CurrentValue = Aimbot.FOVSettings.RainbowColor,
    Callback = function(Value)
        Aimbot.FOVSettings.RainbowColor = Value
    end
})

Tab:CreateSlider({
    Name = "Camera Tween Sensitivity",
    Range = {0, 3},
    Increment = 0.1,
    CurrentValue = Aimbot.Settings.Sensitivity,
    Callback = function(Value)
        Aimbot.Settings.Sensitivity = Value
    end
})

Tab:CreateSlider({
    Name = "Mouse Sensitivity (LockMode 2)",
    Range = {1, 5},
    Increment = 0.1,
    CurrentValue = Aimbot.Settings.Sensitivity2,
    Callback = function(Value)
        Aimbot.Settings.Sensitivity2 = Value
    end
})

Tab:CreateDropdown({
    Name = "Lock Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = Aimbot.Settings.LockPart,
    Callback = function(Option)
        Aimbot.Settings.LockPart = Option
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
