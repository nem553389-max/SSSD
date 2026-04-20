-- [[ SAILOR PIECE: AUTO EQUIP BEST WEAPON + AUTO FARM ]]
_G.AutoFarm = true

local Player = game:GetService("Players").LocalPlayer

-- [[ FUNCTION: AUTO EQUIP BEST TOOL ]]
local function equipBestTool()
    local char = Player.Character
    if char and not char:FindFirstChildOfClass("Tool") then
        local backpack = Player.Backpack
        local bestTool = nil
        
        -- Priority: Find any Tool in Backpack
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                bestTool = tool
                break
            end
        end
        
        if bestTool then
            char:WaitForChild("Humanoid"):EquipTool(bestTool)
        end
    end
end

-- [[ MONSTER LIST ]]
local MonsterList = {
    "Thief", "Thief Leader", "Buggy Pirate", "Bobby", "Monkey", 
    "Gorilla", "King Gorilla", "Arlong Minion", "Arlong", 
    "Marine", "Captain Morgan", "Desert Bandit", "Crocodile",
    "Sky Guard", "Enel", "Sea Beast", "Yeti"
}

-- [[ ATTACK FUNCTION ]]
local function attack()
    local char = Player.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then 
            tool:Activate() 
        end
    end
end

-- [[ FIND TARGET FUNCTION ]]
local function getTarget()
    local target = nil
    local dist = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Humanoid") and table.find(MonsterList, v.Parent.Name) and v.Health > 0 then
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
    return target
end

-- [[ MAIN LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Always ensure weapon is equipped
                equipBestTool()
                
                local mob = getTarget()
                if mob then
                    -- Anti-Freeze / Anti-Fling
                    Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    
                    -- Teleport above target (7 units)
                    Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    
                    -- Attack
                    attack()
                end
            end
        end)
    end
end)

print("Auto Equip & Farm Loaded")
