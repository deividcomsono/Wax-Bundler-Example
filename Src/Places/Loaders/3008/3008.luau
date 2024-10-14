--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script

Script.DidGodmode = false

Script.DefaultFogEnd = shared.Lighting.FogEnd

Script.CurrentAmbient = shared.Lighting.Ambient
Script.CurrentColorShift_Bottom = shared.Lighting.ColorShift_Bottom
Script.CurrentColorShift_Top = shared.Lighting.ColorShift_Top
if shared.Lighting:FindFirstChild("FoggyDay_Atmosphere") then
    Script.CurrentFoggyDayDensity = shared.Lighting["FoggyDay_Atmosphere"].Density
end

Script.Physical = workspace:WaitForChild("GameObjects"):WaitForChild("Physical")
Script.Map = Script.Physical:WaitForChild("Map")
Script.Employees = Script.Physical:WaitForChild("Employees")

--// Player Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()
shared.Humanoid = nil

Script.System = shared.Character:WaitForChild("System")
Script.Event = Script.System:WaitForChild("Event")
Script.Action = Script.System:WaitForChild("Action")

Script.DeathScreen = shared.PlayerGui:WaitForChild("DeathScreen")
Script.Settings = shared.PlayerGui:WaitForChild("PlayerInfo"):WaitForChild("Settings")
Script.PlayerStats = shared.PlayerGui:WaitForChild("MainGui"):WaitForChild("PlayerStats")

Script.ToolSystem = shared.PlayerScripts:WaitForChild("source"):WaitForChild("client"):WaitForChild("ToolSystem")

--// Functions \\--
Script._mspaint_custom_captions = Instance.new("ScreenGui") do
    local Frame = Instance.new("Frame", Script._mspaint_custom_captions)
    local TextLabel = Instance.new("TextLabel", Frame)
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)

    Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    Script._mspaint_custom_captions.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = shared.Library.MainColor
    Frame.BorderColor3 = shared.Library.AccentColor
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    Frame.Size = UDim2.new(0, 200, 0, 75)
    shared.Library:AddToRegistry(Frame, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "AccentColor"
    })

    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = ""
    TextLabel.TextColor3 = shared.Library.FontColor
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    shared.Library:AddToRegistry(TextLabel, {
        TextColor3 = "FontColor"
    })

    UITextSizeConstraint.MaxTextSize = 35

    function Script.Functions.HideCaptions()
        Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    end

    local CaptionsLastUsed = os.time()
    function Script.Functions.Captions(caption: string)
        CaptionsLastUsed = os.time()

        if Script._mspaint_custom_captions.Parent == shared.ReplicatedStorage then
            local success = pcall(function()
                Script._mspaint_custom_captions.Parent = if gethui then gethui() else game:GetService("CoreGui")
            end)

            if not success then
                Script._mspaint_custom_captions.Parent = shared.PlayerGui
            end 
        end
        
        TextLabel.Text = caption

        task.spawn(function()
            task.wait(5)
            if os.time() - CaptionsLastUsed >= 5 then
                Script.Functions.HideCaptions()
            end
        end)
    end
end

function Script.Functions.DistanceFromCharacter(position: Instance | Vector3, getPositionFromCamera: boolean | nil)
    if not position then return 9e9 end
    if typeof(position) == "Instance" then
        position = position:GetPivot().Position
    end

    if getPositionFromCamera and (shared.Camera or workspace.CurrentCamera) then
        local cameraPosition = if shared.Camera then shared.Camera.CFrame.Position else workspace.CurrentCamera.CFrame.Position

        return (cameraPosition - position).Magnitude
    end

    if shared.RootPart then
        return (shared.RootPart.Position - position).Magnitude
    elseif shared.Camera then
        return (shared.Camera.CFrame.Position - position).Magnitude
    end

    return 9e9
end

function Script.Functions.CameraChildAdded(child)
    if Toggles.AutoTPWhistle.Value then
        for playerName, _ in pairs(Options.AutoTPWhistlePlayers.Value) do
            if child.Name == playerName .. "_EchoLocation" then
                shared.Character:PivotTo(child.CFrame)
            end
        end
    end
end

function Script.Functions.IsNaN(x)
    return x ~= x
end

function Script.Functions.Respawn()
    if shared.Humanoid.Health > 0 or Script.Functions.IsNaN(shared.Humanoid.Health) then
        shared.Character:BreakJoints()
    end

    repeat task.wait(0.1) until Script.DeathScreen.BG.Visible
    
    Script.Event:FireServer("Respawn")

    Script.DeathScreen.DeathSound:Stop()
    Script.DeathScreen.DeathMusic:Stop()
end

shared.Load("Utils", "ConnectionsFuncs")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("Main"),
    Exploits = shared.Window:AddTab("Exploits"),
    Visuals = shared.Window:AddTab("Visuals"),
}

shared.Load("Tabs", "Main")
shared.Load("Tabs", "Exploits")
shared.Load("Tabs", "Visuals")
--// Metamethod hooks \\--

--// Function hooks \\--
if wax.shared.ExecutorSupport["hookfunction"] and wax.shared.ExecutorSupport["getcallingscript"] then
    shared.Hooks.instantInteract = hookfunction(TweenInfo.new, newcclosure(function(self, ...)
        if Toggles.InstantInteract.Value then
            local caller = getcallingscript()

            local isInputController = caller and caller.Name == "InputControl"
            local isValidArgument = self and typeof(self) == "number"

            if isInputController and isValidArgument then
                self = 0
            end
        end

        return shared.Hooks.instantInteract(self, ...)
    end))
end

if wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"] then
    if wax.shared.ExecutorSupport["require"] then
        Script.ToolGStep = wax.require(Script.ToolSystem).GlobalRenderStep
    end

    shared.Hooks.mtHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Toggles.InfiniteInventory.Value and wax.shared.ExecutorSupport["require"] then
            if method == "InvokeServer" and self.Name == "Action" and args[1] == "Store" and args[3] ~= "_internal_origin_mspaint" then
                require(Script.ToolSystem).GlobalRenderStep = function() end
                local parentedTools = {}
                
                for _, tool in pairs(shared.LocalPlayer.Backpack:GetChildren()) do
                    table.insert(parentedTools, tool)
                
                    shared.Humanoid:EquipTool(tool)
                    tool.Parent = workspace
                end

                task.wait()
                local modelName = args[2].Model.Name

                Script.Action:InvokeServer("Store", args[2], "_internal_origin_mspaint")
                
                local newTool = shared.LocalPlayer.Backpack:WaitForChild(modelName)

                shared.Humanoid:EquipTool(newTool)

                for _, tool in pairs(parentedTools)  do
                    tool.Parent = shared.Character
                    shared.Humanoid:EquipTool(tool)
                end
                
                shared.Humanoid:UnequipTools()

                require(Script.ToolSystem).GlobalRenderStep = Script.ToolGStep
                return
            end
        end
        
        return shared.Hooks.mtHook(self, ...)
    end))
end

--// Connections \\--
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))

shared.Connect:GiveSignal(shared.Camera.ChildAdded:Connect(Script.Functions.CameraChildAdded))

--// Load \\--
task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)
task.spawn(Script.Functions.SetupLightingConnection)
task.spawn(Script.Functions.SetupExploitInfModulesConnection)

for _, child in pairs(shared.Camera:GetChildren()) do
    Script.Functions.CameraChildAdded(child)
end

--// Unload \\--
shared.Library:OnUnload(function()
    if wax.shared.ExecutorSupport["hookfunction"] and wax.shared.ExecutorSupport["getcallingscript"] then
        hookfunction(TweenInfo.new, shared.Hooks.instantInteract)
    end

    if wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"] then
        hookmetamethod(game, "__namecall", shared.Hooks.mtHook)
    end
end)

getgenv().mspaint_loaded = true