-- [[ Valennity Hub - SAILOR PIECE EDITION ]] --

-- 1. Anti-AFK ระบบกันหลุด
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. โหลด UI Library (ธีม Valennity Red-Black)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Valennity Hub ★", "BloodTheme")

-- 3. ตัวแปรระบบ
_G.AutoFarm = false
_G.GodMode = false
_G.BringMob = false
_G.Distance = 8
_G.AutoQuest = false

-- 4. ฟังก์ชันหลัก: อมตะ (God Mode)
task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.GodMode then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    -- ปิด Collider เพื่อให้ดาเมจทะลุตัว
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        end
    end)
end)

-- 5. ฟังก์ชันหลัก: Auto Farm + Bring Mob
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local enemyFolder = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs") -- รองรับหลายชื่อโฟลเดอร์
                
                if enemyFolder then
                    for _, mob in pairs(enemyFolder:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            repeat
                                task.wait()
                                if not _G.AutoFarm then break end
                                        
-- บรรทัดเดิมของคุณที่มีอยู่แล้ว
local Window = Library.CreateLib("★ Valennity Hub ★", "BloodTheme")

-- ก๊อปปี้ส่วนนี้ไปวางเพิ่มเพื่อให้ UI ขยับได้ 100%
local CoreGui = game:GetService("CoreGui")
local MainUI = CoreGui:FindFirstChild("★ Valennity Hub ★") or CoreGui:FindFirstChild("Library")

if MainUI then
    local Frame = MainUI:FindFirstChildOfClass("Frame")
    if Frame then
        Frame.Active = true
        Frame.Draggable = true
    end
                                        end
                                        
