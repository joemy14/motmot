local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local BOOTH = Vector3.new(1800, 0, 200)
local SPOT = BOOTH + Vector3.new(0, 3, -2)
local CAM = BOOTH + Vector3.new(0, 4.5, 9)
local SHOT_COUNT = 4
local COUNTDOWN = 3
local PINK = Color3.fromRGB(255, 111, 168)
local CREAM = Color3.fromRGB(255, 240, 246)
local FRAME_BG = Color3.fromRGB(255, 215, 230)

local gui = Instance.new("ScreenGui")
gui.Name = "PhotoBoothGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Text = "📸 Start photo booth"
startButton.Font = Enum.Font.GothamBold
startButton.TextScaled = true
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BackgroundColor3 = PINK
startButton.BorderSizePixel = 0
startButton.Size = UDim2.fromScale(0.34, 0.06)
startButton.AnchorPoint = Vector2.new(0.5, 0.5)
startButton.Position = UDim2.fromScale(0.5, 0.6)
startButton.Visible = false
startButton.Parent = gui
Instance.new("UICorner", startButton).CornerRadius = UDim.new(0.3, 0)

local countLabel = Instance.new("TextLabel")
countLabel.Name = "Countdown"
countLabel.Size = UDim2.fromScale(0.5, 0.2)
countLabel.AnchorPoint = Vector2.new(0.5, 0.5)
countLabel.Position = UDim2.fromScale(0.5, 0.4)
countLabel.BackgroundTransparency = 1
countLabel.Font = Enum.Font.GothamBlack
countLabel.TextScaled = true
countLabel.TextColor3 = Color3.new(1, 1, 1)
countLabel.TextStrokeTransparency = 0
countLabel.Text = ""
countLabel.Parent = gui

local running = false
local shots = {}

local function flash()
	local f = Instance.new("Frame")
	f.Size = UDim2.fromScale(1, 1)
	f.BackgroundColor3 = Color3.new(1, 1, 1)
	f.BorderSizePixel = 0
	f.ZIndex = 10
	f.Parent = gui
	TweenService:Create(f, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
	task.delay(0.6, function() f:Destroy() end)
end

-- Copies the character with its current pose. Returns nil if it fails.
local function snapshot(character)
	character.Archivable = true
	local ok, clone = pcall(function() return character:Clone() end)
	if not ok or not clone then
		warn("PhotoBooth: could not copy character", clone)
		return nil
	end
	for _, d in ipairs(clone:GetDescendants()) do
		if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Animator") or d:IsA("Animation") or d:IsA("Sound") then
			d:Destroy()
		elseif d:IsA("BasePart") then
			d.Anchored = true
			d.CanCollide = false
		end
	end
	return clone
end

-- Puts one snapshot in a bright, close-up preview
local function fillViewport(vp, model)
	local cam = Instance.new("Camera")
	-- Closer and a little higher, so the character fills the frame
	cam.CFrame = CFrame.lookAt(Vector3.new(0, 3.6, -5.5), Vector3.new(0, 3.2, 0))
	cam.Parent = vp
	vp.CurrentCamera = cam

	local copy = model:Clone()
	copy.Parent = vp
	copy:PivotTo(CFrame.new(0, 3, 0))
end

-- Vertical strip of small landscape photos on a light background
local function buildStrip(parent, list)
	local strip = Instance.new("Frame")
	strip.Size = UDim2.fromScale(1, 1)
	strip.BackgroundColor3 = CREAM
	strip.BorderSizePixel = 0
	strip.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0.025, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = strip

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0.03, 0)
	pad.PaddingBottom = UDim.new(0.03, 0)
	pad.Parent = strip

	for i, shot in ipairs(list) do
		local vp = Instance.new("ViewportFrame")
		vp.LayoutOrder = i
		-- Small landscape rectangle, not a tall one
		vp.Size = UDim2.new(0.7, 0, 0.21, 0)
		vp.BackgroundColor3 = FRAME_BG
		vp.BackgroundTransparency = 0
		vp.Ambient = Color3.new(1, 1, 1)
		vp.LightColor = Color3.new(1, 1, 1)
		vp.LightDirection = Vector3.new(-0.3, -1, -0.5)
		vp.Parent = strip

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0.08, 0)
		corner.Parent = vp

		pcall(fillViewport, vp, shot)
	end
	return strip
end

local function updateWall()
	local booth = Workspace:FindFirstChild("PhotoBooth")
	local wall = booth and booth:FindFirstChild("StripWall")
	if not wall then
		warn("PhotoBooth: StripWall not found")
		return
	end

	local sg = wall:FindFirstChild("StripGui")
	if not sg then
		sg = Instance.new("SurfaceGui")
		sg.Name = "StripGui"
		sg.Face = Enum.NormalId.Left
		sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		sg.PixelsPerStud = 50
		sg.LightInfluence = 0 -- keeps the strip bright, not shaded
		sg.Parent = wall
	end

	-- Clear the old strip, then draw the new one
	for _, child in ipairs(sg:GetChildren()) do
		child:Destroy()
	end
	sg.Enabled = true
	buildStrip(sg, shots)
end

local function showStripOverlay(onDone)
	local overlay = Instance.new("Frame")
	overlay.Name = "StripOverlay"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.new(0, 0, 0)
	overlay.BackgroundTransparency = 0.35
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 5
	overlay.Parent = gui

	local holder = Instance.new("Frame")
	holder.Size = UDim2.fromScale(0.26, 0.82)
	holder.AnchorPoint = Vector2.new(0.5, 0.5)
	holder.Position = UDim2.fromScale(0.5, 0.47)
	holder.BackgroundTransparency = 1
	holder.Parent = overlay
	buildStrip(holder, shots)

	local done = Instance.new("TextButton")
	done.Name = "Done"
	done.Text = "Done"
	done.Font = Enum.Font.GothamBold
	done.TextScaled = true
	done.TextColor3 = Color3.new(1, 1, 1)
	done.BackgroundColor3 = PINK
	done.BorderSizePixel = 0
	done.Size = UDim2.fromScale(0.16, 0.06)
	done.AnchorPoint = Vector2.new(0.5, 0.5)
	done.Position = UDim2.fromScale(0.85, 0.08)
	done.Parent = overlay
	Instance.new("UICorner", done).CornerRadius = UDim.new(0.3, 0)

	done.MouseButton1Click:Connect(function()
		overlay:Destroy()
		onDone()
	end)
end

local function runSession()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not (root and humanoid) then return end

	running = true
	startButton.Visible = false
	for _, s in ipairs(shots) do s:Destroy() end
	shots = {}

	local oldWalk, oldJump = humanoid.WalkSpeed, humanoid.JumpPower
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.lookAt(CAM, SPOT + Vector3.new(0, 1.5, 0))

	local ok, err = pcall(function()
		for i = 1, SHOT_COUNT do
			for n = COUNTDOWN, 1, -1 do
				countLabel.Text = string.format("Photo %d/%d\n%d", i, SHOT_COUNT, n)
				task.wait(1)
			end
			countLabel.Text = "📸"
			flash()
			local copy = snapshot(character)
			if copy then table.insert(shots, copy) end
			task.wait(0.4)
		end
	end)

	countLabel.Text = ""
	humanoid.WalkSpeed = oldWalk
	humanoid.JumpPower = oldJump
	camera.CameraType = Enum.CameraType.Custom

	if not ok then
		warn("PhotoBooth session error:", err)
	end

	updateWall()
	if #shots > 0 then
		showStripOverlay(function() running = false end)
	else
		countLabel.Text = "Photo failed. Try again."
		task.wait(2)
		countLabel.Text = ""
		running = false
	end
end

startButton.MouseButton1Click:Connect(function()
	task.spawn(runSession)
end)

task.spawn(function()
	while true do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and not running then
			startButton.Visible = (root.Position - SPOT).Magnitude < 8
		end
		task.wait(0.3)
	end
end)
