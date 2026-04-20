-- [[ SAILOR PIECE: TARGETED AUTO FARM ]]
_G.AutoFarm = true

local Player = game:GetService("Players").LocalPlayer

-- [[ MONSTER LIST - ALL ISLANDS ]]
local MonsterList = {
    "Thief", "Thief Leader", "Buggy Pirate", "Bobby", "Monkey", 
    "Gorilla", "King Gorilla", "Arlong Minion", "Arlong", 
    "Marine", "Captain Morgan", "Desert Bandit", "Crocodile",
    "Sky Guard", "Enel", "Sea Beast", "Yeti"
}

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

-- [[ GET TARGET FROM LIST ]]
local function getTarget()
    local target = nil
    local dist = math.huge
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        -- Check if it is a Humanoid and in our MonsterList
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
                equipWeapon() -- Always hold weapon
                
                local mob = getTarget()
                if mob then
                    -- Anti-Fling (Reset Velocity)
                    Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    
                    -- Teleport 7 studs above monster
                    Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
                    
                    -- Fast Attack
                    local tool = Player.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)

print("Targeted Farm Loaded: Farming all listed monsters!")
