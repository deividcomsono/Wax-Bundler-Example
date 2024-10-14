--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
local Tabs = Script.Tabs

--// Visuals \\--
local SelfGroupBox = Tabs.Visuals:AddRightGroupbox("Self") do
    SelfGroupBox:AddSlider("FOV", {
        Text = "Field of View",
        Default = 90,
        Min = 50,
        Max = 120,
        Rounding = 0
    })
    
    SelfGroupBox:AddToggle("NoCamShake", {
        Text = "No Camera Shake",
        Default = false
    })

    SelfGroupBox:AddToggle("Fullbright", {
        Text = "Fullbright",
        Default = false
    })

    SelfGroupBox:AddToggle("NoFog", {
        Text = "No Fog",
        Default = false
    })

    if wax.shared.ExecutorSupport["require"] then
        SelfGroupBox:AddDivider()
    end

    SelfGroupBox:AddToggle("DeathWaypoint", {
        Text = "Death Waypoint",
        Default = false,
        Visible = wax.shared.ExecutorSupport["require"]
    })

    SelfGroupBox:AddToggle("PersonalWatch", {
        Text = "Personal Watch",
        Default = false,
        Visible = wax.shared.ExecutorSupport["require"]
    })

    SelfGroupBox:AddSlider("MaxWaypoints", {
        Text = "Max Waypoints",
        Default = if wax.shared.ExecutorSupport["require"] then require(Script.WaypointsMenu).waypoint_limit else 4,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Compact = true,
        Visible = wax.shared.ExecutorSupport["require"]
    })
end

Options.FOV:OnChanged(function(value)
    Script.Settings:SetAttribute("FieldOfView", value)
end)

Toggles.NoCamShake:OnChanged(function(value)
    Script.Settings:SetAttribute("CameraShake", not value)
end)

Toggles.Fullbright:OnChanged(function(value)
    if value then
        shared.Lighting.Ambient = Color3.new(1, 1, 1)
        shared.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        shared.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    else
        shared.Lighting.Ambient = Script.CurrentAmbient
        shared.Lighting.ColorShift_Bottom = Script.CurrentColorShift_Bottom
        shared.Lighting.ColorShift_Top = Script.CurrentColorShift_Top
    end
end)

Toggles.NoFog:OnChanged(function(value)
    if value then
        shared.Lighting.FogEnd = 9e9

        if shared.Lighting:FindFirstChild("FoggyDay_Atmosphere") then
            shared.Lighting["FoggyDay_Atmosphere"].Density = 0
        end
    else
        shared.Lighting.FogEnd = Script.DefaultFogEnd

        if shared.Lighting:FindFirstChild("FoggyDay_Atmosphere") and Script["CurrentFoggyDayDensity"] then
            shared.Lighting["FoggyDay_Atmosphere"].Density = Script.CurrentFoggyDayDensity
        end
    end
end)

Toggles.PersonalWatch:OnChanged(function(value)
    if wax.shared.ExecutorSupport["require"] then
        if value then
            Script.Calendar["Gamepass_Clock"].Visible = true
            while Toggles.PersonalWatch.Value and task.wait() do
                Script.Calendar["Gamepass_Clock"].Text = require(shared.ReplicatedStorage.Modules.Date).GetTimeInClockFormat(Script.TimeLeft.Value)
                
                if Script.TimeLeft.Value == 5 then
                    Script.Calendar["Gamepass_Clock"].Countdown.Playing = true
                end
            end
        else
            Script.Calendar["Gamepass_Clock"].Visible = Script.GamePassClockVisible
        end
    end
end)

Toggles.DeathWaypoint:OnChanged(function(value)
    if wax.shared.ExecutorSupport["require"] then
        require(Script.WaypointsMenu).create_death = value
        require(Script.WaypointsMenu).death_waypoint = value
    end
end)

Options.MaxWaypoints:OnChanged(function(value)
    if wax.shared.ExecutorSupport["require"] then
        require(Script.WaypointsMenu).waypoint_limit = value
    end
end)