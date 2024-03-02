local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage.DialogueSystem.DialogueRemoteEvent
local EndRemoteEvent = ReplicatedStorage.DialogueSystem.EndDialogueRemoteEvent
local proximityPrompt = game.Workspace.BrightDialogue.Dialogue.ProximityPrompt

local StopMovementEvent = ReplicatedStorage.PlayerSystem.StopMovementEvent
local ResumeMovementEvent = ReplicatedStorage.PlayerSystem.ResumeMovementEvent

local UserInputService = game:GetService("UserInputService")

local DialogueBg 	:Frame= script.Parent.DialogueBg
local messageLabel 	:TextLabel= script.Parent.DialogueBg.MessageText
local nameLabel 	:TextLabel= script.Parent.DialogueBg.NameText
local nextLabel 	:TextLabel= script.Parent.DialogueBg.NextText

local function SetGuiVisibility(isVisible)
	messageLabel.TextTransparency = isVisible and 0 or 1
	nameLabel.TextTransparency = isVisible and 0 or 1
	nextLabel.TextTransparency = isVisible and 0 or 1
	DialogueBg.Transparency = isVisible and 0 or 1
end

local messages = {}
local name = ""
local index = 1

RemoteEvent.OnClientEvent:Connect(function(get_name: string, get_messages: {string})
	SetGuiVisibility(true)
	
	StopMovementEvent:FireServer()

	messages = get_messages
	name = get_name
	nameLabel.Text = name

	if #messages > 0 then
		index = 1
		messageLabel.Text = messages[index]
	else
		End()
	end
end)

function reset() 
	index = 0
	messages = {}
	name = ""
end


function Next() 
	index+= 1
	if index <= #messages then
		messageLabel.Text = messages[index]
	else
		End()
	end
end

function End()
	print("End Dialogue")
	reset()
	SetGuiVisibility(false)
	EndRemoteEvent:FireServer() -- << tell the server the dialogue is ended
end


UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		Next()
	end
end)


game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	SetGuiVisibility(script.Parent.Enabled)
end)



