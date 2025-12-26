local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecutorGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 9999
screenGui.Parent = playerGui

-- Colors (very dark, no grey)
local bgColor = Color3.fromRGB(10, 10, 15)
local titleBarColor = Color3.fromRGB(20, 20, 25)
local textboxColor = Color3.fromRGB(15, 15, 20)
local accentColor = Color3.fromRGB(0, 170, 255)
local textColor = Color3.fromRGB(235, 235, 235)
local placeholderColor = Color3.fromRGB(120, 120, 130)

-- Loading (black and visible)
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 320, 0, 100)
loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -50)
loadingFrame.BackgroundColor3 = bgColor
loadingFrame.BackgroundTransparency = 0  -- solid black
loadingFrame.Visible = true
loadingFrame.Parent = screenGui
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 14)

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Scanning For Backdoor..."
loadingText.TextColor3 = textColor
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 24
loadingText.TextTransparency = 0
loadingText.Parent = loadingFrame

-- Main GUI (hidden during loading)
local gui = Instance.new("Frame")
gui.Size = UDim2.new(0, 520, 0, 420)
gui.Position = UDim2.new(0.5, -260, 0.5, -210)
gui.BackgroundColor3 = bgColor
gui.BackgroundTransparency = 0  -- solid black when shown
gui.Visible = false  -- hidden
gui.Parent = screenGui
Instance.new("UICorner", gui).CornerRadius = UDim.new(0, 14)

-- Title Bar
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 44)
title.BackgroundColor3 = titleBarColor
title.Parent = gui
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 14)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Polaris"
titleLabel.TextColor3 = textColor
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = title

-- Drag
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = gui.Position
    end
end)

title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 34, 0, 34)
minBtn.Position = UDim2.new(1, -44, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
minBtn.Text = "-"
minBtn.TextColor3 = textColor
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.Parent = title
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

local minimized = false
local originalSize = gui.Size

-- Content children
local contentChildren = {}

-- Greeting
local hello = Instance.new("TextLabel")
hello.Size = UDim2.new(1, -40, 0, 30)
hello.Position = UDim2.new(0, 20, 0, 50)
hello.BackgroundTransparency = 1
hello.Text = "Hello, " .. player.Name .. "!"
hello.TextColor3 = textColor
hello.Font = Enum.Font.GothamSemibold
hello.TextSize = 22
hello.TextXAlignment = Enum.TextXAlignment.Left
hello.Parent = gui
table.insert(contentChildren, hello)

-- Code Box (solid dark, no tween on background)
local codeBox = Instance.new("ScrollingFrame")
codeBox.Size = UDim2.new(1, -40, 0, 230)
codeBox.Position = UDim2.new(0, 20, 0, 90)
codeBox.BackgroundColor3 = textboxColor
codeBox.BackgroundTransparency = 0  -- solid
codeBox.BorderSizePixel = 0
codeBox.ScrollBarThickness = 6
codeBox.Parent = gui
Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 10)
table.insert(contentChildren, codeBox)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 1, -20)
input.Position = UDim2.new(0, 10, 0, 10)
input.BackgroundTransparency = 1
input.Text = "Enter your script here..."
input.TextColor3 = placeholderColor
input.Font = Enum.Font.SourceSans
input.TextSize = 17
input.MultiLine = true
input.TextXAlignment = Enum.TextXAlignment.Left
input.TextYAlignment = Enum.TextYAlignment.Top
input.TextWrapped = true
input.ClearTextOnFocus = false
input.Parent = codeBox

local ph = "Enter your script here..."
input.Focused:Connect(function()
    if input.Text == ph then input.Text = "" input.TextColor3 = textColor end
end)
input.FocusLost:Connect(function()
    if input.Text == "" then input.Text = ph input.TextColor3 = placeholderColor end
end)

-- Execute Button
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(0, 150, 0, 44)
exec.Position = UDim2.new(0.5, -75, 0, 330)
exec.BackgroundColor3 = accentColor
exec.Text = "Execute"
exec.TextColor3 = Color3.new(1,1,1)
exec.Font = Enum.Font.GothamBold
exec.TextSize = 19
exec.Parent = gui
Instance.new("UICorner", exec).CornerRadius = UDim.new(0, 12)
table.insert(contentChildren, exec)

-- Description
local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -40, 0, 40)
desc.Position = UDim2.new(0, 20, 0, 380)
desc.BackgroundTransparency = 1
desc.Text = "this is a serverside roblox executor. any scripts sent to the client will be replicated to the server."
desc.TextColor3 = Color3.fromRGB(170, 170, 180)
desc.Font = Enum.Font.Gotham
desc.TextSize = 14
desc.TextWrapped = true
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = gui
table.insert(contentChildren, desc)

-- Execute
exec.MouseButton1Click:Connect(function()
    local code = input.Text
    if code ~= "" and code ~= ph then
        loadstring(code)()
    end
end)

-- Notification (starts invisible)
local notif = Instance.new("Frame")
notif.Size = UDim2.new(0, 300, 0, 80)
notif.Position = UDim2.new(1, 20, 0, 20)
notif.BackgroundColor3 = titleBarColor
notif.BackgroundTransparency = 1
notif.Visible = false
notif.Parent = screenGui
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 12)

local notifTxt = Instance.new("TextLabel")
notifTxt.Size = UDim2.new(1, -30, 1, -20)
notifTxt.Position = UDim2.new(0, 15, 0, 10)
notifTxt.BackgroundTransparency = 1
notifTxt.Text = "Backdoor Found!"
notifTxt.TextColor3 = textColor
notifTxt.Font = Enum.Font.GothamSemibold
notifTxt.TextSize = 16
notifTxt.TextWrapped = true
notifTxt.TextTransparency = 1
notifTxt.Parent = notif

-- Animations
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Loading (text fade)
TweenService:Create(loadingText, tweenInfo, {TextTransparency = 0}):Play()

wait(4)

-- Loading fade out
TweenService:Create(loadingText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
task.wait(0.4)
loadingFrame.Visible = false

-- Main GUI appear (fade text only)
gui.Visible = true
for _, obj in pairs(gui:GetDescendants()) do
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        TweenService:Create(obj, tweenInfo, {TextTransparency = 0}):Play()
    end
end

-- Notification
notif.Visible = true
TweenService:Create(notif, tweenInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(notifTxt, tweenInfo, {TextTransparency = 0}):Play()
TweenService:Create(notif, tweenInfo, {Position = UDim2.new(1, -320, 0, 20)}):Play()
task.wait(2)
TweenService:Create(notif, tweenInfo, {Position = UDim2.new(1, 20, 0, 20)}):Play()
task.wait(0.6)
notif.Visible = false

-- Minimize / Unminimize
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(gui, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 520, 0, 44)}):Play()
        for _, child in ipairs(contentChildren) do
            child.Visible = false
        end
        minBtn.Text = "+"
    else
        TweenService:Create(gui, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = originalSize}):Play()
        task.delay(0.3, function()
            for _, child in ipairs(contentChildren) do
                child.Visible = true
            end
        end)
        minBtn.Text = "-"
    end
end)