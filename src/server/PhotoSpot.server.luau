local Workspace = game:GetService("Workspace")

local ORIGIN = Vector3.new(1800, 0, 200)
local ENTRY_CF = CFrame.new(ORIGIN + Vector3.new(0, 3, 12))
local RETURN_CF = CFrame.new(-20, 3, -14)
local PAD_POS = Vector3.new(-20, 0.6, -20)

local PINK = Color3.fromRGB(255, 150, 190)
local PINK_DARK = Color3.fromRGB(230, 110, 160)
local CREAM = Color3.fromRGB(255, 240, 225)
local CHARCOAL = Color3.fromRGB(40, 35, 45)
local WHITE = Color3.fromRGB(250, 250, 250)
local MIRROR_TINT = Color3.fromRGB(200, 230, 240)

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
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = booth
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

-- Room
part("Floor", Vector3.new(30, 1, 30), Vector3.new(0, 0.5, 0), CREAM, Enum.Material.Marble)
part("BackWall", Vector3.new(30, 14, 1), Vector3.new(0, 7, -15.5), PINK)
part("LeftWall", Vector3.new(1, 14, 30), Vector3.new(-15.5, 7, 0), PINK_DARK)
part("RightWall", Vector3.new(1, 14, 30), Vector3.new(15.5, 7, 0), PINK_DARK)

-- Ceiling light strips
for i = -1, 1 do
	part("CeilingLight" .. i, Vector3.new(3, 0.3, 26), Vector3.new(i * 9, 13.8, 0), WHITE, Enum.Material.Neon)
end

-- Sign above the mirror
local sign = part("Sign", Vector3.new(18, 3.5, 0.4), Vector3.new(0, 11.5, -14.7), CHARCOAL, Enum.Material.Neon)
writeOn(sign, Enum.NormalId.Back, "Photo Booth 📸", Color3.fromRGB(255, 200, 225))
local signLight = Instance.new("PointLight")
signLight.Color = PINK
signLight.Brightness = 1
signLight.Range = 14
signLight.Parent = sign

-- Mirror: white frame, then a reflective glass panel
part("MirrorFrame", Vector3.new(10.6, 8.6, 0.4), Vector3.new(0, 5.5, -14.8), WHITE, Enum.Material.Metal)
local mirror = part("Mirror", Vector3.new(10, 8, 0.2), Vector3.new(0, 5.5, -14.4), MIRROR_TINT, Enum.Material.Glass)
mirror.Reflectance = 0.6

-- Floor mark where you stand
local mark = part("StandMark", Vector3.new(4, 0.1, 4), Vector3.new(0, 1.05, -2), PINK, Enum.Material.Neon)
mark.Transparency = 0.5

-- Wall where the 4-photo strip appears (the client draws it on this wall)
part("StripWall", Vector3.new(0.4, 12, 9), Vector3.new(14.8, 7, 0), WHITE, Enum.Material.SmoothPlastic)

-- Return pad inside the booth
local returnPad = part("ReturnPad", Vector3.new(6, 0.2, 6), Vector3.new(-11, 1.1, 11), PINK, Enum.Material.Neon)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = RETURN_CF end
end)

-- Entry pad on the start platform
local entryPad = Instance.new("Part")
entryPad.Name = "PhotoPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = PAD_POS
entryPad.Anchored = true
entryPad.Color = PINK
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace
entryPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = ENTRY_CF end
end)