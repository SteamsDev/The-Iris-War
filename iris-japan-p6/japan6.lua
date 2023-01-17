-- DABase = {Actor17, Actor18, Actor19, Actor20, Actor21, Actor25, Actor26}
ShadeSupport = {"mtnk", "mtnk", "mtnk", "mtnk", "arty", "arty", "e3", "e3", "e3", "e3", "e1", "e1", "e1", "e1", "e1", "e1"}
ShadeSupportRep = {"mtnk", "mtnk", "mtnk", "mtnk", "ifv", "ifv", "ifv", "ifv", "ifv", "ifv", "e1", "e1", "e1", "e1", "e1", "e1"}
ShadeInTheArea = false
ShadeSupportDone = false
DateTime.TimeLimit = DateTime.Minutes(28)

SendShadeForces = function()
	Media.DisplayMessage("The Shade are here!", "WARNING")
	Actor.Create("camera", true, { Owner = Penta, Location = Actor17.Location })
	Reinforcements.Reinforce(Shade, ShadeSupport, {ShadeWaypointOne.Location, ShadeWaypointFour.Location})
	Reinforcements.Reinforce(Shade, ShadeSupport, {ShadeWaypointTwo.Location, ShadeWaypointFive.Location})

	Trigger.AfterDelay(DateTime.Minutes(1), function()
		Reinforcements.Reinforce(Shade, {"mcv"}, {ShadeWaypointThree.Location, ShadeWaypointSix.Location}, 0, function(mcv)
			ShadeDeathObjective = Penta.AddPrimaryObjective("Eliminate the Shade.")
			ShadeInTheArea = true
			Trigger.OnIdle(mcv, function()
				mcv.Deploy()
				RepeatSupport()
				Trigger.AfterDelay(DateTime.Minutes(1), function() ShadeSupportDone = true end)
			end)
		end)
	end)
end

RepeatSupport = function()
	if Nitro.HasNoRequiredUnits() or ShadeSupportDone == true then return end
	Reinforcements.Reinforce(Shade, ShadeSupportRep, {ShadeWaypointOne.Location, ShadeWaypointFour.Location})
	Reinforcements.Reinforce(Shade, ShadeSupportRep, {ShadeWaypointTwo.Location, ShadeWaypointFive.Location})
	Trigger.AfterDelay(DateTime.Seconds(60), RepeatSupport)
end

WorldLoaded = function()
	Penta = Player.GetPlayer("Penta")
	Nitro = Player.GetPlayer("Nitro")
	NitroGuard = Player.GetPlayer("NitroGuard")
	Shade = Player.GetPlayer("Shade")
	Penta.Cash = 7000
	Shade.Cash = 10000
	Camera.Position = CV.CenterPosition

	NitroDeathObjective = Penta.AddPrimaryObjective("Eliminate the Nitro.")
	Media.DisplayMessage("The Shade are making their way here as they speak. If they show up, eliminate them too!")

	Trigger.OnTimerExpired(function()
		SendShadeForces()
	end)
end

Tick = function()
	if (Nitro.HasNoRequiredUnits() and NitroGuard.HasNoRequiredUnits()) then
		Penta.MarkCompletedObjective(NitroDeathObjective)
	end

	if ShadeInTheArea and Shade.HasNoRequiredUnits() then
		Penta.MarkCompletedObjective(ShadeDeathObjective)
	end

end