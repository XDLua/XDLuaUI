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
window:AddScriptTab("ADMIN", "สคริปต์ Infinite Yield", "สคริปต์ยอดนิยมสำหรับใช้งานคำสั่งแอดมิน", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
window:AddScriptTab("DEX", "สคริปต์ Dex Expolor", "สคริปต์ยอดนิยมสำหรับใช้ดูโครงสร้างแมพ", "https://raw.githubusercontent.com/MITUMAxDev/Tools/refs/heads/main/Dex-Explorer.lua")
-- FORSAKEN
window:AddScriptTab("FORSAKEN", "สคริปต์นี้คือสคริปต์แมพ FORSAKEN", "พัฒนาโดย: KRIDHUB\nเวอร์ชันสคริปต์: 3.5.5", "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/Forsaken.lua")
local Tab1 = window:AddTab("🚫")
window:AddTabDescription(homeTab, "ไม่พบสคริปต์")
window:AddDescription(Tab1, "ขณะนี้ยังไม่มีสคริปต์", "โปรดรอการอัพเดตเพิ่มเติม.....")
local Tab2 = window:AddTab("🚫")
window:AddTabDescription(homeTab, "ไม่พบสคริปต์")
window:AddDescription(Tab2, "ขณะนี้ยังไม่มีสคริปต์", "โปรดรอการอัพเดตเพิ่มเติม.....")
local Tab3 = window:AddTab("🚫")
window:AddTabDescription(homeTab, "ไม่พบสคริปต์")
window:AddDescription(Tab3, "ขณะนี้ยังไม่มีสคริปต์", "โปรดรอการอัพเดตเพิ่มเติม....."
