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

function Script.Functions.SetupCameraConnection(child)
    if Toggles.AutoTPWhistle.Value then
        for playerName, _ in pairs(Options.AutoTPWhistlePlayers.Value) do
            if child.Name == playerName .. "_EchoLocation" then
                shared.Character:PivotTo(child.CFrame)
            end
        end
    end
end