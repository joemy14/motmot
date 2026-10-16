
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MESSAGE = [[Hai bubba! Happy 5th hehee hayss time flies so fast jud when I'm with you, it's been 5 months alreadyyy. our last monthsary is a great surprise to us, kay both busy and random things na lang nahitabo😭. I can't wait kung ano napud kaya ang surprise this time hehe to many more surprising monthsary with youu mwaaa I love you so muchhh hehe happy motmottt🫶🫶🤟🤟]]

local gui = Instance.new("ScreenGui")
gui.Name = "MonthsaryMessageGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MessageFrame"
frame.Size = UDim2.fromScale(0.85, 0.65)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0.08, 0)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Happy 5th Monthsary! 🫶"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(200, 60, 110)
title.BackgroundTransparency = 1
title.Size = UDim2.fromScale(0.9, 0.12)
title.Position = UDim2.fromScale(0.5, 0.06)
title.AnchorPoint = Vector2.new(0.5, 0)
title.Parent = frame

local body = Instance.new("TextLabel")
body.Name = "Body"
body.Text = MESSAGE
body.Font = Enum.Font.GothamMedium
body.TextWrapped = true
body.TextScaled = true
body.TextColor3 = Color3.fromRGB(60, 30, 50)
body.BackgroundTransparency = 1
body.Size = UDim2.fromScale(0.86, 0.64)
body.Position = UDim2.fromScale(0.5, 0.2)
body.AnchorPoint = Vector2.new(0.5, 0)
body.Parent = frame
local bodySize = Instance.new("UITextSizeConstraint")
bodySize.MinTextSize = 12
bodySize.MaxTextSize = 22
bodySize.Parent = body

local button = Instance.new("TextButton")
button.Name = "ContinueButton"
button.Text = "Continue 💕"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(255, 110, 150)
button.BorderSizePixel = 0
button.Size = UDim2.fromScale(0.6, 0.12)
button.Position = UDim2.fromScale(0.5, 0.9)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0.3, 0)

button.MouseButton1Click:Connect(function()
	local t = TweenService:Create(frame, TweenInfo.new(0.3), { Size = UDim2.fromScale(0, 0) })
	t:Play()
	t.Completed:Wait()
	gui:Destroy()
end)
