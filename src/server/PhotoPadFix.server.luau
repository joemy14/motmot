local Workspace = game:GetService("Workspace")

local PAD_POS = Vector3.new(0, 1, 20)
local PINK = Color3.fromRGB(255, 150, 190)

-- Remove the cozy room
local cozy = Workspace:FindFirstChild("HangoutRoom")
if cozy then cozy:Destroy() end

-- Remove every old PhotoPad (from both files), for a few seconds,
-- since the other script may still be creating them
local function clearOldPads()
	for _, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("BasePart") and (child.Name == "PhotoPad" or child.Name == "RoomPad") then
			child:Destroy()
		end
	end
end

for _ = 1, 10 do
	clearOldPads()
	task.wait(0.5)
end

-- One new pad, with a unique name
local pad = Instance.new("Part")
pad.Name = "BoothPad"
pad.Size = Vector3.new(8, 0.2, 8)
pad.Position = PAD_POS
pad.Anchored = true
pad.Color = PINK
pad.Material = Enum.Material.Neon
pad.Parent = Workspace

local busy = false

pad.Touched:Connect(function(hit)
	if busy then return end
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local booth = Workspace:FindFirstChild("PhotoBooth")
	local floor = booth and booth:FindFirstChild("Floor")
	if not floor then
		warn("BoothPad: PhotoBooth floor not found")
		return
	end

	busy = true
	root.CFrame = floor.CFrame + Vector3.new(0, 4, 0)
	task.wait(1)
	busy = false
end)