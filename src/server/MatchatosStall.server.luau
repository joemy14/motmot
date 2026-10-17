local Workspace = game:GetService("Workspace")
local StarterPack = game:GetService("StarterPack")

local ORIGIN = Vector3.new(700, 0, 200)
local ENTRY_CF = CFrame.new(ORIGIN + Vector3.new(0, 3, 12))
local RETURN_CF = CFrame.new(0, 3, -10)

local MATCHA = Color3.fromRGB(140, 210, 95)
local MATCHA_FOAM = Color3.fromRGB(225, 245, 200)
local COFFEE = Color3.fromRGB(105, 65, 38)
local COFFEE_MILK = Color3.fromRGB(235, 215, 190)
local WOOD = Color3.fromRGB(150, 105, 70)
local WOOD_DARK = Color3.fromRGB(95, 62, 40)
local WHITE = Color3.fromRGB(245, 245, 245)
local GREEN = Color3.fromRGB(90, 170, 80)
local CHARCOAL = Color3.fromRGB(45, 45, 50)

local stall = Instance.new("Model")
stall.Name = "MatchatosStall"
stall.Parent = Workspace

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
	p.Parent = stall
	return p
end

-- Upright cylinder (cups on display)
local function cupAt(name, pos, color)
	local p = part(name, Vector3.new(1.8, 1, 1), pos, color, Enum.Material.SmoothPlastic)
	p.Shape = Enum.PartType.Cylinder
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

-- Ground and back wall
part("Ground", Vector3.new(40, 1, 40), Vector3.new(0, 0.5, 0), Color3.fromRGB(190, 185, 175), Enum.Material.Concrete)
part("BackWall", Vector3.new(30, 12, 1), Vector3.new(0, 6, -12), WOOD, Enum.Material.Wood)
for i = 0, 4 do
	part("Plank" .. i, Vector3.new(0.3, 11, 0.2), Vector3.new(-12 + i * 6, 6, -11.4), WOOD_DARK, Enum.Material.Wood)
end

-- Pillars
part("PillarLeft", Vector3.new(1, 12, 1), Vector3.new(-15, 6, -7), WOOD_DARK, Enum.Material.Wood)
part("PillarRight", Vector3.new(1, 12, 1), Vector3.new(15, 6, -7), WOOD_DARK, Enum.Material.Wood)

-- Counter with marble top
part("CounterBody", Vector3.new(16, 4, 4), Vector3.new(0, 2, -4), WOOD_DARK, Enum.Material.Wood)
part("CounterTop", Vector3.new(16.6, 0.4, 4.6), Vector3.new(0, 4.2, -4), WHITE, Enum.Material.Marble)

-- Striped awning (alternating green and white)
for i = 0, 5 do
	part("Awning" .. i, Vector3.new(5.4, 0.6, 9), Vector3.new(-12.5 + i * 5, 12, -3),
		i % 2 == 0 and GREEN or WHITE, Enum.Material.Fabric)
end
part("NeonStrip", Vector3.new(31, 0.3, 0.3), Vector3.new(0, 11.6, -7.4), Color3.fromRGB(180, 255, 120), Enum.Material.Neon)

-- Sign (text faces the customers)
local sign = part("Sign", Vector3.new(20, 4, 0.5), Vector3.new(0, 15.5, -4), WOOD_DARK, Enum.Material.Wood)
writeOn(sign, Enum.NormalId.Back, "Don Matchatos\nCebu's First 39 Pesos Matcha", Color3.fromRGB(230, 255, 200))
local signLight = Instance.new("PointLight")
signLight.Color = Color3.fromRGB(180, 255, 120)
signLight.Brightness = 1
signLight.Range = 14
signLight.Parent = sign

-- Menu board on two legs
part("MenuLegLeft", Vector3.new(0.4, 3, 0.4), Vector3.new(-11, 2.5, 6), WOOD_DARK, Enum.Material.Wood)
part("MenuLegRight", Vector3.new(0.4, 3, 0.4), Vector3.new(-7, 2.5, 6), WOOD_DARK, Enum.Material.Wood)
local board = part("MenuBoard", Vector3.new(7, 6, 0.4), Vector3.new(-9, 6, 6), CHARCOAL, Enum.Material.Wood)
writeOn(board, Enum.NormalId.Back, "MENU\nMatcha ........ 39\nBrown Coffee ..... 39", WHITE, Enum.Font.GothamMedium)

-- Display cups on the counter
cupAt("DisplayMatcha1", Vector3.new(-5, 5.3, -4), MATCHA)
cupAt("DisplayCoffee1", Vector3.new(-2, 5.3, -4), COFFEE)
cupAt("DisplayMatcha2", Vector3.new(1, 5.3, -4), MATCHA)
cupAt("DisplayCoffee2", Vector3.new(4, 5.3, -4), COFFEE)

-- Equippable cups (tools go in StarterPack, so each player gets them on spawn)
local function addPart(tool, handle, name, shape, size, dx, color, material, dz)
	local p = Instance.new("Part")
	p.Name = name
	p.Shape = shape
	p.Size = size
	p.Color = color
	p.Material = material
	p.CanCollide = false
	p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.CFrame = handle.CFrame * CFrame.new(dx, 0, dz or 0)
	p.Parent = tool

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = handle
	weld.Part1 = p
	weld.Parent = p
	return p
end

local function makeCup(toolName, liquidColor, topColor)
	local tool = Instance.new("Tool")
	tool.Name = toolName
	tool.RequiresHandle = true
	tool.CanBeDropped = false

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Shape = Enum.PartType.Cylinder
	handle.Size = Vector3.new(1.8, 1, 1)
	handle.CFrame = CFrame.Angles(0, 0, math.rad(90))
	handle.Color = WHITE
	handle.Transparency = 0.6
	handle.Material = Enum.Material.Glass
	handle.CanCollide = false
	handle.Parent = tool

	addPart(tool, handle, "Liquid", Enum.PartType.Cylinder, Vector3.new(1.0, 0.9, 0.9), -0.4, liquidColor, Enum.Material.SmoothPlastic)
	addPart(tool, handle, "Top", Enum.PartType.Cylinder, Vector3.new(0.8, 0.92, 0.92), 0.5, topColor, Enum.Material.SmoothPlastic)
	addPart(tool, handle, "Lid", Enum.PartType.Cylinder, Vector3.new(0.12, 1.04, 1.04), 0.88, WHITE, Enum.Material.Plastic)
	addPart(tool, handle, "Straw", Enum.PartType.Block, Vector3.new(2.6, 0.2, 0.2), 0.1, CHARCOAL, Enum.Material.Plastic, 0.25)

	tool.Parent = StarterPack
end

makeCup("Matcha Latte", MATCHA, MATCHA_FOAM)
makeCup("Brown Coffee", COFFEE, COFFEE_MILK)

-- Entry pad on the start platform
local entryPad = Instance.new("Part")
entryPad.Name = "MatchatosPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = Vector3.new(20, 0.6, 20)
entryPad.Anchored = true
entryPad.Color = MATCHA
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace
entryPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = ENTRY_CF end
end)

-- Way back to the start
local returnPad = part("ReturnPad", Vector3.new(8, 0.2, 8), Vector3.new(12, 1.1, 14), MATCHA, Enum.Material.Neon)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = RETURN_CF end
end)