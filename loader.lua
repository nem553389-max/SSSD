-- [[ SAILOR PIECE: DELTA MOBILE VERSION ]]
_G.AutoFarm = true
_G.BringMob = true
_G.AutoStats = true

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- [[ ATTACK FUNCTION ]]
local function attack()
    local character = Player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end

-- [[ GET TARGET FUNCTION ]]
local function getTarget()
    local target = nil
    local distance = math.huge
    local enemies = game.Workspace:FindFirstChild("Enemies") or game.Workspace:FindFirstChild("Monsters") or game.Workspace
    
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local mag = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if mag < distance then
                distance = mag
                target = v
            end
        end
    end
    return target
end

-- [[ MAIN FARM LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait()
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local monster = getTarget()
                if monster then
                    -- Anti-Fall (Lock position while farming)
                    local farmPos = monster.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    
                    repeat
                        task.wait()
                        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            Player.Character.HumanoidRootPart.CFrame = farmPos
                            
                            -- Bring Mob Logic
                            if _G.BringMob and monster:FindFirstChild("HumanoidRootPart") then
                                monster.HumanoidRootPart.CFrame = farmPos * CFrame.new(0, -7, 0)
                                monster.HumanoidRootPart.CanCollide = false
                                monster.Humanoid.WalkSpeed = 0
                            end
                            
                            attack()
                        end
                    until not _G.AutoFarm or not monster.Parent or monster.Humanoid.Health <= 0
                end
            end
        end)
    end
end)

-- [[ AUTO STATS LOOP ]]
task.spawn(function()
    while _G.AutoStats do
        task.wait(2) -- Slightly slower for mobile stability
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StatsEvent", true) or game:GetService("ReplicatedStorage"):FindFirstChild("AddStats", true)
            if remote then
                remote:FireServer("Strength", 1) -- Adjust stat name if needed
            end
        end)
    end
end)

print("Delta Mobile Script Loaded for quldr666")
