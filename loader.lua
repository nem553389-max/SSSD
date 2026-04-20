-- [[ SAILOR PIECE: TWEEN BYPASS FARM (NO THAI) ]]
_G.AutoFarm = true
_G.Height = 10
_G.TweenSpeed = 100 -- ความเร็วในการบิน (ปรับเพิ่ม/ลดได้)

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

-- [[ ANTI-CHEAT BYPASS & NO-FALL ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            if Character and Character:FindFirstChild("Humanoid") then
                -- บังคับลุกขึ้นและปิดแรงโน้มถ่วงชั่วคราว
                Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                Character.Humanoid.PlatformStand = true
                
                -- Noclip (เดินทะลุวัตถุขณะบิน)
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

local function getCurrentMob()
    local myLevel = 0
    pcall(function() myLevel = Player.leaderstats.Level.Value end)
    pcall(function() if myLevel == 0 then myLevel = Player.Data.Level.Value end end)
    
    local targetMob = MobData[1].Name
    for _, v in ipairs(MobData) do
        
