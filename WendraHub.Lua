-- ============================================
-- WENDRA HUB - LocalScript
-- Taruh di StarterPlayer > StarterPlayerScripts
-- ============================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ============ GUI DASAR ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WendraHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(40, 130, 255)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Header / judul
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "WENDRA"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(100, 170, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -60, 0, 15)
statusDot.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
statusDot.Parent = mainFrame
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- Tombol close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ============ TAB KATEGORI ============
local tabs = {"Move", "Settings", "Misc"}
local tabButtons = {}
local contentFrames = {}

local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(0, 90, 1, -50)
tabHolder.Position = UDim2.new(1, -90, 0, 45)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, (i-1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.Text = tabName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.Parent = tabHolder
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    tabButtons[tabName] = btn

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -110, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 45)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    contentFrames[tabName] = content
end

local function selectTab(name)
    for tabName, btn in pairs(tabButtons) do
        local isSelected = (tabName == name)
        btn.BackgroundColor3 = isSelected and Color3.fromRGB(40, 130, 255) or Color3.fromRGB(25, 25, 32)
        btn.TextColor3 = isSelected and Color3.new(1,1,1) or Color3.fromRGB(180, 180, 190)
        contentFrames[tabName].Visible = isSelected
    end
end

for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() selectTab(tabName) end)
end
selectTab("Move")

-- ============ HELPER: TOGGLE ROW ============
local function makeToggle(parent, index, label, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 35)
    row.Position = UDim2.new(0, 0, 0, (index-1) * 40)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 8)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 20)
    toggleBtn.Position = UDim2.new(1, -46, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleBtn.Text = ""
    toggleBtn.Parent = row
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggleBtn

    local on = false
    toggleBtn.MouseButton1Click:Connect(function()
        on = not on
        toggleBtn.BackgroundColor3 = on and Color3.fromRGB(40, 130, 255) or Color3.fromRGB(60, 60, 70)
        if callback then callback(on) end
    end)

    return function() return on end
end

-- ============ FLY SYSTEM ============
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro
local moveInput = {W=false, S=false, A=false, D=false, Up=false, Down=false}

local function startFly()
    if flying then return end
    flying = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.Parent = rootPart

    humanoid.PlatformStand = false
end

local function stopFly()
    if not flying then return end
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local camera = workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if moveInput.W then dir += camera.CFrame.LookVector end
        if moveInput.S then dir -= camera.CFrame.LookVector end
        if moveInput.A then dir -= camera.CFrame.RightVector end
        if moveInput.D then dir += camera.CFrame.RightVector end
        if moveInput.Up then dir += Vector3.new(0,1,0) end
        if moveInput.Down then dir -= Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit * flySpeed end
        bodyVelocity.Velocity = dir
        bodyGyro.CFrame = camera.CFrame
    end
end)

-- ============ INFINITY JUMP ============
local infJumpEnabled = false

UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ============ INPUT KEYBOARD (PC) ============
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    elseif input.KeyCode == Enum.KeyCode.W then moveInput.W = true
    elseif input.KeyCode == Enum.KeyCode.S then moveInput.S = true
    elseif input.KeyCode == Enum.KeyCode.A then moveInput.A = true
    elseif input.KeyCode == Enum.KeyCode.D then moveInput.D = true
    elseif input.KeyCode == Enum.KeyCode.Space then moveInput.Up = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then moveInput.Down = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then moveInput.W = false
    elseif input.KeyCode == Enum.KeyCode.S then moveInput.S = false
    elseif input.KeyCode == Enum.KeyCode.A then moveInput.A = false
    elseif input.KeyCode == Enum.KeyCode.D then moveInput.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then moveInput.Up = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then moveInput.Down = false
    end
end)

-- ============ ISI TAB MOVE ============
makeToggle(contentFrames["Move"], 1, "Sprint boost", function(on)
    humanoid.WalkSpeed = on and 32 or 16
end)
makeToggle(contentFrames["Move"], 2, "Jump boost", function(on)
    humanoid.JumpPower = on and 80 or 50
end)
makeToggle(contentFrames["Move"], 3, "Fly", function(on)
    if on then startFly() else stopFly() end
end)
makeToggle(contentFrames["Move"], 4, "Infinity jump", function(on)
    infJumpEnabled = on
end)

-- ============ ISI TAB SETTINGS ============
makeToggle(contentFrames["Settings"], 1, "Background music", function(on) end)
makeToggle(contentFrames["Settings"], 2, "Camera shake", function(on) end)

-- ============ ISI TAB MISC ============
makeToggle(contentFrames["Misc"], 1, "Auto-run", function(on) end)
