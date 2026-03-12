local function CreateWeldConstraint(pO: BasePart, p1: BasePart, normalWeldInstance: boolean?): Weld | WeldConstraint
    local normalWeldInstance = normalWeldInstance or false
    local weld = normalWeldInstance and Instance.new('Weld') or Instance.new('WeldConstraint')
    weld.Part0 = pO
    weld.Part1 = p1
    weld.Parent = p1
    return weld
end

return {
    Weld = CreateWeldConstraint,
}