Helicopter = {"heli"}

SendHeli = function ()
    Reinforcements.Reinforce(NewHope, Helicopter, {HeliSpawn.Location, HeliPointOne.Location, HeliPointTwo.Location, HeliPointThree.Location, HeliPointFour.Location, HeliPointFive.Location, HeliPointSix.Location}, 0)
end

WorldLoaded = function ()
    Pliar = Player.GetPlayer("Player")
    NewHope = Player.GetPlayer("New Hope")
    Penta = Player.GetPlayer("Penta")
    Camera.Position = MCVDest.CenterPosition

    Media.DisplayMessage("Welcome to the jungle, General. The New Hope is entrusting this mission to you.")
    SendHeli()
    Reinforcements.Reinforce(Pliar, {"amcv"}, {MCVSpawn.Location, MCVDest.Location}, 0, function (mcv)
        Media.DisplayMessage("Use this to estalish the New Hope's facilities. Do not let the Penta destroy it!")
        mcv.Deploy()
        DefendObjective = Pliar.AddPrimaryObjective("Establish the New Hope's base and protect it.")
        DestroyObjective = Pliar.AddPrimaryObjective("Eliminate the Penta base and forces.")
    end)
end

Tick = function ()
    if Penta.HasNoRequiredUnits() then
        Pliar.MarkCompletedObjective(DestroyObjective)
        Pliar.MarkCompletedObjective(DefendObjective)
    end

    if Pliar.HasNoRequiredUnits() then
        Pliar.MarkFailedObjective(DefendObjective)
    end
end
