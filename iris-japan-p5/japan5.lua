WorldLoaded = function()
	Penta = Player.GetPlayer("Penta")
	Nitro = Player.GetPlayer("Nitro")
	Camera.Position = Actor102.CenterPosition

	DestroyObjective = Penta.AddPrimaryObjective("Eliminate all Nitro forces.")
end

Tick = function()
	if (Penta.HasNoRequiredUnits()) then
		Penta.MarkFailedObjective(DestroyObjective)
	end

	if (Nitro.HasNoRequiredUnits()) then
		Penta.MarkCompletedObjective(DestroyObjective)
	end
end