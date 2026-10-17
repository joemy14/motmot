local Workspace = game:GetService("Workspace")

local PHOTO_ENTRY = CFrame.new(1800, 3, 212) -- inside the photo booth
local PAD_POS = Vector3.new(0, 1, 20) -- same spot as the old pink pad
local PINK = Color3.fromRGB(255, 150, 190)

-- Wait so this runs after the other room scripts have loaded
task.wait(3)

-- Remove the cozy room
local cozy = Workspace:FindFirstChild("HangoutRoom")
if cozy then cozy:Destroy() end

-- Remove the old pink pad (cozy) and the old photo pad (hard to see)
for _, child in ipairs(Workspace:GetChildren()) do
	if (child.Name == "RoomPad" or child.Name == "PhotoPad") and child:IsA("BasePart") then
		child:Destroy()
	end
end

-- New photo booth pad on the start platform
local pad = Instance.new("Part")
pad.Name = "PhotoPad"
pad.Size = Vector3.new(8, 0.2, 8)
pad.Position = PAD_POS
pad.Anchored = true
pad.Color = PINK
pad.Material = Enum.Material.Neon
pad.Parent = Workspace

pad.Touched:Connect(function(hit)
	local root = hit.Parent and hit.Parent:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = PHOTO_ENTRY
	end
end)