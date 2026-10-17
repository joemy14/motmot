local Workspace = game:GetService("Workspace")

local ORIGIN = Vector3.new(1500, 0, 200)
local ENTRY_CF = CFrame.new(ORIGIN + Vector3.new(0, 3, 12))
local RETURN_CF = CFrame.new(-20, 3, -14)

local PINK = Color3.fromRGB(255, 150, 190)
local PINK_DARK = Color3.fromRGB(230, 110, 160)
local WHITE = Color3.fromRGB(250, 250, 250)
local GREEN = Color3.fromRGB(120, 200, 110)
local CREAM = Color3.fromRGB(255, 240, 225)
local CHARCOAL = Color3.fromRGB(40, 35, 45)

local room = Instance.new("Model")
room.Name = "PhotoSpot"
room.Parent = Workspace

local function part(name, size, pos, color, material, shape)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = ORIGIN + pos
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = room
	return p
end

local function writeOn(target, face, text, color)
	local g = Instance.new("SurfaceGui")
	g.Face = face
	g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	g.PixelsPerStud = 40
	g.Parent = target
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(0.92, 0.88)
	t.Position = UDim2.fromScale(0.5, 0.5)
	t.AnchorPoint = Vector2.new(0.5, 0.5)
	t.BackgroundTransparency = 1
	t.Text = text
	t.Font = Enum.Font.GothamBold
	t.TextScaled = true
	t.TextWrapped = true
	t.TextColor3 = color
	t.Parent = g
end

-- Backdrop
part("Floor", Vector3.new(30, 1, 30), Vector3.new(0, 0.5, 0), CREAM, Enum.Material.Marble)
part("BackWall", Vector3.new(30, 14, 1), Vector3.new(0, 7, -15.5), PINK)
part("LeftWall", Vector3.new(1, 14, 30), Vector3.new(-15.5, 7, 0), PINK_DARK)
part("RightWall", Vector3.new(1, 14, 30), Vector3.new(15.5, 7, 0), PINK_DARK)

-- Sign
local sign = part("Sign", Vector3.new(16, 3.5, 0.4), Vector3.new(0, 11, -15), CHARCOAL, Enum.Material.Neon)
writeOn(sign, Enum.NormalId.Back, "Our Photo Spot 📸", Color3.fromRGB(255, 200, 225))

-- Shelf with two plush bunnies
part("Shelf", Vector3.new(8, 0.5, 2), Vector3.new(0, 6, -14), CREAM, Enum.Material.Wood)
for i, x in ipairs({ -2, 2 }) do
	part("Bunny" .. i, Vector3.new(1.8, 1.8, 1.8), Vector3.new(x, 7.4, -14), WHITE, Enum.Material.Fabric, Enum.PartType.Ball)
	part("EarL" .. i, Vector3.new(0.6, 1.2, 0.6), Vector3.new(x - 0.4, 8.7, -14), WHITE, Enum.Material.Fabric)
	part("EarR" .. i, Vector3.new(0.6, 1.2, 0.6), Vector3.new(x + 0.4, 8.7, -14), WHITE, Enum.Material.Fabric)
end

-- Photo mark on the floor (the camera waits here)
local mark = part("PhotoMark", Vector3.new(6, 0.1, 6), Vector3.new(0, 1.1, 0), PINK, Enum.Material.Neon)
mark.Transparency = 0.4

-- Entry pad on the start platform
local entryPad = Instance.new("Part")
entryPad.Name = "PhotoPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = Vector3.new(-20, 0.6, -20)
entryPad.Anchored = true
entryPad.Color = PINK
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace
entryPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = ENTRY_CF end
end)

-- Way back to the start
local returnPad = part("ReturnPad", Vector3.new(8, 0.2, 8), Vector3.new(12, 1.1, 14), PINK, Enum.Material.Neon)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = RETURN_CF end
end)