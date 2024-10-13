return function(scriptType: "Utils" | "Tabs", name: string)
    local splitPath = string.split(shared.ScriptLoader, "/")
    local scriptPath = script.Parent.Parent.Places[scriptType]

    for _, path in pairs(splitPath) do
        scriptPath = scriptPath[path]
    end
    
    require(scriptPath[name])
end