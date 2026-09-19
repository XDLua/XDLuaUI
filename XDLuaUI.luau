--[[
  XDLuaUI v2.0 -- Crimson Script | Executor-Compatible Roblox UI Library
  Themes: Crimson | Ocean | Forest | Midnight
  
  Usage:
    local UI     = loadstring(...)()
    local Window = UI:CreateWindow({ Title="My Script", Subtitle="v1.0", Theme="Crimson" })
    Window:Notify("Title", "Message", 3, "success")
    local Tab = Window:AddTab("Main", "")
    Tab:AddButton("Click", function() end)
    Tab:AddToggle("Enable", false, function(v) end)
    Tab:AddSlider("FOV", 1, 360, 90, function(v) end)
    Tab:AddDropdown("Hitpart", {"Head","Torso"}, function(v) end)
    Tab:AddKeybind("Key", Enum.KeyCode.RightShift, function() end)
    Tab:AddTextBox("Name", "placeholder...", function(t, enter) end)
    Tab:AddColorPicker("Color", Color3.fromRGB(255,0,0), function(c) end)
    Window:SetTheme("Ocean")
]]

local XDLuaUI = {}
XDLuaUI.Version = "2.0"

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Lighting         = game:GetService("Lighting")

-- [Executor Compat] gethui() hides GUI from game detection
local GuiParent = (typeof(gethui) == "function" and gethui()) or CoreGui

local function SafeProtect(gui)
    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, gui)
    elseif typeof(protect_gui) == "function" then
        pcall(protect_gui, gui)
    end
end

-- [Themes]
local Themes = {
    Crimson = {
        Main=Color3.fromRGB(15,15,15), Secondary=Color3.fromRGB(25,25,25),
        Accent=Color3.fromRGB(220,20,60), AccentDark=Color3.fromRGB(150,10,35),
        Text=Color3.fromRGB(245,245,245), TextDark=Color3.fromRGB(170,170,170),
        Stroke=Color3.fromRGB(50,50,50), Success=Color3.fromRGB(50,210,90),
        Warn=Color3.fromRGB(240,185,0), Error=Color3.fromRGB(220,50,50),
        Info=Color3.fromRGB(60,160,245), Rounding=UDim.new(0,8),
    },
    Ocean = {
        Main=Color3.fromRGB(10,18,30), Secondary=Color3.fromRGB(18,30,50),
        Accent=Color3.fromRGB(0,190,255), AccentDark=Color3.fromRGB(0,120,190),
        Text=Color3.fromRGB(235,248,255), TextDark=Color3.fromRGB(140,185,220),
        Stroke=Color3.fromRGB(35,60,95), Success=Color3.fromRGB(50,210,90),
        Warn=Color3.fromRGB(240,185,0), Error=Color3.fromRGB(220,50,50),
        Info=Color3.fromRGB(60,160,245), Rounding=UDim.new(0,8),
    },
    Forest = {
        Main=Color3.fromRGB(12,20,14), Secondary=Color3.fromRGB(20,36,24),
        Accent=Color3.fromRGB(55,210,90), AccentDark=Color3.fromRGB(30,145,55),
        Text=Color3.fromRGB(235,255,238), TextDark=Color3.fromRGB(145,210,158),
        Stroke=Color3.fromRGB(38,70,45), Success=Color3.fromRGB(50,210,90),
        Warn=Color3.fromRGB(240,185,0), Error=Color3.fromRGB(220,50,50),
        Info=Color3.fromRGB(60,160,245), Rounding=UDim.new(0,8),
    },
    Midnight = {
        Main=Color3.fromRGB(8,8,22), Secondary=Color3.fromRGB(16,16,38),
        Accent=Color3.fromRGB(138,86,255), AccentDark=Color3.fromRGB(90,50,190),
        Text=Color3.fromRGB(245,240,255), TextDark=Color3.fromRGB(165,155,215),
        Stroke=Color3.fromRGB(50,45,85), Success=Color3.fromRGB(50,210,90),
        Warn=Color3.fromRGB(240,185,0), Error=Color3.fromRGB(220,50,50),
        Info=Color3.fromRGB(60,160,245), Rounding=UDim.new(0,8),
    },
}

local Theme = Themes.Crimson
local TI    = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- [Helpers]
local function Tween(obj, props, dur)
    local t = TweenService:Create(obj, dur and TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or TI, props)
    t:Play(); return t
end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    if parent then obj.Parent = parent end
    return obj
end

-- [Connection Manager] prevents memory leaks
local function NewConnMgr()
    local list = {}
    return {
        Connect = function(self, signal, fn)
            local c = signal:Connect(fn)
            table.insert(list, c); return c
        end,
        DisconnectAll = function()
            for _, c in ipairs(list) do
                pcall(function() if c.Connected then c:Disconnect() end end)
            end
            table.clear(list)
        end,
    }
end

-- [Draggable] fixed with connection manager
local function MakeDraggable(handle, target, mgr)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    mgr:Connect(handle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    mgr:Connect(handle.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    mgr:Connect(UserInputService.InputChanged, function(input)
        if dragging and input == dragInput then
            local d = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
end

-- ============================================================
function XDLuaUI:CreateWindow(config)
    if type(config) == "string" then config = { Title = config } end
    config = config or {}
    local winTitle  = config.Title    or "CRIMSON SCRIPT"
    local winSub    = config.Subtitle or "v1.0"
    local winLogo   = config.Logo     or "rbxassetid://111935661110067"
    local themeName = config.Theme    or "Crimson"
    if Themes[themeName] then Theme = Themes[themeName] end

    local mgr = NewConnMgr()

    if GuiParent:FindFirstChild("XDLuaGUI") then
        GuiParent:FindFirstChild("XDLuaGUI"):Destroy()
    end

    local screenGui = New("ScreenGui", {
        Name="XDLuaGUI", IgnoreGuiInset=true, ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    }, GuiParent)
    SafeProtect(screenGui)
    screenGui.AncestryChanged:Connect(function()
        if not screenGui.Parent then mgr.DisconnectAll() end
    end)

    -- Blur (executor-safe pcall)
    local blur
    pcall(function()
        blur = New("BlurEffect", { Size = 0 }, Lighting)
        Tween(blur, { Size = 24 }, 0.5)
    end)

    -- Loading Screen
    local loadFrame = New("Frame", {
        Size=UDim2.new(0,390,0,210), Position=UDim2.new(0.5,-195,0.5,-105),
        BackgroundColor3=Theme.Main, BackgroundTransparency=1, BorderSizePixel=0,
    }, screenGui)
    New("UICorner", { CornerRadius=UDim.new(0,14) }, loadFrame)
    New("UIGradient", {
        Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(35,35,35)),ColorSequenceKeypoint.new(1,Theme.Main)}),
        Rotation=110,
    }, loadFrame)
    local loadStroke = New("UIStroke", { Color=Theme.Accent, Thickness=1.5, Transparency=1 }, loadFrame)
    local loadTitle = New("TextLabel", {
        Size=UDim2.new(1,0,0,58), Position=UDim2.new(0,0,0,22),
        Text=winTitle, TextColor3=Theme.Accent, TextTransparency=1,
        BackgroundTransparency=1, Font=Enum.Font.GothamBlack, TextSize=30, ZIndex=2,
    }, loadFrame)
    local loadSub = New("TextLabel", {
        Size=UDim2.new(1,0,0,18), Position=UDim2.new(0,0,0,78),
        Text=winSub, TextColor3=Theme.TextDark, TextTransparency=1,
        BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=12,
    }, loadFrame)
    local statusLabel = New("TextLabel", {
        Size=UDim2.new(1,-24,0,18), Position=UDim2.new(0,12,0,148),
        Text="Initializing...", TextColor3=Theme.TextDark, TextTransparency=1,
        BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, loadFrame)
    local barTrack = New("Frame", {
        Size=UDim2.new(0.84,0,0,5), Position=UDim2.new(0.08,0,0,172),
        BackgroundColor3=Theme.Secondary, BackgroundTransparency=1, BorderSizePixel=0,
    }, loadFrame)
    New("UICorner", { CornerRadius=UDim.new(1,0) }, barTrack)
    local barFill = New("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=Theme.Accent, BorderSizePixel=0 }, barTrack)
    New("UICorner", { CornerRadius=UDim.new(1,0) }, barFill)
    New("UIStroke", { Color=Theme.Accent, Thickness=2, Transparency=0.5 }, barFill)

    -- Bouncing dots animation
    local dotHolder = New("Frame", {
        Size=UDim2.new(0,44,0,14), Position=UDim2.new(0.5,-22,0,188), BackgroundTransparency=1,
    }, loadFrame)
    local dots = {}
    for i = 1, 3 do
        dots[i] = New("Frame", {
            Size=UDim2.new(0,7,0,7), Position=UDim2.new(0,(i-1)*18,0.5,-3),
            BackgroundColor3=Theme.Accent, BackgroundTransparency=0.5, BorderSizePixel=0,
        }, dotHolder)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, dots[i])
    end
    local dotThread = task.spawn(function()
        while dotHolder and dotHolder.Parent do
            for i = 1, 3 do
                if dots[i] and dots[i].Parent then
                    Tween(dots[i], { Position=UDim2.new(0,(i-1)*18,0,0), BackgroundTransparency=0 }, 0.18)
                    task.wait(0.11)
                    Tween(dots[i], { Position=UDim2.new(0,(i-1)*18,0.5,-3), BackgroundTransparency=0.5 }, 0.18)
                end
            end
            task.wait(0.08)
        end
    end)

    Tween(loadFrame, { BackgroundTransparency=0 }, 0.5)
    Tween(loadStroke, { Transparency=0 }, 0.5)
    Tween(loadTitle, { TextTransparency=0 }, 0.5)
    Tween(loadSub, { TextTransparency=0 }, 0.5)
    Tween(statusLabel, { TextTransparency=0 }, 0.5)
    Tween(barTrack, { BackgroundTransparency=0 }, 0.5)
    task.wait(0.6)

    task.spawn(function()
        local msgs = {"Checking version...","Loading modules...","Preparing UI...","Almost ready..."}
        local waits = {0.5, 0.8, 0.8, 0.6}
        for i, m in ipairs(msgs) do
            task.wait(waits[i])
            if statusLabel and statusLabel.Parent then statusLabel.Text = m end
        end
    end)

    local barTween = Tween(barFill, { Size=UDim2.new(1,0,1,0) }, 3.4)
    barTween.Completed:Wait()
    if statusLabel.Parent then statusLabel.Text = "Ready!" end
    task.wait(0.4)

    Tween(loadFrame, { BackgroundTransparency=1 }, 0.4)
    Tween(loadStroke, { Transparency=1 }, 0.4)
    Tween(loadTitle, { TextTransparency=1 }, 0.4)
    Tween(loadSub, { TextTransparency=1 }, 0.4)
    Tween(statusLabel, { TextTransparency=1 }, 0.4)
    Tween(barTrack, { BackgroundTransparency=1 }, 0.4)
    if blur then pcall(function() Tween(blur, { Size=0 }, 0.4) end) end
    task.wait(0.45)
    task.cancel(dotThread)
    pcall(function() loadFrame:Destroy() end)
    pcall(function() if blur then blur:Destroy() end end)

    -- Logo Button
    local logoBtn = New("TextButton", {
        Name="LogoButton", Size=UDim2.new(0,48,0,48), Position=UDim2.new(0,20,0.5,-24),
        BackgroundColor3=Theme.Main, Text="", AutoButtonColor=false, Active=true, ZIndex=10, BorderSizePixel=0,
    }, screenGui)
    New("UICorner", { CornerRadius=UDim.new(0,10) }, logoBtn)
    local logoStroke = New("UIStroke", { Color=Theme.Accent, Thickness=1.5 }, logoBtn)
    New("ImageLabel", {
        Size=UDim2.new(0.78,0,0.78,0), Position=UDim2.new(0.5,0,0.5,0), AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=1, Image=winLogo, ScaleType=Enum.ScaleType.Fit,
    }, logoBtn)
    MakeDraggable(logoBtn, logoBtn, mgr)
    mgr:Connect(logoBtn.MouseEnter, function()
        Tween(logoBtn, { Size=UDim2.new(0,56,0,56) }, 0.16)
        Tween(logoStroke, { Thickness=2.5 }, 0.16)
    end)
    mgr:Connect(logoBtn.MouseLeave, function()
        Tween(logoBtn, { Size=UDim2.new(0,48,0,48) }, 0.16)
        Tween(logoStroke, { Thickness=1.5 }, 0.16)
    end)

    -- Main Frame
    local mainFrame = New("Frame", {
        Name="MainFrame", Size=UDim2.new(0,550,0,370), Position=UDim2.new(0.5,-275,0.5,-185),
        BackgroundColor3=Theme.Main, BorderSizePixel=0, ClipsDescendants=true,
    }, screenGui)
    New("UICorner", { CornerRadius=Theme.Rounding }, mainFrame)
    New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, mainFrame)

    -- Header with gradient
    local header = New("Frame", {
        Size=UDim2.new(1,0,0,46), BackgroundColor3=Color3.fromRGB(22,22,22), BorderSizePixel=0, ZIndex=3,
    }, mainFrame)
    New("UICorner", { CornerRadius=Theme.Rounding }, header)
    New("UIGradient", {
        Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(38,38,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,18))}),
        Rotation=90,
    }, header)
    -- Separator under header
    New("Frame", {
        Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,46),
        BackgroundColor3=Theme.Stroke, BorderSizePixel=0, ZIndex=2,
    }, mainFrame)
    -- Title
    New("TextLabel", {
        Size=UDim2.new(1,-100,1,0), Position=UDim2.new(0,14,0,0),
        Text=winTitle, TextColor3=Theme.Accent, Font=Enum.Font.GothamBold, TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1, ZIndex=4,
    }, header)

    -- Close button
    local closeBtn = New("TextButton", {
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-36,0.5,-14),
        BackgroundColor3=Color3.fromRGB(200,48,48), Text="x",
        TextColor3=Color3.fromRGB(255,255,255), TextSize=18, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, ZIndex=5, BorderSizePixel=0,
    }, header)
    New("UICorner", { CornerRadius=UDim.new(0,6) }, closeBtn)
    mgr:Connect(closeBtn.MouseEnter, function() Tween(closeBtn, { BackgroundColor3=Color3.fromRGB(255,70,70) }, 0.12) end)
    mgr:Connect(closeBtn.MouseLeave, function() Tween(closeBtn, { BackgroundColor3=Color3.fromRGB(200,48,48) }, 0.12) end)
    mgr:Connect(closeBtn.MouseButton1Click, function() screenGui:Destroy() end)

    -- Minimize button
    local minBtn = New("TextButton", {
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-70,0.5,-14),
        BackgroundColor3=Color3.fromRGB(55,55,55), Text="-", TextColor3=Theme.TextDark,
        TextSize=16, Font=Enum.Font.GothamBold, AutoButtonColor=false, ZIndex=5, BorderSizePixel=0,
    }, header)
    New("UICorner", { CornerRadius=UDim.new(0,6) }, minBtn)
    local minimized = false
    mgr:Connect(minBtn.MouseButton1Click, function()
        minimized = not minimized
        Tween(mainFrame, { Size=minimized and UDim2.new(0,550,0,46) or UDim2.new(0,550,0,370) }, 0.22)
        minBtn.Text = minimized and "+" or "-"
    end)

    MakeDraggable(header, mainFrame, mgr)

    -- Logo toggles mainFrame visibility
    mgr:Connect(logoBtn.MouseButton1Click, function()
        mainFrame.Visible = not mainFrame.Visible
        Tween(logoBtn, { BackgroundColor3=mainFrame.Visible and Theme.Main or Theme.AccentDark }, 0.15)
    end)

    -- Sidebar
    local sidebar = New("Frame", {
        Size=UDim2.new(0,140,1,-56), Position=UDim2.new(0,6,0,51),
        BackgroundColor3=Theme.Secondary, BorderSizePixel=0,
    }, mainFrame)
    New("UICorner", { CornerRadius=UDim.new(0,7) }, sidebar)
    New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, sidebar)
    local tabScroll = New("ScrollingFrame", {
        Size=UDim2.new(1,-8,1,-8), Position=UDim2.new(0,4,0,4),
        BackgroundTransparency=1, ScrollBarThickness=0,
        AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0), BorderSizePixel=0,
    }, sidebar)
    New("UIListLayout", { Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder, HorizontalAlignment=Enum.HorizontalAlignment.Center }, tabScroll)
    New("UIPadding", { PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4) }, tabScroll)

    -- Content Area
    local contentArea = New("Frame", {
        Size=UDim2.new(1,-157,1,-56), Position=UDim2.new(0,153,0,51),
        BackgroundColor3=Theme.Secondary, BorderSizePixel=0, ClipsDescendants=true,
    }, mainFrame)
    New("UICorner", { CornerRadius=UDim.new(0,7) }, contentArea)
    New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, contentArea)

    -- Notification Holder (bottom-right, stacks upward)
    local notifHolder = New("Frame", {
        Size=UDim2.new(0,298,1,-20), Position=UDim2.new(1,-308,0,10),
        BackgroundTransparency=1, ZIndex=100,
    }, screenGui)
    New("UIListLayout", {
        Padding=UDim.new(0,6), VerticalAlignment=Enum.VerticalAlignment.Bottom,
        SortOrder=Enum.SortOrder.LayoutOrder, FillDirection=Enum.FillDirection.Vertical,
    }, notifHolder)
    New("UIPadding", { PaddingBottom=UDim.new(0,8), PaddingRight=UDim.new(0,4) }, notifHolder)
    local notifOrder = 0

    -- Window object returned to user
    local Window = {}
    local tabs = {}
    local activeTab = nil

    local function NextOrder(tabContent)
        for _, t in pairs(tabs) do
            if t.Content == tabContent then
                t.Order = (t.Order or 0) + 1
                return t.Order
            end
        end
        return 0
    end

    -- NOTIFY
    function Window:Notify(ntitle, message, duration, ntype)
        duration = duration or 3; ntype = ntype or "info"
        local typeColor = { info=Theme.Info, success=Theme.Success, warn=Theme.Warn, error=Theme.Error }
        local typeIcon  = { info="i", success="v", warn="!", error="x" }
        local accent = typeColor[ntype] or Theme.Info
        local icon   = typeIcon[ntype] or "i"
        notifOrder = notifOrder + 1
        local card = New("Frame", {
            LayoutOrder=notifOrder, Size=UDim2.new(1,0,0,72),
            BackgroundColor3=Theme.Main, BackgroundTransparency=0.06, BorderSizePixel=0, ZIndex=100,
        }, notifHolder)
        New("UICorner", { CornerRadius=UDim.new(0,9) }, card)
        New("UIStroke", { Color=accent, Thickness=1.2, Transparency=0.3 }, card)
        New("Frame", {
            Size=UDim2.new(0,4,0.7,0), Position=UDim2.new(0,0,0.15,0),
            BackgroundColor3=accent, BorderSizePixel=0, ZIndex=101,
        }, card)
        New("TextLabel", {
            Size=UDim2.new(0,22,0,22), Position=UDim2.new(0,12,0,10),
            Text=icon, TextColor3=accent, TextSize=14, Font=Enum.Font.GothamBold,
            BackgroundTransparency=1, ZIndex=101,
        }, card)
        New("TextLabel", {
            Size=UDim2.new(1,-52,0,24), Position=UDim2.new(0,42,0,6),
            Text=ntitle, TextColor3=Theme.Text, TextSize=13, Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1, ZIndex=101,
        }, card)
        New("TextLabel", {
            Size=UDim2.new(1,-52,0,28), Position=UDim2.new(0,42,0,30),
            Text=message, TextColor3=Theme.TextDark, TextSize=11, Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, BackgroundTransparency=1, ZIndex=101,
        }, card)
        local pTrack = New("Frame", {
            Size=UDim2.new(1,-14,0,3), Position=UDim2.new(0,7,1,-6),
            BackgroundColor3=Theme.Secondary, BorderSizePixel=0, ZIndex=101,
        }, card)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, pTrack)
        local pFill = New("Frame", { Size=UDim2.new(1,0,1,0), BackgroundColor3=accent, BorderSizePixel=0, ZIndex=102 }, pTrack)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, pFill)
        Tween(pFill, { Size=UDim2.new(0,0,1,0) }, duration)
        task.delay(duration, function()
            Tween(card, { BackgroundTransparency=1 }, 0.3)
            task.wait(0.32)
            pcall(function() card:Destroy() end)
        end)
    end

    -- ADD TAB
    function Window:AddTab(tabName, emoji)
        local tabBtn = New("TextButton", {
            Size=UDim2.new(1,-8,0,34), BackgroundColor3=Theme.Main, BackgroundTransparency=0.6,
            Text=(emoji or "") .. "  " .. tabName, TextColor3=Theme.TextDark,
            Font=Enum.Font.GothamMedium, TextSize=12, AutoButtonColor=false, BorderSizePixel=0,
        }, tabScroll)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, tabBtn)
        local indicator = New("Frame", {
            Size=UDim2.new(0,3,0.55,0), Position=UDim2.new(0,1,0.225,0),
            BackgroundColor3=Theme.Accent, Visible=false, BorderSizePixel=0,
        }, tabBtn)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, indicator)
        local tabContent = New("ScrollingFrame", {
            Size=UDim2.new(1,-8,1,-8), Position=UDim2.new(0,4,0,4), Visible=false,
            BackgroundTransparency=1, ScrollBarThickness=3, ScrollBarImageColor3=Theme.Accent,
            AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(0,0,0,0), BorderSizePixel=0,
        }, contentArea)
        New("UIListLayout", { Padding=UDim.new(0,7), HorizontalAlignment=Enum.HorizontalAlignment.Center, SortOrder=Enum.SortOrder.LayoutOrder }, tabContent)
        New("UIPadding", { PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,10) }, tabContent)

        local function Activate()
            for _, t in pairs(tabs) do
                t.Btn.TextColor3=Theme.TextDark; t.Btn.BackgroundTransparency=0.6
                t.Indicator.Visible=false; t.Content.Visible=false
            end
            tabBtn.TextColor3=Theme.Accent; tabBtn.BackgroundTransparency=0
            indicator.Visible=true; tabContent.Visible=true; activeTab=tabName
        end
        mgr:Connect(tabBtn.MouseButton1Click, Activate)
        mgr:Connect(tabBtn.MouseEnter, function()
            if activeTab ~= tabName then Tween(tabBtn, { BackgroundTransparency=0.35 }, 0.12) end
        end)
        mgr:Connect(tabBtn.MouseLeave, function()
            if activeTab ~= tabName then Tween(tabBtn, { BackgroundTransparency=0.6 }, 0.12) end
        end)
        tabs[tabName] = { Btn=tabBtn, Content=tabContent, Order=0, Indicator=indicator }
        if not activeTab then Activate() end

        local Tab = {}
        function Tab:AddSection(text)               return Window:_Section(tabContent, text) end
        function Tab:AddLabel(text, color)          return Window:_Label(tabContent, text, color) end
        function Tab:AddButton(text, cb)            return Window:_Button(tabContent, text, cb) end
        function Tab:AddToggle(text, def, cb)       return Window:_Toggle(tabContent, text, def, cb) end
        function Tab:AddSlider(text, mn, mx, d, cb) return Window:_Slider(tabContent, text, mn, mx, d, cb) end
        function Tab:AddDropdown(text, list, cb)    return Window:_Dropdown(tabContent, text, list, cb) end
        function Tab:AddKeybind(text, key, cb)      return Window:_Keybind(tabContent, text, key, cb) end
        function Tab:AddTextBox(text, ph, cb)       return Window:_TextBox(tabContent, text, ph, cb) end
        function Tab:AddColorPicker(text, def, cb)  return Window:_ColorPicker(tabContent, text, def, cb) end
        return Tab
    end

    -- SECTION
    function Window:_Section(parent, text)
        local f = New("Frame", { LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,26), BackgroundTransparency=1 }, parent)
        New("TextLabel", {
            Size=UDim2.new(0.55,0,1,0), Text="  "..text:upper(), TextColor3=Theme.Accent,
            Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, BackgroundTransparency=1,
        }, f)
        New("Frame", { Size=UDim2.new(0.38,0,0,1), Position=UDim2.new(0.6,0,0.5,0), BackgroundColor3=Theme.Stroke, BorderSizePixel=0 }, f)
        return f
    end

    -- LABEL
    function Window:_Label(parent, text, color)
        local lbl = New("TextLabel", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,22), BackgroundTransparency=1,
            Text=text, TextColor3=color or Theme.TextDark, Font=Enum.Font.GothamMedium, TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
        }, parent)
        New("UIPadding", { PaddingLeft=UDim.new(0,10) }, lbl)
        local F = {}
        function F:Set(t) lbl.Text = t end
        function F:SetColor(c) lbl.TextColor3 = c end
        return F
    end

    -- BUTTON
    function Window:_Button(parent, text, callback)
        local btn = New("TextButton", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,34), BackgroundColor3=Theme.Main,
            Text=text, TextColor3=Theme.Text, Font=Enum.Font.GothamMedium, TextSize=13,
            AutoButtonColor=false, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, btn)
        local bStroke = New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, btn)
        mgr:Connect(btn.MouseEnter, function()
            Tween(bStroke, { Color=Theme.Accent }, 0.14)
            Tween(btn, { BackgroundColor3=Color3.fromRGB(28,28,28) }, 0.14)
        end)
        mgr:Connect(btn.MouseLeave, function()
            Tween(bStroke, { Color=Theme.Stroke }, 0.14)
            Tween(btn, { BackgroundColor3=Theme.Main }, 0.14)
        end)
        mgr:Connect(btn.MouseButton1Down, function() Tween(btn, { Size=UDim2.new(0.93,0,0,32) }, 0.08) end)
        mgr:Connect(btn.MouseButton1Up,   function() Tween(btn, { Size=UDim2.new(0.96,0,0,34) }, 0.1) end)
        mgr:Connect(btn.MouseButton1Click, function() pcall(callback) end)
        local F = {}
        function F:SetText(t) btn.Text = t end
        return F
    end

    -- TOGGLE
    function Window:_Toggle(parent, text, default, callback)
        local on = default == true
        local bg = New("TextButton", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,34), BackgroundColor3=Theme.Main,
            Text="", AutoButtonColor=false, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, bg)
        New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, bg)
        local lbl = New("TextLabel", {
            Size=UDim2.new(1,-55,1,0), Position=UDim2.new(0,12,0,0), Text=text,
            TextColor3=on and Theme.Text or Theme.TextDark, TextXAlignment=Enum.TextXAlignment.Left,
            BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=13,
        }, bg)
        local track = New("Frame", {
            Size=UDim2.new(0,36,0,20), Position=UDim2.new(1,-46,0.5,-10),
            BackgroundColor3=on and Theme.Accent or Theme.Stroke, BorderSizePixel=0,
        }, bg)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, track)
        local knob = New("Frame", {
            Size=UDim2.new(0,14,0,14),
            Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0,
        }, track)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, knob)
        local F = { Value=on }
        local function Sync()
            Tween(track, { BackgroundColor3=on and Theme.Accent or Theme.Stroke }, 0.18)
            Tween(knob, { Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) }, 0.18)
            Tween(lbl, { TextColor3=on and Theme.Text or Theme.TextDark }, 0.18)
            F.Value=on; pcall(callback, on)
        end
        mgr:Connect(bg.MouseButton1Click, function() on = not on; Sync() end)
        function F:Set(v) on=v; Sync() end
        return F
    end

    -- SLIDER
    function Window:_Slider(parent, text, minV, maxV, default, callback)
        local val = math.clamp(default or minV, minV, maxV)
        local frame = New("Frame", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,52), BackgroundColor3=Theme.Main, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, frame)
        New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, frame)
        New("TextLabel", {
            Size=UDim2.new(1,-52,0,28), Position=UDim2.new(0,10,0,2), Text=text,
            TextColor3=Theme.TextDark, TextXAlignment=Enum.TextXAlignment.Left,
            BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=12,
        }, frame)
        local valLbl = New("TextLabel", {
            Size=UDim2.new(0,44,0,28), Position=UDim2.new(1,-50,0,2),
            TextColor3=Theme.Accent, Font=Enum.Font.GothamBold, TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Right, BackgroundTransparency=1,
        }, frame)
        local track = New("Frame", {
            Size=UDim2.new(0.88,0,0,5), Position=UDim2.new(0.06,0,0,36),
            BackgroundColor3=Theme.Secondary, BorderSizePixel=0,
        }, frame)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, track)
        local fill = New("Frame", { BackgroundColor3=Theme.Accent, BorderSizePixel=0 }, track)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, fill)
        local thumb = New("Frame", {
            Size=UDim2.new(0,13,0,13), AnchorPoint=Vector2.new(0.5,0.5),
            BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, ZIndex=2,
        }, track)
        New("UICorner", { CornerRadius=UDim.new(1,0) }, thumb)
        New("UIStroke", { Color=Theme.Accent, Thickness=2 }, thumb)

        local F = { Value=val }
        local function Display(v)
            local pct = (v-minV)/(maxV-minV)
            fill.Size=UDim2.new(pct,0,1,0); thumb.Position=UDim2.new(pct,0,0.5,0)
            valLbl.Text=tostring(v); F.Value=v
        end
        Display(val)
        local slDrag = false
        local function Slide(x)
            local pct = math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X, 0, 1)
            local v = math.floor(minV+(maxV-minV)*pct)
            Display(v); pcall(callback, v)
        end
        mgr:Connect(track.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                slDrag=true; Slide(input.Position.X)
                Tween(thumb, { Size=UDim2.new(0,17,0,17) }, 0.1)
            end
        end)
        mgr:Connect(UserInputService.InputEnded, function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and slDrag then
                slDrag=false; Tween(thumb, { Size=UDim2.new(0,13,0,13) }, 0.1)
            end
        end)
        mgr:Connect(UserInputService.InputChanged, function(input)
            if slDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                Slide(input.Position.X)
            end
        end)
        function F:Set(v) v=math.clamp(math.floor(v),minV,maxV); Display(v); pcall(callback,v) end
        return F
    end

    -- DROPDOWN
    function Window:_Dropdown(parent, text, list, callback)
        local dropped=false; local selected={}; local currentList=list or {}
        local dropFrame = New("Frame", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,34), BackgroundColor3=Theme.Main,
            ClipsDescendants=true, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, dropFrame)
        local dStroke = New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, dropFrame)
        local headerBtn = New("TextButton", {
            Size=UDim2.new(1,-38,0,34), BackgroundTransparency=1,
            Text=text.."  v", TextColor3=Theme.Text, Font=Enum.Font.GothamMedium, TextSize=13,
        }, dropFrame)
        local refreshBtn = New("TextButton", {
            Size=UDim2.new(0,30,0,28), Position=UDim2.new(1,-34,0,3),
            BackgroundColor3=Theme.Secondary, Text="R", TextColor3=Theme.Accent,
            TextSize=14, Font=Enum.Font.GothamBold, AutoButtonColor=false, BorderSizePixel=0,
        }, dropFrame)
        New("UICorner", { CornerRadius=UDim.new(0,4) }, refreshBtn)
        local itemScroll = New("ScrollingFrame", {
            Size=UDim2.new(1,0,0,120), Position=UDim2.new(0,0,0,34),
            BackgroundTransparency=1, ScrollBarThickness=3, ScrollBarImageColor3=Theme.Accent, BorderSizePixel=0,
        }, dropFrame)
        New("UIListLayout", { SortOrder=Enum.SortOrder.LayoutOrder }, itemScroll)
        New("UIPadding", { PaddingTop=UDim.new(0,3), PaddingBottom=UDim.new(0,3) }, itemScroll)

        local function UpdateHeader()
            local count=0; for _ in pairs(selected) do count=count+1 end
            local arrow = dropped and "^" or "v"
            headerBtn.Text = count==0 and (text.."  "..arrow) or (text.." ("..count..")  "..arrow)
        end
        local function Rebuild(items)
            for _, c in ipairs(itemScroll:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for i, item in ipairs(items) do
                local key=tostring(item); local iSel=selected[key]~=nil
                local ib = New("TextButton", {
                    LayoutOrder=i, Size=UDim2.new(1,0,0,30),
                    BackgroundColor3=Theme.Accent, BackgroundTransparency=iSel and 0.72 or 1,
                    Text="   "..key, TextColor3=iSel and Theme.Accent or Theme.TextDark,
                    Font=Enum.Font.GothamMedium, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
                    AutoButtonColor=false, BorderSizePixel=0,
                }, itemScroll)
                mgr:Connect(ib.MouseButton1Click, function()
                    if selected[key] then
                        selected[key]=nil; ib.BackgroundTransparency=1
                        Tween(ib, { TextColor3=Theme.TextDark }, 0.14)
                    else
                        selected[key]=item; ib.BackgroundTransparency=0.72
                        Tween(ib, { TextColor3=Theme.Accent }, 0.14)
                    end
                    local result={}; for _, v in pairs(selected) do table.insert(result,v) end
                    UpdateHeader(); pcall(callback, result)
                end)
            end
            itemScroll.CanvasSize = UDim2.new(0,0,0,#items*30+6)
        end
        Rebuild(currentList)
        mgr:Connect(headerBtn.MouseButton1Click, function()
            dropped = not dropped
            local maxH = math.min(34+#currentList*30+12, 170)
            Tween(dropFrame, { Size=dropped and UDim2.new(0.96,0,0,maxH) or UDim2.new(0.96,0,0,34) }, 0.2)
            Tween(dStroke, { Color=dropped and Theme.Accent or Theme.Stroke }, 0.2)
            UpdateHeader()
        end)
        mgr:Connect(refreshBtn.MouseButton1Click, function()
            Tween(refreshBtn, { Rotation=refreshBtn.Rotation+360 }, 0.38)
            Rebuild(currentList)
        end)
        local F = {}
        function F:Refresh(newList) currentList=newList or {}; Rebuild(currentList) end
        function F:Set(val)
            selected={}; selected[tostring(val)]=val
            Rebuild(currentList); UpdateHeader(); pcall(callback, {val})
        end
        function F:Clear() selected={}; Rebuild(currentList); UpdateHeader() end
        function F:GetSelected() local r={}; for _,v in pairs(selected) do table.insert(r,v) end; return r end
        return F
    end

    -- KEYBIND
    function Window:_Keybind(parent, text, defaultKey, callback)
        local curKey=(defaultKey and defaultKey.Name) or "None"; local binding=false
        local frame = New("Frame", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,34), BackgroundColor3=Theme.Main, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, frame)
        New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, frame)
        New("TextLabel", {
            Size=UDim2.new(1,-75,1,0), Position=UDim2.new(0,12,0,0), Text=text,
            TextColor3=Theme.TextDark, TextXAlignment=Enum.TextXAlignment.Left,
            BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=12,
        }, frame)
        local kBtn = New("TextButton", {
            Size=UDim2.new(0,64,0,24), Position=UDim2.new(1,-70,0.5,-12),
            BackgroundColor3=Theme.Secondary, Text=curKey, TextColor3=Theme.Accent,
            Font=Enum.Font.GothamBold, TextSize=11, AutoButtonColor=false, BorderSizePixel=0,
        }, frame)
        New("UICorner", { CornerRadius=UDim.new(0,4) }, kBtn)
        New("UIStroke", { Color=Theme.Stroke, Thickness=0.8 }, kBtn)
        mgr:Connect(kBtn.MouseButton1Click, function()
            binding=true; kBtn.Text="..."
            Tween(kBtn, { BackgroundColor3=Color3.fromRGB(50,50,50) }, 0.12)
        end)
        local F = { Key=curKey }
        mgr:Connect(UserInputService.InputBegan, function(input, gpe)
            if gpe then return end
            if binding then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    curKey=input.KeyCode.Name; F.Key=curKey; kBtn.Text=curKey; binding=false
                    Tween(kBtn, { BackgroundColor3=Theme.Secondary }, 0.12)
                end
            elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == curKey then
                pcall(callback, input.KeyCode)
            end
        end)
        return F
    end

    -- TEXTBOX
    function Window:_TextBox(parent, text, placeholder, callback)
        local frame = New("Frame", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,52), BackgroundColor3=Theme.Main, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, frame)
        local fStroke = New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, frame)
        New("TextLabel", {
            Size=UDim2.new(1,-12,0,22), Position=UDim2.new(0,10,0,2), Text=text,
            TextColor3=Theme.TextDark, TextXAlignment=Enum.TextXAlignment.Left,
            BackgroundTransparency=1, Font=Enum.Font.GothamMedium, TextSize=11,
        }, frame)
        local inputBg = New("Frame", {
            Size=UDim2.new(0.9,0,0,24), Position=UDim2.new(0.05,0,0,24),
            BackgroundColor3=Theme.Secondary, BorderSizePixel=0,
        }, frame)
        New("UICorner", { CornerRadius=UDim.new(0,4) }, inputBg)
        local box = New("TextBox", {
            Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1, PlaceholderText=placeholder or "Type here...",
            PlaceholderColor3=Color3.fromRGB(85,85,85), Text="", TextColor3=Theme.Text,
            Font=Enum.Font.Gotham, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
            ClearTextOnFocus=false,
        }, inputBg)
        mgr:Connect(box.Focused, function() Tween(fStroke, { Color=Theme.Accent }, 0.14) end)
        mgr:Connect(box.FocusLost, function(enter)
            Tween(fStroke, { Color=Theme.Stroke }, 0.14); pcall(callback, box.Text, enter)
        end)
        local F = {}
        function F:Set(v) box.Text=tostring(v) end
        function F:Get() return box.Text end
        return F
    end

    -- COLOR PICKER
    function Window:_ColorPicker(parent, text, default, callback)
        local chVals = {
            default and math.floor(default.R*255) or 255,
            default and math.floor(default.G*255) or 255,
            default and math.floor(default.B*255) or 255,
        }
        local open=false; local expandH=34+3*36+6
        local frame = New("Frame", {
            LayoutOrder=NextOrder(parent), Size=UDim2.new(0.96,0,0,34), BackgroundColor3=Theme.Main,
            ClipsDescendants=true, BorderSizePixel=0,
        }, parent)
        New("UICorner", { CornerRadius=UDim.new(0,6) }, frame)
        local fStroke = New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, frame)
        local toggleBtn = New("TextButton", {
            Size=UDim2.new(1,-50,0,34), BackgroundTransparency=1, Text=text,
            TextColor3=Theme.TextDark, Font=Enum.Font.GothamMedium, TextSize=13,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, frame)
        New("UIPadding", { PaddingLeft=UDim.new(0,12) }, toggleBtn)
        local preview = New("Frame", {
            Size=UDim2.new(0,30,0,20), Position=UDim2.new(1,-40,0.5,-10),
            BackgroundColor3=Color3.fromRGB(chVals[1],chVals[2],chVals[3]), BorderSizePixel=0,
        }, frame)
        New("UICorner", { CornerRadius=UDim.new(0,4) }, preview)
        New("UIStroke", { Color=Theme.Stroke, Thickness=1 }, preview)

        local chColors = { Color3.fromRGB(220,55,55), Color3.fromRGB(55,200,80), Color3.fromRGB(80,120,240) }
        local chNames  = { "R", "G", "B" }
        local slObjs   = {}

        for i = 1, 3 do
            local yOff = 34+(i-1)*36
            local chRow = New("Frame", {
                Size=UDim2.new(0.9,0,0,28), Position=UDim2.new(0.05,0,0,yOff+4), BackgroundTransparency=1,
            }, frame)
            New("TextLabel", {
                Size=UDim2.new(0,12,1,0), Text=chNames[i], TextColor3=chColors[i],
                Font=Enum.Font.GothamBold, TextSize=11, BackgroundTransparency=1,
            }, chRow)
            local cTrack = New("Frame", {
                Size=UDim2.new(1,-48,0,5), Position=UDim2.new(0,16,0.5,-2),
                BackgroundColor3=Theme.Secondary, BorderSizePixel=0,
            }, chRow)
            New("UICorner", { CornerRadius=UDim.new(1,0) }, cTrack)
            local p0=chVals[i]/255
            local cFill = New("Frame", { Size=UDim2.new(p0,0,1,0), BackgroundColor3=chColors[i], BorderSizePixel=0 }, cTrack)
            New("UICorner", { CornerRadius=UDim.new(1,0) }, cFill)
            local cThumb = New("Frame", {
                Size=UDim2.new(0,11,0,11), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(p0,0,0.5,0),
                BackgroundColor3=Color3.fromRGB(255,255,255), ZIndex=2, BorderSizePixel=0,
            }, cTrack)
            New("UICorner", { CornerRadius=UDim.new(1,0) }, cThumb)
            local cLbl = New("TextLabel", {
                Size=UDim2.new(0,28,1,0), Position=UDim2.new(1,-28,0,0),
                Text=tostring(chVals[i]), TextColor3=chColors[i],
                Font=Enum.Font.GothamBold, TextSize=10, BackgroundTransparency=1,
            }, chRow)
            slObjs[i] = { track=cTrack, fill=cFill, thumb=cThumb, lbl=cLbl }

            local cDrag=false; local idx=i
            local function MoveC(x)
                local p=math.clamp((x-cTrack.AbsolutePosition.X)/cTrack.AbsoluteSize.X, 0, 1)
                chVals[idx]=math.floor(p*255)
                cFill.Size=UDim2.new(p,0,1,0); cThumb.Position=UDim2.new(p,0,0.5,0)
                cLbl.Text=tostring(chVals[idx])
                local c=Color3.fromRGB(chVals[1],chVals[2],chVals[3])
                preview.BackgroundColor3=c; pcall(callback, c)
            end
            mgr:Connect(cTrack.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then cDrag=true; MoveC(input.Position.X) end
            end)
            mgr:Connect(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then cDrag=false end
            end)
            mgr:Connect(UserInputService.InputChanged, function(input)
                if cDrag and input.UserInputType == Enum.UserInputType.MouseMovement then MoveC(input.Position.X) end
            end)
        end

        mgr:Connect(toggleBtn.MouseButton1Click, function()
            open = not open
            Tween(frame, { Size=open and UDim2.new(0.96,0,0,expandH) or UDim2.new(0.96,0,0,34) }, 0.2)
            Tween(fStroke, { Color=open and Theme.Accent or Theme.Stroke }, 0.2)
        end)

        local F = {}
        function F:Set(color)
            chVals={math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)}
            preview.BackgroundColor3=color
            for i, obj in ipairs(slObjs) do
                local p=chVals[i]/255
                obj.fill.Size=UDim2.new(p,0,1,0); obj.thumb.Position=UDim2.new(p,0,0.5,0)
                obj.lbl.Text=tostring(chVals[i])
            end
            pcall(callback, color)
        end
        return F
    end

    -- SET THEME
    function Window:SetTheme(name)
        if not Themes[name] then return end
        Theme = Themes[name]
        self:Notify("Theme", "Switched to "..name, 2.5, "info")
    end

    return Window
end

return XDLuaUI
