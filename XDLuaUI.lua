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
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XDLuaGUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false -- ป้องกันการรีเซ็ตเมื่อเกิดใหม่

    -- สร้างปุ่มโลโก้
    local logoButton = Instance.new("TextButton")
    logoButton.Parent = screenGui
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

    -- ปรับมุมโค้งของปุ่มโลโก้
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = logoButton

    -- สร้างเฟรมหลัก
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 420, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- เพิ่มเส้นขอบให้เฟรมหลัก
    local glowMain = Instance.new("UIStroke")
    glowMain.Thickness = 2 -- ลดความหนาเพื่อความสวยงาม
    glowMain.Color = Color3.fromRGB(255, 50, 255)
    glowMain.Transparency = 0.1
    glowMain.Parent = mainFrame

    -- ปรับมุมโค้งของเฟรมหลัก
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- เพิ่มปุ่มปิด UI
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = mainFrame
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    -- เพิ่มข้อความหัวเรื่อง
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Text = title or "🔹 XDLua UI 🔹"
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 18
    titleLabel.TextStrokeTransparency = 0.2

    -- สร้างเฟรมแท็บ
    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = mainFrame
    tabFrame.Size = UDim2.new(0, 110, 1, -35)
    tabFrame.Position = UDim2.new(0.01, 0, 0, 35)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabFrame.BackgroundTransparency = 0.2

    -- ปรับมุมโค้งของเฟรมแท็บ
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame

    -- สร้าง ScrollingFrame สำหรับแท็บ
    local tabScrollingFrame = Instance.new("ScrollingFrame")
    tabScrollingFrame.Parent = tabFrame
    tabScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    tabScrollingFrame.BackgroundTransparency = 1
    tabScrollingFrame.ScrollBarThickness = 4
    tabScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- เพิ่ม UIListLayout สำหรับแท็บ
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Parent = tabScrollingFrame
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- อัปเดต CanvasSize ของแท็บอัตโนมัติ
    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y)
    end)

    -- สร้างเฟรมเนื้อหา
    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.Size = UDim2.new(1, -120, 1, -37)
    contentFrame.Position = UDim2.new(0, 117, 0, 35)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    contentFrame.BackgroundTransparency = 0.5
    contentFrame.BorderSizePixel = 0

    -- ปรับมุมโค้งของเฟรมเนื้อหา
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame

    -- สร้าง ScrollingFrame สำหรับเนื้อหา
    local contentScrollingFrame = Instance.new("ScrollingFrame")
    contentScrollingFrame.Parent = contentFrame
    contentScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    contentScrollingFrame.BackgroundTransparency = 1
    contentScrollingFrame.ScrollBarThickness = 4
    contentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- เพิ่ม UIListLayout สำหรับเนื้อหา
    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Parent = contentScrollingFrame
    contentListLayout.Padding = UDim.new(0, 10)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- อัปเดต CanvasSize ของเนื้อหาอัตโนมัติ
    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y)
    end)

    -- ตัวแปรเก็บแท็บและเนื้อหา
    local tabs = {}
    local selectedTab = nil

    -- ฟังก์ชันสลับแท็บ
    local function switchTab(tabIndex)
        if selectedTab then
            selectedTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            selectedTab.Button:FindFirstChild("Stroke").Transparency = 1
        end
        selectedTab = tabs[tabIndex]
        selectedTab.Button.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
        selectedTab.Button:FindFirstChild("Stroke").Transparency = 0.2
        for _, tab in pairs(tabs) do
            tab.Content.Visible = false
        end
        selectedTab.Content.Visible = true
    end

    -- เมธอดเพิ่มแท็บ
    function XDLuaUI:AddTab(tabName)
        local tabIndex = #tabs + 1

        -- สร้างปุ่มแท็บ
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabScrollingFrame
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabIndex)
        end)

        -- เพิ่มเส้นขอบให้ปุ่มแท็บ
        local buttonGlow = Instance.new("UIStroke")
        buttonGlow.Name = "Stroke"
        buttonGlow.Thickness = 2
        buttonGlow.Color = Color3.fromRGB(255, 50, 255)
        buttonGlow.Transparency = 1
        buttonGlow.Parent = tabButton

        -- ปรับมุมโค้งของปุ่มแท็บ
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = tabButton

        -- สร้างเฟรมเนื้อหาแท็บ
        local tabContent = Instance.new("Frame")
        tabContent.Parent = contentScrollingFrame
        tabContent.Size = UDim2.new(1, 0, 0, 0) -- ขนาดจะถูกปรับโดย UIListLayout
        tabContent.Name = "Tab" .. tabIndex
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1

        -- เพิ่มลงในตารางแท็บ
        tabs[tabIndex] = {
            Button = tabButton,
            Content = tabContent
        }

        -- เปิดแท็บแรกโดย default
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
        local button = Instance.new("TextButton")
        button.Parent = tabContent
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Text = buttonText
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        button.MouseButton1Click:Connect(callback)
    end

    -- เมธอดเพิ่มปุ่มเปิด/ปิด
    function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        local toggleButton = Instance.new("TextButton")
        toggleButton.Parent = tabContent
        toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        toggleButton.Text = (defaultState and "เปิด " or "ปิด ") .. toggleText
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 14
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggleButton
        local isToggled = defaultState or false
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            toggleButton.Text = (isToggled and "เปิด " or "ปิด ") .. toggleText
            callback(isToggled)
        end)
    end

    -- เมธอดเพิ่มปุ่มสไลด์
    function XDLuaUI:AddSlider(tabContent, sliderText, minValue, maxValue, defaultValue, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = tabContent
        sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BackgroundTransparency = 0.5
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 8)
        sliderCorner.Parent = sliderFrame

        local sliderValueLabel = Instance.new("TextLabel")
        sliderValueLabel.Parent = sliderFrame
        sliderValueLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderValueLabel.Position = UDim2.new(0, 0, 0, 5)
        sliderValueLabel.Text = sliderText .. ": " .. defaultValue
        sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderValueLabel.BackgroundTransparency = 1
        sliderValueLabel.Font = Enum.Font.GothamBold
        sliderValueLabel.TextSize = 14

        local sliderBar = Instance.new("Frame")
        sliderBar.Parent = sliderFrame
        sliderBar.Size = UDim2.new(0.9, 0, 0, 5)
        sliderBar.Position = UDim2.new(0.05, 0, 0, 30)
        sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        local sliderBarCorner = Instance.new("UICorner")
        sliderBarCorner.CornerRadius = UDim.new(0, 5)
        sliderBarCorner.Parent = sliderBar

        local sliderHandle = Instance.new("TextButton")
        sliderHandle.Parent = sliderBar
        sliderHandle.Size = UDim2.new(0, 15, 0, 15)
        sliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7.5, 0, -5)
        sliderHandle.Text = ""
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
        local sliderHandleCorner = Instance.new("UICorner")
        sliderHandleCorner.CornerRadius = UDim.new(0, 10)
        sliderHandleCorner.Parent = sliderHandle

        local function updateSlider(value)
            local clampedValue = math.clamp(value, minValue, maxValue)
            sliderValueLabel.Text = sliderText .. ": " .. clampedValue
            local percent = (clampedValue - minValue) / (maxValue - minValue)
            sliderHandle.Position = UDim2.new(percent, -7.5, 0, -5)
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
            end)
        end)

        updateSlider(defaultValue) -- อัปเดตค่าเริ่มต้น
    end

    -- เมธอดเพิ่มคำอธิบายและเครดิต
    function XDLuaUI:AddDescription(tabContent, descriptionText, creditText)
        local descriptionLabel = Instance.new("TextLabel")
        descriptionLabel.Parent = tabContent
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 60)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true

        local creditLabel = Instance.new("TextLabel")
        creditLabel.Parent = tabContent
        creditLabel.Size = UDim2.new(0.9, 0, 0, 20)
        creditLabel.Text = creditText
        creditLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        creditLabel.BackgroundTransparency = 1
        creditLabel.Font = Enum.Font.Gotham
        creditLabel.TextSize = 12
        creditLabel.TextWrapped = true
    end

    -- เมธอดเพิ่มปุ่มคัดลอกลิงค์ YouTube
    function XDLuaUI:Youtube(tabContent, youtubeLink)
        local Youtube = Instance.new("TextButton")
        Youtube.Parent = tabContent
        Youtube.Size = UDim2.new(0.9, 0, 0, 30)
        Youtube.Text = "📋 คัดลอกลิงค์ YouTube"
        Youtube.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Youtube.Font = Enum.Font.GothamBold
        Youtube.TextSize = 14
        Youtube.TextColor3 = Color3.fromRGB(255, 255, 255)
        local youtubeCorner = Instance.new("UICorner")
        youtubeCorner.CornerRadius = UDim.new(0, 8)
        youtubeCorner.Parent = Youtube
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
        local Discord = Instance.new("TextButton")
        Discord.Parent = tabContent
        Discord.Size = UDim2.new(0.9, 0, 0, 30)
        Discord.Text = "📋 คัดลอกลิงค์ดิสคอร์ด"
        Discord.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        Discord.Font = Enum.Font.GothamBold
        Discord.TextSize = 14
        Discord.TextColor3 = Color3.fromRGB(255, 255, 255)
        local discordCorner = Instance.new("UICorner")
        discordCorner.CornerRadius = UDim.new(0, 8)
        discordCorner.Parent = Discord
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
