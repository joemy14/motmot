local Workspace = game:GetService("Workspace")

local ORIGIN = Vector3.new(1800, 0, 200)
local PAD_POS = Vector3.new(0, 1, 20)
local RETURN_CF = CFrame.new(-20, 3, -14)

local PINK = Color3.fromRGB(255, 150, 190)
local PINK_DARK = Color3.fromRGB(230, 110, 160)
local CREAM = Color3.fromRGB(255, 240, 225)
local WHITE = Color3.fromRGB(250, 250, 250)
local CHARCOAL = Color3.fromRGB(40, 35, 45)

-- Clear old copies so there is only one of each
local oldBooth = Workspace:FindFirstChild("PhotoBooth")
if oldBooth then oldBooth:Destroy() end
local cozy = Workspace:FindFirstChild("HangoutRoom")
if cozy then cozy:Destroy() end
for _, c in ipairs(Workspace:GetChildren()) do
	if c:IsA("BasePart") and (c.Name == "PhotoPad" or c.Name == "RoomPad" or c.Name == "BoothPad") then
		c:Destroy()
	end
end

local booth = Instance.new("Model")
booth.Name = "PhotoBooth"
booth.Parent = Workspace

local function part(name, size, pos, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = ORIGIN + pos
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.Parent = booth
	return p
end

-- Room (floor top is at y = 1)
part("Floor", Vector3.new(30, 1, 30), Vector3.new(0, 0.5, 0), CREAM, Enum.Material.Marble)
part("BackWall", Vector3.new(30, 14, 1), Vector3.new(0, 7, -15.5), PINK)
part("LeftWall", Vector3.new(1, 14, 30), Vector3.new(-15.5, 7, 0), PINK_DARK)
part("RightWall", Vector3.new(1, 14, 30), Vector3.new(15.5, 7, 0), PINK_DARK)

-- Ceiling lights
for i = -1, 1 do
	part("CeilingLight" .. i, Vector3.new(3, 0.3, 26), Vector3.new(i * 9, 13.8, 0), WHITE, Enum.Material.Neon)
end

-- Sign
local sign = part("Sign", Vector3.new(18, 3.5, 0.4), Vector3.new(0, 11.5, -14.7), CHARCOAL, Enum.Material.Neon)
local signGui = Instance.new("SurfaceGui")
signGui.Face = Enum.NormalId.Back
signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
signGui.PixelsPerStud = 40
signGui.Parent = sign
local signText = Instance.new("TextLabel")
signText.Size = UDim2.fromScale(0.92, 0.88)
signText.Position = UDim2.fromScale(0.5, 0.5)
signText.AnchorPoint = Vector2.new(0.5, 0.5)
signText.BackgroundTransparency = 1
signText.Text = "Photo Booth 📸"
signText.Font = Enum.Font.GothamBold
signText.TextScaled = true
signText.TextColor3 = Color3.fromRGB(255, 200, 225)
signText.Parent = signGui

-- Mirror
part("MirrorFrame", Vector3.new(10.6, 8.6, 0.4), Vector3.new(0, 5.5, -14.8), WHITE, Enum.Material.Metal)
local mirror = part("Mirror", Vector3.new(10, 8, 0.2), Vector3.new(0, 5.5, -14.4), Color3.fromRGB(200, 230, 240), Enum.Material.Glass)
mirror.Reflectance = 0.6

-- Floor mark where you stand
local mark = part("StandMark", Vector3.new(4, 0.1, 4), Vector3.new(0, 1.05, -2), PINK, Enum.Material.Neon)
mark.Transparency = 0.5

-- Wall where the photo strip appears (the client script draws on this)
part("StripWall", Vector3.new(0.4, 12, 9), Vector3.new(14.8, 7, 0), WHITE)

-- Way back to the start
local returnPad = part("ReturnPad", Vector3.new(6, 0.2, 6), Vector3.new(-11, 1.1, 11), PINK, Enum.Material.Neon)
local busyReturn = false
returnPad.Touched:Connect(function(hit)
	if busyReturn then return end
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if not root then return end
	busyReturn = true
	root.CFrame = RETURN_CF
	task.wait(1)
	busyReturn = false
end)

-- Entry pad on the start platform (outside the booth model)
local entryPad = Instance.new("Part")
entryPad.Name = "BoothPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = PAD_POS
entryPad.Anchored = true
entryPad.Color = PINK
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace

local busyEntry = false
entryPad.Touched:Connect(function(hit)
	if busyEntry then return end
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if not root then return end
	busyEntry = true
	root.CFrame = CFrame.new(ORIGIN + Vector3.new(0, 4, 0))
	task.wait(1)
	busyEntry = false
end)

print("PhotoBooth built")