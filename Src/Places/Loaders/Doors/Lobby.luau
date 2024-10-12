--// Loading Wait \\--
if shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and shared.LocalPlayer.PlayerGui.LoadingUI.Enabled then
    repeat task.wait() until not shared.LocalPlayer.PlayerGui.LoadingUI.Enabled
end

--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script

Script.CurrentBadge = 0
Script.Achievements = {
    "SurviveWithoutHiding",
    "SurviveGloombats",
    "SurviveSeekMinesSecond",
    "TowerHeroesGoblino",
    "EscapeBackdoor",
    "SurviveFiredamp",
    "CrucifixDread",
    "EnterRooms",
    "EncounterVoid",
    "Join",
    "DeathAmt100",
    "UseCrucifix",
    "EncounterSpider",
    "SurviveHalt",
    "SurviveRush",
    "DeathAmt10",
    "Revive",
    "PlayFriend",
    "SurviveNest",
    "CrucifixFigure",
    "CrucifixAmbush",
    "PlayerBetrayal",
    "SurviveEyes",
    "KickGiggle",
    "EscapeMines",
    "GlowstickGiggle",
    "DeathAmt1",
    "SurviveSeek",
    "UseRiftMutate",
    "CrucifixGloombatSwarm",
    "SurviveScreech",
    "SurviveDread",
    "SurviveSeekMinesFirst",
    "CrucifixHalt",
    "TowerHeroesVoid",
    "JoinLSplash",
    "CrucifixDupe",
    "EncounterGlitch",
    "JeffShop",
    "CrucifixScreech",
    "SurviveGiggle",
    "EscapeHotelMod1",
    "SurviveDupe",
    "CrucifixRush",
    "EscapeBackdoorHunt",
    "EscapeHotel",
    "CrucifixGiggle",
    "EscapeFools",
    "UseRift",
    "SpecialQATester",
    "EscapeRetro",
    "TowerHeroesHard",
    "EnterBackdoor",
    "EscapeRooms1000",
    "EscapeRooms",
    "EscapeHotelMod2",
    "EncounterMobble",
    "CrucifixGrumble",
    "UseHerbGreen",
    "CrucifixSeek",
    "JeffTipFull",
    "SurviveFigureLibrary",
    "TowerHeroesHotel",
    "CrucifixEyes",
    "BreakerSpeedrun",
    "SurviveAmbush",
    "SurviveHide",
    "JoinAgain"
}
Script.ElevatorPresetData = {}
Script.ElevatorPresets = {}

local presetHelper = wax.shared.FileHelper.new("mspaint/doors/presets")

function Script.Functions.File.CreatePreset(name: string, data: table)
    local presetData = Script.Functions.EnforceTypes(data, {
        Floor = "Hotel",
        MaxPlayers = 1,
        Modifiers = nil,
        FriendsOnly = true
    })

    presetHelper.CreateFile(name .. ".json", shared.HttpService:JSONEncode(presetData))
end

function Script.Functions.File.LoadPresets()
    table.clear(Script.ElevatorPresets)
    table.clear(Script.ElevatorPresetData)

    for _, file in pairs(listfiles("mspaint/doors/presets")) do
        local success, ret = pcall(function()
            local data = readfile(file)
            return HttpService:JSONDecode(data)
        end)

        if success then
            local name = Script.Functions.File.GetFileNameFromPath(file)

            Script.ElevatorPresetData[name] = Script.Functions.EnforceTypes(ret, {
                Floor = "Hotel",
                MaxPlayers = 1,
                Modifiers = nil,
                FriendsOnly = true
            })

            table.insert(Script.ElevatorPresets, name)
        else
            Script.Functions.Alert("Failed to load preset: " .. file)
        end
    end

    Options.Elevator_PresetList:SetValues(Script.ElevatorPresets)
    Options.Elevator_PresetList:SetValue(nil)
end

function Script.Functions.LoadPreset(name: string)
    Script.Functions.File.BuildPresetStructure()

    local success, ret = pcall(function()
        local data = readfile("mspaint/doors/presets/" .. name .. ".json")
        return HttpService:JSONDecode(data)
    end)

    if not success then
        Script.Functions.Alert("Failed to load preset: " .. name .. ".json")
        return
    end

    local presetData = Script.Functions.EnforceTypes(ret, {
        Floor = "Hotel",
        MaxPlayers = 1,
        Modifiers = nil,
        FriendsOnly = true
    })

    local data = {
        ["FriendsOnly"] = presetData.FriendsOnly,
        ["Destination"] = presetData.Floor,
        ["Mods"] = presetData.Modifiers or {},
        ["MaxPlayers"] = tostring(presetData.MaxPlayers)
    }

    createElevator:FireServer(data)

    Script.Functions.Alert("Loaded elevator preset: " .. name)
end

function Script.Functions.SetupVariables()
    if shared.ExecutorSupport["require"] then
        for achievementName, _ in pairs(require(game:GetService("ReplicatedStorage").Achievements)) do
            if table.find(Script.Achievements, achievementName) then continue end
    
            table.insert(Script.Achievements, achievementName)
        end
    else
        local badgeList = achievementsFrame:WaitForChild("List", math.huge)

        if badgeList then
            repeat task.wait(.5) until #badgeList:GetChildren() ~= 0
            
            shared.Library:GiveSignal(badgeList.ChildAdded:Connect(function(badge)
                if not badge:IsA("ImageButton") then return end
                if table.find(Script.Achievements, badge.Name) then return end
                table.insert(Script.Achievements, badge.Name)
            end))

            for _, badge in pairs(badgeList:GetChildren()) do
                if not badge:IsA("ImageButton") then continue end
                if table.find(Script.Achievements, badge.Name) then continue end

                table.insert(Script.Achievements, badge.Name)
            end
        end
    end
end

shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()

--// Code \\--
function Script.Functions.SetupCharacterConnection(newCharacter)
    shared.Character = newCharacter
    shared.Humanoid = shared.Character:FindFirstChildWhichIsA("Humanoid")
    shared.RootPart = shared.Character:FindFirstChild("HumanoidRootPart") or shared.Character.PrimaryPart
end

task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)
shared.Library:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))


getgenv().mspaint_loaded = true