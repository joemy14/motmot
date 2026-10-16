local Workspace = game:GetService("Workspace")

local ROOM_TELEPORT = CFrame.new(200, 4, 200) -- stands on the room floor

-- Start platform: where you spawn, so you don't fall
local start = Instance.new("Part")
start.Name = "StartPlatform"
start.Size = Vector3.new(60, 2, 60)
start.Position = Vector3.new(0, -1, 0) -- top surface at y = 0
start.Anchored = true
start.Color = Color3.fromRGB(180, 150, 220)
start.Material = Enum.Material.SmoothPlastic
start.Parent = Workspace

-- Spawn point on the platform
local spawn = Instance.new("SpawnLocation")
spawn.Name = "StartSpawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(0, 0.5, 0)
spawn.Anchored = true
spawn.Neutral = true
spawn.Transparency = 1
spawn.CanCollide = true
spawn.Parent = Workspace

-- Teleport pad: step on it to go to the hangout room
local pad = Instance.new("Part")
pad.Name = "RoomPad"
pad.Size = Vector3.new(8, 1, 8)
pad.Position = Vector3.new(0, 1, 20)
pad.Anchored = true
pad.Color = Color3.fromRGB(255, 111, 168)
pad.Material = Enum.Material.Neon
pad.Parent = Workspace

pad.Touched:Connect(function(hit)
	local character = hit.Parent
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = ROOM_TELEPORT
	end
end)