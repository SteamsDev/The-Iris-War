FoundPentaBase = false
PlayerBaseBuilt = false
ShadeEliminated = false
ShipsBuilt = false

Trucks = {Actor154, Actor155, Actor156}
ShadeTaskForce = {"e1", "e1", "e1", "e1", "1tnk", "1tnk"}

SendMCV = function ()
	Media.DisplayMessage("This is the only MCV we can provide right now. Try not to lose it.")
	Reinforcements.Reinforce(Pliar, {"amcv"}, {PlayerSpawnOne.Location, PlayerGuardOne.Location}, 0)
	BuildObjective = Pliar.AddPrimaryObjective("Find the old Penta harbor and establish a base there.")
end

SendPatrols = function ()
	if ShadeEliminated == false then
		Reinforcements.Reinforce(Shade, ShadeTaskForce, {ShadeSpawnTwo.Location, ShadePointTwo.Location}, 1, function (a)
			Trigger.OnIdle(a, function (a)
				a.Hunt()
			end)
		end)
		Reinforcements.Reinforce(Shade, ShadeTaskForce, {ShadeSpawnFour.Location, ShadePointFour.Location}, 1, function (a)
			Trigger.OnIdle(a, function (a)
				a.Hunt()
			end)
		end)
		Trigger.AfterDelay(DateTime.Seconds(60), SendPatrols)
	end
end

PentaBaseFound = function ()
	if FoundPentaBase == false then
		FoundPentaBase = true
		Actor.Create("camera", true, {Owner = Pliar, Location = BaseCamera.Location})
		Actor.Create("camera", true, {Owner = Pliar, Location = CPos.New(39, 39)})
		Media.DisplayMessage("This is the location. Looks like the Shade is trying to extract something from this site. Put a stop to it if you can.")
	end
end

FoundTrucks = function ()
	Actor.Create("camera", true, {Owner = Pliar, Location = CPos.New(33, 90)})
end

WorldLoaded = function ()
	Pliar = Player.GetPlayer("Player")
	Shade = Player.GetPlayer("Shade")
	Penta = Player.GetPlayer("Penta")
	Camera.Position = PlayerGuardOne.CenterPosition

	Media.DisplayMessage("The destroyed Penta base is near here. Find it and build your own base there.")

	Trigger.AfterDelay(DateTime.Seconds(2), SendMCV)

	Trigger.OnEnteredProximityTrigger(BaseTriggerOne.CenterPosition, WDist.New(3 * 1024), function (a, id)
		if a.Owner == Pliar then
			Trigger.RemoveProximityTrigger(id)
			PentaBaseFound()
		end
	end)

	Trigger.OnEnteredProximityTrigger(BaseTriggerTwo.CenterPosition, WDist.New(3 * 1024), function (a, id)
		if a.Owner == Pliar then
			Trigger.RemoveProximityTrigger(id)
			PentaBaseFound()
		end
	end)

	Trigger.OnEnteredProximityTrigger(BaseTriggerThree.CenterPosition, WDist.New(3 * 1024), function (a, id)
		if a.Owner == Pliar then
			Trigger.RemoveProximityTrigger(id)
			PentaBaseFound()
		end
	end)

	Trigger.OnAllKilled(Trucks, function ()
		Media.DisplayMessage("Those trucks were carrying stolen tech that we've been able to claim. Good job, General.")
	end)
end

Tick = function ()
	if #Pliar.GetActorsByType("afac") > 0 and PlayerBaseBuilt == false then
		PlayerBaseBuilt = true
		Media.DisplayMessage("Okay, now get a small navy built and clear out any other enemy forces here.")
		NavalObjective = Pliar.AddPrimaryObjective("Build at least five naval vessels.")
		DestroyObjective = Pliar.AddPrimaryObjective("Eliminate any remaining Shade forces.")
		Pliar.MarkCompletedObjective(BuildObjective)
		Trigger.AfterDelay(DateTime.Seconds(60), SendPatrols)
	end

	if Shade.HasNoRequiredUnits() and PlayerBaseBuilt == true and ShadeEliminated == false then
		ShadeEliminated = true
		Media.DisplayMessage("I fear we may have irritated the Shade quite a bit, but oh well. You did good, General.")
		Pliar.MarkCompletedObjective(DestroyObjective)
	end

	if PlayerBaseBuilt == true and #Pliar.GetActorsByTypes({"pt2", "dd2", "cv"}) > 5 and ShipsBuilt == false then
		ShipsBuilt = true
		Media.DisplayMessage("That should be enough ships for now. We'll focus on gathering resources for the time being.")
		Pliar.MarkCompletedObjective(NavalObjective)
	end
end

