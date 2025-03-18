local MathUtil = {}

function MathUtil.Lerp(a: number, b: number, t: number): number
    return a + (b - a) * t
end

function MathUtil.Easing(t: number)
    local a = t * t
    local b = 1.0 - (1.0 - t) * (1.0 - t)
    return MathUtil.Lerp(a,b,t)
end


return MathUtil