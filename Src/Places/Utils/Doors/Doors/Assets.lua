--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script

--// Assets Functions \\--
function Script.Functions.GetShortName(entityName: string)
    if EntityTable.ShortNames[entityName] then
        return EntityTable.ShortNames[entityName]
    end

    for suffix, fix in pairs(SuffixPrefixes) do
        entityName = entityName:gsub(suffix, fix)
    end

    return entityName
end

function Script.Functions.PromptCondition(prompt)
    local modelAncestor = prompt:FindFirstAncestorOfClass("Model")
    return 
        prompt:IsA("ProximityPrompt") and (
            not table.find(PromptTable.Excluded.Prompt, prompt.Name) 
            and not table.find(PromptTable.Excluded.Parent, prompt.Parent and prompt.Parent.Name or "") 
            and not (table.find(PromptTable.Excluded.ModelAncestor, modelAncestor and modelAncestor.Name or ""))
        )
end

function Script.Functions.ItemCondition(item)
    return item:IsA("Model") and (item:GetAttribute("Pickup") or item:GetAttribute("PropType")) and not item:GetAttribute("FuseID")
end

function Script.Functions.ChildCheck(child)
    -- optimization (ty lsplash)
    if (child.Name == "AnimSaves" or child.Name == "Keyframe" or child:IsA("KeyframeSequence")) then
        child:Destroy()
        return
    end
    
    -- skip
    if not (child:IsA("ProximityPrompt") or child:IsA("Model") or child:IsA("BasePart") or child:IsA("Decal")) then
        return
    end
            
    if Script.Functions.PromptCondition(child) then
        task.defer(function()
            if not child:GetAttribute("Hold") then child:SetAttribute("Hold", child.HoldDuration) end
            if not child:GetAttribute("Distance") then child:SetAttribute("Distance", child.MaxActivationDistance) end
            if not child:GetAttribute("Enabled") then child:SetAttribute("Enabled", child.Enabled) end
            if not child:GetAttribute("Clip") then child:SetAttribute("Clip", child.RequiresLineOfSight) end
        end)

        task.defer(function()
            child.MaxActivationDistance = child:GetAttribute("Distance") * Options.PromptReachMultiplier.Value
    
            if Toggles.InstaInteract.Value then
                child.HoldDuration = 0
            end
    
            if Toggles.PromptClip.Value and Script.Functions.PromptCondition(child) then
                child.RequiresLineOfSight = false
            end
        end)

        table.insert(PromptTable.GamePrompts, child)
    end

    if child:IsA("Model") then
        if child.Name == "ElevatorBreaker" and Toggles.AutoBreakerSolver.Value then
            Script.Functions.SolveBreakerBox(child)
        end

        if isMines and Toggles.TheMinesAnticheatBypass.Value and child.Name == "Ladder" then
            Script.Functions.ESP({
                Type = "None",
                Object = child,
                Text = "Ladder",
                Color = Color3.new(0, 0, 1)
            })
        end

        if child.Name == "Snare" and Toggles.AntiSnare.Value then
            child:WaitForChild("Hitbox", 5).CanTouch = false
        elseif child.Name == "GiggleCeiling" and Toggles.AntiGiggle.Value then
            child:WaitForChild("Hitbox", 5).CanTouch = false
        elseif (child:GetAttribute("LoadModule") == "DupeRoom" or child:GetAttribute("LoadModule") == "SpaceSideroom") and Toggles.AntiDupe.Value then
            Script.Functions.DisableDupe(child, true, child:GetAttribute("LoadModule") == "SpaceSideroom")
        end

        if (isHotel or isFools) and (child.Name == "ChandelierObstruction" or child.Name == "Seek_Arm") and Toggles.AntiSeekObstructions.Value then
            for i,v in pairs(child:GetDescendants()) do
                if v:IsA("BasePart") then v.CanTouch = false end
            end
        end

        if isFools then
            if Toggles.FigureGodmodeFools.Value and child.Name == "FigureRagdoll" then
                for i, v in pairs(child:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if not v:GetAttribute("Clip") then v:SetAttribute("Clip", v.CanCollide) end

                        v.CanTouch = false

                        -- woudn't want figure to just dip into the ground
                        task.spawn(function()
                            repeat task.wait() until (latestRoom.Value == 50 or latestRoom.Value == 100)
                            task.wait(5)
                            v.CanCollide = false
                        end)
                    end
                end
            end
        end
    elseif child:IsA("BasePart") then
        if tonumber(child.Name) and child.Name == child.Parent.Name then
            child.Size *= Vector3.new(1, 100, 1)
        elseif child.Name == "Egg" and Toggles.AntiGloomEgg.Value then
            child.CanTouch = false
        end

        if Toggles.AntiLag.Value then
            if not child:GetAttribute("Material") then child:SetAttribute("Material", child.Material) end
            if not child:GetAttribute("Reflectance") then child:SetAttribute("Reflectance", child.Reflectance) end
    
            child.Material = Enum.Material.Plastic
            child.Reflectance = 0
        end

        if isMines then
            if Toggles.AntiBridgeFall.Value and child.Name == "PlayerBarrier" and child.Size.Y == 2.75 and (child.Rotation.X == 0 or child.Rotation.X == 180) then
                local clone = child:Clone()
                clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
                clone.Color = Color3.new(1, 1, 1)
                clone.Name = "AntiBridge"
                clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
                clone.Transparency = 0
                clone.Parent = child.Parent
                
                table.insert(Script.Temp.Bridges, clone)
            elseif Toggles.AntiSeekFlood.Value and child.Name == "SeekFloodline" then
                child.CanCollide = true
            end
        end
    elseif child:IsA("Decal") and Toggles.AntiLag.Value then
        if not child:GetAttribute("Transparency") then child:SetAttribute("Transparency", child.Transparency) end

        if not table.find(SlotsName, child.Name) then
            child.Transparency = 1
        end
    end
end

function Script.Functions.IsPromptInRange(prompt: ProximityPrompt)
    return Script.Functions.DistanceFromCharacter(prompt:FindFirstAncestorWhichIsA("BasePart") or prompt:FindFirstAncestorWhichIsA("Model") or prompt.Parent) <= prompt.MaxActivationDistance
end

function Script.Functions.GetNearestAssetWithCondition(condition: () -> ())
    local nearestDistance = math.huge
    local nearest
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        if not room:FindFirstChild("Assets") then continue end

        for i, v in pairs(room.Assets:GetChildren()) do
            if condition(v) and Script.Functions.DistanceFromCharacter(v) < nearestDistance then
                nearestDistance = Script.Functions.DistanceFromCharacter(v)
                nearest = v
            end
        end
    end

    return nearest
end

function Script.Functions.GetAllPromptsWithCondition(condition)
    assert(typeof(condition) == "function", "Expected a function as condition argument but got " .. typeof(condition))
    
    local validPrompts = {}
    for _, prompt in pairs(PromptTable.GamePrompts) do
        if not prompt or not prompt:IsDescendantOf(workspace) then continue end

        local success, returnData = pcall(function()
            return condition(prompt)
        end)

        assert(success, "An error has occured while running condition function.\n" .. tostring(returnData))
        assert(typeof(returnData) == "boolean", "Expected condition function to return a boolean")
        
        if returnData then
            table.insert(validPrompts, prompt)
        end
    end

    return validPrompts
end

function Script.Functions.GetNearestPromptWithCondition(condition)
    local prompts = Script.Functions.GetAllPromptsWithCondition(condition)

    local nearestPrompt = nil
    local oldHighestDistance = math.huge
    for _, prompt in pairs(prompts) do
        local promptParent = prompt:FindFirstAncestorWhichIsA("BasePart") or prompt:FindFirstAncestorWhichIsA("Model")

        if promptParent and Script.Functions.DistanceFromCharacter(promptParent) < oldHighestDistance then
            nearestPrompt = prompt
            oldHighestDistance = Script.Functions.DistanceFromCharacter(promptParent)
        end
    end

    return nearestPrompt
end