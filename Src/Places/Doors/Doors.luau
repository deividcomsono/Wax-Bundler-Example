print("doors game")


shared.Library:AddSignal(shared.RunService.RenderStepped:Connect(function()
    --[[
    if shared.Toggles.ShowCustomCursor and not shared.Toggles.ShowCustomCursor.Value and shared.Library.Toggled then
        shared.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        shared.UserInputService.MouseIcon = "rbxassetid://2833720882"
        shared.UserInputService.MouseIconEnabled = true
    end
    ]]
end))

getgenv().mspaint_loaded = true