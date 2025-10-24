local MathUtil = {}

function MathUtil.Lerp(a: number, b: number, t: number): number
    return a + (b - a) * t
end

-- Returns the remaining time based on the provided start time and goal duration.
function MathUtil.GetTimeLeft(startedTime: number, goalDuration: number, useOSTime: boolean?): number
    local currentTime = useOSTime and os.time() or tick()
    local elapsedTime = currentTime - startedTime
    local timeLeft = goalDuration - elapsedTime
    return math.max(timeLeft, 0)
end

function MathUtil.Easing(t: number)
    local a = t * t
    local b = 1.0 - (1.0 - t) * (1.0 - t)
    return MathUtil.Lerp(a,b,t)
end

function MathUtil.ClosestMultiple(value: number | Vector3, multiple: number)
	if multiple == 0 then
		return value
	end

	if typeof(value) == "number" then
		return math.floor((value / multiple) + 0.5) * multiple
	end

	if typeof(value) == "Vector3" then
		local x = math.floor((value.X / multiple) + 0.5) * multiple
		local y = math.floor((value.Y / multiple) + 0.5) * multiple
		local z = math.floor((value.Z / multiple) + 0.5) * multiple
		return Vector3.new(x, y, z)
	end

	error("MathUtil.ClosestMultiple: unsupported value type " .. typeof(value))
end


return MathUtil