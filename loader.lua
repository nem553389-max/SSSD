-- [[ SAILOR PIECE: ORIGINAL + ANTI-GROUND FIX ]]
_G.AutoFarm = true
_G.Distance = 8 -- Increased distance to stay above the ground

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

-- [[ REFRESH CHARACTER ]]
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Root = newChar:WaitForChild("HumanoidRootPart")
end)

-- [[ AUTO EQUIP ]]
local function equipWeapon()
    if not Character:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            Character.Humanoid:EquipTool(tool)
        end
    end
end

-- [[ AUTO QUEST ]]
local function checkQuest()
    if not Player:FindFirstChild("QuestValue") or Player.QuestValue.Value == "" then
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:FindFirstChild("Head") and (Root.Position - v.Head.Position).Magnitude < 50 then
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote") 
                if remote then
                    remote:FireServer(v.Name)
                end
            end
        end
    end
end

-- [[ TARGET FINDER ]]
local function getTarget()
    local target = nil
    local dist = 1000 
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v ~= Character then
            local mRoot = v:FindFirstChild("HumanoidRootPart")
            if mRoot then
                local mag = (Root.Position - mRoot.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
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
            if _G.AutoFarm and Character:FindFirstChildOfClass("Tool") then
                Character:FindFirstChildOfClass("Tool"):Activate()
            end
        end)
    end
end)

-- [[ MAIN LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            checkQuest()
            
            local mob = getTarget()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                -- Anti-Gravity & Anti-Ground
                Root.Velocity = Vector3.new(0, 0, 0)
                -- Teleport 8 studs ABOVE the monster to avoid the floor
                Root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            end
        end)
    end
end)

print("Original Auto Farm Loaded - Anti-Ground Enabled")
