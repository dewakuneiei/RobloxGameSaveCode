local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StartDialogueEvent = ReplicatedStorage.DialogueSystem.StartDialogueRemoteEvent
local NextDialogueEvent = ReplicatedStorage.DialogueSystem.NextDialogueRemoteEvent
local EndDialogueEvent = ReplicatedStorage.DialogueSystem.EndDialogueRemoteEvent


local dialogueTrigged = script.Parent:WaitForChild("DialogueTrigged")
dialogueTrigged.Value = false

StartDialogueEvent.OnServerEvent:Connect(function(player) 
	dialogueTrigged.Value = true
end)

NextDialogueEvent.OnServerEvent:Connect(function(player) 
	NextDialogueEvent:FireAllClients(player)
end)

EndDialogueEvent.OnServerEvent:Connect(function()	
	dialogueTrigged.Value = false
end)

































