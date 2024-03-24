OilProtected = true
OilDerricks = {Actor34, Actor35, Actor36, Actor37, Actor38, Actor65, Actor73, Actor84, Actor85, Actor86}

WorldLoaded = function()
    Shade = Player.GetPlayer("Shade")
    Penta = Player.GetPlayer("Penta")
    DA = Player.GetPlayer("DA")
    Penta.Cash = 85000

    OilNumber = #OilDerricks

    ProtectObjective = Shade.AddPrimaryObjective("Keep at least four of the oil derricks intact.")
    DestroyObj = Shade.AddPrimaryObjective("Drive out the Penta.")

end

Tick = function()
    if (Penta.HasNoRequiredUnits()) then
        Shade.MarkCompletedObjective(DestroyObj)
        Shade.MarkCompletedObjective(ProtectObjective)
    end

    OilKilled = 0
    for i = 1, OilNumber do
        if OilDerricks[i].IsDead then
            OilKilled = OilKilled + 1
        end
    end
    if OilNumber - OilKilled < 4 then
        Shade.MarkFailedObjective(ProtectObjective)
    end
end