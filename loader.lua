-- [[ SAILOR PIECE: FLY FARM (NO NOCLIP) ]]
_G.AutoFarm = true
_G.Height = 12
_G.Speed = 100

local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local Character = Player.Character or Player.CharacterAdded:Wait()

-- [[ LEVEL DATA ]]
local MobData = {
    {Level = 0, Name = "Thief"},
    {Level = 20, Name = "Strong Thief"},
    {Level = 50, Name = "Pirate"},
    {Level = 100, Name = "Marine"}
}

-- [[ ANTI-GRAVITY SYSTEM (ยืนบนอากาศ) ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.Humanoid.PlatformStand = true
                -- ล้างแรงโน้มถ่วงเพื่อให้ลอยได้โดยไม่ทะลุแมพ
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                
                -- ตรวจสอบว่าไม่ได้นอนนิ่ง
                if char.Humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end)
    end
end)

local function getTargetName()
    local lvl = 0
    pcall(function() lvl = Player.leaderstats.Level.Value end)
    pcall(function() if lvl == 0 then lvl = Player.Data.Level.Value end end)
    
    local name = MobData[1].Name
    for _, v in ipairs(MobData) do
        if lvl >= v.Level then name = v.Name end
    end
    return name
end

-- [[ MAIN FARM LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local char = Player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local mobName = getTargetName()
            local target = nil
            
            -- ค้นหามอนสเตอร์
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    target = v
                    break
                end
            end

            if target and target:FindFirstChild("HumanoidRootPart") then
                -- คำนวณตำแหน่งเหนือหัวมอนสเตอร์
                local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- ใช้ Tween บินไป (จะติดกำแพงถ้าขวางทาง เพราะไม่ได้เปิด Noclip)
                local dist = (root.Position - targetPos.Position).Magnitude
                if dist > 2 then
                    TweenService:Create(root, TweenInfo.new(dist/_G.Speed, Enum.EasingStyle.Linear), {CFrame = targetPos}):Play()
                end

                -- โจมตี
                if dist < 15 then
                    if not char:FindFirstChildOfClass("Tool") then
                        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
                        if tool then char.Humanoid:EquipTool(tool) end
                    end
                    local weapon = char:FindFirstChildOfClass("Tool")
                    if weapon then weapon:Activate() end
                end
            end
        end)
    end
end)

print("Fly Farm Loaded (Collision Enabled)")
