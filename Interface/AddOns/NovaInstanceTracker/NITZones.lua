------------------------------------
---NovaInstance Tracker zones list--
------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("NovaInstanceTracker");

NIT.zones = {
	--Dungeons.
	[33] = {
		name = L["Shadowfang Keep"],
		type = "dungeon",
		expansion = "classic",
	},
	[48] = {
		name = L["Blackfathom Deeps"],
		type = "dungeon",
		expansion = "classic",
	},
	[230] = {
		name = L["Blackrock Depths"],
		type = "dungeon",
		expansion = "classic",
	},
	[229] = {
		name = L["Blackrock Spire"],
		type = "dungeon",
		expansion = "classic",
	},
	[429] = {
		name = L["Dire Maul"],
		type = "dungeon",
		expansion = "classic",
	},
	[90] = {
		name = L["Gnomeregan"],
		type = "dungeon",
		expansion = "classic",
	},
	[349] = {
		name = L["Maraudon"],
		type = "dungeon",
		expansion = "classic",
	},
	[389] = {
		name = L["Ragefire Chasm"],
		type = "dungeon",
		expansion = "classic",
	},
	[129] = {
		name = L["Razorfen Downs"],
		type = "dungeon",
		expansion = "classic",
	},
	[47] = {
		name = L["Razorfen Kraul"],
		type = "dungeon",
		expansion = "classic",
	},
	[1001] = {
		name = L["Scarlet Halls"],
		type = "dungeon",
		expansion = "classic",
	},
	[1004] = {
		name = L["Scarlet Monastery"],
		type = "dungeon",
		expansion = "classic",
	},
	[1007] = {
		name = L["Scholomance"],
		type = "dungeon",
		expansion = "classic",
	},
	[33] = {
		name = L["Shadowfang Keep"],
		type = "dungeon",
		expansion = "classic",
	},
	[329] = {
		name = L["Stratholme"],
		type = "dungeon",
		expansion = "classic",
	},
	[36] = {
		name = L["The Deadmines"],
		type = "dungeon",
		expansion = "classic",
	},
	[34] = {
		name = L["The Stockade"],
		type = "dungeon",
		expansion = "classic",
	},
	[109] = {
		name = L["The Temple of Atal'Hakkar"],
		type = "dungeon",
		expansion = "classic",
	},
	[70] = {
		name = L["Uldaman"],
		type = "dungeon",
		expansion = "classic",
	},
	[43] = {
		name = L["Wailing Caverns"],
		type = "dungeon",
		expansion = "classic",
	},
	[209] = {
		name = L["Zul'Farrak"],
		type = "dungeon",
		expansion = "classic",
	},
	--Raids.
	[249] = {
		name = L["Onyxia's Lair"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[309] = {
		name = L["Zul'gurub"],
		type = "raid",
		expansion = "classic",
	},
	[409] = {
		name = L["Molten Core"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[469] = {
		name = L["Blackwing Lair"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
		maxPlayers = 40,
	},
	[509] = {
		name = L["Ruins of Ahn'Qiraj"],
		type = "raid",
		expansion = "classic",
	},
	[531] = {
		name = L["Temple of Ahn'Qiraj"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
	[533] = {
		name = L["Naxxramas"],
		type = "raid",
		expansion = "classic",
		noLockout = true,
	},
}