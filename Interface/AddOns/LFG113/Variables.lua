	local _, L = ...

	L.Functions = {}

	-- Default Values
	L.Variables = { ["version"] = "Version 1.16", ["author"] = "Joseph Forrest", ["date"] = "09/20/2019", ["update"] = "02/21/2021" }

	-- Visual Frames
	L.Frames = {}
	L.Frames.mainFrame = CreateFrame ("Frame", "LFG113_MainFrame", UIParent, "BasicFrameTemplate")
	L.Frames.popupFrame = CreateFrame ("Frame", nil, UIParent, "BasicFrameTemplate")
	L.Frames.updatedFrame = CreateFrame ("Frame", nil, UIParent, "BasicFrameTemplate")
	L.Frames.MinimapButton = CreateFrame ("Button", nil, Minimap)

	-- Frames for events
	L.Frames.rosterFrame = CreateFrame ("Frame")
	L.Frames.autoInviteFrame = CreateFrame ("Frame")
	L.Frames.chatFrame = CreateFrame( "Frame" )

	L.Variables.BroadCastChannel = "LFG113V04a"
	L.Variables.AddOnChatWindowMessages, L.Variables.BasicFramePool, L.Variables.FramePool, L.Variables.CurrentSearch, L.Variables.TableRowList, L.Variables.tableOpen = {}, {}, {}, {}, {}, {}
	L.Variables.TabViewing, L.Variables.ActivitySelected, L.Variables.AllDungeonsChecked = 0, 1, false
	L.Variables.CanDPS, L.Variables.CanHeal, L.Variables.CanTank = false, false, false
	L.Variables.broadcastAppString, L.Variables.broadcastOriginalString, L.Variables.CustomSearchString = "", "", ""
	L.Variables.guildName, L.Variables.guildOnly, L.Variables.guildBroadcastTime = "", false, 1
	L.Variables.NotifiedOfUpdate, L.Variables.PeopleWaiting = false, false
	L.Variables.FirstResponder = nil
	L.Variables.LoadedPremade = nil

	L.Variables.InstancesSorted = { "any", "rfc", "wc", "vc", "sfk", "bfd", "stocks", "gnomer", "rfk", "internalsm", "sm gy", "sm lib", "sm arm", "sm cath", "rfd", "internalulda", "ulda front", "ulda back", "zf", "internalmara", "mara purple", "mara orange", "mara princess", "st", "internalbrd", "brd anger", "brd arena", "brd golem", "lbrs", "internaldm", "dm west", "dm north", "dm east", "dm tribute", "internalstrat", "strat live", "strat dead", "scholo" }
	L.Variables.RaidsSorted = { "any", "ubrs", "ony", "zg", "mc", "bwl", "aq20", "aq40", "naxx" }
	L.Variables.PVPSorted = { "any", "world", "av", "wg", "ab" }

	L.Variables.QuestingNKSorted = { "any", "teldrassil", "darkshore", "ashvale", "azshara", "felwood", "winterspring", "moonglade" }
	L.Variables.QuestingNK = {
		["any"]			= {1, "Select Any", 1, 60, "Any"},
		["teldrassil"]	= {20, "Teldrassil", 1, 10, "Northern Kalimdor" },
		["darkshore"]	= {20, "Darkshore", 10, 20, "Northern Kalimdor" },
		["ashvale"]		= {20, "Ashvale", 18, 30, "Northern Kalimdor" },
		["azshara"]		= {20, "Azshara", 45, 55, "Northern Kalimdor" },
		["felwood"]		= {20, "Felwood", 48, 55, "Northern Kalimdor" },
		["winterspring"]= {20, "Winterspring", 53, 60, "Northern Kalimdor" },
		["moonglade"]	= {20, "Moonglade", 55, 60, "Northern Kalimdor" }
	}

	L.Variables.QuestingCKSorted = { "any", "durotar", "malgore", "the barrens", "stonetalon mountains", "desolace", "dustwallow marsh" }
	L.Variables.QuestingCK = {
		["any"]			= {1, "Select Any", 1, 60, "Any"},
		["durotar"]		= {20, "Durotar", 1, 10, "Central Kalimdor" },
		["malgore"]		= {20, "Malgore", 1, 10, "Central Kalimdor" },
		["the barrens"]	= {20, "The Barrens", 10, 25, "Central Kalimdor" },
		["stonetalon mountains"]= {20, "Stonetalon Mountains", 15, 27, "Central Kalimdor" },
		["desolace"]		= {20, "Desolace", 30, 40, "Central Kalimdor" },
		["dustwallow marsh"]	= {20, "Dustwallow Marsh", 35, 45, "Central Kalimdor" }
	}

	L.Variables.QuestingSKSorted = { "any", "thousand needles", "feralus", "tanaris desert", "ungoro crater", "silithus" }
	L.Variables.QuestingSK = {
		["any"]			= {1, "Select Any", 1, 60, "Any"},
		["thousand needles"]	= {20, "Thousand Needles", 25, 35, "Southern Kalimdor" },
		["feralus"]		= {20, "Feralus", 40, 50, "Southern Kalimdor" },
		["tanaris desert"]	= {20, "Tanaris Desert", 40, 50, "Southern Kalimdor" },
		["ungoro crater"]	= {20, "Ungoro Crater", 48, 55, "Southern Kalimdor" },
		["silithus"]		= {20, "Silithus", 55, 60, "Southern Kalimdor" }
	}

	L.Variables.QuestingALSorted = { "any", "tirisfal glades", "silverpine forest", "hillsbrad foothills", "alterac mountains", "arathi highlands", "the hinterlands", "western plaguelands", "eastern plaguelands" }
	L.Variables.QuestingAL = {
		["any"]			= {1, "Select Any", 1, 60, "Any"},
		["tirisfal glades"]	= {20, "Tirisfal Glades", 1, 10, "Lordaeron" },
		["silverpine forest"]	= {20, "Silverpine Forest", 10, 20, "Lordaeron" },
		["hillsbrad foothills"]	= {20, "Hillsbrad Foothills", 20, 30, "Lordaeron" },
		["alterac mountains"]	= {20, "Alterac Mountains", 30, 40, "Lordaeron" },
		["arathi highlands"]	= {20, "Arathi Highlands", 30, 40, "Lordaeron" },
		["the hinterlands"]	= {20, "The Hinterlands", 40, 50, "Lordaeron" },
		["western plaguelands"]	= {20, "Western Plaguelands", 51, 58, "Lordaeron" },
		["eastern plaguelands"]	= {20, "Eastern Plaguelands", 53, 60, "Lordaeron" }
	}

	L.Variables.QuestingAKSorted = { "any", "dun morogh", "loch modan", "wetlands", "badlands", "searing gorge", "blackrock mountain" }
	L.Variables.QuestingAK = {
		["any"]		= {1, "Select Any", 1, 60, "Any"},
		["dun morogh"]		= {20, "Dun Morogh", 1, 10, "Khaz Modan" },
		["loch modan"]		= {20, "Loch Modan", 10, 20, "Khaz Modan" },
		["wetlands"]		= {20, "Wetlands", 20, 30, "Khaz Modan" },
		["badlands"]		= {20, "Badlands", 35, 45, "Khaz Modan" },
		["searing gorge"]	= {20, "Searing Gorge", 45, 50, "Khaz Modan" },
		["blackrock mountain"]	= {20, "Blackrock Mountain", 55, 60, "Khaz Modan" }
	}

	L.Variables.QuestingAASorted = { "any", "elwynn forest", "westfall", "redridge mountains", "duskwood", "stranglethorn vale", "swamp of sorrows", "blasted lands", "burning steppes", "deadwind pass" }
	L.Variables.QuestingAA = {
		["any"]		= {1, "Select Any", 1, 60, "Any"},
		["elwynn forest"]	= {20, "Elwynn Forest", 1, 10, "Azeroth" },
		["westfall"]		= {20, "Westfall", 10, 20, "Azeroth" },
		["redridge mountains"]	= {20, "Redridge Mountains", 15, 25, "Azeroth" },
		["duskwood"]		= {20, "Duskwood", 18, 30, "Azeroth" },
		["stranglethorn vale"]	= {20, "Stranglethorn Vale", 30, 45, "Azeroth" },
		["swamp of sorrows"]	= {20, "Swamp of Sorrows", 35, 45, "Azeroth" },
		["blasted lands"]	= {20, "Blasted Lands", 45, 55, "Azeroth" },
		["burning steppes"]	= {20, "Burning Steppes", 50, 58, "Azeroth" },
		["deadwind pass"]	= {20, "Deadwind Pass", 55, 60, "Azeroth" }
	}

	L.Variables.PlayerClass = { -- Roles = Tank, Healer, DPS
		["druid"]		= { ["roles"] = { true, true, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .75, ["ey"] = 1 } },
		["hunter"]		= { ["roles"] = { false, false, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .25, ["ey"] = .5 } },
		["mage"]		= { ["roles"] = { false, false, true }, ["map"] = { ["sx"] = .75, ["ex"] = .875, ["sy"] = 0, ["ey"] = .25 } },
		["rogue"]		= { ["roles"] = { false, false, true }, ["map"] = { ["sx"] = .875, ["ex"] = 1, ["sy"] = 0, ["ey"] = .25 } },
		["paladin"]		= { ["roles"] = { true, true, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .5, ["ey"] = .75 } },
		["pally"]		= { ["roles"] = { true, true, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .5, ["ey"] = .75 } },
		["priest"]		= { ["roles"] = { false, true, true }, ["map"] = { ["sx"] = .875, ["ex"] = 1, ["sy"] = .25, ["ey"] = .5 } },
		["shaman"]		= { ["roles"] = { false, true, true }, ["map"] = { ["sx"] = .75, ["ex"] = .875, ["sy"] = .25, ["ey"] = .5 } },
		["warlock"]		= { ["roles"] = { false, false, true }, ["map"]  = { ["sx"] = .75, ["ex"] = .875, ["sy"] = .75, ["ey"] = 1 } },
		["warrior"]		= { ["roles"] = { true, false, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = 0, ["ey"] = .25 } },
	}

	L.Variables.PlayerRace = {
		["Human"]		= { ["map"] = { ["sx"] = 0, ["ex"] = .125, ["sy"] = 0, ["ey"] = .25 } },
		["Dwarf"]		= { ["map"] = { ["sx"] = .125, ["ex"] = .25, ["sy"] = 0, ["ey"] = .25 } },
		["Gnome"]		= { ["map"] = { ["sx"] = .25, ["ex"] = .375, ["sy"] = 0, ["ey"] = .25 } },
		["NightElf"]	= { ["map"] = { ["sx"] = .375, ["ex"] = .5, ["sy"] = 0, ["ey"] = .25 } },
		["Draenei"]		= { ["map"] = { ["sx"] = .5, ["ex"] = .725, ["sy"] = 0, ["ey"] = .25 } },
		["Tauren"]		= { ["map"] = { ["sx"] = 0, ["ex"] = .125, ["sy"] = .25, ["ey"] = .5 } },
		["Undead"]		= { ["map"] = { ["sx"] = .125, ["ex"] = .25, ["sy"] = .25, ["ey"] = .5 } },
		["Troll"]		= { ["map"] = { ["sx"] = .25, ["ex"] = .375, ["sy"] = .25, ["ey"] = .5 } },
		["Orc"]			= { ["map"] = { ["sx"] = .375, ["ex"] = .5, ["sy"] = .25, ["ey"] = .5 } },
		["BloodElf"]	= { ["map"] = { ["sx"] = .5, ["ex"] = .725, ["sy"] = .25, ["ey"] = .5 } },
	}

	L.Variables.didMovingEyeDelay = true
	L.Variables.MovingEyeDelay = 0
	L.Variables.MovingEyeFrame = 0
	L.Variables.MovingEyeActionIndex = 0
	L.Variables.MovingEyeKey = {
		["x"] =	{ 0, .125, .25, .375, .5, .625, .75, .875 },
		["y"] = { 0, .25, .5, .75 },
		["dimensions"] = { .125, .25 }
	}

	L.Variables.MovingEyeActions = {	-- {index of loop start, index of loop end, index of delay}
		{ 1, 10, 5 }, -- Close
		{ 10, 20, 15 }, -- Look left
		{ 20, 29, 25 }, -- Look right
		{ 10, 29, 0 } -- Look left, right then center no delay
	}

	-- Get current Players name and server
	L.Variables.Player, L.Variables.Server = UnitFullName("player")
	L.Variables.Player = L.Variables.Player:lower()
