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
-- FORSAKEN
window:AddMapTab(
    "FORSAKEN",
    "ยินดีต้อนรับสู่ สคริปต์ของผม\nสคริปต์นี้คือสคริปต์แมพ FORSAKEN", "พัฒนาโดย: IronFang\nเวอร์ชันสคริปต์: 7.1.5 ",
    "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/Forsaken.lua"
)
-- 2
window:AddExTab("//")
-- 3
window:AddExTab("//")
-- 4
window:AddExTab("//")
-- 5
window:AddExTab("//")
