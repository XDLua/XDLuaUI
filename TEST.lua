-- ═════════════════════════════════════════════
-- XDLuaUI V2.5 | Clean Version - No Syntax Error
-- ใช้งานได้ทุก Executor: Krnl, Fluxus, Delta, Codex, Arceus X, Hydrogen
-- ═════════════════════════════════════════════

local XDLuaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Notification ปลอดภัย
local function Notify(title, text, duration)
	spawn(function()
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = title or "XDLuaUI",
				Text = text or "Success!",
				Duration = duration or 4
			})
		end)
	end)
end

-- Main Function
function XDLuaUI:CreateWindow(config)
	config = config or {}
	local Title = config.Title or "XDLua Hub"
	local EmojiFront = config.EmojiFront or ""
	local EmojiBack = config.EmojiBack or ""
	local Keybind = config.Keybind or Enum.KeyCode.RightShift
	local Size = config.Size or UDim2.new(0, 550, 0, 380)

	-- ลบ GUI เก่า
	if CoreGui:FindFirstChild("XDLuaGUI_V25") then
		CoreGui:FindFirstChild("XDLuaGUI_V25"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "XDLuaGUI_V25"
	ScreenGui.Parent = CoreGui
	ScreenGui.ResetOnSpawn = false

	-- Loading Screen สั้น ๆ สวย ๆ
	local Loading = Instance.new("Frame", ScreenGui)
	Loading.Size = UDim2.new(0, 300, 0, 160)
	Loading.Position = UDim2.new(0.5, -150, .5, -80)
	Loading.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	Loading.BorderSizePixel = 0
	local lc = Instance.new("UICorner", Loading); lc.CornerRadius = UDim.new(0, 16)
	local ls = Instance.new("UIStroke", Loading); ls.Thickness = 3; ls.Color = Color3.fromRGB(255, 50, 255)

	local LoadText = Instance.new("TextLabel", Loading)
	LoadText.Text = "BY C • J"
	LoadText.Size = UDim2.new(1,0,0,50)
	LoadText.Position = UDim2.new(0,0,0,20)
	LoadText.BackgroundTransparency = 1
	LoadText.TextColor3 = Color3.fromRGB(255,50,255)
	LoadText.Font = Enum.Font.GothamBlack
	LoadText.TextSize = 30

	local BarBack = Instance.new("Frame", Loading)
	BarBack.Size = UDim2.new(.8,0,0,10)
	BarBack.Position = UDim2.new(.1,0,0,100)
	BarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
	local bc = Instance.new("UICorner", BarBack); bc.CornerRadius = UDim.new(1,0)

	local BarFill = Instance.new("Frame", BarBack)
	BarFill.Size = UDim2.new(0,0,1,0)
	BarFill.BackgroundColor3 = Color3.fromRGB(255,50,255)
	local fc = Instance.new("UICorner", BarFill); fc.CornerRadius = UDim.new(1,0)

	TweenService:Create(BarFill, TweenInfo.new(2.2), {Size = UDim2.new(1,0,1,0)}):Play()
	wait(2.4)
	Loading:Destroy()
	Notify("XDLuaUI V2.5", "โหลดสำเร็จแล้วครับ!", 4)

	-- Main Frame
	local Main = Instance.new("Frame", ScreenGui)
	Main.Size = Size
	Main.Position = UDim2.new(.5, -Size.X.Offset/2, .5, -Size.Y.Offset/2)
	Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
	Main.BackgroundTransparency = 0.05
	Main.Active = true
	Main.Draggable = true
	local mc = Instance.new("UICorner", Main); mc.CornerRadius = UDim.new(0,14)

	-- Rainbow Glow
	local Glow = Instance.new("UIStroke", Main)
	Glow.Thickness = 3.5
	Glow.Transparency = 0.3
	spawn(function()
		while Main and Main.Parent do
			Glow.Color = Color3.fromHSV(tick() % 6 / 6, 1, 1)
			wait(0.05)
		end
	end)

	-- Title
	local TitleLabel = Instance.new("TextLabel", Main)
	TitleLabel.Size = UDim2.new(1,0,0,45)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = EmojiFront .. "  " .. Title .. "  " .. EmojiBack
	TitleLabel.TextColor3 = Color3.fromRGB(255,50,255)
	TitleLabel.Font = Enum.Font.GothamBlack
	TitleLabel.TextSize = 22

	-- ปุ่มปิด + ย่อ
	local Close = Instance.new("TextButton", Main)
	Close.Size = UDim2.new(0,36,0,36)
	Close.Position = UDim2.new(1,-44,0,6)
	Close.BackgroundColor3 = Color3.fromRGB(220,20,60)
	Close.Text = "X"
	Close.TextColor3 = Color3.new(1,1,1)
	Close.Font = Enum.Font.GothamBold
	local cc = Instance.new("UICorner", Close); cc.CornerRadius = UDim.new(0,10)

	local Minimize = Instance.new("TextButton", Main)
	Minimize.Size = UDim2.new(0,36,0,36)
	Minimize.Position = UDim2.new(1,-86,0,6)
	Minimize.BackgroundColor3 = Color3.fromRGB(255,165,0)
	Minimize.Text = "−"
	Minimize.TextColor3 = Color3.new(1,1,1)
	local mc2 = Instance.new("UICorner", Minimize); mc2.CornerRadius = UDim.new(0,10)

	-- Logo Button (เปิด/ปิด UI)
	local Logo = Instance.new("TextButton", ScreenGui)
	Logo.Size = UDim2.new(0,60,0,60)
	Logo.Position = UDim2.new(0,15,0.5,-30)
	Logo.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Logo.BackgroundTransparency = 0.1
	Logo.Text = "XD"
	Logo.TextColor3 = Color3.fromRGB(255,50,255)
	Logo.Font = Enum.Font.GothamBlack
	Logo.TextSize = 28
	Logo.Draggable = true
	local lc = Instance.new("UICorner", Logo); lc.CornerRadius = UDim.new(1,0)
	spawn(function()
		while wait(0.1) do
			if Logo and Logo.Parent then
				Logo.Rotation = Logo.Rotation + 4
			end
		end
	end)

	-- Tab System
	local TabContainer = Instance.new("Frame", Main)
	TabContainer.Size = UDim2.new(0,140,1,-55)
	TabContainer.Position = UDim2.new(0,10,0,50)
	TabContainer.BackgroundColor3 = Color3.fromRGB(22,22,22)
	local tc = Instance.new("UICorner", TabContainer); tc.CornerRadius = UDim.new(0,10)

	local TabScroll = Instance.new("ScrollingFrame", TabContainer)
	TabScroll.Size = UDim2.new(1,0,1,0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 3
	TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	local TabLayout = Instance.new("UIListLayout", TabScroll)
	TabLayout.Padding = UDim.new(0,8)
	TabLayout.PaddingTop = UDim.new(0,10)

	local Content = Instance.new("ScrollingFrame", Main)
	Content.Size = UDim2.new(1,-160,1,-65)
	Content.Position = UDim2.new(0,150,0,55)
	Content.BackgroundTransparency = 1
	Content.ScrollBarThickness = 4
	Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local tabs = {}
	local selectedTab = nil

	-- AddTab
	function XDLuaUI:AddTab(Name, Emoji)
		local TabBtn = Instance.new("TextButton", TabScroll)
		TabBtn.Size = UDim2.new(0.9,0,0,42)
		TabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		TabBtn.Text = (Emoji or "Tab") .. "  " .. Name
		TabBtn.TextColor3 = Color3.new(1,1,1)
		TabBtn.Font = Enum.Font.GothamBold
		TabBtn.TextSize = 15
		TabBtn.AutoButtonColor = false
		local bc = Instance.new("UICorner", TabBtn); bc.CornerRadius = UDim.new(0,8)
		local stroke = Instance.new("UIStroke", TabBtn)
		stroke.Color = Color3.fromRGB(255,50,255)
		stroke.Transparency = 1

		local Page = Instance.new("Frame", Content)
		Page.Size = UDim2.new(1,0,0,0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.AutomaticSize = Enum.AutomaticSize.Y
		local layout = Instance.new("UIListLayout", Page)
		layout.Padding = UDim.new(0,10)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		Instance.new("UIPadding", Page).PaddingTop = UDim.new(0,10)

		TabBtn.MouseButton1Click:Connect(function()
			if selectedTab then
				TweenService:Create(selectedTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
				selectedTab.Stroke.Transparency = 1
			end
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100,0,100)}):Play()
			stroke.Transparency = 0.3
			for _, p in pairs(Content:GetChildren()) do
				if p:IsA("Frame") then p.Visible = false end
			end
			Page.Visible = true
			selectedTab = {Button = TabBtn, Stroke = stroke}
		end)

		if #tabs == 0 then
			TabBtn.BackgroundColor3 = Color3.fromRGB(100,0,100)
			stroke.Transparency = 0.3
			Page.Visible = true
			selectedTab = {Button = TabBtn, Stroke = stroke}
		end

		table.insert(tabs, Page)
		return Page
	end

	-- AddButton
	function XDLuaUI:AddButton(Parent, Text, Callback)
		local Btn = Instance.new("TextButton", Parent)
		Btn.Size = UDim2.new(0.9,0,0,38)
		Btn.BackgroundColor3 = Color3.fromRGB(80,0,80)
		Btn.Text = Text
		Btn.TextColor3 = Color3.new(1,1,1)
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 15
		local c = Instance.new("UICorner", Btn); c.CornerRadius = UDim.new(0,10)

		Btn.MouseButton1Click:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0.85,0,0,36)}):Play()
			wait(0.1)
			TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0.9,0,0,38)}):Play()
			Callback()
		end)
	end

	-- AddToggle
	function XDLuaUI:AddToggle(Parent, Text, Default, Callback)
		local enabled = Default or false

		local Toggle = Instance.new("TextButton", Parent)
		Toggle.Size = UDim2.new(0.9,0,0,40)
		Toggle.BackgroundColor3 = Color3.fromRGB(70,0,70)
		Toggle.Text = ""
		local tc = Instance.new("UICorner", Toggle); tc.CornerRadius = UDim.new(0,10)

		local Label = Instance.new("TextLabel", Toggle)
		Label.Text = Text
		Label.Size = UDim2.new(0.7,0,1,0)
		Label.Position = UDim2.new(0,10,0,0)
		Label.BackgroundTransparency = 1
		Label.TextColor3 = Color3.new(1,1,1)
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Font = Enum.Font.GothamBold
		Label.TextSize = 15

		local Switch = Instance.new("Frame", Toggle)
		Switch.Size = UDim2.new(0,50,0,24)
		Switch.Position = UDim2.new(1,-60,0.5,-12)
		Switch.BackgroundColor3 = enabled and Color3.fromRGB(255,50,255) or Color3.fromRGB(60,60,60)
		local sc = Instance.new("UICorner", Switch); sc.CornerRadius = UDim.new(1,0)

		local Handle = Instance.new("Frame", Switch)
		Handle.Size = UDim2.new(0,20,0,20)
		Handle.Position = enabled and UDim2.new(0,26,0.5,-10) or UDim2.new(0,4,0.5,-10)
		Handle.BackgroundColor3 = Color3.new(1,1,1)
		local hc = Instance.new("UICorner", Handle); hc.CornerRadius = UDim.new(1,0)

		Toggle.MouseButton1Click:Connect(function()
			enabled = not enabled
			TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = enabled and Color3.fromRGB(255,50,255) or Color3.fromRGB(60,60,60)}):Play()
			TweenService:Create(Handle, TweenInfo.new(0.25), {Position = enabled and UDim2.new(0,26,0.5,-10) or UDim2.new(0,4,0.5,-10)}):Play()
			Callback(enabled)
		end)
	end

	-- เปิด/ปิด UI + ปุ่มปิด
	Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
	UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Keybind then Main.Visible = not Main.Visible end end)
	Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
	Minimize.MouseButton1Click:Connect(function() Main.Visible = false end)

	return XDLuaUI
end

return XDLuaUI
