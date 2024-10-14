--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script

--// Functions \\--
function Script.Functions.SetupCharacterConnection(newCharacter)
    shared.Character = newCharacter
    shared.Humanoid = shared.Character:WaitForChild("Humanoid")

    Script.System = shared.Character:WaitForChild("System")
    Script.Event = Script.System:WaitForChild("Event")
    Script.Action = Script.System:WaitForChild("Action")

    Script.Functions.SetupCharacterDeathConnection(newCharacter)

    if shared.Humanoid then
        Script.LastSpeed = shared.Humanoid.WalkSpeed
        Script.LastJumpPower = shared.Humanoid.UseJumpPower and shared.Humanoid.JumpPower or shared.Humanoid.JumpHeight

        if Toggles.SpeedHack.Value then shared.Humanoid.WalkSpeed = Options.WalkSpeed.Value end
        
        if Toggles.JumpPowerHack.Value then
            if shared.Humanoid.UseJumpPower then
                shared.Humanoid.JumpPower = Options.JumpPower.Value
            else
                shared.Humanoid.JumpHeight = Options.JumpPower.Value
            end
        end

        shared.Connect:GiveSignal(shared.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if shared.Humanoid.WalkSpeed ~= Options.WalkSpeed.Value then
                Script.LastSpeed = shared.Humanoid.WalkSpeed
                if Toggles.SpeedHack.Value then shared.Humanoid.WalkSpeed = Options.WalkSpeed.Value end
            end
        end))

        shared.Connect:GiveSignal(shared.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if not shared.Humanoid.UseJumpPower then return end
            if shared.Humanoid.JumpPower ~= Options.JumpPower.Value then
                Script.LastJumpPower = shared.Humanoid.JumpPower
                if Toggles.JumpPowerHack.Value then shared.Humanoid.JumpPower = Options.JumpPower.Value end
            end
        end))
        shared.Connect:GiveSignal(shared.Humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
            if shared.Humanoid.UseJumpPower then return end
            if shared.Humanoid.JumpHeight ~= Options.JumpPower.Value then
                Script.LastJumpPower = shared.Humanoid.JumpHeight
                if Toggles.JumpPowerHack.Value then shared.Humanoid.JumpHeight = Options.JumpPower.Value end
            end
        end))
    end

    if Toggles.Godmode.Value then
        Script.DidGodmode = true

        repeat task.wait() until #Script.Map.Floor:GetChildren() > 0
        
        Script.Event:FireServer("FallDamage", {
            Sliding = false,
            OriginalDamage = (0/0),
            Sound = "LR^SS",
            Softened = true,
            Broken = false,
            Model = Script.Map.Floor:FindFirstChildOfClass("Model"),
            Range = 19,
            Damage = (0/0)
        })
    end

    if Toggles.NoFall.Value then
        local fallDamage = shared.Character:WaitForChild("FallDamage")
        if fallDamage then
            fallDamage.Enabled = false
        end
    end

    shared.RootPart = shared.Character:WaitForChild("HumanoidRootPart")
end

function Script.Functions.SetupCharacterDeathConnection(newCharacter)
    shared.Connect:GiveSignal(newCharacter:WaitForChild("Humanoid").Died:Connect(function()
        if Toggles.AutoRespawn.Value then
            Script.Functions.Respawn()
        end
    end))
end

function Script.Functions.SetupLightingConnection()
    shared.Connect:GiveSignal(shared.Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
        if shared.Lighting.Ambient ~= Script.CurrentAmbient and shared.Lighting.Ambient ~= Color3.new(1, 1, 1) then
            Script.CurrentAmbient = shared.Lighting.Ambient
        end

        if Toggles.Fullbright.Value then
            shared.Lighting.Ambient = Color3.new(1, 1, 1)
        end
    end))

    shared.Connect:GiveSignal(shared.Lighting:GetPropertyChangedSignal("ColorShift_Bottom"):Connect(function()
        if shared.Lighting.ColorShift_Bottom ~= Script.CurrentColorShift_Bottom and shared.Light.ColorShift_Bottom ~= Color3.new(1, 1, 1) then
            Script.CurrentColorShift_Bottom = shared.Lighting.ColorShift_Bottom
        end

        if Toggles.Fullbright.Value then
            shared.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        end
    end))

    shared.Connect:GiveSignal(shared.Lighting:GetPropertyChangedSignal("ColorShift_Top"):Connect(function()
        if shared.Lighting.ColorShift_Top ~= Script.CurrentColorShift_Top and shared.Light.ColorShift_Top ~= Color3.new(1, 1, 1) then
            Script.CurrentColorShift_Top = shared.Lighting.ColorShift_Top
        end

        if Toggles.Fullbright.Value then
            shared.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        end
    end))

    if shared.Lighting:FindFirstChild("FoggyDay_Atmosphere") then
        shared.Connect:GiveSignal(shared.Lighting["FoggyDay_Atmosphere"]:GetPropertyChangedSignal("Density"):Connect(function()
            if shared.Lighting["FoggyDay_Atmosphere"].Density ~= Script.CurrentFoggyDayDensity and shared.Lighting["FoggyDay_Atmosphere"].Density ~= 0 then
                Script.CurrentFoggyDayDensity = shared.Lighting["FoggyDay_Atmosphere"].Density
            end

            if Toggles.NoFog.Value then
                shared.Lighting["FoggyDay_Atmosphere"].Density = 0
            end
        end))
    end

    if Toggles.Fullbright.Value then
        shared.Lighting.Ambient = Color3.new(1, 1, 1)
        shared.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        shared.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    end

    if Toggles.NoFog.Value then
        shared.Lighting.FogEnd = 9e9

        if shared.Lighting:FindFirstChild("FoggyDay_Atmosphere") then
            shared.Lighting["FoggyDay_Atmosphere"].Density = 0
        end
    end
end