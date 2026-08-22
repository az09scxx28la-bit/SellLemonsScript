--[[
    RAYFIELD MENU SCRIPT - AUTO-UPDATE SYSTEM
    Script ID: sid_scfu9em3x8ti
    Raw GitHub: https://raw.githubusercontent.com/yourusername/yourrepo/main/script.lua
]]

-- [[ ========== AUTO-UPDATE SYSTEM ========== ]]
local Rayfield = nil
local scriptVersion = "1.0.0"
local scriptID = "sid_scfu9em3x8ti" -- Your Rayfield script ID

-- Function to check for updates (loads from raw GitHub)
local function CheckForUpdates()
    local currentVersion = scriptVersion
    local githubRawURL = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/script.lua"
    -- ^^^ CHANGE THIS TO YOUR ACTUAL GITHUB RAW URL ^^^
    
    -- Try to fetch the latest version
    local success, result = pcall(function()
        return game:HttpGet(githubRawURL)
    end)
    
    if success and result then
        -- Check version in the fetched script
        local newVersion = result:match('scriptVersion%s*=%s*"([^"]+)"')
        if newVersion and newVersion ~= currentVersion then
            print("🔄 New version available:", newVersion)
            print("📥 Downloading update...")
            
            -- Load the new script
            local loadSuccess, loadError = pcall(function()
                local newScript = loadstring(result)()
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
local VirtualUser = game:GetService("VirtualUser")

-- [[ ========== SETTINGS ========== ]]
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
    Name = getGameName() .. " | v" .. scriptVersion,
    LoadingTitle = "Loading Menu...",
    LoadingSubtitle = "Script ID: " .. scriptID,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "YourHubConfigs",
        FileName = "UserPrefs"
    },
    KeySystem = false, -- Set to true if you want a key system
    -- KeySettings = { -- Uncomment if KeySystem is true
    --     Key = "YourKeyHere",
    --     Note = "Get your key from our Discord!"
    -- }
})

print("✅ Window created!")

-- [[ ========== CREATE TABS ========== ]]
-- Main Tabs
local HomeTab = Window:CreateTab("Home", "home")
local PlayerTab = Window:CreateTab("Player", "user")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local TeleportTab = Window:CreateTab("Teleport", "map-pin")
local SettingsTab = Window:CreateTab("Settings", "settings")

print("✅ Tabs created!")

-- [[ ========== HOME TAB ========== ]]
HomeTab:CreateSection("🏠 Welcome")

HomeTab:CreateLabel("Welcome to the Menu!")
HomeTab:CreateLabel("Script ID: " .. scriptID)
HomeTab:CreateLabel("Version: " .. scriptVersion)

HomeTab:CreateButton({
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

HomeTab:CreateButton({
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

-- [[ ========== PLAYER TAB ========== ]]
PlayerTab:CreateSection("👤 Movement")

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
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

PlayerTab:CreateSlider({
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

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
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

PlayerTab:CreateToggle({
    Name = "Noclip",
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

PlayerTab:CreateSection("🛡️ Safety")

PlayerTab:CreateButton({
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

-- [[ ========== VISUALS TAB ========== ]]
VisualsTab:CreateSection("👁️ Visuals")

VisualsTab:CreateSlider({
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

VisualsTab:CreateToggle({
    Name = "Player ESP",
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

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
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

-- [[ ========== TELEPORT TAB ========== ]]
TeleportTab:CreateSection("🌐 Teleport")

TeleportTab:CreateButton({
    Name = "📍 Teleport to Spawn",
    Callback = function()
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame
            Rayfield:Notify({
                Title = "Teleported!",
                Content = "Moved to spawn location",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No spawn location found!",
                Duration = 3
            })
        end
    end
})

TeleportTab:CreateButton({
    Name = "📍 Teleport to Players",
    Callback = function()
        local players = {}
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                table.insert(players, v.Name)
            end
        end
        
        if #players == 0 then
            Rayfield:Notify({
                Title = "No Players",
                Content = "No other players found!",
                Duration = 3
            })
            return
        end
        
        -- You could add a dropdown here for player selection
        print("Players found:", table.concat(players, ", "))
        Rayfield:Notify({
            Title = "Check Console",
            Content = "Players list printed to F9",
            Duration = 3
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
                        titleLabel.Text = currentName .. " | v" .. scriptVersion
                    end
                end
            end)
        end
    end
end)

print("✅ Menu loaded successfully!")
print("📋 Script ID:", scriptID)
print("📋 Version:", scriptVersion)
