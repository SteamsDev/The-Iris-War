Prisoners = {Actor157, Actor158, Actor159, Actor160, Actor161, Actor162, Actor163, Actor164, Actor165, Actor166}
PlayerUnits = {"e1", "e1", "e1", "e1", "e1", "ifv", "ifv", "ifv", "ifv"}

WorldLoaded = function()
    Shade = Player.GetPlayer("Shade")
    Nitro = Player.GetPlayer("Nitro")
    Camera.Position = Spawn.CenterPosition
    Nitro.Cash = 4000
    Shade.Cash = 6000

    CaptureObjective = Shade.AddPrimaryObjective("Capture the Nuclear Power Plant and Construction Yard.")
    DestroyObjective = Shade.AddPrimaryObjective("Eliminate all Nitro forces.")
    Media.DisplayMessage("Our conquest of Saudi Arabia has begun! Do your job, Commander!")

    Trigger.AfterDelay(DateTime.Minutes(2), function()
        Reinforcements.Reinforce(Shade, PlayerUnits, {WayTwo.Location, Spawn.Location}, 0)
        Media.DisplayMessage("Reinforcements have arrived.")
    end)

    Trigger.OnAnyKilled({NUKE, ConYard}, function()
        Shade.MarkFailedObjective(CaptureObjective)
    end)

    Trigger.OnAllKilledOrCaptured({Actor26, Actor27, Actor28, Actor29}, function()
        Reinforcements.Reinforce(Shade, PlayerUnits, {WayOne.Location, StopOne.Location}, 0)
        Media.DisplayMessage("Reinforcements have arrived.")
    end)

    Trigger.OnEnteredFootprint({CageBoundOne.Location, CageBoundTwo.Location}, function(a)
        if a.Owner == Shade then
            for i=1, #Prisoners do
                Prisoners[i].Owner = Shade
            end
        end
    end)
end

Tick = function()
    if (NUKE.Owner == Shade and ConYard.Owner == Shade) then
        Shade.MarkCompletedObjective(CaptureObjective)
    end

    if (Nitro.HasNoRequiredUnits()) then
        Shade.MarkCompletedObjective(DestroyObjective)
    end

    if (Shade.HasNoRequiredUnits()) then
        Shade.MarkFailedObjective(DestroyObjective)
    end
end