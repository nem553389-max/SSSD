-- [[ SAILOR PIECE: AUTO FARM + AUTO QUEST + AUTO CLICK ]]
_G.AutoFarm = true
_G.Distance = 5 -- Distance above monster

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

-- [[ REFRESH CHARACTER REFERENCE ]]
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Root = newChar:WaitForChild("HumanoidRootPart")
end)

-- [[ OPTIMIZED AUTO EQUIP ]]
local function equipWeapon()
    if not Character:FindFirstChildOfClass("Tool") then
        local tool = Player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            Character.Humanoid:EquipTool(tool)
        end
    end
end

-- [[ AUTO QUEST SYSTEM ]]
local function checkQuest()
    local questGui = Player.PlayerGui:FindFirstChild("Main")
    if not Player:FindFirstChild("QuestValue") or Player.QuestValue.Value == "" then
        for _, v in pairs(game.Workspace.NPCs:GetChildren()) do
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
    local dist = 800 
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if not game.Players:GetPlayerFromCharacter(v) then
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
    end
    return target
end

--
