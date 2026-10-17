local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local SPOT = Vector3.new(1500, 3, 200)
local CAMERA_POS = SPOT + Vector3.new(0, 3, -16) -- front-facing shot
local LOOK_AT = SPOT + Vector3.new(0, 3, 0)

local gui = Instance.new("ScreenGui")
gui.Name = "PhotoSpotGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "PhotoButton"
button.Text = "📸 Photo mode"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(255, 111, 168)
button.BorderSizePixel = 0
button.Size = UDim2.fromScale(0.28, 0.07)
button.Position = UDim2.fromScale(0.5, 0.88)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Visible = false
button.Parent = gui
Instance.new("UICorner", button).CornerRadius = UDim.new(0.3, 0)

local exitButton = button:Clone()
exitButton.Name = "ExitButton"
exitButton.Text = "Exit"
exitButton.BackgroundColor3 = Color3.fromRGB(60, 50, 70)
exitButton.Position = UDim2.fromScale(0.5, 0.9)
exitButton.Visible = false
exitButton.Parent = gui

local inPhotoMode = false

local function enterPhotoMode()
	inPhotoMode = true
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.lookAt(CAMERA_POS, LOOK_AT)
	button.Visible = false
	exitButton.Visible = true
end

local function exitPhotoMode()
	inPhotoMode = false
	camera.CameraType = Enum.CameraType.Custom
	exitButton.Visible = false
end

button.MouseButton1Click:Connect(enterPhotoMode)
exitButton.MouseButton1Click:Connect(exitPhotoMode)

-- Show the button only when the player stands close to the spot
task.spawn(function()
	while true do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and not inPhotoMode then
			button.Visible = (root.Position - SPOT).Magnitude < 14
		end
		task.wait(0.4)
	end
end)