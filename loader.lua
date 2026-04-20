-- [[ SAILOR PIECE: DEEP SEARCH & AUTO FLY ]]
_G.AutoFarm = true
_G.Height = 10
_G.TweenSpeed = 100

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local TweenService = game:GetService("TweenService")

-- [[ LEVEL DATA (LV 0 START) ]]
local MobData = {
    {Level = 0, Name = "Thief"},
    {Level = 20, Name = "Strong Thief"},
    {Level = 50, Name = "Pirate"},
    {Level = 100, Name = "Marine"}
}

-- [[ ANTI-RAGDOLL & NOCLIP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            if Character:FindFirstChild("Humanoid") then
                Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                Character.Humanoid.PlatformStand = true
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end)

-- [[ GET CURRENT MOB NAME ]]
local function getCurrentMob()
    local myLevel = 0
    pcall(function() myLevel = Player.leaderstats.Level.Value end)
    pcall(function() if myLevel == 0 then myLevel = Player.Data.Level.Value end end)
    
    local targetMob = "Thief"
    for _, v in ipairs(MobData) do
        if myLevel >= v.Level then targetMob = v.Name end
    end
    return targetMob
end

-- [[ TWEEN FUNCTION ]]
local function flyTo(targetCFrame)
    local root = Character:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        if distance > 1 then
            local tweenInfo = TweenInfo.new(distance / _G.TweenSpeed, Enum.EasingStyle.Linear)
            TweenService:Create(root, tweenInfo, {CFrame = targetCFrame}):Play()
        end
    end
end

-- [[ MAIN LOOP ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            local mobName = getCurrentMob()
            local target = nil
            
            -- ค้นหามอนสเตอร์แบบละเอียด (Search in all Workspace)
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    target = v
                    break
                end
            end

            if target and target:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- สั่งบิน
                flyTo(targetPos)
                
                -- สวมอาวุธ
                if not Character:FindFirstChildOfClass("Tool") then
                    local tool = Player.Backpack:FindFirstChildOfClass("Tool")
                    if tool then Character.Humanoid:EquipTool(tool) end
                end
                
                -- โจมตีเมื่อถึงระยะ
                if (Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude < 20 then
                    local weapon = Character:FindFirstChildOfClass("Tool")
                    if weapon then weapon:Activate() end
                end
            end
        end)
    end
end)

print("Bypass Tween: Searching for target...")
