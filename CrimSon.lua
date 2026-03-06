local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local XDLua = {
    AccentColor = Color3.fromRGB(0, 162, 255),
    Font = Enum.Font.GothamMedium,
    SecondaryColor = Color3.fromRGB(30, 30, 30),
    MainColor = Color3.fromRGB(15, 15, 15)
}

-- [ Helper: Smooth Drag ]
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function XDLua:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "XDLua_Ultimate"
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = self.MainColor
    MainFrame.BorderSizePixel = 0
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1

    -- [ Sidebar / Tabs ]
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- [ Topbar ]
    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundTransparency = 1
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel", Topbar)
    TitleLabel.Text = "  " .. title
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = self.Font
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1

    -- [ Pages Container ]
    local Pages = Instance.new("Frame", MainFrame)
    Pages.Size = UDim2.new(1, -160, 1, -50)
    Pages.Position = UDim2.new(0, 155, 0, 45)
    Pages.BackgroundTransparency = 1

    local WindowAPI = { CurrentPage = nil }

    function WindowAPI:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8)
        Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 5)

        local TabButton = Instance.new("TextButton", TabContainer)
        TabButton.Size = UDim2.new(0, 130, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.Font = XDLua.Font
        TabButton.TextSize = 14
        Instance.new("UICorner", TabButton)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end 
            end
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = XDLua.AccentColor, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        if not WindowAPI.CurrentPage then
            Page.Visible = true
            WindowAPI.CurrentPage = Page
            TabButton.BackgroundColor3 = XDLua.AccentColor
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        local PageAPI = {}

        -- [ 1. Button ]
        function PageAPI:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = XDLua.SecondaryColor
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.Font = XDLua.Font
            Btn.TextSize = 14
            Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- [ 2. Toggle ]
        function PageAPI:AddToggle(text, default, callback)
            local Toggled = default
            local ToggleBtn = Instance.new("TextButton", Page)
            ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
            ToggleBtn.BackgroundColor3 = XDLua.SecondaryColor
            ToggleBtn.Text = "  " .. text
            ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.Font = XDLua.Font
            Instance.new("UICorner", ToggleBtn)

            local Status = Instance.new("Frame", ToggleBtn)
            Status.Size = UDim2.new(0, 24, 0, 24)
            Status.Position = UDim2.new(1, -34, 0.5, -12)
            Status.BackgroundColor3 = Toggled and XDLua.AccentColor or Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

            ToggleBtn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and XDLua.AccentColor or Color3.fromRGB(50, 50, 50)}):Play()
                callback(Toggled)
            end)
        end

        -- [ 3. Slider ]
        function PageAPI:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, -10, 0, 45)
            SliderFrame.BackgroundColor3 = XDLua.SecondaryColor
            Instance.new("UICorner", SliderFrame)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = "  " .. text
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.Font = XDLua.Font
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValLabel = Instance.new("TextLabel", SliderFrame)
            ValLabel.Text = tostring(default) .. " "
            ValLabel.Size = UDim2.new(1, 0, 0, 25)
            ValLabel.BackgroundTransparency = 1
            ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right

            local BarArea = Instance.new("TextButton", SliderFrame)
            BarArea.Size = UDim2.new(1, -20, 0, 5)
            BarArea.Position = UDim2.new(0, 10, 0, 32)
            BarArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            BarArea.Text = ""
            Instance.new("UICorner", BarArea)

            local Fill = Instance.new("Frame", BarArea)
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = XDLua.AccentColor
            Instance.new("UICorner", Fill)

            local function UpdateSlider()
                local percent = math.clamp((UserInputService:GetMouseLocation().X - BarArea.AbsolutePosition.X) / BarArea.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                ValLabel.Text = tostring(value) .. " "
                callback(value)
            end

            local sliding = false
            BarArea.MouseButton1Down:Connect(function() sliding = true end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider() end end)
        end

        -- [ 4. Dropdown (Simplified) ]
        function PageAPI:AddDropdown(text, list, callback)
            local DropFrame = Instance.new("TextButton", Page)
            DropFrame.Size = UDim2.new(1, -10, 0, 35)
            DropFrame.BackgroundColor3 = XDLua.SecondaryColor
            DropFrame.Text = "  " .. text .. " : Select..."
            DropFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropFrame.TextXAlignment = Enum.TextXAlignment.Left
            DropFrame.Font = XDLua.Font
            Instance.new("UICorner", DropFrame)

            local isOpen = false
            DropFrame.MouseButton1Click:Connect(function()
                -- ในเวอร์ชันเต็มต้องมีระบบขยาย List ลงมา
                -- นี่คือตัวอย่าง Logic การเปลี่ยนค่าวนรอบ
                local currentIdx = 1
                isOpen = true
                DropFrame.Text = "  " .. text .. " : " .. list[1]
                callback(list[1])
            end)
        end

        return PageAPI
    end

    return WindowAPI
end

return XDLua
