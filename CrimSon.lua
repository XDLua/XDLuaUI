-- XDLuaUI (Professional Version)
local XDLuaUI = {}

-- [Services]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [Theme Configuration] - ปรับแต่งสีและสไตล์ที่นี่ที่เดียว
local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(255, 50, 255),
    Text = Color3.fromRGB(245, 245, 245),
    TextDark = Color3.fromRGB(180, 180, 180),
    Stroke = Color3.fromRGB(45, 45, 45),
    Rounding = UDim.new(0, 8),
    TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- [Helper Functions]
local function ApplyTween(obj, goal, duration)
    local info = duration and TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or Theme.TweenInfo
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            ApplyTween(gui, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.1)
        end
    end)
end

-- [Main Library Function]
function XDLuaUI:CreateWindow(title, emojiFront, emojiBack, spacing)
    -- Clean existing UI
    if CoreGui:FindFirstChild("XDLuaGUI") then
        CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaGUI"
    screenGui.IgnoreGuiInset = true

    -- 1. Loading Frame
    local loadingFrame = Instance.new("Frame", screenGui)
    loadingFrame.Size = UDim2.new(0, 320, 0, 160)
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    loadingFrame.BackgroundColor3 = Theme.Main
    loadingFrame.BorderSizePixel = 0
    
    Instance.new("UICorner", loadingFrame).CornerRadius = Theme.Rounding
    local loadStroke = Instance.new("UIStroke", loadingFrame)
    loadStroke.Color = Theme.Accent
    loadStroke.Thickness = 1.5

    local titleLabel = Instance.new("TextLabel", loadingFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Text = "BY C • J"
    titleLabel.TextColor3 = Theme.Accent
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 24

    local barFrame = Instance.new("Frame", loadingFrame)
    barFrame.Size = UDim2.new(0.8, 0, 0, 4)
    barFrame.Position = UDim2.new(0.1, 0, 0.5, 10)
    barFrame.BackgroundColor3 = Theme.Secondary
    Instance.new("UICorner", barFrame).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame", barFrame)
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    -- Animation Loading
    local barTween = ApplyTween(bar, {Size = UDim2.new(1, 0, 1, 0)}, 2.5)
    barTween.Completed:Wait()
    task.wait(0.5)
    loadingFrame:Destroy()

    -- 2. Logo Button (Toggle UI)
    local logoButton = Instance.new("TextButton", screenGui)
    logoButton.Size = UDim2.new(0, 45, 0, 45)
    logoButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    logoButton.BackgroundColor3 = Theme.Main
    logoButton.Text = "👾"
    logoButton.TextSize = 22
    logoButton.TextColor3 = Theme.Accent
    logoButton.AutoButtonColor = false
    Instance.new("UICorner", logoButton).CornerRadius = UDim.new(0, 10)
    local logoStroke = Instance.new("UIStroke", logoButton)
    logoStroke.Color = Theme.Stroke
    MakeDraggable(logoButton)

    -- 3. Main Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 500, 0, 340)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = true
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = Theme.Rounding
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Theme.Stroke
    mainStroke.Thickness = 1.2
    MakeDraggable(mainFrame)

    -- Top Bar Title
    local topTitle = Instance.new("TextLabel", mainFrame)
    topTitle.Size = UDim2.new(1, -80, 0, 45)
    topTitle.Position = UDim2.new(0, 15, 0, 0)
    topTitle.Text = title or "XDLua Professional"
    topTitle.TextColor3 = Theme.Accent
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextSize = 18
    topTitle.BackgroundTransparency = 1

    -- Close Button
    local closeBtn = Instance.new("TextButton", mainFrame)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 20
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Layouts
    local tabContainer = Instance.new("ScrollingFrame", mainFrame)
    tabContainer.Size = UDim2.new(0, 130, 1, -60)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    local tabLayout = Instance.new("UIListLayout", tabContainer)
    tabLayout.Padding = UDim.new(0, 5)

    local contentHolder = Instance.new("Frame", mainFrame)
    contentHolder.Size = UDim2.new(1, -160, 1, -60)
    contentHolder.Position = UDim2.new(0, 150, 0, 50)
    contentHolder.BackgroundColor3 = Theme.Secondary
    Instance.new("UICorner", contentHolder).CornerRadius = Theme.Rounding
    
    local tabs = {}
    local selectedTab = nil

    function XDLuaUI:AddTab(tabName, emoji)
        local tabBtn = Instance.new("TextButton", tabContainer)
        tabBtn.Size = UDim2.new(1, 0, 0, 35)
        tabBtn.BackgroundColor3 = Theme.Secondary
        tabBtn.Text = (emoji or "📂") .. " " .. tabName
        tabBtn.TextColor3 = Theme.TextDark
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        tabBtn.AutoButtonColor = false
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
        local tStroke = Instance.new("UIStroke", tabBtn)
        tStroke.Color = Theme.Stroke
        tStroke.Transparency = 0.5

        local tabContent = Instance.new("ScrollingFrame", contentHolder)
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Theme.Accent
        local cLayout = Instance.new("UIListLayout", tabContent)
        cLayout.Padding = UDim.new(0, 8)
        cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Btn.TextColor3 = Theme.TextDark
                t.Btn.BackgroundColor3 = Theme.Secondary
                t.Content.Visible = false
            end
            tabBtn.TextColor3 = Theme.Accent
            tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            tabContent.Visible = true
        end)

        tabs[tabName] = {Btn = tabBtn, Content = tabContent}
        if not selectedTab then 
            tabBtn.TextColor3 = Theme.Accent
            tabContent.Visible = true
            selectedTab = tabName 
        end
        return tabContent
    end

    -- Components
    function XDLuaUI:AddButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 35)
        btn.BackgroundColor3 = Theme.Main
        btn.Text = text
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 14
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bStroke = Instance.new("UIStroke", btn)
        bStroke.Color = Theme.Stroke

        btn.MouseEnter:Connect(function() ApplyTween(bStroke, {Color = Theme.Accent}) end)
        btn.MouseLeave:Connect(function() ApplyTween(bStroke, {Color = Theme.Stroke}) end)
        btn.MouseButton1Down:Connect(function() ApplyTween(btn, {Size = UDim2.new(0.92, 0, 0, 32)}, 0.1) end)
        btn.MouseButton1Up:Connect(function() 
            ApplyTween(btn, {Size = UDim2.new(0.95, 0, 0, 35)}, 0.1)
            callback() 
        end)
    end

    function XDLuaUI:AddToggle(parent, text, default, callback)
        local toggled = default or false
        local bg = Instance.new("TextButton", parent)
        bg.Size = UDim2.new(0.95, 0, 0, 35)
        bg.BackgroundColor3 = Theme.Main
        bg.Text = ""
        bg.AutoButtonColor = false
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", bg)
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = text
        label.TextColor3 = Theme.TextDark
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13

        local switch = Instance.new("Frame", bg)
        switch.Size = UDim2.new(0, 34, 0, 18)
        switch.Position = UDim2.new(1, -44, 0.5, -9)
        switch.BackgroundColor3 = toggled and Theme.Accent or Theme.Stroke
        Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", switch)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        dot.BackgroundColor3 = Theme.Text
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        bg.MouseButton1Click:Connect(function()
            toggled = not toggled
            ApplyTween(switch, {BackgroundColor3 = toggled and Theme.Accent or Theme.Stroke}, 0.2)
            ApplyTween(dot, {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
            callback(toggled)
        end)
    end

    -- Toggle Main UI Visibility
    logoButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    return XDLuaUI
end

return XDLuaUI
