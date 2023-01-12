ExtractionComplete = false
DateTime.TimeLimit = DateTime.Minutes(20) + DateTime.Seconds(40)

AllyReinforcements = {"1tnk", "1tnk", "1tnk", "e1", "e1", "e1", "e1"}

AllyComeHelp = function()
	Reinforcements.Reinforce(PentaAlly, AllyReinforcements, {AllyWaypointOne.Location, AllyRallyOne.Location})
	Reinforcements.Reinforce(PentaAlly, AllyReinforcements, {AllyWaypointTwo.Location, AllyRallyTwo.Location})
	Reinforcements.Reinforce(PentaAlly, {"mcv"}, {AllyWaypointCV.Location, MCVDeploy.Location}, 0, function(mcv)
		Trigger.OnIdle(mcv, function()
			mcv.Deploy()
		end)
	end)
	Media.DisplayMessage("An ally has overcome the Nitro resistance and can now provide assistance.")
end

WorldLoaded = function()
	Penta = Player.GetPlayer("Penta")
	PentaAlly = Player.GetPlayer("PentaAlly")
	Nitro = Player.GetPlayer("Nitro")
	DA = Player.GetPlayer("DA")
	Camera.Position = ResearchFacility.CenterPosition

	DefendObjective = Penta.AddPrimaryObjective("Defend the research facility until extraction is complete.")
	DestroyObjective = Penta.AddPrimaryObjective("Destroy the Nitro and DA.")

	Media.DisplayMessage("Our allies are pushing through the Nitro resistance now. Hold steady until they arrive.")

	Trigger.OnKilled(ResearchFacility, function()
		if (ExtractionComplete == false) then
			Penta.MarkFailedObjective(DefendObjective)
		end
	end)

	Trigger.OnTimerExpired(function()
		ExtractionComplete = true
		Media.DisplayMessage("Extraction complete. This will be vital for our research!")
		Penta.MarkCompletedObjective(DefendObjective)
	end)

	Trigger.AfterDelay((DateTime.Minutes(8) + DateTime.Seconds(20)), AllyComeHelp)
end

Tick = function()
	if (Nitro.HasNoRequiredUnits() and DA.HasNoRequiredUnits()) then
		Penta.MarkCompletedObjective(DestroyObjective)
	end

	if (Penta.HasNoRequiredUnits()) then
		Penta.MarkFailedObjective(DestroyObjective)
	end
end