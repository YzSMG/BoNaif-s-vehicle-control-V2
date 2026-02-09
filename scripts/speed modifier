-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Settings
local velocityMult = 0.003
local directionMode = 0 -- 0=OFF,1=RAW,2=FORCE
local language = "EN"   -- "EN" or "AR"

-- Gamepad triggers
local accelTrigger = 0
local brakeTrigger = 0

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(0.22, 0.28)
frame.Position = UDim2.fromScale(0.02, 0.62)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 8, 0, 6)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- ================= Draggable GUI =================
local dragging = false
local dragInput, mousePos, framePos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

-- Minimize button
local minimized = false
local fullSize = frame.Size

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 28, 0, 28)
minimize.Position = UDim2.new(1, -34, 0, 6)
minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minimize.Text = "–"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.Parent = frame
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

-- Language button
local langToggle = Instance.new("TextButton")
langToggle.Size = UDim2.new(0, 28, 0, 28)
langToggle.Position = UDim2.new(1, -70, 0, 6) -- next to minimize
langToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
langToggle.TextColor3 = Color3.new(1, 1, 1)
langToggle.Font = Enum.Font.GothamBold
langToggle.TextSize = 14
langToggle.Parent = frame
Instance.new("UICorner", langToggle).CornerRadius = UDim.new(0, 6)

-- Speed input
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 34)
input.Position = UDim2.new(0, 10, 0, 45)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.Text = tostring(velocityMult)
input.ClearTextOnFocus = false
input.Parent = frame
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

-- Car Direction toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 32)
toggle.Position = UDim2.new(0, 10, 0, 88)
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)
-- Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, -10, 0, 20)
credits.Position = UDim2.new(0, 5, 1, -25)
credits.BackgroundTransparency = 1
credits.TextColor3 = Color3.fromRGB(180, 180, 180)
credits.Font = Enum.Font.Gotham
credits.TextSize = 12
credits.Parent = frame

-- ========== Functions ==========
local function updateTexts()
	title.Text = language == "EN" and "Vehicle Speed" or "سرعة المركبة"

	if directionMode == 0 then
		toggle.Text = language == "EN" and "Car Direction: OFF" or "اتجاه المركبة: إيقاف"
	elseif directionMode == 1 then
		toggle.Text = language == "EN" and "Car Direction: RAW" or "اتجاه المركبة: خام"
	else
		toggle.Text = language == "EN" and "Car Direction: FORCE" or "اتجاه المركبة: قوة"
	end

	credits.Text = language == "EN" and "Credits: BoNaif" or "الحقوق: BoNaif"
	langToggle.Text = language == "EN" and "AR" or "EN"
end

updateTexts()

-- Minimize button
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		fullSize = frame.Size
		frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 40)
		input.Visible = false
		toggle.Visible = false
		credits.Visible = false
		langToggle.Visible = false
		killButton.Visible = false
	else
		frame.Size = fullSize
		input.Visible = true
		toggle.Visible = true
		credits.Visible = true
		langToggle.Visible = true
		killButton.Visible = true
	end
end)

-- Language toggle
langToggle.MouseButton1Click:Connect(function()
	language = language == "EN" and "AR" or "EN"
	updateTexts()
end)
-- Speed input
input.FocusLost:Connect(function()
	local val = tonumber(input.Text)
	if val then
		velocityMult = math.clamp(val, 0, 1)
		input.Text = tostring(velocityMult)
	end
end)

-- Car Direction toggle
toggle.MouseButton1Click:Connect(function()
	directionMode = (directionMode + 1) % 3
	updateTexts()
end)

-- Gamepad triggers
UserInputService.InputChanged:Connect(function(inputObj)
	if inputObj.UserInputType == Enum.UserInputType.Gamepad1 then
		if inputObj.KeyCode == Enum.KeyCode.ButtonR2 then
			accelTrigger = inputObj.Position.Z
		elseif inputObj.KeyCode == Enum.KeyCode.ButtonL2 then
			brakeTrigger = inputObj.Position.Z
		end
	end
end)

-- ================= Vehicle Logic =================
RunService.Stepped:Connect(function()
	local Character = LocalPlayer.Character
	if not Character then return end

	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	if not Humanoid then return end

	local SeatPart = Humanoid.SeatPart
	if not SeatPart or not SeatPart:IsA("VehicleSeat") then return end

	local accelerating = UserInputService:IsKeyDown(Enum.KeyCode.W) or accelTrigger > 0.1
	local braking = UserInputService:IsKeyDown(Enum.KeyCode.S) or brakeTrigger > 0.1

	if accelerating then
		local strength = math.max(accelTrigger, 1)
		local vel = SeatPart.AssemblyLinearVelocity
		local speed = vel.Magnitude

		if directionMode == 0 then
			local mult = 1 + velocityMult * strength
			SeatPart.AssemblyLinearVelocity *= Vector3.new(mult, 1, mult)

		elseif directionMode == 1 and speed > 0 then
			local dir = Vector3.new(
				SeatPart.CFrame.LookVector.X,
				0,
				SeatPart.CFrame.LookVector.Z
			).Unit
			local newSpeed = speed * (1 + velocityMult * strength)
			SeatPart.AssemblyLinearVelocity = dir * newSpeed

		elseif directionMode == 2 then
			local dir = Vector3.new(
				SeatPart.CFrame.LookVector.X,
				0,
				SeatPart.CFrame.LookVector.Z
			).Unit
			SeatPart.AssemblyLinearVelocity += dir * (velocityMult * 1000 * strength)
		end

	elseif braking then
		local mult = 1 - velocityMult * math.max(brakeTrigger, 1)
		SeatPart.AssemblyLinearVelocity *= Vector3.new(mult, 1, mult)
	end
end)
