IsShadeActive = false
OpenAreaFound = false
OrePitFound = false
ShadeBaseFound = false
FoundAll = false
ShadeAlive = false

KivotosConvoy = {"e1", "e1", "e1", "e1", "e1", "e1", "e3", "e3", "e3", "e3", "vulc", "vulc", "mtnk", "mtnk"}
KivotosCV = {"amcv"}

PlayerTanks = {"ltnk", "ltnk", "ltnk"}
PlayerEngies = {"e6", "e6", "e6", "e6", "e6", "e6", "e6", "e6"}

BringInKivotos = function ()
    Reinforcements.Reinforce(Kivotos, KivotosConvoy, {KivotosSpawnOne.Location, KivotosGuardOne.Location})
    Reinforcements.Reinforce(Kivotos, KivotosConvoy, {KivotosSpawnThree.Location, KivotosGuardTwo.Location})
    Reinforcements.Reinforce(Kivotos, KivotosCV, {KivotosSpawnTwo.Location, KivotosMCV.Location}, 0, function (mcv)
        Trigger.OnIdle(mcv, function (mcv)
            mcv.Deploy()
        end)
        Kivotos.Cash = 12000
        BringInPlayerUnits()
    end)
end

BringInPlayerUnits = function ()
    Reinforcements.Reinforce(Pliar, PlayerTanks, {PlayerSpawnOne.Location, PlayerGuardOne.Location})
    Reinforcements.Reinforce(Pliar, PlayerEngies, {PlayerSpawnTwo.Location, PlayerGuardTwo.Location})
    Reinforcements.Reinforce(Pliar, PlayerTanks, {PlayerSpawnThree.Location, PlayerGuardThree.Location})
    Media.DisplayMessage("Reinforcements have arrived.")
    Actor.Create("camera", true, {Owner = Pliar, Location = Actor140.Location})

    Trigger.AfterDelay(DateTime.Seconds(15), ActivateShade)
end

ShadeBaseDiscovered = function ()
    Actor.Create("camera", true, {Owner = Pliar, Location = Actor51.Location})
end

OrePitDiscovered = function ()
    Actor.Create("camera", true, {Owner = Pliar, Location = CPos.New(52, 54)})
end

OpenAreaDiscovered = function ()
    Actor.Create("camera", true, {Owner = Pliar, Location = KivotosMCV.Location})
end

WorldLoaded = function ()
    Pliar = Player.GetPlayer("Player")
    Kivotos = Player.GetPlayer("Kivotos")
    ShadeIdle = Player.GetPlayer("ShadeIdle")
    ShadeActive = Player.GetPlayer("ShadeActive")
    Camera.Position = PlayerGuardTwo.CenterPosition

    HuntObjective = Pliar.AddPrimaryObjective("Find the ore pit, open area, and the Shade base.")
    Media.DisplayMessage("Find the ore pit, open area, and Shade base.", "New Objective")
    UserInterface.SetMissionText("Find the ore pit, open area, and the Shade base.")

    Trigger.OnEnteredFootprint(Utils.ExpandFootprint({BaseLookout.Location}, true), function (a)
        if a.Owner == Pliar and ShadeBaseFound == false then
            Media.DisplayMessage("Shade base discovered.")
            ShadeBaseFound = true
            ShadeBaseDiscovered()
        end
    end)

    Trigger.OnPlayerDiscovered(ShadeIdle, function ()
        if ShadeBaseFound == false then
            Media.DisplayMessage("Shade base discovered.")
            ShadeBaseFound = true
            ShadeBaseDiscovered()
        end
    end)

    Trigger.OnEnteredFootprint(Utils.ExpandFootprint({KivotosMCV.Location}, true), function (a)
        if a.Owner == Pliar and OpenAreaFound == false then
            OpenAreaFound = true
            Media.DisplayMessage("Open area discovered.")
            OpenAreaDiscovered()
        end
    end)

end

Tick = function ()
    OrePit = Map.ActorsInBox(OrePitOne.CenterPosition, OrePitTwo.CenterPosition)
    for i=1, #OrePit do
        if OrePit[i].Owner == Pliar and OrePitFound == false then
            OrePitFound = true
            Media.DisplayMessage("Ore pit discovered.")
            OrePitDiscovered()
        end
    end

    if OrePitFound == true and OpenAreaFound == true and ShadeBaseFound == true and FoundAll == false then
        FoundAll = true
        Media.DisplayMessage("All locations discovered. Objective complete.")
        UserInterface.SetMissionText("")
        Trigger.AfterDelay(DateTime.Seconds(7), SecondPhaseStart)
    end

    if ShadeActive.HasNoRequiredUnits() and ShadeAlive == true then
        ShadeAlive = false
        Pliar.MarkCompletedObjective(DestroyObj)
    end
end

SecondPhaseStart = function ()
    DestroyObj = Pliar.AddPrimaryObjective("Assist Kivotos in destoying the Shade base.")
    Pliar.MarkCompletedObjective(HuntObjective)
    Media.DisplayMessage("Assist Kivotos in destroying the Shade base.", "New Objective")
    UserInterface.SetMissionText("Assist Kivotos in destoying the Shade base.")
    Trigger.AfterDelay(DateTime.Seconds(2), BringInKivotos)
end

ActivateShade = function ()
    ShadeActors = ShadeIdle.GetActors()
    for i=1, #ShadeActors do
        ShadeActors[i].Owner = ShadeActive
    end

    ShadeAlive = true
end