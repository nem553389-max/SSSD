-- [[ SAILOR PIECE: TEST VERSION - FORCE TELEPORT ]]
_G.AutoFarm = true
_G.Height = 10 -- ระยะความสูงจากหัวมอนสเตอร์

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- [[ แก้ปัญหานอนนิ่ง ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.5)
        pcall(function()
            if Character:FindFirstChild("Humanoid") then
                -- บังคับให้ตัวละครยืนเสมอ ไม่ให้นอน Ragdoll
                Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end)

-- [[ สวมใส่อาวุธ ]]
local function equipWeapon()
    if not Character:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then Character.Humanoid:EquipTool(tool) end
    end
end

-- [[ ลูปฟาร์มหลัก ]]
task.spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        pcall(function()
            equipWeapon()
            
            -- ค้นหามอนสเตอร์ที่ชื่อว่า Thief
            local target = nil
            for _, v in pairs(game.Workspace:GetChildren()) do
                -- ตรวจสอบชื่อ "Thief" (เช็คตัวพิมพ์เล็กพิมพ์ใหญ่ให้ตรงในเกมนะครับ)
                if (v.Name == "Thief" or v.Name:find("Thief")) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    target = v
                    break
                end
            end

            if target and target:FindFirstChild("HumanoidRootPart") then
                local root = Character.HumanoidRootPart
                root.Velocity = Vector3.new(0, 0, 0)
                
                -- วาร์ปไปที่มอนสเตอร์ (ลอยเหนือหัว 10 หน่วย)
                root.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Height, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- สั่งคลิกโจมตี
                local tool = Character:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate() 
                end
            end
        end)
    end
end)

print("Test Version: Force Teleport Thief Loaded!")
