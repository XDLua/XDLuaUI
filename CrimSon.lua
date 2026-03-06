local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local XDLua = {
    WindowCount = 0,
    AccentColor = Color3.fromRGB(0, 120, 255), -- สีหลัก (ปรับเปลี่ยนได้)
    Font = Enum.Font.GothamMedium
}

-- ฟังก์ชันสำหรับทำ Smooth Drag (การลากหน้าต่าง)
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)

    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
        end
    end)
end

function XDLua:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XDLua_" .. tostring(math.random(1, 999))
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = MainFrame
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "XDLua UI"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = self.Font
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Content Container (Scrolling)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -10, 1, -45)
    Container.Position = UDim2.new(0, 5, 0, 40)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = self.AccentColor
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y -- ยืดตามคอนเทนต์อัตโนมัติ
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Container

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 5)
    Padding.Parent = Container

    local WindowAPI = {}

    -- ฟังก์ชันสร้างปุ่ม (Button)
    function WindowAPI:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.AutoButtonColor = false
        Button.Text = ""
        Button.Parent = Container

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 6)
        BCorner.Parent = Button

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = Color3.fromRGB(50, 50, 50)
        BStroke.Parent = Button

        local BLabel = Instance.new("TextLabel")
        BLabel.Size = UDim2.new(1, 0, 1, 0)
        BLabel.BackgroundTransparency = 1
        BLabel.Text = text
        BLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        BLabel.Font = XDLua.Font
        BLabel.TextSize = 14
        BLabel.Parent = Button

        -- Interaction
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.2), {Color = XDLua.AccentColor}):Play()
        end)

        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
        end)

        Button.MouseButton1Click:Connect(function()
            callback()
            -- Click Effect
            BLabel.TextSize = 12
            task.wait(0.05)
            BLabel.TextSize = 14
        end)
    end

    -- ฟังก์ชันสร้าง Toggle
    function WindowAPI:AddToggle(text, default, callback)
        local Toggled = default or false
        
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleBtn.Text = ""
        ToggleBtn.Parent = Container
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

        local TTitle = Instance.new("TextLabel")
        TTitle.Position = UDim2.new(0, 15, 0, 0)
        TTitle.Size = UDim2.new(1, -50, 1, 0)
        TTitle.BackgroundTransparency = 1
        TTitle.Text = text
        TTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        TTitle.Font = XDLua.Font
        TTitle.TextSize = 14
        TTitle.TextXAlignment = Enum.TextXAlignment.Left
        TTitle.Parent = ToggleBtn

        local StatusFrame = Instance.new("Frame")
        StatusFrame.Size = UDim2.new(0, 20, 0, 20)
        StatusFrame.Position = UDim2.new(1, -35, 0.5, -10)
        StatusFrame.BackgroundColor3 = Toggled and XDLua.AccentColor or Color3.fromRGB(50, 50, 50)
        StatusFrame.Parent = ToggleBtn
        Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 4)

        ToggleBtn.MouseButton1Click:Connect(function()
            Toggled = not Toggled
            TweenService:Create(StatusFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Toggled and XDLua.AccentColor or Color3.fromRGB(50, 50, 50)
            }):Play()
            callback(Toggled)
        end)
    end

    return WindowAPI
end

return XDLua
