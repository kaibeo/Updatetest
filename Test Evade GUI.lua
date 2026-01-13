--// XOÁ UI CŨ (NẾU CÓ)
if getgenv and getgenv().ZMatrix_Evade_Main and typeof(getgenv().ZMatrix_Evade_Main) == "table" then
    pcall(function()
        if getgenv().ZMatrix_Evade_Main.Destroy then
            getgenv().ZMatrix_Evade_Main:Destroy()
        end
    end)
end

--// LOAD UiBanana GỐC
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kaibeo/Updatetest/refs/heads/main/UiBanana%20G%E1%BB%91c.lua"))()
local Main = Library.CreateMain({
    Desc = ""  -- Ui tự ghi title rồi, để trống
})

if getgenv then
    getgenv().ZMatrix_Evade_Main = Main
end

----------------------------------------------------
--              TẠO PAGE / SECTION
----------------------------------------------------

local PageGame     = Main.CreatePage({ Page_Name = "Game",     Page_Title = "Game / Farm" })
local PagePlayer   = Main.CreatePage({ Page_Name = "Player",   Page_Title = "Player" })
local PageESP      = Main.CreatePage({ Page_Name = "ESP",      Page_Title = "ESP" })
local PageInfo     = Main.CreatePage({ Page_Name = "Info",     Page_Title = "Info" })
local PageSettings = Main.CreatePage({ Page_Name = "Settings", Page_Title = "Settings" })

local GameSection     = PageGame.CreateSection("Evade (EVENT) - ZMatrix")
local PlayerSection   = PagePlayer.CreateSection("Player Settings")
local ESPSection      = PageESP.CreateSection("ESP Settings")
local InfoSection     = PageInfo.CreateSection("Information")
local SettingsSection = PageSettings.CreateSection("Settings")

----------------------------------------------------
--                LOGIC SCRIPT CŨ (TORA)
----------------------------------------------------

-- Xoá UI Tora cũ nếu có
if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
    game:GetService("CoreGui").ToraScript:Destroy()
end

_G.Avoid = false

-- AVOID NEXTBOT
local function Avoid()
    task.spawn(function()
        _G.Avoid = true
        local PlayersService = game:GetService("Players")
        local LocalPlayer = PlayersService.LocalPlayer

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

    local billboard = Parent:FindFirstChild("ESP") or Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, OffsetY or 0, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

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
    local success, result = pcall(function()
        local gameFolder = Workspace:FindFirstChild("Game")
        if not gameFolder then return nil end

        local plrsFolder = gameFolder:FindFirstChild("Players")
        if not plrsFolder then return nil end

        for _, v in pairs(plrsFolder:GetChildren()) do
            local isDown =
                v:GetAttribute("Downed") == true
                or v:GetAttribute("Down") == true

            if isDown then
                return v
            end
        end

        return nil
    end)

    if not success then
        warn("[ZMatrix AutoMoney] GetDownedPlayer error:", result)
        return nil
    end

    return result
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("setclipboard is not supported in this environment.")
    end
end

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

RunService.RenderStepped:Connect(function()
    if AutoJumpEnabled and AutoBhopActive then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.B and AutoJumpEnabled then
        AutoBhopActive = not AutoBhopActive
        updateBhopUI()
    end
end)

TextLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        if AutoJumpEnabled then
            AutoBhopActive = not AutoBhopActive
            updateBhopUI()
        end
    end
end)

----------------------------------------------------
--          GAME TAB (AVOID + AUTO FARM + ANTI AFK)
----------------------------------------------------

GameSection.CreateToggle({
    Title = "Avoid Nextbot",
    Desc  = "Tự TP né bot trong phạm vi ~30m",
    Default = false
}, function(state)
    _G.Avoid = state
    print("Avoid:", state)
    if state then
        Avoid()
    end
end)

GameSection.CreateToggle({
    Title = "Auto Farm XP (Auto Win)",
    Desc  = "Đưa bạn lên trên trời để tránh chết và ăn XP cuối vòng",
    Default = false
}, function(Value)
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
end)

GameSection.CreateToggle({
    Title = "Auto Farm Money (Revive)",
    Desc  = "Tự tìm người bị downed để revive lấy tiền",
    Default = false
}, function(Value)
    ActiveAutoFarmMoney = Value

    task.spawn(function()
        while ActiveAutoFarmMoney do
            task.wait(0.15)

            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")

            local myModelInGame = Workspace:FindFirstChild("Game")
                and Workspace.Game:FindFirstChild("Players")
                and Workspace.Game.Players:FindFirstChild(LocalPlayer.Name)

            local imDown = myModelInGame and (
                myModelInGame:GetAttribute("Downed") == true
                or myModelInGame:GetAttribute("Down") == true
            )

            if not hrp or imDown or InReviving then
                -- skip
            else
                local downedPlayer = GetDownedPlayer()
                if downedPlayer and downedPlayer:FindFirstChild("HumanoidRootPart") then
                    InReviving = true

                    print("[ZMatrix AutoMoney] Found downed:", downedPlayer.Name)

                    hrp.CFrame = downedPlayer.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)

                    local rep = game:GetService("ReplicatedStorage")
                    local eventsFolder = rep:FindFirstChild("Events")
                    local charFolder   = eventsFolder and eventsFolder:FindFirstChild("Character")
                    local interact     = charFolder and charFolder:FindFirstChild("Interact")

                    if interact then
                        interact:FireServer("Revive", true, downedPlayer)
                    else
                        warn("[ZMatrix AutoMoney] Không tìm thấy Events.Character.Interact")
                    end

                    task.wait(0.6)
                    InReviving = false
                end
            end
        end
    end)
end)

GameSection.CreateToggle({
    Title = "Auto Farm Winter Holiday Event",
    Desc  = "TP liên tục tới Tickets (Event)",
    Default = false
}, function(Value)
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
end)

GameSection.CreateButton({
    Title = "Anti AFK",
    Desc  = "Bật Anti AFK (chỉ chạy 1 lần)"
}, function()
    local StarterGui = game:GetService("StarterGui")

    if AntiAFKLoaded then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Anti AFK",
                Text = "Anti AFK đã được bật trước đó!",
                Duration = 3
            })
        end)
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
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Anti AFK",
                Text = "Anti AFK Enabled ✅",
                Duration = 3
            })
        end)
    else
        warn("Anti AFK Error:", Result)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Anti AFK",
                Text = "Không thể bật Anti AFK ❌",
                Duration = 3
            })
        end)
    end
end)

----------------------------------------------------
--          UI PLAYER TAB (SPEED / JUMP / BHOP)
----------------------------------------------------

local ValueSpeed = 16

PlayerSection.CreateSlider({
    Title = "Player Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Precise = true
}, function(Value)
    ValueSpeed = Value
end)

PlayerSection.CreateToggle({
    Title = "Enable Speed Boost",
    Desc  = "Giữ WalkSpeed theo slider",
    Default = false
}, function(Value)
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
end)

local DefaultJumpPower = 50
local ValueJump = DefaultJumpPower

PlayerSection.CreateSlider({
    Title = "Player JumpPower",
    Min = 0,
    Max = 200,
    Default = DefaultJumpPower,
    Precise = true
}, function(Value)
    ValueJump = Value
end)

PlayerSection.CreateToggle({
    Title = "Enable JumpPower Boost",
    Desc  = "Giữ JumpPower theo slider",
    Default = false
}, function(Value)
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

        local char = Game.Players.LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and not ActiveJumpBoost then
            humanoid.JumpPower = DefaultJumpPower
            humanoid.UseJumpPower = false
        end
    end)
end)

PlayerSection.CreateToggle({
    Title = "Auto BHop UI (PC: nhấn B)",
    Desc  = "Hiện UI BHop, bật/tắt tự nhảy",
    Default = false
}, function(Value)
    AutoJumpEnabled = Value
    setBhopUIVisible(Value)
    AutoBhopActive = false
    updateBhopUI()
end)

----------------------------------------------------
--          UI ESP TAB (PLAYER / BOTS / TICKETS)
----------------------------------------------------

ESPSection.CreateToggle({
    Title = "Players ESP",
    Desc  = "Highlight người chơi khác",
    Default = false
}, function(Value)
    ActiveEspPlayers = Value

    task.spawn(function()
        while ActiveEspPlayers do
            task.wait(0.1)
            local gameFolder = Workspace:FindFirstChild("Game")
            if gameFolder then
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
        end

        for _, pl in pairs(Players:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("Head") then
                KeepEsp(pl.Character, pl.Character.Head)
            end
        end
    end)
end)

ESPSection.CreateToggle({
    Title = "Bots ESP",
    Desc  = "Highlight Nextbot (Hitbox đỏ)",
    Default = false
}, function(Value)
    ActiveEspBots = Value

    task.spawn(function()
        while ActiveEspBots do
            task.wait(0.1)
            local gameFolder = Workspace:FindFirstChild("Game")
            if gameFolder then
                local plrsFolder = gameFolder:FindFirstChild("Players")
                if plrsFolder then
                    for _, Assets in pairs(plrsFolder:GetChildren()) do
                        if Assets and Assets:FindFirstChild("Hitbox")
                            and not Assets:FindFirstChildOfClass("Highlight")
                            and not Assets.Hitbox:FindFirstChildOfClass("BillboardGui") then

                            Assets.Hitbox.Transparency = 0
                            CreateEsp(Assets, Color3.fromRGB(255, 0, 0), Assets.Name, Assets.Hitbox, -2)
                        end
                    end
                end
            end
        end

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
end)

ESPSection.CreateToggle({
    Title = "Tickets Event ESP",
    Desc  = "Highlight Tickets Event",
    Default = false
}, function(Value)
    ActiveEspSummerEvent = Value

    task.spawn(function()
        while ActiveEspSummerEvent do
            task.wait(0.1)
            local effects = Workspace:FindFirstChild("Game")
                and Workspace.Game:FindFirstChild("Effects")
                and Workspace.Game.Effects:FindFirstChild("Tickets")

            if effects then
                for _, Assets in pairs(effects:GetChildren()) do
                    if Assets and Assets.PrimaryPart and Assets.Name == "Visual"
                        and not Assets:FindFirstChildOfClass("Highlight")
                        and not Assets.PrimaryPart:FindFirstChildOfClass("BillboardGui") then

                        CreateEsp(Assets, Color3.fromRGB(0, 255, 255), "Tickets", Assets.PrimaryPart, -2)
                    end
                end
            end
        end

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
end)

----------------------------------------------------
--          INFO TAB (VERSION + SERVER INFO + DISCORD)
----------------------------------------------------

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

local info = getServerInfo()
local infoText = string.format(
    "Version: %s\nAuthor: GM1nhRBL / ZMatrix\nFeatures: Avoid Nextbot, Auto Farm XP/Money, ESP, Anti AFK, BHop...\n\n📌 PlaceId: %s\n🔑 JobId: %s\n🧪 Studio: %s\n👥 Players: %d/%d",
    V,
    tostring(info.PlaceId),
    tostring(info.JobId),
    tostring(info.IsStudio),
    info.CurrentPlayers,
    info.MaxPlayers
)

InfoSection.CreateLabel({
    Title = infoText
})

InfoSection.CreateButton({
    Title = "Copy Discord Link",
    Desc  = "Copy Discord ZMatrix vào clipboard"
}, function()
    local StarterGui = game:GetService("StarterGui")
    copyToClipboard("https://discord.gg/9Md7ExK6DD")
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Discord",
            Text = "Đã copy link Discord vào clipboard!",
            Duration = 3
        })
    end)
end)

----------------------------------------------------
--          SETTINGS TAB (DISTANCE ESP + UNLOAD)
----------------------------------------------------

SettingsSection.CreateToggle({
    Title = "Show Distance in ESP",
    Desc  = "Hiện khoảng cách (m) trên ESP",
    Default = false
}, function(Value)
    ActiveDistanceEsp = Value
end)

SettingsSection.CreateButton({
    Title = "Unload Cheat",
    Desc  = "Tắt toàn bộ loop & phá UI ZMatrix Evade"
}, function()
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

    pcall(function()
        ScreenGui.Enabled = false
    end)

    pcall(function()
        if Main and Main.Destroy then
            Main:Destroy()
        end
    end)

    local StarterGui = game:GetService("StarterGui")
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Unload",
            Text = "Đã Unload ZMatrix Evade.",
            Duration = 3
        })
    end)
end)
