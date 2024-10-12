--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()

--// Linoria Elements \\--
local Tabs = {
    Main = shared.Window:AddTab("Main")
}

local PlayerGroupBox = Tabs.Main:AddLeftGroupbox("Player") do
    PlayerGroupBox:AddToggle("SpeedHack", {
        Text = "Speed Hack",
        Default = false
    })

    PlayerGroupBox:AddSlider("WalkSpeed", {
        Text = "Walk Speed",
        Default = 16,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Compact = true
    })

    PlayerGroupBox:AddToggle("JumpPowerHack", {
        Text = "Jump Power Hack",
        Default = false
    })

    PlayerGroupBox:AddSlider("JumpPower", {
        Text = "Jump Power",
        Default = 50,
        Min = 0,
        Max = 200,
        Rounding = 0,
        Compact = true
    })

    PlayerGroupBox:AddDivider()

    PlayerGroupBox:AddToggle("Noclip", {
        Text = "Noclip",
        Default = false
    }):AddKeyPicker("NoclipKey", {
        Mode = "Toggle",
        Default = "N",
        Text = "Noclip",
        SyncToggleState = true
    })

    PlayerGroupBox:AddToggle("Fly", {
        Text = "Fly",
        Default = false
    }):AddKeyPicker("FlyKey", {
        Mode = "Toggle",
        Default = "F",
        Text = "Fly",
        SyncToggleState = true
    })
    
    PlayerGroupBox:AddSlider("FlySpeed", {
        Text = "Fly Speed",
        Default = 15,
        Min = 10,
        Max = 22,
        Rounding = 1,
        Compact = true
    })
end

--// Code \\--
function shared.Functions.SetupCharacterConnection(newCharacter)
    shared.Character = newCharacter
    shared.Humanoid = shared.Character:FindFirstChildWhichIsA("Humanoid")
    shared.RootPart = shared.Character:FindFirstChild("HumanoidRootPart") or shared.Character.PrimaryPart
end

--// OnChanged \\--
Toggles.Noclip:OnChanged(function(value)
    if not shared.Character then return end

    for _, part in pairs(shared.Character:GetDescendants()) do
        if not part:IsA("BasePart") then continue end
        part.CanCollide = value
    end
end)

Toggles.Fly:OnChanged(function(value)
    if not shared.Fly.FlyBody then shared.Fly:Setup() end

    shared.Fly:Set(value)
end)
Options.FlySpeed:OnChanged(function(value)
    shared.Fly:SetSpeed(value)
end)


--// Load \\--
task.spawn(shared.Functions.SetupCharacterConnection, shared.Character)
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, shared.Functions.SetupCharacterConnection, newCharacter)
end))

shared.Connect:GiveSignal(shared.RunService.RenderStepped:Connect(function()
    if shared.Character then
        if shared.Humanoid then
            if Toggles.SpeedHack.Value then shared.Humanoid.WalkSpeed = Options.WalkSpeed.Value end

        end

        for _, part in pairs(shared.Character:GetDescendants()) do

        end
    end
end))

getgenv().mspaint_loaded = true