local XDLuaUI = {}

-- [Services]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [Theme Configuration]
local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(220, 20, 60),
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

local function MakeDraggable(dragPart, moveTarget)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = moveTarget.Position
        end
    end)
    dragPart.InputEnded:Connect(function(input)
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
            ApplyTween(moveTarget, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.1)
        end
    end)
end

-- ฟังก์ชันนับลำดับสำหรับการวาง UI
local function GetNextOrder(parent)
    local count = 0
    for _, v in pairs(parent:GetChildren()) do
        if not v:IsA("UIListLayout") and not v:IsA("UIPadding") and not v:IsA("UICorner") and not v:IsA("UIStroke") then
            count = count + 1
        end
    end
    return count
end

-- [Main Library Function]
function XDLuaUI:CreateWindow(title)
    if CoreGui:FindFirstChild("XDLuaGUI") then
        CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    local Window = {} -- สร้าง Object สำหรับหน้าต่างนี้โดยเฉพาะ
    
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaGUI"
    screenGui.IgnoreGuiInset = true

    -- 1. สร้าง Main Frame (แต่ซ่อนไว้ก่อนจนกว่าจะโหลดเสร็จ)
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 500, 0, 340)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.Visible = false
    Instance.new("UICorner", mainFrame).CornerRadius = Theme.Rounding
    Instance.new("UIStroke", mainFrame).Color = Theme.Stroke

    -- 2. สร้าง Logo Button (ซ่อนไว้ก่อน)
    local logoButton = Instance.new("TextButton", screenGui)
    logoButton.Name = "LogoButton"
    logoButton.Size = UDim2.new(0, 45, 0, 45)
    logoButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    logoButton.BackgroundColor3 = Theme.Main
    logoButton.Text = ""
    logoButton.AutoButtonColor = false
    logoButton.Visible = false
    logoButton.Active = true 
    Instance.new("UICorner", logoButton).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", logoButton).Color = Theme.Accent
    Instance.new("UIStroke", logoButton).Thickness = 1.5

    local logoImage = Instance.new("ImageLabel", logoButton)
    logoImage.Size = UDim2.new(1, 0, 1, 0)
    logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://111935661110067"
    logoImage.ScaleType = Enum.ScaleType.Fit

    -- 3. [ระบบ Loading Screen]
    local blur = Instance.new("BlurEffect", game.Lighting)
    blur.Size = 0
    ApplyTween(blur, {Size = 20}, 0.5)

    local loadingFrame = Instance.new("Frame", screenGui)
    loadingFrame.Size = UDim2.new(0, 350, 0, 180)
    loadingFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
    loadingFrame.BackgroundColor3 = Theme.Main
    loadingFrame.BackgroundTransparency = 1
    Instance.new("UICorner", loadingFrame).CornerRadius = Theme.Rounding
    
    local loadStroke = Instance.new("UIStroke", loadingFrame)
    loadStroke.Color = Theme.Accent
    loadStroke.Thickness = 2
    loadStroke.Transparency = 1

    local titleLabel = Instance.new("TextLabel", loadingFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 60)
    titleLabel.Position = UDim2.new(0, 0, 0, 20)
    titleLabel.Text = "CRIMSON SCRIPT"
    titleLabel.TextColor3 = Theme.Accent
    titleLabel.TextTransparency = 1
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 28

    local statusLabel = Instance.new("TextLabel", loadingFrame)
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 0, 0.5, 35)
    statusLabel.Text = "กำลังโหลด..."
    statusLabel.TextColor3 = Theme.TextDark
    statusLabel.TextTransparency = 1
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextSize = 12

    local barFrame = Instance.new("Frame", loadingFrame)
    barFrame.Size = UDim2.new(0.8, 0, 0, 6)
    barFrame.Position = UDim2.new(0.1, 0, 0.5, 20)
    barFrame.BackgroundColor3 = Theme.Secondary
    barFrame.BackgroundTransparency = 1
    Instance.new("UICorner", barFrame).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame", barFrame)
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Theme.Accent
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    
    local barGlow = Instance.new("UIStroke", bar)
    barGlow.Color = Theme.Accent
    barGlow.Thickness = 2
    barGlow.Transparency = 0.6

    -- รัน Animation โหลด
    ApplyTween(loadingFrame, {BackgroundTransparency = 0}, 0.5)
    ApplyTween(loadStroke, {Transparency = 0}, 0.5)
    ApplyTween(titleLabel, {TextTransparency = 0}, 0.5)
    ApplyTween(statusLabel, {TextTransparency = 0}, 0.5)
    ApplyTween(barFrame, {BackgroundTransparency = 0}, 0.5)
    task.wait(0.6)

    task.spawn(function()
        task.wait(0.8) statusLabel.Text = "กำลังเช็คเวอร์ชั่น..."
        task.wait(0.8) statusLabel.Text = "กำลังเตรียมพร้อม..."
    end)

    local barTween = ApplyTween(bar, {Size = UDim2.new(1, 0, 1, 0)}, 2.8)
    barTween.Completed:Wait()
    statusLabel.Text = "พร้อมใช้งาน !"
    task.wait(0.5)

    -- จบการโหลด, นำ UI ขึ้นมาโชว์
    ApplyTween(loadingFrame, {BackgroundTransparency = 1}, 0.5)
    ApplyTween(loadStroke, {Transparency = 1}, 0.5)
    ApplyTween(titleLabel, {TextTransparency = 1}, 0.5)
    ApplyTween(statusLabel, {TextTransparency = 1}, 0.5)
    ApplyTween(barFrame, {BackgroundTransparency = 1}, 0.5)
    ApplyTween(bar, {BackgroundTransparency = 1}, 0.5)
    ApplyTween(blur, {Size = 0}, 0.5)
    
    task.wait(0.5)
    blur:Destroy()
    loadingFrame:Destroy()
    
    mainFrame.Visible = true
    logoButton.Visible = true

    -- 4. [ฟังก์ชันเชื่อมต่อสำหรับ UI หลัก]
    MakeDraggable(logoButton, logoButton)
    logoButton.MouseEnter:Connect(function() ApplyTween(logoButton, {Size = UDim2.new(0, 52, 0, 52)}, 0.2) end)
    logoButton.MouseLeave:Connect(function() ApplyTween(logoButton, {Size = UDim2.new(0, 45, 0, 45)}, 0.2) end)
    logoButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    local dragHandle = Instance.new("Frame", mainFrame)
    dragHandle.Size = UDim2.new(1, 0, 0, 45)
    dragHandle.BackgroundTransparency = 1
    MakeDraggable(dragHandle, mainFrame)

    local topTitle = Instance.new("TextLabel", mainFrame)
    topTitle.Size = UDim2.new(1, -80, 0, 45)
    topTitle.Position = UDim2.new(0, 15, 0, 0)
    topTitle.Text = title or "Crimson"
    topTitle.TextColor3 = Theme.Accent
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextSize = 18
    topTitle.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", mainFrame)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 20
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

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

    -- [Window Methods] -- (เปลี่ยนจาก XDLuaUI เป็น Window)
    function Window:AddTab(tabName, emoji)
        local tabBtn = Instance.new("TextButton", tabContainer)
        tabBtn.Size = UDim2.new(1, 0, 0, 35)
        tabBtn.BackgroundColor3 = Theme.Secondary
        tabBtn.Text = (emoji or "📂") .. " " .. tabName
        tabBtn.TextColor3 = Theme.TextDark
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local tabContent = Instance.new("ScrollingFrame", contentHolder)
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = Theme.Accent
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local cLayout = Instance.new("UIListLayout", tabContent)
        cLayout.Padding = UDim.new(0, 8)
        cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        cLayout.SortOrder = Enum.SortOrder.LayoutOrder

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
            tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            tabContent.Visible = true
            selectedTab = tabName 
        end
        return tabContent
    end

    function Window:AddSection(parent, text)
        local sectionFrame = Instance.new("Frame", parent)
        sectionFrame.Name = "Section"
        sectionFrame.LayoutOrder = GetNextOrder(parent)
        sectionFrame.Size = UDim2.new(0.95, 0, 0, 25)
        sectionFrame.BackgroundTransparency = 1

        local sLabel = Instance.new("TextLabel", sectionFrame)
        sLabel.Size = UDim2.new(1, 0, 1, 0)
        sLabel.Text = text:upper()
        sLabel.TextColor3 = Theme.Accent
        sLabel.Font = Enum.Font.GothamBold
        sLabel.TextSize = 12
        sLabel.TextXAlignment = Enum.TextXAlignment.Left
        sLabel.BackgroundTransparency = 1
        Instance.new("UIPadding", sLabel).PaddingLeft = UDim.new(0, 5)

        local line = Instance.new("Frame", sectionFrame)
        line.Size = UDim2.new(1, - (sLabel.TextBounds.X + 15), 0, 1)
        line.Position = UDim2.new(0, sLabel.TextBounds.X + 10, 0.5, 0)
        line.BackgroundColor3 = Theme.Stroke
        line.BorderSizePixel = 0
        return sectionFrame
    end

    function Window:AddLabel(parent, text, color)
        local label = Instance.new("TextLabel", parent)
        label.LayoutOrder = GetNextOrder(parent)
        label.Size = UDim2.new(0.95, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color or Theme.TextDark
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        Instance.new("UIPadding", label).PaddingLeft = UDim.new(0, 12)
        return label
    end

    function Window:AddButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.LayoutOrder = GetNextOrder(parent)
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
        btn.MouseButton1Click:Connect(callback)
    end

    function Window:AddToggle(parent, text, default, callback)
        local toggled = default or false
        local bg = Instance.new("TextButton", parent)
        bg.LayoutOrder = GetNextOrder(parent)
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

    function Window:AddSlider(parent, text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame", parent)
        sliderFrame.LayoutOrder = GetNextOrder(parent)
        sliderFrame.Size = UDim2.new(0.95, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Theme.Main
        Instance.new("UICorner", sliderFrame).CornerRadius = Theme.Rounding
        Instance.new("UIStroke", sliderFrame).Color = Theme.Stroke

        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Text = text .. " : " .. default
        label.TextColor3 = Theme.TextDark
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left

        local barBg = Instance.new("Frame", sliderFrame)
        barBg.Size = UDim2.new(1, -30, 0, 6)
        barBg.Position = UDim2.new(0, 15, 0, 32)
        barBg.BackgroundColor3 = Theme.Secondary
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

        local barFill = Instance.new("Frame", barBg)
        barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        barFill.BackgroundColor3 = Theme.Accent
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function UpdateSlider()
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = barBg.AbsolutePosition.X
            local barSize = barBg.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            ApplyTween(barFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
            label.Text = text .. " : " .. value
            callback(value)
        end

        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                UpdateSlider()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider() end
        end)
    end

    function Window:AddDropdown(parent, text, list, callback)
        local dropped = false
        local selectedItems = {}
        local currentList = list or {}
        
        local dropFrame = Instance.new("Frame", parent)
        dropFrame.LayoutOrder = GetNextOrder(parent)
        dropFrame.Size = UDim2.new(0.95, 0, 0, 35)
        dropFrame.BackgroundColor3 = Theme.Main
        dropFrame.ClipsDescendants = true
        Instance.new("UICorner", dropFrame).CornerRadius = Theme.Rounding
        Instance.new("UIStroke", dropFrame).Color = Theme.Stroke

        local btn = Instance.new("TextButton", dropFrame)
        btn.Size = UDim2.new(1, -35, 0, 35)
        btn.BackgroundTransparency = 1
        btn.Text = text .. "  ▼"
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Center

        local refreshBtn = Instance.new("TextButton", dropFrame)
        refreshBtn.Size = UDim2.new(0, 30, 0, 30)
        refreshBtn.Position = UDim2.new(1, -32, 0, 2.5)
        refreshBtn.BackgroundColor3 = Theme.Secondary
        refreshBtn.Text = "🔄"
        refreshBtn.TextColor3 = Theme.Accent
        refreshBtn.TextSize = 14
        Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 4)
        local rStroke = Instance.new("UIStroke", refreshBtn)
        rStroke.Color = Theme.Stroke
        rStroke.Thickness = 0.5

        local container = Instance.new("ScrollingFrame", dropFrame)
        container.Size = UDim2.new(1, 0, 0, 120)
        container.Position = UDim2.new(0, 0, 0, 35)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 3
        container.ScrollBarImageColor3 = Theme.Accent
        local layout = Instance.new("UIListLayout", container)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local function CreateItems(items)
            for _, child in pairs(container:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            
            for _, item in pairs(items) do
                local itemBtn = Instance.new("TextButton", container)
                itemBtn.Size = UDim2.new(1, 0, 0, 30)
                itemBtn.BackgroundTransparency = 1
                itemBtn.Text = tostring(item)
                itemBtn.TextColor3 = selectedItems[item] and Theme.Accent or Theme.TextDark
                itemBtn.Font = Enum.Font.Gotham
                itemBtn.TextSize = 12

                itemBtn.MouseButton1Click:Connect(function()
                    selectedItems = {[item] = true} -- โหมดเลือกทีละ 1 ค่า
                    btn.Text = text .. " : " .. tostring(item) .. "  " .. (dropped and "▲" or "▼")
                    CreateItems(currentList) -- รีเฟรชให้สีเปลี่ยน
                    callback({item})
                end)
            end
            container.CanvasSize = UDim2.new(0, 0, 0, #items * 30)
        end

        CreateItems(currentList)

        btn.MouseButton1Click:Connect(function()
            dropped = not dropped
            local targetSize = dropped and UDim2.new(0.95, 0, 0, 155) or UDim2.new(0.95, 0, 0, 35)
            ApplyTween(dropFrame, {Size = targetSize}, 0.2)
            
            local currentSelection = ""
            for k, _ in pairs(selectedItems) do currentSelection = " : " .. tostring(k) end
            btn.Text = text .. currentSelection .. "  " .. (dropped and "▲" or "▼")
        end)

        refreshBtn.MouseButton1Click:Connect(function()
            ApplyTween(refreshBtn, {Rotation = refreshBtn.Rotation + 360}, 0.5)
            CreateItems(currentList) 
        end)

        local DropdownFuncs = {}
        function DropdownFuncs:Refresh(newList)
            currentList = newList or {}
            CreateItems(currentList)
        end

        function DropdownFuncs:Set(val)
            selectedItems = {[val] = true}
            btn.Text = text .. " : " .. tostring(val) .. "  " .. (dropped and "▲" or "▼")
            CreateItems(currentList)
            callback({val})
        end
        
        function DropdownFuncs:Clear()
            selectedItems = {}
            btn.Text = text .. "  " .. (dropped and "▲" or "▼")
            CreateItems(currentList)
        end

        return DropdownFuncs
    end

    function Window:AddKeybind(parent, text, defaultKey, callback)
        local currentKey = defaultKey.Name
        local binding = false

        local bindFrame = Instance.new("Frame", parent)
        bindFrame.LayoutOrder = GetNextOrder(parent)
        bindFrame.Size = UDim2.new(0.95, 0, 0, 35)
        bindFrame.BackgroundColor3 = Theme.Main
        Instance.new("UICorner", bindFrame).CornerRadius = Theme.Rounding
        Instance.new("UIStroke", bindFrame).Color = Theme.Stroke

        local label = Instance.new("TextLabel", bindFrame)
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.Text = text
        label.TextColor3 = Theme.TextDark
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13

        local bindBtn = Instance.new("TextButton", bindFrame)
        bindBtn.Size = UDim2.new(0, 60, 0, 24)
        bindBtn.Position = UDim2.new(1, -65, 0.5, -12)
        bindBtn.BackgroundColor3 = Theme.Secondary
        bindBtn.Text = currentKey
        bindBtn.TextColor3 = Theme.Accent
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextSize = 12
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)

        bindBtn.MouseButton1Click:Connect(function()
            binding = true
            bindBtn.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if binding then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode.Name
                    bindBtn.Text = currentKey
                    binding = false
                    callback(input.KeyCode)
                end
            elseif input.KeyCode.Name == currentKey then
                callback(input.KeyCode)
            end
        end)
    end

    function Window:AddDropdownBind(parent, dropdownFunc, text, defaultKey, targetValue)
        self:AddKeybind(parent, text .. " (" .. tostring(targetValue) .. ")", defaultKey, function()
            dropdownFunc:Set(targetValue) 
        end)
    end

    -- ส่งคืนอ็อบเจกต์หน้าต่างหลักเพื่อให้ผู้ใช้นำไปสร้าง UI ต่อ
    return Window
end

return XDLuaUI
