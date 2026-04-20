-- [[ SAILOR PIECE: SPAWN-FIX VERSION - NO THAI ]]
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
            -- Disable platform physics to prevent falling
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

-- [[ UPDATED TARGET FINDER - SPAWN CHECK ]]
local function getTarget()
    local target = nil
    local dist = 1000
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= Character then
            -- Check if the monster's model is loaded and not clipping
            local root = v:FindFirstChild("HumanoidRootPart")
            if root and root.Parent and root.Parent:FindFirstChild("Head") then
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

-- [[ TWEEN MOVEMENT - SPAWN-AWARE ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            local mob = getTarget()
            if mob then
                local root = Character.HumanoidRootPart
                -- Additional check for clipping during spawn
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                if mobRoot and (root.Position - mobRoot.Position).Magnitude < 200 then
                    -- Delay slightly if the monster is very close to ground or spawn
                    if mobRoot.Position.Y < (game.Workspace.Baseplate or game.Workspace:FindFirstChildOfClass("BasePart")).Position.Y + 2 then
                        task.wait(0.05)
                    end
                end
                
                local targetPos = mobRoot.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- Smooth tween movement to prevent sudden clips
                TweenService:Create(root, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {CFrame = targetPos}):Play()
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end)

print("Spawn-Fix Version Loaded!")
