NitroBaseDestroyed = false
NitroWavesOut = false

SankalpaTaskForce = {"ltnk", "ltnk", "ltnk", "ltnk", "ftnk", "ftnk", "ftnk", "mlrs", "mlrs", "mlrs"}
SankalpaCV = {"amcv"}
PlayerEngies = {"e6", "e6", "e6", "e6", "e6", "e6", "e6", "e6"}

NitroWaveOne = {"3tnk", "3tnk", "3tnk", "3tnk", "btr", "btr", "btr", "e1", "e1", "e1", "e1", "e1", "e1", "e1", "e1", "e1", "e4", "e4", "e4", "e4"}
NitroWaveTwo = {"3tnk", "3tnk", "3tnk", "e4", "e4", "e4", "e4", "katy", "katy"}
NitroWaveThree = {"4tnk", "4tnk", "ttnk", "ttnk", "ttnk", "3tnk.rhino", "3tnk.rhino", "3tnk.rhino", "3tnk.rhino", "e1", "e1", "e1", "e1", "e1", "e1"}

AttackScript = function (a)
    Trigger.OnIdle(a, function (a)
        a.Hunt()
    end)
end

DeliverEngies = function ()
    Media.DisplayMessage("The Nitro will likely be attacking soon. Recover these facilties and prepare to help defend the Snakalpa.")
    Reinforcements.Reinforce(Pliar, PlayerEngies, {EngieSpawn.Location, EngieDest.Location}, 0)
end

DeliverSankalpa = function ()
    Reinforcements.Reinforce(Sankalpa, SankalpaTaskForce, {SankalpaSpawnOne.Location, SankalpaGuardOne.Location}, 0)
    Reinforcements.Reinforce(Sankalpa, SankalpaTaskForce, {SankalpaSpawnTwo.Location, SankalpaGuardTwo.Location}, 0)
end

BeginNitroTimer = function ()
    DefendObjective = Pliar.AddPrimaryObjective("Defend the Sankalpa facility from the Nitro counterattack.")
    Pliar.MarkCompletedObjective(DestroyObj)
    DateTime.TimeLimit = DateTime.Minutes(5) + DateTime.Seconds(25)

    Trigger.OnTimerExpired(function ()
        UserInterface.SetMissionText("Defend from the Nitro counterattack.")
        Media.DisplayMessage("The Nitro main force is arriving. Do not let them destroy the Sankalpa facility.")
        NitroAttacksWaveOne()
        NitroWavesOut = true
    end)
end

NitroAttacksWaveOne = function ()
    Reinforcements.Reinforce(Nitro, NitroWaveOne, {NitroSpawnOne.Location, NitroDestOne.Location}, 0, AttackScript)
    Reinforcements.Reinforce(Nitro, NitroWaveOne, {NitroSpawnTwo.Location, NitroDestOne.Location}, 0, AttackScript)

    Trigger.AfterDelay(DateTime.Seconds(20), NitroAttacksWaveTwo)
end

NitroAttacksWaveTwo = function ()
    Reinforcements.Reinforce(Nitro, NitroWaveTwo, {NitroSpawnOne.Location, NitroDestOne.Location}, 0, AttackScript)
    Reinforcements.Reinforce(Nitro, NitroWaveTwo, {NitroSpawnTwo.Location, NitroDestOne.Location}, 0, AttackScript)
    Reinforcements.Reinforce(Nitro, NitroWaveTwo, {NitroSpawnThree.Location, NitroDestTwo.Location}, 0, AttackScript)

    Trigger.AfterDelay(DateTime.Seconds(20), NitroAttacksWaveThree)
end

NitroAttacksWaveThree = function ()
    Reinforcements.Reinforce(Nitro, NitroWaveThree, {NitroSpawnOne.Location, NitroDestOne.Location}, 0, AttackScript)
    Reinforcements.Reinforce(Nitro, NitroWaveThree, {NitroSpawnTwo.Location, NitroDestOne.Location}, 0, AttackScript)
    Reinforcements.Reinforce(Nitro, NitroWaveOne, {NitroSpawnThree.Location, NitroDestTwo.Location}, 0, AttackScript)

    Remaining = Nitro.GetGroundAttackers()
    Trigger.OnAllKilled(Remaining, function ()
        Media.DisplayMessage("Nitro counterattack thwarted. Objective complete.")
        Pliar.MarkCompletedObjective(DefendObjective)
    end)
end


WorldLoaded = function ()
    Pliar = Player.GetPlayer("Player")
    Sankalpa = Player.GetPlayer("Sankalpa")
    Nitro = Player.GetPlayer("Nitro")
    Neutral = Player.GetPlayer("Neutral")
    Camera.Position = CameraLocation.CenterPosition

    DestroyObj = Pliar.AddPrimaryObjective("Help the Sankalpa destroy the Nitro production facility.")
    UserInterface.SetMissionText("Help the Sankalpa destroy the Nitro production facility.")
    
end

Tick = function ()
    if Nitro.HasNoRequiredUnits() and NitroBaseDestroyed == false then
        NitroBaseDestroyed = true
        Media.DisplayMessage("The Nitro base has been wiped out. The rest of Sankalpa'a force will arrive soon.")
        UserInterface.SetMissionText("")
        Reinforcements.Reinforce(Sankalpa, SankalpaCV, {SankalpaSpawnTwo.Location, SankalpaMCV.Location}, 0, function (mcv)
            Trigger.OnIdle(mcv, function (mcv)
                mcv.Deploy()
            end)
            DeliverSankalpa()
            DeliverEngies()
            BeginNitroTimer()
        end)
    end

    if Sankalpa.HasNoRequiredUnits() and NitroWavesOut == true then
        Pliar.MarkFailedObjective(DefendObjective)
    end
end