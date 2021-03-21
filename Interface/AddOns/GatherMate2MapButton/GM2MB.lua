function ToggleNodes()

	GatherMate2.db.profile["showWorldMap"] = not GatherMate2.db.profile["showWorldMap"]
	GatherMate2:GetModule("Config"):UpdateConfig()
	--LibStub("AceConfigRegistry-3.0"):NotifyChange("GatherMate2")

end