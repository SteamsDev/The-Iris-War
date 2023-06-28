WorldLoaded = function()
    Shade = Player.GetPlayer("Shade")
    Nitro = Player.GetPlayer("Nitro")
    DA = Player.GetPlayer("DA")
    Camera.Position = Actor19.CenterPosition

    DestroyObjective = Shade.AddPrimaryObjective("Destroy the Nitro base.")
    ProtectObjective = Shade.AddSecondaryObjective("Protect the civilian village and factories.")

    Village = DA.GetActors()

    Trigger.OnAllKilled(Village, function() Shade.MarkFailedObjective(ProtectObjective) end)

end

Tick = function()
    if (Nitro.HasNoRequiredUnits()) then
        Shade.MarkCompletedObjective(DestroyObjective)
    end
    if Shade.HasNoRequiredUnits() then
        Shade.MarkFailedObjective(DestroyObjective)
    end
end