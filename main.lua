-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- LOAD TOPBARPLUS (executor only)
local TopbarPlus = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/1ForeverHD/TopbarPlus/main/init.lua"
))()

-- ===== SPEED GUI =====
local speedGui = Instance.new("ScreenGui")
speedGui.Name = "SpeedGui"
speedGui.Enabled = false
speedGui.Parent = CoreGui

-- placeholder frame
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.fromScale(0.2, 0.2)
speedFrame.Position = UDim2.fromScale(0.4, 0.4)
speedFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedFrame.Parent = speedGui

-- ===== SUSPENSION GUI =====
local suspensionGui = Instance.new("ScreenGui")
suspensionGui.Name = "SuspensionGui"
suspensionGui.Enabled = false
suspensionGui.Parent = CoreGui

-- placeholder frame
local susFrame = Instance.new("Frame")
susFrame.Size = UDim2.fromScale(0.2, 0.2)
susFrame.Position = UDim2.fromScale(0.4, 0.4)
susFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
susFrame.Parent = suspensionGui

-- ===== TOPBAR ICONS =====
local speedIcon = TopbarPlus.new()
    :setLabel("Speed")
    :setIcon("rbxassetid://6031280882") -- optional
    :bindEvent("selected", function()
        speedGui.Enabled = not speedGui.Enabled
    end)

local suspensionIcon = TopbarPlus.new()
    :setLabel("Suspension")
    :setIcon("rbxassetid://6031280882") -- optional
    :bindEvent("selected", function()
        suspensionGui.Enabled = not suspensionGui.Enabled
    end)



local StarterGui = game:GetService("StarterGui")

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title or "Notification",
			Text = text or "",
			Duration = duration or 3
		})
	end)
end



notify("Loaded جرينفل جربعة", "by: BoNaif discord: ujade", 4)
