-- this script is on server-side
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StopMovementEvent = ReplicatedStorage.PlayerSystem.StopMovementEvent
local ResumeMovementEvent = ReplicatedStorage.PlayerSystem.ResumeMovementEvent

local EndDialogueRemoteEvent = ReplicatedStorage.DialogueSystem.EndDialogueRemoteEvent


local dialogueTrigged = script.Parent.DialogueTrigged

StopMovementEvent.OnServerEvent:Connect(function(player)
	print("Stop all player movement")
	dialogueTrigged.Value = true 
	
end)

EndDialogueRemoteEvent.OnServerEvent:Connect(function(player) 
	print("Player can move")
	dialogueTrigged.Value = false
end)


























