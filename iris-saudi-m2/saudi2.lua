DerricksCaptured = false
RefineriesCaptured = true


WorldLoaded = function()
    Shade = Player.GetPlayer("Shade")
    Nitro = Player.GetPlayer("Nitro")
    Camera.Position = Actor7.CenterPosition

    CaptureObj = Shade.AddPrimaryObjective("Capture all of Nitro's oil derricks and refineries.")
    DestroyObj = Shade.AddPrimaryObjective("Destroy all Nitro forces.")

    Derricks = Nitro.GetActorsByType("oilb")
    Refineries = Nitro.GetActorsByType("proc")

    Trigger.OnAllKilledOrCaptured(Derricks, function ()
        DerricksCaptured = true
    end)

    Trigger.OnAllKilledOrCaptured(Refineries, function ()
        RefineriesCaptured = true
    end)

    Trigger.OnAnyKilled(Derricks, function ()
        Shade.MarkFailedObjective(CaptureObj)
    end)

    Trigger.OnAnyKilled(Refineries, function ()
        Shade.MarkFailedObjective(CaptureObj)
    end)

end

Tick = function()
    if Nitro.HasNoRequiredUnits() then
        Shade.MarkCompletedObjective(DestroyObj)
    end

    if DerricksCaptured == true and RefineriesCaptured == true then
        Shade.MarkCompletedObjective(CaptureObj)
    end

    
end