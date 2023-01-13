
NitroConvoy = {"3tnk", "3tnk", "e3", "e3", "e1", "e1"}
NitroMCV = {"mcv"}

SendNitroForces = function()
	Reinforcements.Reinforce(Nitro, NitroConvoy, {DaWaeOne.Location, NitroPoint.Location})
	Reinforcements.Reinforce(Nitro, NitroConvoy, {DaWaeTwo.Location, NitroPoint.Location})
	Reinforcements.Reinforce(Nitro, NitroConvoy, {DaWaeThree.Location, NitroPoint.Location})
end

SendNitroMCV = function()
	Reinforcements.Reinforce(Nitro, NitroMCV, {DaWaeTwo.Location, MCVDeploy.Location}, 0, function(mcv)
		Trigger.OnIdle(mcv, function()
			mcv.Deploy()
		end)
	end)
end

WorldLoaded = function()
	Penta = Player.GetPlayer("Penta")
	Nitro = Player.GetPlayer("Nitro")
	DA = Player.GetPlayer("DA")
	Camera.Position = Actor177.CenterPosition

	PlayerObjective = Penta.AddPrimaryObjective("Eliminate all DA and Nitro forces")
	NitroObjective = Nitro.AddPrimaryObjective("Destroy the DA and Penta.")
	DefendObjective = DA.AddPrimaryObjective("Defend against the Penta and Nitro.")

	Trigger.AfterDelay(DateTime.Seconds(10), SendNitroForces)
	Trigger.AfterDelay(DateTime.Seconds(30), SendNitroMCV)
end

Tick = function()
	if (DA.HasNoRequiredUnits() and Nitro.HasNoRequiredUnits()) then
		Penta.MarkCompletedObjective(PlayerObjective)
	end
	if (DA.HasNoRequiredUnits() and Penta.HasNoRequiredUnits()) then
		Nitro.MarkCompletedObjective(NitroObjective)
	end
	if (Nitro.HasNoRequiredUnits() and Penta.HasNoRequiredUnits()) then
		DA.MarkCompletedObjective(DefendObjective)
	end
end