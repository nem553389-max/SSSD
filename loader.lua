-- [[ SAILOR PIECE: ANTI-GROUND VERSION ]]
_G.AutoFarm = true
_G.Height = 10 -- เพิ่มความสูงเป็น 10 หน่วย (กันมุดแน่นอน)

local Player = game:GetService("Players").LocalPlayer

-- [[ AUTO EQUIP ]]
local function equipWeapon()
    local char = Player.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            char.Humanoid:EquipTool(tool)
        end
    end
end

-- [[ TARGET FINDER ]]
local function getTarget()
    local target = nil
    local dist = 1000
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= Player.Character then
            local root = v:FindFirstChild("HumanoidRootPart")
            if root then
                local mag = (Player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

-- [[ AUTO CLICK LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then 
                tool:Activate() 
            end
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
                local root = Player.Character.HumanoidRootPart
                -- ล็อคความเร็วให้เป็น 0 เพื่อป้องกันตัวละครร่วงหรือมุด
                root.Velocity = Vector3.new(0, 0, 0)
                -- ยืนสูงขึ้นจากหัวมอนสเตอร์ 10 หน่วย
                root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0)
            end
        end)
    end
end)

print("Anti-Ground Script: Running")
