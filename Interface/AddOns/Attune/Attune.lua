-------------------------------------------------------------------------
--
--	Copyright (c) 2019-2021 by Antoine Desmarets.
--	Cixi/Gaya of Remulos Oceanic / WoW Classic Horde
--
--	Attune is distributed in the hope that it will be useful/entertaining
--	but WITHOUT ANY WARRANTY
--
-------------------------------------------------------------------------

-- Done in 219
-- - completed the russian locale
-- - fixed an issue where having the EXACT reputation was not marking step as complete
-- - added the compatibility for TBC (Beta)


-------------------------------------------------------------------------
-- ADDON VARIABLES
-------------------------------------------------------------------------

Attune = LibStub("AceAddon-3.0"):NewAddon("Attune", "AceConsole-3.0", "AceEvent-3.0")
Attune_Data = {};							-- Attunements / steps / tooltips

Lang = LibStub("AceLocale-3.0"):GetLocale("Attune")


local AceGUI = LibStub("AceGUI-3.0")
local _G = getfenv(0)

local attunelocal_ldb = LibStub("LibDataBroker-1.1")
local Attune_Broker = nil
local attunelocal_minimapicon = LibStub("LibDBIcon-1.0")
local attunelocal_brokervalue = nil
local attunelocal_brokerlabel = nil

local attunelocal_version = "1.13.6.219"  			-- change here, and in TOC
local attunelocal_prefix = "Attune_Channel"			-- used for addon chat communications
local attunelocal_versionprefix = "Attune_Version"	-- used for addon version check
local attunelocal_detectedNewer = false;			-- flag to only warn about new version once per session

-- Defaults for Node size
local attunelocal_Node_Width = 170
local attunelocal_Node_Height = 48
local attunelocal_Node_HGap = 10
local attunelocal_Node_VGap = 30
local attunelocal_Icon_Size = 32
local attunelocal_Line_Thickness = 6

local attunelocal_MiniNode_Width = 32
local attunelocal_MiniNode_Height = 32
local attunelocal_MiniNode_HGap = 10
local attunelocal_MiniNode_VGap = 6
local attunelocal_MiniIcon_Size = 20
local attunelocal_MiniLine_Thickness = 2

-- Frame variables
local attunelocal_frame						-- main frame
local attunelocal_tree = {}					-- tree data (nodes and leaves)
local attunelocal_treeframe					-- Ace TreeGroup object for attune tab
local attunelocal_guildframe				-- Ace SimpleGroup object for result tab
local attunelocal_treeIsShown = false		-- indicates whether we're on the tree view or result view
local attunelocal_right						-- right panel of the TreeGroup object
local attunelocal_scroll					-- scroller inside of the TreeGroup right panel
local attunelocal_gscroll					-- scroller inside the SimpleGroup of the result tab
local attunelocal_glist						-- individual rows of data inside the result tab
local attunelocal_export_frame				-- export submenu frame
local attunelocal_survey_frame				-- survey submenu frame
local attunelocal_resultselection = 1 		-- indicates whether to show last survey results(0) or guild results(1) or all(2)
local attunelocal_exportselection = 0 		-- indicates what dataset to export 0:me, 1:last survey, 2:guild, 3:all
local attunelocal_gflabel					-- table header (used to update the number of characters in list)

local attunelocal_repWidget					-- Reputation Widget frame
local attunelocal_repWidget_frames = {} 	-- list of non-Ace frames for the rep widget (to reuse them later)

local attunelocal_frames = {} 				-- list of non-Ace frames (to reuse them later)
local attunelocal_initial = true			-- first run

local attunelocal_myguild = ""				-- Guild of the current character
local attunelocal_realm = GetRealmName()	-- Realm of the current character

local guildToonMap = {}						-- matching guild to toon

local attunelocal_data = {}					-- data being exported to website
local attunelocal_count = 0					-- count of toons being exported

local attunelocal_charKey = UnitName("player") .. "-" .. attunelocal_realm			-- Character unique name
local attunelocal_statusText = Lang["Version"]:gsub("##VERSION##", attunelocal_version)		-- Default status text

local attune_options = {
    name = "Attune",
    handler = Attune,
    type = "group",
	childGroups = "tab",
    args = {
        tab1 = {
            type = "group",
            name = Lang["Settings"],
			width = "full",
			order = 1,
			args = {

				spacer1 = {
					type = "description",
					name = " ",
					width = "full",
					order = 2,
				},
				showMinimapButton = {
					type = "toggle",
					name = Lang["MinimapButton_TEXT"],
					desc = Lang["MinimapButton_DESC"],
					get = function(info) return not Attune_DB.minimapbuttonpos.hide end,
					set = function(info, val)
							if val then attunelocal_minimapicon:Show("Attune_Broker") else attunelocal_minimapicon:Hide("Attune_Broker") end
							Attune_DB.minimapbuttonpos.hide = not val
						end,
					width = 2.5,
					order = 5,
				},
				autosurvey = {
					type = "toggle",
					name = Lang["AutoSurvey_TEXT"],
					desc = Lang["AutoSurvey_DESC"],
					get = function(info) return Attune_DB.autosurvey end,
					set = function(info, val) Attune_DB.autosurvey = val end,
					width = 2.5,
					order = 6,
				},
				showSurveyed = {
					type = "toggle",
					name = Lang["ShowSurveyed_TEXT"],
					desc = Lang["ShowSurveyed_DESC"],
					get = function(info) return Attune_DB.showSurveyed end,
					set = function(info, val) Attune_DB.showSurveyed = val end,
					width = 1.7,
					order = 15,
				},
				showResponses = {
					type = "toggle",
					name = Lang["ShowResponses_TEXT"],
					desc = Lang["ShowResponses_DESC"],
					get = function(info) return Attune_DB.showResponses end,
					set = function(info, val) Attune_DB.showResponses = val end,
					width = 1.7,
					order = 16,
				},
				showStepReached = {
					type = "toggle",
					name = Lang["ShowSetMessages_TEXT"],
					desc = Lang["ShowSetMessages_DESC"],
					get = function(info) return Attune_DB.showStepReached end,
					set = function(info, val) Attune_DB.showStepReached = val end,
					width = 1.7,
					order = 17,
				},
				announceAttuneCompleted = {
					type = "toggle",
					name = Lang["AnnounceToGuild_TEXT"],
					desc = Lang["AnnounceToGuild_DESC"],
					get = function(info) return Attune_DB.announceAttuneCompleted end,
					set = function(info, val) Attune_DB.announceAttuneCompleted = val end,
					width = 1.7,
					order = 18,
				},
				showOtherChat = {
					type = "toggle",
					name = Lang["ShowOther_TEXT"],
					desc = Lang["ShowOther_DESC"],
					get = function(info) return Attune_DB.showOtherChat end,
					set = function(info, val) Attune_DB.showOtherChat = val end,
					width = "full",
					order = 20,
				},
				spacer2 = {
					type = "description",
					name = " ",
					width = "full",
					order = 21,
				},
				showList = {
					type = "toggle",
					name = Lang["ShowGuildies_TEXT"],
					desc = Lang["ShowGuildies_DESC"],
					get = function(info) return Attune_DB.showList end,
					set = function(info, val) Attune_DB.showList = val end,
					width = 2.8,
					order = 22,
				},
				maxListSize = {
					type = "input",
					name = "",
					desc = "",
					get = function(info) return Attune_DB.maxListSize end,
					set = function(info, val) Attune_DB.maxListSize = val end,
					width = 0.5,
					order = 24,
				},
				showListAlt = {
					type = "toggle",
					name = Lang["ShowAltsInstead_TEXT"],
					desc = Lang["ShowAltsInstead_DESC"],
					get = function(info) return Attune_DB.showListAlt end,
					set = function(info, val) Attune_DB.showListAlt = val end,
					width = 2.5,
					order = 26,
				},
				spacer3 = {
					type = "description",
					name = " ",
					width = "full",
					order = 30,
				},
--[[
				preferredLocale = {
					type = "select",
					values = { enUS = "English", frFR = "Français", deDE = "Deutsch", ruRU = "Pусский"},
					name = Lang["PreferredLocale_TEXT"],
					desc = Lang["PreferredLocale_DESC"],
					get = function(info) return Attune_DB.preferredLocale end,
					set = function(info, val) Attune_DB.preferredLocale = val end,
					width = 1,
					order = 35,
				},
]]
				spacer4 = {
					type = "description",
					name = " ",
					width = "full",
					order = 40,
				},
				deleteAll = {
					type = "execute",
					name = Lang["ClearAll_TEXT"],
					desc = Lang["ClearAll_DESC"],
					confirm = true,
					confirmText = Lang["ClearAll_CONF"],
					func = function(info, val)
						for kt, t in pairs(Attune_DB.toons) do
							if kt ~= attunelocal_charKey then
								Attune_DB.toons[kt] = nil
							end
						end
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["ClearAll_TEXT"]) end
					end,
					width = 1.6,
					order = 32,
				},
				deleteGuild = {
					type = "execute",
					name = Lang["DelNonGuildies_TEXT"],
					desc = Lang["DelNonGuildies_DESC"],
					confirm = true,
					confirmText = Lang["DelNonGuildies_CONF"],
					func = function(info, val)
						for kt, t in pairs(Attune_DB.toons) do
							if kt ~= attunelocal_charKey then
								if t.guild ~= nil then
									if t.guild ~= attunelocal_myguild then
										Attune_DB.toons[kt] = nil
									end
								end
							end
						end
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["DelNonGuildies_DONE"]) end
					end,
					width = 1.6,
					order = 33,
				},
				delete60 = {
					type = "execute",
					name = Lang["DelUnder60_TEXT"],
					desc = Lang["DelUnder60_DESC"],
					confirm = true,
					confirmText = Lang["DelUnder60_CONF"],
					func = function(info, val)
						for kt, t in pairs(Attune_DB.toons) do
							if kt ~= attunelocal_charKey then
								if t.level ~= nil then
									if tonumber(t.level) < 60 then
										Attune_DB.toons[kt] = nil
									end
								end
							end
						end
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["DelUnder60_DONE"]) end
					end,
					width = 1.6,
					order = 34,
				},
				delete70 = {
					type = "execute",
					name = Lang["DelUnder70_TEXT"],
					desc = Lang["DelUnder70_DESC"],
					confirm = true,
					confirmText = Lang["DelUnder70_CONF"],
					func = function(info, val)
						for kt, t in pairs(Attune_DB.toons) do
							if kt ~= attunelocal_charKey then
								if t.level ~= nil then
									if tonumber(t.level) < 70 then
										Attune_DB.toons[kt] = nil
									end
								end
							end
						end
						if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["DelUnder70_DONE"]) end
					end,
					width = 1.6,
					order = 35,
				},


				spacer5 = {
					type = "description",
					name = " ",
					width = "full",
					order = 40,
				},


				credits = {
					type = "description",
					name = Lang["Credits"],
					width = "full",
					fontSize = "medium",
					order = 45,
				},
--[[				showWidget = {
					type = "toggle",
					name = "Show Reputation Widget",
					desc = "Displays a reputation tracking window, allowing you to check your attunement reputation gains and progress.",
					get = function(info) return Attune_DB.repWidget.showWidget end,
					set = function(info, val) Attune_DB.repWidget.showWidget = val;
						if attunelocal_repWidget ~= nil then
							if val then attunelocal_repWidget:Show()
							else attunelocal_repWidget:Hide()
							end
						end
					end,
					width = 1.7,
					order = 41,
				},
				lockWidget = {
					type = "toggle",
					name = "Lock Reputation Widget",
					desc = "Lock the reputation widget in place, preventing its movement and hiding usage information.",
					get = function(info) return Attune_DB.repWidget.lockWidget end,
					set = function(info, val) Attune_DB.repWidget.lockWidget = val
						if attunelocal_repWidget ~= nil then
							print("in")
							if val then
								attunelocal_repWidget:SetMovable(false)
								print("NOT movable")
							else
								attunelocal_repWidget:SetMovable(true)
								print("movable")
							end
						end
					end,
					width = 1.7,
					order = 42,
				},
]]
			},
		},

        tab2 = {
            type = "group",
            name = Lang["Survey Log"],
			width = "full",
			order = 100,
			args = {
				logs = {
					type = "description",
					name = "",
					width = "full",
					order = 110,
				},
			},
		},
	},
}

-------------------------------------------------------------------------
-- EVENT: Addon is Initialized
-------------------------------------------------------------------------

function Attune:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Attune", attune_options, nil)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Attune"):SetParent(InterfaceOptionsFramePanelContainer)

end

-------------------------------------------------------------------------
-- EVENT: Addon is enabled
-------------------------------------------------------------------------

function Attune:OnEnable()
	-- Called when the addon is enabled
	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_prefix)
	C_ChatInfo.RegisterAddonMessagePrefix(attunelocal_versionprefix)
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_TURNED_IN")
	self:RegisterEvent("UPDATE_FACTION")
	self:RegisterEvent("BAG_UPDATE")

	if Attune_DB == nil then Attune_DB = {} end
	if Attune_DB.width == nil then Attune_DB.width = 950 end
	if Attune_DB.height == nil then Attune_DB.height = 550 end
	if Attune_DB.mini == nil then Attune_DB.mini = false end	-- allows to show tiny icons instead of the normal steps, and therefore see more of the attune
	if Attune_DB.toons == nil then Attune_DB.toons = {} end
	if Attune_DB.toons[attunelocal_charKey] == nil then Attune_DB.toons[attunelocal_charKey] = {} end
	if Attune_DB.survey == nil then Attune_DB.survey = {} end
	if Attune_DB.sortresult == nil then Attune_DB.sortresult = { 0, true } end -- sort order for the result tab (attune, asc/desc)  (0 for name)
	if Attune_DB.showList == nil then Attune_DB.showList = true end
	if Attune_DB.showListAlt == nil then Attune_DB.showListAlt = false end
	if Attune_DB.showSurveyed == nil then Attune_DB.showSurveyed = true end
	if Attune_DB.showResponses == nil then Attune_DB.showResponses = true end
	if Attune_DB.showStepReached == nil then Attune_DB.showStepReached = true end
	if Attune_DB.announceAttuneCompleted == nil then Attune_DB.announceAttuneCompleted = true end
	if Attune_DB.showOtherChat == nil then Attune_DB.showOtherChat = true end
	if Attune_DB.maxListSize == nil then Attune_DB.maxListSize = "20" end
	if Attune_DB.logs == nil then Attune_DB.logs = {} end
	if Attune_DB.minimapbuttonpos == nil then Attune_DB.minimapbuttonpos = {} end
	if Attune_DB.minimapbuttonpos.hide == nil then Attune_DB.minimapbuttonpos.hide = false end
	if Attune_DB.autosurvey == nil then Attune_DB.autosurvey = false end

--[[	local gameLocale = GetLocale()
	if gameLocale == "enGB" then
		gameLocale = "enUS"
	end
	if Attune_DB.preferredLocale == nil then Attune_DB.preferredLocale = gameLocale end
]]
	if (Attune_DB.repWidget == nil) then Attune_DB.repWidget = {}; end
	if (Attune_DB.repWidget.showWidget == nil) then Attune_DB.repWidget.showWidget = false; end
	if (Attune_DB.repWidget.lockWidget == nil) then Attune_DB.repWidget.lockWidget = false; end
	if (Attune_DB.repWidget.showInRaid == nil) then Attune_DB.repWidget.showInRaid = true; end
	if (Attune_DB.repWidget.showInDungeon == nil) then Attune_DB.repWidget.showInDungeon = true; end
	if (Attune_DB.repWidget.showInWorld == nil) then Attune_DB.repWidget.showInWorld = true; end
	if (Attune_DB.repWidget.showInBg == nil) then Attune_DB.repWidget.showInBg = true; end
	if (Attune_DB.repWidget.point == nil) then Attune_DB.repWidget.point = nil; end


	if Attune_DB.showOtherChat then DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[Attune]|r "..Lang["Splash"]:gsub("##VERSION##", attunelocal_version)) end


	Attune_UpdateLogs()

	--this is per character as it could cause problems with alliance vs horde last viewed (ex if last viewed is Honor Hold)
	if AttuneLastViewed == nil then AttuneLastViewed = Attune_Data.attunes[1].EXPAC.."\001"..Attune_Data.attunes[1].ID end --select first in the list by default (should be MC, same alliance/horde)

	Attune_CheckProgress() -- get your own standing
	Attune:BAG_UPDATE(nil)


	-- calculate how many steps this toon has done on the attune
	local attuneDone = {}
	local t = Attune_DB.toons[attunelocal_charKey]
	local attuneSteps = {}
	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE ~= "Spacer" then
			if attuneSteps[s.ID_ATTUNE] == nil then attuneSteps[s.ID_ATTUNE] = 0 end
			attuneSteps[s.ID_ATTUNE] = attuneSteps[s.ID_ATTUNE] +1
		end
	end
	for i, d in pairs(t.done) do
		local Ids = Attune_split(i, "-")
		if attuneDone[Ids[1]] == nil then attuneDone[Ids[1]] = 0 end
		attuneDone[Ids[1]] = attuneDone[Ids[1]] +1
	end
		if t.attuned == nil then t.attuned = {} end
	for i, a in pairs(Attune_Data.attunes) do
		if attuneDone[a.ID] == nil then attuneDone[a.ID] = 0 end
		t.attuned[a.ID] = math.floor(100*(attuneDone[a.ID]/attuneSteps[a.ID]))

	end



	-- sending a couple version checks to make sure people update to the latest version
	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then
		C_Timer.After(11, function()
			C_ChatInfo.SendAddonMessage(attunelocal_versionprefix, attunelocal_version, "GUILD", "");
		end)
	end

	C_Timer.After(11, function()
		C_ChatInfo.SendAddonMessage(attunelocal_versionprefix, attunelocal_version, "YELL", "");
	end)


	-- sending a couple version checks to make sure people update to the latest version

	if Attune_DB.autosurvey then
		C_Timer.After(13, function()
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["StartAutoGuildSurvey"]) end
			C_ChatInfo.SendAddonMessage(attunelocal_prefix, "SILENTSURVEY", "GUILD", "");
		end)
	end



	Attune_Broker = attunelocal_ldb:NewDataObject("Attune_Broker", {
		type = "data source",
		label = "Attune",
		text = "Click me!",
		icon = "Interface\\Icons\\inv_scroll_03",
		OnClick = function(self, button)
			if button=="LeftButton" then
				Attune_SlashCommandHandler("")
			elseif button=="RightButton" then
				InterfaceOptionsFrame_Show()
				InterfaceOptionsFrame_OpenToCategory("Attune")
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("|cFFffffffAttune v"..attunelocal_version.."|r")

			if 	attunelocal_brokerlabel ~= nil then
				tooltip:AddLine(" ")
				tooltip:AddLine("|cffffd100"..attunelocal_brokerlabel..":|r |cFFffffff"..attunelocal_brokervalue.."|r")
			end

			tooltip:AddLine(" ")
			tooltip:AddLine("|cffffd100"..Lang["LeftClick"].."|r"..Lang["OpenAttune"].."\n|cffffd100"..Lang["RightClick"].."|r"..Lang["OpenSettings"], 0.2, 1, 0.2)
		end,
	})





	local aid = nil
	local st, le = string.find(AttuneLastViewed, "\001")
	if st ~= nil then -- not a group
		local g = string.sub(AttuneLastViewed, st+1)
		if g ~= "" then
			aid = g
		end
	end
	if aid ~= nil then
		for k, a in pairs(Attune_Data.attunes) do
			if a.ID == aid then
				attunelocal_brokerlabel = a.NAME
			end
		end
		if Attune_DB.toons[attunelocal_charKey].attuned[aid] ~= nil then
			attunelocal_brokervalue = Attune_DB.toons[attunelocal_charKey].attuned[aid].."%"
		else
			attunelocal_brokervalue = "0%"
		end
		Attune_Broker.text = attunelocal_brokervalue
	end


	attunelocal_minimapicon:Register("Attune_Broker", Attune_Broker, Attune_DB.minimapbuttonpos)
	if Attune_DB.minimapbuttonpos.hide then attunelocal_minimapicon:Hide("Attune_Broker"); attunelocal_minimapicon:Hide("Attune_Broker") else attunelocal_minimapicon:Show("Attune_Broker");attunelocal_minimapicon:Show("Attune_Broker") end


	--Attune_CreateRepWidget()

end

-------------------------------------------------------------------------
-- EVENT: Addon is disabled
-------------------------------------------------------------------------

function Attune:OnDisable()
	-- Called when the addon is disabled
	self:Print("|cffff00ff[Attune]|r "..Lang["Addon disabled"])
end

-------------------------------------------------------------------------
-- EVENT: Addon Chat message is received
-------------------------------------------------------------------------

function Attune:CHAT_MSG_ADDON(event, arg1, arg2, arg3, arg4)

	--attune data channel
	if arg1 == attunelocal_prefix then
		if arg2 == 'SURVEY' or arg2 == 'SILENTSURVEY' then
			attunelocal_count = 0
			attunelocal_data = {}
			attunelocal_data['_faction'] = ""
			attunelocal_data['_realm'] = ""
			attunelocal_data['_guild'] = ""

			if arg2 == 'SURVEY' and arg4 ~= UnitName("player").."-"..GetRealmName() then
				if Attune_DB.showSurveyed then print("|cffff00ff[Attune]|r "..Lang["SendingDataTo"]:gsub("##NAME##", Attune_split(arg4, "-")[1]))  end
			end

			-- log all surveys (silent or not) unless they were sent by us
			if arg4 ~= UnitName("player").."-"..GetRealmName() then
				Attune_DB.logs[time()] = Lang["ReceivedRequestFrom"]:gsub("##FROM##", arg4)
				Attune_UpdateLogs()
			end

			Attune_SendRequestResults(arg4)
		else
			Attune_HandleRequestResults(arg2)
		end
	end

	--version check channel
	if arg1 == attunelocal_versionprefix then
		if arg2 > attunelocal_version and not attunelocal_detectedNewer then
			attunelocal_detectedNewer = true
			if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["NewVersionAvailable"]) end -- 	ved check with a newer version, warn the user
		end
	end

end

-------------------------------------------------------------------------
-- EVENT: Detect a mob has been killed
-------------------------------------------------------------------------

function Attune:COMBAT_LOG_EVENT_UNFILTERED(event, arg1, arg2, arg3, arg4)
	local param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16 = CombatLogGetCurrentEventInfo()
	local refreshNeeded = false

	--party kill is the better option as it knows your group did the kill (your tag), but doesn't work in raid.
	--for raids, use UNIT_DIED, as since it's a raid mob your group obviously had the tag
	if (param2 == "PARTY_KILL" and not IsInRaid()) or (param2 == "UNIT_DIED" and IsInRaid()) then

		for i, s in pairs(Attune_Data.steps) do
			if s.TYPE == "Kill" then
				if s.STEP == param9 then

					-- checking that predecessors are done (meaning this step is ISNext)
					local isNext = true
					local followOR = false
					if s.FOLLOWS ~= "0" then
						local fIDs = Attune_split(s.FOLLOWS, "&")
						if string.find(s.FOLLOWS, "|") then fIDs = Attune_split(s.FOLLOWS, "|"); followOR = true end
						if followOR then
							isNext = false
							for fi, f in pairs(fIDs) do
								if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. f] then isNext = true end
							end
						else
							isNext = true
							for fi, f in pairs(fIDs) do
								if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. f] == nil then isNext = false end
							end
						end
					end

					if isNext then
						if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
							--mark step as done
							Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
							refreshNeeded = true
							PlaySound(1210) --putdownring
							-- need to refresh attune in window
							-- fetch attune name for chat message
							for k, a in pairs(Attune_Data.attunes) do
								if a.ID == s.ID_ATTUNE then
									if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
								end
							end

						end
					end
				end
			end
		end

		if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

	end
end

-------------------------------------------------------------------------
-- EVENT: Detect a level up
-------------------------------------------------------------------------

function Attune:PLAYER_LEVEL_UP(event, arg1)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Level" then
			if arg1 >= tonumber(s.ID_WOWHEAD) then

				if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
					--mark step as done
					Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
					refreshNeeded = true
					PlaySound(1210) --putdownring
					-- fetch attune name for chat message
					for k, a in pairs(Attune_Data.attunes) do
						if a.ID == s.ID_ATTUNE then
							if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end


-------------------------------------------------------------------------
-- EVENT: Quest accepted
-------------------------------------------------------------------------

function Attune:QUEST_ACCEPTED(event)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Pick Up" then

			if C_QuestLog.IsOnQuest(s.ID_WOWHEAD) then

				if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
					--mark step as done
					Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
					refreshNeeded = true
					PlaySound(1210) --putdownring
					-- fetch attune name for chat message
					for k, a in pairs(Attune_Data.attunes) do
						if a.ID == s.ID_ATTUNE then
							if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Quest turned in
-------------------------------------------------------------------------

function Attune:QUEST_TURNED_IN(event, arg1)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Quest" or s.TYPE == "Turn In" then

			if tonumber(s.ID_WOWHEAD) == arg1 then

				if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
					--mark step as done
					Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
					refreshNeeded = true
					PlaySound(1210) --putdownring
					-- fetch attune name for chat message
					for k, a in pairs(Attune_Data.attunes) do
						if a.ID == s.ID_ATTUNE then
							if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
							Attune_CheckComplete()
							if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] == 100 then
								PlaySound(5275) -- AuctionWindowClose
								if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
								if Attune_DB.announceAttuneCompleted then SendChatMessage("[Attune] "..Lang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
							end
						end
					end

				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Looted stuff
-------------------------------------------------------------------------

function Attune:BAG_UPDATE(event)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Item" then

			local countNeeded = 1
			if s.COUNT ~= nil then countNeeded = s.COUNT end

			Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] = GetItemCount(s.ID_WOWHEAD, 1)
				if Attune_DB.toons[attunelocal_charKey].items[s.ID_WOWHEAD] >= countNeeded then   --check bags and bank

				if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
					--mark step as done
					Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
					refreshNeeded = true
					PlaySound(1210) --putdownring
					-- fetch attune name for chat message
					for k, a in pairs(Attune_Data.attunes) do
						if a.ID == s.ID_ATTUNE then
							if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
							Attune_CheckComplete()
							if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] == 100 then
								PlaySound(5275) -- AuctionWindowClose
								if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
								if Attune_DB.announceAttuneCompleted then SendChatMessage("[Attune] "..Lang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end

-------------------------------------------------------------------------
-- EVENT: Rep changed
-------------------------------------------------------------------------

function Attune:UPDATE_FACTION(event)

	local refreshNeeded = false

	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Rep" then

			--loop on the all the character's factions
			local factionIndex = 1

			local name, _, _, _, _, earnedValue = GetFactionInfoByID(s.LOCATION)
			Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION] = {}
			Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION].earned = earnedValue
			Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION].name = name or Lang["Unknown Reputation"]
			--repeat
			--	local name, _, _, _, _, earnedValue = GetFactionInfo(factionIndex)
			--	if (name == s.LOCATION) then
			--		Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION] = earnedValue
			--		break
			--	end
			--	factionIndex = factionIndex + 1
			--until factionIndex > 200

			if Attune_DB.toons[attunelocal_charKey].reps[s.LOCATION].earned >= tonumber(s.ID_WOWHEAD) then

				if Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] == nil then
					--mark step as done
					Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
					refreshNeeded = true
					PlaySound(1210) --putdownring
					-- fetch attune name for chat message
					for k, a in pairs(Attune_Data.attunes) do
						if a.ID == s.ID_ATTUNE then
							if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["CompletedStep"]:gsub("##TYPE##", s.TYPE):gsub("##STEP##", s.STEP):gsub("##NAME##", a.NAME)) end
							Attune_CheckComplete()
							if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] == 100 then
								PlaySound(5275) -- AuctionWindowClose
								if Attune_DB.showStepReached then print("|cffff00ff[Attune]|r "..Lang["AttuneComplete"]:gsub("##NAME##", a.NAME)) end
								if Attune_DB.announceAttuneCompleted then SendChatMessage("[Attune] "..Lang["AttuneCompleteGuild"]:gsub("##NAME##", a.NAME), "GUILD") end
							end
						end
					end
				end
			end
		end
	end

	if refreshNeeded then Attune_ForceAttuneTabRefresh() end -- refresh view if needed

end



-------------------------------------------------------------------------
function Attune_UpdateLogs()

	local slogs = ""
	local cnt = 0
	for i, l in Attune_spairs(Attune_DB.logs, function(t,a,b) return b < a end) do
		if cnt < 40 then -- only about 40 lines fit in that area
			slogs = slogs .. date("%d %b %Y - %H:%M", i) .. " - " .. l .. "\n"
		else
			Attune_DB.logs[i] = nil
		end
		cnt = cnt + 1
	end

	if slogs == "" then
		attune_options.args.tab2.args.logs.name = "None yet..."
	else
		attune_options.args.tab2.args.logs.name = slogs
	end

end

-------------------------------------------------------------------------
-- Perform the attunement checks
-------------------------------------------------------------------------

function Attune_CheckProgress()

	local att = Attune_DB.toons[attunelocal_charKey]

	if att.reps == nil then att.reps = {} end
	--if att.quests == nil then att.quests = {} end
	if att.items == nil then att.items = {} end
	if att.done == nil then att.done = {} end
	if att.attuned == nil then att.attuned = {} end
	if att.next == nil then att.next = {} end

	local faction = UnitFactionGroup("player")
	-- looping through all applicable attunes
	for i, a in pairs(Attune_Data.attunes) do

		if a.FACTION == faction or a.FACTION == 'Both' then

			--looping through all steps
			for i, s in pairs(Attune_Data.steps) do

				if s.ID_ATTUNE == a.ID then

					--get REPUTATION progression
					if s.TYPE == "Rep" then

						--loop on the all the character's factions
						local factionIndex = 1
						local name, _, _, _, _, earnedValue = GetFactionInfoByID(s.LOCATION)
						att.reps[s.LOCATION] = {}
						att.reps[s.LOCATION].earned = earnedValue
						att.reps[s.LOCATION].name = name or Lang["Unknown Reputation"]
						--repeat
						--	local name, _, _, _, _, earnedValue = GetFactionInfo(factionIndex)
						--	if (name == s.LOCATION) then
						--		att.reps[s.LOCATION] = earnedValue
						--		break
						--	end
						--	factionIndex = factionIndex + 1
						--until factionIndex > 200

						if att.reps[s.LOCATION].earned >= tonumber(s.ID_WOWHEAD) then
							text = "|TInterface\\AddOns\\Attune\\Images\\success:16|t"
							att.done[a.ID .. "-" .. s.ID] = 1
						end
					end

					--get QUEST accepts
					if s.TYPE == "Pick Up" then
						if C_QuestLog.IsOnQuest(s.ID_WOWHEAD) then
							att.done[a.ID .. "-" .. s.ID] = 1
						end
					end

					--get QUEST completion
					if s.TYPE == "Quest" or s.TYPE == "Turn In" then
						if IsQuestFlaggedCompleted(s.ID_WOWHEAD) then
							att.done[a.ID .. "-" .. s.ID] = 1
						end
					end

					--get ITEM possession
					if s.TYPE == "Item" then
						local countNeeded = 1
						if s.COUNT ~= nil then countNeeded = s.COUNT end
						if GetItemCount(s.ID_WOWHEAD, 1) >= countNeeded then   --check bags and bank
							att.items[s.ID_WOWHEAD] = GetItemCount(s.ID_WOWHEAD, 1);
							att.done[a.ID .. "-" .. s.ID] = 1
						end
					end

					--get LEVEL progression
					if s.TYPE == "Level" then
						if UnitLevel('player') >= tonumber(s.ID_WOWHEAD) then
							att.done[a.ID .. "-" .. s.ID] = 1
						end
					end

				end
			end
		end
	end

	-- some specific steps mean the whole achievement is complete. Close off the whole tree if those are done
	-- including a second pass to mark as done all non-trackable steps (interact/kill/past items) that belong to earlier (completed) quests
	Attune_CheckComplete()

	-- a third pass to mark as done all attunements used in further attunements
	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == 'Attune' and att.attuned[s.ID_WOWHEAD] == 100 then
			att.done[s.ID_ATTUNE.."-"..s.ID] = 1
		end
	end

end

-------------------------------------------------------------------------
-- Check full Attune completion
-------------------------------------------------------------------------

function Attune_CheckComplete()
	local att = Attune_DB.toons[attunelocal_charKey]

	-- WoW
	if att.done["0-40"] 	then att.done["0-50"] = 1; 		att.attuned["0"] = 100; Attune_UpdateTreeGroup("0"); end	-- Debug
	if att.done["1-15"] 	then att.done["1-20"] = 1; 		att.attuned["1"] = 100; Attune_UpdateTreeGroup("1"); end	-- Debug multi
	if att.done["2-45"] 	then att.done["2-50"] = 1; 		att.attuned["2"] = 100; Attune_UpdateTreeGroup("2"); end	-- MC
	if att.done["3-268"]	then att.done["3-270"] = 1; 	att.attuned["3"] = 100; Attune_UpdateTreeGroup("3"); end	-- Ony Horde
	if att.done["4-265"]	then att.done["4-270"] = 1; 	att.attuned["4"] = 100; Attune_UpdateTreeGroup("4"); end	-- Ony Alliance
	if att.done["5-65"] 	then att.done["5-70"] = 1; 		att.attuned["5"] = 100; Attune_UpdateTreeGroup("5"); end	-- BWL
	if att.done["6-40"] 	then att.done["6-90"] = 1; 		att.attuned["6"] = 100; Attune_UpdateTreeGroup("6"); end	-- Naxx
	if att.done["6-50"] 	then att.done["6-90"] = 1; 		att.attuned["6"] = 100; Attune_UpdateTreeGroup("6"); end	-- Naxx
	if att.done["6-60"] 	then att.done["6-90"] = 1; 		att.attuned["6"] = 100; Attune_UpdateTreeGroup("6"); end	-- Naxx
	if att.done["10-960"] 	then att.done["10-970"] = 1; 	att.attuned["10"] = 100; Attune_UpdateTreeGroup("10"); end	-- scarab

	-- TBC
	if att.done["20-85"] 	then att.done["20-90"] = 1; 	att.attuned["20"] = 100 end		-- SH Horde
	if att.done["21-85"] 	then att.done["21-90"] = 1; 	att.attuned["21"] = 100 end		-- SH Alliance
	if att.done["30-20"] 	then att.done["30-30"] = 1; 	att.attuned["30"] = 100 end		-- Shadow Lab
	if att.done["40-90"] 	then att.done["40-100"] = 1; 	att.attuned["40"] = 100 end		-- Black Morass
	if att.done["80-160"] 	then att.done["80-180"] = 1; 	att.attuned["80"] = 100 end		-- Arcatraz

	if att.done["104-20"] 	then att.done["104-30"] = 1; 	att.attuned["104"] = 100 end	-- Thrallmar
	if att.done["105-20"] 	then att.done["105-30"] = 1; 	att.attuned["105"] = 100 end	-- HH
	if att.done["106-20"] 	then att.done["106-30"] = 1; 	att.attuned["106"] = 100 end	-- CE
	if att.done["107-20"] 	then att.done["107-30"] = 1; 	att.attuned["107"] = 100 end	-- Lower City
	if att.done["108-20"] 	then att.done["108-30"] = 1; 	att.attuned["108"] = 100 end	-- Shatar
	if att.done["109-20"] 	then att.done["109-30"] = 1; 	att.attuned["109"] = 100 end	-- CoT

	if att.done["115-170"] 	then att.done["115-190"] = 1; 	att.attuned["115"] = 100 end	-- Kara
	if att.done["120-100"] 	then att.done["120-110"] = 1; 	att.attuned["120"] = 100 end	-- SSC
	if att.done["140-460"] 	then att.done["140-480"] = 1; 	att.attuned["140"] = 100 end	-- The Eye Horde
	if att.done["160-460"] 	then att.done["160-480"] = 1; 	att.attuned["160"] = 100 end	-- The Eye Alliance
	if att.done["170-80"] 	then att.done["170-90"] = 1; 	att.attuned["170"] = 100 end	-- Hyjal Alliance
	if att.done["180-80"] 	then att.done["180-90"] = 1; 	att.attuned["180"] = 100 end	-- Hyjal Horde
	if att.done["190-260"] 	then att.done["190-280"] = 1; 	att.attuned["190"] = 100 end	-- BT Horde
	if att.done["200-260"] 	then att.done["200-280"] = 1; 	att.attuned["200"] = 100 end	-- BT Alliance

	for i, s in Attune_spairs(Attune_Data.steps, function(t,a,b) 	return tonumber(t[b].ID) > tonumber(t[a].ID) end) do
		if att.done[s.ID_ATTUNE .. "-" .. s.ID] then
			-- recurse into earlier steps to mark them as done too
			Attune_recursePreviousSteps(s.ID_ATTUNE, s.FOLLOWS)
		end
	end

	Attune_CheckIsNext(attunelocal_charKey)
end

-------------------------------------------------------------------------
-- Check which step is next
-------------------------------------------------------------------------

function Attune_CheckIsNext(who)
	local att = Attune_DB.toons[who]

	-- blank the array
	att.next = {}

	for i, step in pairs(Attune_Data.steps) do

		local next = false
		if  att.done[step.ID_ATTUNE .. "-" .. step.ID] ~= nil then
			-- if done, then not isnext
			next = false

		else
			local followOR = false
			local fIDs = Attune_split(step.FOLLOWS, "&")
			if string.find(step.FOLLOWS, "|") then fIDs = Attune_split(step.FOLLOWS, "|"); followOR = true end

			if followOR then
				next = false
				for fi, flw in pairs(fIDs) do
					if  att.done[step.ID_ATTUNE .. "-" .. flw] then next = true end
				end
			else
				next = true
				for fi, flw in pairs(fIDs) do
					if  att.done[step.ID_ATTUNE .. "-" .. flw] == nil or att.done[step.ID_ATTUNE .. "-" .. flw] == false then next = false end
				end
			end
			if step.FOLLOWS == "0" then next = true end
		end

		if next then
			att.next[step.ID_ATTUNE .. "-" .. step.ID] = 1
		else
			att.next[step.ID_ATTUNE .. "-" .. step.ID] = nil
		end
	end
end

-------------------------------------------------------------------------
-- Update the treeview to show completed attunes
-------------------------------------------------------------------------

function Attune_UpdateTreeGroup(aid)

	for i, a in pairs(Attune_Data.attunes) do
		if a.ID == aid then

			for i3, a3 in pairs(attunelocal_tree) do
				if a3.value == a.EXPAC then
					for i2, a2 in pairs(a3.children) do
						if a2.value == a.ID then
							a2.text = "|cff00ff00"..a2.text.."|r"
							a2.icon = "Interface\\AddOns\\Attune\\Images\\success"
						end
					end
				end
			end
		end
	end

end

-------------------------------------------------------------------------
-- Recurse through previous steps (following the FOLLOWS path)
-------------------------------------------------------------------------

function Attune_recursePreviousSteps(aID, follows)

	-- there can be multi-follows (for example FOLLOW=160|170)
	-- We need to recurse both paths
	local fIDs = Attune_split(follows, "&")
	if string.find(follows, "|") then fIDs = Attune_split(follows, "|") end

	for fi, f in pairs(fIDs) do
		for i, s in pairs(Attune_Data.steps) do
			if s.ID_ATTUNE == aID and s.ID == f then
				if string.find(follows, "|") == nil then -- don't recurse OR, as we don't know which parent was actually done
					Attune_DB.toons[attunelocal_charKey].done[s.ID_ATTUNE .. "-" .. s.ID] = 1
					if follows ~= 0 then -- no need to recurse first level
						Attune_recursePreviousSteps(s.ID_ATTUNE, s.FOLLOWS)
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------
-- Load the data into the TreeGroup object (nodes/leaves)
-------------------------------------------------------------------------

function Attune_LoadTree()
	attunelocal_tree = {}
	local expac = ""
	local expacId = 0
	local expacNode = {}
	for i, a in pairs(Attune_Data.attunes) do
		if expac ~= a.EXPAC then

			if expac ~= "" then
				table.insert(attunelocal_tree, expacNode)
			end

			expacId = expacId + 1
			expacNode = {
				value = a.EXPAC, --"EXPAC"..expacId,
				text =  a.EXPAC,
				children = {}
			  }
			expac = a.EXPAC
		end

		if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then

			local text = a.NAME
			local icon = a.ICON
			if Attune_DB.toons[attunelocal_charKey].attuned ~= nil then
				if Attune_DB.toons[attunelocal_charKey].attuned[a.ID] == 100 then
					text = "|cff00ff00"..text.."|r"
					icon = "Interface\\AddOns\\Attune\\Images\\success"
				end
			end


			local attuneNode = {
				value = a.ID,
				text = text,
				icon = icon

			  }
			  -- "Interface\\Icons\\" ..
			  --icon = "Interface\\AddOns\\Attune\\Images\\" .. a.ICON
			table.insert(expacNode.children, attuneNode)
		end

	end
	table.insert(attunelocal_tree, expacNode)


end


-------------------------------------------------------------------------
-- Create the Main UI Frame
-------------------------------------------------------------------------

function Attune_Frame()

	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName ~= nil then attunelocal_myguild = guildName end


	attunelocal_frame = AceGUI:Create("Frame")
	attunelocal_frame:SetTitle("  Attune")
	attunelocal_frame:SetStatusText(attunelocal_statusText)

	attunelocal_frame:SetStatusText(attunelocal_statusText)

	attunelocal_frame:SetHeight(Attune_DB.height)
	attunelocal_frame:SetWidth(Attune_DB.width)

	attunelocal_frame.frame:SetScript("OnSizeChanged", function(self)
		local hh = self:GetHeight()
		local ww = self:GetWidth()
		if hh > self:GetParent():GetHeight() - 50 	then hh = self:GetParent():GetHeight() - 50; self:SetHeight(hh) end
		if ww > self:GetParent():GetWidth() - 50 	then ww = self:GetParent():GetWidth() - 50; self:SetWidth(ww) end
		Attune_DB.height = hh
		Attune_DB.width = ww
	end)


	--attunelocal_frame.frame:SetHeight(Attune_DB.height)
	--attunelocal_frame.frame:SetWidth(Attune_DB.width)

	attunelocal_frame.frame:SetMinResize(970, 550)
	attunelocal_frame.frame:SetFrameStrata("HIGH")


	-- Hacking into the Ace3 frame to reduce the size of the statusbox, to allow us room for other buttons
	local closebutton, statusbg, _, _, _, _, _ = attunelocal_frame.content.obj.frame:GetChildren()
	statusbg:ClearAllPoints()
	statusbg:SetPoint("BOTTOMLEFT", 15, 15)     -- taken from AceGUIContainer-Frame.lua
	statusbg:SetPoint("BOTTOMRIGHT", -360, 15)  -- taken from AceGUIContainer-Frame.lua, modified from -132

	closebutton:SetWidth(80)
	closebutton:SetScript("OnClick", function()
		attunelocal_export_frame.frame:Hide() -- close other submenu
		attunelocal_survey_frame.frame:Hide() -- close other submenu
		attunelocal_frame:Hide()
	end)


	-- SURVEY BUTTON
	local surveybutton = CreateFrame("Button", nil, attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	surveybutton:SetPoint("BOTTOMRIGHT", -276, 17)
	surveybutton:SetFrameStrata("DIALOG")
	surveybutton:SetHeight(20)
	surveybutton:SetWidth(80)
	surveybutton:SetText(Lang["Survey"])
	--if attunelocal_myguild == "" then surveybutton:Disable() end
	surveybutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(Lang["Survey_DESC"]) end)
	surveybutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	surveybutton:SetScript("OnClick", function()
		if attunelocal_survey_frame.frame:IsShown() then
			attunelocal_survey_frame.frame:Hide()
		else
			attunelocal_export_frame.frame:Hide() -- close other submenu
			attunelocal_survey_frame.frame:Show()
		end
	end)

	-- SURVEY SUB MENU
		attunelocal_survey_frame = AceGUI:Create("InlineGroup")
		attunelocal_survey_frame:SetLayout("Flow")
		attunelocal_survey_frame:SetWidth(160)
		attunelocal_survey_frame:SetPoint("TOPLEFT", surveybutton,"BOTTOMLEFT", 0, 10)
		attunelocal_survey_frame.frame:Hide()

		local surveyGuild = AceGUI:Create("Button")
		surveyGuild:SetText(Lang["Guild"])
		surveyGuild:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			Attune_SendRequest("Guild")
		end)
		attunelocal_survey_frame:AddChild(surveyGuild)

		local surveyParty = AceGUI:Create("Button")
		surveyParty:SetText(Lang["Party"])
		surveyParty:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			Attune_SendRequest("Party")
		end)
		attunelocal_survey_frame:AddChild(surveyParty)

		local surveyRaid = AceGUI:Create("Button")
		surveyRaid:SetText(Lang["Raid"])
		surveyRaid:SetCallback("OnClick", function()
			attunelocal_survey_frame.frame:Hide()
			Attune_SendRequest("Raid")
		end)
		attunelocal_survey_frame:AddChild(surveyRaid)

		local surveyClose = AceGUI:Create("Button")
		surveyClose:SetText(Lang["Close"])
		surveyClose:SetCallback("OnClick", function(slid)	attunelocal_survey_frame.frame:Hide()	end)
		attunelocal_survey_frame:AddChild(surveyClose)

	-- EXPORT BUTTON
	local exportbutton = CreateFrame("Button", nil, attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	exportbutton:SetPoint("BOTTOMRIGHT", -193, 17)
	exportbutton:SetFrameStrata("DIALOG")
	exportbutton:SetHeight(20)
	exportbutton:SetWidth(80)
	exportbutton:SetText(Lang["Export"])
	exportbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(Lang["Export_DESC"]) end)
	exportbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	exportbutton:SetScript("OnClick", function()

		if attunelocal_export_frame.frame:IsShown() then
			attunelocal_export_frame.frame:Hide()
		else
			attunelocal_survey_frame.frame:Hide() -- close other submenu
			attunelocal_export_frame.frame:Show()
		end
	end)

	-- EXPORT SUB MENU
		attunelocal_export_frame = AceGUI:Create("InlineGroup")
		attunelocal_export_frame:SetLayout("Flow")
		attunelocal_export_frame:SetWidth(160)
		attunelocal_export_frame:SetPoint("TOPLEFT", exportbutton,"BOTTOMLEFT", 0, 10)
		attunelocal_export_frame.frame:Hide()

		local exportMyData = AceGUI:Create("Button")
		exportMyData:SetText(Lang["My Data"])
		exportMyData:SetCallback("OnClick", function()
			attunelocal_export_frame.frame:Hide()
			attunelocal_exportselection = 0
			Attune_ExportToWebsite()
		end)
		attunelocal_export_frame:AddChild(exportMyData)

		local exportLastSurvey = AceGUI:Create("Button")
		exportLastSurvey:SetText(Lang["Last Survey"])
		exportLastSurvey:SetCallback("OnClick", function()
			attunelocal_export_frame.frame:Hide()
			attunelocal_exportselection = 1
			Attune_ExportToWebsite()
		end)
		attunelocal_export_frame:AddChild(exportLastSurvey)

		local exportGuildData = AceGUI:Create("Button")
		exportGuildData:SetText(Lang["Guild Data"])
		exportGuildData:SetCallback("OnClick", function()
			attunelocal_export_frame.frame:Hide()
			attunelocal_exportselection = 2
			Attune_ExportToWebsite()
		end)
		attunelocal_export_frame:AddChild(exportGuildData)

		local exportAll = AceGUI:Create("Button")
		exportAll:SetText(Lang["All Data"])
		exportAll:SetCallback("OnClick", function()
			attunelocal_export_frame.frame:Hide()
			attunelocal_exportselection = 3
			Attune_ExportToWebsite()
		end)
		attunelocal_export_frame:AddChild(exportAll)

		local exportClose = AceGUI:Create("Button")
		exportClose:SetText(Lang["Close"])
		exportClose:SetCallback("OnClick", function()	attunelocal_export_frame.frame:Hide()	end)
		attunelocal_export_frame:AddChild(exportClose)

	-- GUILD BUTTON
	local guildbutton = CreateFrame("Button", "GuildButton", attunelocal_frame.content.obj.frame, "UIPanelButtonTemplate")
	guildbutton:SetPoint("BOTTOMRIGHT", -110, 17)
	guildbutton:SetFrameStrata("DIALOG")
	guildbutton:SetHeight(20)
	guildbutton:SetWidth(80)
	guildbutton:SetText(Lang["Results"])
	--if attunelocal_myguild == "" then guildbutton:Disable() end
	guildbutton:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(Lang["Toggle_DESC"]) end)
	guildbutton:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText) end)
	guildbutton:SetScript("OnClick", function()
		attunelocal_export_frame.frame:Hide() -- close other submenu
		attunelocal_survey_frame.frame:Hide() -- close other submenu
		Attune_ToggleView()

	end)

    -- Register the global variable `Attune_MainFrame` as a "special frame"
    -- so that it is closed when the escape key is pressed.
	_G["Attune_MainFrame"] = attunelocal_frame.frame
    tinsert(UISpecialFrames, "Attune_MainFrame")
	_G["Attune_ExportMenuFrame"] = attunelocal_export_frame.frame
    tinsert(UISpecialFrames, "Attune_ExportMenuFrame")
	_G["Attune_SurveyMenuFrame"] = attunelocal_survey_frame.frame
    tinsert(UISpecialFrames, "Attune_SurveyMenuFrame")

	Attune_ToggleView()

end

-------------------------------------------------------------------------
-- Display the attune after it being selected in tree
-------------------------------------------------------------------------

function Attune_Select(attuneId)
	PlaySound(856)  --igMainMenuOptionCheckBoxOn
	local scrollframe = attunelocal_scroll.content.obj.content

	attunelocal_scroll:ReleaseChildren()

	local att = Attune_DB.toons[attunelocal_charKey]

	-- Display Title
	for i, a in pairs(Attune_Data.attunes) do
		if (a.ID == attuneId) then

			attunelocal_brokerlabel = a.NAME
			if Attune_DB.toons[attunelocal_charKey].attuned[attuneId] ~= nil then
				attunelocal_brokervalue = Attune_DB.toons[attunelocal_charKey].attuned[attuneId].."%"
			else
				attunelocal_brokervalue = "0%"
			end
			Attune_Broker.text = attunelocal_brokervalue

			local titlebutton = AceGUI:Create("SimpleGroup")
			titlebutton:SetLayout("Flow")
			titlebutton:SetFullWidth(true)

				local label = AceGUI:Create("Label")
				label:SetText(a.NAME)
				label:SetImage(a.ICON)
				label:SetFont(GameFontHighlightSmall:GetFont(), 24)
				label:SetImageSize(32,32)
				label:SetRelativeWidth(0.9)
				titlebutton:AddChild(label)

				local mini = AceGUI:Create("Button")
				mini:SetText(Attune_DB.mini and Lang["Maxi"] or Lang["Mini"])
				mini:SetWidth(70)
				mini:SetCallback("OnClick", function()
					Attune_DB.mini = not Attune_DB.mini
					Attune_ForceAttuneTabRefresh()
				end)
				titlebutton:AddChild(mini)


			attunelocal_scroll:AddChild(titlebutton)

			-- spacer
			local label = AceGUI:Create("Label")
			label:SetText(" ")
			label:SetFullWidth(true)
			label:SetFont(GameFontHighlight:GetFont(), 20)
			attunelocal_scroll:AddChild(label)

			-- desc
			local label = AceGUI:Create("Label")
			label:SetText(a.DESC)
			label:SetFullWidth(true)
			label:SetFont(GameFontHighlightSmall:GetFont(), 12)
			attunelocal_scroll:AddChild(label)
		end
	end

	-- spacer
	local label = AceGUI:Create("Label")
	label:SetText(" ")
	label:SetFullWidth(true)
	label:SetFont(GameFontHighlight:GetFont(), 20)
	attunelocal_scroll:AddChild(label)

	-- Hiding all non-Ace frames (all attune steps basically)
	for i, f in pairs(attunelocal_frames) do	_G[f]:Hide()	end


	-- Count the number of steps at each stage, to know how to center the frames
	local stageSteps = {} -- steps per stage
	for i, s in pairs(Attune_Data.steps) do
		if s.ID_ATTUNE == attuneId then
			stageSteps[s.STAGE] = (stageSteps[s.STAGE] or 0) + 1
		end
	end



	-- Create/position each step frame
	local yy = (Attune_DB.mini and 40 or 0)  -- allow a top margin when in mini mode
	local curStage = 0
	local nbStep = 0
	for i, s in Attune_spairs(Attune_Data.steps, function(t,a,b) 	return tonumber(t[b].STAGE)*10000 + tonumber(t[b].ID) > tonumber(t[a].STAGE)*10000 + tonumber(t[a].ID) end) do
		if s.ID_ATTUNE == attuneId then
			if s.STAGE ~= curStage then
				nbStep = 1
				curStage = s.STAGE
				yy = yy + (Attune_DB.mini and (attunelocal_MiniNode_VGap + attunelocal_MiniNode_Height) or (attunelocal_Node_VGap + attunelocal_Node_Height))
			end
			local xx = (stageSteps[s.STAGE] * (Attune_DB.mini and (attunelocal_MiniNode_Width + attunelocal_MiniNode_HGap) or (attunelocal_Node_Width + attunelocal_Node_HGap))) - (nbStep * (Attune_DB.mini and (attunelocal_MiniNode_Width + attunelocal_MiniNode_HGap) or (attunelocal_Node_Width + attunelocal_Node_HGap))) - (stageSteps[s.STAGE]-1) * ((Attune_DB.mini and (attunelocal_MiniNode_Width + attunelocal_MiniNode_HGap) or (attunelocal_Node_Width + attunelocal_Node_HGap))/2)

			Attune_CreateNode(s, scrollframe, xx, yy)
			nbStep = nbStep + 1
		end
	end

	-- Ace 'mask' needed to trick the scroller into the right size, as it doesn't detect the custom frames.
	local mask = AceGUI:Create("SimpleGroup")
	mask:SetAutoAdjustHeight(false)
	mask:SetHeight(yy+50)
	mask:SetFullWidth(true)
	mask.frame:SetScript("OnEnter", function() end)
	mask.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)
	attunelocal_scroll:AddChild(mask)



	-- This script needed to allow the scrollframe resize whenever content changes or vertical size is moved
	attunelocal_scroll.frame:SetScript("OnUpdate", function()
		attunelocal_scroll:SetHeight(yy+50)
	end)



end

-------------------------------------------------------------------------
-- Create the frame for a single attune step (node)
-------------------------------------------------------------------------

function Attune_CreateNode(step, parent, posX, posY)
	-- Generic look and feel for the node
	local PaneBackdrop  = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}

	local countSameStep = 0
	local countCompleted = 0
	local listSameStep = ""
	local listCompleted = ""
	local dots1 = false
	local dots2 = false
	--calculate guildmembers on this stage
	for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b) return b > a end) do

		local filter = false

		if  Attune_DB.showListAlt then
			--show alts
			if t.owner == 1 then filter = true end
		else
			--show guildies
			if t.guild == attunelocal_myguild then filter = true end
		end

		if filter then
			-- calculate how many other toon has this step marked as IsNext
			if kt ~= attunelocal_charKey then
				if t.next ~= nil then
					if t.next[step.ID_ATTUNE .. "-" .. step.ID] ~= nil then
						countSameStep = countSameStep + 1
						if countSameStep <= tonumber(Attune_DB.maxListSize) then
							listSameStep = listSameStep .. "\n" .. Attune_split(kt, "-")[1]
						else
							if dots1 == false then
								listSameStep = listSameStep .. "\n..."
								dots1 = true
							end
						end

					end
				end
			end
			-- calculate how many toons have completed this attune
			if step.TYPE == "End" then
				if t.attuned ~= nil then
					if t.attuned[step.ID_ATTUNE] == 100 then
						countCompleted = countCompleted + 1
						if countCompleted <= tonumber(Attune_DB.maxListSize) then
							listCompleted = listCompleted .. "\n" .. Attune_split(kt, "-")[1]
						else
							if dots2 == false then
								listCompleted = listCompleted .. "\n..."
								dots2 = true
							end
						end
					end
				end
			end
		end
	end

	if  Attune_DB.showListAlt then
		if listSameStep ~= "" then
			listSameStep = "\n\n|cff00ff00"..Lang["Alts on this step"]..":|r" .. listSameStep
		end
		if listCompleted ~= "" then
			listCompleted = "\n\n|cff00ff00"..Lang["Attuned alts"]..":|r" .. listCompleted
		end
	else
		if listSameStep ~= "" then
			listSameStep = "\n\n|cff00ff00"..Lang["Guild members on this step"]..":|r" .. listSameStep
		end
		if listCompleted ~= "" then
			listCompleted = "\n\n|cff00ff00"..Lang["Attuned guild members"]..":|r" .. listCompleted
		end
	end



	-- check whether the step has been done
	if Attune_DB.toons[attunelocal_charKey].done == nil then Attune_DB.toons[attunelocal_charKey].done = {}  end
	local done = Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. step.ID]

	local countNeeded = 1
	if step.COUNT ~= nil then countNeeded = step.COUNT end

	-- main node frame, reuse if possible
	local fnode
	local exist = false
	for _, f in ipairs(attunelocal_frames) do if f == "Attune_Node_"..step.ID then exist = true end end
	if exist then 	fnode = _G["Attune_Node_"..step.ID] -- reusing
	else			fnode = CreateFrame("Button", "Attune_Node_"..step.ID, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
					table.insert(attunelocal_frames, "Attune_Node_"..step.ID) -- recording, to reuse
	end
	fnode:SetParent(parent)
	fnode:SetWidth(Attune_DB.mini and attunelocal_MiniNode_Width or attunelocal_Node_Width)
	fnode:SetHeight(Attune_DB.mini and attunelocal_MiniNode_Height or attunelocal_Node_Height)
	fnode:SetPoint("TOP", posX, -posY)
	fnode:SetScript("OnEnter", function()

		-- put full step info in status bar
		attunelocal_frame:SetStatusText(step.STEP)

		-- display Item link or quest tooltip on hover
		if step.TYPE == "Item" then
			if countNeeded == 1 then
				attunelocal_frame:SetStatusText(step.STEP)
			else
				attunelocal_frame:SetStatusText(step.STEP .. " (" .. Attune_DB.toons[attunelocal_charKey].items[step.ID_WOWHEAD] .. "/" .. countNeeded .. ")")
			end
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetHyperlink("item:"..step.ID_WOWHEAD)

		elseif step.TYPE == "End" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(Lang["AttuneColors"])
			if listCompleted ~= "" and Attune_DB.showList then GameTooltip:AddLine(listCompleted, 1, 1, 1, 1) end

		elseif step.TYPE == "Level" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(Lang["Minimum Level"])

		elseif step.TYPE == "Rep"then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local tempRep = Attune_DB.toons[attunelocal_charKey].reps[step.LOCATION].earned
			local tempGoal = step.ID_WOWHEAD
			if tonumber(tempRep) > tonumber(step.ID_WOWHEAD) then tempRep = step.ID_WOWHEAD end

			GameTooltip:SetText("" .. Attune_DB.toons[attunelocal_charKey].reps[step.LOCATION].name)
			GameTooltip:AddLine(Lang["Current progress"]..": ".. tempRep .. "/" ..step.ID_WOWHEAD, 0.5, 0.5, 0.5, 1)
			if step.OFFSET ~= nil then
				tempGoal = step.ID_WOWHEAD + step.OFFSET
				tempRep = tempRep + step.OFFSET
			end
			GameTooltip:AddLine(Lang["Completion"]..": " .. math.floor(100*tonumber(tempRep)/tonumber(tempGoal)).."%", 0.5, 0.5, 0.5, 1)

		elseif step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local quest = Attune_Data.quests[tonumber(step.ID_WOWHEAD)]
			if quest == nil then
				-- error message if quest is not in AttuneData.lua
				GameTooltip:SetText(Lang["Quest information not found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				GameTooltip:SetText(Lang["Q1_"..step.ID_WOWHEAD])
				GameTooltip:AddLine(Lang["Requires level"].." "..quest[1].."\n\n", 0.5, 0.5, 0.5, 1)
				if quest[2] == 1 then
					GameTooltip:AddLine(Lang["Solo quest"].."\n\n", 0.373, 0.729, 0.275, 1)
				elseif quest[2] <= 5 then
					GameTooltip:AddLine(Lang["Party quest"]:gsub("##NB##", quest[2]).."\n\n", 0.851, 0.608, 0.0, 1)
				else
					GameTooltip:AddLine(Lang["Raid quest"]:gsub("##NB##", quest[2]).."\n\n", 0.857, 0.055, 0.075, 1)
				end
				if Lang["Q2_"..step.ID_WOWHEAD] ~= nil then GameTooltip:AddLine(Lang["Q2_"..step.ID_WOWHEAD], 1, 1, 1, 1, true) end
			end

		elseif step.TYPE == "Kill" or step.TYPE == "Interact" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local npc = Attune_Data.npcs[tonumber(step.ID_WOWHEAD)]
			if npc == nil then
				-- error message if quest is not in AttuneData.lua
				GameTooltip:SetText(Lang["NPC Not Found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				GameTooltip:SetText(Lang["N1_"..step.ID_WOWHEAD])
				GameTooltip:AddLine(Lang["Level"].." "..npc[1].." "..npc[2].." "..npc[3].."\n", 0.851, 0.608, 0.0, 1)
				if Lang["N2_"..step.ID_WOWHEAD] ~= "" then
					GameTooltip:AddLine("\n"..Lang["N2_"..step.ID_WOWHEAD], 1, 1, 1, 1, true)
				end
			end

		elseif step.TYPE == "Click"then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			local other = Lang["O_"..step.ID_WOWHEAD]
			if other == nil then
				-- error message if quest is not in AttuneData.lua
				GameTooltip:SetText(Lang["Information not found"].." (ID "..step.ID_WOWHEAD..")", 1, 0.5, 0.5, 1)
			else
				-- build tooltip
				GameTooltip:SetText((Attune_DB.mini and step.STEP.."\n" or "") .. other)
			end



		-- change transparency if clickable sub-attune
		elseif step.TYPE == "Attune" then
			GameTooltip:SetOwner(fnode,"ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", fnode,"TOPRIGHT", 10, 0)
			GameTooltip:SetText(Lang["Click to navigate to that attunement"])

			if done then
				fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3 * 1.25)
			else
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7 * 1.25)
			end
		end

		if listSameStep ~= "" and Attune_DB.showList then GameTooltip:AddLine(listSameStep, 1, 1, 1, 1) end
		GameTooltip:Show()

	end)
	fnode:SetScript("OnLeave", function()
		-- restore status text to default
		attunelocal_frame:SetStatusText(attunelocal_statusText)
		GameTooltip:Hide()
		-- restore  transparency for clickable sub-attunes
		if step.TYPE == "Attune" then
			if done then
				fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3)
			else
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7)
			end
		end
	end)
	fnode:SetScript("OnClick", function()

		-- shif-clicking items in chat
		if step.TYPE == "Item" then
			local _, link = GetItemInfo(tonumber(step.ID_WOWHEAD));
			if link then
				HandleModifiedItemClick(link);
			end
		-- shift clicking quests not working in Classic. Keep for TBC maybe it will work there
	--		elseif step.TYPE == "Quest" then
	--			local quest = Attune_Data.quests[tonumber(step.ID_WOWHEAD)]
	--			if quest and IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() then
	--				ChatEdit_InsertLink(format("|cffffff00|Hquest:%d:%d|h[%s]|h|r", tonumber(step.ID_WOWHEAD), 60, quest[1]));
	--			end

		-- navigate to sub-attunement
		elseif step.TYPE == "Attune" then
			--call sub attune
			for i, a in pairs(Attune_Data.attunes) do
				if (a.ID == step.ID_ATTUNE) then
					attunelocal_treeframe:SelectByPath(a.EXPAC.."\001"..step.ID_WOWHEAD)
					break
				end
			end
		end

	end)


	local next = false
	if step.TYPE ~= "Spacer" then

		-- format node color
		fnode:SetBackdrop(PaneBackdrop)
		if done then
			if step.TYPE == "Attune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.055, 0.306, 0.576, 0.7) -- blue, attune
				fnode:SetBackdropBorderColor(1, 1, 1)

			else
				fnode:SetBackdropColor(0.373, 0.729, 0.275, 0.3) -- green, to match website colors
				fnode:SetBackdropBorderColor(0.373, 0.729, 0.275)
			end

		else
			-- check if all predecessor are done, and mark as Next if it is the case

			local followOR = false
			local fIDs = Attune_split(step.FOLLOWS, "&")
			if string.find(step.FOLLOWS, "|") then fIDs = Attune_split(step.FOLLOWS, "|"); followOR = true end

			if followOR then
				next = false
				for fi, flw in pairs(fIDs) do
					if  Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] then next = true end
				end
			else
				next = true
				for fi, flw in pairs(fIDs) do
					if  Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] == nil or Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw] == false then next = false end
				end
			end

			if step.FOLLOWS == "0" then next = true end

			if next then
				fnode:SetBackdropColor(0.851, 0.608, 0.0, 0.3) -- yellow
				fnode:SetBackdropBorderColor(0.851, 0.608, 0.0, 1)
			else
				fnode:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- gray
				fnode:SetBackdropBorderColor(0.4, 0.4, 0.4)
			end

			if step.TYPE == "Attune" or step.TYPE == "End" then
				fnode:SetBackdropColor(0.557, 0.055, 0.075, 0.7	) -- red, attune
				fnode:SetBackdropBorderColor(1, 1, 1)
			end
		end


		--icon, reuse object when possible
		local exist = false
		for _, f in ipairs(attunelocal_frames) do if f == "Attune_Icon_"..step.ID then exist = true end end
		local icon
		if exist then 	icon = _G["Attune_Icon_"..step.ID] -- reuse
		else			icon = CreateFrame("Button", "Attune_Icon_"..step.ID)
						table.insert(attunelocal_frames, "Attune_Icon_"..step.ID) -- recording, to reuse
		end
		icon:SetPoint("TOPLEFT", fnode, "TOPLEFT", Attune_DB.mini and 6 or 8, Attune_DB.mini and -6 or -8)
		icon:SetParent(fnode)
		icon:SetWidth(Attune_DB.mini and attunelocal_MiniIcon_Size or attunelocal_Icon_Size)
		icon:SetHeight(Attune_DB.mini and attunelocal_MiniIcon_Size or attunelocal_Icon_Size)
		icon:SetNormalTexture(step.ICON)
		icon:SetHighlightTexture(step.ICON)
		icon:SetToplevel(true)
		icon:EnableMouse(false)
		icon:Disable()
		icon:Show()


		if not Attune_DB.mini then
			-- step information, reuse when possible
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Title_"..step.ID then exist = true end end
			local ftitle
			if exist then 	ftitle = _G["Attune_Title_"..step.ID] -- reuse
			else			ftitle = fnode:CreateFontString("Attune_Title_"..step.ID)
							table.insert(attunelocal_frames, "Attune_Title_"..step.ID) -- recording, to reuse
			end
			ftitle:SetWidth(attunelocal_Node_Width - 50)
			ftitle:SetHeight(16)
			ftitle:SetJustifyH("LEFT")
			-- End node gets a bigger font
			if step.TYPE == 'End' then
				ftitle:SetPoint("TOPLEFT", 44, -16)
				ftitle:SetFont(GameFontHighlightSmall:GetFont(), 12)
				if Attune_DB.toons[attunelocal_charKey].attuned[step.ID_ATTUNE] == 100 then
					ftitle:SetText(Lang["Attuned"])
				else
					ftitle:SetText(Lang["Not attuned"])
				end
			else
				ftitle:SetPoint("TOPLEFT", 44, -8)
				ftitle:SetFont(GameFontHighlightSmall:GetFont(), 11)

				if step.TYPE == "Item" then
					if countNeeded == 1 then
						--ftitle:SetText(step.STEP)
						ftitle:SetText(Lang["I_"..step.ID_WOWHEAD])
					else
						ftitle:SetText(Lang["I_"..step.ID_WOWHEAD] .. " (" .. Attune_DB.toons[attunelocal_charKey].items[step.ID_WOWHEAD] .. "/" .. countNeeded .. ")")
					end
				elseif step.TYPE == "Kill" or step.TYPE == "Interact" then
					ftitle:SetText(Lang["N1_"..step.ID_WOWHEAD])

				elseif step.TYPE == "Quest" or step.TYPE == "Pick Up" or step.TYPE == "Turn In" then
					ftitle:SetText(Lang["Q1_"..step.ID_WOWHEAD])
				else
					ftitle:SetText(step.STEP)
				end
			end
			ftitle:Show()


			-- type and icon (level, interact, quest, kill...), reuse when possible
			if step.TYPE ~= 'End' then

				-- format depending on type
				local type = "|cffffd100"..Lang[step.TYPE].."|r"
				if step.TYPE == "Level" then type = "|cffffd100"..Lang["Required level"].."|r"
				elseif step.TYPE == "Attune" then type = "|c60808080"..Lang["Attunement or key"].."|r"
				elseif step.TYPE == "Rep" then type = "|cffffd100"..Lang["Reputation"].."|r"
				elseif step.LOCATION ~= "" then type = type .. "|c60808080 ".. Lang["in"].." "..Lang[step.LOCATION].."|r"
				end

				local exist = false
				for _, f in ipairs(attunelocal_frames) do if f == "Attune_Type_"..step.ID then exist = true end end
				local ftype
				if exist then 	ftype = _G["Attune_Type_"..step.ID] --reuse
				else			ftype = fnode:CreateFontString("Attune_Type_"..step.ID)
								table.insert(attunelocal_frames, "Attune_Type_"..step.ID) -- recording, to reuse
				end
				ftype:SetPoint("TOPLEFT", 44, -24)
				ftype:SetWidth(attunelocal_Node_Width - 50)
				ftype:SetHeight(16)
				ftype:SetJustifyH("LEFT")
				ftype:SetFont(GameFontHighlightSmall:GetFont(), 9)
				ftype:SetText(type)
				ftype:Show()
			end


			if countSameStep > 0 or countCompleted > 0 then

				--notification text
				local exist = false
				for _, f in ipairs(attunelocal_frames) do if f == "Attune_NotifText_"..step.ID then exist = true end end
				local notiftext
				if exist then 	notiftext = _G["Attune_NotifText_"..step.ID] -- reuse
				else			notiftext = fnode:CreateFontString("Attune_NotifText_"..step.ID)
								table.insert(attunelocal_frames, "Attune_NotifText_"..step.ID) -- recording, to reuse
				end
				notiftext:SetParent(fnode)
				notiftext:SetWidth(32)
				notiftext:SetFont(GameFontHighlightSmall:GetFont(), 10)
				notiftext:SetText(""..((countSameStep > 0) and countSameStep or countCompleted))
				notiftext:Show()



				--notification icon
				local exist = false
				for _, f in ipairs(attunelocal_frames) do if f == "Attune_Notif_"..step.ID then exist = true end end
				local notif
				if exist then 	notif = _G["Attune_Notif_"..step.ID] -- reuse
				else			notif = CreateFrame("Button", "Attune_Notif_"..step.ID)
								table.insert(attunelocal_frames, "Attune_Notif_"..step.ID) -- recording, to reuse
				end
				notif:SetPoint("TOPRIGHT", fnode, "TOPRIGHT", Attune_DB.mini and 6 or 8, Attune_DB.mini and -6 or 5)
				notif:SetParent(fnode)
				notif:SetWidth(32)
				notif:SetHeight(16)
				notif:SetFontString(notiftext)
				notif:SetNormalTexture("Interface\\AddOns\\Attune\\Images\\" .. ((countSameStep > 0) and "notification" or "completion"))
				notif:SetHighlightTexture("Interface\\AddOns\\Attune\\Images\\" .. ((countSameStep > 0) and "notification" or "completion"))
				notif:SetToplevel(true)
				notif:EnableMouse(false)
				notif:Disable()
				notif:Show()
			end

		end
	else
		--make spacer transparent
		fnode:SetBackdropColor(0, 0, 0, 0)
		fnode:SetBackdropBorderColor(1, 1, 1, 0)
	end

	fnode:Show()

	-- Create lines between nodes
	-- 3 lines for each connection. No diagonals are used, only horizontal or vertical, to make it easier to look at
	if step.FOLLOWS ~= "0" then
		local followOR = false;
		local fIDs = Attune_split(step.FOLLOWS, "&")
		if string.find(step.FOLLOWS, "|") then fIDs = Attune_split(step.FOLLOWS, "|"); followOR = true end
		for fi, flw in pairs(fIDs) do

			local linedone = Attune_DB.toons[attunelocal_charKey].done[step.ID_ATTUNE .. "-" .. flw]


			-- VERTICAL Line from prev to just under prev
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Line1_"..step.ID.."_"..flw then exist = true end end

			local cur, _, _, curX, curY  = _G["Attune_Node_"..step.ID]:GetPoint()
			local prev, _, _, prevX, prevY = _G["Attune_Node_"..flw]:GetPoint()
			local offset = ((Attune_DB.mini and attunelocal_MiniLine_Thickness or attunelocal_Line_Thickness)/2)

			local line
			if exist then 	line = _G["Attune_Line1_"..step.ID.."_"..flw] --reuse
			else			line = fnode:CreateLine("Attune_Line1_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "Attune_Line1_"..step.ID.."_"..flw) -- recording, to reuse
			end
			if done then
				if linedone then
					line:SetColorTexture(0.388, 0.686, 0.388, 1) -- green
					line:SetDrawLayer("ARTWORK",2)
				else
					line:SetColorTexture(0.2, 0.2, 0.2, 1)
					line:SetDrawLayer("ARTWORK",0)
				end
			else
				if linedone then
					line:SetColorTexture(0.851, 0.608, 0.0, 1) -- yellow
					line:SetDrawLayer("ARTWORK",1)
				else
					line:SetColorTexture(0.2, 0.2, 0.2, 1)
					line:SetDrawLayer("ARTWORK",0)
				end
			end
			line:SetThickness(Attune_DB.mini and attunelocal_MiniLine_Thickness or attunelocal_Line_Thickness)
			line:SetStartPoint("TOP", prevX - curX, prevY - curY - (Attune_DB.mini and attunelocal_MiniNode_Height or attunelocal_Node_Height))
			line:SetEndPoint("TOP", prevX - curX, prevY - curY - (Attune_DB.mini and (attunelocal_MiniNode_Height + (attunelocal_MiniNode_VGap/2)) or (attunelocal_Node_Height + (attunelocal_Node_VGap/2))) - offset)
			line:Show()


			-- VERTICAL Line to go all the way down to cur
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Line3_"..step.ID.."_"..flw then exist = true end end

			local line
			if exist then 	line = _G["Attune_Line3_"..step.ID.."_"..flw]
			else			line = fnode:CreateLine("Attune_Line3_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "Attune_Line3_"..step.ID.."_"..flw) -- recording, to reuse
			end
			if done then
				if linedone then
					line:SetColorTexture(0.388, 0.686, 0.388, 1) -- green
					line:SetDrawLayer("ARTWORK",2)
				else
					line:SetColorTexture(0.2, 0.2, 0.2, 1)
					line:SetDrawLayer("ARTWORK",0)
				end
			else
				if linedone then
					line:SetColorTexture(0.851, 0.608, 0.0, 1) -- yellow
					line:SetDrawLayer("ARTWORK",1)
				else
					line:SetColorTexture(0.2, 0.2, 0.2, 1)
					line:SetDrawLayer("ARTWORK",0)
				end
			end
			line:SetThickness(Attune_DB.mini and attunelocal_MiniLine_Thickness or attunelocal_Line_Thickness)
			line:SetStartPoint("TOP", 0, prevY - curY - (Attune_DB.mini and (attunelocal_MiniNode_Height + (attunelocal_MiniNode_VGap/2)) or (attunelocal_Node_Height + (attunelocal_Node_VGap/2))) + offset)
			line:SetEndPoint("TOP", 0, -2)
			line:Show()



			-- HORIZONTAL Line to center on curX
			local exist = false
			for _, f in ipairs(attunelocal_frames) do if f == "Attune_Line2_"..step.ID.."_"..flw then exist = true end end

			local line
			if exist then 	line = _G["Attune_Line2_"..step.ID.."_"..flw]
			else			line = fnode:CreateLine("Attune_Line2_"..step.ID.."_"..flw)
							table.insert(attunelocal_frames, "Attune_Line2_"..step.ID.."_"..flw) -- recording, to reuse
			end
			if done then
				if linedone then
					line:SetColorTexture(0.388, 0.686, 0.388, 1) -- green
					line:SetDrawLayer("ARTWORK",2)
				else
					line:SetColorTexture(0.2, 0.2, 0.2, 1)
					line:SetDrawLayer("ARTWORK",0)
				end
			else
				if linedone then
					line:SetColorTexture(0.851, 0.608, 0.0, 1) -- yellow
					line:SetDrawLayer("ARTWORK",1)
				else
					line:SetColorTexture(0.2, 0.2, 0.2, 1)
					line:SetDrawLayer("ARTWORK",0)
				end
			end
			line:SetThickness(Attune_DB.mini and attunelocal_MiniLine_Thickness or attunelocal_Line_Thickness)

			if prevX < 0 or curX < 0 then offset = -offset 	end -- need for the line thickness in corners
			line:SetStartPoint("TOP", offset, prevY - curY - (Attune_DB.mini and (attunelocal_MiniNode_Height + (attunelocal_MiniNode_VGap/2)) or (attunelocal_Node_Height + (attunelocal_Node_VGap/2))))
			line:SetEndPoint("TOP", prevX - curX + offset, prevY - curY - (Attune_DB.mini and (attunelocal_MiniNode_Height + (attunelocal_MiniNode_VGap/2)) or (attunelocal_Node_Height + (attunelocal_Node_VGap/2))))
			line:Show()


		end
	end
end


-------------------------------------------------------------------------
-- Trigger a redraw of the Attune tab
-------------------------------------------------------------------------

function Attune_ForceAttuneTabRefresh()
	if not attunelocal_initial then
		attunelocal_treeIsShown = not attunelocal_treeIsShown
		Attune_ToggleView()
	end
end


-------------------------------------------------------------------------
-- Toggle between the Attune tab and the result summary tab
-------------------------------------------------------------------------

function Attune_ToggleView()

	attunelocal_frame:ReleaseChildren()
	--Hiding all frames
	for i, f in pairs(attunelocal_frames) do _G[f]:Hide() end

	if attunelocal_treeIsShown then

		_G["GuildButton"]:SetText(Lang["Attunes"])

		-- SHOW RESULT FRAME
		PlaySound(856)  --igMainMenuOptionCheckBoxOn
		attunelocal_treeIsShown = false

		attunelocal_guildframe = AceGUI:Create("SimpleGroup")
		attunelocal_guildframe:SetLayout("Flow")
		attunelocal_guildframe:SetFullWidth(true)
		attunelocal_guildframe:SetFullHeight(true)
		attunelocal_guildframe:SetAutoAdjustHeight(false)
		attunelocal_frame:AddChild(attunelocal_guildframe)


		attunelocal_gscroll = AceGUI:Create("ScrollFrame")
		attunelocal_gscroll:SetLayout("Flow")
		attunelocal_gscroll:SetFullWidth(true)
		attunelocal_guildframe:AddChild(attunelocal_gscroll)


		-- This script needed to allow the scrollframe resize whenever content changes or vertical size is moved
		attunelocal_gscroll.frame:SetScript("OnUpdate", function()
			attunelocal_gscroll:SetHeight(attunelocal_frame.frame:GetHeight() - 80)
		end)

		--Display guild name and sort message
		local titleGroup = AceGUI:Create("SimpleGroup")
		titleGroup:SetRelativeWidth(0.5)

		local label = AceGUI:Create("Label")
		label:SetText(attunelocal_myguild)
		if UnitFactionGroup("player") == 'Horde' then
			label:SetImage("Interface\\Icons\\inv_bannerpvp_01")
		else
			label:SetImage("Interface\\Icons\\inv_bannerpvp_02")
		end
		label:SetFont(GameFontHighlight:GetFont(), 24)
		label:SetImageSize(32,32)
		label:SetFullWidth(true)
		titleGroup:AddChild(label)

		local sortlabel = AceGUI:Create("Label")
		sortlabel:SetText("\n|c80808080"..Lang["Click on a header to sort the results"].."|r")
		sortlabel:SetFont(GameFontHighlightSmall:GetFont(), 12)
		sortlabel:SetFullWidth(true)
		titleGroup:AddChild(sortlabel)

		attunelocal_gscroll:AddChild(titleGroup)


		--CheckBox
		local radioGroup = AceGUI:Create("SimpleGroup")
		radioGroup:SetRelativeWidth(0.3)

		local radio1 = AceGUI:Create("CheckBox")
		radio1:SetType("radio")
		radio1:SetLabel(Lang["Last survey results"])
		radio1:SetValue(attunelocal_resultselection == 0)
		radioGroup:AddChild(radio1)

		local radio2 = AceGUI:Create("CheckBox")
		radio2:SetType("radio")
		radio2:SetLabel(Lang["Guild members"])
		radio2:SetValue(attunelocal_resultselection == 1)
		radioGroup:AddChild(radio2)

		local radio3 = AceGUI:Create("CheckBox")
		radio3:SetType("radio")
		radio3:SetLabel(Lang["All results"])
		radio3:SetValue(attunelocal_resultselection == 2)
		radioGroup:AddChild(radio3)

		radio1:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 0
			radio1:SetValue(true)
			radio2:SetValue(false)
			radio3:SetValue(false)
			Attune_ShowResultList(label)
		end)
		radio2:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 1
			radio1:SetValue(false)
			radio2:SetValue(true)
			radio3:SetValue(false)
			Attune_ShowResultList(label)
		end)
		radio3:SetCallback("OnValueChanged", function(obj, evt, val)
			attunelocal_resultselection = 2
			radio1:SetValue(false)
			radio2:SetValue(false)
			radio3:SetValue(true)
			Attune_ShowResultList(label)
		end)

		attunelocal_gscroll:AddChild(radioGroup)


		--Slider
		local slider = AceGUI:Create("Slider")
		slider:SetValue(Attune_DB.minFilterValue or 1)
		slider:SetSliderValues(1, 70, 1)
		slider:SetLabel(Lang["Minimum level"])
		slider:SetRelativeWidth(0.2)
		slider:SetCallback("OnValueChanged", function(slid)
			Attune_DB.minFilterValue = slid:GetValue()
		end)
		slider:SetCallback("OnMouseUp", function(slid)
			Attune_ShowResultList(label)
		end)
		attunelocal_gscroll:AddChild(slider)


		--Header row
		local gftitle = AceGUI:Create("InlineGroup")
		gftitle:SetLayout("Flow")
		gftitle:SetAutoAdjustHeight(true)
		gftitle:SetFullWidth(true)

		attunelocal_gflabel = AceGUI:Create("InteractiveLabel")
		attunelocal_gflabel:SetText(Lang["Character"])
		attunelocal_gflabel:SetWidth(145)
		attunelocal_gflabel:SetFont(GameFontHighlight:GetFont(), 16)
		attunelocal_gflabel:SetCallback("OnClick", function()
			if Attune_DB.sortresult[1] == 0 then
				--same sort, just change order
				Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
			else
				Attune_DB.sortresult[1] = 0
				Attune_DB.sortresult[2] = true
			end
			Attune_ShowResultList(label)
		end)
		gftitle:AddChild(attunelocal_gflabel)


		local expac = ""
		for i, a in pairs(Attune_Data.attunes) do

			if expac ~= a.EXPAC then
				local gfspacer = AceGUI:Create("Label")
				gfspacer:SetText(" ")
				gfspacer:SetWidth(30)
				gftitle:AddChild(gfspacer)
				expac = a.EXPAC
			end

			if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then
				local gficon = AceGUI:Create("Icon")
				gficon:SetImage(a.ICON)
				gficon:SetWidth(30)
				gficon:SetImageSize(24, 24)
				gficon.frame:SetScript("OnClick", function()
					if Attune_DB.sortresult[1] == a.ID then
						--same sort, just change order
						Attune_DB.sortresult[2] = not Attune_DB.sortresult[2]
					else
						Attune_DB.sortresult[1] = a.ID
						Attune_DB.sortresult[2] = true --desc better for attunes, but we're reversing % further down.
					end
					Attune_ShowResultList(label)
				end)
				gficon.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(a.NAME.." - "..a.EXPAC)  end)
				gficon.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)
				gftitle:AddChild(gficon)
			end
		end

		attunelocal_gscroll:AddChild(gftitle)


		attunelocal_glist = AceGUI:Create("SimpleGroup")
		attunelocal_glist:SetLayout("Flow")
		attunelocal_glist:SetAutoAdjustHeight(true)
		attunelocal_glist:SetFullWidth(true)

		Attune_ShowResultList(label)

		attunelocal_gscroll:AddChild(attunelocal_glist)





	else

		_G["GuildButton"]:SetText(Lang["Results"])

		-- SHOW TREE FRAME
		attunelocal_treeIsShown = true

		-- create the tree
		attunelocal_treeframe = AceGUI:Create("TreeGroup")
		attunelocal_treeframe:SetTree(attunelocal_tree)
		attunelocal_treeframe:SetLayout("Fill")
		attunelocal_treeframe:SetFullWidth(true)
		attunelocal_treeframe:SetFullHeight(true)
		attunelocal_treeframe:SetAutoAdjustHeight(false)
		attunelocal_frame:AddChild(attunelocal_treeframe)

		for i, a in pairs(Attune_Data.attunes) do
			attunelocal_treeframe:SelectByPath(a.EXPAC)
		end
		attunelocal_treeframe:SetCallback("OnGroupSelected", function(container, event, group)
			AttuneLastViewed = group
			local st, le = string.find(group, "\001")
			if st ~= nil then -- not a group
				local g = string.sub(group, st+1)
				if g ~= "" then
					Attune_Select(g)
				end
			end
		end)

		attunelocal_treeframe:SetCallback("OnTreeResize", function(container, event, group)
			--force the size to 175
			container.treeframe:SetWidth(175)
		end)

		attunelocal_right = AceGUI:Create("SimpleGroup")
		attunelocal_right:SetLayout("Fill")
		attunelocal_right:SetFullWidth(true)
		attunelocal_right:SetFullHeight(true)
		attunelocal_right:SetAutoAdjustHeight(false)
		attunelocal_treeframe:AddChild(attunelocal_right)

		attunelocal_scroll = AceGUI:Create("ScrollFrame")
		attunelocal_scroll:SetLayout("List")
		attunelocal_scroll:SetFullWidth(true)
		attunelocal_scroll:SetFullHeight(true)
		attunelocal_scroll:SetAutoAdjustHeight(false)
		attunelocal_right:AddChild(attunelocal_scroll)


		--select default attune (or last viewed)
		attunelocal_treeframe:SelectByPath(AttuneLastViewed)

	end

end

-------------------------------------------------------------------------
-- Create the list shown in the Result tab
-------------------------------------------------------------------------

function Attune_ShowResultList(title)

	local count = 0 -- number of rows displayed in table

	-- number of steps per attune - this is to calculate % completion
	local attuneSteps = {}
	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE ~= "Spacer" then
			if attuneSteps[s.ID_ATTUNE] == nil then attuneSteps[s.ID_ATTUNE] = 0 end
			attuneSteps[s.ID_ATTUNE] = attuneSteps[s.ID_ATTUNE] +1
		end
	end

	-- adjust the title according to the selection
	if title ~= nil then
		local gg = attunelocal_myguild
		if gg == "" then gg = Lang['Not in a guild'] end

		if attunelocal_resultselection == 0 then
			title:SetText(Lang["Last survey results"])
		elseif attunelocal_resultselection == 1 then
			title:SetText(gg)
		else
			local fact, factLoc = UnitFactionGroup("player")
			title:SetText(Lang["All FACTION results"]:gsub("##FACTION##", factLoc ))
		end

	end

	attunelocal_glist:ReleaseChildren()


	-- parse all recorded toons and get their progress
	for kt, t in pairs(Attune_DB.toons) do
		-- calculate how many steps this toon has done on the attune
		local attuneDone = {}
		for i, d in pairs(t.done) do
			local Ids = Attune_split(i, "-")
			if attuneDone[Ids[1]] == nil then attuneDone[Ids[1]] = 0 end
			attuneDone[Ids[1]] = attuneDone[Ids[1]] +1
		end

		if t.attuned == nil then t.attuned = {} end
		for i, a in pairs(Attune_Data.attunes) do
			if attuneDone[a.ID] == nil then attuneDone[a.ID] = 0 end
			t.attuned[a.ID] = math.floor(100*(attuneDone[a.ID]/attuneSteps[a.ID]))
		end

	end


	-- display the list according to the sort order
	--for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b) 	return b > a end) do
	for kt, t in Attune_spairs(Attune_DB.toons, function(t,a,b)
		if Attune_DB.sortresult[1] == 0 then
			if Attune_DB.sortresult[2] then
				return b > a
			else
				return a > b
			end
		else
			--sort by attune % AND name. reversing the % with "100-" to be able to sort names alpha
			if Attune_DB.sortresult[2] then
				return string.format("%03i", 100-t[b].attuned[Attune_DB.sortresult[1]]) .. b > string.format("%03i", 100-t[a].attuned[Attune_DB.sortresult[1]]) .. a
			else
				return string.format("%03i", 100-t[a].attuned[Attune_DB.sortresult[1]]) .. a > string.format("%03i", 100-t[b].attuned[Attune_DB.sortresult[1]]) .. b
			end
		end
	 end) do

		-- only look at current faction (and current realm)
		if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then

			-- look for:
			-- 		if attunelocal_resultselection == 0, players in the same guild, or if unguilded just this player
			-- 		if attunelocal_resultselection == 1, players that have been put in the survey list
			--		if attunelocal_resultselection == 2, all players recorded
			if (attunelocal_resultselection == 0 and Attune_DB.survey[kt])
			or (attunelocal_resultselection == 1 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == UnitName("player")))
			or (attunelocal_resultselection == 2) then

				if tonumber(t.level) >= (Attune_DB.minFilterValue or 1) then

					count = count + 1
					local lev = t.level
					if tonumber(lev) < 10 then lev = "  "..lev end -- align numbers when under 10

					local ggg = t.guild
					if ggg == '' then ggg = "(Not in a guild)" else ggg = "< "..ggg.." >" end

					local vvv = t.version
					if vvv == nil then vvv = "(older addon version)" else vvv = "(v"..vvv..")" end


					-- container for the whole row
					local gframe = AceGUI:Create("SimpleGroup")
					gframe:SetLayout("Flow")
					gframe:SetAutoAdjustHeight(true)
					gframe:SetFullWidth(true)
					gframe.frame:SetScript("OnEnter", function() attunelocal_frame:SetStatusText(t.name.."  "..ggg.."    "..vvv)  end)
					gframe.frame:SetScript("OnLeave", function() attunelocal_frame:SetStatusText(attunelocal_statusText)  end)

					-- add toon part
						local glabel = AceGUI:Create("Label")
						glabel:SetText("    |c80808080"..lev.."|r  |T"..Attune_Icons(string.upper(t.class), nil)..":16|t  "..t.name)
						glabel:SetWidth(160)
						glabel:SetFont(GameFontHighlightSmall:GetFont(), 12)
						gframe:AddChild(glabel)


					-- Go through each Attune and create the corresponding % label for this toon
					local expac = ""
					for i, a in pairs(Attune_Data.attunes) do

						-- This spacer to separate Wow classic from TBC attunes
						if expac ~= a.EXPAC then
							local gfspacer = AceGUI:Create("Label")
							gfspacer:SetText(" ")
							gfspacer:SetWidth(30)
							gframe:AddChild(gfspacer)
							expac = a.EXPAC
						end

						-- Only look at attunes for this toon's faction
						if a.FACTION == UnitFactionGroup("player") or a.FACTION == 'Both' then

							local gflabel = AceGUI:Create("Label")
							if t.attuned[a.ID] == 100 then
								gflabel:SetText("|TInterface\\AddOns\\Attune\\Images\\success:16|t")
							else
								gflabel:SetText(t.attuned[a.ID].."%")
							end
							gflabel:SetWidth(30)
							gframe:AddChild(gflabel)

						end
					end


					if attunelocal_charKey ~= kt then
						-- add a delete button, to allow removing players from our data (for example if they changed guilds)
						local gdel = AceGUI:Create("Button")
						gdel:SetText("X")
						gdel:SetWidth(50)
						gdel:SetCallback("OnClick", function()
							Attune_DB.toons[kt] = nil
							Attune_ShowResultList() -- reload list after delete
						end)
						gframe:AddChild(gdel)
					end

					-- add the row to the list
					attunelocal_glist:AddChild(gframe)

				end
			end
		end
	end

	attunelocal_gflabel:SetText(Lang["Characters"].." ("..count..")")
	attunelocal_gscroll.content.obj.content:SetHeight(attunelocal_frame.frame:GetHeight() - 80)

end

-------------------------------------------------------------------------

function Attune_count(tab)
	local attunelocal_count = 0
	for Index, Value in pairs(tab) do
		attunelocal_count = attunelocal_count + 1
	end
	return attunelocal_count

end


-------------------------------------------------------------------------
-- Send the Addon request (surve) to the selected channel
-------------------------------------------------------------------------

function Attune_SendRequest(what)
	Attune_DB.survey = {}
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["SendingSurveyWhat"]:gsub("##WHAT##", Lang[what])) end
	C_ChatInfo.SendAddonMessage(attunelocal_prefix, "SURVEY", string.upper(what), "");

end

-------------------------------------------------------------------------
-- This is the same as SendRequest('Guild') except the surveyed players
-- won't see a message saying they replied.
-- Useful for debug purposes, to not annoy players with repeated messages
-------------------------------------------------------------------------

function Attune_SendSilentGuildRequest()
	Attune_DB.survey = {}
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["SendingGuildSilentSurvey"]) end
	C_ChatInfo.SendAddonMessage(attunelocal_prefix, "SILENTSURVEY", "GUILD", "");

end

-------------------------------------------------------------------------
-- Same as SendRequest, but in the YELL range
-- Quirk to see who around has the addon, silently
-------------------------------------------------------------------------

function Attune_SendSilentYellRequest()
	Attune_DB.survey = {}
	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["SendingYellSilentSurvey"]) end
	C_ChatInfo.SendAddonMessage(attunelocal_prefix, "SILENTSURVEY", "YELL", "");

end

-------------------------------------------------------------------------
-- Send my attune information (request results)
-- Information is sent back via addon whisper to the surveyRequestor
-- This defines what is sent back (1. toon meta, 2. steps done, 3. end)
-------------------------------------------------------------------------

function Attune_SendRequestResults(surveyRequestor)

	local meta = {}
	meta.l = UnitLevel("player")
	local attunelocal_faction = UnitFactionGroup("player")
	_, classFile = UnitClass("player")
	_, raceFile = UnitRace("player")

	local g = UnitSex("player")
	meta.g = 'male'
	if g == 3 then meta.g = 'female' end
	meta.c = classFile
	meta.r = raceFile   --Scourge, Troll, etc
	--meta.owner = 1

	local guildName, guildRankName, guildRank = GetGuildInfo("player");
	if guildName == nil then
		meta.o = 0 --not officer
		guildName = ""
	else
		if guildRank == 0 or CanGuildRemove() then
			meta.o = 1 --officer
		else
			meta.o = 0 --not officer
		end
	end
	attunelocal_myguild = guildName

	-- Send a first response with the player metadata
	C_ChatInfo.SendAddonMessage(attunelocal_prefix, UnitName("player") .. "|TOON|" .. meta.g  .. "|" .. meta.c .. "|" .. meta.r .. "|" .. meta.l .. "|" .. meta.o .. "|".. guildName.."|"..attunelocal_version, "WHISPER", surveyRequestor)  --the last pipe is in case the guildname is empty. still need it as blank, not nil


	-- then send a bunch of followup whispers with the completed steps
	local att = Attune_DB.toons[attunelocal_charKey]
	for key, status in pairs(att.done) do
		if status then --step done
			C_ChatInfo.SendAddonMessage(attunelocal_prefix, UnitName("player") .. "|DONE|" .. key, "WHISPER", surveyRequestor)
		end
	end

	-- Send a closing message after 1sec (to make sure it arrives last)
	C_Timer.After(0.250, function()
		C_ChatInfo.SendAddonMessage(attunelocal_prefix, UnitName("player") .. "|OVER", "WHISPER", surveyRequestor)
	end)

end

-------------------------------------------------------------------------
-- Handle the replies from the survey
-- Typically comes as 1 'meta' whisper, many 'step' whispers and 1 'over'
--    META contains: name|TOON|gender|class|race|level|officer|guild
--    STEP contains: name|DONE|attune-step
--    OVER contains: name|OVER|
-------------------------------------------------------------------------

function Attune_HandleRequestResults(response)

	--consolidate responses
	local data = Attune_split(response, "|")
	local name = data[1].."-"..attunelocal_realm
	local tag = data[2]


	Attune_DB.survey[name] = 1

	-- initialize the record for this player
--	if attunelocal_data[name] == nil then attunelocal_data[name] = {} end
--	local player = attunelocal_data[name]
	if Attune_DB.toons[name] == nil then Attune_DB.toons[name] = {} end
	local player = Attune_DB.toons[name]


	-- META reply
	if tag == 'TOON' then
		attunelocal_count = attunelocal_count + 1
		player.name = data[1] -- short name
		player.gender = data[3]	--gender
		player.class = data[4]	--class
		player.race = data[5]	--race
		player.level = data[6]	--level
		player.officer = data[7]	--officer in their guild
		player.guild = data[8]	--guild
		player.version = data[9]	--version
		player.faction = UnitFactionGroup("player")

		-- check if this is the requester or someone else
		if player.name == UnitName("player") then player.owner = 1 else player.owner = 0 end

		-- initialize the STEP container
		if player.done == nil then	player.done = {}	end

		if player.version ~= nil then
			if player.version > attunelocal_version and not attunelocal_detectedNewer then
				attunelocal_detectedNewer = true
				if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["NewVersionAvailable"]) end-- detected someone with a newer version, warn the user
			end
		end


	-- STEP replies
	elseif tag == 'DONE' then
		player.done[data[3]] = 1 -- step



	-- OVER reply
	elseif tag == 'OVER' then
		if player.name ~= UnitName("player") then
			if Attune_DB.showResponses then print("|cffff00ff[Attune]|r "..Lang["ReceivedDataFromName"]:gsub("##NAME##",  player.name)) end -- received data from someone else, might as well announce it in chat
			Attune_CheckIsNext(name)
		end

		if attunelocal_frame ~= nil then
			if not attunelocal_treeIsShown then
				Attune_ShowResultList()	-- update result tab if already shown
			else
				if not attunelocal_initial then
					attunelocal_resultselection = 0
					Attune_ToggleView()
				end
			end
			attunelocal_initial = false -- disable the 'no announce on first load'
		end

	end

end

-------------------------------------------------------------------------
-- encode data and show popup to copy it
-------------------------------------------------------------------------

function Attune_ExportToWebsite()

	attunelocal_data = {}
	attunelocal_data['_realm'] = attunelocal_realm
	attunelocal_data['_faction'] = UnitFactionGroup("player")

	local count = 0

	-- parse all recorded toons
	for kt, t in pairs(Attune_DB.toons) do

		-- only look at current faction and realm
		if t.faction == UnitFactionGroup("player") and (kt == t.name.."-"..attunelocal_realm) then

			-- export data:
			-- 		if attunelocal_exportselection == 0, only this player
			-- 		if attunelocal_exportselection == 1, players that have been put in the survey list
			--		if attunelocal_exportselection == 2, all players in the same guild
			--		if attunelocal_exportselection == 3, all players recorded
			if (attunelocal_exportselection == 0 and kt == (UnitName("player").."-"..attunelocal_realm))
			or (attunelocal_exportselection == 1 and Attune_DB.survey[kt])
			or (attunelocal_exportselection == 2 and ((attunelocal_myguild ~= "" and t.guild == attunelocal_myguild) or t.name == UnitName("player")))
			or (attunelocal_exportselection == 3) then

				count = count + 1
				attunelocal_data[t.name] = {}
				attunelocal_data[t.name].g = t.gender
				attunelocal_data[t.name].c = t.class
				attunelocal_data[t.name].r = t.race
				attunelocal_data[t.name].l = t.level
				attunelocal_data[t.name].o = t.officer
				attunelocal_data[t.name].G = t.guild
				--attunelocal_data[t.name].f = t.faction
				attunelocal_data[t.name].owner = t.owner
				attunelocal_data[t.name].done = "-1"

				for i, d in pairs(t.done) do
					attunelocal_data[t.name].done = attunelocal_data[t.name].done .. "|" .. i
				end
			end
		end
	end


	if Attune_DB.showOtherChat then print("|cffff00ff[Attune]|r "..Lang["ExportingData"]:gsub("##COUNT##", count)) end

	local serattunelocal_data = Attune_serialize(attunelocal_data)
	local ser = attunelocal_version .. "##" .. serattunelocal_data

	local encoded = Attune_enc(ser)

	StaticPopupDialogs["EXPORT_ATTUNE_GUILD"] = {
		text = Lang["Copy the text below, then upload it to"].."\n\nhttps://warcraftratings.com/attune/upload",
		button1 = Lang["Close"],
		OnShow = function (self, data)
			self.editBox:SetText(""..encoded)
			self.editBox:HighlightText()
			self.editBox:SetScript("OnEscapePressed", function(self) StaticPopup_Hide ("EXPORT_ATTUNE_GUILD") end)

		end,
		timeout = 0,
		hasEditBox = true,
		editBoxWidth = 350,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show ("EXPORT_ATTUNE_GUILD")

end

-------------------------------------------------------------------------

function Attune_spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[Attune_count(keys)+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-------------------------------------------------------------------------

function Attune_serialize (o)
	local res = ""
	if type(o) == "number" then
	  res = res .. o
	elseif type(o) == "string" then
		res = res .. string.format("%q", o)
	elseif type(o) == "table" then
		res = res .. "{\n"
	  for k,v in pairs(o) do
		if type(k) == "number" then
			res = res .. "  [" .. k .. "] = "
		elseif type(k) == "string" then
			 res = res .. "  [\"" .. k .. "\"] = "
		end
		res = res .. Attune_serialize(v)
		res = res .. ",\n"
	  end
	  res = res ..  "}"
	elseif type(o) == "boolean" then
		if o then res = res .. "true"
		else res = res .. "false" end
	else
	  error("cannot serialize a " .. type(o))
	end
	return res
end

-------------------------------------------------------------------------

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function Attune_enc(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-------------------------------------------------------------------------
-- decoding
function Attune_dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end


-------------------------------------------------------------------------

function Attune_formatTime(sec)
	local str = ""

	if sec ~= nil then
		local minutes, hours
		if (sec<60) then
			str = ""..sec.."sec"
		else
			minutes = math.floor(sec/60)
			sec = sec - (minutes*60)
			if (minutes<60) then
				str =  ""..minutes.."min"
			else
				hours = math.floor(minutes/60)
				minutes = minutes - (hours*60)
				str = ""..hours.."h"
				if (minutes > 0) then str = str .. " "..minutes.."min" end
			end
			if (sec > 0) then str = str .. " "..sec.."sec" end
		end
	else
		str = ""
	end
	return str
end

-------------------------------------------------------------------------

function Attune_split(str, sep)
	local t = {}
	local ind = string.find(str, sep)
	while (ind ~= nil) do
		table.insert(t, string.sub(str, 1, ind-1))
		str = string.sub(str, ind+1)
		ind = string.find(str, sep, 1, true)
	end
	if (str ~="") then table.insert(t, str) end
	return t
end

-------------------------------------------------------------------------
-- find if key exists in table
function Attune_locate(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

-------------------------------------------------------------------------

function Attune_Icons(what, gender)
	local icon = "Interface/Icons/inv_misc_questionmark"
	if (what == "DRUID") 	then icon = "Interface\\Icons\\inv_misc_monsterclaw_04" end
	if (what == "HUNTER") 	then icon = "Interface\\Icons\\inv_weapon_bow_07" end
	if (what == "MAGE") 	then icon = "Interface\\Icons\\inv_staff_13" end
	if (what == "PALADIN") then icon = "Interface\\AddOns\\Attune\\Images\\class_paladin" end
	if (what == "PRIEST") 	then icon = "Interface\\AddOns\\Attune\\Images\\class_priest" 	end
	if (what == "ROGUE") 	then icon = "Interface\\AddOns\\Attune\\Images\\class_rogue" end
	if (what == "SHAMAN") 	then icon = "Interface\\Icons\\spell_nature_bloodlust" end
	if (what == "WARLOCK") then icon = "Interface\\Icons\\spell_nature_drowsy" end
	if (what == "WARRIOR") then icon = "Interface\\Icons\\inv_sword_27" end

	local g = 'male'
	if gender == 3 then g = 'female' end
	if (what == "Dwarf") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_dwarf_"..g end
	if (what == "Gnome") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_gnome_"..g end
	if (what == "Human") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_human_"..g end
	if (what == "NightElf") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_nightelf_"..g end
	if (what == "Orc") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_orc_"..g end
	if (what == "Tauren") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_tauren_"..g end
	if (what == "Troll") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_troll_"..g end
	if (what == "Scourge") then icon = "Interface\\AddOns\\Attune\\Images\\achievement_character_undead_"..g end
	return icon
end

-------------------------------------------------------------------------

function Attune_SlashCommandHandler( msg )

	if (msg == 'help' or msg == '?') then

		print("|cffff00ff[Attune]|r "..Lang["Help1"])
		print("|cffff00ff[Attune]|r "..Lang["Help2"])
		print("|cffff00ff[Attune]|r ")
		print("|cffff00ff[Attune]|r "..Lang["Help3"])
		print("|cffff00ff[Attune]|r "..Lang["Help4"])
		print("|cffff00ff[Attune]|r "..Lang["Help5"])
		print("|cffff00ff[Attune]|r ")
		print("|cffff00ff[Attune]|r "..Lang["Help6"])

	elseif (msg == 'survey') then
		Attune_SendRequest("Guild");

	elseif (msg == 'silentsurvey') then
		Attune_SendSilentGuildRequest();	-- Guild check, without triggering the response message on remote toons. Mostly for debugging without annoying players

	elseif (msg == 'yell') then
		Attune_SendSilentYellRequest();		-- Check who's got the addon around you

	elseif attunelocal_initial == false and attunelocal_frame:IsShown() then
		attunelocal_frame:Hide()

	else
		Attune_CheckProgress()

		if attunelocal_initial then
			Attune_LoadTree()
			Attune_Frame()
			Attune_DB.survey = {}
			Attune_SendRequestResults(UnitName("player"));  -- Send a request to myself
		end
		attunelocal_frame:Show()

	end

end





-------------------------------------------------------------------------

function Attune_DisplayData()

	dtlocal_yy = 0
	Attune_ContainerFrame:SetHeight(26 - dtlocal_yy)

	--Hiding all frames
	for i, f in pairs(dtlocal_frames) do
		_G[f]:Hide()
	end



	-- GET OVERALL TOTAL (to calculate percentage per school)
	local dtlocal_total = 0
	for ip, p in pairs(dtlocal_schools) do
		dtlocal_total = dtlocal_total + p.sum
	end


--[[	-- LOOP THROUGH SCHOOLS
	for ip, p in pairs(dtlocal_schools) do

		if p.sum > 0 then
			local exist = false
			for _, f in ipairs(dtlocal_frames) do if f == "damagetype_school_"..ip then exist = true end end

			if not exist then
				CreateFrame("Frame", "damagetype_school_"..ip, DamageType_ContainerFrame, "DamageType_SchoolTemplate")
				table.insert(dtlocal_frames, "damagetype_school_"..ip)
			end

			_G["damagetype_school_"..ip.."_sum"]:SetText(DamageType_formatNumber(p.sum))
			_G["damagetype_school_"..ip.."_pct"]:SetText(DamageType_Round(100 * p.sum / dtlocal_total, 2).."%  " .. p.resist)
			_G["damagetype_school_"..ip.."_schoolIcon"]:SetNormalTexture(DamageType_schoolIcons(ip)[2]);
			--_G["damagetype_school_"..ip.."_name"]:SetText("|cffffff00"..ip.."|r")

			_G["damagetype_school_"..ip]:SetParent(DamageType_ContainerFrame)
			_G["damagetype_school_"..ip]:SetPoint("TOPLEFT", DamageType_ContainerFrame, "TOPLEFT", 5, dtlocal_yy);
			_G["damagetype_school_"..ip]:Show()

			dtlocal_yy = dtlocal_yy - 30
			DamageType_ContainerFrame:SetHeight(4 - dtlocal_yy)

		end
	end
]]
end


-------------------------------------------------------------------------
--[[
function Attune_CreateRepWidget()

	--icon, reuse object when possible
	local exist = false
	for _, f in ipairs(attunelocal_repWidget_frames) do if f == "Attune_repWidget_Frame" then exist = true end end
	if exist then 	attunelocal_repWidget = _G["Attune_repWidget_Frame"] -- reuse
	else			attunelocal_repWidget = CreateFrame("Frame", "Attune_repWidget_Frame", UIParent)
					table.insert(attunelocal_repWidget_frames, "Attune_repWidget_Frame") -- recording, to reuse
	end


	attunelocal_repWidget = CreateFrame("Frame",nil,UIParent)
	attunelocal_repWidget:SetFrameStrata("DIALOG")
	attunelocal_repWidget:SetWidth(500) -- Set these to whatever height/width is needed
	attunelocal_repWidget:SetHeight(500) -- for your Texture

	attunelocal_repWidget:EnableMouse(true)
	attunelocal_repWidget:SetMovable(true)
	attunelocal_repWidget:RegisterForDrag("LeftButton","RightButton");
	attunelocal_repWidget:SetClampedToScreen(true)
	attunelocal_repWidget:SetScript("OnDragStart", function()
		print("ondrag START")
		if Attune_DB.repWidget.lockWidget == false then
			attunelocal_repWidget:StartMoving()
		end
	end)
	attunelocal_repWidget:SetScript("OnDragStop", function()
		print("ondrag STOP")
		if Attune_DB.repWidget.lockWidget == false then
			attunelocal_repWidget:StopMovingOrSizing();
			Attune_DB.repWidget.point = attunelocal_repWidget:GetPoint()
		end
	end)

	--	local t = attunelocal_repWidget:CreateTexture(nil,"BACKGROUND")
--	t:SetTexture("Interface\\AddOns\\Attune\\Images\\inv_misc_token_thrallmar")
--	t:SetAllPoints(attunelocal_repWidget)
	attunelocal_repWidget.texture = t

	attunelocal_repWidget:SetPoint("TOPLEFT",0,0)

	if Attune_DB.repWidget.showWidget then attunelocal_repWidget:Show() else attunelocal_repWidget:Hide() end



	local yy = 0
	for i, s in pairs(Attune_Data.steps) do
		if s.TYPE == "Rep" then

--			print(s.STEP)
			local exist = false
			for _, f in ipairs(attunelocal_repWidget_frames) do if f == "Attune_repWidget_Icon_"..s.LOCATION then exist = true end end
			local icon
			if exist then 	icon = _G["Attune_repWidget_Icon_"..s.LOCATION] -- reuse
			else			icon = CreateFrame("Button", "Attune_repWidget_Icon_"..s.LOCATION, attunelocal_repWidget)
							table.insert(attunelocal_repWidget_frames, "Attune_repWidget_Icon_"..s.LOCATION) -- recording, to reuse
			end
			icon:SetPoint("TOPLEFT", attunelocal_repWidget, "TOPLEFT", 0, yy)
			icon:SetWidth(24)
			icon:SetHeight(24)
			icon:SetNormalTexture(s.ICON)
			icon:SetHighlightTexture(s.ICON)
			icon:SetToplevel(true)
			icon:EnableMouse(false)
			icon:Disable()
			icon:Show()


			local exist = false
			for _, f in ipairs(attunelocal_repWidget_frames) do if f == "Attune_repWidget_Text1_"..s.LOCATION then exist = true end end
			local ftext
			if exist then 	ftext = _G["Attune_repWidget_Text1_"..s.LOCATION] -- reuse
			else			ftext = attunelocal_repWidget:CreateFontString("Attune_repWidget_Text1_"..s.LOCATION)
							table.insert(attunelocal_repWidget_frames, "Attune_repWidget_Text1_"..s.LOCATION) -- recording, to reuse
			end
			ftext:SetWidth(150)
			ftext:SetHeight(16)
			ftext:SetJustifyH("LEFT")
			ftext:SetPoint("TOPLEFT", 30, yy-3)
			ftext:SetFont(GameFontHighlight:GetFont(), 16)
			ftext:SetText(s.ID_WOWHEAD)
			ftext:Show()
			yy = yy - 30
		end
	end


end
]]
-------------------------------------------------------------------------

SlashCmdList["Attune"] = Attune_SlashCommandHandler
SLASH_Attune1 = "/attune"
