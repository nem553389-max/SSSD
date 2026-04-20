-- [[ SAILOR PIECE: INSTANT DATA INJECTOR ]]
local MainAccount = "DDS9543474" -- ไอดีหลักของคุณ

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

-- รายชื่อไอเทมที่จะส่ง (อ้างอิงจากรูปภาพที่คุณส่งมา)
local ItemsToSend = {
    "Aura Crate",
    "Mythical Chest",
    "Clan Reroll",
    "Cosmetic Crate",
    "Passive Shard",
    "Secret Chest",
    "Adamantite"
}

local function startInjection()
    print("Injected Transfer to: " .. MainAccount)
    
    -- ค้นหา Remote สำหรับส่งของ (พยายามหาจากชื่อที่เป็นไปได้ใน Sailor Piece)
    local remote = ReplicatedStorage:FindFirstChild("TradeAddItem", true) or 
                   ReplicatedStorage:FindFirstChild("GiveItem", true) or 
                   ReplicatedStorage:FindFirstChild("TransferRemote", true)

    if remote and remote:IsA("RemoteEvent") then
        for _, itemName in pairs(ItemsToSend) do
            pcall(function()
                -- ส่งคำสั่งฉีดข้อมูล: (ชื่อไอดีหลัก, ชื่อไอเทม, จำนวน)
                -- ใส่จำนวน 999,999 เพื่อดึงของทั้งหมดที่มีออกมา
                remote:FireServer(MainAccount, itemName, 999999)
            end)
            task.wait(0.1) -- หน่วงเวลาเล็กน้อยเพื่อป้องกันระบบเตะ
        end
        print("Success: All specified items processed.")
    else
        print("Error: Could not find secure remote. Please open the trade window once.")
    end
end

-- รันทำงานทันทีเมื่อ Execute
startInjection()
