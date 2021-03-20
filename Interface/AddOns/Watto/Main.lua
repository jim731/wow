--[[
	Watto
	Version 1.7.4
	
	Revision: $Id: Main.lua 25 2019-09-06 09:25:16 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."Main is unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end
local L = w.Localization
if (not L) then
	print(RED_FONT_COLOR_CODE.."Main is unable to find Watto's Localization data."..FONT_COLOR_CODE_CLOSE)
	return
end
local C = w.Constants
if (not C) then
	print(RED_FONT_COLOR_CODE.."Main is unable to find Watto's Constants data."..FONT_COLOR_CODE_CLOSE)
	return
end
local P = w.PlayerData
if (not P) then
	print(RED_FONT_COLOR_CODE.."Main is unable to find Watto's Player data."..FONT_COLOR_CODE_CLOSE)
	return
end

w.CurrentItem = {}

w.Version = "1.7.4"

-- Libraries
local LibKJ = LibStub("LibKjasi-1.0")
-- Setup our addon with KjasiLib
LibKJ:setupAddon({
	["Name"] = L.WATTO_TITLE,
	["Version"] = w.Version,
	["MsgStrings"] = {
		["Default"] = L.MSG,
		["error"] = L.ERRORMSG,
	},
	["ChannelLevel"] = 0,
})

local Watto_Buy_FirstCall = false

function Watto_Msg(msg,channel)
	if (msg == nil) then return end
	LibKJ:Msg(L.WATTO_TITLE, msg, channel)
end

function Watto_Load(self)
	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("ITEM_PUSH")
	self:RegisterEvent("PLAYER_MONEY")

	SlashCmdList["Watto"] = Watto_CommandLine
	SLASH_Watto1 = "/watto"
end

function Watto_Loaded()
	Watto_Database_Build()
	Watto_Database_Update()

	hooksecurefunc("MerchantFrame_Update",Watto_Merchant_ChangeTab)
	hooksecurefunc("CloseMerchant",Watto_Merchant_OnHide)
	Orig_MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	MerchantItemButton_OnModifiedClick = Watto_Buy_OnModClick
	
	--== Tooltip Hooks ==--
	-- Main Game
	GameTooltip:HookScript("OnShow", Watto_TooltipSellNotice)
	GameTooltip:HookScript("OnTooltipSetItem", Watto_TooltipSellNotice)
	ItemRefTooltip:HookScript("OnShow", Watto_TooltipSellNotice)
	ShoppingTooltip1:HookScript("OnShow", Watto_TooltipSellNotice)
	ShoppingTooltip2:HookScript("OnShow", Watto_TooltipSellNotice)
	if ShoppingTooltip3 then
		ShoppingTooltip3:HookScript("OnShow", Watto_TooltipSellNotice)
	end
	hooksecurefunc(GameTooltip, "SetHyperlink", Watto_TooltipSellNotice)

	-- AtlasLoot
	if AtlasLootTooltip then
		AtlasLootTooltip:HookScript("OnShow", Watto_TooltipSellNotice)
	end

	w.options = Watto_Options
	w:UpdatePlayer()
	
	Watto_Msg(format(L.IS_LOADED,w.Version))
end

--== Database Building Functions ==--
function Watto_Database_Build()
	if (not Watto_Options) then
		Watto_Options = w.Defaults["Options"]
	end
	
	if (not Watto_ItemList) then
		Watto_ItemList = {
			["General"] = {},
			["PerChar"] = {},
		}
	end
	if (not Watto_ItemList["PerChar"][P.Realm]) then
		Watto_ItemList["PerChar"][P.Realm] = {}
	end
	if (not Watto_ItemList["PerChar"][P.Realm][P.Name]) then
		Watto_ItemList["PerChar"][P.Realm][P.Name] = {}
	end
	if (not Watto_TempSell) then
		Watto_TempSell = {}
	end
end

--== Database Updating Functions ==--
function Watto_Database_Update()
	-- If No Databases
	if (not Watto_Options) or (not Watto_ItemList) then
		Watto_Database_Build()
		return
	end
	-- If no Version Number
	if (not Watto_Options.Version) then
		Watto_Database_Build()
		return
	end
	-- If Version Number is the Current Version
	if (Watto_Options.Version == w.Version) then
		return
	end
	-- Else, Update the Database!
	Watto_Msg("Updating Database.")

	local temp = LibKJ:UpdateDatabase(Watto_Options, w.Defaults["Options"])

	temp.Version = w.Version
	Watto_Options = {}
	Watto_Options = temp
end

function Watto_Events(self, event, ...)
	if (event =="VARIABLES_LOADED") then
		Watto_Loaded()
	elseif (event == "MERCHANT_SHOW") then
		w:UpdatePlayer()
		w:getSellItems()
		Watto_Merchant_OnShow()
	elseif (event == "ITEM_PUSH") or (event == "BAG_UPDATE") or (event == "PLAYER_MONEY") then
		w.ListUpdated = false
		w:UpdatePlayer()
		w:getSellItems()
	end
end

function Watto_CommandLine(cmd)
	-- Force lowercase so we don't have to double-up our options! Also makes it more user-proof.
	if cmd == nil then cmd = "" end
	cmd = strlower(cmd)

	--Watto_Msg("Command: \""..cmd.."\"")

	if cmd == "" or cmd == L.CMD_HELP then
		Watto_Msg(L.CMD_HELP_TEXT)
	elseif cmd == L.CMD_SHOW or cmd == L.CMD_CONFIG then
		InterfaceOptionsFrame_OpenToCategory(Watto_InterfaceOptions)
	elseif cmd == L.CMD_ADD or cmd == L.CMD_ADD_ME then
		Watto_Msg(L.CMD_HELP_ADD)
	elseif cmd == L.CMD_REM or cmd == L.CMD_REM_ME then
		Watto_Msg(L.CMD_HELP_REM)
	elseif cmd == L.CMD_REM_ALL then
		Watto_ItemList["General"] = {}
		w.ListUpdated = false
		w:getSellItems()
		Watto_Msg(L.LIST_REMALL)
	elseif cmd == L.CMD_REM_ME_ALL then
		Watto_ItemList["PerChar"][P.Realm][P.Name] = {}
		w.ListUpdated = false
		w:getSellItems()
		Watto_Msg(L.LIST_REMMEALL)
	elseif cmd == L.CMD_LIST_ME then
		local list = L.LIST_PERSONALLISTING.."\r"
		local count = LibKJ:tcount(Watto_ItemList["PerChar"][P.Realm][P.Name])

		if count > 0 then
			local c = 1
			for k,v in pairs(Watto_ItemList["PerChar"][P.Realm][P.Name]) do
				local _,link = GetItemInfo(k)
				list = list..c..") "..link
				if c < count then
					list = list.."\r"
				end
				c = c+1
			end
		else
			list = L.LIST_EMPTYPERSONAL
		end
		Watto_Msg(list)
	elseif cmd == L.CMD_LIST then
		local list = {}
		local lnum = 0
		local countmax = 10
		local count = LibKJ:tcount(Watto_ItemList["General"])

		if count > 0 then
			local c = 1
			local counter = 0
			for k,v in pairs(Watto_ItemList["General"]) do
				local _,link = GetItemInfo(k)
				if (link) then
					if (not list[lnum]) then
						list[lnum] = ""
					end
					if (counter ~= 0) then
						list[lnum] = list[lnum].."\r"
					end
					list[lnum] = list[lnum]..c..") "..link
					c = c+1
					counter = counter+1
					if (counter == countmax) then
						lnum = lnum+1
						counter = 0
					end
				end
			end
		else
			list[0] = L.LIST_EMPTYGENERAL
		end
		Watto_Msg(L.LIST_GENERALLISTING)
		for x=0, lnum do
			Watto_Msg(list[x])
		end
	else
		Watto_CmdParse(cmd)
	end
end

local Commands = {
	L.CMD_ADD_ME,
	L.CMD_ADD,
	L.CMD_REM_ME,
	L.CMD_REM,
}

function Watto_CmdParse(cmd)
	local listing, command = "",""
	local linkPat = "|?|hitem.-|h.-|h"
	local outmsg = ""
	-- Watto_Msg("Parsing command \""..cmd.."\"...")

	-- Get the Command we're using
	for i=1, #Commands do
		local a = Commands[i]

		if string.find(cmd,a) then
			local com = string.find(cmd,a)
			command = strtrim(strsub(cmd,com,com+strlen(a)))
			--Watto_Msg("Command: \""..command.."\"")
			listing = string.gsub(cmd,command,"")
			break
		end
	end

	if command == nil then
		Watto_Msg(L.ERROR_UNKNOWNCOMMAND)
	end

	-- Watto_Msg("Items: \""..strtrim(tostring(gsub(listing, "\124", "\124\124"))).."\"")

	-- Generate the Items Table
	local items = {}
	for v in string.gmatch(listing, linkPat) do
		local vid = LibKJ:getIDNumber(v)
		tinsert(items,vid)
	end

	if (#items == 0) then
		Watto_Msg(L.ERROR_NO_ITEMS)
		return
	end
	
	-- Watto_Msg("Pre-bigloop, #Items: "..#items)
	-- Apply the Command to the items
	for x=1,#items do
		local _,link,_,itemLevel,_,itemType,itemSubType = GetItemInfo(items[x])
		local itemid = tonumber(items[x])
		--Watto_Msg("Item: "..tostring(itemid))

		if (command == L.CMD_ADD_ME) then
			--Watto_Msg("Attempting to add to Personal List...")
			if Watto_CheckforBadItem(items[x]) then
				outmsg=format(L.ERROR_LIST_BADITEM,link)
			elseif (not Watto_ItemList["PerChar"][P.Realm][P.Name][items[x]]) then
				local text_gen = L.LIST_ADDPERSONALBUTINGENERAL_SUCCESS
				local text_per = L.LIST_ADDPERSONAL_SUCCESS
				local nofoodsell = false

				for x=1,#w.Constants.NoAutoSell do
					if (tonumber(w.Constants.NoAutoSell[x]) == itemid) then
						nofoodsell = true
						break
					end
				end

				if (w.options.autosellfood == "on") and (itemType == L.WATTO_ITEMTYPE_CONSUMABLE) and (itemSubType == L.WATTO_ITEMSUBTYPE_FOODANDDRINK) and (nofoodsell == false) and (itemLevel+5 < UnitLevel("Player")) then
					text_gen = L.LIST_ADDPERSONALBUTINGENERALFOOD_SUCCESS
					text_per = L.LIST_ADDFOOD_SUCCESS
				end

				Watto_ItemList["PerChar"][P.Realm][P.Name][items[x]] = 1
				if (Watto_ItemList["General"][items[x]]) then
					outmsg=format(text_gen,link)
				else
					outmsg=format(text_per,link)
				end
			else
				outmsg=format(L.LIST_ADDPERSONAL_FAIL,link)
			end
			w.ListUpdated = false
			w:getSellItems()
		elseif (command == L.CMD_ADD) then
			local text = L.LIST_ADDGENERAL_SUCCESS
			local nofoodsell = false
			local isfood = false

			for x=1,#w.Constants.NoAutoSell do
				if (tonumber(w.Constants.NoAutoSell[x]) == itemid) then
					nofoodsell = true
					break
				end
			end

			if (w.options.autosellfood == "on") and (itemType == L.WATTO_ITEMTYPE_CONSUMABLE) and (itemSubType == L.WATTO_ITEMSUBTYPE_FOODANDDRINK) and (nofoodsell == false) and (itemLevel+5 < UnitLevel("Player")) then
				text = L.LIST_ADDFOOD_SUCCESS
			end

			--Watto_Msg("Attempting to add to Global List...")
			if Watto_CheckforBadItem(items[x]) then
				outmsg=format(L.ERROR_LIST_BADITEM,link)
			elseif (not Watto_ItemList["General"][items[x]]) then
				Watto_ItemList["General"][items[x]] = 1
				outmsg=format(text,link)
			else
				outmsg=format(L.LIST_ADDGENERAL_FAIL,link)
			end
			w.ListUpdated = false
			w:getSellItems()
		elseif (command == L.CMD_REM_ME) then
			if (Watto_ItemList["PerChar"][P.Realm][P.Name][items[x]]) then
				Watto_ItemList["PerChar"][P.Realm][P.Name] = Watto_RemoveFromTable(Watto_ItemList["PerChar"][P.Realm][P.Name],items[x])
				outmsg=format(L.LIST_REMPERSONAL_SUCCESS,link)
			else
				outmsg=format(L.LIST_REMPERSONAL_FAIL,link)
			end
			w:getSellItems()
		elseif (command == L.CMD_REM) then
			if (Watto_ItemList["General"][items[x]]) then
				Watto_ItemList["General"] = Watto_RemoveFromTable(Watto_ItemList["General"],items[x])
				outmsg=format(L.LIST_REMGENERAL_SUCCESS,link)
			else
				outmsg=format(L.LIST_REMGENERAL_FAIL,link)
			end
			w.ListUpdated = false
			w:getSellItems()
		else
			Watto_Msg("Unknown Command")
		end
		Watto_Msg(outmsg)
	end
end

function Watto_TranslateMoney(money)
	if money == nil then
		return 0, 0, 0
	end
	
	money = tostring(money)
	local c, s, g = nil
	
	c = strsub(money,-2)
	if (strlen(money)>2) then
		s = strsub(money,-4,-3)
	end
	if (strlen(money)>4) then
		g = strsub(money,0,strlen(money)-4)
	end
	return c, s, g
end

function Watto_CSG(money,useIcons,iconSize)
	if (not iconSize) then
		iconSize = 16
	end
	local c, s, g = Watto_TranslateMoney(money)
	local text = ""
	if (g ~= nil) then
		if (not useIcons) or (useIcons == 0) then
			text = g..L.GOLD_S
		else
			text = g..format("|TInterface\\MoneyFrame\\UI-GoldIcon:%d:%d:0:0|t",iconSize,iconSize)
		end
	end
	if (s ~= nil) and (s ~= "00") then
		if (not useIcons) or (useIcons == 0) then
			text = text..s..L.SILVER_S
		else
			text = text..s..format("|TInterface\\MoneyFrame\\UI-SilverIcon:%d:%d:0:0|t",iconSize,iconSize)
		end
	end
	if (c ~= nil) and (c ~= "00") then
		if (not useIcons) or (useIcons == 0) then
			text = text..c..L.COPPER_S
		else
			text = text..c..format("|TInterface\\MoneyFrame\\UI-CopperIcon:%d:%d:0:0|t",iconSize,iconSize)
		end
	end
	return text
end

function Watto_RemoveFromTable(table,index)
	local temp = {}

	for k,v in pairs(table) do
		if k ~= index then
			temp[k] = v
		end
	end
	return temp
end

-- Tooltip Searching
function Watto_TooltipFind(self, target)
	target = gsub(target, "-", "")
	for i=1,self:NumLines() do
		local mytextL = getglobal(self:GetName().."TextLeft"..i)
		local mytextR = getglobal(self:GetName().."TextRight"..i)
		local textL = mytextL:GetText()
		local textR = mytextR:GetText()
		textL = gsub(tostring(textL), "-", "")
		textR = gsub(tostring(textR), "-", "")
		if (textL) and (strfind(textL,target)) then
			local s = {strmatch(textL,target)}
			return true, s
		end
		if (textR) and (strfind(textR,target)) then
			local s = {strmatch(textL,target)}
			return true, s
		end
	end
	return
end