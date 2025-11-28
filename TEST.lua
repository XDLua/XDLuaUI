-- ═════════════════════════════════════════════
-- XDLuaUI V2.0 - Ultimate Neon Purple UI Library
-- สุดยอด UI Roblox ปี 2025 | BY C • J + Grok
-- ══════════════════════════════════════════════

local XDLuaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ลบ GUI เก่าออกก่อน
if game.CoreGui:FindFirstChild("XDLuaGUI") then
    game.CoreGui.XDLuaGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XDLuaGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = game.CoreGui

-- Notification System สวยสุด ๆ
local function Notify(title, text, duration, icon)
    spawn(function()
        local noti = Instance.new("Frame")
        noti.Size = UDim2.new(0, 320, 0, 90)
        noti.Position = UDim2.new(1, 20, 1, -100)
        noti.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        noti.BackgroundTransparency = 0.05
        noti.BorderSizePixel = 0
        noti.Parent = screenGui

        local corner = Instance.new("UICorner", noti)
        corner.CornerRadius = UDim.new(0, 14)

        local stroke = Instance.new("UIStroke", noti)
        stroke.Thickness = 2.5
        stroke.Color = Color3.fromRGB(255, 50, 255)
        stroke.Transparency = 0.3

        local grad = Instance.new("UIGradient", stroke)
        grad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
        }
        grad.Rotation = 45
        TweenService:Create(grad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 405}):Play()

        if icon then
            local ico = Instance.new("TextLabel", noti)
            ico.Size = UDim2.new(0, 40, 0, 40)
            ico.Position = UDim2.new(0, 15, 0.5, -20)
            ico.BackgroundTransparency = 1
            ico.Text = icon
            ico.TextSize = 30
            ico.Font = Enum.Font.GothamBlack
            ico.TextColor3 = Color3.fromRGB(255, 50, 255)
        end

        local t = Instance.new("TextLabel", noti)
        t.Size = UDim2.new(1, -20, 0, 30)
        t.Position = UDim2.new(0, icon and 65 or 20, 0, 10)
        t.BackgroundTransparency = 1
        t.Text = title or "XDLua Hub"
        t.TextColor3 = Color3.fromRGB(255, 50, 255)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 18
        t.TextXAlignment = Enum.TextXAlignment.Left

        local d = Instance.new("TextLabel", noti)
        d.Size = UDim2.new(1, -30, 0, 30)
        d.Position = UDim2.new(0, icon and 65 or 20, 0, 40)
        d.BackgroundTransparency = 1
        d.Text = text or "Success!"
        d.TextColor3 = Color3.new(1,1,1)
        d.Font = Enum.Font.Gotham
        d.TextSize = 14
        d.TextWrapped = true
        d.TextXAlignment = Enum.TextXAlignment.Left

        noti.Position = UDim2.new(1, 340, 1, -100)
        noti:TweenPosition(UDim2.new(1, -340, 1, -100), "Out", "Quad", 0.5, true)
        wait(duration or 4)
        noti:TweenPosition(UDim2.new(1, 20, 1, -100), "In", "Quad", 0.4, true)
        wait(0.4)
        noti:Destroy()
    end)
end

-- Loading Screen + Welcome Screen + Fade Animation
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 360, 0, 200)
loadingFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
loadingFrame.BackgroundTransparency = 0.05
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local lcorner = Instance.new("UICorner", loadingFrame)
lcorner.CornerRadius = UDim.new(0, 16)

local lstroke = Instance.new("UIStroke", loadingFrame)
lstroke.Thickness = 3
lstroke.Color = Color3.fromRGB(255, 50, 255)
local lgrad = Instance.new("UIGradient", lstroke)
lgrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,255))}
lgrad.Rotation = 45
TweenService:Create(lgrad, TweenInfo.new(3, Enum.EasingStyle.Linear, -1), {Rotation = 405}):Play()

local titleLoad = Instance.new("TextLabel", loadingFrame)
titleLoad.Size = UDim2.new(1,0,0,50)
titleLoad.Position = UDim2.new(0,0,0,20)
titleLoad.Text = "BY C • J"
titleLoad.TextColor3 = Color3.fromRGB(255, 50, 255)
titleLoad.BackgroundTransparency = 1
titleLoad.Font = Enum.Font.GothamBlack
titleLoad.TextSize = 32

local barBack = Instance.new("Frame", loadingFrame)
barBack.Size = UDim2.new(0.8,0,0,12)
barBack.Position = UDim2.new(0.1,0,0,100)
barBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBack.BorderSizePixel = 0
Instance.new("UICorner", barBack).CornerRadius = UDim.new(1,0)

local barFill = Instance.new("Frame", barBack)
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(255,50,255)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1,0,0,30)
loadingText.Position = UDim2.new(0,0,0,130)
loadingText.Text = "กำลังโหลด..."
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 18

-- Animation Loading Bar
TweenService:Create(barFill, TweenInfo.new(2, Enum.EasingStyle.Sine), {Size = UDim2.new(0.8,0,1,0)}):Play()
wait(2.2)
TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {Size = UDim2.new(1,0,1,0)}):Play()

-- Welcome Screen
local welcomeFrame = Instance.new("Frame", screenGui)
welcomeFrame.Size = UDim2.new(0,340,0,420)
welcomeFrame.Position = UDim2.new(0.5,-170,0.5,-210)
welcomeFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
welcomeFrame.BackgroundTransparency = 1
welcomeFrame.BorderSizePixel = 0

local wcorner = Instance.new("UICorner", welcomeFrame)
wcorner.CornerRadius = UDim.new(0,20)

local avatar = Instance.new("ImageLabel", welcomeFrame)
avatar.Size = UDim2.new(0,120,0,120)
avatar.Position = UDim2.new(0.5,-60,0,40)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=420&h=420"
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

local nameLabel = Instance.new("TextLabel", welcomeFrame)
nameLabel.Size = UDim2.new(1,0,0,50)
nameLabel.Position = UDim2.new(0,0,0,180)
nameLabel.Text = "Welcome, "..player.Name
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBlack
nameLabel.TextSize = 28

local welcomeText = Instance.new("TextLabel", welcomeFrame)
welcomeText.Size = UDim2.new(1,0,0,50)
welcomeText.Position = UDim2.new(0,0,0,240)
welcomeText.Text = "XDLua Hub V2 พร้อมแล้ว"
welcomeText.TextColor3 = Color3.fromRGB(255,50,255)
welcomeText.BackgroundTransparency = 1
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextSize = 20

wait(1)
TweenService:Create(welcomeFrame, TweenInfo.new(1.5), {BackgroundTransparency = 0}):Play()
wait(3)
TweenService:Create(welcomeFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
wait(1)
loadingFrame:Destroy()
welcomeFrame:Destroy()

-- ปุ่มเปิด/ปิด UI แบบวงกลม (ลากได้ + Pulse)
local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0,70,0)
openButton.Position = UDim2.new(0,20,0.5,-35)
openButton.Text = "XD"
openButton.TextColor3 = Color3.fromRGB(255,50,255)
openButton.BackgroundColor3 = Color3.fromRGB(10,10,10)
openButton.Font = Enum.Font.GothamBlack
openButton.TextSize = 36
openButton.AutoButtonColor = false
openButton.Draggable = true
openButton.Visible = true
Instance.new("UICorner", openButton).CornerRadius = UDim.new(1,0)

local openStroke = Instance.new("UIStroke", openButton)
openStroke.Thickness = 4
openStroke.Color = Color3.fromRGB(255,50,255)

-- Pulse Animation
spawn(function()
    while openButton and openButton.Parent do
        TweenService:Create(openButton, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Size = UDim2.new(0,80,0,80)
        }):Play()
        wait(2)
    end
end)

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0,500,0,350)
mainFrame.Position = UDim2.new(0.5,-250,0.5,-175)
mainFrame.BackgroundColor3 = Color3.fromRGB(12,12,12)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
local mcorner = Instance.new("UICorner", mainFrame)
mcorner.CornerRadius = UDim.new(0,16)

local mstroke = Instance.new("UIStroke", mainFrame)
mstroke.Thickness = 3
mstroke.Color = Color3.fromRGB(255,50,255)
local mgrad = Instance.new("UIGradient", mstroke)
mgrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
mgrad.Rotation = 90
TweenService:Create(mgrad, TweenInfo.new(5, Enum.EasingStyle.Linear, -1), {Rotation = 450}):Play()

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1,0,0,50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XDLua Hub"
titleLabel.TextColor3 = Color3.fromRGB(255,50,255)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 24

-- ปุ่มปิด, ย่อ, ตั้งค่า
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-50,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(220,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)

local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0,40,0,40)
minimizeBtn.Position = UDim2.new(1,-100,0,5)
minimizeBtn.Text = "–"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,0)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,10)

-- Tab System
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0,140,1,-60)
tabFrame.Position = UDim2.new(0,10,0,60)
tabFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
tabFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0,12)

local tabScroll = Instance.new("ScrollingFrame", tabFrame)
tabScroll.Size = UDim2.new(1,0,1,0)
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollBarThickness = 0
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local tabLayout = Instance.new("UIListLayout", tabScroll)
tabLayout.Padding = UDim.new(0,8)
tabLayout.PaddingTop = UDim.new(0,10)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,-160,1,-70)
contentFrame.Position = UDim2.new(0,150,0,60)
contentFrame.BackgroundTransparency = 1

local tabs = {}

function XDLuaUI:AddTab(name, emoji)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.9,0,0,45)
    tabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tabBtn.Text = (emoji or "Tab") .. "  " .. name
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 16
    tabBtn.Parent = tabScroll
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Transparency = 1

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = contentFrame
    local list = Instance.new("UIListLayout", content)
    list.Padding = UDim.new(0,12)
    list.PaddingTop = UDim.new(0,15)

    tabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabs) do
            v.Content.Visible = false
            TweenService:Create(v.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
            v.Button.UIStroke.Transparency = 1
        end
        content.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100,0,100)}):Play()
        stroke.Transparency = 0
    end)

    if #tabs == 0 then
        content.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
        stroke.Transparency = 0
    end

    tabs[#tabs+1] = {Button = tabBtn, Content = content}
    return content
end

-- Components
function XDLuaUI:AddButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(80,0,80)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = tab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.85,0,0,38)}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.9,0,0,40)}):Play()
        pcall(callback)
    end)
end

function XDLuaUI:AddToggle(tab, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9,0,0,40)
    frame.BackgroundColor3 = Color3.fromRGB(60,0,60)
    frame.Parent = tab
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7,0,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0,50,0,25)
    toggle.Position = UDim2.new(1,-60,0.5,-12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
    toggle.Parent = frame
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0,21,0,21)
    circle.Position = default and UDim2.new(0,27,0.5,-10.5) or UDim2.new(0,4,0.5,-10.5)
    circle.BackgroundColor3 = default and Color3.fromRGB(255,50,255) or Color3.new(1,1,1)
    circle.Parent = toggle
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

    local enabled = default or false
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = enabled and UDim2.new(0,27,0.5,-10.5) or UDim2.new(0,4,0.5,-10.5),
                BackgroundColor3 = enabled and Color3.fromRGB(255,50,255) or Color3.new(1,1,1)
            }):Play()
            TweenService:Create(toggle, TweenInfo.new(0.3), {
                BackgroundColor3 = enabled and Color3.fromRGB(100,0,100) or Color3.fromRGB(80,80,80)
            }):Play()
            pcall(callback, enabled)
        end)
    end)
end

-- เปิด/ปิด UI
openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Size = mainFrame.Size == UDim2.new(0,500,0,350) and UDim2.new(0,500,0,60) or UDim2.new(0,500,0,350)
end)

Notify("XDLua Hub V2", "โหลดสำเร็จแล้ว! กด Insert เพื่อเปิด/ปิด", 5, "Checkmark")

return XDLuaUI
