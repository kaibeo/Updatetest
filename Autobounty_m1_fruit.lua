-- Cài đặt team và khởi tạo biến
getgenv().team = "Pirates" -- Pirates

-- Đợi game tải hoàn chỉnh
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- Tự động chọn team với phương pháp đáng tin cậy hơn
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        wait()
        local l_Remotes_0 = game.ReplicatedStorage:WaitForChild("Remotes")
        l_Remotes_0.CommF_:InvokeServer("SetTeam", getgenv().team)
        task.wait(3)
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end

-- Tiếp tục đợi GUI chính tải
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")

-- >>> TẢI CUTTAY UI <
-- Tải UI trước khi khởi tạo auto bounty
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/diemquy/testhub/refs/heads/main/autobountyui.lua"))()

-- Khởi tạo cài đặt cơ bản nếu chưa tồn tại
if not getgenv().Setting then
    getgenv().Setting = {
        ["YOU"] = {
            ["Team"] = getgenv().team or "Pirates",
        },
        ["Webhook"] = {
            ["Enabled"] = true,
            ["Url"] = ""
        },
        ["Chat"] = {
            ["Enabled"] = false,
            ["List"] = {""},
        }
    }
end

if not getgenv().Setting.Click then
    getgenv().Setting.Click = {
        ["FastClick"] = true,
        ["AlwaysClick"] = true
    }
end

if not getgenv().Setting.Hunt then
    getgenv().Setting.Hunt = {
        ["Min"] = 0,
        ["Max"] = 30000000
    }
end

if not getgenv().Setting.Skip then
    getgenv().Setting.Skip = {
        ["V4"] = true,
        ["Fruit"] = false,
        ["FruitList"] = {"Buddha", "Leopard", "T-Rex"},
        ["SafeZone"] = true,
        ["NoHaki"] = true,
        ["NoPvP"] = true
    }
end

if not getgenv().Setting.SafeHealth then
    getgenv().Setting.SafeHealth = {
        ["Health"] = 7000,
        ["Mask"] = false,
        ["MaskType"] = "Mask",
        ["RaceV4"] = false
    }
end

if not getgenv().Setting.Another then
    getgenv().Setting.Another = {
        ["V3"] = true,
        ["V4"] = true,
        ["CustomHealth"] = true,
        ["Health"] = 7000,
        ["WhiteScreen"] = false,
        ["FPSBoots"] = true,
        ["LockCamera"] = false,
        ["AutoServerHop"] = true,
        ["HopWhenNoBounty"] = true,
        ["BountyLock"] = false,
        ["BountyLockAt"] = 30000000,
        ["ServerHopAfterTime"] = false,
        ["ServerHopTime"] = 900,
        ["CheckCombatBeforeHop"] = true,
        ["MaxPlayersInServer"] = 8
    }
end

if not getgenv().Setting.Gun then
    getgenv().Setting.Gun = {
        ["Enable"] = false,
        ["GunMode"] = false,
        ["Delay"] = 0.1
    }
end

if not getgenv().Setting.Melee then
    getgenv().Setting.Melee = {
        ["Enable"] = false,
        ["Delay"] = 0.1
    }
end

if not getgenv().Setting.Sword then
    getgenv().Setting.Sword = {
        ["Enable"] = false,
        ["Delay"] = 0.1
    }
end

if not getgenv().Setting.Fruit then
    getgenv().Setting.Fruit = {
        ["Enable"] = false,
        ["Delay"] = 0.1
    }
end


getgenv().weapon = nil
getgenv().targ = nil
getgenv().lasttarrget = nil
getgenv().checked = {}
getgenv().pl = game.Players:GetPlayers()
getgenv().killed = nil
_G.Earned = 0  -- Số tiền kiếm được hiện tại
_G.TotalEarn = 0  -- Tổng số tiền kiếm được
_G.Time = 0  -- Thời gian hoạt động

-- Định nghĩa thế giới và cấu hình đảo
local World1, World2, World3 = false, false, false

if game.PlaceId == 7449423635 then
    World3 = true
else
    game.Players.LocalPlayer:Kick("Chỉ hỗ trợ BF Sea 3")
    return
end 

-- Cấu hình đảo dựa trên thế giới
local distbyp, island
if World3 then 
    distbyp = 5000
    island = {
        ["Port Town"] = CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375),
        ["Hydra Island"] = CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531),
        ["Mansion"] = CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375),
        ["Castle On The Sea"] = CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375),
        ["Haunted Island"] = CFrame.new(-9547.5703125, 141.0137481689453, 5535.16162109375),
        ["Great Tree"] = CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625),
        ["Candy Island"] = CFrame.new(-1106.076416015625, 13.016114234924316, -14231.9990234375),
        ["Cake Island"] = CFrame.new(-1903.6856689453125, 36.70722579956055, -11857.265625),
        ["Loaf Island"] = CFrame.new(-889.8325805664062, 64.72842407226562, -10895.8876953125),
        ["Peanut Island"] = CFrame.new(-1943.59716796875, 37.012996673583984, -10288.01171875),
        ["Cocoa Island"] = CFrame.new(147.35205078125, 23.642955780029297, -12030.5498046875),
        ["Tiki Outpost"] = CFrame.new(-16234,9,416)
    } 
elseif World2 then 
    distbyp = 3500
    island = { 
        a = CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938),
        b = CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094),
        c = CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375),
        d = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344),
        e = CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828), 
        f = CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875),
        g = CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188),
        h = CFrame.new(923.40197753906, 125.05712890625, 32885.875),
        i = CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125),
    }
elseif World1 then 
    distbyp = 1500
    island = { 
        a = CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594), 
        b = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156), 
        c = CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688), 
        d = CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969), 
        e = CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754), 
        f = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094),
        g = CFrame.new(-4607.82275, 872.54248, -1667.55688), 
        h = CFrame.new(-7952.31006, 5545.52832, -320.704956),
        i = CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313),
        j = CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969),
        k = CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469),
        l = CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813),
        m = CFrame.new(61163.8515625, 11.6796875, 1819.7841796875),
        n = CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875),
        o = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656),
        p = CFrame.new(-4813.0249, 903.708557, -1912.69055),
        q = CFrame.new(-4970.21875, 717.707275, -2622.35449),
    } 
end

-- Định nghĩa biến cục bộ
local p = game.Players
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local hb = rs.Heartbeat
local rends = rs.RenderStepped
local webhook = {} 

-- === CÁC HÀM TIỆN ÍCH ===
-- Hàm vượt qua chướng ngại
function bypass(Pos)   
    if not lp.Character:FindFirstChild("Head") or not lp.Character:FindFirstChild("HumanoidRootPart") or not lp.Character:FindFirstChild("Humanoid") then
        return
    end
    
    local dist = math.huge
    local is = nil
    
    for i, v in pairs(island) do
        if (Pos.Position-v.Position).magnitude < dist then
            is = v 
            dist = (Pos.Position-v.Position).magnitude 
        end
    end 
    
    if is == nil then return end
    
    if lp:DistanceFromCharacter(Pos.Position) > distbyp then 
        if (lp.Character.Head.Position-Pos.Position).magnitude > (is.Position-Pos.Position).magnitude then
            if tween then
                pcall(function() tween:Destroy() end)
            end
            
            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or 
               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or 
               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or 
               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                
                if tween then
                   pcall(function() tween:Cancel() end)
                end
                
                repeat task.wait()
                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        lp.Character.HumanoidRootPart.CFrame = is  
                    else
                        break
                    end
                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is   
                
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
            else
                if not stopbypass then
                    if tween then
                       pcall(function() tween:Cancel() end)
                    end
                    
                    repeat task.wait()
                        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            lp.Character.HumanoidRootPart.CFrame = is  
                        else
                            break
                        end
                    until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is  
                    
                    pcall(function()
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
                        lp.Character:SetPrimaryPartCFrame(is)
                        wait(0.1)
                        if lp.Character and lp.Character:FindFirstChild("Head") then
                            lp.Character.Head:Destroy()
                        end
                        wait(0.5)
                        
                        repeat task.wait()
                            if lp.Character and lp.Character:FindFirstChild("PrimaryPart") then
                                lp.Character.PrimaryPart.CFrame = is  
                            else
                                break
                            end
                        until lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0
                        
                        task.wait(0.5)
                    end)
                end 
            end
        end
    end
end

-- Hàm di chuyển (tween)
function to(Pos)
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health > 0 then
            local Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if not game.Players.LocalPlayer.Character.PrimaryPart:FindFirstChild("Hold") then
                local Hold = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.PrimaryPart)
                Hold.Name = "Hold"
                Hold.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                Hold.Velocity = Vector3.new(0, 0, 0)
            end
            
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
            
            local Speed
            if Distance <= 250 then
                if tween then tween:Cancel() end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
            elseif Distance < 1000 then
                Speed = 375
            elseif Distance >= 1000 then
                Speed = 350
            end


            
            pcall(function()
                tween = game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
                    {CFrame = Pos}
                )
                tween:Play()
            end)
            
            if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main") and 
               game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("InCombat") and
               game.Players.LocalPlayer.PlayerGui.Main.InCombat.Visible then
                if not string.find(string.lower(game.Players.LocalPlayer.PlayerGui.Main.InCombat.Text), "risk") then
                   
                else
                    local dist = math.huge
                    local is = nil
                    
                    for i, v in pairs(island) do
                        if (Pos.Position-v.Position).magnitude < dist then
                            is = v 
                            dist = (Pos.Position-v.Position).magnitude 
                        end
                    end 
                    
                    if is == nil then return end
                    
                    if lp:DistanceFromCharacter(Pos.Position) > distbyp then 
                        if (lp.Character.Head.Position-Pos.Position).magnitude > (is.Position-Pos.Position).magnitude then
                            if tween then
                                pcall(function() tween:Destroy() end)
                            end
                            
                            if (is.X == 61163.8515625 and is.Y == 11.6796875 and is.Z == 1819.7841796875) or 
                               is == CFrame.new(-12471.169921875 + 50, 374.94024658203, -7551.677734375) or 
                               is == CFrame.new(-5085.23681640625 + 50, 316.5072021484375, -3156.202880859375) or 
                               is == CFrame.new(5749.7861328125 + 50, 611.9736938476562, -276.2497863769531) then
                                
                                if tween then
                                   pcall(function() tween:Cancel() end)
                                end
                                
                                repeat task.wait()
                                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                        lp.Character.HumanoidRootPart.CFrame = is  
                                    else
                                        break
                                    end
                                until lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame == is   
                                
                                task.wait(0.1)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            end
                        end
                    end
                end
            else
                
            end
            
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
            
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, 
                    Pos.Y, 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            end
        end
    end)
end

-- Hàm nhấn phím
local function down(key)
    pcall(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):SetKeyDown(key)
        task.wait(0.1)
        game:GetService("VirtualUser"):SetKeyUp(key)
    end)
end

-- Hàm sử dụng Buso (Haki)
function buso()
    if lp.Character and not lp.Character:FindFirstChild("HasBuso") then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- Hàm sử dụng Ken (Observation Haki)
function Ken()
    if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and 
       game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") and 
       game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
        return true
    else
        game:service("VirtualUser"):CaptureController()
        game:service("VirtualUser"):SetKeyDown("0x65")
        game:service("VirtualUser"):SetKeyUp("0x65")
        return false
    end
end

-- Hàm equip tool
-- Auto Equip Fruit Tool
local player = game.Players.LocalPlayer

function equipFruit()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()

    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- Nhận diện fruit (tuỳ game có chữ "Fruit" hoặc tên trái)
            if string.find(tool.Name:lower(), "fruit") 
            or string.find(tool.Name:lower(), "kitsune") 
            or string.find(tool.Name:lower(), "t-rex") then
                
                tool.Parent = character
            end
        end
    end
end

-- Loop auto equip
task.spawn(function()
    while true do
        pcall(function()
            equipFruit()
        end)
        task.wait(1)
    end
end)
-- Hàm click
function Click()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,1,0,1))
end

-- === CHUẨN BỊ GAME ===
-- No Clip
spawn(function()
    while game:GetService("RunService").Stepped:wait() do
        pcall(function()
            if lp.Character then
                for _, v in pairs(lp.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Boots FPS
if getgenv().Setting.Another.FPSBoots then
    local removedecals = false
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and removedecals then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        end
    end
    
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
end

-- Loại bỏ đối tượng
function ObjectRemove()
    for i, v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name,"Tree") or string.find(v.Name,"House") then
            pcall(function() v:Destroy() end)
        end
    end
end

-- Đối tượng vô hình
function InvisibleObject()
    for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if (v:IsA("Part") or v:IsA("MeshPart") or v:IsA("BasePart")) and v.Transparency then
            v.Transp
