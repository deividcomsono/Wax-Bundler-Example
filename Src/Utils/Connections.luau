local Connect = {}
shared.Connections = {}

function Connect:GiveSignal(signal: RBXScriptConnection)
    table.insert(shared.Connections, signal)
end

function Connect:DisconnectSignal(signal: RBXScriptConnection)
    if not signal then return end

    if signal.Connected then
        signal:Disconnect()
    end
end

return Connect