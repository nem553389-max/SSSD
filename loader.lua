-- [[ SAILOR PIECE: PRO FARM 1-MAX (BYPASS EDITION) ]]
_G.AutoFarm = true
_G.Height = 11 -- ความสูงตอนฟาร์ม
_G.TweenSpeed = 120 -- ความเร็วในการบิน (100-150 คือปลอดภัย)

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local TweenService = game:GetService("TweenService")

-- [[ ตารางรายชื่อมอนสเตอร์ และเลเวลที่ต้องไปฟาร์ม ]]
local MobData = {
    {Level = 0, Name = "Thief"},
    {Level = 20, Name = "Strong Thief"},
    {Level = 50, Name = "Pirate"},
    {Level = 100, Name = "Marine"},
    {Level = 180, Name = "Elite Marine"},
    {Level = 250, Name = "Fishman"},
    {Level = 400, Name = "Sky Pirate"}
}

-- [[ ระบบป้องกันตัวละครค้าง/นอนนิ่ง/ติดบั๊กพื้น ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.2)
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                -- บังคับให้ยืน และปิดฟิสิกส์การล้ม
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                char.Humanoid.PlatformStand = true
                
                -- Noclip: บินทะลุทุกอย่าง
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- [[ ฟังก์ชันเช็คเลเวลปัจจุบัน ]]
local function getMyLevel()
    local lvl = 0
    -- เช็คหลายๆ Path เผื่อชื่อโฟลเดอร์ไม่เหมือนกัน
    local stats = Player:FindFirstChild("leaderstats") or Player:FindFirstChild("Data")
    if stats and stats:FindFirstChild("Level") then
        lvl = stats.Level.Value
    end
    return lvl
end

-- [[ ฟังก์ชันค้นหาเป้าหมายตามเลเวล ]]
local function getTargetName()
    local currentLvl = getMyLevel()
    local target = MobData[1].Name
    for _, v in ipairs(MobData) do
        if currentLvl >= v.Level then
            target = v.Name
        end
    end
    return target
end

-- [[ ลูปหลัก: บินไปตี ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        local success, err = pcall(function()
            local char = Player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local targetName = getTargetName()
            local mob = nil
            
            -- ค้นหามอนสเตอร์ที่ใกล้ที่สุดใน Workspace
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == targetName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    mob = v
                    break
                end
            end

            if mob and mob:FindFirstChild("HumanoidRootPart") then
                -- คำนวณตำแหน่งการบิน (เหนือหัวมอนสเตอร์)
                local targetCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- ระบบบิน (Tween)
                local distance = (root.Position - targetCFrame.Position).Magnitude
                if distance > 2 then
                    local tween = TweenService:Create(root, TweenInfo.new(distance/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                    tween:Play()
                end

                -- ระบบตี (Auto Attack)
                if distance < 15 then
                    -- สวมอาวุธ (ถ้ายังไม่ถือ)
                    if not char:FindFirstChildOfClass("Tool") then
                        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
                        if tool then char.Humanoid:EquipTool(tool) end
                    end
                    -- คลิกโจมตี
                    local weapon = char:FindFirstChildOfClass("Tool")
                    if weapon then weapon:Activate() end
                end
            else
                -- ถ้าหามอนสเตอร์รอบๆ ไม่เจอ (อาจจะอยู่คนละเกาะ) ให้ทำความเร็ว 0 ไว้ก่อน
                root.Velocity = Vector3.new(0,0,0)
            end
        end)
    end
end)

print("--- SAILOR PIECE AUTO FARM STARTED ---")
