-- [[ SAILOR PIECE: English Version - Anti-Ground & Auto Click ]]
_G.AutoFarm = true

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
        task.wait(0.2)
        pcall(function()
            equipWeapon()
            local mob = getTarget()
                    
