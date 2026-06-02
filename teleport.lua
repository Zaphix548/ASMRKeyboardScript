-- Teleport GUI Script
-- Position 1: 2033, 545, -1631
-- Position 2: -74, 6, 34 (Treadmill)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local targetPosition = Vector3.new(2033, 545, -1631)
local treadmillPosition = Vector3.new(-74, 6, 34)
local autoEnabled = false
local autoConnection = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⟡ Teleporter"
TitleLabel.TextColor3 = Color3.fromRGB(180, 160, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.Parent = TitleBar

-- Dragging
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local function doTeleport(position)
    local character = LocalPlayer.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(position)
        end
    end
end

-- Teleport Button
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(1, -20, 0, 34)
TeleportBtn.Position = UDim2.new(0, 10, 0, 38)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 210)
TeleportBtn.Text = "Teleport"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.Font = Enum.Font.GothamSemibold
TeleportBtn.TextSize = 13
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = TeleportBtn

-- Treadmill Button (now matches Auto color scheme)
local TreadmillBtn = Instance.new("TextButton")
TreadmillBtn.Size = UDim2.new(1, -20, 0, 34)
TreadmillBtn.Position = UDim2.new(0, 10, 0, 78)
TreadmillBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
TreadmillBtn.Text = "TreadMill Teleporter"
TreadmillBtn.TextColor3 = Color3.fromRGB(160, 140, 220)
TreadmillBtn.Font = Enum.Font.GothamSemibold
TreadmillBtn.TextSize = 12
TreadmillBtn.BorderSizePixel = 0
TreadmillBtn.Parent = MainFrame

local TreadCorner = Instance.new("UICorner")
TreadCorner.CornerRadius = UDim.new(0, 6)
TreadCorner.Parent = TreadmillBtn

-- Auto Toggle Button
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(1, -20, 0, 30)
AutoBtn.Position = UDim2.new(0, 10, 0, 120)
AutoBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
AutoBtn.Text = "Auto: OFF"
AutoBtn.TextColor3 = Color3.fromRGB(160, 140, 220)
AutoBtn.Font = Enum.Font.GothamSemibold
AutoBtn.TextSize = 12
AutoBtn.BorderSizePixel = 0
AutoBtn.Parent = MainFrame

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 6)
AutoCorner.Parent = AutoBtn

TeleportBtn.MouseButton1Click:Connect(function()
    doTeleport(targetPosition)
end)

TreadmillBtn.MouseButton1Click:Connect(function()
    doTeleport(treadmillPosition)
end)

AutoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    if autoEnabled then
        AutoBtn.Text = "Auto: ON"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 150)
        AutoBtn.TextColor3 = Color3.fromRGB(200, 185, 255)
        autoConnection = RunService.Heartbeat:Connect(function()
            doTeleport(targetPosition)
        end)
    else
        AutoBtn.Text = "Auto: OFF"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        AutoBtn.TextColor3 = Color3.fromRGB(160, 140, 220)
        if autoConnection then
            autoConnection:Disconnect()
            autoConnection = nil
        end
    end
end)
