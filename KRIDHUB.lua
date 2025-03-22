-- โหลด UI Library
local XDLuaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/XDLuaUI.lua"))()

-- สร้างหน้าต่าง
local window = XDLuaUI:CreateWindow("🔹 KRIDHUB 🔹")

-- home
local homeTab = window:AddTab("🏠 หน้าหลัก")
window:AddTabDescription(homeTab, "🏠 หน้าหลัก")
window:AddDescription(homeTab, "ยินดีต้อนรับสู่ KRIDHUB\nสคริปต์นี้คือสคริปต์รวมแมพ", "พัฒนาโดย: KRIDHUB")
window:Youtube(homeTab, "https://www.youtube.com/@IronFang2008")
window:Discord(homeTab)
window:AddExecutorTab()
-- FORSAKEN
window:AddScriptTab("FORSAKEN", "ยินดีต้อนรับสู่ KRIDHUB\nสคริปต์นี้คือสคริปต์แมพ FORSAKEN", "พัฒนาโดย: KRIDHUB\nเวอร์ชันสคริปต์: 7.1.5 ", "https://raw.githubusercontent.com/XDLua/Scripts/refs/heads/main/Forsaken.lua")
local Tab1 = window:AddTab("🚫")
window:AddTabDescription(homeTab, "ไม่พบสคริปต์")
window:AddDescription(Tab1, "ขณะนี้ยังไม่มีสคริปต์\nโปรดรอการอัพเดตเพิ่มเติม.....")
local Tab2 = window:AddTab("🚫")
window:AddTabDescription(homeTab, "ไม่พบสคริปต์")
window:AddDescription(Tab2, "ขณะนี้ยังไม่มีสคริปต์\nโปรดรอการอัพเดตเพิ่มเติม.....")
local Tab3 = window:AddTab("🚫")
window:AddTabDescription(homeTab, "ไม่พบสคริปต์")
window:AddDescription(Tab3, "ขณะนี้ยังไม่มีสคริปต์\nโปรดรอการอัพเดตเพิ่มเติม.....")
