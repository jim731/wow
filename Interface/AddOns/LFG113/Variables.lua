	local _, L = ...

	L.Functions = {}

	-- Default Values
	L.Variables = { ["version"] = "Version 2.06", ["author"] = "Joseph Forrest", ["date"] = "09/20/2019", ["update"] = "06/07/2021" }

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

	L.Variables.InstancesSorted = { "any", "rfc", "wc", "vc", "sfk", "bfd", "stocks", "gnomer", "rfk", "internalsm", "sm gy", "sm lib", "sm arm", "sm cath", "rfd", "internalulda", "ulda front", "ulda back", "zf", "internalmara", "mara purple", "mara orange", "mara princess", "st", "internalbrd", "brd anger", "brd arena", "brd golem", "lbrs", "ubrs", "internaldm", "dm west", "dm north", "dm east", "dm tribute", "internalstrat", "strat live", "strat dead", "scholo",
		"ramparts", "furnace", "shattered", "slavepens", "theunderbog", "thesteamvaults", "manatombs", "auchenaicrypts", "sethekkhalls", "shadowlabyrinth", "escapefromdurnholde", "blackmorass", "openingofthedarkportal", "themechanar", "thebotanica", "thearcatraz", "magistersterrace",
		"hramparts", "hfurnace", "hshattered", "hslavepens", "htheunderbog", "hthesteamvaults", "hmanatombs", "hauchenaicrypts", "hsethekkhalls", "hshadowlabyrinth", "hescapefromdurnholde", "hblackmorass", "hopeningofthedarkportal", "hthemechanar", "hthebotanica", "hthearcatraz", "hmagistersterrace" }
	L.Variables.RaidsSorted = { "any", "ony", "zg", "mc", "bwl", "aq20", "aq40", "naxx",
		"magtheridonslair", "serpentshrinecavern", "theeye", "karazhan", "gruulslair", "thebattleformounthyjal", "blacktemple", "zulaman", "sunwellplateau", "doomwalker", "doomlordkazzak" }
	L.Variables.PVPSorted = { "any", "world", "av", "wg", "ab",
		"eyeofthestorm" }

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
		[1]		= { ["roles"] = { true, false, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = 0, ["ey"] = .25 } },	-- warrior
		[2]		= { ["roles"] = { true, true, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .5, ["ey"] = .75 } },	-- paladin
		[3]		= { ["roles"] = { false, false, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .25, ["ey"] = .5 } },	-- hunter
		[4]		= { ["roles"] = { false, false, true }, ["map"] = { ["sx"] = .875, ["ex"] = 1, ["sy"] = 0, ["ey"] = .25 } },	-- rogue
		[5]		= { ["roles"] = { false, true, true }, ["map"] = { ["sx"] = .875, ["ex"] = 1, ["sy"] = .25, ["ey"] = .5 } },	-- priest
		[7]		= { ["roles"] = { false, true, true }, ["map"] = { ["sx"] = .75, ["ex"] = .875, ["sy"] = .25, ["ey"] = .5 } },	-- shaman
		[8]		= { ["roles"] = { false, false, true }, ["map"] = { ["sx"] = .75, ["ex"] = .875, ["sy"] = 0, ["ey"] = .25 } },	-- mage
		[9]		= { ["roles"] = { false, false, true }, ["map"]  = { ["sx"] = .75, ["ex"] = .875, ["sy"] = .75, ["ey"] = 1 } },	-- warlock
		[11]		= { ["roles"] = { true, true, true }, ["map"] = { ["sx"] = .625, ["ex"] = .75, ["sy"] = .75, ["ey"] = 1 } },	-- druid
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

	L.Variables.InstanceBasicInfo = { -- { Number People, Minimum level, Maximum level, (# Tank, # healers, # dps } }, "use PulldownSecondChance #8", { Quest chains required for attunement }, { faction, ... }, faction level required }
		["any"]						= {1, 1, 60 },
		-- Vanilla
		["rfc"]						= {5, 13, 18, {1,1,3}, nil, nil, nil, nil },
		["wc"]						= {5, 17, 24, {1,1,3}, nil, nil, nil, nil },
		["vc"]						= {5, 17, 26, {1,1,3}, nil, nil, nil, nil },
		["sfk"]						= {5, 22, 30, {1,1,3}, nil, nil, nil, nil },
		["bfd"]						= {5, 24, 32, {1,1,3}, nil, nil, nil, nil },
		["stocks"]					= {5, 24, 32, {1,1,3}, nil, nil, nil, nil },
		["gnomer"]					= {5, 29, 38, {1,1,3}, nil, nil, nil, nil },
		["rfk"]						= {5, 29, 38, {1,1,3}, nil, nil, nil, nil },
		["internalsm"]				= {5, 26, 45, {1,1,3}, "1:sm gy!1:sm lib!1:sm arm!1:sm cath!1:internalsm", nil, nil, nil },
		["sm gy"]					= {5, 26, 36, {1,1,3}, "1:sm gy!1:internalsm", nil, nil, nil },
		["sm lib"]					= {5, 29, 39, {1,1,3}, "1:sm lib!1:internalsm", nil, nil, nil },
		["sm arm"]					= {5, 32, 42, {1,1,3}, "1:sm arm!1:internalsm", nil, nil, nil },
		["sm cath"]					= {5, 34, 45, {1,1,3}, "1:sm cath!1:internalsm", nil, nil, nil },
		["rfd"]						= {5, 37, 46, {1,1,3}, nil, nil, nil, nil },
		["internalulda"]			= {5, 41, 51, {1,1,3}, "1:ulda front!1:ulda back!1:internalulda", nil, nil, nil },
		["ulda front"]				= {5, 41, 51, {1,1,3}, "1:ulda front!1:internalulda", nil, nil, nil },
		["ulda back"]				= {5, 41, 51, {1,1,3}, "1:ulda back!1:internalulda", nil, nil, nil },
		["zf"]						= {5, 42, 46, {1,1,3}, nil, nil, nil, nil },
		["internalmara"]			= {5, 46, 55, {1,1,3}, "1:mara purple!1:mara orange!1:mara princess!1:internalmara", nil, nil, nil },
		["mara purple"]				= {5, 46, 55, {1,1,3}, "1:mara purple!1:internalmara", nil, nil, nil },
		["mara orange"]				= {5, 46, 55, {1,1,3}, "1:mara orange!1:internalmara", nil, nil, nil },
		["mara princess"]			= {5, 46, 55, {1,1,3}, "1:mara princess!1:internalmara", nil, nil, nil },
		["st"]						= {5, 50, 56, {1,1,3}, nil, nil, nil, nil },
		["internalbrd"]				= {5, 52, 60, {1,1,3}, "1:brd arena!1:brd anger!1:brd golem!1:internalbrd", nil, nil, nil },
		["brd arena"]				= {5, 52, 60, {1,1,3}, "1:brd arena!1:internalbrd", nil, nil, nil },
		["brd anger"]				= {5, 52, 60, {1,1,3}, "1:brd anger!1:internalbrd", nil, nil, nil },
		["brd golem"]				= {5, 52, 60, {1,1,3}, "1:brd golem!1:internalbrd", nil, nil, nil },
		["lbrs"]					= {5, 55, 60, {1,1,3}, nil, nil, nil, nil },
		["internaldm"]				= {5, 55, 60, {1,1,3}, "1:dm west!1:dm north!1:dm east!1:dm tribute!1:internaldm", nil, nil, nil },
		["dm west"]					= {5, 55, 60, {1,1,3}, "1:dm west!1:internaldm", nil, nil, nil },
		["dm north"]				= {5, 55, 60, {1,1,3}, "1:dm north!1:internaldm", nil, nil, nil },
		["dm east"]					= {5, 55, 60, {1,1,3}, "1:dm east!1:internaldm", nil, nil, nil },
		["dm tribute"]				= {5, 55, 60, {1,1,3}, nil, nil, nil, nil },
		["internalstrat"]			= {5, 58, 60, {1,1,3}, "1:strat live!1:strat dead!1:internalstrat", nil, nil, nil },
		["strat live"]				= {5, 58, 60, {1,1,3}, "1:dm tribute!1:internaldm", nil, nil, nil },
		["strat dead"]				= {5, 58, 60, {1,1,3}, "1:strat live!1:strat dead!1:internalstrat", nil, nil, nil },
		["scholo"]					= {5, 58, 60, {1,1,3}, "1:strat live!1:internalstrat", nil, nil, nil },
		-- TBC
		["ramparts"]				= {5, 60, 62, {1,1,3}, nil, nil, nil, nil },
		["furnace"]					= {5, 61, 63, {1,1,3}, nil, nil, nil, nil },
		["shattered"]				= {5, 70, 72, {1,1,3}, nil, nil, nil, nil },
		["slavepens"]				= {5, 62, 64, {1,1,3}, nil, nil, nil, nil },
		["theunderbog"]				= {5, 63, 65, {1,1,3}, nil, nil, nil, nil },
		["thesteamvaults"]			= {5, 70, 72, {1,1,3}, nil, nil, nil, nil },
		["manatombs"]				= {5, 64, 66, {1,1,3}, nil, nil, nil, nil },
		["auchenaicrypts"]			= {5, 65, 67, {1,1,3}, nil, nil, nil, nil },
		["sethekkhalls"]			= {5, 67, 69, {1,1,3}, nil, nil, nil, nil },
		["shadowlabyrinth"]			= {5, 70, 72, {1,1,3}, nil, nil, nil, nil },
		["escapefromdurnholde"]		= {5, 66, 68, {1,1,3}, nil, nil, nil, nil },
		["blackmorass"]				= {5, 69, 72, {1,1,3}, nil, nil, nil, nil },
		["openingofthedarkportal"]	= {5, 69, 70, {1,1,3}, nil, nil, nil, nil },
		["themechanar"]				= {5, 69, 72, {1,1,3}, nil, nil, nil, nil },
		["thebotanica"]				= {5, 70, 72, {1,1,3}, nil, nil, nil, nil },
		["thearcatraz"]				= {5, 70, 72, {1,1,3}, nil, nil, nil, nil },
		["magistersterrace"]		= {5, 70, 70, {1,1,3}, nil, nil, nil, nil },
		-- TBC Heroic
		["hramparts"]				= {5, 70, 72, {1,1,3}, nil, nil, { 946, 947 }, 7 },
		["hfurnace"]				= {5, 70, 72, {1,1,3}, nil, nil, { 946, 947 }, 7 },
		["hshattered"]				= {5, 70, 72, {1,1,3}, nil, nil, { 946, 947 }, 7 },
		["hslavepens"]				= {5, 70, 72, {1,1,3}, nil, nil, { 942 }, 7 },
		["htheunderbog"]			= {5, 70, 72, {1,1,3}, nil, nil, { 942 }, 7 },
		["hthesteamvaults"]			= {5, 70, 72, {1,1,3}, nil, nil, { 942 }, 7 },
		["hmanatombs"]				= {5, 70, 72, {1,1,3}, nil, nil, { 1011 }, 7 },
		["hauchenaicrypts"]			= {5, 70, 72, {1,1,3}, nil, nil, { 1011 }, 7 },
		["hsethekkhalls"]			= {5, 70, 69, {1,1,3}, nil, nil, { 1011 }, 7 },
		["hshadowlabyrinth"]		= {5, 70, 72, {1,1,3}, nil, nil, { 1011 }, 7 },
		["hescapefromdurnholde"]	= {5, 70, 72, {1,1,3}, nil, nil, { 989 }, 7 },
		["hblackmorass"]			= {5, 70, 72, {1,1,3}, nil, nil, { 989 }, 7 },
		["hopeningofthedarkportal"]	= {5, 70, 70, {1,1,3}, nil, nil, { 989 }, 7 },
		["hthemechanar"]			= {5, 70, 72, {1,1,3}, nil, nil, { 935 }, 7 },
		["hthebotanica"]			= {5, 70, 72, {1,1,3}, nil, nil, { 935 }, 7 },
		["hthearcatraz"]			= {5, 70, 72, {1,1,3}, nil, nil, { 935 }, 7 },
		["hmagistersterrace"]		= {5, 70, 72, {1,1,3}, nil, { 11492 }, nil, nil },
	}

	L.Variables.SecondChanceBasicInfo = {
		["sm"]						= {5, 26, 45, {1,1,3}, "1:internalsm!1:sm gy!1:sm lib!1:sm arm!1:sm cath", nil, nil, nil },
		["ulda"]					= {5, 41, 51, {1,1,3}, "1:internalulda!1:ulda front!1:ulda back", nil, nil, nil },
		["mara"]					= {5, 46, 55, {1,1,3}, "1:internalmara!1:mara purple!1:mara orange!1:mara princess", nil, nil, nil },
		["brd"]						= {5, 52, 60, {1,1,3}, "1:internalbrd!1:brd arena!1:brd anger!1:brd golem", nil, nil, nil },
		["dm"]						= {5, 55, 60, {1,1,3}, "1:internaldm!1:dm west!1:dm north!1:dm east!1:dm tribute", nil, nil, nil },
		["strat"]					= {5, 58, 60, {1,1,3}, "1:internalstrat!1:strat live!1:strat dead", nil, nil, nil },
	}

	L.Variables.RaidBasicInfo = {
		["any"]						= {1, 1, 60, {1,1,3}, nil, nil, nil, nil },
		["ubrs"]					= {10, 55, 60, {1,1,3}, nil, nil, nil, nil },
		["ony"]						= {40, 60, 61, {2,8,30}, nil, nil, nil, nil },
		["zg"]						= {20, 60, 61, {2,4,14}, nil, nil, nil, nil },
		["mc"]						= {40, 60, 61, {2,8,30}, nil, nil, nil, nil },
		["bwl"]						= {40, 60, 62, {2,8,30}, nil, nil, nil, nil },
		["aq20"]					= {20, 60, 62, {2,4,14}, nil, nil, nil, nil },
		["aq40"]					= {40, 60, 63, {2,8,30}, nil, nil, nil, nil },
		["naxx"]					= {40, 60, 64, {2,8,30}, nil, nil, nil, nil },
		-- TBC
		["karazhan"]				= {10, 70, 70, {2,3,5}, nil, { 9838, 9837, 9836, 9832, 9831, 9829, 9826, 9825, 9824 }, nil, nil },
		["gruulsLair"]				= {25, 70, 70, {3,8,29}, nil, nil, nil, nil },
		["magtheridonslair"]		= {25, 70, 70, {4,8,28}, nil, nil, nil, nil },
		["serpentshrinecavern"]		= {25, 70, 70, {4,8,28}, nil, { 10901 }, nil, nil },
		["theeye"]					= {25, 70, 70, {4,8,28}, nil, { 10888, 10886, 10885, 10884, 10588, 10523, 10579, 10541, 10519, 10515, 10514, 10431, 10481, 10480, 10458, 10680 }, nil, nil },
		["thebattleformounthyjal"]	= {25, 70, 70, {4,8,28}, nil, { 10445 }, nil, nil },
		["blacktemple"]				= {25, 70, 70, {4,8,28}, nil, { 10959, 10957, 10958, 10985, 10949, 10948, 10947, 10946, 10944, 10708 }, nil, nil },
		["zulaman"]					= {10, 70, 70, {2,3,5}, nil, nil, nil, nil },
		["sunwellplateau"]			= {25, 70, 70, {4,8,28}, nil, nil, nil, nil },
		["doomwalker"]				= {40, 70, 70, {5,15,20}, nil, nil, nil, nil },
		["doomlordkazzak"]			= {40, 70, 70, {5,15,20}, nil, nil, nil, nil },
	}

	L.Variables.PVPBasicInfo = {
		-- Vanilla
		["any"]						= {1, 1, 60, {1,1,3}, nil, nil, nil, nil },
		["av"]						= {5, 1, 60, {}, nil, nil, nil, nil },
		["wg"]						= {5, 1, 60, {}, nil, nil, nil, nil },
		["ab"]						= {5, 1, 60, {}, nil, nil, nil, nil },
		["world"]					= {40, 1, 60, {}, nil, nil, nil, nil },
		-- TBC
		["eyeofthestorm"]			= {5, 1, 60, {}, nil, nil, nil, nil },
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
