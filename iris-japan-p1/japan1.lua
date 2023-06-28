Transport = "lst"
TransportOne = {"gtnk", "e1", "e1", "e3", "e3"}
TransportTwo = {"gtnk", "gtnk", "mcv"}
TransportThree = {"ifv", "ifv", "e3", "e3", "e3"}
Destroyer = {"dd"}

SpawnPoints = {WaypointOne, WaypointTwo, WaypointThree, WaypointFour, WaypointFive}
EndPoints = {DestOne, DestTwo, DestThree, DestFour, DestFive}
TurretsWest = {TurretOne, TurretTwo, TurretThree, TurretFour, TurretFive}
TurretsEast = {TurretSix, TurretSeven, TurretEight, TurretNine}
EastTurretsDead = false
WestTurretsDead = false
MCVDeployed = false
IntialForcesLost = false

ReinforcePlayerWhenBeachheadDestroyed = function()
	if (EastTurretsDead == false) then
		EastTurretsDead = true
	end
	Reinforcements.ReinforceWithTransport(Penta, Transport, TransportOne, {SpawnPoints[1].Location, EndPoints[1].Location})
	Reinforcements.ReinforceWithTransport(Penta, Transport, TransportOne, {SpawnPoints[3].Location, EndPoints[3].Location})
	Reinforcements.ReinforceWithTransport(Penta, Transport, TransportTwo, {SpawnPoints[2].Location, EndPoints[2].Location})
	Media.DisplayMessage("Reinforcements have arrived.")

end

ReinforcePlayerWhenEastBeachDestroyed = function()
	if (WestTurretsDead == false) then
		WestTurretsDead = true
	end
	Reinforcements.Reinforce(Penta, Destroyer, {SpawnPoints[1].Location, EndPoints[1].Location})
	Reinforcements.Reinforce(Penta, Destroyer, {SpawnPoints[2].Location, EndPoints[2].Location})
	Reinforcements.Reinforce(Penta, Destroyer, {SpawnPoints[3].Location, EndPoints[3].Location})
	Media.DisplayMessage("Reinforcements have arrived.")
end

ReinforcePlayerOnBaseBuilt = function()
	Reinforcements.ReinforceWithTransport(Penta, Transport, TransportThree, {SpawnPoints[1].Location, EndPoints[1].Location})
	Reinforcements.ReinforceWithTransport(Penta, Transport, TransportThree, {SpawnPoints[3].Location, EndPoints[3].Location})
	Media.DisplayMessage("Reinforcements have arrived.")
end

WorldLoaded = function()
    Penta = Player.GetPlayer("Penta")
	PentaAlly = Player.GetPlayer("PentaAlly")
    DA = Player.GetPlayer("DA")

    DestroyObjective = Penta.AddPrimaryObjective("Eliminate the DA forces at the beachhead.")
    DefendObjective = DA.AddPrimaryObjective("Defend against the Penta.")

	InitialForces = Penta.GetActorsByTypes({"dd", "ca"})
	Trigger.OnAllKilled(InitialForces, function()
		InitialForcesLost = true
		if (Penta.HasNoRequiredUnits) then
			DA.MarkCompletedObjective(DefendObjective)
		end
	end)

	
	Trigger.AfterDelay(DateTime.Seconds(5), function()
		Reinforcements.ReinforceWithTransport(PentaAlly, Transport, TransportThree, {AllyWaypointOne.Location, AllyDropoffOne.Location}, nil, function(ta, a)
			ta.UnloadPassengers()
			for i=1, #a do
				a[i].Hunt()
			end	
		end)
		Reinforcements.ReinforceWithTransport(PentaAlly, Transport, TransportThree, {AllyWaypointTwo.Location, AllyDropoffTwo.Location}, nil, function(ta, a)
			ta.UnloadPassengers()
			for i=1, #a do
				a[i].Hunt()
			end	
		end)
	end)

	Trigger.OnAllKilled(TurretsWest, function()
		ReinforcePlayerWhenBeachheadDestroyed()
	end)

	Trigger.OnAllKilled(TurretsEast, function()
		ReinforcePlayerWhenEastBeachDestroyed()
	end)

	
	
end

Tick = function()
	if(DA.HasNoRequiredUnits()) then
		Penta.MarkCompletedObjective(DestroyObjective)
	end

	if (InitialForcesLost == true and Penta.HasNoRequiredUnits()) then
		DA.MarkCompletedObjective(DefendObjective)
	end

	if (MCVDeployed == false and #(Penta.GetActorsByType("fact")) ~= 0) then
		MCVDeployed = true
		ReinforcePlayerOnBaseBuilt()
	end
end