local CAS = game:GetService("ContextActionService")
local mouse = game:GetService("Players").LocalPlayer:GetMouse()

local PlankModule = {}

function PlankModule.Setup(actionName, cooldown, onSelectCallback)
    CAS:BindAction(
        actionName,
        function(name, state, input)
            if state ~= Enum.UserInputState.Begin then
                return Enum.ContextActionResult.Pass
            end

            local target = mouse.Target
            if onSelectCallback then
                onSelectCallback(target)
            end

            return Enum.ContextActionResult.Sink
        end,
        true,
        Enum.UserInputType.MouseButton1,
        Enum.UserInputType.Touch
    )
end

function PlankModule.Cleanup(actionName)
    CAS:UnbindAction(actionName)
end

return PlankModule
