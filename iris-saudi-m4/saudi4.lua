WorldLoaded = function()
    Shade = Player.GetPlayer("Shade")
    Nitro = Player.GetPlayer("Nitro")
    DA = Player.GetPlayer("DA")
    Camera.Position = Actor41.CenterPosition
    Nitro.Cash = 10000

    DestroyObj = Shade.AddPrimaryObjective("Destroy the final Nitro base in the region.")
end

Tick = function()
     if Nitro.HasNoRequiredUnits() then
        Shade.MarkCompletedObjective(DestroyObj)
     end
     if Shade.HasNoRequiredUnits() then
        Shade.MarkFailedObjective(DestroyObj)
     end
end