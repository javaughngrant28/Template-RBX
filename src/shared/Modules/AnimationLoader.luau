export type AnimationID = string | number
export type KeyframeCallback = (markerName: string) -> nil

export type AnimationData = {
	Connection: RBXScriptConnection?,
	AnimationTrack: AnimationTrack
}

export type AnimationAdress = {
	[string]: AnimationData
}

local ANIMATION_EXTENTION = "rbxassetid://"
local NO_CATEGORY = "None"

local Animations: {
	[Model]: {
		[string]: AnimationAdress
	}
} = {}

local function sanitizeAnimationID(data: AnimationID): string
	if typeof(data) == "number" then
		return `{ANIMATION_EXTENTION}{data}`
	else
		return data
	end
end

local function getAnimator(character: Model): Animator?
	local humanoid = character:FindFirstChildWhichIsA("Humanoid", true)
	if not humanoid then
		warn(`{script.Name} {character} has no Humanoid`)
		return nil
	end

	local animator = humanoid:FindFirstChildWhichIsA("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	return animator
end

local function getAnimation(animationID: string): Animation
	local animation = Instance.new("Animation")
	animation.AnimationId = animationID
	return animation
end

local function getAnimationAdress(character: Model, catagory: string): AnimationAdress
	Animations[character] = Animations[character] or {}
	Animations[character][catagory] = Animations[character][catagory] or {}
	return Animations[character][catagory]
end

local function findAnimationTrack(character: Model, catagory: string, animationID: AnimationID): AnimationTrack?
	local animationAdress = getAnimationAdress(character, catagory)
	local animationData = animationAdress[animationID]
	if animationData then
		local track = animationData.AnimationTrack
		if track and track.Parent then -- ✅ safety check
			return track
		else
			animationAdress[animationID] = nil
		end
	end
	return nil
end

local function LoadAnimation(character: Model, animationID: AnimationID, catagory: string?, keyframeCallback: KeyframeCallback?): AnimationTrack?
	local catagory = catagory or NO_CATEGORY
	local animationID = sanitizeAnimationID(animationID)
	local animationAdress = getAnimationAdress(character, catagory)

	if animationAdress[animationID] then return animationAdress[animationID].AnimationTrack end

	local animator = getAnimator(character)
	if not animator then return end

	local animation = getAnimation(animationID)
	local animationTrack = animator:LoadAnimation(animation)

	local keyframeConnection: RBXScriptConnection? = nil
	if keyframeCallback then
		keyframeConnection = animationTrack.KeyframeReached:Connect(keyframeCallback)
	end

	animationAdress[animationID] = {
		Connection = keyframeConnection,
		AnimationTrack = animationTrack,
	}

	animation:Destroy()

	return animationTrack
end

local function PlayAnimation(character: Model, animationID: AnimationID, catagory: string?, fadeTime: number?, speed: number?, weight: number?)
	local catagory = catagory or NO_CATEGORY
	local sanitizeID = sanitizeAnimationID(animationID)
	local animationTrack = findAnimationTrack(character, catagory, sanitizeID) or LoadAnimation(character, sanitizeID, catagory)
	if animationTrack then
		animationTrack:Play(fadeTime, weight, speed)
	end
end

local function GetAnimationTrack(character: Model, animationID: AnimationID, catagory: string?): AnimationTrack?
	local catagory = catagory or NO_CATEGORY
	local sanitizeID = sanitizeAnimationID(animationID)
	return findAnimationTrack(character, catagory, sanitizeID)
end

local function GetAnimationTrackList(character: Model, catagory: string?): {AnimationTrack}
	local catagory = catagory or NO_CATEGORY
	local adress = getAnimationAdress(character, catagory)
	local tracks = {}
	for _, data in adress do
		if data.AnimationTrack and data.AnimationTrack.Parent then
			table.insert(tracks, data.AnimationTrack)
		end
	end
	return tracks
end

local function DisconnectKeyframeConnection(character: Model, animationID: AnimationID, catagory: string?)
	local catagory = catagory or NO_CATEGORY
	local sanitizeID = sanitizeAnimationID(animationID)
	local adress = getAnimationAdress(character, catagory)
	local data = adress[sanitizeID]
	if data and data.Connection then
		data.Connection:Disconnect()
		data.Connection = nil
	end
end

local function StopAnimation(character: Model, animationID: AnimationID, catagory: string?)
	local track = GetAnimationTrack(character, animationID, catagory)
	if track then
		track:Stop()
	end
end

local function RemoveAnimation(character: Model, animationID: AnimationID, catagory: string?)
	local catagory = catagory or NO_CATEGORY
	local sanitizeID = sanitizeAnimationID(animationID)
	local adress = getAnimationAdress(character, catagory)
	local data = adress[sanitizeID]
	if data then
		if data.Connection then
			data.Connection:Disconnect()
		end
		data.AnimationTrack:Stop()
		data.AnimationTrack:Destroy()
		adress[sanitizeID] = nil
	end
end

local function RemoveAnimationInCategory(character: Model, catagory: string)
	local adress = getAnimationAdress(character, catagory)
	for animID, data in adress do
		if data.Connection then
			data.Connection:Disconnect()
		end
		data.AnimationTrack:Stop()
		data.AnimationTrack:Destroy()
		adress[animID] = nil
	end
	Animations[character][catagory] = nil
end

local function RemoveAll(character: Model)
	if not Animations[character] then return end
	for catagory, _ in pairs(Animations[character]) do
		RemoveAnimationInCategory(character, catagory)
	end
	Animations[character] = nil
end

return {
	Load = LoadAnimation,
	Play = PlayAnimation,
	Stop = StopAnimation,

	DisconnectKeyframe = DisconnectKeyframeConnection,

	GetTrack = GetAnimationTrack,
	GetList = GetAnimationTrackList,

	Remove = RemoveAnimation,
	RemoveAllInCategory = RemoveAnimationInCategory,
	RemoveAll = RemoveAll,
}
