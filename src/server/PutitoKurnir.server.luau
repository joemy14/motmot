local Workspace = game:GetService("Workspace")
local StarterPack = game:GetService("StarterPack")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local ORIGIN = Vector3.new(1100, 0, 200)
local ENTRY_CF = CFrame.new(ORIGIN + Vector3.new(0, 3, 12))
local RETURN_CF = CFrame.new(0, 3, -10)
local START_PAD_POS = Vector3.new(0, 0.6, -20) -- bottom row of the 3x3 start grid

local GREEN_DARK = Color3.fromRGB(20, 110, 50)
local GREEN = Color3.fromRGB(40, 160, 70)
local YELLOW = Color3.fromRGB(255, 215, 60)
local YELLOW_LIGHT = Color3.fromRGB(255, 240, 150)
local FRY = Color3.fromRGB(240, 190, 70)
local WHITE = Color3.fromRGB(245, 245, 245)
local CHARCOAL = Color3.fromRGB(35, 35, 40)
local TILE = Color3.fromRGB(230, 230, 225)

local room = Instance.new("Model")
room.Name = "PutitoKurnir"
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
part("BackWall", Vector3.new(40, 14, 1), Vector3.new(0, 7, -20.5), GREEN)
part("LeftWall", Vector3.new(1, 14, 40), Vector3.new(-20.5, 7, 0), GREEN_DARK)
part("RightWall", Vector3.new(1, 14, 40), Vector3.new(20.5, 7, 0), GREEN_DARK)

-- Glowing ceiling strips
for i = -1, 1 do
	part("CeilingStrip" .. i, Vector3.new(3, 0.3, 30), Vector3.new(i * 9, 13.8, 0), YELLOW_LIGHT, Enum.Material.Neon)
end

-- Counter with yellow top and green front
part("CounterBody", Vector3.new(18, 4, 4), Vector3.new(0, 2, -15), GREEN)
part("CounterTop", Vector3.new(18.6, 0.4, 4.6), Vector3.new(0, 4.2, -15), YELLOW)
part("FryWarmer", Vector3.new(5, 2, 2.5), Vector3.new(-5, 5.2, -15), CHARCOAL)
part("FryWarmerGlow", Vector3.new(4.4, 0.2, 2), Vector3.new(-5, 6.25, -15), YELLOW_LIGHT, Enum.Material.Neon)

-- Striped awning
for i = 0, 5 do
	part("Awning" .. i, Vector3.new(6, 0.6, 9), Vector3.new(-15 + i * 6, 12, -10),
		i % 2 == 0 and YELLOW or GREEN)
end

-- Sign on the back wall (lowered, text faces the room)
local sign = part("Sign", Vector3.new(22, 4, 0.5), Vector3.new(0, 9.5, -19.7), GREEN_DARK, Enum.Material.Neon)
writeOn(sign, Enum.NormalId.Back, "Putito Kurnir\nAlways Cooked Fresh", YELLOW)

-- Menu board
part("MenuLegLeft", Vector3.new(0.4, 3, 0.4), Vector3.new(-11, 2.5, 4), CHARCOAL)
part("MenuLegRight", Vector3.new(0.4, 3, 0.4), Vector3.new(-7, 2.5, 4), CHARCOAL)
local board = part("MenuBoard", Vector3.new(7, 6, 0.4), Vector3.new(-9, 6, 4), CHARCOAL, Enum.Material.Wood)
writeOn(board, Enum.NormalId.Back, "MENU\nFries Cup ....... 39\nCheese Fries .... 49", WHITE, Enum.Font.GothamMedium)

-- Fry cups on display
for i, x in ipairs({ 0, 3, 6, 9 }) do
	local cup = part("DisplayCup" .. i, Vector3.new(1.8, 1.4, 1.4), Vector3.new(x, 5.4, -15), WHITE, nil, Enum.PartType.Cylinder)
	cup.CFrame = CFrame.new(ORIGIN + Vector3.new(x, 5.4, -15)) * CFrame.Angles(0, 0, math.rad(90))
	local fries = part("DisplayFries" .. i, Vector3.new(0.4, 1.4, 1.4), Vector3.new(x, 6.4, -15), FRY)
end

-- Equippable Fries Cup
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

addPart(friesTool, handle, "Cup", Enum.PartType.Cylinder, Vector3.new(1.9, 1.1, 1.1),
	UPRIGHT, Color3.fromRGB(230, 40, 40), Enum.Material.SmoothPlastic, 0.1)
addPart(friesTool, handle, "Band", Enum.PartType.Cylinder, Vector3.new(0.4, 1.15, 1.15),
	CFrame.new(0.1, 0, 0) * UPRIGHT, GREEN, Enum.Material.SmoothPlastic)
addPart(friesTool, handle, "FriesA", Enum.PartType.Block, Vector3.new(0.25, 0.25, 1.1),
	CFrame.new(0, 1.1, 0.2) * CFrame.Angles(0.3, 0, 0.2), FRY, Enum.Material.SmoothPlastic)
addPart(friesTool, handle, "FriesB", Enum.PartType.Block, Vector3.new(0.25, 0.25, 1.1),
	CFrame.new(0.2, 1.2, -0.1) * CFrame.Angles(-0.2, 0.4, -0.3), FRY, Enum.Material.SmoothPlastic)
addPart(friesTool, handle, "FriesC", Enum.PartType.Block, Vector3.new(0.25, 0.25, 1.1),
	CFrame.new(-0.1, 1.15, -0.2) * CFrame.Angles(0.4, -0.2, 0.1), FRY, Enum.Material.SmoothPlastic)

friesTool.Parent = StarterPack

-- Fry rain (runs on the copies players actually hold)
local rainFolder = Instance.new("Folder")
rainFolder.Name = "FryRain"
rainFolder.Parent = Workspace

local function dropFry(center)
	local fry = Instance.new("Part")
	fry.Name = "RainFry"
	fry.Size = Vector3.new(0.35, 0.35, 1.8)
	fry.Color = FRY
	fry.Material = Enum.Material.SmoothPlastic
	fry.CanCollide = false
	fry.CFrame = CFrame.new(center + Vector3.new(math.random(-18, 18), 35, math.random(-18, 18)))
		* CFrame.Angles(math.random() * 3, math.random() * 3, math.random() * 3)
	fry.Parent = rainFolder
	Debris:AddItem(fry, 8)
end

local raining = {}

local function startRain(tool)
	raining[tool] = true
	task.spawn(function()
		while raining[tool] do
			local character = tool.Parent
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _ = 1, 2 do
					dropFry(hrp.Position)
				end
			end
			task.wait(0.15)
		end
	end)
end

local watched = {}

local function watchTool(tool)
	if not tool:IsA("Tool") or tool.Name ~= "Fries Cup" or watched[tool] then return end
	watched[tool] = true
	tool.Equipped:Connect(function() startRain(tool) end)
	tool.Unequipped:Connect(function() raining[tool] = nil end)
end

local function watchPlayer(player)
	player.CharacterAdded:Connect(function(character)
		character.ChildAdded:Connect(watchTool)
		for _, t in ipairs(character:GetChildren()) do watchTool(t) end

		local backpack = player:WaitForChild("Backpack")
		backpack.ChildAdded:Connect(watchTool)
		for _, t in ipairs(backpack:GetChildren()) do watchTool(t) end
	end)
end

Players.PlayerAdded:Connect(watchPlayer)
for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end

-- Entry pad on the start platform (green, bottom row of the grid)
local entryPad = Instance.new("Part")
entryPad.Name = "PutitoPad"
entryPad.Size = Vector3.new(8, 0.2, 8)
entryPad.Position = START_PAD_POS
entryPad.Anchored = true
entryPad.Color = GREEN
entryPad.Material = Enum.Material.Neon
entryPad.Parent = Workspace
entryPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = ENTRY_CF end
end)

-- Way back to the start (glowing green)
local returnPad = part("ReturnPad", Vector3.new(8, 0.2, 8), Vector3.new(12, 1.1, 14), GREEN, Enum.Material.Neon)
returnPad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then root.CFrame = RETURN_CF end
end)