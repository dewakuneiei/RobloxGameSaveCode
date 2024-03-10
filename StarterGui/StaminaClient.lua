local playerStatus = require(game:GetService("ReplicatedStorage").ModuleScripts.PlayerStatus)
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

local character = players.LocalPlayer.Character
local staminaFrame = script.Parent

local maxStamina = 100
local currentStamina = maxStamina
local decreaseRateMultiplier = 100
local increaseRateMultiplier = 10

local isOnPressed = false
local canRun = true
local isFatigued = false
local getRestFor = 2 -- in seconds

local Humanoid = character.Humanoid
local MIN_MOVE_SPEED = playerStatus.MIN_MOVE_SPEED
local MAX_MOVE_SPEED = playerStatus.MAX_MOVE_SPEED
local MOVE_SPEED = playerStatus.MOVE_SPEED

local function GotFatigued()
	isFatigued = true
	Humanoid.WalkSpeed = MIN_MOVE_SPEED
	print("Take a break.")
	task.wait(getRestFor)
	isFatigued = false
end 

local function handleInput(input, isPressed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
			isOnPressed = isPressed
		end
	end
end

userInputService.InputBegan:Connect(function(input)
	handleInput(input, true)
end)

userInputService.InputEnded:Connect(function(input)
	handleInput(input, false)
end)

function Run()
	Humanoid.WalkSpeed = playerStatus.MAX_MOVE_SPEED
end

function Walk()
	Humanoid.WalkSpeedd = playerStatus.MOVE_SPEED
end

local function UpdateStamina(value)
	currentStamina = currentStamina + value
	local newSizeX = math.clamp(currentStamina / maxStamina, 0, 1)
	local targetSize = UDim2.new(newSizeX, 0, 1, 0)
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = tweenService:Create(staminaFrame, tweenInfo, {Size = targetSize})
	tween:Play()
end

local function DecreaseStamina(value)
	UpdateStamina(-value)
end

local function IncreaseStamina(value)
	UpdateStamina(value)
end


runService.Heartbeat:Connect(function(step)
	canRun = currentStamina > 0
	if (isOnPressed and canRun and not isFatigued) or currentStamina <= maxStamina then
		if isOnPressed and canRun and not isFatigued then
			Humanoid.WalkSpeed = MAX_MOVE_SPEED
			DecreaseStamina(step * decreaseRateMultiplier)
			if currentStamina <= 0 then
				GotFatigued()
			end
		else
			if not isFatigued then
				Humanoid.WalkSpeed = MOVE_SPEED
			end
			IncreaseStamina(step * increaseRateMultiplier)
		end
	end
end)