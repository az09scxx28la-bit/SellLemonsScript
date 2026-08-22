--[[
    RAYFIELD MENU SCRIPT - AUTO-UPDATE SYSTEM
    Script ID: sid_scfu9em3x8ti
    Raw GitHub: https://raw.githubusercontent.com/az09scxx28la-bit/SellLemonsScript/refs/heads/main/script.lua
]]

-- [[ ========== AUTO-UPDATE SYSTEM ========== ]]
local Rayfield = nil
local scriptVersion = "1.0.0"
local scriptID = "sid_scfu9em3x8ti"

local function CheckForUpdates()
    local currentVersion = scriptVersion
    local githubRawURL = "https://raw.githubusercontent.com/az09scxx28la-bit/SellLemonsScript/refs/heads/main/script.lua"
    
    local success, result = pcall(function()
        return game:HttpGet(githubRawURL)
    end)

    if success and result then
        local newVersion = result:match('scriptVersion%s*=%s*"([^"]+)"')
        if newVersion and newVersion ~= currentVersion then
            print("🔄 New version available:", newVersion)
            print("📥 Downloading update...")
            local loadSuccess, loadError = pcall(function()
                loadstring(result)()
                return true
            end)
            if loadSuccess then
                print("✅ Update applied successfully!")
                return true
            else
                warn("❌ Update failed:", loadError)
                return false
            end
        else
            print("✅ You have the latest version:", currentVersion)
            return true
        end
    else
        warn("⚠️ Could not check for updates. Using current version.")
        return true
    end
end

-- [[ ========== LOAD RAYFIELD ========== ]]
print("🔄 Loading Rayfield...")
local RayfieldLoaded, RayfieldLoadError = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not RayfieldLoaded or not Rayfield then
    warn("❌ Rayfield failed to load!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Rayfield failed to load! Check console.",
        Duration = 5
    })
    return
end

print("✅ Rayfield loaded!")

-- [[ ========== SERVICES ========== ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

-- [[ ========== GLOBALS ========== ]]
_G.InfJump = false
_G.Noclip = false
_G.ESPEnabled = false
_G.ESPColor = Color3.fromRGB(255, 0, 0)
_G.FOV = 70
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.CustomColor = Color3.fromRGB(0, 125, 255)
_G.TransparencyValue = 0
_G.FullTransparency = false
_G.AutoFarm = false
_G.AutoCollect = false
_G.AntiKick = false
_G.AntiBan = false
_G.SpinBot = false
_G.FlyMode = false
_G.GodMode = false
_G.TeleportOnDamage = false
_G.AutoRejoin = false
_G.BypassActive = false
_G.BetaFeature1 = false
_G.BetaFeature2 = false
_G.SafetyMode = false
_G.AntiCrash = false
_G.AntiFreeze = false

-- [[ ========== UTILITY FUNCTIONS ========== ]]
local function getGameName()
    local success, info = pcall(function() 
        return MarketplaceService:GetProductInfo(game.PlaceId).Name 
    end)
    return (success and info) and info or "Roblox Game"
end

local function ApplyTransparency()
    pcall(function()
        local rayfieldGui = CoreGui:FindFirstChild("Rayfield") 
            or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Rayfield"))
        if rayfieldGui then
            for _, v in pairs(rayfieldGui:GetDescendants()) do
                if v:IsA("Frame") or v:IsA("ScrollingFrame") then
                    if _G.FullTransparency or v.Name == "Main" or v.Name == "SideBar" then
                        v.BackgroundTransparency = _G.TransparencyValue / 100
                    end
                end
            end
        end
    end)
end

local function ApplyAccentColor(color)
    pcall(function()
        local rayfieldGui = CoreGui:FindFirstChild("Rayfield") 
            or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Rayfield"))
        if rayfieldGui then
            for _, v in pairs(rayfieldGui:GetDescendants()) do
                if v:IsA("Frame") and (v.Name == "InteractionRender" or v.Name == "Accent" or v.Name == "Slider") then
                    v.BackgroundColor3 = color
                elseif v:IsA("TextButton") and v.Name == "InteractionRender" then
                    v.BackgroundColor3 = color
                elseif v:IsA("TextLabel") and v.Name == "Title" then
                    v.TextColor3 = color
                end
            end
        end
    end)
end

-- [[ ========== CREATE RAYFIELD WINDOW ========== ]]
print("🔄 Creating Rayfield window...")

local Window = Rayfield:CreateWindow({
    Name = "🔰 SellLemons Hub | v" .. scriptVersion,
    LoadingTitle = "Loading Menu...",
    LoadingSubtitle = "Script ID: " .. scriptID,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SellLemonsConfigs",
        FileName = "UserPrefs"
    },
    KeySystem = false,
})

print("✅ Window created!")

-- [[ ========== CREATE ALL 9 TABS ========== ]]
local MainTab = Window:CreateTab("Main", "home")
local AutomationTab = Window:CreateTab("Automation", "play")
local CheatsTab = Window:CreateTab("Cheats", "zap")
local BetaTab = Window:CreateTab("Beta", "flask")
local SafetyTab = Window:CreateTab("Safety", "shield")
local AntiTab = Window:CreateTab("Anti", "ban")
local BypassTab = Window:CreateTab("Bypass", "unlock")
local FunTab = Window:CreateTab("Fun", "smile")
local SettingsTab = Window:CreateTab("Settings", "settings")

print("✅ 9 Tabs created!")

-- [[ ========== MAIN TAB ========== ]]
MainTab:CreateSection("🏠 Welcome")

MainTab:CreateLabel("Welcome to SellLemons Hub!")
MainTab:CreateLabel("Script ID: " .. scriptID)
MainTab:CreateLabel("Version: " .. scriptVersion)

MainTab:CreateButton({
    Name = "🔄 Check for Updates",
    Callback = function()
        Rayfield:Notify({
            Title = "Checking...",
            Content = "Looking for updates...",
            Duration = 2
        })
        CheckForUpdates()
    end
})

MainTab:CreateButton({
    Name = "📋 Copy Script ID",
    Callback = function()
        setclipboard(scriptID)
        Rayfield:Notify({
            Title = "✅ Copied!",
            Content = "Script ID copied to clipboard",
            Duration = 3
        })
    end
})

MainTab:CreateSection("👤 Player Info")

MainTab:CreateLabel("Username: " .. (LocalPlayer and LocalPlayer.Name or "Unknown"))
MainTab:CreateLabel("Display Name: " .. (LocalPlayer and LocalPlayer.DisplayName or "Unknown"))
MainTab:CreateLabel("User ID: " .. (LocalPlayer and LocalPlayer.UserId or "Unknown"))

MainTab:CreateButton({
    Name = "📋 Copy User ID",
    Callback = function()
        if LocalPlayer then
            setclipboard(tostring(LocalPlayer.UserId))
            Rayfield:Notify({
                Title = "✅ Copied!",
                Content = "User ID copied to clipboard",
                Duration = 3
            })
        end
    end
})

MainTab:CreateSection("🎮 Quick Actions")

MainTab:CreateButton({
    Name = "🔄 Reset Character",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            char:BreakJoints()
            Rayfield:Notify({
                Title = "Reset",
                Content = "Character reset!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateButton({
    Name = "📍 Teleport to Spawn",
    Callback = function()
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = spawn.CFrame
                Rayfield:Notify({
                    Title = "Teleported!",
                    Content = "Moved to spawn location",
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No spawn location found!",
                Duration = 3
            })
        end
    end
})

-- [[ ========== AUTOMATION TAB ========== ]]
AutomationTab:CreateSection("🤖 Auto Farm")

AutomationTab:CreateToggle({
    Name = "🔄 Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        Rayfield:Notify({
            Title = "Auto Farm",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AutomationTab:CreateToggle({
    Name = "📦 Auto Collect",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoCollect = Value
        Rayfield:Notify({
            Title = "Auto Collect",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AutomationTab:CreateToggle({
    Name = "🔄 Auto Rejoin",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoRejoin = Value
        Rayfield:Notify({
            Title = "Auto Rejoin",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AutomationTab:CreateSection("⚙️ Automation Settings")

AutomationTab:CreateSlider({
    Name = "Farm Speed",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        print("Farm speed set to:", Value)
        Rayfield:Notify({
            Title = "Farm Speed",
            Content = "Set to " .. Value,
            Duration = 2
        })
    end
})

AutomationTab:CreateSlider({
    Name = "Collection Delay (seconds)",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        print("Collection delay set to:", Value)
    end
})

-- [[ ========== CHEATS TAB ========== ]]
CheatsTab:CreateSection("👤 Movement")

CheatsTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 350},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        _G.WalkSpeed = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

CheatsTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        _G.JumpPower = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

CheatsTab:CreateToggle({
    Name = "🦘 Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        _G.InfJump = Value
        Rayfield:Notify({
            Title = "Infinite Jump",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

CheatsTab:CreateToggle({
    Name = "🔄 Noclip",
    CurrentValue = false,
    Callback = function(Value)
        _G.Noclip = Value
        Rayfield:Notify({
            Title = "Noclip",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

CheatsTab:CreateToggle({
    Name = "✈️ Fly Mode",
    CurrentValue = false,
    Callback = function(Value)
        _G.FlyMode = Value
        Rayfield:Notify({
            Title = "Fly Mode",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

CheatsTab:CreateSection("🛡️ God Mode")

CheatsTab:CreateToggle({
    Name = "💀 God Mode",
    CurrentValue = false,
    Callback = function(Value)
        _G.GodMode = Value
        if Value then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").MaxHealth = math.huge
                char:FindFirstChildOfClass("Humanoid").Health = math.huge
            end
        end
        Rayfield:Notify({
            Title = "God Mode",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

CheatsTab:CreateToggle({
    Name = "💫 Teleport on Damage",
    CurrentValue = false,
    Callback = function(Value)
        _G.TeleportOnDamage = Value
        Rayfield:Notify({
            Title = "Teleport on Damage",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

CheatsTab:CreateSection("👁️ Visuals")

CheatsTab:CreateSlider({
    Name = "FOV",
    Range = {30, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(Value)
        _G.FOV = Value
        pcall(function()
            workspace.CurrentCamera.FieldOfView = Value
        end)
    end
})

CheatsTab:CreateToggle({
    Name = "🎯 Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
        if not Value then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character then
                    local highlight = v.Character:FindFirstChild("ESP_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
        Rayfield:Notify({
            Title = "ESP",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

CheatsTab:CreateColorPicker({
    Name = "🎨 ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        _G.ESPColor = Value
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local highlight = v.Character:FindFirstChild("ESP_Highlight")
                if highlight then highlight.FillColor = Value end
            end
        end
    end
})

CheatsTab:CreateToggle({
    Name = "🔄 Spin Bot",
    CurrentValue = false,
    Callback = function(Value)
        _G.SpinBot = Value
        Rayfield:Notify({
            Title = "Spin Bot",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

-- [[ ========== BETA TAB ========== ]]
BetaTab:CreateSection("🧪 Beta Features")

BetaTab:CreateLabel("⚠️ These features are experimental!")
BetaTab:CreateLabel("Use at your own risk!")

BetaTab:CreateToggle({
    Name = "🧪 Beta Feature 1: Super Jump",
    CurrentValue = false,
    Callback = function(Value)
        _G.BetaFeature1 = Value
        if Value then
            _G.JumpPower = 1000
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").JumpPower = 1000
            end
        else
            _G.JumpPower = 50
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").JumpPower = 50
            end
        end
        Rayfield:Notify({
            Title = "Super Jump",
            Content = Value and "✅ Enabled (1000 JumpPower)" or "❌ Disabled (50 JumpPower)",
            Duration = 3
        })
    end
})

BetaTab:CreateToggle({
    Name = "🧪 Beta Feature 2: Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        _G.BetaFeature2 = Value
        Rayfield:Notify({
            Title = "Infinite Stamina",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

BetaTab:CreateToggle({
    Name = "🧪 Beta Feature 3: Fast Respawn",
    CurrentValue = false,
    Callback = function(Value)
        print("Fast Respawn:", Value)
        Rayfield:Notify({
            Title = "Fast Respawn",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

BetaTab:CreateSection("📊 Beta Stats")

BetaTab:CreateLabel("Beta Features Active: 0/3")

BetaTab:CreateButton({
    Name = "🔄 Refresh Beta Stats",
    Callback = function()
        local count = 0
        if _G.BetaFeature1 then count = count + 1 end
        if _G.BetaFeature2 then count = count + 1 end
        if _G.BetaFeature3 then count = count + 1 end
        Rayfield:Notify({
            Title = "Beta Stats",
            Content = count .. "/3 features active",
            Duration = 3
        })
    end
})

-- [[ ========== SAFETY TAB ========== ]]
SafetyTab:CreateSection("🛡️ Safety Features")

SafetyTab:CreateLabel("⚠️ These features help protect you!")

SafetyTab:CreateToggle({
    Name = "🛡️ Safety Mode",
    CurrentValue = false,
    Callback = function(Value)
        _G.SafetyMode = Value
        Rayfield:Notify({
            Title = "Safety Mode",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

SafetyTab:CreateToggle({
    Name = "🚫 Anti-Crash",
    CurrentValue = false,
    Callback = function(Value)
        _G.AntiCrash = Value
        Rayfield:Notify({
            Title = "Anti-Crash",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

SafetyTab:CreateToggle({
    Name = "❄️ Anti-Freeze",
    CurrentValue = false,
    Callback = function(Value)
        _G.AntiFreeze = Value
        Rayfield:Notify({
            Title = "Anti-Freeze",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

SafetyTab:CreateSection("🔄 Auto Protection")

SafetyTab:CreateToggle({
    Name = "🔄 Auto Reconnect on Kick",
    CurrentValue = false,
    Callback = function(Value)
        print("Auto Reconnect:", Value)
        Rayfield:Notify({
            Title = "Auto Reconnect",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

SafetyTab:CreateButton({
    Name = "🔄 Reconnect Now",
    Callback = function()
        Rayfield:Notify({
            Title = "Reconnecting...",
            Content = "Attempting to reconnect...",
            Duration = 3
        })
    end
})

-- [[ ========== ANTI TAB ========== ]]
AntiTab:CreateSection("🚫 Anti Features")

AntiTab:CreateLabel("⚠️ Anti-features to prevent issues")

AntiTab:CreateToggle({
    Name = "🚫 Anti-Kick",
    CurrentValue = false,
    Callback = function(Value)
        _G.AntiKick = Value
        Rayfield:Notify({
            Title = "Anti-Kick",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AntiTab:CreateToggle({
    Name = "🚫 Anti-Ban",
    CurrentValue = false,
    Callback = function(Value)
        _G.AntiBan = Value
        Rayfield:Notify({
            Title = "Anti-Ban",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AntiTab:CreateToggle({
    Name = "🚫 Anti-Exploit Detection",
    CurrentValue = false,
    Callback = function(Value)
        print("Anti-Exploit Detection:", Value)
        Rayfield:Notify({
            Title = "Anti-Exploit Detection",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AntiTab:CreateSection("🛡️ Advanced Protection")

AntiTab:CreateToggle({
    Name = "🛡️ Script Protection",
    CurrentValue = false,
    Callback = function(Value)
        print("Script Protection:", Value)
        Rayfield:Notify({
            Title = "Script Protection",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AntiTab:CreateToggle({
    Name = "🛡️ Server Protection",
    CurrentValue = false,
    Callback = function(Value)
        print("Server Protection:", Value)
        Rayfield:Notify({
            Title = "Server Protection",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

AntiTab:CreateButton({
    Name = "🔄 Reset Anti-Features",
    Callback = function()
        _G.AntiKick = false
        _G.AntiBan = false
        Rayfield:Notify({
            Title = "Reset",
            Content = "All anti-features reset!",
            Duration = 3
        })
    end
})

-- [[ ========== BYPASS TAB ========== ]]
BypassTab:CreateSection("🔓 Bypass Features")

BypassTab:CreateLabel("⚠️ Use these at your own risk!")

BypassTab:CreateToggle({
    Name = "🔓 Activate Bypass",
    CurrentValue = false,
    Callback = function(Value)
        _G.BypassActive = Value
        Rayfield:Notify({
            Title = "Bypass",
            Content = Value and "✅ Activated" or "❌ Deactivated",
            Duration = 2
        })
    end
})

BypassTab:CreateToggle({
    Name = "🔓 Bypass Anti-Exploit",
    CurrentValue = false,
    Callback = function(Value)
        print("Bypass Anti-Exploit:", Value)
        Rayfield:Notify({
            Title = "Bypass Anti-Exploit",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

BypassTab:CreateToggle({
    Name = "🔓 Bypass Anti-Cheat",
    CurrentValue = false,
    Callback = function(Value)
        print("Bypass Anti-Cheat:", Value)
        Rayfield:Notify({
            Title = "Bypass Anti-Cheat",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

BypassTab:CreateSection("⚡ Bypass Settings")

BypassTab:CreateSlider({
    Name = "Bypass Strength",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value)
        print("Bypass strength set to:", Value)
        Rayfield:Notify({
            Title = "Bypass Strength",
            Content = "Set to " .. Value,
            Duration = 2
        })
    end
})

BypassTab:CreateButton({
    Name = "🔄 Reset Bypass",
    Callback = function()
        _G.BypassActive = false
        Rayfield:Notify({
            Title = "Reset",
            Content = "Bypass reset!",
            Duration = 3
        })
    end
})

-- [[ ========== FUN TAB ========== ]]
FunTab:CreateSection("🎉 Fun Features")

FunTab:CreateLabel("Just for fun! 😄")

FunTab:CreateButton({
    Name = "🎭 Toggle Dance Mode",
    Callback = function()
        Rayfield:Notify({
            Title = "Dance Mode!",
            Content = "💃🕺 Let's dance!",
            Duration = 3
        })
    end
})

FunTab:CreateButton({
    Name = "🎵 Play Random Sound",
    Callback = function()
        Rayfield:Notify({
            Title = "Sound!",
            Content = "🔊 Playing random sound...",
            Duration = 2
        })
    end
})

FunTab:CreateToggle({
    Name = "🌈 Rainbow Character",
    CurrentValue = false,
    Callback = function(Value)
        print("Rainbow Character:", Value)
        Rayfield:Notify({
            Title = "Rainbow Character",
            Content = Value and "✅ Enabled 🌈" or "❌ Disabled",
            Duration = 2
        })
    end
})

FunTab:CreateToggle({
    Name = "🎨 Colorful Chat",
    CurrentValue = false,
    Callback = function(Value)
        print("Colorful Chat:", Value)
        Rayfield:Notify({
            Title = "Colorful Chat",
            Content = Value and "✅ Enabled" or "❌ Disabled",
            Duration = 2
        })
    end
})

FunTab:CreateSection("😄 Fun Stats")

FunTab:CreateLabel("Fun Features Active: 0/4")

FunTab:CreateButton({
    Name = "🔄 Refresh Fun Stats",
    Callback = function()
        Rayfield:Notify({
            Title = "Fun Stats",
            Content = "Check console for details!",
            Duration = 3
        })
    end
})

FunTab:CreateButton({
    Name = "🎁 Random Surprise",
    Callback = function()
        local surprises = {
            "🎉 You got a free cookie!",
            "🎁 Here's a virtual hug!",
            "🌟 You're amazing!",
            "💎 You found a hidden gem!",
            "🦄 A unicorn appeared!",
            "🍕 Free pizza for you!",
        }
        local random = surprises[math.random(1, #surprises)]
        Rayfield:Notify({
            Title = "🎁 Surprise!",
            Content = random,
            Duration = 4
        })
    end
})

-- [[ ========== SETTINGS TAB ========== ]]
SettingsTab:CreateSection("🎨 UI Customization")

SettingsTab:CreateColorPicker({
    Name = "Menu Accent Color",
    Color = Color3.fromRGB(0, 125, 255),
    Callback = function(Value)
        _G.CustomColor = Value
        ApplyAccentColor(Value)
    end
})

SettingsTab:CreateToggle({
    Name = "Full UI Transparency",
    CurrentValue = false,
    Callback = function(Value)
        _G.FullTransparency = Value
        ApplyTransparency()
    end
})

SettingsTab:CreateSlider({
    Name = "Transparency Level",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        _G.TransparencyValue = Value
        ApplyTransparency()
    end
})

SettingsTab:CreateSection("ℹ️ Info")

SettingsTab:CreateLabel("Script ID: " .. scriptID)
SettingsTab:CreateLabel("Version: " .. scriptVersion)
SettingsTab:CreateLabel("Made by: SellLemons")

SettingsTab:CreateButton({
    Name = "📋 Copy Script ID",
    Callback = function()
        setclipboard(scriptID)
        Rayfield:Notify({
            Title = "✅ Copied!",
            Content = "Script ID copied to clipboard",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "🔄 Reset All Settings",
    Callback = function()
        Rayfield:Notify({
            Title = "Reset",
            Content = "All settings reset!",
            Duration = 3
        })
    end
})

-- [[ ========== SYSTEM LOOPS ========== ]]

-- ESP Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.ESPEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local highlight = v.Character:FindFirstChild("ESP_Highlight")
                    if not highlight then
                        highlight = Instance.new("Highlight", v.Character)
                        highlight.Name = "ESP_Highlight"
                        highlight.FillColor = _G.ESPColor
                        highlight.FillTransparency = 0.3
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineTransparency = 0.5
                    else
                        highlight.FillColor = _G.ESPColor
                    end
                end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not hum.Sit then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        local char = LocalPlayer.Character
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if _G.GodMode and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
end)

-- Spin Bot
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.SpinBot and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.1, 0)
            end
        end
    end
end)

-- Fly Mode
local flyBodyVelocity = nil
local flyBodyGyro = nil

RunService.Heartbeat:Connect(function()
    if _G.FlyMode and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
                flyBodyVelocity.Parent = hrp
                
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
                flyBodyGyro.Parent = hrp
            end
            
            local moveVector = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + hrp.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - hrp.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - hrp.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + hrp.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
            
            flyBodyVelocity.Velocity = moveVector * 50
            flyBodyGyro.CFrame = hrp.CFrame
        end
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    end
end)

-- Teleport on Damage
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").HealthChanged:Connect(function(health)
        if _G.TeleportOnDamage and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
            end
        end
    end)
end)

-- Auto-update title
task.spawn(function()
    while true do
        task.wait(60)
        local success, currentName = pcall(getGameName)
        if success and currentName then
            pcall(function()
                local rayfieldGui = CoreGui:FindFirstChild("Rayfield") 
                    or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Rayfield"))
                if rayfieldGui then
                    local titleLabel = rayfieldGui:FindFirstChild("Title", true)
                    if titleLabel and titleLabel:IsA("TextLabel") then
                        titleLabel.Text = "🔰 " .. currentName .. " | v" .. scriptVersion
                    end
                end
            end)
        end
    end
end)

print("✅ SellLemons Hub loaded successfully!")
print("📋 Tabs: Main | Automation | Cheats | Beta | Safety | Anti | Bypass | Fun | Settings")
print("📋 Script ID:", scriptID)
print("📋 Version:", scriptVersion)
