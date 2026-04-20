-- [[ SAILOR PIECE PRO HUB - SPEED HUB STYLE ]] --

-- 1. SETTINGS & VARIABLES
_G.Settings = {
    AutoFarm = false,
    AutoQuest = false,
    BringMob = false,
    Weapon = "Combat", -- เปลี่ยนเป็นชื่ออาวุธที่คุณถือ
    Distance = 7
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- 2. TWEEN SYSTEM (เคลื่อนที่แบบนุ่มนวลกันแบน)
function to(targetCFrame)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local distance = (targetCFrame.Position - char.HumanoidRootPart.Position).Magnitude
    local speed = 250 -- ความเร็วในการเคลื่อนที่ (ปรับได้)
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    local tween = TS:Create(char.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- 3. AUTO FARM & QUEST LOGIC
task.spawn(function()
    while task.wait() do
        if _G.Settings.AutoFarm then
            pcall(function()
                -- ตรวจสอบว่ามีเควสต์หรือยัง (ต้องใช้ RemoteEvent ของเกม)
                -- ตัวอย่าง: game:GetService("ReplicatedStorage").Events.Quest:FireServer("GetQuest", "Bandit")
                
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        -- วาร์ปไปหามอนสเตอร์
                        local farmPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        Player.Character.HumanoidRootPart.CFrame = farmPos -- ใช้ Warp ทันทีแบบ Speed Hub
                        
                        -- ดึงมอนสเตอร์ตัวอื่นมารวม (Bring Mob)
                        if _G.Settings.BringMob then
                            for _, otherMob in pairs(workspace.Enemies:GetChildren()) do
                                if (otherMob.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude < 50 then
                                    otherMob.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame
                                    otherMob.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end

                        -- สั่งโจมตี
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        
                        if mob.Humanoid.Health <= 0 then break end
                    end
                end
            end)
        end
    end
end)

-- 4. GUI SETUP (Kavo Library)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SAILOR PIECE: ELITE HUB", "BloodTheme")

-- Tab: Farming
local FarmTab = Window:NewTab("Auto Farming")
local FarmSection = FarmTab:NewSection("Level Farm")

FarmSection:NewToggle("Auto Farm Level", "ฟาร์มเลเวล + รับเควสต์อัตโนมัติ", function(state)
    _G.Settings.AutoFarm = state
end)

FarmSection:NewToggle("Bring Mobs", "ดึงมอนสเตอร์มารวมกัน", function(state)
    _G.Settings.BringMob = state
end)

-- Tab: Combat
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Weapon Settings")

CombatSection:
