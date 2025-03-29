-- XDLuaUIScript.lua
local XDLuaUIScript = {}

-- บริการที่ใช้
local TweenService = game:GetService("TweenService")

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

-- สร้างหน้าต่างหลักสำหรับรันสคริปต์ (ไม่มีหน้าโหลด)
function XDLuaUIScript:CreateWindow(title, emojiFront, emojiBack, spacing)
    -- ลบ GUI เดิมหากมีอยู่
    if game.CoreGui:FindFirstChild("XDLuaScriptGUI") then
        game.CoreGui:FindFirstChild("XDLuaScriptGUI"):Destroy()
    end

    -- สร้าง ScreenGui
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaScriptGUI"

    -- สร้างปุ่มโลโก้ (แยกจาก UI หลัก)
    local logoButton = Instance.new("TextButton", screenGui)
    logoButton.Size = UDim2.new(0, 50, 0, 50)
    logoButton.Position = UDim2.new(0.02, 0, 0.6, -25) -- ปรับตำแหน่งให้ไม่ทับกับ UI หลัก
    logoButton.Text = "💻"
    logoButton.TextColor3 = Color3.fromRGB(50, 255, 255)
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
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true

    local glowMain = Instance.new("UIStroke", mainFrame)
    glowMain.Thickness = 4
    glowMain.Color = Color3.fromRGB(50, 255, 255)
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
    
    local titleText = title or "XDLua Script UI"
    if emojiFront ~= "" and emojiBack ~= "" then
        titleLabel.Text = emojiFront .. spacingStr .. titleText .. spacingStr .. emojiBack
    elseif emojiFront ~= "" then
        titleLabel.Text = emojiFront .. spacingStr .. titleText
    elseif emojiBack ~= "" then
        titleLabel.Text = titleText .. spacingStr .. emojiBack
    else
        titleLabel.Text = titleText
    end

    titleLabel.TextColor3 = Color3.fromRGB(50, 255, 255)
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
    settingsButton.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
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
    tabScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 255, 255)
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
    contentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 255, 255)
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
        selectedTab.Button.BackgroundColor3 = Color3.fromRGB(0, 80, 80)
        if selectedTab.Button:FindFirstChild("Stroke") then
            selectedTab.Button:FindFirstChild("Stroke").Transparency = 0.2
        end
        for _, tab in pairs(tabs) do
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
    function XDLuaUIScript:AddTab(tabName, emoji, emojiPosition)
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
        buttonGlow.Color = Color3.fromRGB(50, 255, 255)
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
    function XDLuaUIScript:SetTitle(newTitle, emojiFront, emojiBack, spacing)
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

    -- เมธอดเพิ่มแท็บสคริปต์
    function XDLuaUIScript:AddScriptTab(tabName, scriptName, scriptDescription, scriptUrl)
        local tabContent = self:AddTab(tabName)

        local scriptNameLabel = Instance.new("TextLabel", tabContent)
        scriptNameLabel.Size = UDim2.new(0.9, 0, 0, 30)
        scriptNameLabel.AnchorPoint = Vector2.new(0.5, 0)
        scriptNameLabel.Text = "ชื่อ: " .. scriptName
        scriptNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptNameLabel.BackgroundTransparency = 1
        scriptNameLabel.Font = Enum.Font.GothamBold
        scriptNameLabel.TextSize = 14
        scriptNameLabel.TextWrapped = true
        scriptNameLabel.TextTransparency = 1

        local scriptDescLabel = Instance.new("TextLabel", tabContent)
        scriptDescLabel.Size = UDim2.new(0.9, 0, 0, 50)
        scriptDescLabel.AnchorPoint = Vector2.new(0.5, 0)
        scriptDescLabel.Text = "คำอธิบาย: " .. scriptDescription
        scriptDescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptDescLabel.BackgroundTransparency = 1
        scriptDescLabel.Font = Enum.Font.GothamBold
        scriptDescLabel.TextSize = 12
        scriptDescLabel.TextWrapped = true
        scriptDescLabel.TextTransparency = 1

        local runButton = Instance.new("TextButton", tabContent)
        runButton.Size = UDim2.new(0.9, 0, 0, 30)
        runButton.AnchorPoint = Vector2.new(0.5, 0)
        runButton.Text = "รันสคริปต์"
        runButton.BackgroundColor3 = Color3.fromRGB(0, 204, 0)
        runButton.Font = Enum.Font.GothamBold
        runButton.TextSize = 14
        runButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        runButton.BackgroundTransparency = 1
        runButton.TextTransparency = 1

        local runButtonCorner = Instance.new("UICorner", runButton)
        runButtonCorner.CornerRadius = UDim.new(0, 8)

        runButton.MouseButton1Click:Connect(function()
            local success, err = pcall(function()
                local scriptContent = game:HttpGet(scriptUrl)
                local scriptFunc = loadstring(scriptContent)
                scriptFunc()
            end)
            if success then
                game:GetService(" StarterGui"):SetCore("SendNotification", {
                    Title = "รันสคริปต์",
                    Text = "รันสคริปต์สำเร็จ!",
                    Duration = 3
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "ข้อผิดพลาด",
                    Text = "รันสคริปต์ล้มเหลว: " .. tostring(err),
                    Duration = 3
                })
            end
        end)

        local copyButton = Instance.new("TextButton", tabContent)
        copyButton.Size = UDim2.new(0.9, 0, 0, 30)
        copyButton.AnchorPoint = Vector2.new(0.5, 0)
        copyButton.Text = "คัดลอกสคริปต์"
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        copyButton.Font = Enum.Font.GothamBold
        copyButton.TextSize = 14
        copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyButton.BackgroundTransparency = 1
        copyButton.TextTransparency = 1

        local copyButtonCorner = Instance.new("UICorner", copyButton)
        copyButtonCorner.CornerRadius = UDim.new(0, 8)

        copyButton.MouseButton1Click:Connect(function()
            setclipboard(scriptUrl)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "คัดลอกลิงค์",
                Text = "คัดลอกลิงค์สคริปต์เรียบร้อยแล้ว!",
                Duration = 3
            })
        end)
    end

    -- เมธอดเพิ่มแท็บ Executor
    function XDLuaUIScript:AddExecutorTab()
        local tabContent = self:AddTab("Executor", "💻", "front")

        local executorLabel = Instance.new("TextLabel", tabContent)
        executorLabel.Size = UDim2.new(0.9, 0, 0, 30)
        executorLabel.AnchorPoint = Vector2.new(0.5, 0)
        executorLabel.Text = "วางลิงค์สคริปต์เพื่อรัน"
        executorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        executorLabel.BackgroundTransparency = 1
        executorLabel.Font = Enum.Font.GothamBold
        executorLabel.TextSize = 14
        executorLabel.TextWrapped = true
        executorLabel.TextTransparency = 1

        local scriptUrlBox = Instance.new("TextBox", tabContent)
        scriptUrlBox.Size = UDim2.new(0.9, 0, 0, 30)
        scriptUrlBox.AnchorPoint = Vector2.new(0.5, 0)
        scriptUrlBox.Text = "วางลิงค์สคริปต์ที่นี่"
        scriptUrlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptUrlBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        scriptUrlBox.Font = Enum.Font.GothamBold
        scriptUrlBox.TextSize = 14
        scriptUrlBox.ClearTextOnFocus = true
        scriptUrlBox.TextWrapped = true
        scriptUrlBox.BackgroundTransparency = 1
        scriptUrlBox.TextTransparency = 1

        local scriptUrlBoxCorner = Instance.new("UICorner", scriptUrlBox)
        scriptUrlBoxCorner.CornerRadius = UDim.new(0, 8)

        local executeButton = Instance.new("TextButton", tabContent)
        executeButton.Size = UDim2.new(0.9, 0, 0, 30)
        executeButton.AnchorPoint = Vector2.new(0.5, 0)
        executeButton.Text = "รันสคริปต์"
        executeButton.BackgroundColor3 = Color3.fromRGB(0, 204, 0)
        executeButton.Font = Enum.Font.GothamBold
        executeButton.TextSize = 14
        executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        executeButton.BackgroundTransparency = 1
        executeButton.TextTransparency = 1

        local executeButtonCorner = Instance.new("UICorner", executeButton)
        executeButtonCorner.CornerRadius = UDim.new(0, 8)

        executeButton.MouseButton1Click:Connect(function()
            local scriptUrl = scriptUrlBox.Text:match("^%s*(.-)%s*$")
            if scriptUrl == "" or scriptUrl == "วางลิงค์สคริปต์ที่นี่" then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "ข้อผิดพลาด",
                    Text = "กรุณาวางลิงค์สคริปต์ที่ถูกต้อง!",
                    Duration = 3
                })
                return
            end

            if not scriptUrl:match("^https?://") then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "ข้อผิดพลาด",
                    Text = "ลิงค์ไม่ถูกต้อง! ต้องเริ่มต้นด้วย http:// หรือ https://",
                    Duration = 3
                })
                return
            end

            local success, err = pcall(function()
                local scriptContent = game:HttpGet(scriptUrl, true)
                if not scriptContent or scriptContent == "" then
                    error("ไม่สามารถดึงเนื้อหาสคริปต์ได้")
                end
                local scriptFunc = loadstring(scriptContent)
                if not scriptFunc then
                    error("ไม่สามารถโหลดสคริปต์ได้")
                end
                scriptFunc()
            end)

            if success then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "รันสคริปต์",
                    Text = "รันสคริปต์สำเร็จ!",
                    Duration = 3
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "ข้อผิดพลาด",
                    Text = "รันสคริปต์ล้มเหลว: " .. tostring(err),
                    Duration = 5
                })
            end
        end)

        local clearButton = Instance.new("TextButton", tabContent)
        clearButton.Size = UDim2.new(0.9, 0, 0, 30)
        clearButton.AnchorPoint = Vector2.new(0.5, 0)
        clearButton.Text = "ล้างช่อง"
        clearButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        clearButton.Font = Enum.Font.GothamBold
        clearButton.TextSize = 14
        clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        clearButton.BackgroundTransparency = 1
        clearButton.TextTransparency = 1

        local clearButtonCorner = Instance.new("UICorner", clearButton)
        clearButtonCorner.CornerRadius = UDim.new(0, 8)

        clearButton.MouseButton1Click:Connect(function()
            scriptUrlBox.Text = "วางลิงค์สคริปต์ที่นี่"
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ล้างช่อง",
                Text = "ล้างช่องเรียบร้อยแล้ว!",
                Duration = 3
            })
        end)
  end

  -- อะนิเมชันเปิด/ปิด UI
    local function toggleUI()
        if mainFrame.Visible then
            createTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In):Play()
            for _, child in pairs(mainFrame:GetDescendants()) do
                if child:IsA("GuiObject") then
                    createTween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In):Play()
                end
            end
            wait(0.5)
            mainFrame.Visible = false
        else
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            createTween(mainFrame, {Size = UDim2.new(0, 450, 0, 300), BackgroundTransparency = 0.3}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
            createTween(glowMain, {Transparency = 0.1}, 0.5):Play()
            for _, child in pairs(mainFrame:GetDescendants()) do
                if child:IsA("GuiObject") then
                    createTween(child, {BackgroundTransparency = child.BackgroundTransparency == 1 and 1 or 0, TextTransparency = 0}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
                end
            end
        end
    end

    -- คลิกปุ่มโลโก้เพื่อแสดง/ซ่อนเฟรมหลัก
    logoButton.MouseButton1Click:Connect(toggleUI)

    return XDLuaUIScript
end

return XDLuaUIScript
