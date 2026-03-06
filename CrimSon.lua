local XDLuaUI = {}

-- [Services]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- [Global Variables]
local CurrentKeybind = Enum.KeyCode.RightControl
local MainUI = nil

-- [Theme Configuration]
local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(255, 50, 255),
    Text = Color3.fromRGB(245, 245, 245),
    TextDark = Color3.fromRGB(180, 180, 180),
    Stroke = Color3.fromRGB(45, 45, 45),
    Rounding = UDim.new(0, 8)
}

-- [Helper Functions]
local function ApplyTween(obj, goal, duration)
    local info = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

local function MakeDraggable(dragPart, frame)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            ApplyTween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- [Library Functions]
function XDLuaUI:CreateWindow(title)
    if CoreGui:FindFirstChild("XDLuaGUI") then CoreGui.XDLuaGUI:Destroy() end

    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "XDLuaGUI"
    screenGui.IgnoreGuiInset = true
    MainUI = screenGui

    -- Main Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 500, 0, 340)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -170)
    mainFrame.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", mainFrame).CornerRadius = Theme.Rounding
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Theme.Stroke
    mainStroke.Thickness = 1.2

    -- Drag Handle (Top Bar)
    local dragHandle = Instance.new("Frame", mainFrame)
    dragHandle.Size = UDim2.new(1, 0, 0, 45)
    dragHandle.BackgroundTransparency = 1
    MakeDraggable(dragHandle, mainFrame)

    local topTitle = Instance.new("TextLabel", mainFrame)
    topTitle.Size = UDim2.new(1, -50, 0, 45)
    topTitle.Position = UDim2.new(0, 15, 0, 0)
    topTitle.Text = title
    topTitle.TextColor3 = Theme.Accent
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextSize = 18
    topTitle.TextXAlignment = "Left"
    topTitle.BackgroundTransparency = 1

    -- Notification System
    function XDLuaUI:Notify(t, d, dur)
        local nFrame = Instance.new("Frame", screenGui)
        nFrame.Size = UDim2.new(0, 220, 0, 60)
        nFrame.Position = UDim2.new(1, 10, 1, -70)
        nFrame.BackgroundColor3 = Theme.Main
        Instance.new("UICorner", nFrame)
        Instance.new("UIStroke", nFrame).Color = Theme.Accent
        
        local nt = Instance.new("TextLabel", nFrame)
        nt.Text = t; nt.Size = UDim2.new(1, 0, 0, 30); nt.TextColor3 = Theme.Accent; nt.Font = "GothamBold"; nt.BackgroundTransparency = 1
        local nd = Instance.new("TextLabel", nFrame)
        nd.Text = d; nd.Size = UDim2.new(1, 0, 0, 30); nd.Position = UDim2.new(0,0,0,25); nd.TextColor3 = Theme.Text; nd.Font = "Gotham"; nd.BackgroundTransparency = 1

        ApplyTween(nFrame, {Position = UDim2.new(1, -230, 1, -70)}, 0.3)
        task.delay(dur or 3, function()
            ApplyTween(nFrame, {Position = UDim2.new(1, 10, 1, -70)}, 0.3)
            task.wait(0.3)
            nFrame:Destroy()
        end)
    end

    -- Tab Setup
    local tabContainer = Instance.new("ScrollingFrame", mainFrame)
    tabContainer.Size = UDim2.new(0, 130, 1, -60)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1; tabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", tabContainer).Padding = UDim.new(0, 5)

    local contentHolder = Instance.new("Frame", mainFrame)
    contentHolder.Size = UDim2.new(1, -160, 1, -60)
    contentHolder.Position = UDim2.new(0, 150, 0, 50)
    contentHolder.BackgroundColor3 = Theme.Secondary
    Instance.new("UICorner", contentHolder)

    local tabs = {}
    function XDLuaUI:AddTab(name, icon)
        local tabBtn = Instance.new("TextButton", tabContainer)
        tabBtn.Size = UDim2.new(1, 0, 0, 35); tabBtn.BackgroundColor3 = Theme.Secondary; tabBtn.Text = icon.." "..name; tabBtn.TextColor3 = Theme.TextDark; tabBtn.Font = "GothamMedium"
        Instance.new("UICorner", tabBtn)
        
        local content = Instance.new("ScrollingFrame", contentHolder)
        content.Size = UDim2.new(1, -10, 1, -10); content.Position = UDim2.new(0,5,0,5); content.Visible = false; content.BackgroundTransparency = 1; content.ScrollBarThickness = 2; content.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", content).HorizontalAlignment = "Center"
        content.UIListLayout.Padding = UDim.new(0, 8)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabs) do v.B.TextColor3 = Theme.TextDark; v.C.Visible = false end
            tabBtn.TextColor3 = Theme.Accent; content.Visible = true
        end)
        tabs[name] = {B = tabBtn, C = content}
        if #tabContainer:GetChildren() == 2 then tabBtn.TextColor3 = Theme.Accent; content.Visible = true end
        return content
    end

    -- Components
    function XDLuaUI:AddButton(parent, text, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Theme.Main; btn.Text = text; btn.TextColor3 = Theme.Text; btn.Font = "GothamMedium"
        Instance.new("UICorner", btn); local s = Instance.new("UIStroke", btn); s.Color = Theme.Stroke
        btn.MouseButton1Click:Connect(cb)
    end

    function XDLuaUI:AddToggle(parent, text, def, cb)
        local t = def
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Theme.Main; btn.Text = "  "..text; btn.TextColor3 = Theme.TextDark; btn.Font = "GothamMedium"; btn.TextXAlignment = "Left"
        Instance.new("UICorner", btn)
        local box = Instance.new("Frame", btn)
        box.Size = UDim2.new(0, 18, 0, 18); box.Position = UDim2.new(1, -28, 0.5, -9); box.BackgroundColor3 = t and Theme.Accent or Theme.Secondary
        Instance.new("UICorner", box)
        btn.MouseButton1Click:Connect(function()
            t = not t; ApplyTween(box, {BackgroundColor3 = t and Theme.Accent or Theme.Secondary}, 0.2); cb(t)
        end)
    end

    -- Keybind System (Special Component)
    function XDLuaUI:AddKeybind(parent, text, def, cb)
        local key = def
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Theme.Main; btn.Text = "  "..text.." : "..key.Name; btn.TextColor3 = Theme.TextDark; btn.Font = "GothamMedium"; btn.TextXAlignment = "Left"
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            btn.Text = "  "..text.." : ..."; local conn
            conn = UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    key = i.KeyCode; btn.Text = "  "..text.." : "..key.Name; cb(key); conn:Disconnect()
                end
            end)
        end)
    end

    -- Keybind Toggle Logic
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == CurrentKeybind then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    return XDLuaUI, topTitle, mainStroke
end

-- [Example Usage with Settings]
local Lib, Title, Stroke = XDLuaUI:CreateWindow("XDLua Pro")
local MainTab = Lib:AddTab("Main", "🏠")
local SettingsTab = Lib:AddTab("Settings", "⚙️")

Lib:AddToggle(MainTab, "Auto Farm", false, function(v) print("Farm:", v) end)

-- Settings: เปลี่ยน Keybind
Lib:AddKeybind(SettingsTab, "Toggle UI", CurrentKeybind, function(newKey)
    CurrentKeybind = newKey
    Lib:Notify("Settings", "เปลี่ยนปุ่มเปิด/ปิดเป็น: "..newKey.Name, 3)
end)

-- Settings: เปลี่ยนสีธีม (Accent Color)
Lib:AddButton(SettingsTab, "Theme: Purple", function() 
    Theme.Accent = Color3.fromRGB(255, 50, 255); Title.TextColor3 = Theme.Accent; Lib:Notify("Theme", "เปลี่ยนเป็นสีม่วงแล้ว", 2)
end)
Lib:AddButton(SettingsTab, "Theme: Blue", function() 
    Theme.Accent = Color3.fromRGB(50, 150, 255); Title.TextColor3 = Theme.Accent; Lib:Notify("Theme", "เปลี่ยนเป็นสีฟ้าแล้ว", 2)
end)
Lib:AddButton(SettingsTab, "Theme: Green", function() 
    Theme.Accent = Color3.fromRGB(50, 255, 150); Title.TextColor3 = Theme.Accent; Lib:Notify("Theme", "เปลี่ยนเป็นสีเขียวแล้ว", 2)
end)

-- Settings: ปิด UI
Lib:AddButton(SettingsTab, "Close UI (Destroy)", function()
    Lib:Notify("Warning", "กำลังปิดการทำงานสคริปต์...", 2)
    task.wait(1)
    MainUI:Destroy()
end)

return XDLuaUI
