--// Loading Wait \\--
if shared.LocalPlayer and shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and shared.LocalPlayer.PlayerGui.LoadingUI.Enabled then
    print("[mspaint] Waiting for game to load...")
    repeat task.wait() until not shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and true or not shared.LocalPlayer.PlayerGui.LoadingUI.Enabled
end

--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
Script.FeatureConnections = {
    Character = {},
    Clip = {},
    Door = {},
    Humanoid = {},
    Player = {},
    Pump = {},
    RootPart = {},
}
Script.ESPTable = {
    Chest = {},
    Door = {},
    Entity = {},
    SideEntity = {},
    Gold = {},
    Guiding = {},
    DroppedItem = {},
    Item = {},
    Objective = {},
    Player = {},
    HidingSpot = {},
    None = {}
}

Script.Functions.Minecart = {}

Script.Temp = {
    AnchorFinished = {},
    AutoWardrobeEntities = {},
    Bridges = {},
    CollisionSize = Vector3.new(5.5, 3, 3),
    Guidance = {},
    PaintingDebounce = {},
    UsedBreakers = {},
}

Script.FakeRevive = {
    Debounce = false,
    Enabled = false,
    Connections = {}
}

Script.WhitelistConfig = {
    [45] = {firstKeep = 3, lastKeep = 2},
    [46] = {firstKeep = 2, lastKeep = 2},
    [47] = {firstKeep = 2, lastKeep = 2},
    [48] = {firstKeep = 2, lastKeep = 2},
    [49] = {firstKeep = 2, lastKeep = 4},
}

Script.SuffixPrefixes = {
    ["Backdoor"] = "",
    ["Ceiling"] = "",
    ["Moving"] = "",
    ["Ragdoll"] = "",
    ["Rig"] = "",
    ["Wall"] = "",
    ["Clock"] = " Clock",
    ["Key"] = " Key",
    ["Pack"] = " Pack",
    ["Pointer"] = " Pointer",
    ["Swarm"] = " Swarm",
}

Script.PrettyFloorName = {
    ["Fools"] = "Super Hard Mode",
}

Script.EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "Dread", "A60", "A120"},
    ["SideNames"] = {"FigureRig", "GiggleCeiling", "GrumbleRig", "Snare"},
    ["ShortNames"] = {
        ["BackdoorRush"] = "Blitz",
        ["JeffTheKiller"] = "Jeff The Killer"
    },
    ["NotifyMessage"] = {
        ["GloombatSwarm"] = "Gloombats in next room!"
    },
    ["Avoid"] = {
        "RushMoving",
        "AmbushMoving"
    },
    ["NotifyReason"] = {
        ["A60"] = {
            ["Image"] = "12350986086",
        },
        ["A120"] = {
            ["Image"] = "12351008553",
        },
        ["BackdoorRush"] = {
            ["Image"] = "11102256553",
        },
        ["RushMoving"] = {
            ["Image"] = "11102256553",
        },
        ["AmbushMoving"] = {
            ["Image"] = "10938726652",
        },
        ["Eyes"] = {
            ["Image"] = "10865377903",
            ["Spawned"] = true
        },
        ["BackdoorLookman"] = {
            ["Image"] = "16764872677",
            ["Spawned"] = true
        },
        ["JeffTheKiller"] = {
            ["Image"] = "98993343",
            ["Spawned"] = true
        },
        ["GloombatSwarm"] = {
            ["Image"] = "79221203116470",
            ["Spawned"] = true
        },
        ["HaltRoom"] = {
            ["Image"] = "11331795398",
            ["Spawned"] = true
        }
    },
    ["NoCheck"] = {
        "Eyes",
        "BackdoorLookman",
        "JeffTheKiller"
    },
    ["InfCrucifixVelocity"] = {
        ["RushMoving"] = {
            threshold = 52,
            minDistance = 55,
        },
        ["RushNew"] = {
            threshold = 52,
            minDistance = 55,
        },    
        ["AmbushMoving"] = {
            threshold = 70,
            minDistance = 80,
        }
    },
    ["AutoWardrobe"] = {
        ["Entities"] = {
            "RushMoving",
            "AmbushMoving",
            "BackdoorRush",
            "A60",
            "A120",
        },
        ["Distance"] = {
            ["RushMoving"] = {
                Distance = 100,
                Loader = 175
            },
            ["BackdoorRush"] = {
                Distance = 100,
                Loader = 175
            },
    
            ["AmbushMoving"] = {
                Distance = 155,
                Loader = 200
            },
            ["A60"] = {
                Distance = 200,
                Loader = 200
            },
            ["A120"] = {
                Distance = 200,
                Loader = 200
            }
        }
    }
}

Script.HidingPlaceName = {
    ["Hotel"] = "Closet",
    ["Backdoor"] = "Closet",
    ["Fools"] = "Closet",
    ["Retro"] = "Closet",

    ["Rooms"] = "Locker",
    ["Mines"] = "Locker"
}

Script.CutsceneExclude = {
    "FigureHotelChase",
    "Elevator1",
    "MinesFinale"
}

Script.SlotsName = {
    "Oval",
    "Square",
    "Tall",
    "Wide"
}

Script.PromptTable = {
    GamePrompts = {},

    Aura = {
        ["ActivateEventPrompt"] = false,
        ["AwesomePrompt"] = true,
        ["FusesPrompt"] = true,
        ["HerbPrompt"] = false,
        ["LeverPrompt"] = true,
        ["LootPrompt"] = false,
        ["ModulePrompt"] = true,
        ["SkullPrompt"] = false,
        ["UnlockPrompt"] = true,
        ["ValvePrompt"] = false,
        ["PropPrompt"] = true
    },
    AuraObjects = {
        "Lock",
        "Button"
    },

    Clip = {
        "AwesomePrompt",
        "FusesPrompt",
        "HerbPrompt",
        "HidePrompt",
        "LeverPrompt",
        "LootPrompt",
        "ModulePrompt",
        "Prompt",
        "PushPrompt",
        "SkullPrompt",
        "UnlockPrompt",
        "ValvePrompt"
    },
    ClipObjects = {
        "LeverForGate",
        "LiveBreakerPolePickup",
        "LiveHintBook",
        "Button",
    },

    Excluded = {
        Prompt = {
            "HintPrompt",
            "InteractPrompt"
        },

        Parent = {
            "KeyObtainFake",
            "Padlock"
        },

        ModelAncestor = {
            "DoorFake"
        }
    }
}

Script.HideTimeValues = {
    {min = 1, max = 5, a = -1/6, b = 1, c = 20},
    {min = 6, max = 19, a = -1/13, b = 6, c = 19},
    {min = 19, max = 22, a = -1/4, b = 19, c = 18},
    {min = 23, max = 26, a = 1/3, b = 23, c = 18},
    {min = 26, max = 30, a = -1/4, b = 26, c = 19},
    {min = 30, max = 35, a = -1/3, b = 30, c = 18},
    {min = 36, max = 60, a = -1/12, b = 36, c = 18},
    {min = 60, max = 90, a = -1/30, b = 60, c = 16},
    {min = 90, max = 99, a = -1/6, b = 90, c = 15}
}

Script.MinecartPathNodeColor = {
    Disabled = nil,
    Red = Color3.new(1, 0, 0),
    Yellow = Color3.new(1, 1, 0),
    Purple = Color3.new(1, 0, 1),
    Green = Color3.new(0, 1, 0),
    Cyan = Color3.new(0, 1, 1),
    Orange = Color3.new(1, 0.5, 0),
    White = Color3.new(1, 1, 1),
}

Script.MinecartPathfind = {
    -- ground chase [41 to 44]
    -- minecart chase [45 to 49]
}

--// Player Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()
shared.Humanoid = nil
Script.Collision = nil
Script.CollisionClone = nil

Script.Alive = shared.LocalPlayer:GetAttribute("Alive")

--// DOORS Variables \\--
Script.EntityModules = shared.ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("EntityModules")

Script.GameData = shared.ReplicatedStorage:WaitForChild("GameData")
Script.Floor = Script.GameData:WaitForChild("Floor")
Script.LatestRoom = Script.GameData:WaitForChild("LatestRoom")

Script.LiveModifiers = shared.ReplicatedStorage:WaitForChild("LiveModifiers")

Script.IsMines = Script.Floor.Value == "Mines"
Script.IsRooms = Script.Floor.Value == "Rooms"
Script.IsHotel = Script.Floor.Value == "Hotel"
Script.IsBackdoor = Script.Floor.Value == "Backdoor"
Script.IsFools = Script.Floor.Value == "Fools"
Script.IsRetro = Script.Floor.Value == "Retro"

Script.FloorReplicated = if not Script.IsFools then shared.ReplicatedStorage:WaitForChild("FloorReplicated") else nil
Script.RemotesFolder = if not Script.IsFools then shared.ReplicatedStorage:WaitForChild("RemotesFolder") else shared.ReplicatedStorage:WaitForChild("EntityInfo")

--// Player DOORS Variables \\--
Script.CurrentRoom = shared.LocalPlayer:GetAttribute("CurrentRoom") or 0
Script.NextRoom = Script.CurrentRoom + 1

Script.MainUI = shared.PlayerGui:WaitForChild("MainUI")
Script.MainGame = Script.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game")
Script.MainGameSrc = if wax.shared.ExecutorSupport["require"] then require(Script.MainGame) else nil

--// Other Variables \\--
Script.SpeedBypassing = false
Script.LastSpeed = 0
Script.Bypassed = false

--// Functions \\--
function LoadScript(scriptType: "Utils" | "Tabs", name: string)
    return require(script.Parent.Parent.Parent[scriptType].Doors.Doors[name])
end
LoadScript("Utils", "ESP")
LoadScript("Utils", "Assets")
LoadScript("Utils", "Entities")

LoadScript("Utils", "AutoWardrobe")
LoadScript("Utils", "BreakerBox")
LoadScript("Utils", "Padlock")
LoadScript("Utils", "Minecarts")

LoadScript("Utils", "ConnectionsFuncs")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("Main"),
    Exploits = shared.Window:AddTab("Exploits"),
    Visuals = shared.Window:AddTab("Visuals"),
    Floor = shared.Window:AddTab("Floor")
}

LoadScript("Tabs", "Main")

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
        Compact = true,

        Callback = function(value)
            shared.Fly:SetSpeed(value)
        end
    })
end

--// Code \\--
function Script.Functions.SetupCharacterConnection(newCharacter)
    shared.Character = newCharacter
    shared.Humanoid = shared.Character:FindFirstChildWhichIsA("Humanoid")
    shared.RootPart = shared.Character:FindFirstChild("HumanoidRootPart") or shared.Character.PrimaryPart
end

--// OnChanged \\--
Toggles.Fly:OnChanged(function(value)
    if not shared.Fly.FlyBody then shared.Fly:Setup() end

    shared.Fly:Set(value)
end)

Options.FlySpeed:OnChanged(function(value)
    shared.Fly:SetSpeed(value)
end)

--// Load \\--
task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)
shared.Library:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))


shared.Library:GiveSignal(shared.RunService.RenderStepped:Connect(function()
    if Toggles["ShowCustomCursor"] and not Toggles.ShowCustomCursor.Value and shared.Library.Toggled then
        shared.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        shared.UserInputService.MouseIcon = "rbxassetid://2833720882"
        shared.UserInputService.MouseIconEnabled = true
    end
end))

getgenv().mspaint_loaded = true