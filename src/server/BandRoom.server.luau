local Workspace = game:GetService("Workspace")

local ORIGIN = Vector3.new(400, 0, 200) -- band room sits away from the hangout room
local BAND_SPAWN = CFrame.new(ORIGIN + Vector3.new(0, 3, 10)) -- in front of the stage
local START_SPAWN = CFrame.new(-20, 3, 10) -- back on the start platform

local NAVY = Color3.fromRGB(12, 22, 50)
local BLUE = Color3.fromRGB(40, 90, 180)
local DARK = Color3.fromRGB(20, 40, 90)
local CYAN = Color3.fromRGB(120, 220, 255)
local SILVER = Color3.fromRGB(190, 200, 215)
local BLACK = Color3.fromRGB(25, 25, 30)
local WOOD = Color3.fromRGB(90, 60, 45)

local room = Instance.new("Model")
room.Name = "BandRoom"
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

-- Upright cylinder (drums, cymbals, base)
local function cyl(name, height, radius, pos, color, material)
	local p = part(name, Vector3.new(height, radius * 2, radius * 2), Vector3.new(0, 0, 0), color, material, Enum.PartType.Cylinder)
	p.CFrame = CFrame.new(ORIGIN + pos) * CFrame.Angles(0, 0, math.rad(90))
	return p
end

local function writeOn(target, face, text, color, font)
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
	t.Font = font or Enum.Font.GothamBold
	t.TextScaled = true
	t.TextWrapped = true
	t.TextColor3 = color
	t.Parent = g
end

-- Room shell
part("Floor", Vector3.new(40, 1, 40), Vector3.new(0, 0.5, 0), NAVY, Enum.Material.Fabric)
part("BackWall", Vector3.new(40, 14, 1), Vector3.new(0, 7, -20.5), BLUE)
part("LeftWall", Vector3.new(1, 14, 40), Vector3.new(-20.5, 7, 0), DARK)
part("RightWall", Vector3.new(1, 14, 40), Vector3.new(20.5, 7, 0), DARK)

-- Neon wall stripes (detail without extra parts)
part("StripeLow", Vector3.new(40, 0.3, 0.3), Vector3.new(0, 2, -19.85), CYAN, Enum.Material.Neon)
part("StripeHigh", Vector3.new(40, 0.3, 0.3), Vector3.new(0, 13, -19.85), CYAN, Enum.Material.Neon)

-- Stage: raised platform with neon front trim
part("Stage", Vector3.new(16, 2, 10), Vector3.new(0, 1, -4), DARK, Enum.Material.Wood)
part("StageTrim", Vector3.new(16.4, 0.2, 0.4), Vector3.new(0, 2.1, 1.2), CYAN, Enum.Material.Neon)

-- Microphone: base, pole, glowing silver head
cyl("MicBase", 0.2, 0.8, Vector3.new(0, 2.1, -3), BLACK, Enum.Material.Metal)
part("MicPole", Vector3.new(0.3, 3.5, 0.3), Vector3.new(0, 3.95, -3), SILVER, Enum.Material.Metal)
local micHead = part("MicHead", Vector3.new(0.9, 0.9, 0.9), Vector3.new(0, 5.8, -3), SILVER, Enum.Material.Metal, Enum.PartType.Ball)
local micLight = Instance.new("PointLight")
micLight.Color = CYAN
micLight.Brightness = 0.6
micLight.Range = 8
micLight.Parent = micHead

-- Drum kit (left side of stage)
cyl("Kick", 1.6, 1.2, Vector3.new(-5, 2.8, -6), BLACK, Enum.Material.Fabric)
cyl("Snare", 0.8, 0.8, Vector3.new(-3, 3.4, -7.5), SILVER, Enum.Material.Metal)
part("CymbalPole", Vector3.new(0.2, 3, 0.2), Vector3.new(-6.5, 3.5, -7.5), SILVER, Enum.Material.Metal)
cyl("Cymbal", 0.1, 1.2, Vector3.new(-6.5, 5, -7.5), SILVER, Enum.Material.Metal)
cyl("DrumStool", 1, 0.6, Vector3.new(-5, 2.5, -2.5), BLACK, Enum.Material.Fabric)

-- Amps with neon panels
part("AmpLeft", Vector3.new(4, 3, 2), Vector3.new(-11, 3.5, -6), BLACK)
part("AmpLeftPanel", Vector3.new(3, 2, 0.2), Vector3.new(-11, 3.5, -4.9), CYAN, Enum.Material.Neon)
part("AmpRight", Vector3.new(4, 3, 2), Vector3.new(11, 3.5, -6), BLACK)
part("AmpRightPanel", Vector3.new(3, 2, 0.2), Vector3.new(11, 3.5, -4.9), CYAN, Enum.Material.Neon)

-- Speakers at the back corners of the stage
part("SpeakerLeft", Vector3.new(2.5, 5, 2.5), Vector3.new(-8, 4.5, -8), BLACK)
part("SpeakerRight", Vector3.new(2.5, 5, 2.5), Vector3.new(8, 4.5, -8), BLACK)

-- Audience stools in front of the stage
for i, x in ipairs({ -6, -2, 2, 6 }) do
	cyl("Stool" .. i, 1.5, 1, Vector3.new(x, 1.75, 8), DARK, Enum.Material.Fabric)
end

-- Ceiling stage lights (3 point lights keeps it light for phones)
for i, x in ipairs({ -8, 0, 8 }) do
	local bulb = part("StageLight" .. i, Vector3.new(1.5, 1.5, 1.5), Vector3.new(x, 13, -4), CYAN, Enum.Material.Neon, Enum.PartType.Ball)
	local pl = Instance.new("PointLight")
	pl.Color = Color3.fromRGB(150, 210, 255)
	pl.Brightness = 2
	pl.Range = 30
	pl.Parent = bulb
end

-- Sign on the back wall (text faces the room)
local sign = part("BandSign", Vector3.new(18, 4, 0.4), Vector3.new(0, 9.5, -19.7), NAVY, Enum.Material.Neon)
writeOn(sign, Enum.NormalId.Back, "Band Practice 🎤", CYAN)

-- Way back to the start
local returnPad = part("ReturnPad", Vector3.new(8, 0.2, 8), Vector3.new(-14, 1.1, 14), CYAN, Enum.Material.Neon)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = START_SPAWN end
end)

-- Entry pad on the start platform (outside the room, so it's not part of the model)
local entryPad = Instance.new("Part")
entryPad.Name = "BandPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = Vector3.new(-20, 0.6, 20)
entryPad.Anchored = true
entryPad.Color = BLUE
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace
entryPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = BAND_SPAWN end
end)