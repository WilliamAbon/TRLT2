local CAS = game:GetService("ContextActionService")
local mouse = game:GetService("Players").LocalPlayer:GetMouse()

local PlankModule = {}

function PlankModule.Setup(actionName, onSelectCallback)
    CAS:BindAction(
        actionName,
        function(name, state, input)
            if state == Enum.UserInputState.Begin and mouse.Target then
                onSelectCallback(mouse.Target)
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

return PlankModule -- PASTIKAN TIDAK ADA TANDA KURUNG DI SINI
