-- โหลด UI Library
local XDLuaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/XDLuaUI.lua"))()

-- สร้างหน้าต่าง
local window = XDLuaUI:CreateWindow("🔹 KRIDHUB 🔹")

-- เพิ่มแท็บ
local homeTab = window:AddTab("🏠 หน้าหลัก")
window:AddTabDescription(homeTab, "🏠 หน้าหลัก")
-- เพิ่มคำอธิบายและเครดิต
window:AddDescription(homeTab, "ยินดีต้อนรับสู่ KRIDHUB\nสคริปต์นี้คือสคริปต์รวมแมพ", "พัฒนาโดย: KRIDHUB")
-- เพิ่มปุ่มคัดลอกลิงค์ YouTube
window:Youtube(homeTab, "https://www.youtube.com/@IronFang2008")
-- เพิ่มปุ่มคัดลอกลิงค์ดิสคอร์ด
window:Discord(homeTab)
-- ฟอนต์
local font = Enum.Font.GothamBlack
-- FORSAKEN
window:AddMapTab(
    "FORSAKEN",
    "ยินดีต้อนรับสู่ สคริปต์ของผม\nสคริปต์นี้คือสคริปต์แมพ FORSAKEN", "พัฒนาโดย: IronFang\nเวอร์ชันสคริปต์: 7.1.5 ",
    "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/Forsaken.lua"
)
-- 2
window:AddExTab(//)
-- 3
window:AddExTab(//)
-- 4
window:AddExTab(//)
-- 5
window:AddExTab(//)
