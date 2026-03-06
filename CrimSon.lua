-- [[ XDLua UI Library: Professional Loadstring Edition ]] --

local XDLua = {} -- สร้างตารางหลัก
XDLua.__index = XDLua

-- บริการต่างๆ ของ Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- ตั้งค่าเริ่มต้น (Themes)
XDLua.AccentColor = Color3.fromRGB(0, 162, 255)
XDLua.Font = Enum.Font.GothamMedium
XDLua.SecondaryColor = Color3.fromRGB(30, 30, 30)
XDLua.MainColor = Color3.fromRGB(15, 15, 15)

-- [ Internal Helper: Smooth Drag ]
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

-- [ Function: Create Window ]
function XDLua:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "XDLua_" .. math.random(100, 999)
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = self.MainColor
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

    -- Sidebar & Topbar (ส่วนตกแต่ง)
    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 40); Topbar.BackgroundTransparency = 1
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel", Topbar)
    TitleLabel.Text = "  " .. (title or "XDLua UI")
    TitleLabel.Size = UDim2.new(1, 0, 1, 0); TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.Font = self.Font; TitleLabel.TextSize = 18; TitleLabel.BackgroundTransparency = 1; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Pages = Instance.new("Frame", MainFrame)
    Pages.Size = UDim2.new(1, -160, 1, -50); Pages.Position = UDim2.new(0, 155, 0, 45); Pages.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Size = UDim2.new(0, 140, 1, -50); TabContainer.Position = UDim2.new(0, 10, 0, 45); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local WindowAPI = { CurrentPage = nil }

    -- [ Function: Create Tab ]
    function WindowAPI:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.CanvasSize = UDim2.new(0,0,0,0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35); TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TabBtn.Font = XDLua.Font; Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            Page.Visible = true
        end)

        if not self.CurrentPage then Page.Visible = true; self.CurrentPage = Page end

        local PageAPI = {}
        function PageAPI:AddButton(text, callback)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = XDLua.SecondaryColor; b.Text = text; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(callback)
        end
        
        return PageAPI
    end

    return WindowAPI
end

-- *** สำคัญมาก: ต้อง return ตารางหลักเพื่อให้ loadstring() รับค่าไปได้ ***
return XDLua
