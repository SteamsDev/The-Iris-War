DateTime.TimeLimit = DateTime.Minutes(10) + DateTime.Seconds(20)
CouncilsDone = false
ShadeDefeated = false
NitroDefeated = false
GameDone = false

ShadeTaskForce = {"e1", "e1", "e1", "e1", "e1", "e3", "e3", "e3", "2tnk", "2tnk", "ptnk"}
NitroTaskForce = {"e1", "e1", "e1", "e1", "e1", "e3", "e3", "e3", "3tnk", "3tnk", "ttnk"}
PlayerTaskForceOne = {"mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mtnk.drone", "mlrs", "mlrs", "mlrs", "mlrs"}

-- Unused for now, but might want to reimplement these in the future.
ShadeAttacks = function ()
	if CouncilsDone == false and ShadeDefeated == false then
		Reinforcements.Reinforce(Shade, ShadeTaskForce, {ShadeSpawn.Location, ShadePoint.Location}, 0, function (a)
			Trigger.OnIdle(a, function (a)
				a.Hunt()
			end)
		end)
		Trigger.AfterDelay(DateTime.Minutes(1), ShadeAttacks)
	end
end

NitroAttacks = function ()
	if CouncilsDone == false and NitroDefeated == false then
		Reinforcements.Reinforce(Nitro, NitroTaskForce, {NitroSpawn.Location, NitroPoint.Location}, 0, function (a)
			Trigger.OnIdle(a, function (a)
				a.Hunt()
			end)
		end)
		Trigger.AfterDelay(DateTime.Minutes(1), NitroAttacks)
	end
end

PlayerReinforce = function ()
	Media.DisplayMessage("We have some more drones for you. Use them well, General.")
	Reinforcements.Reinforce(Pliar, PlayerTaskForceOne, {PlayerSpawn.Location, PlayerDestOne.Location}, 1)
	Reinforcements.Reinforce(Pliar, PlayerTaskForceOne, {PlayerSpawn.Location, PlayerDestTwo.Location}, 1)
end

DeliverMCV = function ()
	Media.DisplayMessage("MCV has arrived.")
	Reinforcements.Reinforce(Pliar, {"amcv"}, {PlayerSpawn.Location, MCVDest.Location}, 0, function (mcv)
		mcv.Deploy()
		Trigger.AfterDelay(DateTime.Seconds(10), PlayerReinforce)
	end)
end

WorldLoaded = function ()
    Pliar = Player.GetPlayer("Player")
    Council = Player.GetPlayer("Council")
    Shade = Player.GetPlayer("Shade")
    Nitro = Player.GetPlayer("Nitro")
    Camera.Position = CouncilMeeting.CenterPosition

    DefendObjective = Pliar.AddPrimaryObjective("Defend the meeting location until the Councils have been dismissed.")

    Trigger.OnKilled(CouncilMeeting, function ()
        if CouncilsDone == false then
            Pliar.MarkFailedObjective(DefendObjective)
        end
    end)

    Trigger.OnTimerExpired(function ()
        CouncilsDone = true
        Media.DisplayMessage("The Councils have been dismissed. The new alliance seems to be moving forward smoothly.")
        Trigger.AfterDelay(DateTime.Seconds(5), function ()
            DestroyObjective = Pliar.AddPrimaryObjective("Destroy the Shade and Nitro.")
            Pliar.MarkCompletedObjective(DefendObjective)
            Media.DisplayMessage("Reinforcements are coming. Destroy the Shade and Nitro so we have time to cover our tracks.")
			Trigger.AfterDelay(DateTime.Seconds(3), DeliverMCV)
        end)
    end)
end

Tick = function ()
    if CouncilsDone == true then
        if Shade.HasNoRequiredUnits() and Nitro.HasNoRequiredUnits() and GameDone == false then
			GameDone = true
            Media.DisplayMessage("Our enemies have been dealt with. Objective complete.")
            Pliar.MarkCompletedObjective(DestroyObjective)
        end
    end

    if Shade.HasNoRequiredUnits() and ShadeDefeated == false then
		ShadeDefeated = true
        Media.DisplayMessage("Shade forces wiped out. That's one less thorn in our side.")
    end

    if Nitro.HasNoRequiredUnits() and NitroDefeated == false then
		NitroDefeated = true
        Media.DisplayMessage("The Nitro have retreated for the time being. If only they would understand...")
    end
end