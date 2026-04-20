-- [[ SAILOR PIECE: ULTIMATE AUTO FARM ]]
_G.AutoFarm = true

local Player = game:GetService("Players").LocalPlayer

-- [[ AUTO EQUIP FUNCTION ]]
local function equipWeapon()
    local char = Player.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            char:WaitForChild("Humanoid"):EquipTool(tool)
        end
    end
end

-- [[ GET NEAREST TARGET ]]
local function getTarget()
    local target = nil
    local dist = 1000 
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent ~= Player.Character and v.Health > 0 then
            if not game.Players:GetPlayerFromCharacter(v.Parent) then
                local root = v.Parent:FindFirstChild("HumanoidRootPart")
                if root then
                    local mag = (Player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        target = v.Parent
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
        task.wait(0.1)
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                equipWeapon()
                
                local mob = getTarget()
                if mob then
                    -- Reset Velocity
                    Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    
                    -- Teleport above monster
                    Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    
                    -- Attack
                    local tool = Player.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)

print("Script Activated: Ultimate Auto Farm Running")
