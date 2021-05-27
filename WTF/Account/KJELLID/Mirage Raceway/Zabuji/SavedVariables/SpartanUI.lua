
SpartanUIDB = {
	["namespaces"] = {
		["FilmEffects"] = {
			["profiles"] = {
				["Fermion - Nethergarde Keep"] = {
					["enable"] = true,
					["animationInterval"] = 0.00800000037997961,
					["Effects"] = {
						["crisp"] = {
							["afk"] = false,
						},
					},
				},
			},
		},
	},
	["global"] = {
		["textures"] = {
			["i"] = 0,
		},
		["BartenderChangesActive"] = false,
		["Version"] = "5.3.2",
		["Bartender4"] = {
			["Default"] = {
				["Style"] = "Classic",
			},
			["SpartanUI - Classic"] = {
				["Style"] = "Classic",
			},
		},
	},
	["profileKeys"] = {
		["Fermion - Nethergarde Keep"] = "Fermion - Nethergarde Keep",
	},
	["profiles"] = {
		["Fermion - Nethergarde Keep"] = {
			["Modules"] = {
				["StatusBars"] = {
					nil, -- [1]
					{
						["display"] = "rep",
					}, -- [2]
				},
				["PlayerFrames"] = {
					["Castbar"] = {
						["player"] = 0,
						["focus"] = 0,
						["target"] = 0,
						["targettarget"] = 0,
						["pet"] = 0,
					},
					["player"] = {
						["Anchors"] = {
							["relativeTo"] = "UIParent",
							["point"] = "BOTTOMRIGHT",
							["relativePoint"] = "TOP",
							["yOfs"] = -3,
							["xOfs"] = -72,
						},
					},
				},
				["NamePlates"] = {
					["elements"] = {
						["Power"] = {
						},
						["SUI_ClassIcon"] = {
						},
						["XPBar"] = {
						},
						["Health"] = {
						},
						["Castbar"] = {
						},
						["Name"] = {
						},
					},
					["Scale"] = 1.44,
				},
				["PartyFrames"] = {
					["castbartext"] = 1,
					["castbar"] = 0,
				},
				["Artwork"] = {
					["FirstLoad"] = false,
					["SetupDone"] = true,
					["SlidingTrays"] = {
						["left"] = {
							["collapsed"] = true,
						},
						["right"] = {
							["collapsed"] = true,
						},
					},
					["Style"] = "Classic",
					["Viewport"] = {
						["offset"] = {
							["bottom"] = 2.8,
						},
					},
				},
				["Objectives"] = {
					["AlwaysShowScenario"] = true,
					["SetupDone"] = true,
					["Rule2"] = {
						["Status"] = "Disabled",
						["Combat"] = false,
					},
					["Rule3"] = {
						["Status"] = "Disabled",
						["Combat"] = false,
					},
					["Rule1"] = {
						["Status"] = "Raid",
						["Combat"] = false,
					},
				},
				["TauntWatcher"] = {
					["inArena"] = true,
					["inRaid"] = true,
					["inParty"] = true,
					["FirstLaunch"] = false,
					["outdoors"] = false,
					["inBG"] = false,
				},
			},
			["SUIProper"] = {
				["Styles"] = {
					["Transparent"] = {
					},
					["Classic"] = {
						["Color"] = {
							["PlayerFrames"] = false,
							["Art"] = false,
							["PartyFrames"] = false,
							["RaidFrames"] = false,
						},
						["TalkingHeadUI"] = {
							["y"] = -30,
							["relPoint"] = "TOP",
							["point"] = "BOTTOM",
							["scale"] = 0.8,
							["x"] = 0,
						},
						["BT4Profile"] = "Default",
					},
					["War"] = {
					},
				},
				["EnabledComponents"] = {
					["MailOpenAll"] = true,
					["AutoSell"] = true,
					["Tooltips"] = true,
					["Minimap"] = true,
					["CombatLog"] = true,
					["TauntWatcher"] = true,
					["Buffs"] = true,
					["Nameplates"] = true,
					["AutoTurnIn"] = true,
					["InterruptAnnouncer"] = true,
					["Objectives"] = true,
				},
				["xOffset"] = -33.1249999999999,
				["Tooltips"] = {
					["Override"] = {
					},
					["Color"] = {
						0, -- [1]
						0, -- [2]
						0, -- [3]
						0.4, -- [4]
					},
					["Rule1"] = {
						["Status"] = "All",
						["Anchor"] = {
							["AnchorPos"] = {
							},
							["onMouse"] = false,
							["Moved"] = false,
						},
						["Combat"] = false,
						["OverrideLoc"] = false,
					},
					["Rule3"] = {
						["Status"] = "Disabled",
						["Anchor"] = {
							["AnchorPos"] = {
							},
							["onMouse"] = false,
							["Moved"] = false,
						},
						["Combat"] = false,
						["OverrideLoc"] = false,
					},
					["SuppressNoMatch"] = true,
					["ColorOverlay"] = true,
					["VendorPrices"] = true,
					["Rule2"] = {
						["Status"] = "Disabled",
						["Anchor"] = {
							["AnchorPos"] = {
							},
							["onMouse"] = false,
							["Moved"] = false,
						},
						["Combat"] = false,
						["OverrideLoc"] = false,
					},
					["Styles"] = {
						["none"] = {
							["tile"] = false,
							["bgFile"] = "Interface\\AddOns\\SpartanUI\\media\\blank.tga",
						},
						["smoke"] = {
							["tile"] = false,
							["bgFile"] = "Interface\\AddOns\\SpartanUI\\media\\smoke.tga",
						},
						["smooth"] = {
							["tile"] = false,
							["bgFile"] = "Interface\\AddOns\\SpartanUI\\media\\Smoothv2.tga",
						},
						["metal"] = {
							["tile"] = false,
							["bgFile"] = "Interface\\AddOns\\SpartanUI\\media\\metal.tga",
						},
					},
					["ActiveStyle"] = "smoke",
				},
				["AutoSell"] = {
					["AutoRepair"] = true,
					["FirstLaunch"] = false,
					["MaxILVL"] = 40,
				},
				["MiniMap"] = {
					["DisplayMapCords"] = false,
					["ManualAllowPrompt"] = "5.3.2",
					["ManualAllowUse"] = true,
					["DisplayZoneName"] = false,
					["AutoDetectAllowUse"] = false,
				},
				["Bartender4Version"] = "4.9.0",
				["SetupWizard"] = {
					["FirstLaunch"] = false,
				},
				["MailOpenAll"] = {
					["Silent"] = false,
					["FreeSpace"] = 0,
					["FirstLaunch"] = true,
				},
				["ActionBars"] = {
					["popup1"] = {
						["enable"] = false,
						["anim"] = false,
					},
					["popup2"] = {
						["enable"] = false,
						["anim"] = false,
					},
				},
				["BT4Profile"] = "Default",
				["yoffset"] = 1,
				["SetupDone"] = true,
				["Buffs"] = {
					["Rule3"] = {
						["offset"] = 0,
						["Combat"] = false,
						["Status"] = "Disabled",
						["OverrideLoc"] = false,
						["Anchor"] = {
							["AnchorPos"] = {
							},
							["Moved"] = false,
						},
					},
					["Override"] = {
					},
					["Rule2"] = {
						["offset"] = 0,
						["Combat"] = false,
						["Status"] = "Disabled",
						["OverrideLoc"] = false,
						["Anchor"] = {
							["AnchorPos"] = {
							},
							["Moved"] = false,
						},
					},
					["Rule1"] = {
						["offset"] = 0,
						["Combat"] = false,
						["Status"] = "Disabled",
						["OverrideLoc"] = false,
						["Anchor"] = {
							["AnchorPos"] = {
							},
							["Moved"] = false,
						},
					},
				},
				["CombatLog"] = {
					["heroicdungeon"] = false,
					["loggingActive"] = false,
					["debug"] = false,
					["raidheroic"] = true,
					["raidlfr"] = false,
					["raidmythic"] = true,
					["raidlegacy"] = false,
					["raidnormal"] = true,
					["FirstLaunch"] = false,
					["mythicplus"] = true,
					["normaldungeon"] = false,
					["logging"] = false,
					["mythicdungeon"] = false,
					["announce"] = true,
					["alwayson"] = false,
				},
				["font"] = {
					["SetupDone"] = true,
				},
				["Version"] = "5.3.2",
				["scale"] = 0.8,
				["AutoTurnIn"] = {
					["TurnInEnabled"] = false,
					["AcceptGeneralQuests"] = false,
					["FirstLaunch"] = false,
					["AutoGossipSafeMode"] = false,
					["AutoGossip"] = false,
				},
				["InterruptAnnouncer"] = {
					["inArena"] = true,
					["inRaid"] = true,
					["always"] = false,
					["inParty"] = true,
					["inBG"] = false,
					["outdoors"] = false,
					["announceLocation"] = "SMART",
					["FirstLaunch"] = false,
					["includePets"] = true,
					["text"] = "Interrupted %t %spell",
				},
			},
		},
	},
}
