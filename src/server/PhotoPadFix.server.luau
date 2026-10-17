local Workspace = game:GetService("Workspace")

local PHOTO_ENTRY = CFrame.new(1800, 6, 200) -- center of the booth, raised so you don't clip into the floor
local PAD_POS = Vector3.new(0, 1, 20)
local PINK = Color3.fromRGB(255, 150, 190)

-- Give the other room scripts time to build first
task.wait(5)

-- Remove the cozy room
local cozy = Workspace:FindFirstChild("HangoutRoom")
if cozy then cozy:Destroy() end

-- Remove leftover pads so only one pink pad leads to the booth
for _, child in ipairs(Workspace:GetChildren()) do
	if child:IsA("BasePart") and (child.Name == "RoomPad" or child.Name == "PhotoPad") then
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
		print("PhotoPad: sending to booth")
		root.CFrame = PHOTO_ENTRY
	end
end)