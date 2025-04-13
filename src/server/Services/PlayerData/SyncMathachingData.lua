--[[
    This model has one function.
    - Updating / Overriding any matching data values found in A to B and returning B
]]

type DataTeble = {
    [string]: number | string | Vector3 | DataTeble
}

local SyncMathachingData = {}

function SyncMathachingData.Fire(tableA: DataTeble, tableB: DataTeble): DataTeble
    if type(tableA) ~= "table" or type(tableB) ~= "table" then
        error("Both tableA and tableB must be tables.")
    end

    for key, valueA in pairs(tableA) do
        if tableB[key] ~= nil then
            local valueB = tableB[key]

            if type(valueA) == "table" and type(valueB) == "table" then
                tableB[key] = SyncMathachingData.Fire(valueA, valueB)
            else
                if type(valueA) == type(valueB) then
                    tableB[key] = valueA
                end
            end
        end
    end

    return tableB
end

return SyncMathachingData