print("universal 😨🟢😨🤯😨💭🤡⚠👀🛠🗣🛠🆘👀🏃‍♂️💿💭🎃🤣😭👀😈🟡🎫🟡😚🎫😧🤣🎮🎫👀🤣😀👑😎🏃‍♂️💿")

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

task.spawn(shared.Functions.SetupCharacterConnection, shared.Character)
shared.Library:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, shared.Functions.SetupCharacterConnection, newCharacter)
end))


--// OnChanged \\--
Toggles.Fly:OnChanged(function(value)
    if not shared.Fly.FlyBody then shared.Fly:Setup() end

    shared.Fly:Set(value)
end)
Options.FlySpeed:OnChanged(function(value)
    shared.Fly:SetSpeed(value)
end)

getgenv().mspaint_loaded = true