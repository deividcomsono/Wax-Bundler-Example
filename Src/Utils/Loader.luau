return function(scriptType: "Utils" | "Tabs", name: string)
    local scriptPath = script.Parent.Parent.Places[scriptType][shared.Mapping["Folder"]]

    if shared.ScriptExclusionExists then
        local ExclusionPath = shared.ScriptExclusion or shared.Mapping["Exclusion"]
        return require(scriptPath[ExclusionPath][name])
    end
    
    require(scriptPath[name])
end