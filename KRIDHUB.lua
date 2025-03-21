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
    "นี่คือคำอธิบายของแมพ1\n- รองรับผู้เล่น 1-4 คน\n- ความยาก: ง่าย",
    "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/Map1Script.lua"
)
-- เพิ่มแท็บสำหรับแมพ2
ui:AddMapTab(
    "แมพ2",
    "นี่คือคำอธิบายของแมพ2\n- รองรับผู้เล่น 2-6 คน\n- ความยาก: ปานกลาง",
    "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/Map2Script.lua"
)
-- เพิ่มแท็บสำหรับแมพ3
ui:AddMapTab(
    "แมพ3",
    "นี่คือคำอธิบายของแมพ3\n- รองรับผู้เล่น 4-8 คน\n- ความยาก: ยาก",
    "https://raw.githubusercontent.com/XDLua/XDLuaUI/refs/heads/main/Map3Script.lua"
)
