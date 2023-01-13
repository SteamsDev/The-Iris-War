WorldLoaded = function()
	Penta = Player.GetPlayer("Penta")
	DA = Player.GetPlayer("DA")
	Camera.Position = Actor95.CenterPosition
	Penta.Cash = 8000

	CaptureObjective = Penta.AddPrimaryObjective("Capture the DA Headquarters.")
	Media.DisplayMessage("Capture the DA Headquarters. DO NOT DESTROY IT!!!", "Objective: ")

	Trigger.OnKilled(DAHQ, function()
		Player.MarkFailedObjective(CaptureObjective)
	end)

	Trigger.OnCapture(DAHQ, function()
		Penta.MarkCompletedObjective(CaptureObjective)
	end)
end

Tick = function()
	if (Penta.HasNoRequiredUnits()) then
		Penta.MarkFailedObjective(CaptureObjective)
	end
end