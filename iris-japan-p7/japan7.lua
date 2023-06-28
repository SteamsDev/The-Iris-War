WorldLoaded = function()
    Penta = Player.GetPlayer("Penta")
    Nitro = Player.GetPlayer("Nitro")
    DA = Player.GetPlayer("DA")
    Shade = Player.GetPlayer("Shade")
    Penta.Cash = 12000
    Camera.Position = Actor236.CenterPosition

    Media.DisplayMessage("This is the day we finish the DA. Take the HQ!")
    DestroyObjective = Penta.AddPrimaryObjective("Capture or destroy the DA Headquarters.")
    NitroObjective = Penta.AddSecondaryObjective("Destroy the DA base.")
    ShadeObjective = Penta.AddSecondaryObjective("Destroy the Shade base.")

    Trigger.OnKilledOrCaptured(DAHQ, function()
        Penta.MarkCompletedObjective(DestroyObjective)
    end)
end

Tick = function()
    if DA.HasNoRequiredUnits() then
        Penta.MarkCompletedObjective(NitroObjective)
    end

    if Shade.HasNoRequiredUnits() then
        Penta.MarkCompletedObjective(ShadeObjective)
    end

    if Penta.HasNoRequiredUnits() then
        Penta.MarkFailedObjective(DestroyObjective)
    end
end