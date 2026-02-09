--[[ 
    CONFIGURATION 
--]]
local CONFIG = {
    INCREMENT = 0.05,     -- Smaller increment for smoother holding
    NORMAL_HEIGHT = 2.3,  
    MIN_LIMIT = 0.5,      
    MAX_LIMIT = 5.0,      
}

-- Credits: BoNaif
local player = game.Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. Main Screen
local sg = Instance.new("ScreenGui")
sg.Name = "BoNaif_Suspension_Scaled"
sg.ResetOnSpawn = false
sg.Parent = pGui

-- 2. Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 320)
main.Position = UDim2.new(0.5, -210, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.BorderSizePixel = 0
main.Active = true
main.Parent = sg

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

-- Draggable Logic
local dragToggle, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true dragStart = input.Position startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

-- 3. Header
local title = Instance.new("TextLabel")
title.Text = "Suspension control script"
title.Size = UDim2.new(0, 150, 0, 40)
title.Position = UDim2.new(0, 20, 0, 5)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true -- ENABLED
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Top Right Buttons
local function createTopBtn(txt, color, xOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 35)
    btn.Position = UDim2.new(1, xOffset, 0, 10)
    btn.BackgroundColor3 = color
    btn.Text = txt
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true -- ENABLED
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Parent = main
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

local transBtn = createTopBtn("AR", Color3.fromRGB(40, 40, 40), -45)
local minBtn = createTopBtn("-", Color3.fromRGB(40, 40, 40), -95)

-- 4. Wheel Controls
local wheelList = Instance.new("Frame")
wheelList.Size = UDim2.new(1, -40, 0, 180)
wheelList.Position = UDim2.new(0, 20, 0, 60)
wheelList.BackgroundTransparency = 1
wheelList.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = wheelList

local function getSpring(car, wheelName)
    local wheelsFolder = car:FindFirstChild("Wheels")
    local wheelPart = wheelsFolder and wheelsFolder:FindFirstChild(wheelName)
    return wheelPart and (wheelPart:FindFirstChild("Spring") or wheelPart:FindFirstChildWhichIsA("SpringConstraint"))
end

local function createRow(name)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 35)
    row.BackgroundTransparency = 1
    row.Parent = wheelList

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 70, 1, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true -- ENABLED
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local function createSideBtn(txt, xPos)
        local b = Instance.new("TextButton")
        b.Text = txt
        b.Size = UDim2.new(0, 110, 1, 0)
        b.Position = UDim2.new(0, xPos, 0, 0)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.TextScaled = true -- ENABLED
        b.BorderSizePixel = 0
        b.Font = Enum.Font.Gotham
        b.Parent = row
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = b

        -- Function to update suspension
        local function updateSuspension()
            local char = player.Character
            local seat = char and char:FindFirstChildWhichIsA("Humanoid") and char.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                local spring = getSpring(seat.Parent, name)
                if spring then
                    local move = (txt == "UP +") and CONFIG.INCREMENT or -CONFIG.INCREMENT
                    spring.FreeLength = math.clamp(spring.FreeLength + move, CONFIG.MIN_LIMIT, CONFIG.MAX_LIMIT)
                    label.Text = name .. " [" .. math.floor(spring.FreeLength * 10)/10 .. "]"
                end
            end
        end

        -- Holding Logic
        local isHolding = false
        b.MouseButton1Down:Connect(function()
            isHolding = true
            while isHolding do
                updateSuspension()
                task.wait(0.05)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then isHolding = false end
        end)

        return b
    end

    createSideBtn("UP +", 80)
    createSideBtn("DOWN", 205)
    return label
end

local rows = {FR = createRow("FR"), FL = createRow("FL"), RR = createRow("RR"), RL = createRow("RL")}

-- 5. Reset All Button
local resetBtn = Instance.new("TextButton")
resetBtn.Text = "RESET ALL SUSPENSION"
resetBtn.Size = UDim2.new(1, -40, 0, 35)
resetBtn.Position = UDim2.new(0, 20, 0, 245)
resetBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
resetBtn.TextColor3 = Color3.new(1, 1, 1)
resetBtn.TextScaled = true -- ENABLED
resetBtn.Font = Enum.Font.GothamBold
resetBtn.BorderSizePixel = 0
resetBtn.Parent = main
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetBtn

resetBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local seat = char and char:FindFirstChildWhichIsA("Humanoid") and char.Humanoid.SeatPart
    if seat and seat:IsA("VehicleSeat") then
        for n, l in pairs(rows) do
            local spring = getSpring(seat.Parent, n)
            if spring then 
                spring.FreeLength = CONFIG.NORMAL_HEIGHT 
                l.Text = n .. " [" .. CONFIG.NORMAL_HEIGHT .. "]"
            end
        end
    end
end)

-- 6. Credits
local credits = Instance.new("TextLabel")
credits.Text = "Credits: BoNaif"
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -25)
credits.TextColor3 = Color3.fromRGB(80, 80, 80)
credits.TextScaled = true -- ENABLED
credits.BackgroundTransparency = 1
credits.Parent = main

-- 7. Utility Logic
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
local isMin = false
minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    wheelList.Visible = not isMin
    resetBtn.Visible = not isMin
    credits.Visible = not isMin
    main:TweenSize(isMin and UDim2.new(0, 420, 0, 55) or UDim2.new(0, 420, 0, 320), "Out", "Quad", 0.3, true)
end)

local isAr = false
transBtn.MouseButton1Click:Connect(function()
    isAr = not isAr
    if isAr then
        transBtn.Text = "EN" title.Text = "سكربت هيدروليك" resetBtn.Text = "إعادة ضبط الترفيع"
    else
        transBtn.Text = "AR" title.Text = "Suspension control script" resetBtn.Text = "RESET ALL SUSPENSION"
    end
end)
