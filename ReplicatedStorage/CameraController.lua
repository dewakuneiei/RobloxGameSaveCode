local CameraController = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local CAMERA_DEPTH = 24
local HEIGHT_OFFSET = 2
local MOVE_TIME = 1 -- Adjust this value to control the speed of the camera movement

function CameraController:Move2Pos(object)
	local player = Players.LocalPlayer
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false) -- Disable jumping

		local root = character:FindFirstChild("HumanoidRootPart")
		if root then
			local rootPosition = root.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
			local objectPosition = object.Position
			local objectFront = objectPosition + object.CFrame.LookVector

			local camera = Workspace.CurrentCamera
			local tween = TweenService:Create(camera, TweenInfo.new(MOVE_TIME), {CFrame = CFrame.new(objectFront, objectPosition)})
			tween:Play()
			camera.CameraType = Enum.CameraType.Scriptable
		end
	end
end

function CameraController:Reset()
	local player = Players.LocalPlayer
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) -- Enable jumping

		local root = character:FindFirstChild("HumanoidRootPart")
		if root then
			local rootPosition = root.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
			local camera = Workspace.CurrentCamera

			local lookVector = camera.CFrame.LookVector.Unit
			local targetCFrame = CFrame.new(rootPosition, rootPosition + lookVector)

			local tween = TweenService:Create(camera, TweenInfo.new(MOVE_TIME), {CFrame = targetCFrame})
			tween:Play()
			camera.CameraType = Enum.CameraType.Custom
		end
	end
end

return CameraController