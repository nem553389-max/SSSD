-- [[ SAILOR PIECE: LEVEL 0 START + ANTI-GROUND ]]
_G.AutoFarm = true
_G.Height = 10

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local TweenService = game:GetService("TweenService")

-- [[ LEVEL DATA TABLE (START FROM LV 0) ]]
local MobData = {
    {Level = 0, Name = "Thief"}, -- เริ่มต้นที่เลเวล 0
    {Level = 20, Name = "Strong Thief"},
    {Level = 50, Name = "Pirate"},
    {Level = 100, Name = "Marine"}
}

-- [[ FIX: FORCE STAND & NOCLIP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            if Character:FindFirstChild("Humanoid") then
                -- บังคับให้ยืนเสมอ และแก้สถานะนอนนิ่ง
                Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                Character.Humanoid.PlatformStand = false
            end
            -- ระบบ Noclip กันติดบั๊กพื้น
            for _, part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

local function getCurrentMob()
    local myLevel = 0
    -- เช็คเลเวลจากทุกที่ที่อาจจะเป็นไปได้
    pcall(function() myLevel = Player.leaderstats.Level.Value end)
    pcall(function() if myLevel == 0 then myLevel = Player.Data.Level.Value end end)
    
    local targetMob = MobData[1].Name
    for _, v in ipairs(MobData) do
        if myLevel >= v.Level then
            targetMob = v.Name
        end
    end
    return targetMob
end

local function equipWeapon()
    if not Character:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then Character.Humanoid:EquipTool(tool) end
    end
end

-- [[ MAIN FARM LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            local mobName = getCurrentMob()
            local target = nil
            
            -- ค้นหามอนสเตอร์
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    target = v
                    break
                end
            end

            if target and target:FindFirstChild("HumanoidRootPart") then
                local root = Character.HumanoidRootPart
                root.Velocity = Vector3.new(0, 0, 0)
                
                -- วาร์ปไปเหนือมอนสเตอร์ (กันมุดดิน 100%)
                local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                root.CFrame = targetPos
                
                -- โจมตี
                local tool = Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end)
    end
end)

print("Script Started: Level 0 Farm Active")
