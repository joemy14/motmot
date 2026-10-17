local Workspace = game:GetService("Workspace")
local StarterPack = game:GetService("StarterPack")
local Debris = game:GetService("Debris")

local ORIGIN = Vector3.new(1100, 0, 200)
local ENTRY_CF = CFrame.new(ORIGIN + Vector3.new(0, 3, 12))
local RETURN_CF = CFrame.new(0, 3, -10)

local GREEN_DARK = Color3.fromRGB(20, 110, 50)
local GREEN = Color3.fromRGB(40, 160, 70)
local YELLOW = Color3.fromRGB(255, 215, 60)
local YELLOW_LIGHT = Color3.fromRGB(255, 240, 150)
local FRY = Color3.fromRGB(240, 190, 70)
local WHITE = Color3.fromRGB(245, 245, 245)
local CHARCOAL = Color3.fromRGB(35, 35, 40)
local BROWN_PAD = Color3.fromRGB(120, 75, 40)
local TILE = Color3.fromRGB(230, 230, 225)

local room = Instance.new("Model")
room.Name = "PutitoKurnir"
room.Parent = Workspace

local function part(name, size, pos, color, material, shape, parent)
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
	p.Parent = parent or room
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

-- Floor and walls
part("Floor", Vector3.new(40, 1, 40), Vector3.new(0, 0.5, 0), TILE, Enum.Material.Marble)
for i = -4, 4 do
	part("FloorTileLine" .. i, Vector3.new(40, 0.05, 0.15), Vector3.new(0, 1.03, i * 4), Color3.fromRGB(200, 200, 195), Enum.Material.Marble)
end
part("BackWall", Vector3.new(40, 14, 1), Vector3.new(0, 7, -20.5), GREEN)
part("LeftWall", Vector3.new(1, 14, 40), Vector3.new(-20.5, 7, 0), GREEN_DARK)
part("RightWall", Vector3.new(1, 14, 40), Vector3.new(20.5, 7, 0), GREEN_DARK)

-- Glowing ceiling strips (cheap light detail)
for i = -1, 1 do
	part("CeilingStrip" .. i, Vector3.new(3, 0.3, 30), Vector3.new(i * 9, 13.8, 0), YELLOW_LIGHT, Enum.Material.Neon)
end

-- Counter with a yellow top and green front
part("CounterBody", Vector3.new(18, 4, 4), Vector3.new(0, 2, -15), GREEN)
part("CounterTop", Vector3.new(18.6, 0.4, 4.6), Vector3.new(0, 4.2, -15), YELLOW)
part("FryWarmer", Vector3.new(5, 2, 2.5), Vector3.new(-5, 5.2, -15), CHARCOAL)
part("FryWarmerGlow", Vector3.new(4.4, 0.2, 2), Vector3.new(-5, 6.25, -15), YELLOW_LIGHT, Enum.Material.Neon)

-- Striped yellow and green awning over the counter
for i = 0, 5 do
	part("Awning" .. i, Vector3.new(6, 0.6, 9), Vector3.new(-15 + i * 6, 12, -10),
		i % 2 == 0 and YELLOW or GREEN)
end

-- Sign with the room name
local sign = part("Sign", Vector3.new(22, 4, 0.5), Vector3.new(0, 15.5, -17), GREEN_DARK)
writeOn(sign, Enum.NormalId.Back, "Putito Kurnir\nAlways Cooked Fresh", YELLOW)
local signLight = Instance.new("PointLight")
signLight.Color = YELLOW
signLight.Brightness = 1
signLight.Range = 14
signLight.Parent = sign

-- Menu board on two legs
part("MenuLegLeft", Vector3.new(0.4, 3, 0.4), Vector3.new(-11, 2.5, 4), CHARCOAL)
part("MenuLegRight", Vector3.new(0.4, 3, 0.4), Vector3.new(-7, 2.5, 4), CHARCOAL)
local board = part("MenuBoard", Vector3.new(7, 6, 0.4), Vector3.new(-9, 6, 4), CHARCOAL, Enum.Material.Wood)
writeOn(board, Enum.NormalId.Back, "MENU\nFries Cup ....... 39\nCheese Fries .... 49", WHITE, Enum.Font.GothamMedium)

-- Fry cups on display (upright cylinders on the counter)
for i, x in ipairs({ 0, 3, 6, 9 }) do
	local cup = part("DisplayCup" .. i, Vector3.new(1.8, 1.4, 1.4), Vector3.new(x, 5.4, -15), WHITE, Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
	cup.CFrame = CFrame.new(ORIGIN + Vector3.new(x, 5.4, -15)) * CFrame.Angles(0, 0, math.rad(90))
	local fries = part("DisplayFries" .. i, Vector3.new(1.2, 1, 1), Vector3.new(x, 6.4, -15), FRY, Enum.Material.SmoothPlastic, Enum.PartType.Block)
	fries.Size = Vector3.new(0.4, 1.4, 1.4)
end

-- Friendly potato mascot (original character, not a copy of the brand mascot)
local mascot = Instance.new("Model")
mascot.Name = "Mascot"
mascot.Parent = room
local body = part("MascotBody", Vector3.new(6, 6, 6), Vector3.new(17, 4, -6), Color3.fromRGB(230, 180, 90), Enum.Material.SmoothPlastic, Enum.PartType.Ball, mascot)
part("MascotEyeL", Vector3.new(1, 1, 0.3), Vector3.new(16, 5, -3), CHARCOAL, nil, Enum.PartType.Ball, mascot)
part("MascotEyeR", Vector3.new(1, 1, 0.3), Vector3.new(18, 5, -3), CHARCOAL, nil, Enum.PartType.Ball, mascot)
part("MascotFootL", Vector3.new(1.6, 1, 2), Vector3.new(15, 0.5, -6), GREEN, nil, nil, mascot)
part("MascotFootR", Vector3.new(1.6, 1, 2), Vector3.new(19, 0.5, -6), GREEN, nil, nil, mascot)
local mascotBubble = part("MascotSign", Vector3.new(5, 2, 0.3), Vector3.new(17, 9.5, -6), WHITE, nil, nil, mascot)
writeOn(mascotBubble, Enum.NormalId.Front, "Fresh! 🍟", CHARCOAL)

-- Equippable Fries Cup (tool goes in StarterPack)
local UPRIGHT = CFrame.Angles(0, 0, math.rad(90))

local function addPart(tool, handle, name, shape, size, localCF, color, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Shape = shape
	p.Size = size
	p.Color = color
	p.Material = material
	p.Transparency = transparency or 0
	p.CanCollide = false
	p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.CFrame = handle.CFrame * localCF
	p.Parent = tool

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = handle
	weld.Part1 = p
	weld.Parent = p
	return p
end

local friesTool = Instance.new("Tool")
friesTool.Name = "Fries Cup"
friesTool.RequiresHandle = true
friesTool.CanBeDropped = false

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.6, 0.6, 0.6)
handle.Transparency = 1
handle.CanCollide = false
handle.Massless = true
handle.Parent = friesTool

-- Cup shell (translucent so the fries show through)
addPart(friesTool, handle, "Cup", Enum.PartType.Cylinder, Vector3.new(1.9, 1.1, 1.1),
	UPRIGHT, Color3.fromRGB(230, 40, 40), Enum.Material.SmoothPlastic, 0.1)
-- Green stripe band
addPart(friesTool, handle, "Band", Enum.PartType.Cylinder, Vector3.new(0.4, 1.15, 1.15),
	CFrame.new(0.1, 0, 0) * UPRIGHT, GREEN, Enum.Material.SmoothPlastic)
-- Fries piled above the rim
addPart(friesTool, handle, "FriesA", Enum.PartType.Block, Vector3.new(0.25, 0.25, 1.1),
	CFrame.new(0, 1.1, 0.2) * CFrame.Angles(0.3, 0, 0.2), FRY, Enum.Material.SmoothPlastic)
addPart(friesTool, handle, "FriesB", Enum.PartType.Block, Vector3.new(0.25, 0.25, 1.1),
	CFrame.new(0.2, 1.2, -0.1) * CFrame.Angles(-0.2, 0.4, -0.3), FRY, Enum.Material.SmoothPlastic)
addPart(friesTool, handle, "FriesC", Enum.PartType.Block, Vector3.new(0.25, 0.25, 1.1),
	CFrame.new(-0.1, 1.15, -0.2) * CFrame.Angles(0.4, -0.2, 0.1), FRY, Enum.Material.SmoothPlastic)

friesTool.Parent = StarterPack

-- Fry rain: spawns while the tool is equipped, stops when unequipped
local rainFolder = Instance.new("Folder")
rainFolder.Name = "FryRain"
rainFolder.Parent = Workspace

local active = {}

local function dropFry(center)
	local fry = Instance.new("Part")
	fry.Name = "RainFry"
	fry.Size = Vector3.new(0.35, 0.35, 1.8)
	fry.Color = FRY
	fry.Material = Enum.Material.SmoothPlastic
	fry.CanCollide = true
	fry.Position = center + Vector3.new(math.random(-18, 18), 35, math.random(-18, 18))
	fry.CFrame = CFrame.new(fry.Position) * CFrame.Angles(math.random() * 3, math.random() * 3, math.random() * 3)
	fry.Parent = rainFolder
	Debris:AddItem(fry, 8)
end

friesTool.Equipped:Connect(function()
	local token = {}
	active[friesTool] = token
	task.spawn(function()
		while active[friesTool] == token and friesTool:IsDescendantOf(game) do
			local character = friesTool.Parent
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _ = 1, 2 do
					dropFry(hrp.Position)
				end
			end
			task.wait(0.15)
		end
	end)
end)

friesTool.Unequipped:Connect(function()
	active[friesTool] = nil
end)

-- Entry pad on the start platform (green)
local entryPad = Instance.new("Part")
entryPad.Name = "PutitoPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = Vector3.new(40, 0.6, 20)
entryPad.Anchored = true
entryPad.Color = GREEN
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace
entryPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = ENTRY_CF end
end)

-- Way back to the start (brown)
local returnPad = part("ReturnPad", Vector3.new(8, 0.2, 8), Vector3.new(12, 1.1, 14), BROWN_PAD)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = RETURN_CF end
end)