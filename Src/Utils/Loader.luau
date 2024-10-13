return function(scriptType: "Utils" | "Tabs", name: string)
    local scriptPath = script.Parent.Parent.Places[scriptType][shared.Mapping["Folder"]]

    if shared.Mapping and shared.Mapping["Exclusions"] ~= nil then
        local ExclusionPath = shared.ScriptExclusion or shared.Mapping["Main"]
        return require(scriptPath[ExclusionPath][name])
    end
    
    require(scriptPath[name])
end