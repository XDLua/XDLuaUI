local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local XDLua = {
    AccentColor = Color3.fromRGB(0, 162, 255), -- ปรับสีตรงนี้ที่เดียว เปลี่ยนทั้ง UI
    Font = Enum.Font.GothamMedium,
    Open = true
}

-- [ Helper Functions ]
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(object, TweenInfo.new(0.15), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- [ Main Library ]
function XDLua:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {Name = "XDLua_"..math.random(100), Parent = CoreGui})
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame", Parent = ScreenGui, Size = UDim2.new(0, 480, 0, 350),
        Position = UDim2.new(0.5, -240, 0.5, -175), BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0, ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainFrame})
    Create("UIStroke", {Color = Color3.fromRGB(40, 40, 40), Thickness = 1.5, Parent = MainFrame})

    local Topbar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = MainFrame
    })
    MakeDraggable(Topbar, MainFrame)

    Create("TextLabel", {
        Parent = Topbar, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = self.Font, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left
    })

    local Container = Create("ScrollingFrame", {
        Parent = MainFrame, Size = UDim2.new(1, -10, 1, -50), Position = UDim2.new(0, 5, 0, 45),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.AccentColor, AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Padding = UDim.new(0, 7), HorizontalAlignment = "Center", SortOrder = "LayoutOrder", Parent = Container})
    Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 10), Parent = Container})

    local Window = {}

    -- 1. Section (หัวข้อแยกส่วน)
    function Window:AddSection(text)
        local Section = Create("TextLabel", {
            Parent = Container, Size = UDim2.new(1, -20, 0, 20), BackgroundTransparency = 1,
            Text = text:upper(), TextColor3 = XDLua.AccentColor, Font = Enum.Font.GothamBold,
            TextSize = 12, TextXAlignment = "Left"
        })
        Create("UIPadding", {PaddingLeft = UDim.new(0, 5), Parent = Section})
    end

    -- 2. Button
    function Window:AddButton(text, callback)
        local Btn = Create("TextButton", {
            Parent = Container, Size = UDim2.new(1, -20, 0, 38), BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Text = "", AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
        local Stroke = Create("UIStroke", {Color = Color3.fromRGB(45, 45, 45), Parent = Btn})
        
        local Label = Create("TextLabel", {
            Parent = Btn, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = text, TextColor3 = Color3.fromRGB(200, 200, 200), Font = XDLua.Font, TextSize = 14
        })

        Btn.MouseEnter:Connect(function() 
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = XDLua.AccentColor}):Play()
        end)
        Btn.MouseLeave:Connect(function() 
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45)}):Play()
        end)
        Btn.MouseButton1Click:Connect(callback)
    end

    -- 3. Toggle
    function Window:AddToggle(text, default, callback)
        local state = default or false
        local ToggleBtn = Create("TextButton", {
            Parent = Container, Size = UDim2.new(1, -20, 0, 38), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Text = ""
        })
        Create("UICorner", {Parent = ToggleBtn})
        
        Create("TextLabel", {
            Parent = ToggleBtn, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -50, 1, 0),
            BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = XDLua.Font, TextSize = 14, TextXAlignment = "Left"
        })

        local Box = Create("Frame", {
            Parent = ToggleBtn, Position = UDim2.new(1, -35, 0.5, -10), Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = state and XDLua.AccentColor or Color3.fromRGB(45, 45, 45)
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Box})

        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and XDLua.AccentColor or Color3.fromRGB(45, 45, 45)}):Play()
            callback(state)
        end)
    end

    -- 4. Slider
    function Window:AddSlider(text, min, max, default, callback)
        local SliderFrame = Create("Frame", {
            Parent = Container, Size = UDim2.new(1, -20, 0, 50), BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        Create("UICorner", {Parent = SliderFrame})
        
        local Label = Create("TextLabel", {
            Parent = SliderFrame, Position = UDim2.new(0, 15, 0, 8), Text = text, 
            TextColor3 = Color3.fromRGB(200, 200, 200), Font = XDLua.Font, TextSize = 13, BackgroundTransparency = 1
        })
        
        local ValueLabel = Create("TextLabel", {
            Parent = SliderFrame, Position = UDim2.new(1, -45, 0, 8), Text = tostring(default),
            TextColor3 = XDLua.AccentColor, Font = XDLua.Font, TextSize = 13, BackgroundTransparency = 1
        })

        local SlideBar = Create("Frame", {
            Parent = SliderFrame, Position = UDim2.new(0, 15, 0, 32), Size = UDim2.new(1, -30, 0, 6),
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        })
        Create("UICorner", {Parent = SlideBar})

        local Fill = Create("Frame", {
            Parent = SlideBar, Size = UDim2.new((default-min)/(max-min), 0, 1, 0),
            BackgroundColor3 = XDLua.AccentColor
        })
        Create("UICorner", {Parent = Fill})

        local function Update(input)
            local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            ValueLabel.Text = tostring(val)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            callback(val)
        end

        SlideBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
                end)
                Update(input)
            end
        end)
    end

    -- 5. Dropdown (พื้นฐาน)
    function Window:AddDropdown(text, list, callback)
        local DropFrame = Create("TextButton", {
            Parent = Container, Size = UDim2.new(1, -20, 0, 38), BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Text = "", ClipsDescendants = true
        })
        Create("UICorner", {Parent = DropFrame})
        
        local Title = Create("TextLabel", {
            Parent = DropFrame, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -30, 0, 38),
            BackgroundTransparency = 1, Text = text .. " : ...", TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = XDLua.Font, TextSize = 14, TextXAlignment = "Left"
        })

        local expanded = false
        DropFrame.MouseButton1Click:Connect(function()
            expanded = not expanded
            TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, expanded and (40 + (#list * 30)) or 38)}):Play()
        end)

        for i, v in ipairs(list) do
            local Item = Create("TextButton", {
                Parent = DropFrame, Position = UDim2.new(0, 10, 0, 40 + (i-1)*30), Size = UDim2.new(1, -20, 0, 25),
                BackgroundTransparency = 1, Text = v, TextColor3 = Color3.fromRGB(150, 150, 150),
                Font = XDLua.Font, TextSize = 13
            })
            Item.MouseButton1Click:Connect(function()
                Title.Text = text .. " : " .. v
                expanded = false
                TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 38)}):Play()
                callback(v)
            end)
        end
    end

    -- 6. TextBox (ช่องกรอกข้อมูล)
    function Window:AddTextbox(text, placeholder, callback)
        local TBoxFrame = Create("Frame", {
            Parent = Container, Size = UDim2.new(1, -20, 0, 55), BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        Create("UICorner", {Parent = TBoxFrame})
        
        Create("TextLabel", {
            Parent = TBoxFrame, Position = UDim2.new(0, 15, 0, 8), Text = text, 
            TextColor3 = Color3.fromRGB(200, 200, 200), Font = XDLua.Font, TextSize = 13, BackgroundTransparency = 1
        })

        local Input = Create("TextBox", {
            Parent = TBoxFrame, Position = UDim2.new(0, 15, 0, 28), Size = UDim2.new(1, -30, 0, 20),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35), Text = "", PlaceholderText = placeholder,
            TextColor3 = Color3.fromRGB(255, 255, 255), Font = XDLua.Font, TextSize = 12
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Input})

        Input.FocusLost:Connect(function(enter)
            if enter then callback(Input.Text) end
        end)
    end

    return Window
end

return XDLua
