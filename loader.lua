-- [[ SAILOR PIECE: ULTIMATE ANTI-FALL + TWEEN FARM ]]
_G.AutoFarm = true
_G.Height = 12

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local TweenService = game:GetService("TweenService")

-- [[ DISABLE PHYSICS TO PREVENT FALLING ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.5)
        if Character and Character:FindFirstChild("Humanoid") then
            -- ปิดการคำนวณพื้นดินเพื่อไม่ให้ตัวละครร่วง
            Character.Humanoid.PlatformStand = true 
        end
    end
end)

-- [[ AUTO EQUIP ]]
local function equipWeapon()
    if not Character:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then Character.Humanoid:EquipTool(tool) end
    end
end

-- [[ TARGET FINDER ]]
local function getTarget()
    local target = nil
    local dist = 1000
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= Character then
            local root = v:FindFirstChild("HumanoidRootPart")
            if root then
                local mag = (Character.HumanoidRootPart.Position - root.Position).Magnitude
                if mag < dist then dist = mag; target = v end
            end
        end
    end
    return target
end

-- [[ AUTO CLICK ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end)
    end
end)

-- [[ TWEEN MOVEMENT ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            local mob = getTarget()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                local root = Character.HumanoidRootPart
                local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- ใช้ Tween เพื่อล็อคตำแหน่งให้สมูทและไม่มุด
                TweenService:Create(root, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetPos}):Play()
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end)

print("Ultimate Fix: Tween & PlatformStand Loaded!")
