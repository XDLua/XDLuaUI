-- ═════════════════════════════════════════════
-- XDLuaUI V2 - God Tier Edition | BY พี่เทพ + C•J
-- รันได้ทุก Executor: Krnl, Fluxus, Delta, Codex, Arceus X, Hydrogen
-- ═════════════════════════════════════════════

local XDLuaUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Notification สวย ๆ
local function Notify(title, text, duration)
    spawn(function()
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title or "XDLua",
                Text = text or "Success!",
                Duration = duration or 4,
                Icon = "rbxassetid://6034832508"
            })
        end)
    end)
end

function XDLuaUI:CreateWindow(title, emojiFront, emojiBack, spacing, keybind)
    keybind = keybind or Enum.KeyCode.RightShift

    if CoreGui:FindFirstChild("XDLuaGUI") then
        CoreGui:FindFirstChild("XDLuaGUI"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XDLuaGUI"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    -- Loading Screen
    local loadingFrame = Instance.new("Frame", screenGui)
    loadingFrame.Size = UDim2.new(0, 320, 0, 160)
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    loadingFrame.BackgroundTransparency = 0.1
    loadingFrame.BorderSizePixel = 0
    local lc = Instance.new("UICorner", loadingFrame); lc.CornerRadius = UDim.new(0, 14)
    local lg = Instance.new("UIStroke", loadingFrame); lg.Thickness = 3; lg.Color = Color3.fromRGB(255, 50, 255); lg.Transparency = 0.3

    local titleLoad = Instance.new("TextLabel", loadingFrame)
    titleLoad.Text = "BY C • J"
    titleLoad.Size = UDim2.new(1,0,0,50)
    titleLoad.Position = UDim2.new(0,0,0,10)
    titleLoad.BackgroundTransparency = Color3.new(0,0,0)
    titleLoad.TextColor3 = Color3.fromRGB(255,50,255)
    titleLoad.Font = Enum.Font.GothamBlack
    titleLoad.TextSize = 28

    local barBack = Instance.new("Frame", loadingFrame)
    barBack.Size = UDim2.new(0.85,0,0,12)
    barBack.Position = UDim2.new(0.075,0,0,80)
    barBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local bc = Instance.new("UICorner", barBack); bc.CornerRadius = UDim.new(1,0)

    local barFill = Instance.new("Frame", barBack)
    barFill.Size = UDim2.new(0,0,1,0)
    barFill.BackgroundColor3 = Color3.fromRGB(255,50,255)
    local fc = Instance.new("UICorner", barFill); fc.CornerRadius = UDim.new(1,0)

    local loadingText = Instance.new("TextLabel", loadingFrame)
    loadingText.Text = "กำลังโหลดสคริปต์สุดเทพ..."
    loadingText.Position = UDim2.new(0,0,0,110)
    loadingText.Size = UDim2.new(1,0,0,30)
    loadingText.BackgroundTransparency = 1
    loadingText.TextColor3 = Color3.new(1,1,1)
    loadingText.Font = Enum.Font.GothamBold
    loadingText.TextSize = 16

    -- Loading Animation
    TweenService:Create(barFill, TweenInfo.new(2.5, Enum.EasingStyle.Sine), {Size = UDim2.new(1,0,1,0)}):Play()
    wait(3)

    loadingFrame:Destroy()
    Notify("XDLua V2", "โหลดสำเร็จแล้วครับท่านเทพ!", 5)

    -- Main UI
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 520, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.Active = true
    mainFrame.Draggable = true
    local mc = Instance.new("UICorner", mainFrame); mc.CornerRadius = UDim.new(0,14)

    -- Rainbow + Breathing Glow
    local glow = Instance.new("UIStroke", mainFrame)
    glow.Thickness = 4
    glow.Transparency = 0.3
    spawn(function()
        while wait(0.05) do
            glow.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        end
    end)

    -- Title
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1,0,0,45)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255,50,255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 22
    titleLabel.Text = (emojiFront or "✨").."  "..(title or "XDLua Hub").."  "..(emojiBack or "✨")

    -- ปุ่ม X, Minimize, Settings
    local closeBtn = Instance.new("TextButton", mainFrame)
    closeBtn.Size = UDim2.new(0,35,0,35)
    closeBtn.Position = UDim2.new(1,-45,0,5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,80)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    local cc = Instance.new("UICorner", closeBtn); cc.CornerRadius = UDim.new(0,10)

    local miniBtn = Instance.new("TextButton", mainFrame)
    miniBtn.Size = UDim2.new(0,35,0,35)
    miniBtn.Position = UDim2.new(1,-85,0,5)
    miniBtn.Text = "–"
    miniBtn.BackgroundColor3 = Color3.fromRGB(100,100,0)
    miniBtn.TextColor3 = Color3.new(1,1,1)
    local mc2 = Instance.new("UICorner", miniBtn); mc2.CornerRadius = UDim.new(0,10)

    -- Logo Button (เปิด/ปิด)
    local logo = Instance.new("TextButton", screenGui)
    logo.Size = UDim2.new(0,60,0,60)
    logo.Position = UDim2.new(0,20,0.5,-30)
    logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
    logo.BackgroundTransparency =  = 0.2
    logo.Text = "XDLua"
    logo.TextColor3 = Color3.fromRGB(255,50,255)
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 20
    logo.Draggable = true
    local lc2 = Instance.new("UICorner", logo); lc2.CornerRadius = UDim.new(1,0)
    spawn(function()
        while wait(0.1) do
            logo.Rotation = logo.Rotation + 3
        end
    end)

    logo.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- Keybind เปิด/ปิด
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == keybind then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Tab System
    local tabs = {}
    local selectedTab = nil

    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Size = UDim2.new(0,140,1,-50)
    tabContainer.Position = UDim2.new(0,10,0,50)
    tabContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
    local tc = Instance.new("UICorner", tabContainer); tc.CornerRadius = UDim.new(0,10)

    local tabScroll = Instance.new("ScrollingFrame", tabContainer)
    tabScroll.Size = UDim2.new(1,0,1,0)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 4
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local list = Instance.new("UIListLayout", tabScroll)
    list.Padding = UDim.new(0,8)
    list.PaddingTop = UDim.new(0,10)

    local content = Instance.new("ScrollingFrame", mainFrame)
    content.Size = UDim2.new(1,-160,1,-60)
    content.Position = UDim2.new(0,150,0,50,10)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y

    -- AddTab
    function XDLuaUI:AddTab(name, emoji)
        local btn = Instance.new("TextButton", tabScroll)
        btn.Size = UDim2.new(0.9,0,0,40)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.Text = (emoji or "Tab").."  "..name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        local bc = Instance.new("UICorner", btn); bc.CornerRadius = UDim.new(0,8)
        local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(255,50,255); stroke.Transparency = 1

        local page = Instance.new("Frame", content)
        page.Size = UDim2.new(1,0,0,0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.AutomaticSize = Enum.AutomaticSize.Y
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,12)
        layout.HorizontalAlignment = "Center"
        layout.PaddingTop = UDim.new(0,10)

        btn.MouseButton1Click:Connect(function()
            if selectedTab then
                TweenService:Create(selectedTab[1], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
                selectedTab[1].UIStroke.Transparency = 1
            end
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100,0,100)}):Play()
            stroke.Transparency = 0.2
            for _, v in pairs(content:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end
            page.Visible = true
            selectedTab = {btn, stroke}
        end)

        if #tabs == 0 then
            btn.BackgroundColor3 = Color3.fromRGB(100,0,100)
            stroke.Transparency = 0.2
            page.Visible = true
            selectedTab = {btn, stroke}
        end

        tabs[#tabs+1] = page
        return page
    end

    -- ตัวอย่างการใช้ (ลบได้)
    local tab1 = XDLuaUI:AddTab("Main", "Home")
    XDLuaUI:AddButton(tab1, "Hello World", function()
        Notify("Test", "กดปุ่มสำเร็จ!")
    end)

    -- ปุ่มปิดสุดท้าย
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        Notify("XDLua", "บายครับ ท่านเทพเจ้า
    end)

    return XDLuaUI
end

return XDLuaUI
