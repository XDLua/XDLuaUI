-- UI Library
local XDLuaUI = {}

-- สร้างหน้าต่างหลัก
function XDLuaUI:CreateWindow(title)
    -- ลบ GUI เดิมหากมีอยู่
    if game.CoreGui:FindFirstChild("XDLuaGUI") then
        game.CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    -- สร้าง ScreenGui
    local CoreGui = game:GetService("CoreGui")
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaGUI"

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
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true

    local glowMain = Instance.new("UIStroke", mainFrame)
    glowMain.Thickness = 4
    glowMain.Color = Color3.fromRGB(255, 50, 255)
    glowMain.Transparency = 0.1

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 12)

    -- เพิ่มข้อความหัวเรื่อง
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Text = title or "🔹 XDLua UI 🔹"
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 20
    titleLabel.TextStrokeTransparency = 0.2

    -- สร้างปุ่มฟันเฟือง (แทนปุ่ม X)
    local settingsButton = Instance.new("TextButton", mainFrame)
    settingsButton.Size = UDim2.new(0, 30, 0, 30)
    settingsButton.Position = UDim2.new(1, -40, 0, 5)
    settingsButton.Text = "⚙️"
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    settingsButton.Font = Enum.Font.GothamBold
    settingsButton.TextSize = 16
    local settingsCorner = Instance.new("UICorner", settingsButton)
    settingsCorner.CornerRadius = UDim.new(0, 8)

    -- สร้างเฟรมแท็บ
    local tabFrame = Instance.new("Frame", mainFrame)
    tabFrame.Size = UDim2.new(0, 120, 1, -50)
    tabFrame.Position = UDim2.new(0, 10, 0, 45)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

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

    -- เพิ่ม UIPadding เพื่อให้ปุ่มแท็บไม่ชิดบนสุด
    local tabPadding = Instance.new("UIPadding", tabScrollingFrame)
    tabPadding.PaddingTop = UDim.new(0, 10)

    -- สร้างเฟรมเนื้อหา
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -140, 1, -50)
    contentFrame.Position = UDim2.new(0, 135, 0, 45)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    contentFrame.BackgroundTransparency = 0.5
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

    -- เพิ่มคำอธิบายในหน้า "ตั้งค่า"
    local settingsLabel = Instance.new("TextLabel", settingsFrame)
    settingsLabel.Size = UDim2.new(0.9, 0, 0, 40)
    settingsLabel.AnchorPoint = Vector2.new(0.5, 0)
    settingsLabel.Text = "การตั้งค่า"
    settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 14
    settingsLabel.TextWrapped = true

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
            tab.Content.Visible = false
        end
        settingsFrame.Visible = false
        settingsVisible = false
        selectedTab.Content.Visible = true
    end

    -- ฟังก์ชันสลับไปหน้า "ตั้งค่า"
    local function toggleSettings()
        settingsVisible = not settingsVisible
        if settingsVisible then
            for _, tab in pairs(tabs) do
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
        else
            settingsFrame.Visible = false
            if tabs[1] then
                switchTab(1) -- กลับไปที่แท็บแรกถ้าไม่มีแท็บที่เลือก
            end
        end
    end

    -- เพิ่มการทำงานให้ปุ่มฟันเฟือง
    settingsButton.MouseButton1Click:Connect(toggleSettings)

    -- เมธอดเพิ่มแท็บ
    function XDLuaUI:AddTab(tabName)
        local tabIndex = #tabs + 1

        local tabButton = Instance.new("TextButton", tabScrollingFrame)
        tabButton.Size = UDim2.new(0.9, 0, 0, 40)
        tabButton.AnchorPoint = Vector2.new(0.5, 0)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
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

        -- สร้างเฟรมเนื้อหาแท็บ
        local tabContent = Instance.new("Frame", contentScrollingFrame)
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.Name = "Tab" .. tabIndex
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.AutomaticSize = Enum.AutomaticSize.Y

        -- เพิ่ม UIListLayout ใน tabContent เพื่อจัดการตำแหน่งขององค์ประกอบภายใน
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

    -- เมธอดเพิ่มแท็บสคริปต์
    function XDLuaUI:AddScriptTab(tabName, scriptName, scriptDescription, scriptUrl)
        local tabContent = XDLuaUI:AddTab(tabName)

        -- เพิ่มชื่อสคริปต์
        local scriptNameLabel = Instance.new("TextLabel", tabContent)
        scriptNameLabel.Size = UDim2.new(0.9, 0, 0, 30)
        scriptNameLabel.AnchorPoint = Vector2.new(0.5, 0)
        scriptNameLabel.Text = "ชื่อ: " .. scriptName
        scriptNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptNameLabel.BackgroundTransparency = 1
        scriptNameLabel.Font = Enum.Font.GothamBold
        scriptNameLabel.TextSize = 14
        scriptNameLabel.TextWrapped = true

        -- เพิ่มคำอธิบายสคริปต์
        local scriptDescLabel = Instance.new("TextLabel", tabContent)
        scriptDescLabel.Size = UDim2.new(0.9, 0, 0, 50)
        scriptDescLabel.AnchorPoint = Vector2.new(0.5, 0)
        scriptDescLabel.Text = "คำอธิบาย: " .. scriptDescription
        scriptDescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptDescLabel.BackgroundTransparency = 1
        scriptDescLabel.Font = Enum.Font.GothamBold
        scriptDescLabel.TextSize = 12
        scriptDescLabel.TextWrapped = true

        -- ปุ่มรันสคริปต์
        local runButton = Instance.new("TextButton", tabContent)
        runButton.Size = UDim2.new(0.9, 0, 0, 30)
        runButton.AnchorPoint = Vector2.new(0.5, 0)
        runButton.Text = "รันสคริปต์"
        runButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        runButton.Font = Enum.Font.GothamBold
        runButton.TextSize = 14
        runButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        local runButtonCorner = Instance.new("UICorner", runButton)
        runButtonCorner.CornerRadius = UDim.new(0, 8)

        runButton.MouseButton1Click:Connect(function()
            local success, err = pcall(function()
                local scriptContent = game:HttpGet(scriptUrl)
                local scriptFunc = loadstring(scriptContent)
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
                    Duration = 3
                })
            end
        end)

        -- ปุ่มคัดลอกลิงค์สคริปต์
        local copyButton = Instance.new("TextButton", tabContent)
        copyButton.Size = UDim2.new(0.9, 0, 0, 30)
        copyButton.AnchorPoint = Vector2.new(0.5, 0)
        copyButton.Text = "คัดลอกลิงค์สคริปต์"
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        copyButton.Font = Enum.Font.GothamBold
        copyButton.TextSize = 14
        copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

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
    function XDLuaUI:AddExecutorTab()
        local tabContent = XDLuaUI:AddTab("Executor")

        -- เพิ่มคำอธิบาย
        local executorLabel = Instance.new("TextLabel", tabContent)
        executorLabel.Size = UDim2.new(0.9, 0, 0, 30)
        executorLabel.AnchorPoint = Vector2.new(0.5, 0)
        executorLabel.Text = "วางลิงค์สคริปต์เพื่อรัน"
        executorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        executorLabel.BackgroundTransparency = 1
        executorLabel.Font = Enum.Font.GothamBold
        executorLabel.TextSize = 14
        executorLabel.TextWrapped = true

        -- เพิ่ม TextBox สำหรับวางลิงค์
        local scriptUrlBox = Instance.new("TextBox", tabContent)
        scriptUrlBox.Size = UDim2.new(0.9, 0, 0, 30)
        scriptUrlBox.AnchorPoint = Vector2.new(0.5, 0)
        scriptUrlBox.Text = "วางลิงค์สคริปต์ที่นี่"
        scriptUrlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptUrlBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        scriptUrlBox.Font = Enum.Font.GothamBold
        scriptUrlBox.TextSize = 14
        scriptUrlBox.ClearTextOnFocus = true

        local scriptUrlBoxCorner = Instance.new("UICorner", scriptUrlBox)
        scriptUrlBoxCorner.CornerRadius = UDim.new(0, 8)

        -- ปุ่มรันสคริปต์จากลิงค์
        local executeButton = Instance.new("TextButton", tabContent)
        executeButton.Size = UDim2.new(0.9, 0, 0, 30)
        executeButton.AnchorPoint = Vector2.new(0.5, 0)
        executeButton.Text = "รันสคริปต์"
        executeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        executeButton.Font = Enum.Font.GothamBold
        executeButton.TextSize = 14
        executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        local executeButtonCorner = Instance.new("UICorner", executeButton)
        executeButtonCorner.CornerRadius = UDim.new(0, 8)

        executeButton.MouseButton1Click:Connect(function()
            local scriptUrl = scriptUrlBox.Text
            if scriptUrl == "" or scriptUrl == "วางลิงค์สคริปต์ที่นี่" then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "ข้อผิดพลาด",
                    Text = "กรุณาวางลิงค์สคริปต์!",
                    Duration = 3
                })
                return
            end

            local success, err = pcall(function()
                local scriptContent = game:HttpGet(scriptUrl)
                local scriptFunc = loadstring(scriptContent)
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
                    Duration = 3
                })
            end
        end)
    end

    -- เมธอดแก้ไข Title
    function XDLuaUI:SetTitle(newTitle)
        titleLabel.Text = newTitle
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

        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, 8)

        button.MouseButton1Click:Connect(callback)
    end

    -- เมธอดเพิ่มปุ่มเปิด/ปิด (Toggle) โดยสวิตช์ชิดซ้ายและข้อความอยู่ตรงกลาง
    function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        local toggleButton = Instance.new("TextButton", tabContent)
        toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        toggleButton.AnchorPoint = Vector2.new(0.5, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        toggleButton.Text = ""

        local toggleCorner = Instance.new("UICorner", toggleButton)
        toggleCorner.CornerRadius = UDim.new(0, 8)

        -- สร้าง Frame เพื่อจัดวางสวิตช์และข้อความ
        local contentFrame = Instance.new("Frame", toggleButton)
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.Position = UDim2.new(0, 0, 0, 0)
        contentFrame.BackgroundTransparency = 1

        -- สร้างสวิตช์กราฟิก (ชิดซ้าย)
        local switchFrame = Instance.new("Frame", contentFrame)
        switchFrame.Size = UDim2.new(0, 40, 0, 20)
        switchFrame.Position = UDim2.new(0, 5, 0.5, 0)
        switchFrame.AnchorPoint = Vector2.new(0, 0.5)
        switchFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        switchFrame.BorderSizePixel = 0

        local switchCorner = Instance.new("UICorner", switchFrame)
        switchCorner.CornerRadius = UDim.new(1, 0)

        local switchHandle = Instance.new("TextButton", switchFrame)
        switchHandle.Size = UDim2.new(0, 16, 0, 16)
        switchHandle.Position = UDim2.new(1, -18, 0.5, 0)
        switchHandle.AnchorPoint = Vector2.new(0, 0.5)
        switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchHandle.BorderSizePixel = 0
        switchHandle.Text = ""

        local handleCorner = Instance.new("UICorner", switchHandle)
        handleCorner.CornerRadius = UDim.new(1, 0)

        -- สร้าง TextLabel สำหรับข้อความ (อยู่ตรงกลาง)
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

       local isToggled = false
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            if isToggled then
                switchHandle.Position = UDim2.new(0, 2, 0.5, 0)
                switchHandle.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
            else
                switchHandle.Position = UDim2.new(1, -18, 0.5, 0)
                switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            callback(isToggled)
        end)
    end

    -- เมธอดเพิ่มปุ่มคัดลอกลิงค์ YouTube
    function XDLuaUI:Youtube(tabContent, youtubeLink)
        local Youtube = Instance.new("TextButton", tabContent)
        Youtube.Size = UDim2.new(0.9, 0, 0, 30)
        Youtube.AnchorPoint = Vector2.new(0.5, 0)
        Youtube.Text = "📋 คัดลอกลิงค์ YouTube"
        Youtube.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Youtube.Font = Enum.Font.GothamBold
        Youtube.TextSize = 14
        Youtube.TextColor3 = Color3.fromRGB(255, 255, 255)

        local youtubeCorner = Instance.new("UICorner", Youtube)
        youtubeCorner.CornerRadius = UDim.new(0, 8)

        Youtube.MouseButton1Click:Connect(function()
            setclipboard(youtubeLink)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "คัดลอกลิงค์ YouTube",
                Text = "คัดลอกลิงค์เรียบร้อยแล้ว!",
                Duration = 3
            })
        end)
    end

    -- เมธอดเพิ่มปุ่มคัดลอกลิงค์ดิสคอร์ด
    function XDLuaUI:Discord(tabContent)
        local Discord = Instance.new("TextButton", tabContent)
        Discord.Size = UDim2.new(0.9, 0, 0, 30)
        Discord.AnchorPoint = Vector2.new(0.5, 0)
        Discord.Text = "📋 คัดลอกลิงค์ดิสคอร์ด"
        Discord.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        Discord.Font = Enum.Font.GothamBold
        Discord.TextSize = 14
        Discord.TextColor3 = Color3.fromRGB(255, 255, 255)

        local discordCorner = Instance.new("UICorner", Discord)
        discordCorner.CornerRadius = UDim.new(0, 8)

        Discord.MouseButton1Click:Connect(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ขออภัย",
                Text = "ตอนนี้ยังไม่มีกลุ่มดิสครับ",
                Duration = 3
            })
        end)
    end

    -- คลิกปุ่มโลโก้เพื่อแสดง/ซ่อนเฟรมหลัก
    logoButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    return XDLuaUI
end

return XDLuaUI
