

local function CreateLinearVelocity(attachment0: Attachment): LinearVelocity
    local LinearVelocity =  Instance.new('LinearVelocity')

    LinearVelocity.Attachment0 = attachment0
    LinearVelocity.ForceLimitsEnabled = false
    LinearVelocity.VectorVelocity = Vector3.zero
    LinearVelocity.Parent = attachment0.Parent

    return LinearVelocity
end

local function LinearVelocityWithOrientation(attachment0: Attachment): (LinearVelocity, AlignOrientation)
    local linearVelocity = CreateLinearVelocity(attachment0)
    local alignOrientation = Instance.new('AlignOrientation')
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.RigidityEnabled = true
    alignOrientation.Attachment0 = attachment0
   alignOrientation.CFrame = attachment0.WorldCFrame
    alignOrientation.Parent = attachment0.Parent
    return linearVelocity, alignOrientation
end

return {
    Linear = CreateLinearVelocity,
    LinearWithOrientation = LinearVelocityWithOrientation,
}