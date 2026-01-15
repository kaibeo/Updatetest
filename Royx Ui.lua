_G.Color = Color3.fromRGB(255, 204, 0) 
_G.imageLogo = "rbxassetid://136144254602856"

local DragonToro = {}
local UIConfig = {Bind = Enum.KeyCode.RightControl}

local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local length = 20
local randomString = ""

math.randomseed(os.time())
charTable = {}
for c in chars:gmatch "." do
    table.insert(charTable, c)
end
for i = 1, length do
    randomString = randomString .. charTable[math.random(1, #charTable)]
end

for i, v in pairs(game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):GetChildren()) do
    if v.ClassName == "ScreenGui" then
        for i1, v1 in pairs(v:GetChildren()) do
            if v1.Name == "Main" then
                do
                    local ui = v
                    if ui then
                        ui:Destroy()
                    end
                end
            end
        end
    end
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function CircleClick(button, x, y)
    local Circle = Instance.new("ImageLabel")
    Circle.Name = "Circle"
    Circle.Parent = button
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BackgroundTransparency = 1.000
    Circle.ZIndex = 20
    Circle.Image = "rbxassetid://266543268"
    Circle.ImageColor3 = Color3.fromRGB(211, 211, 211)
    Circle.ImageTransparency = 0.800
    Circle.Size = UDim2.new(0, 0, 0, 0)
    Circle.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
    Circle.AnchorPoint = Vector2.new(0.5, 0.5)	
    local Size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
    TweenService:Create(Circle, TweenInfo.new(0.5), {
        Size = UDim2.new(0, Size, 0, Size),ImageTransparency = 1}):Play()	
    spawn(function()
        wait(0.5)
        Circle:Destroy()
    end)
end

function dragify(Frame, object)
    dragToggle = nil
    dragSpeed = .25
    dragInput = nil
    dragStart = nil
    dragPos = nil
    function updateInput(input)
        Delta = input.Position - dragStart
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        game:GetService("TweenService"):Create(object, TweenInfo.new(dragSpeed), {Position = Position}):Play()
    end
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    dragToggle = false
                end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if (input == dragInput and dragToggle) then
            updateInput(input)
        end
    end)
end

local UI = Instance.new("ScreenGui")
UI.Name = randomString
UI.Parent = game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn then
    syn.protect_gui(UI)
end

local AllControls = {}
local AllSections = {}

function DragonToro:DragonToroo()
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Top = Instance.new("Frame")
    local TabHolder = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local TabContainer = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local Logo = Instance.new("ImageLabel")
    
    Main.Name = "Main"
    Main.Parent = UI
    Main.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 520, 0, 500)
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)

---ImageButton tui xoá
 
    Logo.Name = "Logo"
    Logo.Parent = Main
    Logo.Active = true
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.Position = UDim2.new(0, 33, 0, 28)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Image = _G.imageLogo
    
    local UiToggle_UiStroke1 = Instance.new("UIStroke")
    UiToggle_UiStroke1.Color = Color3.fromRGB(25,25,25)
    UiToggle_UiStroke1.Thickness = 2
    UiToggle_UiStroke1.Name = "UiToggle_UiStroke1"
    UiToggle_UiStroke1.Parent = Main
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main
    
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Top.BackgroundTransparency = 1.000
    Top.Position = UDim2.new(0.021956088, 0, 0.0133333337, 40)
    Top.Size = UDim2.new(0, 490, 0, 39)
    
    local SearchContainer = Instance.new("Frame")
    local UICorner_Search = Instance.new("UICorner")
    local UIStroke_Search = Instance.new("UIStroke")
    local SearchBox = Instance.new("TextBox")
    local SearchIcon = Instance.new("ImageLabel")
    
    SearchContainer.Name = "SearchContainer"
    SearchContainer.Parent = Top
    SearchContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SearchContainer.BackgroundTransparency = 0.300
    SearchContainer.Position = UDim2.new(0, 0, 0.2, 0)
    SearchContainer.Size = UDim2.new(0, 500, 0, 25)
    SearchContainer.ZIndex = 16
    
    UICorner_Search.CornerRadius = UDim.new(0, 6)
    UICorner_Search.Parent = SearchContainer
    
    UIStroke_Search.Thickness = 1
    UIStroke_Search.Color = Color3.fromRGB(60, 60, 60)
    UIStroke_Search.Parent = SearchContainer
    
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = SearchContainer
    SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.BackgroundTransparency = 1.000
    SearchBox.Position = UDim2.new(0, 24, 0, 0)
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.ZIndex = 16
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.PlaceholderText = "🔍 Search"
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
    SearchBox.TextSize = 11.000
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchContainer
    SearchIcon.AnchorPoint = Vector2.new(1, 0.5)
    SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.BackgroundTransparency = 1.000
    SearchIcon.Position = UDim2.new(0, 15, 0.5, 0)
    SearchIcon.Size = UDim2.new(0, 15, 0, 15)
    SearchIcon.ZIndex = 16
    SearchIcon.Image = "rbxassetid://10734943674"
    SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    SearchIcon.ImageRectOffset = Vector2.new(964, 324)
    SearchIcon.ImageRectSize = Vector2.new(36, 36)
    
    local DragFrames = {}
    local TopDragFrame = Instance.new("Frame")
    TopDragFrame.Name = "TopDragFrame"
    TopDragFrame.Parent = Main
    TopDragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopDragFrame.BackgroundTransparency = 1
    TopDragFrame.Position = UDim2.new(0, 0, 0, 0)
    TopDragFrame.Size = UDim2.new(1, 0, 0, 80)
    table.insert(DragFrames, TopDragFrame)
    
    local LeftDragFrame = Instance.new("Frame")
    LeftDragFrame.Name = "LeftDragFrame"
    LeftDragFrame.Parent = Main
    LeftDragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LeftDragFrame.BackgroundTransparency = 1
    LeftDragFrame.Position = UDim2.new(0, 0, 0, 0)
    LeftDragFrame.Size = UDim2.new(0, 20, 1, 0)
    table.insert(DragFrames, LeftDragFrame)
    
    local RightDragFrame = Instance.new("Frame")
    RightDragFrame.Name = "RightDragFrame"
    RightDragFrame.Parent = Main
    RightDragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RightDragFrame.BackgroundTransparency = 1
    RightDragFrame.Position = UDim2.new(1, -20, 0, 0)
    RightDragFrame.Size = UDim2.new(0, 20, 1, 0)
    table.insert(DragFrames, RightDragFrame)
    
    local BottomDragFrame = Instance.new("Frame")
    BottomDragFrame.Name = "BottomDragFrame"
    BottomDragFrame.Parent = Main
    BottomDragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BottomDragFrame.BackgroundTransparency = 1
    BottomDragFrame.Position = UDim2.new(0, 0, 1, -20)
    BottomDragFrame.Size = UDim2.new(1, 0, 0, 20)
    table.insert(DragFrames, BottomDragFrame)
    
    for _, frame in pairs(DragFrames) do
        dragify(frame, Main)
    end
    
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.BackgroundColor3 = Color3.fromRGB(25,25,25)
    TabHolder.Position = UDim2.new(0, 80, 0, 9)
    TabHolder.Size = UDim2.new(0, 412, 0, 38)
    
    UICorner_2.Parent = TabHolder
    
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = TabHolder
    TabContainer.Active = true
    TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabContainer.BackgroundTransparency = 1.000
    TabContainer.Size = UDim2.new(0, 430, 0, 38)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 3
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    
    UIListLayout.Parent = TabContainer
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    
    UIPadding.Parent = TabContainer
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 5)
    
    local LeftArrow = Instance.new("ImageButton")
    LeftArrow.Name = "Left"
    LeftArrow.Parent = Main
    LeftArrow.AnchorPoint = Vector2.new(0, 0.5)
    LeftArrow.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    LeftArrow.BackgroundTransparency = 1.000
    LeftArrow.BorderColor3 = Color3.fromRGB(0,0,0)
    LeftArrow.BorderSizePixel = 0
    LeftArrow.Position = UDim2.new(0, 55, 0, 28)
    LeftArrow.Size = UDim2.new(0, 30, 0, 30)
    LeftArrow.Image = "rbxassetid://13858688108"
    LeftArrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
    LeftArrow.ZIndex = 16
    
    local RightArrow = Instance.new("ImageButton")
    RightArrow.Name = "Right"
    RightArrow.Parent = Main
    RightArrow.AnchorPoint = Vector2.new(1, 0.5)
    RightArrow.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    RightArrow.BackgroundTransparency = 1.000
    RightArrow.BorderColor3 = Color3.fromRGB(0,0,0)
    RightArrow.BorderSizePixel = 0
    RightArrow.Position = UDim2.new(0, 515, 0, 28)
    RightArrow.Size = UDim2.new(0, 30, 0, 30)
    RightArrow.Image = "rbxassetid://13858691067"
    RightArrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
    RightArrow.ZIndex = 16
    
    LeftArrow.MouseEnter:Connect(function()
        TweenService:Create(LeftArrow, TweenInfo.new(0.2), {ImageColor3 = _G.Color}):Play()
    end)
    
    LeftArrow.MouseLeave:Connect(function()
        TweenService:Create(LeftArrow, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play() 
    end)
    
    RightArrow.MouseEnter:Connect(function()
        TweenService:Create(RightArrow, TweenInfo.new(0.2), {ImageColor3 = _G.Color}):Play()
    end)
    
    RightArrow.MouseLeave:Connect(function()
        TweenService:Create(RightArrow, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)
    
    local currentActiveTab = nil
    local allTabs = {}
    
    LeftArrow.MouseButton1Click:Connect(function()
        local tabs = {}
        for _, tab in pairs(TabContainer:GetChildren()) do
            if tab:IsA("TextButton") and tab.Name == "Tab" then
                table.insert(tabs, tab)
            end
        end    
        if #tabs == 0 then return end
        
        local currentIndex = 1
        for i, tab in ipairs(tabs) do
            if tab == currentActiveTab then
                currentIndex = i
                break
            end
        end   
        
        local prevIndex = currentIndex - 1
        if prevIndex < 1 then
            prevIndex = #tabs
        end
        tabs[prevIndex].MouseButton1Click:Fire()
    end)
    
    RightArrow.MouseButton1Click:Connect(function()
        local tabs = {}
        for _, tab in pairs(TabContainer:GetChildren()) do
            if tab:IsA("TextButton") and tab.Name == "Tab" then
                table.insert(tabs, tab)
            end
        end    
        if #tabs == 0 then return end    
        
        local currentIndex = 1
        for i, tab in ipairs(tabs) do
            if tab == currentActiveTab then
                currentIndex = i
                break
            end
        end
        
        local nextIndex = currentIndex + 1
        if nextIndex > #tabs then
            nextIndex = 1
        end   
        tabs[nextIndex].MouseButton1Click:Fire()
    end)

    local Bottom = Instance.new("Frame")
    Bottom.Name = "Bottom"
    Bottom.Parent = Main
    Bottom.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Bottom.BackgroundTransparency = 1.000
    Bottom.Position = UDim2.new(0.0119760484, 7, 0.0916666687, 40)
    Bottom.Size = UDim2.new(0, 500, 0, 375)
    
    local function SearchControls(searchText)
        searchText = string.lower(searchText:gsub("%s+", ""))
        local foundAny = false		
        for _, control in pairs(AllControls) do
            if control and control.Parent then
                control.Visible = false
                local textLabel = control:FindFirstChild("TextLabel") or control:FindFirstChild("Text") or control:FindFirstChild("Sectionname")
                if textLabel then
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end		
        
        for _, control in pairs(AllControls) do
            if control and control.Parent then
                local textLabel = control:FindFirstChild("TextLabel") or control:FindFirstChild("Text") or control:FindFirstChild("Sectionname")
                if textLabel then
                    local controlText = string.lower(textLabel.Text:gsub("%s+", ""))
                    if string.find(controlText, searchText, 1, true) then
                        control.Visible = true
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                        foundAny = true						
                        local parentSection = control:FindFirstAncestorOfClass("Frame")
                        while parentSection do
                            if parentSection.Name == "Section" then
                                parentSection.Visible = true
                            end
                            parentSection = parentSection.Parent
                        end
                    end
                end
            end
        end		
        
        for _, section in pairs(AllSections) do
            if section and section.Parent then
                local hasVisibleControls = false
                for _, child in pairs(section:GetDescendants()) do
                    if child:IsA("Frame") and table.find(AllControls, child) then
                        if child.Visible then
                            hasVisibleControls = true
                            break
                        end
                    end
                end
                section.Visible = hasVisibleControls
            end
        end		
        
        if not foundAny and searchText ~= "" then
        end
    end
    
    local function ResetSearch()
        for _, control in pairs(AllControls) do
            if control then
                control.Visible = true
                local textLabel = control:FindFirstChild("TextLabel") or control:FindFirstChild("Text") or control:FindFirstChild("Sectionname")
                if textLabel then
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end		
        
        for _, section in pairs(AllSections) do
            if section then
                section.Visible = true
            end
        end
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchBox.Text
        if searchText == "" then
            ResetSearch()
        else
            SearchControls(searchText)
        end
    end)
    
    SearchBox.Focused:Connect(function()
        TweenService:Create(SearchContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        TweenService:Create(UIStroke_Search, TweenInfo.new(0.2), {Color = _G.Color}):Play()
    end)
    
    SearchBox.FocusLost:Connect(function()
        TweenService:Create(SearchContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        TweenService:Create(UIStroke_Search, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    local tabs = {}
    local S = false
    
    local function UpdateTabContainerSize()
        local totalWidth = 0
        for _, tab in pairs(TabContainer:GetChildren()) do
            if tab:IsA("TextButton") then
                totalWidth = totalWidth + tab.AbsoluteSize.X + 8
            end
        end
        TabContainer.CanvasSize = UDim2.new(0, totalWidth, 0, 0)
    end	
    
    function tabs:DragonTorooTab(Name)
        local Tab = Instance.new("TextButton")
        local UICorner_3 = Instance.new("UICorner")
        local TextLabel = Instance.new("TextLabel")
        
        Tab.Name = "Tab"
        Tab.Parent = TabContainer
        Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Tab.Size = UDim2.new(0, 0, 0, 28)
        Tab.BackgroundTransparency = 0
        Tab.Text = ""
        Tab.AutoButtonColor = false
        
        UICorner_3.CornerRadius = UDim.new(0, 4)
        UICorner_3.Parent = Tab
        
        TextLabel.Parent = Tab
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        TextLabel.Size = UDim2.new(0, 0, 0, 20)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = Name
        TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TextLabel.TextSize = 12.000
        TextLabel.TextTransparency = 0.200
        TextLabel.TextWrapped = false	
        
        local textService = game:GetService("TextService")
        local textSize = textService:GetTextSize(Name, 12, Enum.Font.GothamBold, Vector2.new(1000, 20))
        local textWidth = math.max(60, textSize.X + 20)		
        
        Tab.Size = UDim2.new(0, textWidth, 0, 28)
        TextLabel.Size = UDim2.new(0, textWidth - 4, 0, 26)
        
        local Page = Instance.new("ScrollingFrame")
        local Left = Instance.new("ScrollingFrame")
        local Right = Instance.new("ScrollingFrame")
        local UIListLayout_5 = Instance.new("UIListLayout")
        local UIPadding_5 = Instance.new("UIPadding")
        
        Page.Name = "Page"
        Page.Parent = Bottom
        Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Page.BackgroundTransparency = 1.000
        Page.Size = UDim2.new(0, 500, 0, 400)
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        
        Left.Name = "Left"
        Left.Parent = Page
        Left.Active = true
        Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Left.BackgroundTransparency = 1
        Left.Size = UDim2.new(0, 240, 0, 400)
        Left.ScrollBarThickness = 0
        Left.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        Right.Name = "Right"
        Right.Parent = Page
        Right.Active = true
        Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Right.BackgroundTransparency = 1
        Right.Size = UDim2.new(0, 240, 0, 400)
        Right.ScrollBarThickness = 0
        Right.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local LeftList = Instance.new("UIListLayout")
        local RightList = Instance.new("UIListLayout")
        
        LeftList.Parent = Left
        LeftList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftList.Padding = UDim.new(0, 5)
        
        RightList.Parent = Right
        RightList.SortOrder = Enum.SortOrder.LayoutOrder
        RightList.Padding = UDim.new(0, 5)
        
        UIListLayout_5.Parent = Page
        UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_5.Padding = UDim.new(0, 13)
        
        UIPadding_5.Parent = Page
        
        if S == false then
            S = true
            Page.Visible = true
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextTransparency = 0
            Tab.BackgroundColor3 = _G.Color
            currentActiveTab = Tab
        end
        
        Tab.MouseButton1Click:Connect(function()
            for _, x in next, TabContainer:GetChildren() do
                if x.Name == "Tab" then
                    TweenService:Create(x, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                    TweenService:Create(x.TextLabel, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                    TweenService:Create(x.TextLabel, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.2}):Play()
                    
                    for index, y in next, Bottom:GetChildren() do
                        if y:IsA("ScrollingFrame") then
                            y.Visible = false
                        end
                    end
                end
            end
            
            TweenService:Create(TextLabel, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TextLabel, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            TweenService:Create(Tab, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = _G.Color}):Play()
            
            Page.Visible = true
            currentActiveTab = Tab
        end)
        
        local function GetType(value)
            if value == "Left" then
                return Left
            elseif value == "Right" then
                return Right
            else
                return Left
            end
        end
        
        game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
                Right.CanvasSize = UDim2.new(0,0,0,RightList.AbsoluteContentSize.Y + 5)
                Left.CanvasSize = UDim2.new(0,0,0,LeftList.AbsoluteContentSize.Y + 5)
            end)
        end)
        
        UpdateTabContainerSize()
        
        local sections = {}
        
        function sections:DragonTorooSection(Name,side)
            if side == nil then
                return Left
            end
            
            local Section = Instance.new("Frame")
            local UICorner_5 = Instance.new("UICorner")
            local Top_2 = Instance.new("Frame")
            local Line = Instance.new("Frame")
            local Sectionname = Instance.new("TextLabel")
            local SectionContainer = Instance.new("Frame")
            local UIListLayout_2 = Instance.new("UIListLayout")
            local UIPadding_2 = Instance.new("UIPadding")
            
            Section.Name = "Section"
            Section.Parent = GetType(side)
            Section.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Section.ClipsDescendants = true
            Section.Size = UDim2.new(0, 240, 0, 280)
            
            UICorner_5.CornerRadius = UDim.new(0, 5)
            UICorner_5.Parent = Section
            
            Top_2.Name = "Top"
            Top_2.Parent = Section
            Top_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Top_2.BackgroundTransparency = 1.000
            Top_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Top_2.Size = UDim2.new(0, 238, 0, 31)
            
            Line.Name = "Line"
            Line.Parent = Top_2
            Line.BackgroundColor3 = _G.Color
            Line.BorderSizePixel = 0
            Line.Size = UDim2.new(0, 239, 0, 1)
            
            Sectionname.Name = "Sectionname"
            Sectionname.Parent = Top_2
            Sectionname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sectionname.BackgroundTransparency = 1.000
            Sectionname.Position = UDim2.new(0.0591227226, 0, 0.0222222228, 0)
            Sectionname.Size = UDim2.new(0, 224, 0, 24)
            Sectionname.Font = Enum.Font.GothamBold
            Sectionname.Text = Name
            Sectionname.TextColor3 = Color3.fromRGB(255, 255, 255)
            Sectionname.TextSize = 14.000
            Sectionname.TextTransparency = 0.300
            Sectionname.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionContainer.Name = "SectionContainer"
            SectionContainer.Parent = Top_2
            SectionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionContainer.BackgroundTransparency = 1.000
            SectionContainer.BorderSizePixel = 0
            SectionContainer.Position = UDim2.new(0, 0, 0.796416223, 0)
            SectionContainer.Size = UDim2.new(0, 239, 0, 255)
            
            UIListLayout_2.Parent = SectionContainer
            UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_2.Padding = UDim.new(0, 5)
            
            UIPadding_2.Parent = SectionContainer
            UIPadding_2.PaddingLeft = UDim.new(0, 5)
            
            UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 35)
            end)
            
            table.insert(AllSections, Section)
            
            local functionitem = {}
            
            function functionitem:DragonTorooLabel(text)
                local textas = {}
                local Label = Instance.new("Frame")
                local Text = Instance.new("TextLabel")
                
                Label.Name = "Label"
                Label.Parent = SectionContainer
                Label.AnchorPoint = Vector2.new(0.5, 0.5)
                Label.BackgroundTransparency = 1.000
                Label.Size = UDim2.new(0.975000024, 0, 0, 30)
                
                Text.Name = "Text"
                Text.Parent = Label
                Text.AnchorPoint = Vector2.new(0.5, 0.5)
                Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text.BackgroundTransparency = 1.000
                Text.Position = UDim2.new(0.5, 0, 0.5, 0)
                Text.Size = UDim2.new(0, 53, 0, 12)
                Text.ZIndex = 16
                Text.Font = Enum.Font.GothamBold
                Text.Text = text
                Text.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text.TextSize = 12.000
                
                function textas:Change(newtext)
                    Text.Text = newtext
                end
                
                table.insert(AllControls, Label)
                return textas
            end
            
            function functionitem:DragonTorooParagarp(text)
                local textas = {}
                local Label = Instance.new("Frame")
                local Text = Instance.new("TextLabel")
                
                Label.Name = "Label"
                Label.Parent = SectionContainer
                Label.AnchorPoint = Vector2.new(0.5, 0.5)
                Label.BackgroundTransparency = 1.000
                Label.Size = UDim2.new(0.975000024, 0, 0, 30)
                
                Text.Name = "Text"
                Text.Parent = Label
                Text.AnchorPoint = Vector2.new(0.5, 0.5)
                Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text.BackgroundTransparency = 1.000
                Text.Position = UDim2.new(0.5, 0, 0.5, 0)
                Text.Size = UDim2.new(0, 53, 0, 12)
                Text.ZIndex = 16
                Text.Font = Enum.Font.GothamBold
                Text.Text = text
                Text.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text.TextSize = 16
                
                function textas:Change(newtext)
                    Text.Text = newtext
                end
                
                table.insert(AllControls, Label)
                return textas
            end
            
            function functionitem:DragonTorooLabelColor(text,color)
                local textas = {}
                local Label = Instance.new("Frame")
                local Text = Instance.new("TextLabel")
                
                Label.Name = "Label"
                Label.Parent = SectionContainer
                Label.AnchorPoint = Vector2.new(0.5, 0.5)
                Label.BackgroundTransparency = 1.000
                Label.Size = UDim2.new(0.975000024, 0, 0, 30)
                
                Text.Name = "Text"
                Text.Parent = Label
                Text.AnchorPoint = Vector2.new(0.5, 0.5)
                Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text.BackgroundTransparency = 1.000
                Text.Position = UDim2.new(0.5, 0, 0.5, 0)
                Text.Size = UDim2.new(0, 53, 0, 12)
                Text.ZIndex = 16
                Text.Font = Enum.Font.GothamBold
                Text.Text = text
                Text.TextColor3 = color
                Text.TextSize = 12.000
                
                function textas:Change(newtext)
                    Text.Text = newtext
                end
                
                table.insert(AllControls, Label)
                return textas
            end

            function functionitem:DragonTorooButtonTog(Title, default, callback)
                local b3Func = {}
                local callback = callback or function() end
                local Tgs = default
                local Button_2 = Instance.new("Frame")
                local UICorner_21 = Instance.new("UICorner")
                local TextLabel_4 = Instance.new("TextLabel")
                local TextButton_4 = Instance.new("TextButton")
                
                Button_2.Name = "Button"
                Button_2.Parent = SectionContainer
                Button_2.BackgroundColor3 = Color3.fromRGB(33, 132, 112)
                Button_2.Size = UDim2.new(0.975000024, 0, 0, 25)
                Button_2.ZIndex = 16
                
                -- SỬA LỖI: Đảo ngược logic màu
                if default then
                    Button_2.BackgroundColor3 = _G.Color
                else
                    Button_2.BackgroundColor3 = Color3.fromRGB(33, 132, 112)
                end
                
                UICorner_21.CornerRadius = UDim.new(0, 4)
                UICorner_21.Parent = Button_2
                
                TextLabel_4.Parent = Button_2
                TextLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel_4.BackgroundTransparency = 1.000
                TextLabel_4.Position = UDim2.new(0.5, 0, 0.5, 0)
                TextLabel_4.Size = UDim2.new(0, 40, 0, 12)
                TextLabel_4.ZIndex = 16
                TextLabel_4.Font = Enum.Font.GothamBold
                TextLabel_4.Text = tostring(Title)
                TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel_4.TextSize = 12.000
                
                TextButton_4.Parent = Button_2
                TextButton_4.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TextButton_4.BackgroundTransparency = 1.000
                TextButton_4.BorderSizePixel = 0
                TextButton_4.ClipsDescendants = true
                TextButton_4.Size = UDim2.new(1, 0, 1, 0)
                TextButton_4.ZIndex = 16
                TextButton_4.AutoButtonColor = false
                TextButton_4.Font = Enum.Font.Gotham
                TextButton_4.Text = ""
                TextButton_4.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextButton_4.TextSize = 14.000
                
                TextButton_4.MouseButton1Click:Connect(function()
                    Tgs = not Tgs
                    b3Func:Update(Tgs)
                    CircleClick(Button_2, Mouse.X, Mouse.Y)
                end)
                
                if default then
                    TweenService:Create(
                        Button_2,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Tgs and _G.Color or Color3.fromRGB(33, 132, 112)}
                    ):Play()
                    callback(default)
                    Tgs = default
                end
                
                function b3Func:Update(state)
                    TweenService:Create(
                        Button_2,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = state and Color3.fromRGB(33, 132, 112) or _G.Color}
                    ):Play()
                    callback(state)
                    Tgs = state
                end
                
                table.insert(AllControls, Button_2)
                return b3Func
            end
            
            function functionitem:DragonTorooButton(Name, callback)
                local Button = Instance.new("Frame")
                local UICorner_6 = Instance.new("UICorner")
                local TextLabel_3 = Instance.new("TextLabel")
                local TextButton = Instance.new("TextButton")
                
                Button.Name = "Button"
                Button.Parent = SectionContainer
                Button.BackgroundColor3 = _G.Color
                Button.Size = UDim2.new(0.975000024, 0, 0, 25)
                Button.ZIndex = 16
                
                UICorner_6.CornerRadius = UDim.new(0, 4)
                UICorner_6.Parent = Button
                
                TextLabel_3.Parent = Button
                TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel_3.BackgroundTransparency = 1.000
                TextLabel_3.Position = UDim2.new(0.5, 0, 0.5, 0)
                TextLabel_3.Size = UDim2.new(0, 200, 0, 12)
                TextLabel_3.ZIndex = 16
                TextLabel_3.Font = Enum.Font.GothamBold
                TextLabel_3.Text = Name
                TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel_3.TextSize = 12.000
                
                TextButton.Parent = Button
                TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TextButton.BackgroundTransparency = 1.000
                TextButton.BorderSizePixel = 0
                TextButton.ClipsDescendants = true
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.ZIndex = 16
                TextButton.AutoButtonColor = false
                TextButton.Font = Enum.Font.Gotham
                TextButton.Text = ""
                TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextButton.TextSize = 14.000
                
                TextButton.MouseButton1Down:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(math.floor(_G.Color.R * 255 * 0.7), math.floor(_G.Color.G * 255 * 0.7), math.floor(_G.Color.B * 255 * 0.7))}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0.965000024, 0, 0, 23)}):Play()
                end)
                
                TextButton.MouseButton1Up:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = _G.Color}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0.975000024, 0, 0, 25)}):Play()
                end)
                
                TextButton.MouseButton1Click:Connect(function()
                    CircleClick(Button, Mouse.X, Mouse.Y)       
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(math.floor(_G.Color.R * 255 * 1.3), math.floor(_G.Color.G * 255 * 1.3), math.floor(_G.Color.B * 255 * 1.3))}):Play()        
                    wait(0.1)        
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = _G.Color}):Play()        
                    if callback then
                        callback()
                    end
                end)
                
                TextButton.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(math.floor(_G.Color.R * 255 * 1.1), math.floor(_G.Color.G * 255 * 1.1), math.floor(_G.Color.B * 255 * 1.1))}):Play()
                end)
                
                TextButton.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = _G.Color}):Play()
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0.975000024, 0, 0, 25)}):Play()
                end)
                
                table.insert(AllControls, Button)
            end

            function functionitem:DragonTorooToggle(Name, default, callback)
                local ToglFunc = {}
                local Tgo = default
                local MainToggle = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local Text = Instance.new("TextLabel")
                local MainToggle_2 = Instance.new("ImageLabel")
                local UICorner_2 = Instance.new("UICorner")
                local MainToggle_3 = Instance.new("ImageLabel")
                local UICorner_3 = Instance.new("UICorner")
                local TextButton = Instance.new("TextButton")
                
                MainToggle.Name = "MainToggle"
                MainToggle.Parent = SectionContainer
                MainToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                MainToggle.BackgroundTransparency = 0.700
                MainToggle.BorderSizePixel = 0
                MainToggle.ClipsDescendants = true
                MainToggle.Size = UDim2.new(0.975000024, 0, 0, 35)
                MainToggle.ZIndex = 16
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = MainToggle
                
                Text.Name = "Text"
                Text.Parent = MainToggle
                Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text.BackgroundTransparency = 1.000
                Text.Position = UDim2.new(0, 10, 0, 10)
                Text.Size = UDim2.new(0, 100, 0, 12)
                Text.ZIndex = 16
                Text.Font = Enum.Font.GothamBold
                Text.Text = Name
                Text.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text.TextSize = 12.000
                Text.TextTransparency = 0.4
                Text.TextXAlignment = Enum.TextXAlignment.Left
                
                MainToggle_2.Name = "MainToggle"
                MainToggle_2.Parent = MainToggle
                MainToggle_2.AnchorPoint = Vector2.new(0.5, 0.5)
                MainToggle_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                MainToggle_2.ClipsDescendants = true
                MainToggle_2.Position = UDim2.new(0.899999976, 0, 0.5, 0)
                MainToggle_2.Size = UDim2.new(0, 23, 0, 23)
                MainToggle_2.ZIndex = 16
                
                UICorner_2.CornerRadius = UDim.new(0, 3)
                UICorner_2.Parent = MainToggle_2
                
                MainToggle_3.Name = "MainToggle"
                MainToggle_3.Parent = MainToggle_2
                MainToggle_3.AnchorPoint = Vector2.new(0.5, 0.5)
                MainToggle_3.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                MainToggle_3.ClipsDescendants = true
                MainToggle_3.Position = UDim2.new(0.5, 0, 0.5, 0)
                MainToggle_3.Size = UDim2.new(0, 0, 0, 0)
                MainToggle_3.ZIndex = 16
                MainToggle_3.Image = "http://www.roblox.com/asset/?id=6031068421"
                MainToggle_3.ImageColor3 = _G.Color
                MainToggle_3.Visible = false
                
                UICorner_3.CornerRadius = UDim.new(0, 3)
                UICorner_3.Parent = MainToggle_3
                
                TextButton.Name = ""
                TextButton.Parent = MainToggle
                TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                TextButton.BackgroundTransparency = 1.000
                TextButton.BorderSizePixel = 0
                TextButton.Size = UDim2.new(1, 0, 1, 0)
                TextButton.ZIndex = 16
                TextButton.AutoButtonColor = false
                TextButton.Font = Enum.Font.Gotham
                TextButton.Text = ""
                TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextButton.TextSize = 14.000
                
                TextButton.MouseButton1Click:Connect(function()
                    Tgo = not Tgo
                    ToglFunc:Update(Tgo)
                    CircleClick(MainToggle, Mouse.X, Mouse.Y)
                end)
                
                if default then
                    -- SỬA LỖI: Xóa dòng if default then thừa
                    MainToggle_3.Visible = default
                    
                    TweenService:Create(Text,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = default and 0 or 0.4}):Play()
                    local we = TweenService:Create(MainToggle_3,TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{Size = default and UDim2.new(0, 25, 0, 25) or UDim2.new(0, 0, 0, 0)})
                    we:Play()
                    we.Completed:Wait()
                    if default == false then
                        MainToggle_3.Visible = default
                    end
                    callback(default)
                    Tgo = default
                end
                
                function ToglFunc:Update(state)
                    if state then
                        MainToggle_3.Visible = state
                    end
                    TweenService:Create(Text,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = state and 0 or 0.4}):Play()
                    local we = TweenService:Create(MainToggle_3,TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{Size = state and UDim2.new(0, 25, 0, 25) or UDim2.new(0, 0, 0, 0)})
                    we:Play()
                    we.Completed:Wait()
                    if state == false then
                        MainToggle_3.Visible = state
                    end
                    callback(state)
                    Tgo = state
                end
                
                table.insert(AllControls, MainToggle)
                return ToglFunc
            end
            
            function functionitem:DragonTorooTextbox(Name, Placeholder, callback)
                local Textbox = Instance.new("Frame")
                local UICorner_16 = Instance.new("UICorner")
                local Text_5 = Instance.new("TextLabel")
                local TextboxHoler = Instance.new("Frame")
                local UICorner_17 = Instance.new("UICorner")
                local HeadTitle = Instance.new("TextBox")    
                Textbox.Name = "Textbox"
                Textbox.Parent = SectionContainer
                Textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Textbox.BackgroundTransparency = 0.700
                Textbox.BorderSizePixel = 0
                Textbox.ClipsDescendants = true
                Textbox.Size = UDim2.new(0.975000024, 0, 0, 60)
                Textbox.ZIndex = 16    
                UICorner_16.CornerRadius = UDim.new(0, 4)
                UICorner_16.Parent = Textbox    
                Text_5.Name = "Text"
                Text_5.Parent = Textbox
                Text_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text_5.BackgroundTransparency = 1.000
                Text_5.Position = UDim2.new(0, 10, 0, 10)
                Text_5.Size = UDim2.new(0, 43, 0, 12)
                Text_5.ZIndex = 16
                Text_5.Font = Enum.Font.GothamBold
                Text_5.Text = Name
                Text_5.TextColor3 = _G.Color
                Text_5.TextSize = 11.000
                Text_5.TextXAlignment = Enum.TextXAlignment.Left
                TextboxHoler.Name = "TextboxHoler"
                TextboxHoler.Parent = Textbox
                TextboxHoler.AnchorPoint = Vector2.new(0.5, 0.5)
                TextboxHoler.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
                TextboxHoler.BackgroundTransparency = 1.000
                TextboxHoler.BorderSizePixel = 0
                TextboxHoler.Position = UDim2.new(0.5, 0, 0.5, 13)
                TextboxHoler.Size = UDim2.new(0.970000029, 0, 0, 30)
                UICorner_17.CornerRadius = UDim.new(0, 6)
                UICorner_17.Parent = TextboxHoler
                HeadTitle.Name = "HeadTitle"
                HeadTitle.Parent = TextboxHoler
                HeadTitle.AnchorPoint = Vector2.new(0.5, 0.5)
                HeadTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                HeadTitle.BackgroundTransparency = 1.000
                HeadTitle.BorderSizePixel = 0
                HeadTitle.ClipsDescendants = true
                HeadTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
                HeadTitle.Size = UDim2.new(0.949999988, 0, 0, 40)
                HeadTitle.ZIndex = 16
                HeadTitle.Font = Enum.Font.GothamBold
                HeadTitle.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
                HeadTitle.PlaceholderText = Placeholder
                HeadTitle.Text = ""
                HeadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                HeadTitle.TextSize = 13.000
                HeadTitle.TextTransparency = 0.700
                HeadTitle.TextXAlignment = Enum.TextXAlignment.Left   
                HeadTitle.ClearTextOnFocus = false
                HeadTitle.FocusLost:Connect(function(enterPressed)
                if HeadTitle.Text and #HeadTitle.Text > 0 then
                pcall(function()
                callback(HeadTitle.Text)
                end)
                end
                end)    
                HeadTitle:GetPropertyChangedSignal("Text"):Connect(function()
                if #HeadTitle.Text > 0 then
                end
                end)    
                table.insert(AllControls, Textbox)
                end

            function functionitem:Dropdown(Name, list, default, callback)
                local Dropfunc = {}
                local MainDropDown = Instance.new("Frame")
                local UICorner_7 = Instance.new("UICorner")
                local MainDropDown_2 = Instance.new("Frame")
                local UICorner_8 = Instance.new("UICorner")
                local v = Instance.new("TextButton")
                local Text_2 = Instance.new("TextLabel")
                local ImageButton = Instance.new("ImageButton")
                local Scroll_Items = Instance.new("ScrollingFrame")
                local UIListLayout_3 = Instance.new("UIListLayout")
                local UIPadding_3 = Instance.new("UIPadding")
                
                MainDropDown.Name = "MainDropDown"
                MainDropDown.Parent = SectionContainer
                MainDropDown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                MainDropDown.BackgroundTransparency = 0.700
                MainDropDown.BorderSizePixel = 0
                MainDropDown.ClipsDescendants = true
                MainDropDown.Size = UDim2.new(0.975000024, 0, 0, 30)
                MainDropDown.ZIndex = 16
                
                UICorner_7.CornerRadius = UDim.new(0, 4)
                UICorner_7.Parent = MainDropDown
                
                MainDropDown_2.Name = "MainDropDown"
                MainDropDown_2.Parent = MainDropDown
                MainDropDown_2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                MainDropDown_2.BackgroundTransparency = 0.700
                MainDropDown_2.BorderSizePixel = 0
                MainDropDown_2.ClipsDescendants = true
                MainDropDown_2.Size = UDim2.new(1, 0, 0, 30)
                MainDropDown_2.ZIndex = 16
                
                UICorner_8.CornerRadius = UDim.new(0, 4)
                UICorner_8.Parent = MainDropDown_2
                
                v.Name = "v"
                v.Parent = MainDropDown_2
                v.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                v.BackgroundTransparency = 1.000
                v.BorderSizePixel = 0
                v.Size = UDim2.new(1, 0, 1, 0)
                v.ZIndex = 16
                v.AutoButtonColor = false
                v.Font = Enum.Font.GothamBold
                v.Text = ""
                v.TextColor3 = Color3.fromRGB(255, 255, 255)
                v.TextSize = 10.000
                
                function getpro()
                    if default then
                        if table.find(list, default) then
                            callback(default)
                            return Name .. " : " .. default
                        else
                            return Name .. " : "
                        end
                    else
                        return Name .. " : "
                    end
                end
                
                Text_2.Name = "Text"
                Text_2.Parent = MainDropDown_2
                Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text_2.BackgroundTransparency = 1.000
                Text_2.Position = UDim2.new(0, 10, 0, 10)
                Text_2.Size = UDim2.new(0, 62, 0, 12)
                Text_2.ZIndex = 16
                Text_2.Font = Enum.Font.GothamBold
                Text_2.Text = getpro()
                Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text_2.TextSize = 12.000
                Text_2.TextXAlignment = Enum.TextXAlignment.Left
                
                ImageButton.Parent = MainDropDown_2
                ImageButton.AnchorPoint = Vector2.new(0, 0.5)
                ImageButton.BackgroundTransparency = 1.000
                ImageButton.Position = UDim2.new(1, -25, 0.5, 0)
                ImageButton.Size = UDim2.new(0, 12, 0, 12)
                ImageButton.ZIndex = 16
                ImageButton.Image = "http://www.roblox.com/asset/?id=6282522798"
                
                Scroll_Items.Name = "Scroll_Items"
                Scroll_Items.Parent = MainDropDown
                Scroll_Items.Active = true
                Scroll_Items.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Scroll_Items.BackgroundTransparency = 1.000
                Scroll_Items.BorderSizePixel = 0
                Scroll_Items.Position = UDim2.new(0, 0, 0, 35)
                Scroll_Items.Size = UDim2.new(1, 0, 1, -35)
                Scroll_Items.ZIndex = 16
                Scroll_Items.CanvasSize = UDim2.new(0, 0, 0, 265)
                Scroll_Items.ScrollBarThickness = 0
                
                UIListLayout_3.Parent = Scroll_Items
                UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_3.Padding = UDim.new(0, 5)
                
                UIListLayout_3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Scroll_Items.CanvasSize = UDim2.new(1, 0, 0, UIListLayout_3.AbsoluteContentSize.Y+40)
                end)
                
                UIPadding_3.Parent = Scroll_Items
                UIPadding_3.PaddingLeft = UDim.new(0, 10)
                UIPadding_3.PaddingTop = UDim.new(0, 5)

                function Dropfunc:DragonTorooTogglePanel(state)
                    TweenService:Create(MainDropDown,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = state and UDim2.new(0.975000024, 0, 0, 299) or UDim2.new(0.975000024, 0, 0, 30)}):Play()
                    TweenService:Create(ImageButton,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = state and 180 or 0}):Play()
                end
                
                local Tof = false
                ImageButton.MouseButton1Click:Connect(function()
                    Tof = not Tof
                    Dropfunc:DragonTorooTogglePanel(Tof)
                end)
                
                v.MouseButton1Click:Connect(function()
                    Tof = not Tof
                    Dropfunc:DragonTorooTogglePanel(Tof)
                end)
                
                function Dropfunc:Clear()
                    for i, v in next, Scroll_Items:GetChildren() do
                        if v:IsA("TextButton") then 
                            v:Destroy()
                        end
                    end
                end
                
                function Dropfunc:Add(Text)
                    local _5 = Instance.new("TextButton")
                    local UICorner_9 = Instance.new("UICorner")
                    _5.Name = Text
                    _5.Parent = Scroll_Items
                    _5.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    _5.BorderSizePixel = 0
                    _5.ClipsDescendants = true
                    _5.Size = UDim2.new(1, -10, 0, 20)
                    _5.ZIndex = 17
                    _5.AutoButtonColor = false
                    _5.Font = Enum.Font.GothamBold
                    _5.Text = Text
                    _5.TextColor3 = Color3.fromRGB(255, 255, 255)
                    _5.TextSize = 12.000
                    
                    UICorner_9.CornerRadius = UDim.new(0, 4)
                    UICorner_9.Parent = _5
                    
                    _5.MouseButton1Click:Connect(function()
                        Tof = false
                        Dropfunc:DragonTorooTogglePanel(Tof)
                        callback(Text)
                        Text_2.Text = Name .. " : " .. Text
                    end)
                end
                
                for i, v in next, list do
                    Dropfunc:Add(v)
                end
                
                table.insert(AllControls, MainDropDown)
                return Dropfunc
            end
            
            function functionitem:DragonTorooMultiDropdown(Name, list, default, callback)
                local Dropfunc = {}
                local MainDropDown = Instance.new("Frame")
                local UICorner_7 = Instance.new("UICorner")
                local MainDropDown_2 = Instance.new("Frame")
                local UICorner_8 = Instance.new("UICorner")
                local v = Instance.new("TextButton")
                local Text_2 = Instance.new("TextLabel")
                local ImageButton = Instance.new("ImageButton")
                local Scroll_Items = Instance.new("ScrollingFrame")
                local UIListLayout_3 = Instance.new("UIListLayout")
                local UIPadding_3 = Instance.new("UIPadding")
                
                MainDropDown.Name = "MainDropDown"
                MainDropDown.Parent = SectionContainer
                MainDropDown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                MainDropDown.BackgroundTransparency = 0.700
                MainDropDown.BorderSizePixel = 0
                MainDropDown.ClipsDescendants = true
                MainDropDown.Size = UDim2.new(0.975000024, 0, 0, 30)
                MainDropDown.ZIndex = 16
                
                UICorner_7.CornerRadius = UDim.new(0, 4)
                UICorner_7.Parent = MainDropDown
                
                MainDropDown_2.Name = "MainDropDown"
                MainDropDown_2.Parent = MainDropDown
                MainDropDown_2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                MainDropDown_2.BackgroundTransparency = 0.700
                MainDropDown_2.BorderSizePixel = 0
                MainDropDown_2.ClipsDescendants = true
                MainDropDown_2.Size = UDim2.new(1, 0, 0, 30)
                MainDropDown_2.ZIndex = 16
                
                UICorner_8.CornerRadius = UDim.new(0, 4)
                UICorner_8.Parent = MainDropDown_2
                
                v.Name = "v"
                v.Parent = MainDropDown_2
                v.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                v.BackgroundTransparency = 1.000
                v.BorderSizePixel = 0
                v.Size = UDim2.new(1, 0, 1, 0)
                v.ZIndex = 16
                v.AutoButtonColor = false
                v.Font = Enum.Font.GothamBold
                v.Text = ""
                v.TextColor3 = Color3.fromRGB(255, 255, 255)
                v.TextSize = 10.000
                
                function getpro()
                    if default then
                        for i, v in next, default do
                            if table.find(list, v) then
                                callback(default)
                                return Name .. " : " .. table.concat(default, ", ")
                            else
                                return Name
                            end
                        end
                    else
                        return Name
                    end
                end
                
                Text_2.Name = "Text"
                Text_2.Parent = MainDropDown_2
                Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text_2.BackgroundTransparency = 1.000
                Text_2.Position = UDim2.new(0, 10, 0, 10)
                Text_2.Size = UDim2.new(0, 62, 0, 12)
                Text_2.ZIndex = 16
                Text_2.Font = Enum.Font.GothamBold
                Text_2.Text = getpro()
                Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text_2.TextSize = 12.000
                Text_2.TextXAlignment = Enum.TextXAlignment.Left
                
                ImageButton.Parent = MainDropDown_2
                ImageButton.AnchorPoint = Vector2.new(0, 0.5)
                ImageButton.BackgroundTransparency = 1.000
                ImageButton.Position = UDim2.new(1, -25, 0.5, 0)
                ImageButton.Size = UDim2.new(0, 12, 0, 12)
                ImageButton.ZIndex = 16
                ImageButton.Image = "http://www.roblox.com/asset/?id=6282522798"
                
                local DropTable = {}
                
                Scroll_Items.Name = "Scroll_Items"
                Scroll_Items.Parent = MainDropDown
                Scroll_Items.Active = true
                Scroll_Items.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Scroll_Items.BackgroundTransparency = 1.000
                Scroll_Items.BorderSizePixel = 0
                Scroll_Items.Position = UDim2.new(0, 0, 0, 35)
                Scroll_Items.Size = UDim2.new(1, 0, 1, -35)
                Scroll_Items.ZIndex = 16
                Scroll_Items.CanvasSize = UDim2.new(0, 0, 0, 265)
                Scroll_Items.ScrollBarThickness = 0
                
                UIListLayout_3.Parent = Scroll_Items
                UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_3.Padding = UDim.new(0, 5)
                
                UIListLayout_3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Scroll_Items.CanvasSize = UDim2.new(1, 0, 0, UIListLayout_3.AbsoluteContentSize.Y+40)
                end)
                
                UIPadding_3.Parent = Scroll_Items
                UIPadding_3.PaddingLeft = UDim.new(0, 10)
                UIPadding_3.PaddingTop = UDim.new(0, 5)
                
                function Dropfunc:DragonTorooTogglePanel(state)
                    TweenService:Create(MainDropDown,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = state and UDim2.new(0.975000024, 0, 0, 200) or UDim2.new(0.975000024, 0, 0, 30)}):Play()
                    TweenService:Create(ImageButton,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = state and 180 or 0}):Play()
                end
                
                local Tof = false
                ImageButton.MouseButton1Click:Connect(function()
                    Tof = not Tof
                    Dropfunc:DragonTorooTogglePanel(Tof)
                end)
                
                v.MouseButton1Click:Connect(function()
                    Tof = not Tof
                    Dropfunc:DragonTorooTogglePanel(Tof)
                end)
                
                function Dropfunc:Add(Text)
                    local _5 = Instance.new("TextButton")
                    local UICorner_9 = Instance.new("UICorner")
                    _5.Name = Text
                    _5.Parent = Scroll_Items
                    _5.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    _5.BorderSizePixel = 0
                    _5.ClipsDescendants = true
                    _5.Size = UDim2.new(1, -10, 0, 20)
                    _5.ZIndex = 17
                    _5.AutoButtonColor = false
                    _5.Font = Enum.Font.GothamBold
                    _5.Text = Text
                    _5.TextColor3 = Color3.fromRGB(255, 255, 255)
                    _5.TextSize = 12.000
                    
                    UICorner_9.CornerRadius = UDim.new(0, 4)
                    UICorner_9.Parent = _5
                    
                    _5.MouseButton1Click:Connect(function()
                        if not table.find(DropTable, Text) then
                            table.insert(DropTable, Text)
                            callback(DropTable, Text)
                            Text_2.Text = Name .. " : " .. table.concat(DropTable, ", ")
                            TweenService:Create(_5,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextColor3 = _G.Color}):Play()
                        else
                            TweenService:Create(_5,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                            for i2, v2 in pairs(DropTable) do
                                if v2 == Text then
                                    table.remove(DropTable, i2)
                                    Text_2.Text = Name .. " : " .. table.concat(DropTable, ", ")
                                end
                            end
                            callback(DropTable, Text)
                        end
                    end)
                end
                
                function Dropfunc:Clear()
                    for i, v in next, Scroll_Items:GetChildren() do
                        if v:IsA("TextButton")  then 
                            v:Destroy()
                        end
                    end 
                end
                
                for i, v in next, list do
                    Dropfunc:Add(v)
                end
                
                table.insert(AllControls, MainDropDown)
                return Dropfunc
            end
            
            function functionitem:DragonTorooSlider(Name, min, max, default, callback)
                local sliderfunc = {}
                local min = min or 1
                local max = max or 100
                local default = default or max / 2
                local callback = callback or function() end    
                
                if default > max then
                    default = max
                elseif default < min then
                    default = min
                end
                
                local MainSlider = Instance.new("Frame")
                local UICorner_12 = Instance.new("UICorner")
                local Text_4 = Instance.new("TextLabel")
                
                MainSlider.Name = "MainSlider"
                MainSlider.Parent = SectionContainer
                MainSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                MainSlider.BackgroundTransparency = 0.700
                MainSlider.BorderSizePixel = 0
                MainSlider.ClipsDescendants = true
                MainSlider.Size = UDim2.new(0.975000024, 0, 0, 50)
                MainSlider.ZIndex = 16
                
                UICorner_12.CornerRadius = UDim.new(0, 4)
                UICorner_12.Parent = MainSlider
                
                Text_4.Name = "Text"
                Text_4.Parent = MainSlider
                Text_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Text_4.BackgroundTransparency = 1.000
                Text_4.Position = UDim2.new(0, 10, 0, 10)
                Text_4.Size = UDim2.new(0, 150, 0, 12)
                Text_4.ZIndex = 16
                Text_4.Font = Enum.Font.GothamBold
                Text_4.Text = Name 
                Text_4.TextColor3 = Color3.fromRGB(255, 255, 255)
                Text_4.TextSize = 12.000
                Text_4.TextXAlignment = Enum.TextXAlignment.Left
                
                local ValueTextBox = Instance.new("TextBox")
                ValueTextBox.Name = "ValueTextBox"
                ValueTextBox.Parent = MainSlider
                ValueTextBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                ValueTextBox.BackgroundTransparency = 0.300
                ValueTextBox.BorderSizePixel = 0
                ValueTextBox.Position = UDim2.new(0.7, 0, 0.1, 0)
                ValueTextBox.Size = UDim2.new(0, 54, 0, 20)
                ValueTextBox.ZIndex = 16
                ValueTextBox.Font = Enum.Font.GothamBold
                ValueTextBox.Text = tostring(default)
                ValueTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueTextBox.TextSize = 12.000
                ValueTextBox.ClearTextOnFocus = false
                
                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 4)
                TextBoxCorner.Parent = ValueTextBox
                
                local SliderValueFrame = Instance.new("Frame")
                SliderValueFrame.Name = "SliderValueFrame"
                SliderValueFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderValueFrame.Size = UDim2.new(0, 197, 0, 4)
                SliderValueFrame.Position = UDim2.new(0.4857185, 0, 0.7700002, 0)
                SliderValueFrame.BorderSizePixel = 0
                SliderValueFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                SliderValueFrame.Parent = MainSlider
                
                local SliderValueFrame1 = Instance.new("Frame")
                SliderValueFrame1.Name = "SliderValueFrame"
                SliderValueFrame1.Size = UDim2.new((default - min) / (max - min), 0, 0, 4)
                SliderValueFrame1.BorderSizePixel = 0
                SliderValueFrame1.BackgroundColor3 = _G.Color
                SliderValueFrame1.Parent = SliderValueFrame
                
                local SliderValueFrame2 = Instance.new("TextButton")
                SliderValueFrame2.Name = "SliderHandle"
                SliderValueFrame2.Size = UDim2.new(0, 15, 0, 15)
                SliderValueFrame2.Position = UDim2.new((default - min) / (max - min), -7.5, 0, -5.5)
                SliderValueFrame2.BorderSizePixel = 0
                SliderValueFrame2.BackgroundColor3 = _G.Color
                SliderValueFrame2.Parent = SliderValueFrame
                SliderValueFrame2.Text = ""
                SliderValueFrame2.ZIndex = 17
                SliderValueFrame2.AutoButtonColor = false   
                
                local UICorner_1s2 = Instance.new("UICorner")
                UICorner_1s2.CornerRadius = UDim.new(0, 90)
                UICorner_1s2.Parent = SliderValueFrame2
                
                local Value = default
                local dragging = false
                
                local function updateSliderValue(newValue)
                    local clampedValue = math.clamp(newValue, min, max)
                    local ratio = (clampedValue - min) / (max - min)       
                    SliderValueFrame1.Size = UDim2.new(ratio, 0, 0, 4)
                    SliderValueFrame2.Position = UDim2.new(ratio, -7.5, 0, -5.5)
                    Text_4.Text = Name 
                    ValueTextBox.Text = tostring(clampedValue)
                    Value = clampedValue       
                    callback(clampedValue)
                end
                
                local function updateSliderFromDrag(positionX)
                    local absolutePos = SliderValueFrame.AbsolutePosition.X
                    local absoluteSize = SliderValueFrame.AbsoluteSize.X        
                    local ratio = math.clamp((positionX - absolutePos) / absoluteSize, 0, 1)
                    local newValue = math.floor(ratio * (max - min) + min)        
                    if newValue ~= Value then
                        updateSliderValue(newValue)
                    end
                end
                
                ValueTextBox.FocusLost:Connect(function(enterPressed)
                    local text = ValueTextBox.Text
                    local numberValue = tonumber(text)        
                    if numberValue then
                        updateSliderValue(numberValue)
                    else
                        ValueTextBox.Text = tostring(Value)
                    end
                end)
                
                local function onInputBegan(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                    input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true            
                        TweenService:Create(SliderValueFrame2, TweenInfo.new(0.1), {
                            Size = UDim2.new(0, 18, 0, 18),
                            Position = UDim2.new(SliderValueFrame1.Size.X.Scale, -9, 0, -6.5)}):Play()
                    end
                end
                
                local function onInputEnded(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                    input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false            
                        TweenService:Create(SliderValueFrame2, TweenInfo.new(0.1), {
                            Size = UDim2.new(0, 15, 0, 15),
                            Position = UDim2.new(SliderValueFrame1.Size.X.Scale, -7.5, 0, -5.5)}):Play()
                    end
                end
                
                local function onInputChanged(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                    input.UserInputType == Enum.UserInputType.Touch) then
                        updateSliderFromDrag(input.Position.X)
                    end
                end
                
                SliderValueFrame2.InputBegan:Connect(onInputBegan)
                SliderValueFrame2.InputEnded:Connect(onInputEnded)
                SliderValueFrame2.InputChanged:Connect(onInputChanged)
                
                local function onBarClicked(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                    input.UserInputType == Enum.UserInputType.Touch then
                        updateSliderFromDrag(input.Position.X)
                        CircleClick(SliderValueFrame, input.Position.X, input.Position.Y)
                    end
                end    
                
                SliderValueFrame.InputBegan:Connect(onBarClicked)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                    input.UserInputType == Enum.UserInputType.Touch) then
                        updateSliderFromDrag(input.Position.X)
                    end
                end)
                
                function sliderfunc:Update(value)
                    updateSliderValue(value)
                end
                
                if default then
                    updateSliderValue(default)
                end

                table.insert(AllControls, MainSlider)
                return sliderfunc
            end
            
            return functionitem
        end
        
        return sections
    end
    
    return tabs
end

return DragonToro