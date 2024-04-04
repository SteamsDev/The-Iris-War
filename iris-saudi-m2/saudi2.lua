DerricksCaptured = false


WorldLoaded = function()
    Shade = Player.GetPlayer("Shade")
    Nitro = Player.GetPlayer("Nitro")
    Camera.Position = Actor7.CenterPosition

    CaptureObj = Shade.AddPrimaryObjective("Capture all of Nitro's oil derricks.")
    DestroyObj = Shade.AddPrimaryObjective("Destroy all Nitro forces.")

    Derricks = Nitro.GetActorsByType("oilb")

    Trigger.OnAllKilledOrCaptured(Derricks, function ()
        DerricksCaptured = true
    end)

    Trigger.OnAnyKilled(Derricks, function ()
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