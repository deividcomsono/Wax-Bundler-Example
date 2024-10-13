--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
Script.FeatureConnections = {
    Character = {},
    Humanoid = {},
    Player = {},
    RootPart = {},
}
Script.ESPTable = {
    Player = {},
    None = {}
}

shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()

--// Functions \\--
shared.Load("Utils", "ESP")

shared.Load("Utils", "ConnectionsFuncs")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("Main"),
    Visuals = shared.Window:AddTab("Visuals")
}

shared.Load("Tabs", "Main")
shared.Load("Tabs", "Visuals")

--// Code \\--

--// Players Connection \\--
for _, player in pairs(shared.Players:GetPlayers()) do
    if player == shared.LocalPlayer then continue end
    Script.Functions.SetupOtherPlayerConnection(player)
end
shared.Connect:GiveSignal(shared.Players.PlayerAdded:Connect(Script.Functions.SetupOtherPlayerConnection))

--// Local Player Connection \\--
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))

--// Run Service \\--
shared.Connect:GiveSignal(shared.RunService.RenderStepped:Connect(function()
    if shared.Character then
        if shared.Humanoid then
            if Toggles.SpeedHack.Value then shared.Humanoid.WalkSpeed = Options.WalkSpeed.Value end
            if Toggles.JumpPowerHack.Value then shared.Humanoid.JumpPower = Options.JumpPower.Value end
        end

        if Toggles.Noclip.Value then
            for _, part in pairs(shared.Character:GetDescendants()) do
                if not part:IsA("BasePart") then continue end
                part.CanCollide = false
            end        
        end
    end
end))

--// Load \\--
task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)

getgenv().mspaint_loaded = true