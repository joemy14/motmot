local Workspace = game:GetService("Workspace")

local ORIGIN = Vector3.new(200, 0, 200)
local START_RETURN = CFrame.new(0, 3, -10) -- on the start platform, away from the start pad
local MESSAGE = [[Hai bubba! Happy 5th hehee hayss time flies so fast jud when I'm with you, it's been 5 months alreadyyy. our last monthsary is a great surprise to us, kay both busy and random things na lang nahitabo😭. I can't wait kung ano napud kaya ang surprise this time hehe to many more surprising monthsary with youu mwaaa I love you so muchhh hehe happy motmottt🫶🫶🤟🤟]]

local WALL = Color3.fromRGB(255, 225, 235)
local WOOD = Color3.fromRGB(160, 110, 80)
local PINK = Color3.fromRGB(255, 111, 168)
local PURPLE = Color3.fromRGB(150, 100, 200)
local GREEN = Color3.fromRGB(110, 190, 120)

local room = Instance.new("Model")
room.Name = "HangoutRoom"
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

-- Writes text onto a face of a part
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
part("Floor", Vector3.new(40, 1, 40), Vector3.new(0, 0.5, 0), Color3.fromRGB(230, 190, 160), Enum.Material.Wood)
part("BackWall", Vector3.new(40, 14, 1), Vector3.new(0, 7, -20.5), WALL)
part("LeftWall", Vector3.new(1, 14, 40), Vector3.new(-20.5, 7, 0), WALL)
part("RightWall", Vector3.new(1, 14, 40), Vector3.new(20.5, 7, 0), WALL)

-- Window on the left wall
part("WindowFrame", Vector3.new(0.3, 7, 9), Vector3.new(-19.95, 8, 4), WOOD, Enum.Material.Wood)
part("Window", Vector3.new(0.2, 6, 8), Vector3.new(-19.9, 8, 4), Color3.fromRGB(150, 220, 255), Enum.Material.Neon)

-- Furniture
part("Rug", Vector3.new(14, 0.2, 10), Vector3.new(0, 1.1, 0), PINK, Enum.Material.Fabric)
part("Bed", Vector3.new(10, 2, 14), Vector3.new(-10, 2, -12), PURPLE, Enum.Material.Fabric)
part("BedHeadboard", Vector3.new(10, 5, 1), Vector3.new(-10, 3.5, -19), PURPLE, Enum.Material.Wood)
part("Couch", Vector3.new(12, 3, 4), Vector3.new(8, 2.5, -15), Color3.fromRGB(255, 200, 120), Enum.Material.Fabric)
part("CoffeeTable", Vector3.new(5, 1, 5), Vector3.new(0, 2, 0), WOOD, Enum.Material.Wood)
part("Bookshelf", Vector3.new(2, 7, 8), Vector3.new(18.5, 4.5, -10), WOOD, Enum.Material.Wood)

-- Couch hearts (pillows)
part("PillowA", Vector3.new(1.5, 1.5, 1.5), Vector3.new(5, 4.75, -15), PINK, Enum.Material.Fabric, Enum.PartType.Ball)
part("PillowB", Vector3.new(1.5, 1.5, 1.5), Vector3.new(11, 4.75, -15), PINK, Enum.Material.Fabric, Enum.PartType.Ball)

-- Plant in the corner
part("Pot", Vector3.new(2, 2, 2), Vector3.new(16, 2, 16), WOOD, Enum.Material.Wood)
part("Leaves", Vector3.new(4, 4, 4), Vector3.new(16, 5.5, 16), GREEN, Enum.Material.Grass, Enum.PartType.Ball)

-- Warm lamp
local pole = part("LampPole", Vector3.new(1, 10, 1), Vector3.new(-16, 6, -16), Color3.fromRGB(90, 70, 110), Enum.Material.Metal)
part("LampShade", Vector3.new(4, 3, 4), Vector3.new(-16, 12, -16), Color3.fromRGB(255, 240, 200), Enum.Material.Neon, Enum.PartType.Ball)
local light = Instance.new("PointLight")
light.Color = Color3.fromRGB(255, 200, 150)
light.Brightness = 1.5
light.Range = 25
light.Parent = pole

-- String lights along the back wall
for i = 0, 4 do
	part("StringLight" .. i, Vector3.new(1, 1, 1), Vector3.new(-12 + i * 6, 13, -19.5),
		Color3.fromRGB(255, 240, 180), Enum.Material.Neon, Enum.PartType.Ball)
end

-- Sign on the back wall (text faces the room)
local sign = part("MessageSign", Vector3.new(18, 4, 0.4), Vector3.new(0, 9.5, -19.7),
	Color3.fromRGB(60, 30, 80), Enum.Material.Neon)
writeOn(sign, Enum.NormalId.Back, "Happy 5 Months, Avril 🫶", Color3.fromRGB(255, 180, 210))

-- Full message card on the left wall, under the window area
local card = part("MessageCard", Vector3.new(0.4, 7, 12), Vector3.new(-19.7, 8, -10),
	Color3.fromRGB(255, 240, 245), Enum.Material.SmoothPlastic)
writeOn(card, Enum.NormalId.Right, MESSAGE, Color3.fromRGB(90, 40, 70), Enum.Font.GothamMedium)

-- Way back to the start
local returnPad = part("ReturnPad", Vector3.new(8, 0.2, 8), Vector3.new(14, 1.1, 14), PINK, Enum.Material.Neon)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = START_RETURN
	end
end)