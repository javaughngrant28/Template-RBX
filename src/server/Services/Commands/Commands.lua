local Commands = {}

function Commands.KillAll()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			player.Character.Humanoid.Health = 0
		end
	end
end

function Commands.Kill(player: Player)
	if player and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Health = 0
	end
end




return Commands