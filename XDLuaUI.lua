-- UI Library
local XDLuaUI = {}

-- สร้างหน้าต่างหลัก
function XDLuaUI:CreateWindow(title, primaryColor)
    primaryColor = primaryColor or Color3.fromRGB(255, 50, 255) -- สีหลักเริ่มต้น
    
    -- ลบ GUI เดิมหากมีอยู่
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("XDLuaGUI") then
        CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    -- สร้าง ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XDLuaGUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    -- สร้างปุ่มโลโก้
    local logoButton = Instance.new("TextButton")
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
    logoButton.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = logoButton

    -- สร้างเฟรมหลัก
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -210, 0.45, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local glowMain = Instance.new("UIStroke")
    glowMain.Thickness = 4
    glowMain.Color = primaryColor
    glowMain.Transparency = 0.1
    glowMain.Parent = mainFrame

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- เพิ่มปุ่มปิด
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.Text = "✖"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.Parent = mainFrame
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    -- เพิ่มข้อความหัวเรื่อง
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Text = title or "🔹 XDLua UI 🔹"
    titleLabel.TextColor3 = primaryColor
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 18
    titleLabel.TextStrokeTransparency = 0.2
    titleLabel.Parent = mainFrame

    -- สร้างเฟรมแท็บ
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 110, 1, -35)
    tabFrame.Position = UDim2.new(0.01, 0, 0, 35)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabFrame.Parent = mainFrame

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame

    local tabScrollingFrame = Instance.new("ScrollingFrame")
    tabScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    tabScrollingFrame.BackgroundTransparency = 1
    tabScrollingFrame.ScrollBarThickness = 5
    tabScrollingFrame.ScrollBarImageColor3 = primaryColor
    tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScrollingFrame.Parent = tabFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabScrollingFrame

    -- สร้างเฟรมเนื้อหา
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -120, 1, -37)
    contentFrame.Position = UDim2.new(0, 117, 0, 35)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    contentFrame.BackgroundTransparency = 0.5
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame

    local contentScrollingFrame = Instance.new("ScrollingFrame")
    contentScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    contentScrollingFrame.BackgroundTransparency = 1
    contentScrollingFrame.ScrollBarThickness = 5
    contentScrollingFrame.ScrollBarImageColor3 = primaryColor
    contentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScrollingFrame.Parent = contentFrame

    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Padding = UDim.new(0, 10)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Parent = contentScrollingFrame

    -- ฟังก์ชันอัปเดต CanvasSize
    local function updateCanvasSize()
        local totalHeight = contentListLayout.AbsoluteContentSize.Y
        contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

    -- ตัวแปรเก็บแท็บ
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
        updateCanvasSize()
    end

    -- เมธอดเพิ่มแท็บ
    function XDLuaUI:AddTab(tabName)
        local tabIndex = #tabs + 1

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.Parent = tabScrollingFrame

        local buttonGlow = Instance.new("UIStroke")
        buttonGlow.Name = "Stroke"
        buttonGlow.Thickness = 2
        buttonGlow.Color = primaryColor
        buttonGlow.Transparency = 1
        buttonGlow.Parent = tabButton

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = tabButton

        -- Hover effect
        tabButton.MouseEnter:Connect(function()
            buttonGlow.Transparency = 0.5
        end)
        tabButton.MouseLeave:Connect(function()
            if selectedTab ~= tabs[tabIndex] then
                buttonGlow.Transparency = 1
            end
        end)

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 0, 0) -- ขนาดจะถูกปรับโดย UIListLayout
        tabContent.Name = "Tab" .. tabIndex
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.Parent = contentScrollingFrame

        tabs[tabIndex] = {Button = tabButton, Content = tabContent}
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabIndex)
        end)

        if tabIndex == 1 then
            switchTab(1)
        end

        updateCanvasSize()
        return tabContent
    end

    -- เมธอดแก้ไข Title
    function XDLuaUI:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end

    -- เมธอดเพิ่มปุ่มปกติ
    function XDLuaUI:AddButton(tabContent, buttonText, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Text = buttonText
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Parent = tabContent

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button

        button.MouseButton1Click:Connect(callback)
        updateCanvasSize()
    end

    -- เมธอดเพิ่มปุ่มเปิด/ปิด
    function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        toggleButton.Text = (defaultState and "เปิด " or "ปิด ") .. toggleText
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 14
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.Parent = tabContent

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggleButton

        local isToggled = defaultState or false
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            toggleButton.Text = (isToggled and "เปิด " or "ปิด ") .. toggleText
            callback(isToggled)
        end)
        updateCanvasSize()
    end

    -- เมธอดเพิ่มปุ่มสไลด์
    function XDLuaUI:AddSlider(tabContent, sliderText, minValue, maxValue, defaultValue, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BackgroundTransparency = 0.5
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = tabContent

        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 8)
        sliderCorner.Parent = sliderFrame

        local sliderValueLabel = Instance.new("TextLabel")
        sliderValueLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderValueLabel.Position = UDim2.new(0, 0, 0, 5)
        sliderValueLabel.Text = sliderText .. ": " .. defaultValue
        sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderValueLabel.BackgroundTransparency = 1
        sliderValueLabel.Font = Enum.Font.GothamBold
        sliderValueLabel.TextSize = 14
        sliderValueLabel.Parent = sliderFrame

        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(0.9, 0, 0, 5)
        sliderBar.Position = UDim2.new(0.05, 0, 0, 30)
        sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = sliderFrame

        local sliderBarCorner = Instance.new("UICorner")
        sliderBarCorner.CornerRadius = UDim.new(0, 5)
        sliderBarCorner.Parent = sliderBar

        local sliderHandle = Instance.new("TextButton")
        sliderHandle.Size = UDim2.new(0, 15, 0, 15)
        sliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7.5, 0, -5)
        sliderHandle.Text = ""
        sliderHandle.BackgroundColor3 = primaryColor
        sliderHandle.BorderSizePixel = 0
        sliderHandle.Parent = sliderBar

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
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local inputPosition = game:GetService("UserInputService"):GetMouseLocation()
                local sliderBarPosition = sliderBar.AbsolutePosition
                local sliderBarSize = sliderBar.AbsoluteSize
                local relativeX = (inputPosition.X - sliderBarPosition.X) / sliderBarSize.X
                local value = math.floor(minValue + (maxValue - minValue) * math.clamp(relativeX, 0, 1))
                updateSlider(value)
            end
        end)
        updateCanvasSize()
    end

    -- เมธอดเพิ่มคำอธิบายและเครดิต
    function XDLuaUI:AddDescription(tabContent, descriptionText, creditText)
        local descriptionLabel = Instance.new("TextLabel")
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 60)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true
        descriptionLabel.Parent = tabContent

        local creditLabel = Instance.new("TextLabel")
        creditLabel.Size = UDim2.new(0.9, 0, 0, 30)
        creditLabel.Text = creditText
        creditLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        creditLabel.BackgroundTransparency = 1
        creditLabel.Font = Enum.Font.GothamBold
        creditLabel.TextSize = 12
        creditLabel.TextWrapped = true
        creditLabel.Parent = tabContent

        updateCanvasSize()
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
