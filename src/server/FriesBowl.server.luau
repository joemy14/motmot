local StarterPack = game:GetService("StarterPack")

local FRY = Color3.fromRGB(240, 190, 70)
local FRY_DARK = Color3.fromRGB(215, 160, 50)
local WHITE = Color3.fromRGB(245, 245, 245)
local GREEN = Color3.fromRGB(40, 160, 70)
local UPRIGHT = CFrame.Angles(0, 0, math.rad(90))

-- Remove the old cup so only the bowl is given (runs after the old file has loaded)
task.delay(1, function()
	for _, t in ipairs(StarterPack:GetChildren()) do
		if t:IsA("Tool") and t.Name == "Fries Cup" and not t:GetAttribute("Bowl") then
			t:Destroy()
		end
	end
end)

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

local bowl = Instance.new("Tool")
bowl.Name = "Fries Cup" -- keeps the name so the fry rain still works
bowl.RequiresHandle = true
bowl.CanBeDropped = false
bowl:SetAttribute("Bowl", true)

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.6, 0.6, 0.6)
handle.Transparency = 1
handle.CanCollide = false
handle.Massless = true
handle.Parent = bowl

-- Bowl body: wide and short, see-through so the fries show
addPart(bowl, handle, "BowlBody", Enum.PartType.Cylinder, Vector3.new(0.9, 1.7, 1.7),
	UPRIGHT, WHITE, Enum.Material.SmoothPlastic, 0.35)

-- Green base, like the brand bowl
addPart(bowl, handle, "BowlBase", Enum.PartType.Cylinder, Vector3.new(0.25, 1.0, 1.0),
	CFrame.new(0, -0.3, 0) * UPRIGHT, GREEN, Enum.Material.SmoothPlastic)

-- Heap of many small fries, piled above and inside the rim
local rng = Random.new(7) -- same layout every time
for i = 1, 36 do
	local angle = rng:NextNumber(0, math.pi * 2)
	local radius = rng:NextNumber(0, 0.6)
	local height = rng:NextNumber(0.4, 1.2)
	local pos = CFrame.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
	local spin = CFrame.Angles(
		rng:NextNumber(0, math.pi),
		rng:NextNumber(0, math.pi),
		rng:NextNumber(0, math.pi)
	)
	local color = (i % 3 == 0) and FRY_DARK or FRY
	addPart(bowl, handle, "Fry" .. i, Enum.PartType.Block, Vector3.new(0.14, 0.14, 0.9),
		pos * spin, color, Enum.Material.SmoothPlastic)
end

bowl.Parent = StarterPack