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

    -- สร้างปุ่มโลโก้
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

    -- ปรับมุมโค้งของปุ่มโลโก้
    local uiCorner = Instance.new("UICorner", logoButton)
    uiCorner.CornerRadius = UDim.new(0, 10)

    -- สร้างเฟรมหลัก
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 420, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -210, 0.45, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- เพิ่มเส้นขอบให้เฟรมหลัก
    local glowMain = Instance.new("UIStroke", mainFrame)
    glowMain.Thickness = 4
    glowMain.Color = Color3.fromRGB(255, 50, 255)
    glowMain.Transparency = 0.1

    -- ปรับมุมโค้งของเฟรมหลัก
    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    -- เพิ่มข้อความหัวเรื่อง
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 35)
    titleLabel.Text = title or "🔹 XDLua UI 🔹"
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 18
    titleLabel.TextStrokeTransparency = 0.2

    -- สร้างเฟรมแท็บ
    local tabFrame = Instance.new("Frame", mainFrame)
    tabFrame.Size = UDim2.new(0, 110, 1, -35)
    tabFrame.Position = UDim2.new(0.01, 0, 0, 35)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    -- ปรับมุมโค้งของเฟรมแท็บ
    local tabCorner = Instance.new("UICorner", tabFrame)
    tabCorner.CornerRadius = UDim.new(0, 8)

    -- สร้าง ScrollingFrame สำหรับแท็บ
    local tabScrollingFrame = Instance.new("ScrollingFrame", tabFrame)
    tabScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    tabScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    tabScrollingFrame.BackgroundTransparency = 1
    tabScrollingFrame.ScrollBarThickness = 5
    tabScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
    tabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- สร้างเฟรมเนื้อหา
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -120, 1, -37)
    contentFrame.Position = UDim2.new(0, 117, 0, 35)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    contentFrame.BackgroundTransparency = 0.5
    contentFrame.BorderSizePixel = 0

    -- ปรับมุมโค้งของเฟรมเนื้อหา
    local contentCorner = Instance.new("UICorner", contentFrame)
    contentCorner.CornerRadius = UDim.new(0, 10)

    -- ในส่วนของการสร้าง ScrollingFrame สำหรับเนื้อหา
local contentScrollingFrame = Instance.new("ScrollingFrame", contentFrame)
contentScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
contentScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
contentScrollingFrame.BackgroundTransparency = 1
contentScrollingFrame.ScrollBarThickness = 5
contentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 255)
contentScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- ตั้งค่าให้ CanvasSize ขยายตามเนื้อหา
contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- ตั้งค่าเริ่มต้น

-- เพิ่ม UIListLayout เพื่อจัดการตำแหน่งของเนื้อหา
local contentListLayout = Instance.new("UIListLayout", contentScrollingFrame)
contentListLayout.Padding = UDim.new(0, 10) -- ระยะห่างระหว่างเนื้อหา
contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ฟังก์ชันอัปเดต CanvasSize
local function updateCanvasSize()
    local totalHeight = 0
    for _, child in pairs(contentScrollingFrame:GetChildren()) do
        if child:IsA("GuiObject") and child ~= contentListLayout then
            totalHeight += child.Size.Y.Offset + contentListLayout.Padding.Offset
        end
    end
    contentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- อัปเดต CanvasSize เมื่อเนื้อหาเปลี่ยนแปลง
contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
    
    -- ตัวแปรเก็บแท็บและเนื้อหา
    local tabs = {}
    local selectedTab = nil

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
        selectedTab.Content.Visible = true

        -- อัปเดตข้อความหัวเรื่องแท็บ
        local titleLabel = selectedTab.Content:FindFirstChild("TextLabel")
        if titleLabel then
            titleLabel.Text = selectedTab.Button.Text
        end
    end

    -- เมธอดเพิ่มแท็บ
    function XDLuaUI:AddTab(tabName)
        local tabIndex = #tabs + 1

        -- สร้างปุ่มแท็บ
        local tabButton = Instance.new("TextButton", tabScrollingFrame)
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Position = UDim2.new(0, 0, 0, (tabIndex - 1) * 45)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabIndex)
        end)

        -- เพิ่มเส้นขอบให้ปุ่มแท็บ
        local buttonGlow = Instance.new("UIStroke", tabButton)
        buttonGlow.Name = "Stroke"
        buttonGlow.Thickness = 2
        buttonGlow.Color = Color3.fromRGB(255, 50, 255)
        buttonGlow.Transparency = 1

        -- ปรับมุมโค้งของปุ่มแท็บ
        local tabCorner = Instance.new("UICorner", tabButton)
        tabCorner.CornerRadius = UDim.new(0, 5)

        -- สร้างเฟรมเนื้อหาแท็บ
        local tabContent = Instance.new("Frame", contentScrollingFrame)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Name = "Tab" .. tabIndex
        tabContent.Visible = false
        tabContent.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

        -- เพิ่มข้อความหัวเรื่องแท็บ
        local label = Instance.new("TextLabel", tabContent)
        label.Size = UDim2.new(1, 0, 10, 30)
        label.Text = tabName -- แสดงชื่อแท็บ
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16

        -- เพิ่มลงในตารางแท็บ
        tabs[tabIndex] = {
            Button = tabButton,
            Content = tabContent
        }

        -- เปิดแท็บแรกโดย default
        if tabIndex == 1 then
            switchTab(1)
        end

        -- คืนค่าแท็บเพื่อให้ผู้ใช้เพิ่มเนื้อหา
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
        button.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 40)
        button.Text = buttonText
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)

        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, 8)

        button.MouseButton1Click:Connect(callback)
    end

    -- เมธอดเพิ่มปุ่มเปิด/ปิด
    function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        local toggleButton = Instance.new("TextButton", tabContent)
        toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        toggleButton.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 40)
        toggleButton.Text = (defaultState and "เปิด " or "ปิด ") .. toggleText
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.TextSize = 14
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        local toggleCorner = Instance.new("UICorner", toggleButton)
        toggleCorner.CornerRadius = UDim.new(0, 8)

        local isToggled = defaultState or false
        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            toggleButton.Text = (isToggled and "เปิด " or "ปิด ") .. toggleText
            callback(isToggled)
        end)
    end

    -- เมธอดเพิ่มปุ่มสไลด์
    function XDLuaUI:AddSlider(tabContent, sliderText, minValue, maxValue, defaultValue, callback)
        local sliderFrame = Instance.new("Frame", tabContent)
        sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
        sliderFrame.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 60)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BackgroundTransparency = 0.5
        sliderFrame.BorderSizePixel = 0

        local sliderCorner = Instance.new("UICorner", sliderFrame)
        sliderCorner.CornerRadius = UDim.new(0, 8)

        -- เพิ่มข้อความแสดงค่าปัจจุบัน
        local sliderValueLabel = Instance.new("TextLabel", sliderFrame)
        sliderValueLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderValueLabel.Position = UDim2.new(0, 0, 0, 10)
        sliderValueLabel.Text = sliderText .. ": " .. defaultValue
        sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderValueLabel.BackgroundTransparency = 1
        sliderValueLabel.Font = Enum.Font.GothamBold
        sliderValueLabel.TextSize = 14

        -- เพิ่ม Slider Bar
        local sliderBar = Instance.new("Frame", sliderFrame)
        sliderBar.Size = UDim2.new(0.9, 0, 0, 5)
        sliderBar.Position = UDim2.new(0.05, 0, 0, 30)
        sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderBar.BorderSizePixel = 0

        local sliderBarCorner = Instance.new("UICorner", sliderBar)
        sliderBarCorner.CornerRadius = UDim.new(0, 5)

        -- เพิ่ม Slider Handle
        local sliderHandle = Instance.new("TextButton", sliderBar)
        sliderHandle.Size = UDim2.new(0, 15, 0, 15)
        sliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7.5, 0, -5)
        sliderHandle.Text = ""
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
        sliderHandle.BorderSizePixel = 0

        local sliderHandleCorner = Instance.new("UICorner", sliderHandle)
        sliderHandleCorner.CornerRadius = UDim.new(0, 10)

        -- ฟังก์ชันอัปเดตค่า Slider
        local function updateSlider(value)
            local clampedValue = math.clamp(value, minValue, maxValue)
            sliderValueLabel.Text = sliderText .. ": " .. clampedValue
            local percent = (clampedValue - minValue) / (maxValue - minValue)
            sliderHandle.Position = UDim2.new(percent, -7.5, 0, -5)
            callback(clampedValue)
        end

        -- ฟังก์ชันเมื่อคลิกและลาก Slider
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
                local inputPosition
                if input.UserInputType == Enum.UserInputType.Touch then
                    inputPosition = input.Position
                else
                    inputPosition = game:GetService("UserInputService"):GetMouseLocation()
                end
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
        -- เพิ่มคำอธิบาย
        local descriptionLabel = Instance.new("TextLabel", tabContent)
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 60)
        descriptionLabel.Position = UDim2.new(0.05, 0, 0, 50)
        descriptionLabel.Text = descriptionText
        descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Font = Enum.Font.GothamBold
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true

        -- เพิ่มเครดิต
        local creditLabel = Instance.new("TextLabel", tabContent)
        creditLabel.Size = UDim2.new(0.9, 0, 0, 30)
        creditLabel.Position = UDim2.new(0.05, 0, 0, 100)
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
    descriptionLabel.Position = UDim2.new(0.05, 0, 0, 10) -- อยู่ด้านบนของเนื้อหา
    descriptionLabel.Text = descriptionText
    descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Font = Enum.Font.GothamBold
    descriptionLabel.TextSize = 14
    descriptionLabel.TextWrapped = true
end

-- เมธอดเพิ่มคำอธิบายของ Button
function XDLuaUI:AddButton2(tabContent, buttonText, descriptionText, callback)
    -- เพิ่มคำอธิบาย
    local descriptionLabel = Instance.new("TextLabel", tabContent)
    descriptionLabel.Size = UDim2.new(0.9, 0, 0, 20)
    descriptionLabel.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 40)
    descriptionLabel.Text = descriptionText
    descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Font = Enum.Font.GothamBold
    descriptionLabel.TextSize = 12
    descriptionLabel.TextWrapped = true

    -- เพิ่มปุ่ม
    local button = Instance.new("TextButton", tabContent)
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 40 + 20)
    button.Text = buttonText
    button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)

    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(callback)
end

-- เมธอดเพิ่มคำอธิบายของ Toggle
function XDLuaUI:AddToggle2(tabContent, toggleText, descriptionText, defaultState, callback)
    -- เพิ่มคำอธิบาย
    local descriptionLabel = Instance.new("TextLabel", tabContent)
    descriptionLabel.Size = UDim2.new(0.9, 0, 0, 20)
    descriptionLabel.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 40)
    descriptionLabel.Text = descriptionText
    descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Font = Enum.Font.GothamBold
    descriptionLabel.TextSize = 12
    descriptionLabel.TextWrapped = true

    -- เพิ่ม Toggle
    local toggleButton = Instance.new("TextButton", tabContent)
    toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
    toggleButton.Position = UDim2.new(0.05, 0, 0, #tabContent:GetChildren() * 40 + 20)
    toggleButton.Text = (defaultState and "เปิด " or "ปิด ") .. toggleText
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local toggleCorner = Instance.new("UICorner", toggleButton)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local isToggled = defaultState or false
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = (isToggled and "เปิด " or "ปิด ") .. toggleText
        callback(isToggled)
    end)
    end

    -- เมธอดเพิ่มปุ่มคัดลอกลิงค์ YouTube
    function XDLuaUI:Youtube(tabContent, youtubeLink)
        local Youtube = Instance.new("TextButton", tabContent)
        Youtube.Size = UDim2.new(0.9, 0, 0, 30)
        Youtube.Position = UDim2.new(0.05, 0, 0, 150)
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
        Discord.Position = UDim2.new(0.05, 0, 0, 190)
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

    -- คืนค่าตัวแปร UI Library
    return XDLuaUI
end

-- คืนค่า UI Library
return XDLuaUI
