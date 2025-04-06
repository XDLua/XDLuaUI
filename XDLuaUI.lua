-- XDLuaUI (UI หลัก)
local XDLuaUI = {}

-- บริการที่ใช้
local TweenService = game:GetService("TweenService")

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

    -- สร้างหน้าโหลด
    local loadingFrame = Instance.new("Frame", screenGui)
    loadingFrame.Size = UDim2.new(0, 300, 0, 150)
    loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    loadingFrame.BackgroundTransparency = 0.1
    loadingFrame.BorderSizePixel = 0

    local loadingCorner = Instance.new("UICorner", loadingFrame)
    loadingCorner.CornerRadius = UDim.new(0, 12)

    local loadingGlow = Instance.new("UIStroke", loadingFrame)
    loadingGlow.Thickness = 2
    loadingGlow.Color = Color3.fromRGB(255, 50, 255)
    loadingGlow.Transparency = 0.2

    -- เพิ่มชื่อ "BY C • J"
    local titleLabel = Instance.new("TextLabel", loadingFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.Text = "BY C • J"
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 24
    titleLabel.TextStrokeTransparency = 0.2

    -- เพิ่มแถบโหลด
    local loadingBarFrame = Instance.new("Frame", loadingFrame)
    loadingBarFrame.Size = UDim2.new(0.8, 0, 0, 10)
    loadingBarFrame.Position = UDim2.new(0.1, 0, 0, 60)
    loadingBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    loadingBarFrame.BorderSizePixel = 0

    local barCorner = Instance.new("UICorner", loadingBarFrame)
    barCorner.CornerRadius = UDim.new(0, 5)

    local loadingBar = Instance.new("Frame", loadingBarFrame)
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
    loadingBar.BorderSizePixel = 0

    local barInnerCorner = Instance.new("UICorner", loadingBar)
    barInnerCorner.CornerRadius = UDim.new(0, 5)

    -- เพิ่มข้อความ "กำลังโหลด..."
    local loadingText = Instance.new("TextLabel", loadingFrame)
    loadingText.Size = UDim2.new(1, 0, 0, 30)
    loadingText.Position = UDim2.new(0, 0, 0, 90)
    loadingText.Text = "กำลังโหลด..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.GothamBold
    loadingText.TextSize = 16
    loadingText.TextStrokeTransparency = 0.2

    -- อะนิเมชั่นแถบโหลด
    local tweenService = game:GetService("TweenService")
    local barTweenInfo1 = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) -- ใช้เวลา 1.5 วินาทีเพื่อไปถึง 80%
    local barTween1 = tweenService:Create(loadingBar, barTweenInfo1, {Size = UDim2.new(0.8, 0, 1, 0)}) -- ไปถึง 80%
    barTween1:Play()

    -- รอให้แถบโหลดถึง 80%
    barTween1.Completed:Wait()

    -- รอเวลาที่กำหนดก่อนไปถึง 100%
    wait(3)

    -- อะนิเมชั่นสุดท้าย (เพิ่มจาก 80% ไป 100% ใน 0.5 วินาที)
    local barTweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
    local barTween2 = tweenService:Create(loadingBar, barTweenInfo2, {Size = UDim2.new(1, 0, 1, 0)}) -- ไปถึง 100%
    barTween2:Play()

    -- อะนิเมชั่นข้อความกระพริบ
    local textTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local textTween = TweenService:Create(loadingText, textTweenInfo, {TextTransparency = 0.8})
    textTween:Play()

    -- สร้างหน้ายินดีต้อนรับ
    local welcomeFrame = Instance.new("Frame", screenGui)
    welcomeFrame.Size = UDim2.new(0, 300, 0, 200)
    welcomeFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    welcomeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    welcomeFrame.BackgroundTransparency = 0.1
    welcomeFrame.BorderSizePixel = 0
    welcomeFrame.Visible = false -- ซ่อนไว้ก่อน

    local welcomeCorner = Instance.new("UICorner", welcomeFrame)
    welcomeCorner.CornerRadius = UDim.new(0, 12)

    local welcomeGlow = Instance.new("UIStroke", welcomeFrame)
    welcomeGlow.Thickness = 2
    welcomeGlow.Color = Color3.fromRGB(255, 50, 255)
    welcomeGlow.Transparency = 0.2

    -- รูปโปรไฟล์ผู้ใช้
    local player = game.Players.LocalPlayer
    local userId = player.UserId
    local profileImage = Instance.new("ImageLabel", welcomeFrame)
    profileImage.Size = UDim2.new(0, 80, 0, 80)
    profileImage.Position = UDim2.new(0.5, -40, 0, 20)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150" -- รูปโปรไฟล์จาก Roblox

    local profileCorner = Instance.new("UICorner", profileImage)
    profileCorner.CornerRadius = UDim.new(0, 40) -- ทำให้เป็นวงกลม

    -- ชื่อผู้ใช้
    local welcomeText = Instance.new("TextLabel", welcomeFrame)
    welcomeText.Size = UDim2.new(1, 0, 0, 40)
    welcomeText.Position = UDim2.new(0, 0, 0, 110)
    welcomeText.Text = "" .. player.Name
    welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Font = Enum.Font.GothamBold
    welcomeText.TextSize = 20
    welcomeText.TextStrokeTransparency = 0.2

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
    logoButton.Visible = false -- ซ่อนปุ่มโลโก้จนกว่าหน้าโหลดจะหายไป

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

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 12)

    -- เปลี่ยนขอบเป็นแสงกระพริบ (เลี่ยง UIGradient)
    local glowMain = Instance.new("UIStroke", mainFrame)
    glowMain.Thickness = 4
    glowMain.Color = Color3.fromRGB(255, 50, 255) -- สีม่วงเริ่มต้น
    glowMain.Transparency = 0

    -- อนิเมชั่นแสงกระพริบ (ใช้ TweenService ง่ายๆ)
    spawn(function()
        while wait(0.5) do -- กระพริบทุก 0.5 วินาที
            if mainFrame.Parent then -- ตรวจสอบว่า UI ยังอยู่
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
                local fadeOut = TweenService:Create(glowMain, tweenInfo, {Transparency = 0.8})
                fadeOut:Play()
                fadeOut.Completed:Wait()
                local fadeIn = TweenService:Create(glowMain, tweenInfo, {Transparency = 0})
                fadeIn:Play()
            else
                break -- หยุดลูปถ้า UI ถูกลบ
            end
        end
    end)
    
    -- เพิ่มข้อความหัวเรื่อง
    local titleLabelMain = Instance.new("TextLabel", mainFrame)
    titleLabelMain.Size = UDim2.new(1, 0, 0, 40)

    -- จัดการอิโมจิใน Title
    local emojiFront = emojiFront or "" -- ถ้าไม่ระบุอิโมจิหน้า ให้เป็นสตริงว่าง
    local emojiBack = emojiBack or "" -- ถ้าไม่ระบุอิโมจิหลัง ให้เป็นสตริงว่าง
    local spacing = spacing or 2 -- ค่าเริ่มต้นของช่องว่างเป็น 2 ช่อง
    local spacingStr = string.rep(" ", spacing) -- สร้างช่องว่างตามจำนวนที่ระบุ
    
    -- สร้างข้อความ Title โดยเพิ่มอิโมจิหน้าและหลัง
    local titleText = title or "XDLua UI"
    if emojiFront ~= "" and emojiBack ~= "" then
        titleLabelMain.Text = emojiFront .. spacingStr .. titleText .. spacingStr .. emojiBack
    elseif emojiFront ~= "" then
        titleLabelMain.Text = emojiFront .. spacingStr .. titleText
    elseif emojiBack ~= "" then
        titleLabelMain.Text = titleText .. spacingStr .. emojiBack
    else
        titleLabelMain.Text = titleText
    end

    titleLabelMain.TextColor3 = Color3.fromRGB(255, 50, 255)
    titleLabelMain.BackgroundTransparency = 1
    titleLabelMain.Font = Enum.Font.GothamBlack
    titleLabelMain.TextSize = 20
    titleLabelMain.TextStrokeTransparency = 0.2

    -- เพิ่มปุ่ม X (ปิด UI)
    local deleteButton = Instance.new("TextButton", mainFrame)
    deleteButton.Size = UDim2.new(0, 30, 0, 30)
    deleteButton.Position = UDim2.new(1, -40, 0, 5)
    deleteButton.Text = "X"
    deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    deleteButton.Font = Enum.Font.GothamBold
    deleteButton.TextSize = 16
    local deleteCorner = Instance.new("UICorner", deleteButton)
    deleteCorner.CornerRadius = UDim.new(0, 8)

    -- ปุ่มฟันเฟือง (เลื่อนตำแหน่ง)
    local settingsButton = Instance.new("TextButton", mainFrame)
    settingsButton.Size = UDim2.new(0, 30, 0, 30)
    settingsButton.Position = UDim2.new(1, -75, 0, 5)
    settingsButton.Text = "⚙️"
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    settingsButton.Font = Enum.Font.GothamBold
    settingsButton.TextSize = 16
    local settingsCorner = Instance.new("UICorner", settingsButton)
    settingsCorner.CornerRadius = UDim.new(0, 8)

    -- สร้างหน้ายืนยันการลบ
    local confirmFrame = Instance.new("Frame", screenGui)
    confirmFrame.Size = UDim2.new(0, 200, 0, 120)
    confirmFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    confirmFrame.BackgroundTransparency = 0.1
    confirmFrame.BorderSizePixel = 0
    confirmFrame.Visible = false

    local confirmCorner = Instance.new("UICorner", confirmFrame)
    confirmCorner.CornerRadius = UDim.new(0, 12)

    local confirmGlow = Instance.new("UIStroke", confirmFrame)
    confirmGlow.Thickness = 2
    confirmGlow.Color = Color3.fromRGB(255, 50, 255)
    confirmGlow.Transparency = 0.2

    local confirmText = Instance.new("TextLabel", confirmFrame)
    confirmText.Size = UDim2.new(1, 0, 0, 40)
    confirmText.Position = UDim2.new(0, 0, 0, 10)
    confirmText.Text = "ยืนยันการปิด UI?"
    confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmText.BackgroundTransparency = 1
    confirmText.Font = Enum.Font.GothamBold
    confirmText.TextSize = 16

    local yesButton = Instance.new("TextButton", confirmFrame)
    yesButton.Size = UDim2.new(0, 80, 0, 30)
    yesButton.Position = UDim2.new(0, 20, 0, 60)
    yesButton.Text = "ปิดเลย"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    yesButton.Font = Enum.Font.GothamBold
    yesButton.TextSize = 14
    local yesCorner = Instance.new("UICorner", yesButton)
    yesCorner.CornerRadius = UDim.new(0, 8)

    local noButton = Instance.new("TextButton", confirmFrame)
    noButton.Size = UDim2.new(0, 80, 0, 30)
    noButton.Position = UDim2.new(0, 100, 0, 60)
    noButton.Text = "ยกเลิก"
    noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    noButton.Font = Enum.Font.GothamBold
    noButton.TextSize = 14
    local noCorner = Instance.new("UICorner", noButton)
    noCorner.CornerRadius = UDim.new(0, 8)

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

    -- ฟังก์ชัน switchTab (เพิ่มอนิเมชั่นตอนเปลี่ยนแท็บ)
    local function switchTab(tabIndex)
        if selectedTab then
            local oldButton = selectedTab.Button
            local tweenOut = TweenService:Create(oldButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
                {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            tweenOut:Play()
            if oldButton:FindFirstChild("Stroke") then
                oldButton:FindFirstChild("Stroke").Transparency = 1
            end
        end

        selectedTab = tabs[tabIndex]
        local newButton = selectedTab.Button
        local tweenIn = TweenService:Create(newButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {BackgroundColor3 = Color3.fromRGB(80, 0, 80)})
        tweenIn:Play()
        if newButton:FindFirstChild("Stroke") then
            newButton:FindFirstChild("Stroke").Transparency = 0.2
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
    function XDLuaUI:AddTab(tabName, emoji, emojiPosition)
        local tabIndex = #tabs + 1

        local tabButton = Instance.new("TextButton", tabScrollingFrame)
        tabButton.Size = UDim2.new(0.9, 0, 0, 40)
        tabButton.AnchorPoint = Vector2.new(0.5, 0)
        
        -- จัดการอิโมจิในชื่อแท็บ
        local emoji = emoji or "" -- ถ้าไม่ระบุอิโมจิ ให้เป็นสตริงว่าง
        local emojiPosition = emojiPosition or "front" -- ค่าเริ่มต้นเป็น "front"
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
    function XDLuaUI:SetTitle(newTitle, emojiFront, emojiBack, spacing)
        local emojiFront = emojiFront or ""
        local emojiBack = emojiBack or ""
        local spacing = spacing or 2
        local spacingStr = string.rep(" ", spacing)
        
        if emojiFront ~= "" and emojiBack ~= "" then
            titleLabelMain.Text = emojiFront .. spacingStr .. newTitle .. spacingStr .. emojiBack
        elseif emojiFront ~= "" then
            titleLabelMain.Text = emojiFront .. spacingStr .. newTitle
        elseif emojiBack ~= "" then
            titleLabelMain.Text = newTitle .. spacingStr .. emojiBack
        else
            titleLabelMain.Text = newTitle
        end
    end

    -- เมธอด AddToggle (เพิ่มอนิเมชั่นตอนเปิด/ปิด)
        function XDLuaUI:AddToggle(tabContent, toggleText, defaultState, callback)
        local toggleButton = Instance.new("TextButton", tabContent)
        toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
        toggleButton.AnchorPoint = Vector2.new(0.5, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        toggleButton.Text = ""

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
        if isToggled then
            switchHandle.Position = UDim2.new(0, 2, 0.5, 0)
            switchHandle.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
        end

        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = isToggled and {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 50, 255)} 
                                 or {Position = UDim2.new(1, -18, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
            local tween = TweenService:Create(switchHandle, tweenInfo, goal)
            tween:Play()
            callback(isToggled)
        end)
    end

    -- เมธอด AddButton (เพิ่มอนิเมชั่นตอนกดปุ่ม)
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

        button.MouseButton1Click:Connect(function()
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local pressTween = TweenService:Create(button, tweenInfo, {Size = UDim2.new(0.85, 0, 0, 28)})
            local releaseTween = TweenService:Create(button, tweenInfo, {Size = UDim2.new(0.9, 0, 0, 30)})
            pressTween:Play()
            pressTween.Completed:Connect(function()
                releaseTween:Play()
            end)
            callback()
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
    function XDLuaUI:AddTabDescription(tabContent, descriptionText, emoji, emojiPosition)
        local descriptionLabel = Instance.new("TextLabel", tabContent)
        descriptionLabel.Size = UDim2.new(0.9, 0, 0, 40)
        descriptionLabel.AnchorPoint = Vector2.new(0.5, 0)

        local emoji = emoji or ""
        local emojiPosition = emojiPosition or "front"
        if emoji ~= "" then
            if emojiPosition == "back" then
                descriptionLabel.Text = descriptionText .. " " .. emoji
            else
                descriptionLabel.Text = emoji .. " " .. descriptionText
            end
        else
            descriptionLabel.Text = descriptionText
        end

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
        buttonTextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255, 255, 255)

        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, 8)

        button.MouseButton1Click:Connect(callback)
    end

    -- เมธอดเพิ่ม Toggle พร้อมคำอธิบาย
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
        if isToggled then
            switchHandle.Position = UDim2.new(0, 2, 0.5, 0)
            switchHandle.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
        end

        toggleButton.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            if isToggled then
                switchHandle.Position = UDim2.new(0, 2, 0.5, 0)
                switchHandle.BackgroundColor3 = Color3.fromRGB(255, 50, 255)
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

    -- การทำงานของปุ่มลบ UI
    deleteButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false -- ซ่อน UI
        confirmFrame.Visible = true -- แสดงหน้ายืนยัน
    end)

    -- การทำงานของปุ่มยืนยัน
    yesButton.MouseButton1Click:Connect(function()
        screenGui:Destroy() -- ลบ UI และโลโก้ทั้งหมดทันที
    end)

    noButton.MouseButton1Click:Connect(function()
        confirmFrame.Visible = false
        mainFrame.Visible = true -- แสดง UI
    end)

    -- การทำงานของปุ่มโลโก้
    logoButton.MouseButton1Click:Connect(function()
        if mainFrame.Visible and not confirmFrame.Visible then
            mainFrame.Visible = false
        elseif not confirmFrame.Visible then
            mainFrame.Visible = true
        end
    end)

    -- แก้ไขการแสดง UI หลังหน้ายินดีต้อนรับ
    barTween2.Completed:Connect(function()
        loadingFrame:Destroy()
        textTween:Cancel()
        
        welcomeFrame.Visible = true
        wait(3)
        welcomeFrame:Destroy()
        
        logoButton.Visible = true
        mainFrame.Visible = true -- แสดง UI โดยไม่มีอนิเมชั่น
    end)
    
    return XDLuaUI
end

return XDLuaUI
