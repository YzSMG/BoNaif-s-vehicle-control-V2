-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- ===== TOPBARPLUS LOAD (executor only) =====
local TopbarPlus = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/1ForeverHD/TopbarPlus/main/init.lua"
))()

-- ===== FUNCTION TO LOAD ANY LOADSTRING SCRIPT =====
local loadedScripts = {} -- store loaded scripts

local function toggleLoadstring(name, url)
    if loadedScripts[name] then
        -- already loaded, just toggle visibility
        loadedScripts[name].Enabled = not loadedScripts[name].Enabled
    else
        -- first time loading
        local gui = loadstring(game:HttpGet(url))()
        if typeof(gui) == "Instance" then
            gui.Parent = CoreGui
            loadedScripts[name] = gui
        else
            warn("Loaded script did not return a GUI instance")
        end
    end
end

-- ===== TOPBAR ICONS =====
local speedIcon = TopbarPlus.new()
    :setLabel("Speed")
    :setIcon("rbxassetid://76782366063523")
    :bindEvent("selected", function()
        toggleLoadstring("SpeedGui", "https://raw.githubusercontent.com/1ForeverHD/TopbarPlus/main/init.lua") -- replace with your actual loadstring URL
    end)

local suspensionIcon = TopbarPlus.new()
    :setLabel("Suspension")
    :setIcon("rbxassetid://76782366063523")
    :bindEvent("selected", function()
        toggleLoadstring("SuspensionGui", "https://raw.githubusercontent.com/1ForeverHD/TopbarPlus/main/init.lua") -- replace with your actual loadstring URL
    end)

-- ===== NOTIFICATION FUNCTION =====
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
