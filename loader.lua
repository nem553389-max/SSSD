-- [[ SAILOR PIECE: CORRECTED NAMES (Thief Lv.1) ]]
_G.AutoFarm = true
_G.Height = 12

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local TweenService = game:GetService("TweenService")

-- [[ UPDATED MOB DATA: Corrected Lv.1 to Thief ]]
local MobData = {
    {Level = 1, Name = "Thief"},
    {Level = 20, Name = "Strong Thief"},
    {Level = 45, Name = "Pirate"},
    {Level = 75, Name = "Brute Pirate"},
    {Level = 110, Name = "Monkey"},
    {Level = 150, Name = "Gorilla"},
    {Level = 200, Name = "Marine"},
    {Level = 250, Name = "Elite Marine"},
    {Level = 320, Name = "Fishman"},
    {Level = 400, Name = "Elite Fishman"},
    {Level = 500, Name = "Sky Pirate"},
    {Level = 650, Name = "Elite Sky Pirate"}
}

local function getCurrentMob()
    local myLevel = 0
    pcall(function() myLevel = Player.leaderstats.Level.Value end)
    if myLevel == 0 then
        pcall(function() myLevel = Player.Data.Level.Value end)
    end

    local targetMob = MobData[1].Name
    for _, v in ipairs(MobData) do
        if myLevel >= v.Level then
            targetMob = v.Name
        end
    end
    return targetMob
end

task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.5)
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.PlatformStand = true 
            Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

local function equipWeapon()
    if not Character:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then Character.Humanoid:EquipTool(tool) end
    end
end

local function getTarget()
    local mobName = getCurrentMob()
    local target = nil
    local dist = 15000 
    
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local root = v:FindFirstChild("HumanoidRootPart")
            if root then
                local mag = (Character.HumanoidRootPart.Position - root.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local tool = Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end)
    end
end)

task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            local mob = getTarget()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                local root = Character.HumanoidRootPart
                local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                TweenService:Create(root, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetPos}):Play()
            end
        end)
    end
end)

print("Auto Farm: Thief (Lv.1) Loaded!")
