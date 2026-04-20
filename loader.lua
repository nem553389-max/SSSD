-- [[ SAILOR PIECE: STABLE FARM & EQUIP ]]
_G.AutoFarm = true

local Player = game:GetService("Players").LocalPlayer

-- [[ STABLE EQUIP ]]
local function equipWeapon()
    local char = Player.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            char.Humanoid:EquipTool(tool)
        end
    end
end

-- [[ STABLE TARGET FINDER ]]
local function getTarget()
    local target = nil
    local dist = 1000
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if not game.Players:GetPlayerFromCharacter(v) then
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
    end
    return target
end

-- [[ MAIN LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.2)
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                equipWeapon()
                local mob = getTarget()
                if mob then
                    Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                    
                    local tool = Player.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end)
    end
end)

print("Stable Farm Loaded! Stand near monsters.")
