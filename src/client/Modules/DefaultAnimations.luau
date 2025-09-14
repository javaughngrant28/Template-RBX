local Players = game:GetService("Players")

type DefaultAnimations = {
    RunAnim: string,
    WalkAnim: string,
    Animation1: string, -- Idle1
    Animation2: string, -- Idle2
    JumpAnim: string,
    FallAnim: string,
    Swim: string,
    SwimIdle: string,
    ClimbAnim: string,
}

local AnimationList = {
    RunAnim = "rbxassetid://",
    WalkAnim = "rbxassetid://",
    Animation1 = "rbxassetid://",
    Animation2 = "rbxassetid://",
    JumpAnim = "rbxassetid://",
    FallAnim = "rbxassetid://",
    Swim = "rbxassetid://",
    SwimIdle = "rbxassetid://",
    ClimbAnim = "rbxassetid://",
}

local Player = Players.LocalPlayer

local function LoadAnimationsInTable(animations: DefaultAnimations)
	local animator = Player.Character:FindFirstChildWhichIsA("Animator",true)
    assert(animator,`No Animator In Player`)

	-- Stop all animation tracks
	for _, playingTrack in animator:GetPlayingAnimationTracks() do playingTrack:Stop(0) end

	local animateScript = Player.Character:WaitForChild("Animate",20) 
    assert(animateScript,'Animation Script Not In Player')

    for index,  value in animations do
        local animation = animateScript:FindFirstChild(index,true) :: Animation
        animation.AnimationId = value
    end
end

local function LoadAnimationsFromFolder(folder: Folder)
    local animationTable = {}

    if #folder:GetChildren() == 0 then warn(`{folder} Has No Children`) return end

    for _, animation: Animation in folder:GetChildren() do
        if not animation:IsA('Animation') or not AnimationList[animation.Name] then
            warn(`{animation} {typeof(animation)} Type Or Name Not Valid`)
            continue 
        end
        animationTable[animation.Name] = animation.AnimationId
    end

    LoadAnimationsInTable(animationTable)
end

local function LoadAnimationsFromTable(animationTable: DefaultAnimations)
    local TableEmpty = true

    for index, value in animationTable do
        if not AnimationList[index] then
            animationTable[index] = nil
            warn(`{index} In table Not Valid`)
            continue
        end

        TableEmpty = false
    end

    if TableEmpty then return end
    LoadAnimationsInTable(animationTable)
end

local function UpdateDefaultAnimations(animations: DefaultAnimations | Folder)
    if typeof(animations) == "Instance" and animations:IsA('Folder') then
        LoadAnimationsFromFolder(animations)
        return
    end

    if typeof(animations) =="table" then
        LoadAnimationsFromTable(animations)
        return
    end

    warn(`{animations} Must Be A Table Or Folder`)
end


return {
    Update = UpdateDefaultAnimations
}



-- local function onCharacterAdded(character)
-- 	-- Get animator on humanoid
-- 	local humanoid = character:WaitForChild("Humanoid")
-- 	local animator = humanoid:WaitForChild("Animator")

-- 	-- Stop all animation tracks
-- 	for _, playingTrack in animator:GetPlayingAnimationTracks() do
-- 		playingTrack:Stop(0)
-- 	end

-- 	local animateScript = character:WaitForChild("Animate")

-- end