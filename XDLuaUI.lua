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

    -- สร้างปุ่มฟันเฟือง
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
    switchFrame.Position = UDim2.new(0, 5, 0.5, 0) -- ชิดซ้าย ห่างจากขอบ 5 พิกเซล
    switchFrame.AnchorPoint = Vector2.new(0, 0.5)
    switchFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- พื้นหลังสีเทาเสมอ
    switchFrame.BorderSizePixel = 0

    local switchCorner = Instance.new("UICorner", switchFrame)
    switchCorner.CornerRadius = UDim.new(1, 0)

    local switchHandle = Instance.new("TextButton", switchFrame)
    switchHandle.Size = UDim2.new(0, 16, 0, 16)
    switchHandle.Position = UDim2.new(1, -18, 0.5, 0) -- เริ่มต้นที่ขวา (ปิด)
    switchHandle.AnchorPoint = Vector2.new(0, 0.5)
    switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- วงกลมสีขาวเมื่อปิด
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

    local isToggled = false -- เริ่มต้นเป็น "ปิด" เสมอ
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            switchHandle.Position = UDim2.new(0, 2, 0.5, 0) -- วงกลมเลื่อนไปซ้าย (เปิด)
            switchHandle.BackgroundColor3 = Color3.fromRGB(100, 0, 100) -- วงกลมสีม่วงเมื่อเปิด
        else
            switchHandle.Position = UDim2.new(1, -18, 0.5, 0) -- วงกลมเลื่อนไปขวา (ปิด)
            switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- วงกลมสีขาวเมื่อปิด
        end
        callback(isToggled)
    end)
    end

    -- เมธอดเพิ่มปุ่มสไลด์
    function XDLuaUI:AddSlider(tabContent, sliderText, minValue, maxValue, defaultValue, callback)
        local sliderFrame = Instance.new("Frame", tabContent)
        sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
        sliderFrame.AnchorPoint = Vector2.new(0.5, 0)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BackgroundTransparency = 0.5
        sliderFrame.BorderSizePixel = 0

        local sliderCorner = Instance.new("UICorner", sliderFrame)
        sliderCorner.CornerRadius = UDim.new(0, 8)

        local sliderValueLabel = Instance.new("TextLabel", sliderFrame)
        sliderValueLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderValueLabel.Position = UDim2.new(0, 0, 0, 5)
        sliderValueLabel.Text = sliderText .. ": " .. defaultValue
        sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderValueLabel.BackgroundTransparency = 1
        sliderValueLabel.Font = Enum.Font.GothamBold
        sliderValueLabel.TextSize = 14

        local sliderBar = Instance.new("Frame", sliderFrame)
        sliderBar.Size = UDim2.new(0.9, 0, 0, 4)
        sliderBar.Position = UDim2.new(0.05, 0, 0, 30)
        sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderBar.BorderSizePixel = 0

        local sliderBarCorner = Instance.new("UICorner", sliderBar)
        sliderBarCorner.CornerRadius = UDim.new(0, 5)

        local sliderHandle = Instance.new("TextButton", sliderBar)
        sliderHandle.Size = UDim2.new(0, 12, 0, 12)
        sliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -6, 0, -4)
        sliderHandle.Text = ""
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
        sliderHandle.BorderSizePixel = 0

        local sliderHandleCorner = Instance.new("UICorner", sliderHandle)
        sliderHandleCorner.CornerRadius = UDim.new(0, 10)

        local function updateSlider(value)
            local clampedValue = math.clamp(value, minValue, maxValue)
            sliderValueLabel.Text = sliderText .. ": " .. clampedValue
            local percent = (clampedValue - minValue) / (maxValue - minValue)
            sliderHandle.Position = UDim2.new(percent, -6, 0, -4)
            callback(clampedValue)
        end

        local isDragging = false
        sliderHandle.MouseButton1Down:Connect(function()
            isDragging = true
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local inputPosition = input.UserInputType == Enum.UserInputType.Touch and input.Position or game:GetService("UserInputService"):GetMouseLocation()
                local sliderBarPosition = sliderBar.AbsolutePosition
                local sliderBarSize = sliderBar.AbsoluteSize
                local relativeX = (inputPosition.X - sliderBarPosition.X) / sliderBarSize.X
                local value = math.floor(minValue + (maxValue - minValue) * math.clamp(relativeX, 0, 1))
                updateSlider(value)
            end
        end)
    end

    -- เมธอดเพิ่มคำอธิบายและเครดิต
    function XDLuaUI:AddDescription(tabContent, descriptionText, creditText)
        local descriptionLabel = Instance.new("TextLabel", tabContent)
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 60)
        descriptionLabel.AnchorPoint = Vector2.new(0.5, 0)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true

        local creditLabel = Instance.new("TextLabel", tabContent)
        creditLabel.Size = UDim2.new(0.9, 0, 0, 30)
        creditLabel.AnchorPoint = Vector2.new(0.5, 0)
        creditLabel.Text = creditText
        creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        creditLabel.BackgroundTransparency = 1
        creditLabel.Font = Enum.Font.GothamBold
        creditLabel.TextSize = 12
        creditLabel.TextWrapped = true
    end

    -- เมธอดเพิ่มคำอธิบายของ Tab
    function XDLuaUI:AddTabDescription(tabContent, descriptionText)
        local descriptionLabel = Instance.new("TextLabel", tabContent)
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 40)
        descriptionLabel.AnchorPoint = Vector2.new(0.5, 0)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true
    end

    -- เมธอดเพิ่มปุ่มพร้อมคำอธิบาย
    function XDLuaUI:AddButton2(tabContent, buttonText, descriptionText, callback)
        local descriptionLabel = Instance.new("TextLabel", tabContent)
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 20)
        descriptionLabel.AnchorPoint = Vector2.new(0.5, 0)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 12
        descriptionLabel.TextWrapped = true

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

    -- เมธอดเพิ่ม Toggle พร้อมคำอธิบาย โดยสวิตช์ชิดซ้ายและข้อความอยู่ตรงกลาง
    function XDLuaUI:AddToggle2(tabContent, toggleText, descriptionText, defaultState, callback)
        local descriptionLabel = Instance.new("TextLabel", tabContent)
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 20)
        descriptionLabel.AnchorPoint = Vector2.new(0.5, 0)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 12
        descriptionLabel.TextWrapped = true

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
        switchFrame.BackgroundColor3 = defaultState and Color3.fromRGB(100, 0, 100) or Color3.fromRGB(100, 100, 100)
        switchFrame.BorderSizePixel = 0

        local switchCorner = Instance.new("UICorner", switchFrame)
        switchCorner.CornerRadius = UDim.new(1, 0)

        local switchHandle = Instance.new("TextButton", switchFrame)
        switchHandle.Size = UDim2.new(0, 16, 0, 16)
        switchHandle.Position = defaultState and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
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

        local isToggled = defaultState or false
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            if isToggled then
                switchHandle.Position = UDim2.new(1, -18, 0.5, 0)
                switchFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
            else
                switchHandle.Position = UDim2.new(0, 2, 0.5, 0)
                switchFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
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
