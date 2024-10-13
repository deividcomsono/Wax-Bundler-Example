return function(scriptType: "Utils" | "Tabs", name: string)
    local scriptPath = script.Parent.Parent.Places[scriptType]

    if shared.ScriptExclusionExists then
        return require(scriptPath[shared.Mapping["Folder"]][shared.Mapping["Main"]][name])
    end
    
    require(scriptPath[shared.Mapping["Main"]][name])
end