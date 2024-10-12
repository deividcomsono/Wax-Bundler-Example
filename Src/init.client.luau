if getgenv().mspaint_loading then  print("[mspaint] Loading stopped. (ERROR: Loading)") return end
if getgenv().mspaint_loaded then print("[mspaint] Loading stopped. (ERROR: Already loaded)") return end

getgenv().mspaint_loading = true

--// Services \\--
local Services = require("Utils/Services")
Services:GetServices({
    "Players",
    "UserInputService",
    "TextChatService",
    "ProximityPromptService",

    "Workspace",
    "Lighting",
    "ReplicatedStorage",

    "HttpService",
    "RunService",
    "SoundService"
})

--// Utils \\--
if not wax.shared.ExecutorSupport then
    wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
end

if not wax.shared.BloxstrapRPC then
    wax.shared.BloxstrapRPC = require("Utils/BloxstrapRPC")
end

--// mspaint Loader \\--
if not wax.shared.GotPlace then
    wax.shared.GotPlace = true

    shared.ScriptName = "Universal"
    shared.ScriptLoader = "Universal"
    
    local Mappings = require("Mappings")
    
    local MappingID = Mappings[game.GameId]
    if MappingID then
        local Folder = MappingID["Folder"]
        local Name = MappingID["Name"] or Folder
        local Exclusion = MappingID["Exclusions"][game.PlaceId]
    
        shared.ScriptName = Name
        shared.ScriptLoader = Folder .. "/" .. MappingID["Main"]
    
        if Exclusion then
            shared.ScriptName = Name .. " (" .. Exclusion .. ")"
            shared.ScriptLoader = Folder .. "/" .. Exclusion
        end
    end
end

--// Global functions \\--
shared.Functions = {}

shared.EnforceTypes = require("Utils/EnforceTypes")
shared.Logs = require("Utils/Logs")
shared.Connect = require("Utils/Connections")

--// Player Variables \\--
shared.Camera = workspace.CurrentCamera

shared.LocalPlayer = shared.Players.LocalPlayer
shared.PlayerGui = shared.LocalPlayer.PlayerGui
shared.PlayerScripts = shared.LocalPlayer.PlayerScripts

shared.Fly = require("Utils/Universal/Fly")
shared.ControlModule = require("Utils/Universal/ControlModule")

--// Load \\--
shared.Connect:GiveSignal(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera = workspace.CurrentCamera
end))

local UICreator = require("Utils/GUI/Creator")
shared.Window = UICreator:CreateWindow()

require("Places/" .. shared.ScriptLoader)

UICreator:CreateSettingsTab()
require("Utils/GUI/Addons")

getgenv().mspaint_loading = false