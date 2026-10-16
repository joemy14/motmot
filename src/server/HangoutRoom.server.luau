local Workspace = game:GetService("Workspace")

-- The room sits away from the main map so it's a private spot
local ORIGIN = Vector3.new(200, 0, 200)

local room = Instance.new("Model")
room.Name = "HangoutRoom"
room.Parent = Workspace

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
	p.Parent = room
	return p
end

-- Room shell (floor top is at y = 1)
part("Floor", Vector3.new(40, 1, 40), Vector3.new(0, 0.5, 0), Color3.fromRGB(230, 190, 160), Enum.Material.Wood)
part("BackWall", Vector3.new(40, 14, 1), Vector3.new(0, 7, -20.5), Color3.fromRGB(255, 225, 235))
part("LeftWall", Vector3.new(1, 14, 40), Vector3.new(-20.5, 7, 0), Color3.fromRGB(255, 225, 235))
part("RightWall", Vector3.new(1, 14, 40), Vector3.new(20.5, 7, 0), Color3.fromRGB(255, 225, 235))

-- Cozy furniture
part("Rug", Vector3.new(14, 0.2, 10), Vector3.new(0, 1.1, 0), Color3.fromRGB(255, 140, 180), Enum.Material.Fabric)
part("Bed", Vector3.new(10, 2, 14), Vector3.new(-10, 2, -12), Color3.fromRGB(200, 170, 255), Enum.Material.Fabric)
part("BedHeadboard", Vector3.new(10, 5, 1), Vector3.new(-10, 3.5, -19), Color3.fromRGB(150, 100, 200), Enum.Material.Wood)
part("Couch", Vector3.new(12, 3, 4), Vector3.new(8, 2.5, -15), Color3.fromRGB(255, 200, 120), Enum.Material.Fabric)
part("CoffeeTable", Vector3.new(5, 1, 5), Vector3.new(0, 2, 0), Color3.fromRGB(160, 110, 80), Enum.Material.Wood)

-- Lamp with a warm light
local pole = part("LampPole", Vector3.new(1, 10, 1), Vector3.new(-16, 6, -16), Color3.fromRGB(90, 70, 110), Enum.Material.Metal)
local shade = part("LampShade", Vector3.new(4, 3, 4), Vector3.new(-16, 12, -16), Color3.fromRGB(255, 240, 200), Enum.Material.Neon)
shade.Shape = Enum.PartType.Ball
local light = Instance.new("PointLight")
light.Color = Color3.fromRGB(255, 200, 150)
light.Brightness = 1.5
light.Range = 25
light.Parent = pole

-- Message sign on the back wall (read from the room)
local sign = part("MessageSign", Vector3.new(18, 5, 0.5), Vector3.new(0, 10, -19.2), Color3.fromRGB(60, 30, 80), Enum.Material.Neon)
local gui = Instance.new("SurfaceGui")
gui.Face = Enum.NormalId.Front
gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
gui.PixelsPerStud = 40
gui.Parent = sign

local text = Instance.new("TextLabel")
text.Size = UDim2.fromScale(1, 1)
text.BackgroundTransparency = 1
text.Text = "Happy 5 Months 🫶"
text.Font = Enum.Font.GothamBold
text.TextScaled = true
text.TextColor3 = Color3.fromRGB(255, 180, 210)
text.Parent = gui