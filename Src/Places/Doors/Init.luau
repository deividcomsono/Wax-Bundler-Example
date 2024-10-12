--// Loading Wait \\--
if shared.LocalPlayer and shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and shared.LocalPlayer.PlayerGui.LoadingUI.Enabled then
    print("[mspaint] Waiting for game to load...")
    repeat task.wait() until not shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and true or not shared.LocalPlayer.PlayerGui.LoadingUI.Enabled
end

--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()

--// Code \\--
if shared.ScriptName == "DOORS (Lobby)" then

else
    
end

function shared.Functions.SetupCharacterConnection(newCharacter)
    shared.Character = newCharacter
    shared.Humanoid = shared.Character:FindFirstChildWhichIsA("Humanoid")
    shared.RootPart = shared.Character:FindFirstChild("HumanoidRootPart") or shared.Character.PrimaryPart
end

task.spawn(shared.Functions.SetupCharacterConnection, shared.Character)
shared.Library:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, shared.Functions.SetupCharacterConnection, newCharacter)
end))