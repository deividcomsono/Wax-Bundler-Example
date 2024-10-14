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