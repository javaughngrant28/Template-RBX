

local UIAdded = require(script.Parent.Parent.Components.UIAdded)

local function Update(countdownTextLable: TextLabel,titleValue: StringValue?, countdownGoal: number, number: number)
    if not countdownTextLable then return end

    number = countdownGoal - os.time()
    if number < 0 then
        number = 0
    end
    
    if titleValue then
        countdownTextLable.Text =  `{titleValue.Value} {number}`
        else
            countdownTextLable.Text =  `{number}`
    end
end


UIAdded.new('TitleCountdown',function(screenGui: ScreenGui)
    local titleValue = screenGui:FindFirstChild('TitleValue') :: StringValue
    local countDownGoalValue = screenGui:FindFirstChild('CountDownGoal') :: StringValue
    
    assert(countDownGoalValue and countDownGoalValue:IsA('StringValue'), 'Timer Goal StringValue Invalid Or Missing')

    local countdownTextLable = screenGui:FindFirstChild('CountdownText', true) :: TextLabel

    assert(countdownTextLable,`'{countdownTextLable}: Countdown TextLable`)

    local countdownGoal = tonumber(countDownGoalValue.Value)
    local number = 1


    countdownTextLable.Visible = true

    while screenGui and screenGui.Parent and number > 0 do
        Update(countdownTextLable, titleValue,countdownGoal,number)
        task.wait(1)
    end
end)