-- โหลด UI Library
local XDLuaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/XDLuaUI2.lua"))()

-- สร้างหน้าต่าง
local window = XDLuaUI:CreateWindow("🔹 FORSAKEN 🔹")

-- เพิ่มแท็บ
local homeTab = window:AddTab("🏠 หน้าหลัก")
local espTab = window:AddTab("👁️ บอกตำแหน่ง")
local repairTab = window:AddTab("🔧 ซ่อม")

window:AddTabDescription(homeTab, "🏠 หน้าหลัก")
window:AddTabDescription(espTab, "ฟังก์ชั่นบอกตำแหน่งต่างๆ")
window:AddTabDescription(repairTab, "ฟังก์ชั่นเกี่ยวกับการซ่อม")

-- เพิ่มคำอธิบายและเครดิต
window:AddDescription(homeTab, "ยินดีต้อนรับสู่ สคริปต์ของผม\nสคริปต์นี้คือสคริปต์แมพ FORSAKEN", "พัฒนาโดย: KRIDHUB\nเวอร์ชัน: 1.0.0 (ทดสอบ)")
-- เพิ่มปุ่มคัดลอกลิงค์ YouTube
window:Youtube(homeTab, "https://www.youtube.com/@IronFang2008")
-- เพิ่มปุ่มคัดลอกลิงค์ดิสคอร์ด
window:Discord(homeTab)

-- ประกาศตัวแปร
local player = game.Players.LocalPlayer
local isHighlightActive = false
local isSurvivorHighlightActive = false
local isKillerHighlightActive = false
local run = false
local delay = 1.7
local chanceaim = false
local chanceaimbotLoop
local connections = {}

-- ฟอนต์
local font = Enum.Font.GothamBlack

-- ฟังก์ชันคำนวณระยะห่าง (แปลงเป็นเมตร)
local function calculateDistance(position1, position2)
    return math.floor((position1 - position2).Magnitude / 3.5714285714)
end

-- ฟังก์ชันสร้างข้อความสวยๆ
local function createStyledTextLabel(parent, text, color, size, position)
    local textLabel = Instance.new("TextLabel", parent)
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = position
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = font
    textLabel.TextSize = size
    textLabel.TextWrapped = true
    return textLabel
end

-- ฟังก์ชันไฮไลท์เครื่องปั่นไฟ
local function toggleHighlightGen(state)
    isHighlightActive = state 
    
    local function applyGeneratorHighlight(generator)
        if generator.Name == "Generator" then
            local existingHighlight = generator:FindFirstChild("GeneratorHighlight")
            local progress = generator:FindFirstChild("Progress")
            
            if isHighlightActive then
                if not existingHighlight then
                    local genhighlight = Instance.new("Highlight")
                    genhighlight.Parent = generator
                    genhighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    genhighlight.Name = "GeneratorHighlight"
                    
                    -- เพิ่ม BillboardGui เพื่อแสดงข้อความและระยะห่าง
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "DistanceBillboard"
                    billboard.Size = UDim2.new(0, 150, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = generator
                    
                    -- สร้างข้อความชื่อและระยะห่าง
                    local nameLabel = createStyledTextLabel(billboard, "เครื่องปั่นไฟ", Color3.new(1, 1, 1), 16, UDim2.new(0, 0, 0, 0))
                    local distanceLabel = createStyledTextLabel(billboard, "[กำลังคำนวณ...]", Color3.new(1, 1, 1), 12, UDim2.new(0, 0, 0.5, 0))
                    
                    -- อัพเดทข้อความและสีทุกๆ 0.1 วินาที
                    spawn(function()
                        while genhighlight.Parent do
                            task.wait(0.1)
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and generator:FindFirstChild("Main") then
                                local distance = calculateDistance(player.Character.HumanoidRootPart.Position, generator.Main.Position)
                                if progress and progress.Value < 100 then
                                    genhighlight.FillColor = Color3.fromRGB(255, 255, 0)
                                    distanceLabel.Text = "[" .. distance .. " เมตร]"
                                    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                                else
                                    genhighlight.FillColor = Color3.fromRGB(0, 255, 0)
                                    distanceLabel.Text = "[ซ่อมแล้ว]"
                                    distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                end
                            end
                        end
                    end)
                end
            else
                if existingHighlight then
                    existingHighlight:Destroy()
                end
                return
            end

            if progress then
                if progress.Value == 100 then
                    local highlight = generator:FindFirstChild("GeneratorHighlight")
                    if highlight then
                        highlight:Destroy()
                    end
                    return
                end

                progress:GetPropertyChangedSignal("Value"):Connect(function()
                    if progress.Value == 100 then
                        local highlight = generator:FindFirstChild("GeneratorHighlight")
                        if highlight then
                            highlight:Destroy()
                        end
                    elseif isHighlightActive and not generator:FindFirstChild("GeneratorHighlight") then
                        local genhighlight = Instance.new("Highlight")
                        genhighlight.Parent = generator
                        genhighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        genhighlight.Name = "GeneratorHighlight"
                    end
                end)
            end
        end
    end

    -- ตรวจจับเมื่อเครื่องปั่นไฟถูกสร้างใหม่
    for _, v in pairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
        applyGeneratorHighlight(v)
    end

    game.Workspace.Map.Ingame.Map.ChildAdded:Connect(function(child)
        applyGeneratorHighlight(child)
    end)
end

-- ฟังก์ชันไฮไลท์ผู้รอดชีวิต
local function survivorHighlighter(state)
    isSurvivorHighlightActive = state

    local function applySurvivorHighlight(model)
        if model:IsA("Model") and model:FindFirstChild("Head") and model ~= player.Character then
            local existingBillboard = model.Head:FindFirstChild("billboard")
            local existingHighlight = model:FindFirstChild("HiThere")
            
            if isSurvivorHighlightActive then
                if not existingBillboard then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "billboard"
                    billboard.Size = UDim2.new(0, 150, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = model.Head
                    
                    -- สร้างข้อความชื่อและระยะห่าง
                    local nameLabel = createStyledTextLabel(billboard, model.Name, Color3.fromRGB(0, 255, 255), 16, UDim2.new(0, 0, 0, 0))
                    local distanceLabel = createStyledTextLabel(billboard, "[กำลังคำนวณ...]", Color3.fromRGB(0, 255, 255), 12, UDim2.new(0, 0, 0.5, 0))
                    
                    -- อัพเดทระยะห่างทุกๆ 0.1 วินาที
                    spawn(function()
                        while billboard.Parent do
                            task.wait(0.1)
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = calculateDistance(player.Character.HumanoidRootPart.Position, model.PrimaryPart.Position)
                                distanceLabel.Text = "[" .. distance .. " เมตร]"
                            end
                        end
                    end)
                end

                if not existingHighlight then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HiThere"
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = Color3.fromRGB(0, 255, 255)
                    highlight.Parent = model
                end
            else
                if existingBillboard then
                    existingBillboard:Destroy()
                end
                if existingHighlight then
                    existingHighlight:Destroy()
                end
            end
        end
    end

    for _, v in pairs(game.Workspace.Players.Survivors:GetChildren()) do
        applySurvivorHighlight(v)
    end

    game.Workspace.Players.Survivors.ChildAdded:Connect(function(child)
        applySurvivorHighlight(child)
    end)
end

-- ฟังก์ชันไฮไลท์ฆาตกร
local function killerHighlighter(state)
    isKillerHighlightActive = state

    local function applyKillerHighlight(model)
        if model:IsA("Model") and model:FindFirstChild("Head") and model ~= player.Character then
            local existingBillboard = model.Head:FindFirstChild("billboard")
            local existingHighlight = model:FindFirstChild("HiThere")
            
            if isKillerHighlightActive then
                if not existingBillboard then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "billboard"
                    billboard.Size = UDim2.new(0, 150, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = model.Head
                    
                    -- สร้างข้อความชื่อและระยะห่าง
                    local nameLabel = createStyledTextLabel(billboard, model.Name, Color3.fromRGB(255, 0, 0), 16, UDim2.new(0, 0, 0, 0))
                    local distanceLabel = createStyledTextLabel(billboard, "[กำลังคำนวณ...]", Color3.fromRGB(255, 0, 0), 12, UDim2.new(0, 0, 0.5, 0))
                    
                    -- อัพเดทระยะห่างทุกๆ 0.1 วินาที
                    spawn(function()
                        while billboard.Parent do
                            task.wait(0.1)
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = calculateDistance(player.Character.HumanoidRootPart.Position, model.PrimaryPart.Position)
                                distanceLabel.Text = "[" .. distance .. " เมตร]"
                            end
                        end
                    end)
                end

                if not existingHighlight then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HiThere"
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.Parent = model
                end
            else
                if existingBillboard then
                    existingBillboard:Destroy()
                end
                if existingHighlight then
                    existingHighlight:Destroy()
                end
            end
        end
    end

    for _, v in pairs(game.Workspace.Players.Killers:GetChildren()) do
        applyKillerHighlight(v)
    end

    game.Workspace.Players.Killers.ChildAdded:Connect(function(child)
        applyKillerHighlight(child)
    end)
end

-- ฟังก์ชันแก้ปริศนาเครื่องปั่นไฟทุกๆ 1.7 วินาที
local function autoSolveGen()
    while run do
        task.wait(delay)
        for _, v in pairs(game.Workspace.Map.Ingame.Map:GetChildren()) do
            if v.Name == "Generator" then
                v:WaitForChild("Remotes"):WaitForChild("RE"):FireServer()
            end
        end
    end
end

-- ฟังก์ชันไฮไลท์เครื่องมือ
local function highlightTools(state)
    local toolHighlightActive = state

    local function applyToolHighlight(tool)
        if toolHighlightActive then
            local existingHighlight = tool:FindFirstChild("ToolHighlight")
            if not existingHighlight then
                local toolhighlight = Instance.new("Highlight")
                toolhighlight.Name = "ToolHighlight"
                toolhighlight.Parent = tool
                toolhighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                -- กำหนดสีไฮไลท์ตามประเภทเครื่องมือ
                if tool.Name == "Medkit" then
                    toolhighlight.FillColor = Color3.fromRGB(0, 255, 0) -- สีเขียว (กล่องยา)
                elseif tool.Name == "BloxyCola" then
                    toolhighlight.FillColor = Color3.fromRGB(88, 57, 39) -- สีน้ำตาล (กระป๋องน้ำ)
                elseif tool.Name == "Pizza" then
                    toolhighlight.FillColor = Color3.fromRGB(255, 165, 0) -- สีส้ม (พิซซ่า)
                end

                -- เพิ่ม BillboardGui เพื่อแสดงชื่อและระยะห่าง
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ToolBillboard"
                billboard.Size = UDim2.new(0, 150, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = tool

                -- สร้างข้อความชื่อและระยะห่าง
                local nameLabel = createStyledTextLabel(billboard, tool.Name, Color3.new(1, 1, 1), 16, UDim2.new(0, 0, 0, 0))
                local distanceLabel = createStyledTextLabel(billboard, "[กำลังคำนวณ...]", Color3.new(1, 1, 1), 12, UDim2.new(0, 0, 0.5, 0))

                -- อัพเดทระยะห่างทุกๆ 0.1 วินาที
                spawn(function()
                    while toolhighlight.Parent do
                        task.wait(0.1)
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local toolPosition = tool:GetPivot().Position -- ใช้ตำแหน่งของไอเทม
                            local distance = calculateDistance(player.Character.HumanoidRootPart.Position, toolPosition)
                            distanceLabel.Text = "[" .. distance .. " เมตร]"
                        end
                    end
                end)
            end
        else
            local existingHighlight = tool:FindFirstChild("ToolHighlight")
            if existingHighlight then
                existingHighlight:Destroy()
            end
        end
    end

    for _, v in pairs(game.Workspace.Map.Ingame:GetChildren()) do
        if v:IsA("Tool") then
            applyToolHighlight(v)
        end
    end

    game.Workspace.Map.Ingame.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            applyToolHighlight(child)
        end
    end)
end

-- เชื่อมต่อกับเหตุการณ์เมื่อเริ่มรอบใหม่
local function onRoundStart()
    toggleHighlightGen(isHighlightActive)
    survivorHighlighter(isSurvivorHighlightActive)
    killerHighlighter(isKillerHighlightActive)
    run = true
    autoSolveGen()
end

-- ตรวจจับเมื่อเริ่มรอบใหม่
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(onRoundStart)

-- แท็บ ESP
window:AddToggle(espTab, "ตำแหน่งฆาตกร", false, function(state)
    killerHighlighter(state)
end)

window:AddToggle(espTab, "ตำแหน่งผู้รอดชีวิต", false, function(state)
    survivorHighlighter(state)
end)

window:AddToggle(espTab, "ตำแหน่งไอเทมในแมพ", false, function(state)
    highlightTools(state)
end)

window:AddToggle(espTab, "ตำแหน่งเครื่องปั่นไฟ\n(ปิดแล้วเปิดอีกเมื่อเริ่มรอบใหม่)", false, function(state)
    toggleHighlightGen(state)
end)

-- แท็บซ่อม
window:AddToggle(repairTab, "ซ่อมเครื่องปั่นไฟออโต้\n(ปิดแล้วเปิดอีกเมื่อเริ่มรอบใหม่)", false, function(state)
    run = state
    autoSolveGen(state)
end)

-- รันฟังก์ชันทั้งหมดทันทีเมื่อสคริปต์เริ่มทำงาน
onRoundStart()
