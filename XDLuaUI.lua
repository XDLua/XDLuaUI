-- UI Library
local XDLuaUI = {}

-- สร้างหน้าต่างหลัก
function XDLuaUI:CreateWindow(title)
    -- ลบ GUI เดิมหากมีอยู่ (เพิ่มการตรวจสอบความปลอดภัย)
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("XDLuaGUI") then
        CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    -- สร้าง ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XDLuaGUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false -- ป้องกันการรีเซ็ตเมื่อผู้เล่นเกิดใหม่

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

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = logoButton

    -- สร้างเฟรมหลัก
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 420, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -210, 0.45, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true

    local glowMain = Instance.new("UIStroke")
    glowMain.Thickness = 4
    glowMain.Color = Color3.fromRGB(255, 50, 255)
    glowMain.Transparency = 0.1
    glowMain.Parent = mainFrame

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- เพิ่มปุ่มปิด (Close Button)
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
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    -- เพิ่มข้อความหัวเรื่อง
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, -40, 0, 35) -- ปรับขนาดให้ไม่ทับปุ่มปิด
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

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame

    -- สร้าง ScrollingFrame สำหรับแท็บ
    local tabScrollingFrame = Instance.new("ScrollingFrame")
    tabScrollingFrame.Parent = tabFrame
    tabScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    tabScrollingFrame.BackgroundTransparency = 1
    tabScrollingFrame.ScrollBarThickness = 5
    tabScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- ใช้ AutomaticCanvasSize

    -- สร้างเฟรมเนื้อหา
    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.Size = UDim2.new(1, -120, 1, -37)
    contentFrame.Position = UDim2.new(0, 117, 0, 35)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    contentFrame.BackgroundTransparency = 0.5
    contentFrame.BorderSizePixel = 0

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame

    -- สร้าง ScrollingFrame สำหรับเนื้อหา
    local contentScrollingFrame = Instance.new("ScrollingFrame")
    contentScrollingFrame.Parent = contentFrame
    contentScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    contentScrollingFrame.BackgroundTransparency = 1
    contentScrollingFrame.ScrollBarThickness = 5
    contentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    contentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- ใช้ AutomaticCanvasSize
    contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Parent = contentScrollingFrame
    contentListLayout.Padding = UDim.new(0, 10)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- ตัวแปรเก็บแท็บและเนื้อหา
    local tabs = {}
    local selectedTab = nil

    -- ฟังก์ชันสลับแท็บ
    local function switchTab(tabIndex)
        if not tabs[tabIndex] then return end -- ป้องกันข้อผิดพลาดถ้า tabIndex ไม่ถูกต้อง
        if selectedTab then
            selectedTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            local stroke = selectedTab.Button:FindFirstChild("Stroke")
            if stroke then stroke.Transparency = 1 end
        end
        selectedTab = tabs[tabIndex]
        selectedTab.Button.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
        local stroke = selectedTab.Button:FindFirstChild("Stroke")
        if stroke then stroke.Transparency = 0.2 end
        for _, tab in pairs(tabs) do
            tab.Content.Visible = false
        end
        selectedTab.Content.Visible = true
    end

    -- เมธอดเพิ่มแท็บ
    function XDLuaUI:AddTab(tabName)
        local tabIndex = #tabs + 1

        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabScrollingFrame
        tabButton.Size = UDim2.new(1, -10, 0, 40) -- ปรับขนาดให้มีขอบเล็กน้อย
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabIndex)
        end)

        local buttonGlow = Instance.new("UIStroke")
        buttonGlow.Name = "Stroke"
        buttonGlow.Thickness = 2
        buttonGlow.Color = Color3.fromRGB(255, 50, 255)
        buttonGlow.Transparency = 1
        buttonGlow.Parent = tabButton

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = tabButton

        local tabContent = Instance.new("Frame")
        tabContent.Parent = contentScrollingFrame
        tabContent.Size = UDim2.new(1, 0, 0, 0) -- ขนาดเริ่มต้นเป็น 0 แล้วให้ UIListLayout จัดการ
        tabContent.Name = "Tab" .. tabIndex
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1 -- ไม่ต้องมีสีพื้นหลังซ้ำกับ contentFrame

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
        local button = Instance.new("TextButton")
        button.Parent = tabContent
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Text = buttonText
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.MouseButton1Click:Connect(callback or function() end) -- ป้องกัน callback เป็น nil

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
    end

    -- เมธอดเพิ่มปุ่มเปิด/ปิด (เปลี่ยนเป็นสวิตช์)
    function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        -- สร้าง Frame หลักสำหรับ Toggle
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = tabContent
        toggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
        toggleFrame.BackgroundTransparency = 1

        -- เพิ่มข้อความชื่อ Toggle
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Parent = toggleFrame
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.Text = toggleText
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Font = Enum.Font.GothamBold
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- สร้าง Frame สำหรับสวิตช์
        local switchFrame = Instance.new("Frame")
        switchFrame.Parent = toggleFrame
        switchFrame.Size = UDim2.new(0, 50, 0, 25)
        switchFrame.Position = UDim2.new(1, -50, 0.5, -12.5)
        switchFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 100) -- สีพื้นหลังสวิตช์ (ปิด)
        switchFrame.BorderSizePixel = 0

        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0) -- มุมโค้งแบบวงรี
        switchCorner.Parent = switchFrame

        -- สร้างวงกลมเลื่อน
        local switchHandle = Instance.new("Frame")
        switchHandle.Parent = switchFrame
        switchHandle.Size = UDim2.new(0, 20, 0, 20)
        switchHandle.Position = UDim2.new(0, 5, 0.5, -10)
        switchHandle.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- สีวงกลม (ปิด)
        switchHandle.BorderSizePixel = 0

        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(1, 0)
        handleCorner.Parent = switchHandle

        -- สร้าง TextButton เพื่อรับการคลิก
        local toggleButton = Instance.new("TextButton")
        toggleButton.Parent = switchFrame
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.BackgroundTransparency = 1
        toggleButton.Text = ""

        local isToggled = defaultState or false

        -- อัปเดต UI ตามสถานะ
        local function updateToggle()
            if isToggled then
                switchFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 100) -- สีเมื่อเปิด
                switchHandle.Position = UDim2.new(0, 5, 0.5, -10) -- เลื่อนไปขวา
                switchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- สีวงกลมเมื่อเปิด
            else
                switchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- สีเมื่อปิด
                switchHandle.Position = UDim2.new(1, -25, 0.5, -10) -- เลื่อนไปซ้าย
                switchHandle.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- สีวงกลมเมื่อปิด
            end
        end

        -- ตั้งค่าเริ่มต้น
        updateToggle()

        -- เพิ่มการทำงานเมื่อคลิก
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            updateToggle()
            if callback then callback(isToggled) end
        end)
    end

    -- เมธอดเพิ่มปุ่มสไลด์ (ปรับปรุงการคำนวณ)
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
        sliderValueLabel.Text = sliderText .. ": " .. (defaultValue or minValue)
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
        sliderHandle.BorderSizePixel = 0

        local sliderHandleCorner = Instance.new("UICorner")
        sliderHandleCorner.CornerRadius = UDim.new(0, 10)
        sliderHandleCorner.Parent = sliderHandle

        local function updateSlider(value)
            local clampedValue = math.clamp(value, minValue, maxValue)
            sliderValueLabel.Text = sliderText .. ": " .. clampedValue
            local percent = (clampedValue - minValue) / (maxValue - minValue)
            sliderHandle.Position = UDim2.new(percent, -7.5, 0, -5)
            if callback then callback(clampedValue) end
        end

        local isDragging = false
        sliderHandle.MouseButton1Down:Connect(function()
            isDragging = true
        end)

        local UIS = game:GetService("UserInputService")
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mousePos = UIS:GetMouseLocation()
                local sliderBarPos = sliderBar.AbsolutePosition
                local sliderBarSize = sliderBar.AbsoluteSize
                local relativeX = math.clamp((mousePos.X - sliderBarPos.X) / sliderBarSize.X, 0, 1)
                local value = math.floor(minValue + (maxValue - minValue) * relativeX)
                updateSlider(value)
            end)
        end)

        updateSlider(defaultValue or minValue) -- ตั้งค่าเริ่มต้น
    end

    -- เมธอดเพิ่มคำอธิบายและเครดิต
    function XDLuaUI:AddDescription(tabContent, descriptionText, creditText)
        -- เพิ่มคำอธิบาย
        local descriptionLabel = Instance.new("TextLabel")
        descriptionLabel.Parent = tabContent
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 60)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true

        -- เพิ่มเครดิต
        local creditLabel = Instance.new("TextLabel")
        creditLabel.Parent = tabContent
        creditLabel.Size = UDim2.new(0.9, 0, 0, 30)
        creditLabel.Text = creditText
        creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        creditLabel.BackgroundTransparency = 1
        creditLabel.Font = Enum.Font.GothamBold
        creditLabel.TextSize = 12
        creditLabel.TextWrapped = true
    end

    -- เมธอดเพิ่มคำอธิบายของ Tab
    function XDLuaUI:AddTabDescription(tabContent, descriptionText)
        local descriptionLabel = Instance.new("TextLabel")
        descriptionLabel.Parent = tabContent
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 40)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true
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
