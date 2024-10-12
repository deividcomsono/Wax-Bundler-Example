if getgenv().mspaint_is_loading then return end
getgenv().mspaint_is_loading = true

shared.HttpService = game:GetService("HttpService")
shared.Players = game:GetService("Players")
shared.ReplicatedStorage = game:GetService("ReplicatedStorage")
shared.Workspace = game:GetService("Workspace")
shared.RunService = game:GetService("RunService")
shared.UserInputService = game:GetService("UserInputService")

if not wax.shared.ExecutorSupport then
    wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
end

if not wax.shared.BloxstrapRPC then
    wax.shared.BloxstrapRPC = require("Utils/BloxstrapRPC")
end

shared.ScriptLoader = "Universal"
shared.PlaceName = "Universal"

local Mappings = require("Mappings")

local MappingID = Mappings[game.GameId]
if MappingID then
    local Folder = MappingID["Folder"]
    local Exclusion = MappingID["Exclusions"][game.PlaceId]

    shared.PlaceName = Folder
    shared.ScriptLoader = Folder .. "/" .. MappingID["Main"]

    if Exclusion then
        shared.PlaceName = Folder .. " (" .. Exclusion .. ")"
        shared.ScriptLoader = Folder .. "/" .. Exclusion
    end
end


local UICreator = require("Utils/GUI/Creator")
shared.Window = UICreator:CreateWindow()

require("Places/" .. shared.ScriptLoader)
UICreator:CreateSettingsTab()
require("Utils/GUI/Addons")
getgenv().mspaint_is_loading = false