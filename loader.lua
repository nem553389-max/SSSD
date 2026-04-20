-- [[ SAILOR PIECE: CLEAN & STABLE AUTO FARM ]]
_G.AutoFarm = true
_G.Height = 10
_G.TweenSpeed = 100

local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- ตารางรายชื่อมอนสเตอร์ (เริ่มที่เลเวล 0)
local MobData = {
    {Level = 0, Name = "Thief"},
    {Level = 20, Name = "Strong Thief"},
    {Level = 50, Name = "Pirate"},
    {Level = 100, Name = "Marine"}
}

-- ระบบป้องกันตัวละครนอนนิ่ง (Anti-Ragdoll)
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.5)
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = true
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                -- Noclip: กันติดบั๊ก
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
end)

-- ฟังก์ชันเช็คมอนสเตอร์ตามเลเวล
local function getMobName()
    local lvl = 0
    pcall(function() lvl = Player.leaderstats.Level.Value end)
    pcall(function() if lvl == 0 then lvl = Player.Data.Level.Value end end)
    
    local name = MobData[1].Name
    for _, v in ipairs(MobData) do
        if lvl >= v.Level then name = v.Name end
    end
    return name
end

-- ลูปหลัก (ทำงานทันทีที่รัน)
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        local success, err = pcall(function()
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local mobName = getMobName()
            local target = nil
            
            -- ค้นหามอนสเตอร์ใน Workspace
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    target = v
                    break
                end
            end
            
            if target and target:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- ระบบบิน (Tween)
                local dist = (root.Position - targetPos.Position).Magnitude
                if dist > 1
                            
