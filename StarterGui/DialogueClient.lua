-- Accessing necessary services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")


local CameraController = require(ReplicatedStorage.ModuleScripts.CameraController)

-- Accessing remote events
local StartDialogueRemoteEvent = ReplicatedStorage.DialogueSystem.StartDialogueRemoteEvent
local EndRemoteEvent = ReplicatedStorage.DialogueSystem.EndDialogueRemoteEvent

-- Accessing GUI elements
local DialogueBg = script.Parent.DialogueBg
local messageLabel = DialogueBg.MessageText
local nameLabel = DialogueBg.NameText
local nextLabel = DialogueBg.NextText

-- Accessing local player and character
local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variable initialization
local playerWhoPressedButton = nil
local messages = {}
local name = ""
local index = 1
local moveSpeed = require(ReplicatedStorage.ModuleScripts.PlayerStatus).MOVE_SPEED or 16

-- Function to set GUI visibility
local function SetGuiVisibility(isVisible)
	local transparency = isVisible and 0 or 1
	messageLabel.TextTransparency = transparency
	nameLabel.TextTransparency = transparency
	nextLabel.TextTransparency = transparency
	DialogueBg.Transparency = transparency
end

-- Function to halt movement
local function StopMovement()
	humanoid.WalkSpeed = 0
	humanoid.Jump = false
	UserInputService.MouseIconEnabled = false
end

-- Function to resume movement
local function ResumeMovement()
	humanoid.WalkSpeed = moveSpeed
	humanoid.Jump = true
	UserInputService.MouseIconEnabled = true
end

-- Function to reset dialogue state
local function Reset()
	index = 0
	messages = {}
	name = ""
	playerWhoPressedButton = nil
	
	CameraController:Reset()
end

-- Function to end dialogue
local function End()
	print("End Dialogue")
	Reset()
	SetGuiVisibility(false)
	ResumeMovement()
	EndRemoteEvent:FireServer()
	-- Reset the camera back to the player's camera

end

-- Function to handle next message
local function Next()
	index = index + 1
	if index <= #messages then
		messageLabel.Text = messages[index]
	else
		End()
	end
end

-- Event handler for StartDialogueRemoteEvent
StartDialogueRemoteEvent.OnClientEvent:Connect(function(get_who_pressed, get_name, get_messages, cameraOfDialogue) -- fix cameraOfDialogue
	-- Display GUI and halt movement
	SetGuiVisibility(true)
	StopMovement()
	

	-- Trigger StartDialogueRemoteEvent on server
	StartDialogueRemoteEvent:FireServer()

	-- Set dialogue data
	messages = get_messages
	name = get_name
	nameLabel.Text = name
	playerWhoPressedButton = get_who_pressed
	
	-- Call Move2Pos function when the dialogue is triggered
	CameraController:Move2Pos(cameraOfDialogue)

	-- Display first message
	if #messages > 0 then
		index = 1
		messageLabel.Text = messages[index]
	else
		End()
	end
end)

-- Event handler for player input
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		Next()
	end
end)

-- Event handler for GUI visibility change
Players.LocalPlayer.PlayerGui.GameGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	SetGuiVisibility(script.Parent.Enabled)
end)
