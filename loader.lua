-- [[ SAILOR PIECE: ULTIMATE ANTI-GROUND FIX ]]
_G.AutoFarm = true
_G.Height = 10 -- Floating height above monster

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- [[ CREATE ANTI-GRAVITY ]]
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = Character:WaitForChild("HumanoidRootPart")

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

-- [[ MOVEMENT LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            local mob = getTarget()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                local myRoot = Character.HumanoidRootPart
                -- Force stay at 0 velocity (No falling)
                myRoot.Velocity = Vector3.new(0, 0, 0)
                -- Teleport to position above the monster
                myRoot.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            end
        end)
    end
end)

print("Ultimate Anti-Ground Loaded!")
