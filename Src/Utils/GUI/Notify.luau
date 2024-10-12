local Notify = {}

local Linoria = require("Notifiers/Linoria")
local Doors = require("Notifiers/Doors")

function Notify:Notify(options)
    if shared.NotifyStyle == "Linoria" then
        Linoria:Notify(options)
    elseif shared.NotifyStyle == "Doors" and shared.ScriptName == "DOORS" then
        options["Warning"] = nil
        Doors:Notify(options)
    end
end

function Notify:Alert(options)
    if shared.NotifyStyle == "Linoria" then
        Linoria:Alert(options)
    elseif shared.NotifyStyle == "Doors" and shared.ScriptName == "DOORS" then
        Doors:Alert(options)
    end
end

return Notify