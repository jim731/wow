
TotemTimers_GlobalSettings = {
	["Sink"] = {
	},
	["Version"] = 11,
	["Profiles"] = {
		["Baeldemos"] = {
			{
				["party"] = "default",
				["scenario"] = "default",
				["none"] = "default",
				["raid"] = "default",
				["arena"] = "default",
				["pvp"] = "default",
			}, -- [1]
			{
				["party"] = "default",
				["scenario"] = "default",
				["none"] = "default",
				["raid"] = "default",
				["arena"] = "default",
				["pvp"] = "default",
			}, -- [2]
			{
				["party"] = "default",
				["scenario"] = "default",
				["none"] = "default",
				["raid"] = "default",
				["arena"] = "default",
				["pvp"] = "default",
			}, -- [3]
		},
	},
}
TotemTimers_Profiles = {
	["default"] = {
		["ShowTimerBars"] = false,
		["CrowdControlHex"] = true,
		["EnhanceCDsTimeHeight"] = 12,
		["TimerSpacing"] = 1,
		["EnhanceCDs_Spells"] = {
			{
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				true, -- [6]
				true, -- [7]
				true, -- [8]
				true, -- [9]
				true, -- [10]
				true, -- [11]
				[20] = true,
			}, -- [1]
			{
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				true, -- [6]
				true, -- [7]
				true, -- [8]
				true, -- [9]
				true, -- [10]
				true, -- [11]
				true, -- [12]
				[21] = true,
				[22] = true,
				[20] = true,
			}, -- [2]
			{
				true, -- [1]
				true, -- [2]
				true, -- [3]
				true, -- [4]
				true, -- [5]
				true, -- [6]
				true, -- [7]
				[20] = true,
			}, -- [3]
		},
		["LastWeaponEnchant"] = "Rockbiter Weapon",
		["HideInVehicle"] = true,
		["EnhanceCDsOOCAlpha"] = 0.4,
		["TotemTimerBarWidth"] = 36,
		["TooltipsAtButtons"] = true,
		["TimeFont"] = "Friz Quadrata TT",
		["FulminationAura"] = true,
		["FlashRed"] = true,
		["Show"] = true,
		["EnhanceCDs"] = true,
		["EnhanceCDs_Clickthrough"] = false,
		["Warnings"] = {
			["TotemWarning"] = {
				["a"] = 1,
				["enabled"] = false,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Totem Expiring",
				["g"] = 0,
				["b"] = 0,
			},
			["TotemDestroyed"] = {
				["a"] = 1,
				["enabled"] = false,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Totem Destroyed",
				["g"] = 0,
				["b"] = 0,
			},
			["Maelstrom"] = {
				["a"] = 1,
				["enabled"] = true,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Maelstrom Notifier",
				["g"] = 0,
				["b"] = 0,
			},
			["Shield"] = {
				["a"] = 1,
				["enabled"] = true,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Shield removed",
				["g"] = 0,
				["b"] = 0,
			},
			["EarthShield"] = {
				["a"] = 1,
				["enabled"] = true,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Shield removed",
				["g"] = 0,
				["b"] = 0,
			},
			["TotemExpiration"] = {
				["a"] = 1,
				["enabled"] = false,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Totem Expired",
				["g"] = 0,
				["b"] = 0,
			},
			["Weapon"] = {
				["a"] = 1,
				["enabled"] = true,
				["r"] = 1,
				["sound"] = "",
				["text"] = "Shield removed",
				["g"] = 0,
				["b"] = 0,
			},
		},
		["ColorTimerBars"] = false,
		["TimerTimePos"] = "BOTTOM",
		["TimerTimeHeight"] = 12,
		["CooldownAlpha"] = 0.8,
		["ShieldLeftButton"] = "Lightning Shield",
		["LastOffEnchants"] = {
		},
		["HiddenTotems"] = {
		},
		["Lock"] = false,
		["LavaSurgeAura"] = true,
		["CrowdControlArrange"] = "horizontal",
		["Tracker_Clickthrough"] = false,
		["StopPulse"] = true,
		["TrackerArrange"] = "horizontal",
		["EarthShieldTracker"] = true,
		["AnkhTracker"] = true,
		["CheckRaidRange"] = true,
		["ProcFlash"] = true,
		["EarthShieldButton4"] = "player",
		["FlameShockDurationOnTop"] = false,
		["HideDefaultTotemBar"] = false,
		["EnhanceCDsMaelstromHeight"] = 14,
		["ReverseBarBindings"] = false,
		["CrowdControlSize"] = 30,
		["CrowdControlClickthrough"] = false,
		["LavaSurgeGlow"] = true,
		["TimerBarColor"] = {
			["a"] = 1,
			["b"] = 1,
			["g"] = 0.5,
			["r"] = 0.5,
		},
		["CheckPlayerRange"] = true,
		["LongCooldownsArrange"] = "horizontal",
		["ShowKeybinds"] = true,
		["TimerBarTexture"] = "Blizzard",
		["TimerPositions"] = {
			{
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-50, -- [4]
				-40, -- [5]
			}, -- [1]
			{
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-70, -- [4]
				0, -- [5]
			}, -- [2]
			{
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-30, -- [4]
				0, -- [5]
			}, -- [3]
			{
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-50, -- [4]
				40, -- [5]
			}, -- [4]
		},
		["ShowCooldowns"] = true,
		["EnhanceCDsSize"] = 30,
		["TotemMenuSpacing"] = 0,
		["ESMainTankMenu"] = true,
		["TrackerTimeHeight"] = 12,
		["OpenOnRightclick"] = false,
		["FulminationGlow"] = true,
		["TimerSize"] = 30,
		["CrowdControlEnable"] = true,
		["ActivateHiddenTimers"] = false,
		["CrowdControlTimePos"] = "BOTTOM",
		["FramePositions"] = {
			["TotemTimers_CastBar2"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-200, -- [4]
				-224.9999542236328, -- [5]
			},
			["TotemTimers_CastBar4"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				50, -- [4]
				-224.9999542236328, -- [5]
			},
			["TotemTimers_LongCooldownsFrame"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				150, -- [4]
				-80, -- [5]
			},
			["TotemTimers_EnhanceCDsFrame"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				0, -- [4]
				-170, -- [5]
			},
			["TotemTimers_CastBar3"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				50, -- [4]
				-190.0000152587891, -- [5]
			},
			["TotemTimers_CrowdControlFrame"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-50, -- [4]
				-50, -- [5]
			},
			["TotemTimersFrame"] = {
				"BOTTOM", -- [1]
				nil, -- [2]
				"BOTTOM", -- [3]
				-184.3555755615234, -- [4]
				159.2222290039063, -- [5]
			},
			["TotemTimers_TrackerFrame"] = {
				"BOTTOM", -- [1]
				nil, -- [2]
				"BOTTOM", -- [3]
				-240.1332550048828, -- [4]
				173.7223663330078, -- [5]
			},
			["TotemTimers_CastBar1"] = {
				"CENTER", -- [1]
				nil, -- [2]
				"CENTER", -- [3]
				-200, -- [4]
				-190.0000152587891, -- [5]
			},
		},
		["ESMainTankMenuDirection"] = "auto",
		["TrackerTimeSpacing"] = 0,
		["TimerTimeSpacing"] = 0,
		["CooldownSpacing"] = 5,
		["EarthShieldLeftButton"] = "recast",
		["TimeColor"] = {
			["b"] = 1,
			["g"] = 1,
			["r"] = 1,
		},
		["TimersOnButtons"] = false,
		["Arrange"] = "horizontal",
		["TrackerTimePos"] = "BOTTOM",
		["CrowdControlBindElemental"] = true,
		["LastMainEnchants"] = {
		},
		["EarthShieldTargetName"] = true,
		["Tooltips"] = true,
		["Order"] = {
			1, -- [1]
			2, -- [2]
			3, -- [3]
			4, -- [4]
		},
		["EnhanceCDs_Order"] = {
			{
				1, -- [1]
				2, -- [2]
				3, -- [3]
				4, -- [4]
				5, -- [5]
				6, -- [6]
				7, -- [7]
				8, -- [8]
				9, -- [9]
				10, -- [10]
				11, -- [11]
			}, -- [1]
			{
				1, -- [1]
				2, -- [2]
				3, -- [3]
				4, -- [4]
				5, -- [5]
				6, -- [6]
				7, -- [7]
				8, -- [8]
				9, -- [9]
				10, -- [10]
				11, -- [11]
				12, -- [12]
			}, -- [2]
			{
				1, -- [1]
				2, -- [2]
				3, -- [3]
				4, -- [4]
				5, -- [5]
				6, -- [6]
				7, -- [7]
				8, -- [8]
				9, -- [9]
			}, -- [3]
		},
		["MiniIcons"] = false,
		["ESChargesOnly"] = false,
		["ShieldMiddleButton"] = "Totemic Call",
		["HideBlizzTimers"] = true,
		["MenusAlwaysVisible"] = false,
		["WeaponTracker"] = true,
		["BarBindings"] = true,
		["ShieldRightButton"] = "Water Shield",
		["WeaponMenuOnRightclick"] = false,
		["CastBarDirection"] = "down",
		["WeaponBarDirection"] = "down",
		["ShieldTracker"] = true,
		["TrackerTimerBarWidth"] = 36,
		["TotemSets"] = {
		},
		["TimeStyle"] = "mm:ss",
		["ShieldChargesOnly"] = true,
		["TrackerSize"] = 30,
		["EarthShieldRightButton"] = "target",
		["ShowRaidRangeTooltip"] = true,
		["CDTimersOnButtons"] = true,
		["LastTotems"] = {
			"Searing Totem", -- [1]
			"Strength of Earth Totem", -- [2]
			"Healing Stream Totem", -- [3]
			"Grounding Totem", -- [4]
		},
		["TrackerSpacing"] = 1,
		["EarthShieldMiddleButton"] = "targettarget",
		["ShowOmniCCOnEnhanceCDs"] = true,
		["Timer_Clickthrough"] = false,
		["TotemOrder"] = {
			{
				2894, -- [1]
				30706, -- [2]
				1535, -- [3]
				3599, -- [4]
				8190, -- [5]
				8227, -- [6]
				8181, -- [7]
			}, -- [1]
			{
				5730, -- [1]
				8071, -- [2]
				8075, -- [3]
				2484, -- [4]
				2062, -- [5]
				8143, -- [6]
			}, -- [2]
			{
				5394, -- [1]
				16190, -- [2]
				8166, -- [3]
				8170, -- [4]
				8184, -- [5]
				5675, -- [6]
			}, -- [3]
			{
				8512, -- [1]
				25908, -- [2]
				10595, -- [3]
				8835, -- [4]
				8177, -- [5]
				3738, -- [6]
				6495, -- [7]
				15107, -- [8]
			}, -- [4]
		},
	},
}
