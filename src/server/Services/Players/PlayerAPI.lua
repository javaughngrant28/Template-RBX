
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local PlayerLoadedSignal = Signal.new()
local PlayerRemovingSignal = Signal.new()



local PlayerAPI = {}

function PlayerAPI.GetPlayerLoadedSignal(): Signal.SignalType
    return PlayerLoadedSignal
end

function PlayerAPI.GetPlayerRemovingSignal(): Signal.SignalType
    return PlayerRemovingSignal
end

return PlayerAPI