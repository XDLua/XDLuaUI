local Lib = XDLuaUI:CreateWindow("XDLua Pro", "🔥", "⚡", 5)
local MainTab = Lib:AddTab("Main", "🏠")
local SettingsTab = Lib:AddTab("Settings", "⚙️")

-- 1. ทดสอบระบบแจ้งเตือน
Lib:Notify("XDLua", "ยินดีต้อนรับเข้าสู่สคริปต์!", 5)

-- 2. ระบบเปลี่ยน Keybind Toggle UI
Lib:AddKeybind(SettingsTab, "Toggle UI Key", Enum.KeyCode.RightControl, function(newKey)
    CurrentKeybind = newKey
    Lib:Notify("Settings", "เปลี่ยนปุ่มเปิด/ปิดเป็น: " .. newKey.Name, 3)
end)

-- 3. ระบบเปลี่ยนสีธีม (Accent Color)
Lib:AddColorPicker(SettingsTab, "Change Theme Color", Color3.fromRGB(255, 50, 255), function(newColor)
    Lib:SetAccent(newColor)
end)

-- 4. ปุ่มปิด/ลบ UI
Lib:AddButton(SettingsTab, "Destroy UI (Close Forever)", function()
    game:GetService("CoreGui"):FindFirstChild("XDLuaGUI"):Destroy()
end)
