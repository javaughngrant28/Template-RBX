
local DataToInstance = require(game.ReplicatedStorage.Shared.Modules.DataToInstance)
local DescendantsToData = require(game.ReplicatedStorage.Shared.Modules.DescendantsToData)


export type ValueType = {}


local Data = {
    Values = {}
}

CharacterValues = {}

function CharacterValues.Create(characerModel: Model)
    DataToInstance.Fire(characerModel,Data)
end

function CharacterValues.Get(characerModel: Model): ValueType
    local Values = characerModel:WaitForChild('Values',5) :: Folder
    assert(Values,`Values Folder Not Found In {characerModel}`)
    return DescendantsToData.Fire(Values)
end

return CharacterValues