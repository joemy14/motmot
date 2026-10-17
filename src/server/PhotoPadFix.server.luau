local Workspace = game:GetService("Workspace")

local PAD_POS = Vector3.new(0, 1, 20)
local PINK = Color3.fromRGB(255, 150, 190)

-- Remove the cozy room and any old pads
local cozy = Workspace:FindFirstChild("HangoutRoom")
if cozy then cozy:Destroy() end

task.wait(5)

for _, child in ipairs(Workspace:GetChildren()) do
	if child:IsA("BasePart") and (child.Name == "RoomPad" or child.Name == "PhotoPad") then
		child:Destroy()
	end
end

-- New pad on the start platform
local pad = Instance.new("Part")
pad.Name = "PhotoPad"
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

	-- Find the booth's real floor, so we land on it instead of guessing coordinates
	local booth = Workspace:FindFirstChild("PhotoBooth")
	local floor = booth and booth:FindFirstChild("Floor")
	if not floor then
		warn("PhotoPad: PhotoBooth floor not found. The booth file may not have built.")
		return
	end

	busy = true
	root.CFrame = floor.CFrame + Vector3.new(0, 4, 0)
	task.wait(1)
	busy = false
end)