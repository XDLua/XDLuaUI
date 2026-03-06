-- XDLuaUI (Professional Version - Fixed Dragging)
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

-- ระบบลากที่ปรับปรุงใหม่ (รับ GUI ที่ต้องการให้เลื่อน และ GUI ที่เป็นตัวจับลาก)
local function MakeDraggable(dragPart, mainFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
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
            ApplyTween(mainFrame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.1)
        end
    end)
end

-- [Main Library Function]
function XDLuaUI:CreateWindow(title, emojiFront, emojiBack, spacing)
    if CoreGui:FindFirstChild("XDLuaGUI") then
        CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaGUI"
    screenGui.IgnoreGuiInset = true

    -- 1. Loading Frame (คงเดิม)
    local loadingFrame = Instance.new("Frame", screenGui)
    loadingFrame.Size = UDim2.new(0, 320, 0, 160)
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    loadingFrame.BackgroundColor3 = Theme.Main
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

    local barTween = ApplyTween(bar, {Size = UDim2.new(1, 0, 1, 0)}, 2.5)
    barTween.Completed:Wait()
    task.wait(0.5)
    loadingFrame:Destroy()

    -- 2. Logo Button (ฉบับปรับปรุง: รองรับรูปภาพและเอฟเฟกต์)
    local logoButton = Instance.new("TextButton", screenGui)
    logoButton.Name = "LogoButton"
    logoButton.Size = UDim2.new(0, 45, 0, 45)
    logoButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    logoButton.BackgroundColor3 = Theme.Main
    logoButton.Text = "" -- ลบ Emoji ออก
    logoButton.AutoButtonColor = false
    Instance.new("UICorner", logoButton).CornerRadius = UDim.new(0, 10)
    
    local logoStroke = Instance.new("UIStroke", logoButton)
    logoStroke.Color = Theme.Accent
    logoStroke.Thickness = 1.5

    -- ส่วนแสดงรูปภาพโลโก้
    local logoImage = Instance.new("ImageLabel", logoButton)
    logoImage.Name = "LogoImage"
    logoImage.Size = UDim2.new(0.7, 0, 0.7, 0) -- ขนาดรูปภาพ (70% ของปุ่ม)
    logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://118933158736973" -- ใส่ ID รูปภาพของคุณตรงนี้
    logoImage.ImageColor3 = Theme.Accent -- ให้รูปเปลี่ยนสีตาม Theme (ถ้าเป็นรูปสีขาวล้วน)
    logoImage.ScaleType = Enum.ScaleType.Fit

    -- เอฟเฟกต์เวลาเอาเมาส์ชี้ (Hover Effect)
    logoButton.MouseEnter:Connect(function()
        ApplyTween(logoButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.2)
        ApplyTween(logoImage, {Rotation = 90}, 0.3)
    end)

    logoButton.MouseLeave:Connect(function()
        ApplyTween(logoButton, {Size = UDim2.new(0, 45, 0, 45)}, 0.2)
        ApplyTween(logoImage, {Rotation = 0}, 0.3)
    end)

    MakeDraggable(logoButton, logoButton)

    -- 3. Main Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 500, 0, 340)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
    mainFrame.BackgroundColor3 = Theme.Main
    mainFrame.BorderSizePixel = 0
    Instance.new("UICorner", mainFrame).CornerRadius = Theme.Rounding
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Theme.Stroke
    mainStroke.Thickness = 1.2

    -- [หัวใจหลัก] Drag Handle (แถบบนสุดที่ใช้ลาก)
    local dragHandle = Instance.new("Frame", mainFrame)
    dragHandle.Name = "DragHandle"
    dragHandle.Size = UDim2.new(1, 0, 0, 45)
    dragHandle.BackgroundTransparency = 1 -- โปร่งใสเพื่อให้เห็น Title ข้างหลัง
    dragHandle.ZIndex = 5
    MakeDraggable(dragHandle, mainFrame)

    local topTitle = Instance.new("TextLabel", mainFrame)
    topTitle.Size = UDim2.new(1, -80, 0, 45)
    topTitle.Position = UDim2.new(0, 15, 0, 0)
    topTitle.Text = title or "XDLua Professional"
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
    closeBtn.ZIndex = 6 -- อยู่เหนือ DragHandle
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Layouts (คงเดิม)
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

    -- Components (AddButton, AddToggle, AddSlider, AddDropdown คงเดิมจากที่ปรับปรุงล่าสุด)
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

    function XDLuaUI:AddSlider(parent, text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame", parent)
        sliderFrame.Size = UDim2.new(0.95, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Theme.Main
        Instance.new("UICorner", sliderFrame).CornerRadius = Theme.Rounding
        local sStroke = Instance.new("UIStroke", sliderFrame)
        sStroke.Color = Theme.Stroke

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

        local knob = Instance.new("Frame", barFill)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(1, 0, 0.5, 0)
        knob.BackgroundColor3 = Theme.Text
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local kStroke = Instance.new("UIStroke", knob)
        kStroke.Color = Theme.Accent
        kStroke.Thickness = 1.5

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
                ApplyTween(knob, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
                UpdateSlider()
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                ApplyTween(knob, {Size = UDim2.new(0, 14, 0, 14)}, 0.1)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider()
            end
        end)
    end

    function XDLuaUI:AddDropdown(parent, text, list, callback)
        local dropped = false
        local dropFrame = Instance.new("Frame", parent)
        dropFrame.Size = UDim2.new(0.95, 0, 0, 35)
        dropFrame.BackgroundColor3 = Theme.Main
        dropFrame.ClipsDescendants = true
        Instance.new("UICorner", dropFrame).CornerRadius = Theme.Rounding
        local dStroke = Instance.new("UIStroke", dropFrame)
        dStroke.Color = Theme.Stroke

        local btn = Instance.new("TextButton", dropFrame)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundTransparency = 1
        btn.Text = text .. "  ▼"
        btn.TextColor3 = Theme.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13

        local container = Instance.new("Frame", dropFrame)
        container.Size = UDim2.new(1, 0, 0, #list * 30)
        container.Position = UDim2.new(0, 0, 0, 35)
        container.BackgroundTransparency = 1
        local layout = Instance.new("UIListLayout", container)

        btn.MouseButton1Click:Connect(function()
            dropped = not dropped
            local targetSize = dropped and UDim2.new(0.95, 0, 0, 35 + (#list * 30)) or UDim2.new(0.95, 0, 0, 35)
            ApplyTween(dropFrame, {Size = targetSize}, 0.2)
            btn.Text = dropped and text .. "  ▲" or text .. "  ▼"
        end)

        for _, item in pairs(list) do
            local itemBtn = Instance.new("TextButton", container)
            itemBtn.Size = UDim2.new(1, 0, 0, 30)
            itemBtn.BackgroundTransparency = 1
            itemBtn.Text = tostring(item)
            itemBtn.TextColor3 = Theme.TextDark
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.TextSize = 12

            itemBtn.MouseButton1Click:Connect(function()
                btn.Text = text .. " : " .. item .. "  ▼"
                dropped = false
                ApplyTween(dropFrame, {Size = UDim2.new(0.95, 0, 0, 35)}, 0.2)
                callback(item)
            end)
        end
    end

-- -- [System: Notification]
-- function XDLuaUI:Notify(nTitle, nText, duration)
--     local nFrame = Instance.new("Frame", screenGui)
--     nFrame.Name = "Notification"
--     nFrame.Size = UDim2.new(0, 260, 0, 65)
--     -- เริ่มต้นที่นอกจอฝั่งขวา
--     nFrame.Position = UDim2.new(1, 10, 1, -80) 
--     nFrame.BackgroundColor3 = Theme.Main
--     nFrame.ZIndex = 10
    
--     local nCorner = Instance.new("UICorner", nFrame)
--     nCorner.CornerRadius = Theme.Rounding
    
--     local nStroke = Instance.new("UIStroke", nFrame)
--     nStroke.Color = Theme.Accent
--     nStroke.Thickness = 1.5

--     -- หัวข้อแจ้งเตือน
--     local tLabel = Instance.new("TextLabel", nFrame)
--     tLabel.Size = UDim2.new(1, -20, 0, 25)
--     tLabel.Position = UDim2.new(0, 10, 0, 5)
--     tLabel.Text = nTitle or "Notification"
--     tLabel.TextColor3 = Theme.Accent
--     tLabel.Font = Enum.Font.GothamBold
--     tLabel.TextSize = 14
--     tLabel.BackgroundTransparency = 1
--     tLabel.TextXAlignment = Enum.TextXAlignment.Left

--     -- เนื้อหาแจ้งเตือน
--     local dLabel = Instance.new("TextLabel", nFrame)
--     dLabel.Size = UDim2.new(1, -20, 0, 30)
--     dLabel.Position = UDim2.new(0, 10, 0, 28)
--     dLabel.Text = nText or "Message here..."
--     dLabel.TextColor3 = Theme.Text
--     dLabel.Font = Enum.Font.Gotham
--     dLabel.TextSize = 12
--     dLabel.BackgroundTransparency = 1
--     dLabel.TextXAlignment = Enum.TextXAlignment.Left
--     dLabel.TextWrapped = true

--     -- Animation: เลื่อนเข้ามาในจอ
--     ApplyTween(nFrame, {Position = UDim2.new(1, -275, 1, -80)}, 0.4)

--     -- รอเวลาตามที่กำหนดแล้วเลื่อนออก
--     task.delay(duration or 4, function()
--         local outTween = ApplyTween(nFrame, {Position = UDim2.new(1, 10, 1, -80)}, 0.4)
--         outTween.Completed:Wait()
--         nFrame:Destroy()
--     end)
-- end

    logoButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    return XDLuaUI
end

return XDLuaUI
