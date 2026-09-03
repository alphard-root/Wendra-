local Settings = {
    Speed = 50
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Reset Character saat respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

local Flying = false
local BodyVelocity, BodyGyro

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGuiSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Tombol Fly Utama
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Parent = ScreenGui
FlyButton.Size = UDim2.new(0, 90, 0, 45)
FlyButton.Position = UDim2.new(0.8, 0, 0.2, 0)
FlyButton.Text = "FLY: OFF"
FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextScaled = true
FlyButton.Active = true

-- Tombol Buka Pengaturan Kecepatan
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = FlyButton
SettingsButton.Size = UDim2.new(0, 30, 0, 20)
SettingsButton.Position = UDim2.new(1, -30, 0, -25)
SettingsButton.Text = "⚙️"
SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.TextScaled = true

-- Frame Pengaturan Kecepatan
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Parent = FlyButton
SpeedFrame.Size = UDim2.new(0, 140, 0, 70)
SpeedFrame.Position = UDim2.new(0, 0, 1, 5)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedFrame.Visible = false

local SpeedInput = Instance.new("TextBox")
SpeedInput.Parent = SpeedFrame
SpeedInput.Size = UDim2.new(0, 120, 0, 30)
SpeedInput.Position = UDim2.new(0, 10, 0, 10)
SpeedInput.Text = tostring(Settings.Speed)
SpeedInput.PlaceholderText = "Masukkan Kecepatan"
SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextScaled = true

local ApplyButton = Instance.new("TextButton")
ApplyButton.Parent = SpeedFrame
ApplyButton.Size = UDim2.new(0, 120, 0, 20)
ApplyButton.Position = UDim2.new(0, 10, 0, 45)
ApplyButton.Text = "Simpan"
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.TextScaled = true

-- Fungsi Drag / Geser Tombol
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    FlyButton.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

FlyButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FlyButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FlyButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Fungsi Terbang
local flyConnection
local function StartFly()
    Flying = true
    FlyButton.Text = "FLY: ON"
    FlyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = RootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Parent = RootPart
    
    Humanoid.PlatformStand = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if not Flying then return end
        local Camera = workspace.CurrentCamera
        BodyVelocity.Velocity = Camera.CFrame.LookVector * Settings.Speed
        BodyGyro.CFrame = Camera.CFrame
    end)
end

local function StopFly()
    Flying = false
    FlyButton.Text = "FLY: OFF"
    FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    if Humanoid then Humanoid.PlatformStand = false end
    if flyConnection then flyConnection:Disconnect() end
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
end

-- Event Listener UI
FlyButton.MouseButton1Click:Connect(function()
    if Flying then StopFly() else StartFly() end
end)

SettingsButton.MouseButton1Click:Connect(function()
    SpeedFrame.Visible = not SpeedFrame.Visible
end)

ApplyButton.MouseButton1Click:Connect(function()
    local newSpeed = tonumber(SpeedInput.Text)
    if newSpeed then
        Settings.Speed = newSpeed
        SpeedFrame.Visible = false
    end
end)