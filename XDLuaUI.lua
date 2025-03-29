local XDLuaUI = {}

-- บริการที่ใช้
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ฟังก์ชันสร้าง Tween
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

-- สร้างหน้าต่างหลัก
function XDLuaUI:CreateWindow(title, emojiFront, emojiBack, spacing)
    -- ลบ GUI เดิมหากมีอยู่
    if game.CoreGui:FindFirstChild("XDLuaGUI") then
        game.CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    -- สร้าง ScreenGui
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaGUI"

    -- สร้างหน้าจอโหลด
    local loadingFrame = Instance.new("Frame", screenGui)
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    loadingFrame.BackgroundTransparency = 0

    local loadingLabel = Instance.new("TextLabel", loadingFrame)
    loadingLabel.Size = UDim2.new(0, 200, 0, 50)
    loadingLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
    loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingLabel.Text = "กำลังโหลด..."
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Font = Enum.Font.GothamBold
    loadingLabel.TextSize = 20

    local loadingBarFrame = Instance.new("Frame", loadingFrame)
    loadingBarFrame.Size = UDim2.new(0, 300, 0, 20)
    loadingBarFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadingBarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    loadingBarFrame.BorderSizePixel = 0

    local loadingBarCorner = Instance.new("UICorner", loadingBarFrame)
    loadingBarCorner.CornerRadius = UDim.new(0, 10)

    local loadingBar = Instance.new("Frame", loadingBarFrame)
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
    loadingBar.BorderSizePixel = 0

    local loadingBarCornerInner = Instance.new("UICorner", loadingBar)
    loadingBarCornerInner.CornerRadius = UDim.new(0, 10)

    -- อะนิเมชันจุดในข้อความ "กำลังโหลด..."
    local dots = 0
    local function updateLoadingText()
        dots = (dots + 1) % 4
        loadingLabel.Text = "กำลังโหลด" .. string.rep(".", dots)
    end

    -- เริ่มอะนิเมชันโหลด
    local loadingTween = createTween(loadingBar, {Size = UDim2.new(1, 0, 1, 0)}, 2)
    loadingTween:Play()

    -- อัปเดตข้อความโหลดทุก 0.5 วินาที
    local loadingTextConnection
    loadingTextConnection = game:GetService("RunService").Heartbeat:Connect(function()
        updateLoadingText()
    end)

    -- รอให้โหลดเสร็จ
    loadingTween.Completed:Wait()
    loadingTextConnection:Disconnect()

    -- อะนิเมชัน Fade Out หน้าจอโหลด
    local fadeOutTween = createTween(loadingFrame, {BackgroundTransparency = 1}, 0.5)
    for _, child in pairs(loadingFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            createTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.5):Play()
        end
    end
    fadeOutTween:Play()
    fadeOutTween.Completed:Wait()
    loadingFrame:Destroy()

    -- สร้างปุ่มโลโก้ (ปุ่มเปิด/ปิด UI)
    local logoButton = Instance.new("TextButton", screenGui)
    logoButton.Size = UDim2.new(0, 50, 0, 50)
    logoButton.Position = UDim2.new(0.02, 0, 0.5, -25)
    logoButton.Text = "👾"
    logoButton.TextColor3 = Color3.fromRGB(0, 255, 255)
    logoButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    logoButton.BackgroundTransparency = 0.2
    logoButton.BorderSizePixel = 0
    logoButton.Font = Enum.Font.GothamBold
    logoButton.TextSize = 24
    logoButton.Draggable = true
    logoButton.AutoButtonColor = false

    local uiCorner = Instance.new("UICorner", logoButton)
    uiCorner.CornerRadius = UDim.new(0, 12)

    -- สร้างเฟรมหลัก
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 450, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BackgroundTransparency = 1 -- เริ่มต้นโปร่งใส
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true

    local glowMain = Instance.new("UIStroke", mainFrame)
    glowMain.Thickness = 4
    glowMain.Color = Color3.fromRGB(255, 50, 255)
    glowMain.Transparency = 1

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 12)

    -- เพิ่มข้อความหัวเรื่อง
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    
    -- จัดการอิโมจิใน Title
    local emojiFront = emojiFront or ""
    local emojiBack = emojiBack or ""
    local spacing = spacing or 2
    local spacingStr = string.rep(" ", spacing)
    
    local titleText = title or "XDLua UI"
    if emojiFront ~= "" and emojiBack ~= "" then
        titleLabel.Text = emojiFront .. spacingStr .. titleText .. spacingStr .. emojiBack
    elseif emojiFront ~= "" then
        titleLabel.Text = emojiFront .. spacingStr .. titleText
    elseif emojiBack ~= "" then
        titleLabel.Text = titleText .. spacingStr .. emojiBack
    else
        titleLabel.Text = titleText
    end

    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 20
    titleLabel.TextStrokeTransparency = 0.2
    titleLabel.TextTransparency = 1

    -- สร้างปุ่มฟันเฟือง (แทนปุ่ม X)
    local settingsButton = Instance.new("TextButton", mainFrame)
    settingsButton.Size = UDim2.new(0, 30, 0, 30)
    settingsButton.Position = UDim2.new(1, -40, 0, 5)
    settingsButton.Text = "⚙️"
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    settingsButton.Font = Enum.Font.GothamBold
    settingsButton.TextSize = 16
    settingsButton.BackgroundTransparency = 1
    settingsButton.TextTransparency = 1
    local settingsCorner = Instance.new("UICorner", settingsButton)
    settingsCorner.CornerRadius = UDim.new(0, 8)

    -- สร้างเฟรมแท็บ
    local tabFrame = Instance.new("Frame", mainFrame)
    tabFrame.Size = UDim2.new(0, 120, 1, -50)
    tabFrame.Position = UDim2.new(0, 10, 0, 45)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabFrame.BackgroundTransparency = 1

    local tabCorner = Instance.new("UICorner", tabFrame)
    tabCorner.CornerRadius = UDim.new(0, 8)

    -- สร้าง ScrollingFrame สำหรับแท็บ
    local tabScrollingFrame = Instance.new("ScrollingFrame", tabFrame)
    tabScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    tabScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    tabScrollingFrame.BackgroundTransparency = 1
    tabScrollingFrame.ScrollBarThickness = 4
    tabScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    tabScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never

    local tabListLayout = Instance.new("UIListLayout", tabScrollingFrame)
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local tabPadding = Instance.new("UIPadding", tabScrollingFrame)
    tabPadding.PaddingTop = UDim.new(0, 10)

    -- สร้างเฟรมเนื้อหา
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -140, 1, -50)
    contentFrame.Position = UDim2.new(0, 135, 0, 45)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0

    local contentCorner = Instance.new("UICorner", contentFrame)
    contentCorner.CornerRadius = UDim.new(0, 10)

    -- สร้าง ScrollingFrame สำหรับเนื้อหา
    local contentScrollingFrame = Instance.new("ScrollingFrame", contentFrame)
    contentScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    contentScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    contentScrollingFrame.BackgroundTransparency = 1
    contentScrollingFrame.ScrollBarThickness = 4
    contentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    contentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    contentScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never

    local contentListLayout = Instance.new("UIListLayout", contentScrollingFrame)
    contentListLayout.Padding = UDim.new(0, 10)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- สร้างเฟรมสำหรับหน้า "ตั้งค่า"
    local settingsFrame = Instance.new("Frame", contentScrollingFrame)
    settingsFrame.Size = UDim2.new(1, 0, 0, 0)
    settingsFrame.Name = "Settings"
    settingsFrame.Visible = false
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.AutomaticSize = Enum.AutomaticSize.Y

    local settingsLayout = Instance.new("UIListLayout", settingsFrame)
    settingsLayout.Padding = UDim.new(0, 10)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local settingsLabel = Instance.new("TextLabel", settingsFrame)
    settingsLabel.Size = UDim2.new(0.9, 0, 0, 40)
    settingsLabel.AnchorPoint = Vector2.new(0.5, 0)
    settingsLabel.Text = "การตั้งค่า"
    settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 14
    settingsLabel.TextWrapped = true
    settingsLabel.TextTransparency = 1

    -- ตัวแปรเก็บแท็บและเนื้อหา
    local tabs = {}
    local selectedTab = nil
    local settingsVisible = false

    -- ฟังก์ชันสลับแท็บ
    local function switchTab(tabIndex)
        if selectedTab then
            selectedTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            if selectedTab.Button:FindFirstChild("Stroke") then
                selectedTab.Button:FindFirstChild("Stroke").Transparency = 1
            end
        end
        selectedTab = tabs[tabIndex]
        selectedTab.Button.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
        if selectedTab.Button:FindFirstChild("Stroke") then
            selectedTab.Button:FindFirstChild("Stroke").Transparency = 0.2
        end
        for _, tab in pairs(tabs) do
            -- อะนิเมชัน Fade Out
            createTween(tab.Content, {BackgroundTransparency = 1}, 0.3):Play()
            for _, child in pairs(tab.Content:GetDescendants()) do
                if child:IsA("GuiObject") then
                    createTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3):Play()
                end
            end
            tab.Content.Visible = false
        end
        settingsFrame.Visible = false
        settingsVisible = false
        selectedTab.Content.Visible = true
        -- อะนิเมชัน Fade In
        createTween(selectedTab.Content, {BackgroundTransparency = 0.5}, 0.3):Play()
        for _, child in pairs(selectedTab.Content:GetDescendants()) do
            if child:IsA("GuiObject") then
                createTween(child, {BackgroundTransparency = child.BackgroundTransparency == 1 and 1 or 0, TextTransparency = 0}, 0.3):Play()
            end
        end
    end

    -- ฟังก์ชันสลับไปหน้า "ตั้งค่า"
    local function toggleSettings()
        settingsVisible = not settingsVisible
        if settingsVisible then
            for _, tab in pairs(tabs) do
                createTween(tab.Content, {BackgroundTransparency = 1}, 0.3):Play()
                for _, child in pairs(tab.Content:GetDescendants()) do
                    if child:IsA("GuiObject") then
                        createTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3):Play()
                    end
                end
                tab.Content.Visible = false
            end
            if selectedTab then
                selectedTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                if selectedTab.Button:FindFirstChild("Stroke") then
                    selectedTab.Button:FindFirstChild("Stroke").Transparency = 1
                end
                selectedTab = nil
            end
            settingsFrame.Visible = true
            createTween(settingsFrame, {BackgroundTransparency = 0.5}, 0.3):Play()
            for _, child in pairs(settingsFrame:GetDescendants()) do
                if child:IsA("GuiObject") then
                    createTween(child, {BackgroundTransparency = child.BackgroundTransparency == 1 and 1 or 0, TextTransparency = 0}, 0.3):Play()
                end
            end
        else
            createTween(settingsFrame, {BackgroundTransparency = 1}, 0.3):Play()
            for _, child in pairs(settingsFrame:GetDescendants()) do
                if child:IsA("GuiObject") then
                    createTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3):Play()
                end
            end
            settingsFrame.Visible = false
            if tabs[1] then
                switchTab(1)
            end
        end
    end

    -- เพิ่มการทำงานให้ปุ่มฟันเฟือง
    settingsButton.MouseButton1Click:Connect(toggleSettings)

    -- เมธอดเพิ่มแท็บ
    function XDLuaUI:AddTab(tabName, emoji, emojiPosition)
        local tabIndex = #tabs + 1

        local tabButton = Instance.new("TextButton", tabScrollingFrame)
        tabButton.Size = UDim2.new(0.9, 0, 0, 40)
        tabButton.AnchorPoint = Vector2.new(0.5, 0)
        
        local emoji = emoji or ""
        local emojiPosition = emojiPosition or "front"
        if emoji ~= "" then
            if emojiPosition == "back" then
                tabButton.Text = tabName .. " " .. emoji
            else
                tabButton.Text = emoji .. " " .. tabName
            end
        else
            tabButton.Text = tabName
        end

        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.BackgroundTransparency = 1
        tabButton.TextTransparency = 1
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabIndex)
        end)

        local buttonGlow = Instance.new("UIStroke", tabButton)
        buttonGlow.Name = "Stroke"
        buttonGlow.Thickness = 2
        buttonGlow.Color = Color3.fromRGB(255, 50, 255)
        buttonGlow.Transparency = 1

        local tabCorner = Instance.new("UICorner", tabButton)
        tabCorner.CornerRadius = UDim.new(0, 5)

        local tabContent = Instance.new("Frame", contentScrollingFrame)
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.Name = "Tab" .. tabIndex
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.AutomaticSize = Enum.AutomaticSize.Y

        local tabContentLayout = Instance.new("UIListLayout", tabContent)
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        tabs[tabIndex] = {
            Button = tabButton,
            Content = tabContent
        }

        if tabIndex == 1 then
            switchTab(1)
        end

        return tabContent
    end

    -- เมธอดแก้ไข Title
    function XDLuaUI:SetTitle(newTitle, emojiFront, emojiBack, spacing)
        local emojiFront = emojiFront or ""
        local emojiBack = emojiBack or ""
        local spacing = spacing or 2
        local spacingStr = string.rep(" ", spacing)
        
        if emojiFront ~= "" and emojiBack ~= "" then
            titleLabel.Text = emojiFront .. spacingStr .. newTitle .. spacingStr .. emojiBack
        elseif emojiFront ~= "" then
            titleLabel.Text = emojiFront .. spacingStr .. newTitle
        elseif emojiBack ~= "" then
            titleLabel.Text = newTitle .. spacingStr .. emojiBack
        else
            titleLabel.Text = newTitle
        end
    end

    -- เมธอดเพิ่มปุ่มปกติ
    function XDLuaUI:AddButton(tabContent, buttonText, callback)
        local button = Instance.new("TextButton", tabContent)
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.AnchorPoint = Vector2.new(0.5, 0)
        button.Text = buttonText
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 1
        button.TextTransparency = 1

        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, 8)

        button.MouseButton1Click:Connect(callback)
    end

    -- เมธอดเพิ่มปุ่มเปิด/ปิด (Toggle)
    function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        local toggleButton = Instance.new("TextButton", tabContent)
        toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        toggleButton.AnchorPoint = Vector2.new(0.5, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        toggleButton.Text = ""
        toggleButton.BackgroundTransparency = 1

        local toggleCorner = Instance.new("UICorner", toggleButton)
        toggleCorner.CornerRadius = UDim.new(0, 8)

        local contentFrame = Instance.new("Frame", toggleButton)
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.Position = UDim2.new(0, 0, 0, 0)
        contentFrame.BackgroundTransparency = 1

        local switchFrame = Instance.new("Frame", contentFrame)
        switchFrame.Size = UDim2.new(0, 40, 0, 20)
        switchFrame.Position = UDim2.new(0, 5, 0.5, 0)
        switchFrame.AnchorPoint = Vector2.new(0, 0.5)
        switchFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        switchFrame.BorderSizePixel = 0
        switchFrame.BackgroundTransparency = 1

        local switchCorner = Instance.new("UICorner", switchFrame)
        switchCorner.CornerRadius = UDim.new(1, 0)

        local switchHandle = Instance.new("TextButton", switchFrame)
        switchHandle.Size = UDim2.new(0, 16, 0, 16)
        switchHandle.Position = UDim2.new(1, -18, 0.5, 0)
        switchHandle.AnchorPoint = Vector2.new(0, 0.5)
        switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchHandle.BorderSizePixel = 0
        switchHandle.Text = ""
        switchHandle.BackgroundTransparency = 1

        local handleCorner = Instance.new("UICorner", switchHandle)
        handleCorner.CornerRadius = UDim.new(1, 0)

        local textLabel = Instance.new("TextLabel", contentFrame)
        textLabel.Size = UDim2.new(0, 0, 0, 20)
        textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = toggleText
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 14
        textLabel.AutomaticSize = Enum.AutomaticSize.X
        textLabel.TextTransparency = 1

        local isToggled = defaultState or false
        if isToggled then
            switchHandle.Position = UDim2.new(0, 2, 0.5, 0)
            switchHa
