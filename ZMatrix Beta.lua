--// XOÁ UI CŨ (NẾU CÓ)
if getgenv and getgenv().ZMatrix_Evade_Window and typeof(getgenv().ZMatrix_Evade_Window) == "table" then
    pcall(function()
        if getgenv().ZMatrix_Evade_Window.Destroy then
            getgenv().ZMatrix_Evade_Window:Destroy()
        end
    end)
end

--// LOAD WINDUI (BẢN CHÍNH, KHÔNG DÙNG main_example)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--// TẠO WINDOW CHO ZMATRIX EVADE
local Window = WindUI:CreateWindow({
    Title = "ZMatrix | Evade (EVENT)",
    Icon = "ghost", -- icon lucide (hoặc "lucide:ghost")
    Folder = "ZMatrix_Evade",
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    User = {
        Enabled = false,
    },
    SideBarWidth = 200,
})

-- Lưu lại để lần chạy sau có thể Destroy
if getgenv then
    getgenv().ZMatrix_Evade_Window = Window
end

-- TAG PHÍA TRÊN
Window:Tag({
    Title = "Beta",
    Color = Color3.fromHex("#315dff")
})

Window:Tag({
    Title = "ZMatrix Hub",
    Color = Color3.fromHex("#30ff6a")
})

----------------------------------------------------
--            CẤU TRÚC WINDUI (TABS / SECTIONS)
----------------------------------------------------

-- Một Section lớn chứa các Tab con
local MainTabSection = Window:Section({
    Title = "ZMatrix Evade",
    Icon = "ghost",
    Opened = true,
})

-- Các Tab con giống Zentrix: Farm, Game, Player, ESP, Info, Settings
local Tabs = {
    Farm     = MainTabSection:Tab({ Title = "Farm / Safe",   Icon = "shield" }),
    Game     = MainTabSection:Tab({ Title = "Game / Farm",   Icon = "sword" }),
    Player   = MainTabSection:Tab({ Title = "Player",        Icon = "user" }),
    ESP      = MainTabSection:Tab({ Title = "ESP",           Icon = "radar" }),
    Info     = MainTabSection:Tab({ Title = "Info",          Icon = "info" }),
    Settings = MainTabSection:Tab({ Title = "Settings",      Icon = "settings" }),
}

-- Mỗi Tab có 1 Section chính
local FarmSection     = Tabs.Farm:Section({ Title = "Evade (EVENT) - ZMatrix", Opened = true })
local GameSection     = Tabs.Game:Section({ Title = "Game / Farm" })
local PlayerSection   = Tabs.Player:Section({ Title = "Player Settings" })
local ESPSection      = Tabs.ESP:Section({ Title = "ESP Settings" })
local InfoSection     = Tabs.Info:Section({ Title = "Information" })
local SettingsSection = Tabs.Settings:Section({ Title = "Settings" })

-- LABEL (giống Paragraph Zentrix)
FarmSection:Paragraph({
    Title = "Beta ZMatrix Hub",
    Desc  = "Auto Collect Items, Avoid Nextbot, Farm XP / Money, ESP, Anti AFK, BHop...",
    Image = "sparkles",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a"),
})

----------------------------------------------------
--                LOGIC SCRIPT CŨ (TORA)
----------------------------------------------------

-- Xoá UI Tora cũ nếu có
if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
    game:GetService("CoreGui").ToraScript:Destroy()
end

_G.Items = false
_G.Avoid = false

-- COLLECT ITEMS (Tickets)
local function Items()
    task.spawn(function()
        _G.Items = true

        while _G.Items do
            task.wait()
            pcall(function()
                local effects = workspace:FindFirstChild("Game")
                    and workspace.Game:FindFirstChild("Effects")
                    and workspace.Game.Effects:FindFirstChild("Tickets")

                if not effects then
                    return
                end

                for _, obj in pairs(effects:GetChildren()) do
                    if obj:FindFirstChild("HumanoidRootPart")
                        and game.Players.LocalPlayer.Character
                        and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                            CFrame.new(obj.HumanoidRootPart.Position)
                        task.wait()
                    end
                end
            end)
        end
    end)
end

-- AVOID NEXTBOT
local function Avoid()
    task.spawn(function()
        _G.Avoid = true
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        while _G.Avoid do
            task.wait()
            pcall(function()
                local gameFolder = workspace:FindFirstChild("Game")
                if not gameFolder then return end

                local plrsFolder = gameFolder:FindFirstChild("Players")
                local mapFolder  = gameFolder:FindFirstChild("Map")
                if not plrsFolder or not mapFolder then return end

                local function getNearestBot()
                    local nearest, dist = nil, 30
                    for _, plr in pairs(plrsFolder:GetChildren()) do
                        if plr:GetAttribute("AI") == true
                            and plr:FindFirstChild("HumanoidRootPart")
                            and LocalPlayer.Character
                            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                            local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.HumanoidRootPart.Position).Magnitude
                            if mag < dist then
                                nearest = plr
                                dist = mag
                            end
                        end
                    end
                    return nearest, dist
                end

                local function getRandomItemSpawn()
                    local itemSpawns = mapFolder:FindFirstChild("ItemSpawns")
                    if not itemSpawns then return nil end

                    local list = {}
                    for _, v in pairs(itemSpawns:GetChildren()) do
                        if v.Name == "ItemSpawn" then
                            table.insert(list, v)
                        end
                    end
                    if #list == 0 then return nil end
                    return list[math.random(1, #list)]
                end

                local nearestBot, distance = getNearestBot()
                local targetSpawn = (nearestBot and distance and distance <= 30) and getRandomItemSpawn() or nil

                if targetSpawn
                    and LocalPlayer.Character
                    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetSpawn.CFrame
                end
            end)
        end
    end)
end

----------------------------------------------------
--          CÁC BIẾN DÙNG CHUNG CHO ZENTRIX LOGIC
----------------------------------------------------

local Game = game
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ActiveSpeedBoost      = false
local ActiveEspPlayers      = false
local ActiveEspBots         = false
local ActiveAutoWin         = false
local ActiveAutoFarmMoney   = false
local InReviving            = false
local AutoFarmSummerEvent   = false
local ActiveEspSummerEvent  = false
local InTickets             = false
local ActiveDistanceEsp     = false
local ActiveJumpBoost       = false

local AutoJumpEnabled       = false
local AutoBhopActive        = false

local AntiAFKLoaded         = false

local V = "V.0.16"

----------------------------------------------------
--                 HÀM ESP GỐC
----------------------------------------------------

local function CreateEsp(Char, Color, Text, Parent, OffsetY)
    if not Char or not Parent then return end
    if Char:FindFirstChild("ESP_Highlight") and Parent:FindFirstChild("ESP") then return end

    -- Highlight
    local highlight = Char:FindFirstChild("ESP_Highlight") or Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    -- Billboard
    local billboard = Parent:FindFirstChild("ESP") or Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, OffsetY or 0, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    -- Label
    local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    -- Cập nhật distance
    task.spawn(function()
        while highlight.Parent and billboard.Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                if ActiveDistanceEsp then
                    label.Text = string.format("%s (%.0f m)", Text, distance)
                else
                    label.Text = Text
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function KeepEsp(Char, Parent)
    if Char and Char:FindFirstChildOfClass("Highlight") then
        Char:FindFirstChildOfClass("Highlight"):Destroy()
    end
    if Parent and Parent:FindFirstChildOfClass("BillboardGui") then
        Parent:FindFirstChildOfClass("BillboardGui"):Destroy()
    end
end

local function GetDownedPlayer()
    local gameFolder = Workspace:FindFirstChild("Game")
    if not gameFolder then return nil end

    local plrsFolder = gameFolder:FindFirstChild("Players")
    if not plrsFolder then return nil end

    for _, v in pairs(plrsFolder:GetChildren()) do
        if v:GetAttribute("Downed") then
            return v
        end
    end
    return nil
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("setclipboard is not supported in this environment.")
    end
end

----------------------------------------------------
--          UI FARM / SAFE (WINDUI)
----------------------------------------------------

-- TOGGLE COLLECT ITEMS
FarmSection:Toggle({
    Title = "Collect Items (Tickets)",
    Desc  = "Auto ăn Tickets dưới map Event",
    Icon  = "sparkles",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.Items = state
        print("Items:", state)
        if state then
            Items()
        end
    end,
})

-- TOGGLE AVOID NEXTBOT
FarmSection:Toggle({
    Title = "Avoid Nextbot",
    Desc  = "Tự TP né bot trong phạm vi ~30m",
    Icon  = "shield-alert",
    Type  = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.Avoid = state
        print("Avoid:", state)
        if state then
            Avoid()
        end
    end,
})

----------------------------------------------------
--          UI GAME TAB (AUTO FARM XP / MONEY / EVENT)
----------------------------------------------------

-- Auto Farm XP (Auto Win)
GameSection:Toggle({
    Title = "Auto Farm XP (Auto Win)",
    Desc  = "Đưa bạn lên trên trời để tránh chết và ăn XP cuối vòng",
    Icon  = "trophy",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveAutoWin = Value
        task.spawn(function()
            while ActiveAutoWin do
                task.wait(0.1)
                if Game.Players.LocalPlayer.Character
                    and Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    and (not InReviving or not Game.Players.LocalPlayer.Character:GetAttribute("Downed")) then

                    local securityPart = Workspace:FindFirstChild("SecurityPart") or Instance.new("Part")
                    securityPart.Name = "SecurityPart"
                    securityPart.Size = Vector3.new(10, 1, 10)
                    securityPart.Position = Vector3.new(0, 500, 0)
                    securityPart.Anchored = true
                    securityPart.Parent = Workspace

                    Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        securityPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.5)
                    if securityPart and securityPart.Parent then
                        securityPart:Destroy()
                    end
                end
            end
        end)
    end,
})

-- Auto Farm Money (Revive người downed)
GameSection:Toggle({
    Title = "Auto Farm Money (Revive)",
    Desc  = "Tự tìm người bị downed để revive lấy tiền",
    Icon  = "dollar-sign",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveAutoFarmMoney = Value
        task.spawn(function()
            while ActiveAutoFarmMoney do
                task.wait(0.1)
                if Game.Players.LocalPlayer.Character
                    and Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    and not Game.Players.LocalPlayer.Character:GetAttribute("Downed") then

                    local downedPlayer = GetDownedPlayer()
                    if downedPlayer and downedPlayer:FindFirstChild("HumanoidRootPart") then
                        InReviving = true
                        Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                            downedPlayer.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)

                        local rep = Game:GetService("ReplicatedStorage")
                        local eventsFolder = rep:FindFirstChild("Events")
                        if eventsFolder and eventsFolder:FindFirstChild("Character")
                            and eventsFolder.Character:FindFirstChild("Interact") then

                            eventsFolder.Character.Interact:FireServer("Revive", true, downedPlayer)
                        end
                        wait(0.5)
                        InReviving = false
                    end
                end
            end
        end)
    end,
})

-- Auto Farm Winter Holiday Event (Tickets)
GameSection:Toggle({
    Title = "Auto Farm Winter Holiday Event",
    Desc  = "TP liên tục tới Tickets (Event)",
    Icon  = "snowflake",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        AutoFarmSummerEvent = Value
        task.spawn(function()
            while AutoFarmSummerEvent do
                task.wait(0.1)
                local effects = Workspace:FindFirstChild("Game")
                    and Workspace.Game:FindFirstChild("Effects")
                    and Workspace.Game.Effects:FindFirstChild("Tickets")

                if effects then
                    for _, Assets in pairs(effects:GetChildren()) do
                        if Assets
                            and Assets.PrimaryPart
                            and Assets.Name == "Visual"
                            and Game.Players.LocalPlayer.Character
                            and Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            and (not InReviving or not Game.Players.LocalPlayer.Character:GetAttribute("Downed")) then

                            Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                Assets.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end
        end)
    end,
})

-- Anti AFK (Button)
GameSection:Button({
    Title = "Anti AFK",
    Desc  = "Bật Anti AFK (chỉ chạy 1 lần)",
    Callback = function()
        if AntiAFKLoaded then
            WindUI:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK đã được bật trước đó!",
                Duration = 3,
                Icon = "alarm-clock",
            })
            return
        end

        AntiAFKLoaded = true

        local Success, Result = pcall(function()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk",
                true
            ))()
        end)

        if Success then
            WindUI:Notify({
                Title = "Anti AFK",
                Content = "Anti AFK Enabled ✅",
                Duration = 3,
                Icon = "alarm-clock",
            })
        else
            warn("Anti AFK Error:", Result)
            WindUI:Notify({
                Title = "Anti AFK",
                Content = "Không thể bật Anti AFK ❌",
                Duration = 3,
                Icon = "alarm-clock-off",
            })
        end
    end,
})

----------------------------------------------------
--          UI PLAYER TAB (SPEED / JUMP / BHOP)
----------------------------------------------------

-- SPEED SLIDER
local ValueSpeed = 16
PlayerSection:Slider({
    Title = "Player Speed",
    Desc  = "Chỉnh WalkSpeed nhân vật",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 16,
    },
    Callback = function(Value)
        ValueSpeed = Value
    end,
})

-- SPEED TOGGLE
PlayerSection:Toggle({
    Title = "Enable Speed Boost",
    Desc  = "Giữ WalkSpeed theo slider",
    Icon  = "run",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveSpeedBoost = Value
        task.spawn(function()
            while ActiveSpeedBoost do
                task.wait(0.1)
                local char = Game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").WalkSpeed = ValueSpeed
                end
            end
        end)
    end,
})

-- JumpPower
local DefaultJumpPower = 50
local ValueJump = DefaultJumpPower

PlayerSection:Slider({
    Title = "Player JumpPower",
    Desc  = "Độ cao khi nhảy",
    Step = 1,
    Value = {
        Min = 0,
        Max = 200,
        Default = DefaultJumpPower,
    },
    Callback = function(Value)
        ValueJump = Value
    end,
})

PlayerSection:Toggle({
    Title = "Enable JumpPower Boost",
    Desc  = "Giữ JumpPower theo slider",
    Icon  = "arrow-up",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveJumpBoost = Value
        task.spawn(function()
            while ActiveJumpBoost do
                task.wait(0.1)
                local char = Game.Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = ValueJump
                end
            end

            -- tắt -> trả về mặc định
            local char = Game.Players.LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid and not ActiveJumpBoost then
                humanoid.JumpPower = DefaultJumpPower
                humanoid.UseJumpPower = false
            end
        end)
    end,
})

----------------------------------------------------
--          AUTO BHOP UI (PC + MOBILE)
----------------------------------------------------

local player = Game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BhopUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 300, 0, 50)
TextLabel.Position = UDim2.new(0.5, -150, 0.1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Auto BHop: OFF"
TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.TextStrokeTransparency = 0
TextLabel.TextSize = 36
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Visible = false
TextLabel.Parent = ScreenGui

local function updateBhopUI()
    TextLabel.Text = "Auto BHop: " .. (AutoBhopActive and "ON" or "OFF")
    TextLabel.TextColor3 = AutoBhopActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

-- Drag UI
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart
local startPos

TextLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = TextLabel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TextLabel.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        TextLabel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        TextLabel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local function setBhopUIVisible(state)
    ScreenGui.Enabled = state
    TextLabel.Visible = state
end

-- Auto jump logic
RunService.RenderStepped:Connect(function()
    if AutoJumpEnabled and AutoBhopActive then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- PC: phím B toggle trong UI
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.B and AutoJumpEnabled then
        AutoBhopActive = not AutoBhopActive
        updateBhopUI()
    end
end)

-- Mobile: ấn trực tiếp vào UI
TextLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        if AutoJumpEnabled then
            AutoBhopActive = not AutoBhopActive
            updateBhopUI()
        end
    end
end)

-- Toggle trong Player tab
PlayerSection:Toggle({
    Title = "Auto BHop UI (PC: nhấn B trên UI)",
    Desc  = "Hiện UI BHop, bật/tắt tự nhảy",
    Icon  = "mouse-pointer-click",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        AutoJumpEnabled = Value
        setBhopUIVisible(Value)
        AutoBhopActive = false
        updateBhopUI()
    end,
})

----------------------------------------------------
--          UI ESP TAB (PLAYER / BOTS / TICKETS)
----------------------------------------------------

ESPSection:Toggle({
    Title = "Players ESP",
    Desc  = "Highlight người chơi khác",
    Icon  = "users",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveEspPlayers = Value

        task.spawn(function()
            while ActiveEspPlayers do
                task.wait(0.1)
                local gameFolder = Workspace:FindFirstChild("Game")
                if not gameFolder then continue end

                for _, pl in pairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character then
                        local head = pl.Character:FindFirstChild("Head")
                        if head
                            and not pl.Character:FindFirstChildOfClass("Highlight")
                            and not head:FindFirstChildOfClass("BillboardGui") then

                            CreateEsp(pl.Character, Color3.fromRGB(255, 255, 255), pl.Name, head, 1)
                        end
                    end
                end
            end

            -- tắt -> clear ESP
            for _, pl in pairs(Players:GetPlayers()) do
                if pl.Character and pl.Character:FindFirstChild("Head") then
                    KeepEsp(pl.Character, pl.Character.Head)
                end
            end
        end)
    end,
})

ESPSection:Toggle({
    Title = "Bots ESP",
    Desc  = "Highlight Nextbot (Hitbox đỏ)",
    Icon  = "alert-octagon",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveEspBots = Value

        task.spawn(function()
            while ActiveEspBots do
                task.wait(0.1)
                local gameFolder = Workspace:FindFirstChild("Game")
                if not gameFolder then continue end

                local plrsFolder = gameFolder:FindFirstChild("Players")
                if not plrsFolder then continue end

                for _, Assets in pairs(plrsFolder:GetChildren()) do
                    if Assets and Assets:FindFirstChild("Hitbox")
                        and not Assets:FindFirstChildOfClass("Highlight")
                        and not Assets.Hitbox:FindFirstChildOfClass("BillboardGui") then

                        Assets.Hitbox.Transparency = 0
                        CreateEsp(Assets, Color3.fromRGB(255, 0, 0), Assets.Name, Assets.Hitbox, -2)
                    end
                end
            end

            -- tắt ESP bots -> clear
            local gameFolder = Workspace:FindFirstChild("Game")
            if not gameFolder then return end
            local plrsFolder = gameFolder:FindFirstChild("Players")
            if not plrsFolder then return end

            for _, Assets in pairs(plrsFolder:GetChildren()) do
                if Assets and Assets:FindFirstChild("Hitbox") then
                    Assets.Hitbox.Transparency = 1
                    KeepEsp(Assets, Assets.Hitbox)
                end
            end
        end)
    end,
})

ESPSection:Toggle({
    Title = "Tickets Event ESP",
    Desc  = "Highlight Tickets Event",
    Icon  = "ticket",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveEspSummerEvent = Value

        task.spawn(function()
            while ActiveEspSummerEvent do
                task.wait(0.1)
                local effects = Workspace:FindFirstChild("Game")
                    and Workspace.Game:FindFirstChild("Effects")
                    and Workspace.Game.Effects:FindFirstChild("Tickets")

                if not effects then continue end

                for _, Assets in pairs(effects:GetChildren()) do
                    if Assets and Assets.PrimaryPart and Assets.Name == "Visual"
                        and not Assets:FindFirstChildOfClass("Highlight")
                        and not Assets.PrimaryPart:FindFirstChildOfClass("BillboardGui") then

                        CreateEsp(Assets, Color3.fromRGB(0, 255, 255), "Tickets", Assets.PrimaryPart, -2)
                    end
                end
            end

            -- tắt ESP -> clear
            local effects = Workspace:FindFirstChild("Game")
                and Workspace.Game:FindFirstChild("Effects")
                and Workspace.Game.Effects:FindFirstChild("Tickets")

            if not effects then return end

            for _, Assets in pairs(effects:GetChildren()) do
                if Assets and Assets.PrimaryPart and Assets.Name == "Visual" then
                    KeepEsp(Assets, Assets.PrimaryPart)
                end
            end
        end)
    end,
})

----------------------------------------------------
--          INFO TAB (VERSION + SERVER INFO + DISCORD)
----------------------------------------------------

-- Thông báo version
WindUI:Notify({
    Title = "Script Version!",
    Content = V,
    Duration = 7.5,
    Icon = "badge-check",
})

InfoSection:Paragraph({
    Title = "ZMatrix Evade",
    Desc  = "Version: " .. V .. "\nAuthor: GM1nhRBL / ZMatrix",
    Image = "badge-check",
    ImageSize = 24,
    Color = Color3.fromHex("#315dff"),
})

-- Server Info Paragraph (cập nhật mỗi giây)
local ServerInfoParagraph = InfoSection:Paragraph({
    Title = "Info Server",
    Desc  = "Loading...",
    Image = "server",
    ImageSize = 24,
    Color = Color3.fromHex("#30ff6a"),
})

local function getServerInfo()
    local playerCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers
    local isStudio = game:GetService("RunService"):IsStudio()

    return {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        IsStudio = isStudio,
        CurrentPlayers = playerCount,
        MaxPlayers = maxPlayers,
    }
end

task.spawn(function()
    while true do
        task.wait(1)
        local updatedInfo = getServerInfo()
        local updatedContent = string.format(
            "📌 PlaceId: %s\n🔑 JobId: %s\n🧪 Studio: %s\n👥 Players: %d/%d\n📺 YT: GM1nhRBL",
            tostring(updatedInfo.PlaceId),
            tostring(updatedInfo.JobId),
            tostring(updatedInfo.IsStudio),
            updatedInfo.CurrentPlayers,
            updatedInfo.MaxPlayers
        )
        ServerInfoParagraph:SetDesc(updatedContent)
    end
end)

-- Nút copy Discord
InfoSection:Button({
    Title = "Copy Discord Link",
    Desc  = "Copy Discord ZMatrix vào clipboard",
    Callback = function()
        copyToClipboard("https://discord.gg/9Md7ExK6DD")
        WindUI:Notify({
            Title = "Discord",
            Content = "Đã copy link Discord vào clipboard!",
            Duration = 3,
            Icon = "copy",
        })
    end,
})

----------------------------------------------------
--          SETTINGS TAB (DISTANCE ESP + UNLOAD)
----------------------------------------------------

SettingsSection:Toggle({
    Title = "Show Distance in ESP",
    Desc  = "Hiện khoảng cách (m) trên ESP",
    Icon  = "ruler",
    Type  = "Checkbox",
    Value = false,
    Callback = function(Value)
        ActiveDistanceEsp = Value
    end,
})

SettingsSection:Button({
    Title = "Unload Cheat",
    Desc  = "Tắt toàn bộ loop & phá UI ZMatrix Evade",
    Callback = function()
        -- Tắt tất cả flag
        _G.Items              = false
        _G.Avoid              = false
        ActiveSpeedBoost      = false
        ActiveEspPlayers      = false
        ActiveEspBots         = false
        ActiveAutoWin         = false
        ActiveAutoFarmMoney   = false
        AutoFarmSummerEvent   = false
        ActiveEspSummerEvent  = false
        ActiveDistanceEsp     = false
        ActiveJumpBoost       = false
        AutoJumpEnabled       = false
        AutoBhopActive        = false

        -- Ẩn BHop UI
        pcall(function()
            ScreenGui.Enabled = false
        end)

        -- Destroy Window
        pcall(function()
            if Window and Window.Destroy then
                Window:Destroy()
            end
        end)

        WindUI:Notify({
            Title = "Unload",
            Content = "Đã Unload ZMatrix Evade.",
            Duration = 3,
            Icon = "trash-2",
        })
    end,
})