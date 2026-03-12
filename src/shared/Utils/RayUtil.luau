local function GetRayHit(origin: Vector3, direction: Vector3, distance: number, raycastParams: RaycastParams?): (Instance?, Vector3)
    local rayDirection = direction.Unit * distance
    local raycastResult = workspace:Raycast(origin, rayDirection, raycastParams)
    
    if raycastResult then
        return raycastResult.Instance, raycastResult.Position
    else
        return nil, origin + rayDirection
    end
end

return {
    GetHit = GetRayHit
}