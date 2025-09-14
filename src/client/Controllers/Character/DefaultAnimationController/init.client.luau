local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DefaultAnimations = require(script.Parent.Parent.Parent.Modules.DefaultAnimations)
local CustomAnimation = require(script.CustomAnimations)
local ToolDetectore = require(script.Parent.Parent.Parent.Modules.ToolDetectore)


local function onCharacterAdded(character: Model)
	if #CustomAnimation == 0 then return end
	DefaultAnimations.Update(CustomAnimation)
end

local function ToolEquipped(tool: Tool)
	local animationFolder = tool:FindFirstChild('Animations')
	if animationFolder then
		DefaultAnimations.Update(animationFolder)
	end
end

ToolDetectore.EquippedSignal:Connect(ToolEquipped)
Player.CharacterAppearanceLoaded:Connect(onCharacterAdded)