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
window:AddScriptTab("DEX", "สคริปต์ Dex Explorer", "สคริปต์ยอดนิยมสำหรับใช้ดูโครงสร้างแมพ", "https://raw.githubusercontent.com/MITUMAxDev/Tools/refs/heads/main/Dex-Explorer.lua")
window:AddScriptTab("AIMBOT", "สคริปต์ AIMBOT", "พัฒนาโดย: KRIDHUB", "https://raw.githubusercontent.com/XDLua/KRIDHUB/refs/heads/main/KRIDHUB.lua")
window:AddScriptTab("FORSAKEN", "สคริปต์ FORSAKEN", "พัฒนาโดย: KRIDHUB", "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/GROK.lua")
