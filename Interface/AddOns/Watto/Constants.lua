--[[
	Watto Classic v1.7.4
	Constants

	Static variables that rarely, if ever, change.
	
	Revision: $Id: Constants.lua 10 2019-09-05 15:20:34 Pacific Time Kjasi $
]]

Watto = {}
local w = Watto

w.Constants = {}
local c = w.Constants

w.Defaults = {
	["Options"] = {
		["autosell"] = false,
		["sellnotify"] = true,
		["randomselltext"] = true,
		["autosellfood"] = true,
		["usemoneyicons"] = true,
		["showtooltipdata"] = true,
		["sellbacklimiter"] = false,
		["selljunksoulbound"] = true,
		["fillreagentbank"] = true,
		["Version"] = "1.7.4",
		["PerChar"] = {},
	},
}

-- Player Data
w.PlayerData = {}
local P = w.PlayerData
P.Realm = GetRealmName()
P.Money = GetMoney()
P.Name = UnitName("player")
P.Level = UnitLevel("Player")
P.Class, P.G_Class = UnitClass("player")
P.Bags = {}
P.Bank = {}
P.BankBags = {}

w.List = {}
w.ListUpdated = false

-- Number of "Buy Back" slots merchants have.
c.MerchantSellSlots = 12