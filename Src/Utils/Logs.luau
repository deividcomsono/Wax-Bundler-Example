local Logs = {}

function TableToMessage(tbl: table)
    for idx, val in ipairs(tbl) do
        tbl[idx] = tostring(val)
    end

    return table.concat(tbl, " ")
end

function Logs:Log(...)
    local message = "[INFO] " .. TableToMessage({ ... })
end

return Logs