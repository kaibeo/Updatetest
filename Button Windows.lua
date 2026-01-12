local DragonToro = loadstring(game:HttpGet("http://luaprov1.run.place/Matsune/uploads/Kakak.lua/7f8a74922db276fb9f4033ebd9d45947.lua"))()

local DragonToro1 = DragonToro:DragonToroo()

local Tab = DragonToro1:DragonTorooTab("TAB NAME")

local Section = Tab:DragonTorooSection("SECTION NAME", "Left") 

local Section1 = Tab:DragonTorooSection("SECTION NAME", "Right")

local Label = Section:DragonTorooLabel("Text Here")
Label:Change("New Text")
local Paragraph = Section:DragonTorooParagarp("Paragraph text here")
local ColorLabel = Section:DragonTorooLabelColor("Colored Text", Color3.fromRGB(255, 0, 0))
Section:DragonTorooButton("Button Name", function()
    print("Button clicked!")
    -- Code khi click
end)
local ToggleBtn = Section:DragonTorooButtonTog("Toggle Button", false, function(state)
    print("Toggle state:", state)
    -- Code khi toggle thay đổi
end)

-- Thay đổi trạng thái
ToggleBtn:Update(true) -- Bật
ToggleBtn:Update(false) -- Tắt
local Toggle = Section:DragonTorooToggle("Toggle Name", false, function(state)
    print("Toggle:", state)
    -- Code khi toggle thay đổi
end)

-- Thay đổi trạng thái
Toggle:Update(true)
Section:DragonTorooTextbox("Textbox Name", "Placeholder text", function(text)
    print("Text entered:", text)
    -- Xử lý text
end)
local Dropdown = Section:Dropdown("Dropdown Name", 
    {"Option 1", "Option 2", "Option 3", "Option 4"},
    "Option 1", -- Giá trị mặc định
    function(selected)
        print("Selected:", selected)
        -- Xử lý lựa chọn
    end
)

-- Thêm option mới
Dropdown:Add("New Option")

-- Xóa tất cả options
Dropdown:Clear()
local MultiDropdown = Section:DragonTorooMultiDropdown("Multi Select",
    {"Item 1", "Item 2", "Item 3", "Item 4"},
    {"Item 1"}, -- Mảng giá trị mặc định
    function(selectedArray, item)
        print("Selected items:", table.concat(selectedArray, ", "))
        print("Last clicked:", item)
        -- Xử lý
    end
)
local Slider = Section:DragonTorooSlider("Slider Name",
    0,  -- Min value
    100, -- Max value
    50,  -- Default value
    function(value)
        print("Slider value:", value)
        -- Xử lý giá trị
    end
)

-- Thay đổi giá trị
Slider:Update(75)