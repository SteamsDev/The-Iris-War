PlayerVehicle = {"apc"}
CouncilCamp = {CouncilBarracks, CouncilPowerOne, CouncilPowerThree, CouncilRef, CouncilCommCenter, CouncilOil, CouncilTankOne, CouncilTankTwo, CouncilTankThree, CouncilTankFour, CouncilGunOne, CouncilGunTwo, CouncilGunThree, CouncilGunFour}
ShadeForces = {"e1", "e1", "e1", "e1", "e1", "e3", "e3", "e3", "1tnk", "1tnk", "2tnk"}
ShadeForcesTwo = {"e2", "e2", "e2", "2tnk", "2tnk", "rtnk"} -- <-- Unused --

VertinDiscovered = false
HyperDiscovered = false

PlayerArrival = function ()
    Reinforcements.Reinforce(Council, PlayerVehicle, {SpawnOne.Location, WayOne.Location, WayConference.Location}, 0, function (a)
        a.Owner = Pliar
        Media.DisplayMessage("They have asked you to scout the area for any activity from the Shade.")
        ScoutObjective = Pliar.AddPrimaryObjective("Scout the area.")
        Media.DisplayMessage("Scout the area for any Shade activity.", "Objective")
    end)

    Trigger.OnPlayerDiscovered(Shade, function ()
        Actor.Create("camera", true, {Owner = Pliar, Location = Actor288.Location})
        Media.DisplayMessage("Shade forces discovered. It looks like they've been spying on us...")
        Trigger.AfterDelay(DateTime.Seconds(5), SecondPhase)
        
    end)
end

SecondPhase = function ()

    Media.DisplayMessage("The Shade have caught on to us. We have to hold our ground against the Shade until the Council Meeting is over.")
    Media.DisplayMessage("Defend the meeting location for 7 minutes.", "New Objective")
    DefendObjective = Pliar.AddPrimaryObjective("Defend the meeting location in the center of the base.")
    Pliar.MarkCompletedObjective(ScoutObjective)
    Trigger.AfterDelay(DateTime.Seconds(3), function ()
        Media.DisplayMessage("We have activated some of the facilities in the camp. Use then well.")
        for i=1, #CouncilCamp do
            CouncilCamp[i].Owner = Pliar
        end
        Council.GetActorsByType("harv")[1].Owner = Pliar
        DateTime.TimeLimit = DateTime.Minutes(7)
        Trigger.AfterDelay(DateTime.Seconds(15), ShadeAttacks)

        Trigger.OnKilled(CouncilMeeting, function ()
            Pliar.MarkFailedObjective(DefendObjective)
        end)

        Trigger.OnTimerExpired(function ()
            Media.DisplayMessage("The Councils have been dismissed. We will have to abandon this location as it's no longer feasible to operate here.")
            Trigger.AfterDelay(DateTime.Seconds(5), function ()
                Pliar.MarkCompletedObjective(DefendObjective)
            end)
        end)
    end)
end

ShadeAttacks = function ()
    Trigger.AfterDelay(DateTime.Seconds(10), function ()
        Reinforcements.Reinforce(Shade, ShadeForces, {SpawnOne.Location, WayOne.Location}, 0, function (a)
            Trigger.OnIdle(a, function (a)
                a.Hunt()
            end)
        end)
    end)
    Trigger.AfterDelay(DateTime.Seconds(20), function ()
        Reinforcements.Reinforce(Shade, ShadeForces, {SpawnTwo.Location, WayTwo.Location}, 0, function (a)
            Trigger.OnIdle(a, function (a)
                a.Hunt()
            end)
        end)
    end)
    Trigger.AfterDelay(DateTime.Seconds(30), function ()
        Reinforcements.Reinforce(Shade, ShadeForces, {SpawnThree.Location, WayThree.Location}, 0, function (a)
            Trigger.OnIdle(a, function (a)
                a.Hunt()
            end)
        end)
    end)
    Trigger.AfterDelay(DateTime.Seconds(40), function ()
        Reinforcements.Reinforce(Shade, ShadeForces, {SpawnFour.Location, WayFour.Location}, 0, function (a)
            Trigger.OnIdle(a, function (a)
                a.Hunt()
            end)
        end)
    end)
    Trigger.AfterDelay(DateTime.Seconds(50), function ()
        Reinforcements.Reinforce(Shade, ShadeForces, {SpawnFive.Location, WayFive.Location}, 0, function (a)
            Trigger.OnIdle(a, function (a)
                a.Hunt()
            end)
        end)
    end)
    Trigger.AfterDelay(DateTime.Seconds(90), ShadeAttacks)
end

WorldLoaded = function ()
    Pliar = Player.GetPlayer("Player")
    Council = Player.GetPlayer("Council")
    Shade = Player.GetPlayer("Shade")

    Media.DisplayMessage("The Council Meeting is taking place at this village. Your APC will arrive soon...")
    
    Trigger.AfterDelay(DateTime.Seconds(3), PlayerArrival)

    Trigger.OnDiscovered(Vertin, function ()
        if VertinDiscovered == false then
            local VertinUnits = {MyTankOne, MyTankTwo, MyRaiderOne, MyRaiderTwo}
            for i=1, #VertinUnits do
                VertinUnits[i].Owner = Pliar
            end
            Media.DisplayMessage("I've heard of you before. Take these units and use them to thwart the oncoming storm. Be careful.", "Vertin")
            VertinDiscovered = true
        end
    end)

    Trigger.OnDiscovered(Hyper, function ()
        if HyperDiscovered == false then
            HumVee.Owner = Pliar
            Media.DisplayMessage("I hope the meeting is going well for you. I don't have much to contribute with, but this HumVee should serve you well.", "Hyper")
            HyperDiscovered = true
        end
    end)

    Trigger.OnDiscovered(HideMe, function ()
        HideMe.Owner = Pliar
        Media.DisplayMessage("You found me! I don't know many people who come out here that often. You have a lot on your plate, right? How about I help you out?", "Jarkill")
    end)
end