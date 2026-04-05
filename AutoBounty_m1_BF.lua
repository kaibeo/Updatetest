-- ============================================================
-- BLOX FRUIT - FAST ATTACK + LOCK AIM + AUTO PIRATE TEAM
-- ✅ Lock tầm nhìn vào target (camera + rootpart)
-- ✅ Tự chọn team Hải Tặc khi vào game
-- ✅ Fast Attack gốc giữ nguyên
-- ============================================================

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Workspace           = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService    = game:GetService("UserInputService")

local Player  = Players.LocalPlayer
local Camera  = Workspace.CurrentCamera

-- ══════════════════════════════════════════
--   GIỮ NGUYÊN PHẦN GỐC
-- ══════════════════════════════════════════
local Modules         = ReplicatedStorage:WaitForChild("Modules")
local Net             = Modules:WaitForChild("Net")
local RegisterAttack  = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit     = Net:WaitForChild("RE/RegisterHit")
local ShootGunEvent   = Net:WaitForChild("RE/ShootGunEvent")
local GunValidator    = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Validator2")

local Config = {
    AttackDistance   = 70,
    AttackMobs       = true,
    AttackPlayers    = true,
    AttackCooldown   = 0,
    ComboResetTime   = 0.1,
    MaxCombo         = 10,
    HitboxLimbs      = {"RightLowerArm","RightUpperArm","LeftLowerArm","LeftUpperArm","RightHand","LeftHand"},
    AutoClickEnabled = true,
}

local FastAttack = {}
FastAttack.__index = FastAttack

function FastAttack.new()
    local self = setmetatable({
        Debounce      = 0,
        ComboDebounce = 0,
        ShootDebounce = 0,
        M1Combo       = 0,
        EnemyRootPart = nil,
        Connections   = {},
        Overheat = {
            Dragonstorm = {MaxOverheat=3, Cooldown=0, TotalOverheat=0, Distance=350, Shooting=false}
        },
        ShootsPerTarget = {["Dual Flintlock"] = 2},
        SpecialShoots   = {
            ["Skull Guitar"] = "TAP",
            ["Bazooka"]      = "Position",
            ["Cannon"]       = "Position",
            ["Dragonstorm"]  = "Overheat",
        },
    }, FastAttack)
    pcall(function()
        self.CombatFlags   = require(Modules.Flags).COMBAT_REMOTE_THREAD
        self.ShootFunction = getupvalue(require(ReplicatedStorage.Controllers.CombatController).Attack, 9)
        local LocalScript  = Player:WaitForChild("PlayerScripts"):FindFirstChildOfClass("LocalScript")
        if LocalScript and getsenv then
            self.HitFunction = getsenv(LocalScript)._G.SendHitsToServer
        end
    end)
    return self
end

function FastAttack:IsEntityAlive(entity)
    local h = entity and entity:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

function FastAttack:CheckStun(Character, Humanoid, ToolTip)
    local Stun = Character:FindFirstChild("Stun")
    local Busy = Character:FindFirstChild("Busy")
    if Humanoid.Sit and (ToolTip=="Sword" or ToolTip=="Melee" or ToolTip=="Blox Fruit") then
        return false
    elseif Stun and Stun.Value > 0 or Busy and Busy.Value then
        return false
    end
    return true
end

function FastAttack:GetBladeHits(Character, Distance)
    local Position  = Character:GetPivot().Position
    local BladeHits = {}
    Distance = Distance or Config.AttackDistance
    local function ProcessTargets(Folder)
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy ~= Character and self:IsEntityAlive(Enemy) then
                local BasePart = Enemy:FindFirstChild(Config.HitboxLimbs[math.random(#Config.HitboxLimbs)])
                    or Enemy:FindFirstChild("HumanoidRootPart")
                if BasePart and (Position - BasePart.Position).Magnitude <= Distance then
                    if not self.EnemyRootPart then
                        self.EnemyRootPart = BasePart
                    else
                        table.insert(BladeHits, {Enemy, BasePart})
                    end
                end
            end
        end
    end
    if Config.AttackMobs    then ProcessTargets(Workspace.Enemies)    end
    if Config.AttackPlayers then ProcessTargets(Workspace.Characters) end
    return BladeHits
end

function FastAttack:GetClosestEnemy(Character, Distance)
    local BladeHits = self:GetBladeHits(Character, Distance)
    local Closest, MinDis = nil, math.huge
    for _, Hit in ipairs(BladeHits) do
        local Mag = (Character:GetPivot().Position - Hit[2].Position).Magnitude
        if Mag < MinDis then MinDis = Mag; Closest = Hit[2] end
    end
    return Closest
end

function FastAttack:GetCombo()
    local Combo = (tick()-self.ComboDebounce) <= Config.ComboResetTime and self.M1Combo or 0
    Combo = Combo >= Config.MaxCombo and 1 or Combo + 1
    self.ComboDebounce = tick()
    self.M1Combo = Combo
    return Combo
end

function FastAttack:ShootInTarget(TargetPosition)
    local Character = Player.Character
    if not self:IsEntityAlive(Character) then return end
    local Equipped = Character:FindFirstChildOfClass("Tool")
    if not Equipped or Equipped.ToolTip ~= "Gun" then return end
    local Cooldown  = Equipped:FindFirstChild("Cooldown") and Equipped.Cooldown.Value or 0.3
    if (tick()-self.ShootDebounce) < Cooldown then return end
    local ShootType = self.SpecialShoots[Equipped.Name] or "Normal"
    if ShootType == "Position" or (ShootType == "TAP" and Equipped:FindFirstChild("RemoteEvent")) then
        Equipped:SetAttribute("LocalTotalShots", (Equipped:GetAttribute("LocalTotalShots") or 0)+1)
        GunValidator:FireServer(self:GetValidator2())
        if ShootType == "TAP" then
            Equipped.RemoteEvent:FireServer("TAP", TargetPosition)
        else
            ShootGunEvent:FireServer(TargetPosition)
        end
        self.ShootDebounce = tick()
    else
        VirtualInputManager:SendMouseButtonEvent(0,0,0,true,  game,1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0,0,0,false, game,1)
        self.ShootDebounce = tick()
    end
end

function FastAttack:GetValidator2()
    local v1=getupvalue(self.ShootFunction,15)
    local v2=getupvalue(self.ShootFunction,13)
    local v3=getupvalue(self.ShootFunction,16)
    local v4=getupvalue(self.ShootFunction,17)
    local v5=getupvalue(self.ShootFunction,14)
    local v6=getupvalue(self.ShootFunction,12)
    local v7=getupvalue(self.ShootFunction,18)
    local v8=v6*v2
    local v9=(v5*v2+v6*v1)%v3
    v9=(v9*v3+v8)%v4
    v5=math.floor(v9/v3)
    v6=v9-v5*v3
    v7=v7+1
    setupvalue(self.ShootFunction,15,v1)
    setupvalue(self.ShootFunction,13,v2)
    setupvalue(self.ShootFunction,16,v3)
    setupvalue(self.ShootFunction,17,v4)
    setupvalue(self.ShootFunction,14,v5)
    setupvalue(self.ShootFunction,12,v6)
    setupvalue(self.ShootFunction,18,v7)
    return math.floor(v9/v4*16777215), v7
end

function FastAttack:UseNormalClick(Character, Humanoid, Cooldown)
    self.EnemyRootPart = nil
    local BladeHits = self:GetBladeHits(Character)
    if self.EnemyRootPart then
        RegisterAttack:FireServer(Cooldown)
        if self.CombatFlags and self.HitFunction then
            self.HitFunction(self.EnemyRootPart, BladeHits)
        else
            RegisterHit:FireServer(self.EnemyRootPart, BladeHits)
        end
    end
end

function FastAttack:UseFruitM1(Character, Equipped, Combo)
    local Targets = self:GetBladeHits(Character)
    if not Targets[1] then return end
    local Direction = (Targets[1][2].Position - Character:GetPivot().Position).Unit
    Equipped.LeftClickRemote:FireServer(Direction, Combo)
end

function FastAttack:Attack()
    if not Config.AutoClickEnabled or (tick()-self.Debounce) < Config.AttackCooldown then return end
    local Character = Player.Character
    if not Character or not self:IsEntityAlive(Character) then return end
    local Humanoid  = Character.Humanoid
    local Equipped  = Character:FindFirstChildOfClass("Tool")
    if not Equipped then return end
    local ToolTip   = Equipped.ToolTip
    if not table.find({"Melee","Blox Fruit","Sword","Gun"}, ToolTip) then return end
    local Cooldown  = Equipped:FindFirstChild("Cooldown") and Equipped.Cooldown.Value or Config.AttackCooldown
    if not self:CheckStun(Character, Humanoid, ToolTip) then return end
    local Combo     = self:GetCombo()
    Cooldown = Cooldown + (Combo >= Config.MaxCombo and 0.05 or 0)
    self.Debounce = Combo >= Config.MaxCombo and ToolTip ~= "Gun" and (tick()+0.05) or tick()
    if ToolTip == "Blox Fruit" and Equipped:FindFirstChild("LeftClickRemote") then
        self:UseFruitM1(Character, Equipped, Combo)
    elseif ToolTip == "Gun" then
        local Target = self:GetClosestEnemy(Character, 120)
        if Target then self:ShootInTarget(Target.Position) end
    else
        self:UseNormalClick(Character, Humanoid, Cooldown)
    end
end

local AttackInstance = FastAttack.new()
table.insert(AttackInstance.Connections, RunService.Stepped:Connect(function()
    AttackInstance:Attack()
end))

-- Hook attack functions
pcall(function()
    for _, v in pairs(getgc(true)) do
        if typeof(v)=="function" and iscclosure(v) then
            local name = debug.getinfo(v).name
            if name=="Attack" or name=="attack" or name=="RegisterHit" then
                hookfunction(v, function(...)
                    AttackInstance:Attack()
                    return v(...)
                end)
            end
        end
    end
end)

-- Funcs legacy
local Register_Hit    = Net:WaitForChild("RE/RegisterHit")
local Register_Attack = Net:WaitForChild("RE/RegisterAttack")
local Funcs = {}

local function GetAllBladeHits()
    local bladehits = {}
    for _, v in pairs(Workspace.Enemies:GetChildren()) do
        local hum = v:FindFirstChildOfClass("Humanoid")
        if hum and v:FindFirstChild("HumanoidRootPart") and hum.Health > 0
           and (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 65 then
            table.insert(bladehits, v)
        end
    end
    return bladehits
end

local function Getplayerhit()
    local bladehits = {}
    for _, v in pairs(Workspace.Characters:GetChildren()) do
        local hum = v:FindFirstChildOfClass("Humanoid")
        if v.Name ~= Player.Name and hum and v:FindFirstChild("HumanoidRootPart") and hum.Health > 0
           and (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 65 then
            table.insert(bladehits, v)
        end
    end
    return bladehits
end

function Funcs:Attack()
    local bladehits = {}
    for _, v in pairs(GetAllBladeHits()) do table.insert(bladehits, v) end
    for _, v in pairs(Getplayerhit())   do table.insert(bladehits, v) end
    if #bladehits == 0 then return end
    local args = {[1]=nil, [2]={}, [4]="078da341"}
    for r, v in pairs(bladehits) do
        Register_Attack:FireServer(0)
        if not args[1] then args[1] = v.Head end
        args[2][r] = {[1]=v, [2]=v.HumanoidRootPart}
    end
    Register_Hit:FireServer(unpack(args))
end

-- ══════════════════════════════════════════
--   ✅ MỚI: AUTO CHỌN TEAM HẢI TẶC
-- ══════════════════════════════════════════
local function selectPirateTeam()
    task.spawn(function()
        -- Chờ GUI load
        task.wait(3)

        local function trySelect()
            -- Tìm qua PlayerGui
            for _, gui in pairs(Player.PlayerGui:GetDescendants()) do
                local name = gui.Name:lower()
                -- Tìm button chứa chữ "pirate" hoặc "hải tặc"
                if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                    if name:find("pirate") or name:find("hai tac")
                       or name:find("haĩ tặc") or (gui:IsA("TextButton") and gui.Text:lower():find("pirate")) then
                        gui.MouseButton1Click:Fire()
                        print("[BF] ✅ Đã chọn team Hải Tặc!")
                        return true
                    end
                end
            end

            -- Tìm qua Remote Event chọn team
            local teamRemotes = {
                "ChooseTeam", "SelectTeam", "SetTeam",
                "JoinTeam",   "TeamSelect", "PickTeam",
            }
            for _, rName in pairs(teamRemotes) do
                local r = ReplicatedStorage:FindFirstChild(rName, true)
                if r and r:IsA("RemoteEvent") then
                    -- Thử fire với "Pirates" hoặc số team
                    pcall(function() r:FireServer("Pirates") end)
                    pcall(function() r:FireServer(1) end)
                    print("[BF] ✅ Fired team remote: "..rName)
                    return true
                end
            end

            return false
        end

        -- Thử nhiều lần
        for i = 1, 5 do
            if trySelect() then break end
            task.wait(2)
        end
    end)
end

-- Gọi chọn team ngay khi load
selectPirateTeam()

-- Gọi lại khi respawn
Player.CharacterAdded:Connect(function()
    task.wait(2)
    selectPirateTeam()
end)

-- ══════════════════════════════════════════
--   ✅ MỚI: LOCK TẦM NHÌN VÀO TARGET
-- ══════════════════════════════════════════
local LockState = {
    enabled  = false,
    target   = nil,    -- Model của enemy/player
    targetHP = nil,
}

-- Tìm enemy/player gần nhất để lock
local function findLockTarget()
    local char = Player.Character
    if not char then return nil end
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local best, bestDist = nil, math.huge

    -- Tìm trong Enemies
    pcall(function()
        for _, v in pairs(Workspace.Enemies:GetChildren()) do
            local hum  = v:FindFirstChildOfClass("Humanoid")
            local root = v:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                local d = (hrp.Position - root.Position).Magnitude
                if d < bestDist and d <= Config.AttackDistance * 2 then
                    bestDist = d; best = v
                end
            end
        end
    end)

    -- Tìm trong Characters (players)
    pcall(function()
        for _, v in pairs(Workspace.Characters:GetChildren()) do
            if v.Name == Player.Name then continue end
            local hum  = v:FindFirstChildOfClass("Humanoid")
            local root = v:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                local d = (hrp.Position - root.Position).Magnitude
                if d < bestDist and d <= Config.AttackDistance * 2 then
                    bestDist = d; best = v
                end
            end
        end
    end)

    return best
end

-- Lock camera + rootpart nhìn vào target
RunService.RenderStepped:Connect(function()
    if not LockState.enabled or not LockState.target then return end

    local char = Player.Character
    if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Kiểm tra target còn sống
    local hum = LockState.target:FindFirstChildOfClass("Humanoid")
    local targetRoot = LockState.target:FindFirstChild("HumanoidRootPart")

    if not hum or hum.Health <= 0 or not targetRoot then
        -- Target chết → tìm target mới
        LockState.target = findLockTarget()
        return
    end

    local targetPos = targetRoot.Position

    -- ✅ Lock Camera nhìn vào target
    pcall(function()
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end)

    -- ✅ Lock RootPart quay về phía target (để attack đúng hướng)
    pcall(function()
        local lookDir = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
        hrp.CFrame    = CFrame.new(hrp.Position, lookDir)
    end)
end)

-- Toggle lock bằng phím Q
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        LockState.enabled = not LockState.enabled
        if LockState.enabled then
            LockState.target = findLockTarget()
            if LockState.target then
                print("[BF] 🔒 Lock ON → "..LockState.target.Name)
            else
                print("[BF] 🔒 Lock ON - Không tìm thấy target gần")
            end
        else
            LockState.target = nil
            Camera.CameraType = Enum.CameraType.Custom
            print("[BF] 🔓 Lock OFF")
        end
    end

    -- Phím E để đổi target khi đang lock
    if input.KeyCode == Enum.KeyCode.E and LockState.enabled then
        local old = LockState.target
        LockState.target = findLockTarget()
        if LockState.target and LockState.target ~= old then
            print("[BF] 🔄 Đổi lock → "..LockState.target.Name)
        end
    end
end)

-- ══════════════════════════════════════════
--                  GUI
-- ══════════════════════════════════════════
local old = Player.PlayerGui:FindFirstChild("BFAttackGUI")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "BFAttackGUI"; sg.ResetOnSpawn = false; sg.Parent = Player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,250,0,200)
frame.Position = UDim2.new(0,15,0,15)
frame.BackgroundColor3 = Color3.fromRGB(10,10,20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true; frame.Draggable = true; frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
local st = Instance.new("UIStroke", frame)
st.Color = Color3.fromRGB(255,120,0); st.Thickness = 2

local tf = Instance.new("Frame")
tf.Size = UDim2.new(1,0,0,32)
tf.BackgroundColor3 = Color3.fromRGB(200,80,0)
tf.BorderSizePixel = 0; tf.Parent = frame
Instance.new("UICorner", tf).CornerRadius = UDim.new(0,12)
local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1
tl.TextColor3 = Color3.new(1,1,1)
tl.Text = "🌊  BLOX FRUIT FAST ATTACK"
tl.TextScaled = true; tl.Font = Enum.Font.GothamBold; tl.Parent = tf

local function mkL(y, c)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,22); l.Position = UDim2.new(0,5,0,y)
    l.BackgroundTransparency = 1; l.TextColor3 = c or Color3.new(1,1,1)
    l.TextScaled = true; l.Font = Enum.Font.Gotham; l.Parent = frame; return l
end

local lLock  = mkL(38,  Color3.fromRGB(255,210,80))
local lTeam  = mkL(62,  Color3.fromRGB(150,220,255))
local lAtk   = mkL(86,  Color3.fromRGB(180,255,180))
local lKey   = mkL(110, Color3.fromRGB(200,200,200))

lLock.Text = "🔓 Lock: TẮT  |  Target: --"
lTeam.Text = "🏴‍☠️ Team: Đang chọn Hải Tặc..."
lAtk.Text  = "⚔️ Fast Attack: BẬT"
lKey.Text  = "🎮 Q = Lock/Unlock  |  E = Đổi target"

-- Nút toggle Lock
local function mkB(text, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,34); b.Position = UDim2.new(0,5,0,y)
    b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1)
    b.Text = text; b.TextScaled = true; b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0; b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8); return b
end

local lockBtn = mkB("🔓  Lock Tầm Nhìn: TẮT", 140, Color3.fromRGB(60,60,120))
local teamBtn = mkB("🏴‍☠️  Chọn Hải Tặc",       180, Color3.fromRGB(150,30,30))

lockBtn.MouseButton1Click:Connect(function()
    LockState.enabled = not LockState.enabled
    if LockState.enabled then
        LockState.target  = findLockTarget()
        lockBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
        lockBtn.Text = "🔒  Lock Tầm Nhìn: BẬT"
    else
        LockState.target  = nil
        Camera.CameraType = Enum.CameraType.Custom
        lockBtn.BackgroundColor3 = Color3.fromRGB(60,60,120)
        lockBtn.Text = "🔓  Lock Tầm Nhìn: TẮT"
    end
end)

teamBtn.MouseButton1Click:Connect(function()
    lTeam.Text = "🏴‍☠️ Đang chọn Hải Tặc..."
    selectPirateTeam()
end)

-- Update UI
task.spawn(function()
    while true do
        task.wait(0.4)
        pcall(function()
            if LockState.enabled and LockState.target then
                local hum = LockState.target:FindFirstChildOfClass("Humanoid")
                local hp  = hum and math.floor(hum.Health) or 0
                lLock.Text = "🔒 Lock: BẬT  |  "..LockState.target.Name.." HP:"..hp
                lLock.TextColor3 = Color3.fromRGB(100,255,100)
            else
                lLock.Text = "🔓 Lock: TẮT  |  Target: --"
                lLock.TextColor3 = Color3.fromRGB(255,210,80)
            end
        end)
    end
end)

print("╔══════════════════════════════════════╗")
print("║  BLOX FRUIT FAST ATTACK              ║")
print("║  Lock tầm nhìn [Q]            ✅    ║")
print("║  Đổi target khi lock [E]      ✅    ║")
print("║  Auto chọn Hải Tặc            ✅    ║")
print("║  Fast Attack giữ nguyên       ✅    ║")
print("╚══════════════════════════════════════╝")
