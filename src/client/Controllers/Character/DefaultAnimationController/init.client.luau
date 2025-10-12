local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DefaultAnimations = require(script.Parent.Parent.Parent.Modules.DefaultAnimations)
local CustomAnimation = require(script.CustomAnimations)


local function onCharacterAdded(character: Model)
	if #CustomAnimation == 0 then return end
	DefaultAnimations.Update(CustomAnimation)
end

Player.CharacterAppearanceLoaded:Connect(onCharacterAdded)


