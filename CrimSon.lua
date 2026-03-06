-- [[ XDLua UI Library - Modern Edition 2026 ]] --
-- สคริปต์นี้ออกแบบมาเพื่อใช้งานผ่าน loadstring() โดยเฉพาะ

local XDLua = {}
XDLua.__index = XDLua

-- บริการของ Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- ตั้งค่าธีมและฟอนต์
XDLua.AccentColor = Color3.fromRGB(0, 162, 255)
XDLua.MainColor = Color3.fromRGB(15, 15, 15)
XDLua.SecondaryColor = Color3.fromRGB(30, 30, 30)
XDLua.Font = Enum.Font.GothamMedium

-- ฟังก์ชันภายใน: ระบบลากหน้าต่างแบบสมูท
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [ API: สร้างหน้าต่างหลัก ]
function XDLua:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "XDLua_" .. math.random(1000, 9999)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = XDLua.MainColor
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(45, 45, 45)
    Stroke.Thickness = 1

    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 40); Topbar.BackgroundTransparency = 1
    MakeDraggable(Topbar, MainFrame)

    local Title = Instance.new("TextLabel", Topbar)
    Title.Text = "  " .. (title or "XDLua UI")
    Title.Size = UDim2.new(1, 0, 1, 0); Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = XDLua.Font; Title.TextSize = 18; Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

    local TabScroll = Instance.new("ScrollingFrame", MainFrame)
    TabScroll.Size = UDim2.new(0, 140, 1, -50); TabScroll.Position = UDim2.new(0, 10, 0, 45); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabScroll); TabList.Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Size = UDim2.new(1, -170, 1, -50); PageContainer.Position = UDim2.new(0, 160, 0, 45); PageContainer.BackgroundTransparency = 1

    local WindowAPI = { CurrentPage = nil }

    -- [ API: สร้างแท็บ ]
    function WindowAPI:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.CanvasSize = UDim2.new(0,0,0,0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y; Page.ScrollBarThickness = 2
        local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 7)

        local TabBtn = Instance.new("TextButton", TabScroll)
        TabBtn.Size = UDim2.new(1, 0, 0, 32); TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180); TabBtn.Font = XDLua.Font; Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabScroll:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(180, 180, 180) end end
            Page.Visible = true; TabBtn.TextColor3 = XDLua.AccentColor
        end)

        if not WindowAPI.CurrentPage then Page.Visible = true; WindowAPI.CurrentPage = Page; TabBtn.TextColor3 = XDLua.AccentColor end

        local PageAPI = {}

        -- สร้าง Button
        function PageAPI:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 35); Btn.BackgroundColor3 = XDLua.SecondaryColor; Btn.Text = text; Btn.TextColor3 = Color3.new(1,1,1); Btn.Font = XDLua.Font; Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- สร้าง Toggle
        function PageAPI:AddToggle(text, default, callback)
            local Toggled = default
            local TBtn = Instance.new("TextButton", Page)
            TBtn.Size = UDim2.new(1, -10, 0, 35); TBtn.BackgroundColor3 = XDLua.SecondaryColor; TBtn.Text = "  " .. text; TBtn.TextColor3 = Color3.new(0.8,0.8,0.8); TBtn.Font = XDLua.Font; TBtn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", TBtn)
            local Box = Instance.new("Frame", TBtn); Box.Size = UDim2.new(0, 20, 0, 20); Box.Position = UDim2.new(1, -30, 0.5, -10); Box.BackgroundColor3 = Toggled and XDLua.AccentColor or Color3.fromRGB(60,60,60); Instance.new("UICorner", Box)
            TBtn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Box.BackgroundColor3 = Toggled and XDLua.AccentColor or Color3.fromRGB(60,60,60)
                callback(Toggled)
            end)
        end

        -- สร้าง Slider
        function PageAPI:AddSlider(text, min, max, default, callback)
            local SFrame = Instance.new("Frame", Page); SFrame.Size = UDim2.new(1, -10, 0, 45); SFrame.BackgroundColor3 = XDLua.SecondaryColor; Instance.new("UICorner", SFrame)
            local L = Instance.new("TextLabel", SFrame); L.Text = "  "..text; L.Size = UDim2.new(1,0,0,25); L.BackgroundTransparency = 1; L.TextColor3 = Color3.new(1,1,1); L.Font = XDLua.Font; L.TextXAlignment = Enum.TextXAlignment.Left
            local V = Instance.new("TextLabel", SFrame); V.Text = tostring(default).." "; V.Size = UDim2.new(1,0,0,25); V.BackgroundTransparency = 1; V.TextColor3 = Color3.new(1,1,1); V.TextXAlignment = Enum.TextXAlignment.Right
            local B = Instance.new("TextButton", SFrame); B.Size = UDim2.new(1, -20, 0, 6); B.Position = UDim2.new(0, 10, 0, 30); B.BackgroundColor3 = Color3.fromRGB(50,50,50); B.Text = ""; Instance.new("UICorner", B)
            local F = Instance.new("Frame", B); F.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); F.BackgroundColor3 = XDLua.AccentColor; Instance.new("UICorner", F)
            local move = false
            B.MouseButton1Down:Connect(function() move = true end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if move and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local p = math.clamp((UserInputService:GetMouseLocation().X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * p)
                    F.Size = UDim2.new(p, 0, 1, 0); V.Text = tostring(val).." "; callback(val)
                end
            end)
        end

        return PageAPI
    end

    return WindowAPI
end

-- จุดสำคัญที่สุด: ต้องส่งค่าคืนเพื่อให้ loadstring รับไปใช้งานได้
return XDLua
