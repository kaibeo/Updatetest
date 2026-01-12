local Library = loadstring(game:HttpGet("http://luaprov1.run.place/Matsune/uploads/Kakak.lua/d75962ea0a5aff3f48602ac29cc4cace.lua"))()
local Main = Library.CreateMain({
    Desc = ""
})

local Page = Main.CreatePage({
    Page_Name = "Home",
    Page_Title = "Home"
})

local Page2 = Main.CreatePage({
    Page_Name = "Home1",
    Page_Title = "Home2"
})

local Page3 = Main.CreatePage({
    Page_Name = "Home3",
    Page_Title = "Home4"
})


local Section = Page.CreateSection("Setting")

Section.CreateToggle({
    Title = "Enable/Disable function",
    Desc = "Here is an example toggle",
    Default = false
}, function(state)
    print("Toggle state:", state)
end)

Section.CreateButton({
    Title = "Click me"
}, function()
    print("Button has been pressed!")
end)

Section.CreateLabel({
    Title = "Here is an example label"
})

Section.CreateSlider({
    Title = "Adjust value",
    Min = 0,
    Max = 100,
    Default = 50,
    Precise = true
}, function(value)
    print("Slider value:", value)
end)

Section.CreateBox({
    Title = "Enter text",
    Placeholder = "Type something...",
    Default = "",
    Number = false
}, function(text)
    print("You have entered:", text)
end)

Section.CreateDropdown({
    Title = "Dropdown",
    List = {
        "Option 1",
        "Option 2",
        "Option 3"
    },
    Search = false,
    Selected = false,
    Default = "Option 1",
}, function(value)
    print(value)
end)

local Section1 = Page2.CreateSection("Setting 2")

Section1.CreateToggle({
    Title = "Enable/Disable function",
    Desc = "Here is an example toggle",
    Default = false
}, function(state)
    print("Toggle state:", state)
end)