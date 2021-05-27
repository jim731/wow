--[[
	Watto v1.7.4
	Database
	
	Revision: $Id: Database.lua 3 2019-09-05 15:21:00 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."Gather is unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end
local C = w.Constants
if (not C) then
	print(RED_FONT_COLOR_CODE.."Gather is unable to find Watto's Constants data."..FONT_COLOR_CODE_CLOSE)
	return
end

-- A list of item to NEVER automatically sell to a merchant, unless otherwise listed.
C.NoAutoSell = {
	-- Food Items
	6522,		-- Deviate Fish
	6657,		-- Savory Deviate Delight
	19221,		-- Darkmoon Special Reserve
	17196,		-- Holiday Spirits (Winter Veil food)
	44114,		-- Old Spices
	44228,		-- Baby Spice
	44791,		-- Noblegarden Chocolate (Noblegarden food)
	44837,		-- Spice Bread Stuffing (Pilgrim's Bounty food)
	44838,		-- Slow-Roasted Turkey (Pilgrim's Bounty food)
	44839,		-- Candied Sweet Potato (Pilgrim's Bounty food)
	44854,		-- Tangy Wetland Cranberries (Pilgrim's Bounty food)
	44855,		-- Teldrassil Sweet Potato (Pilgrim's Bounty food)
	46784,		-- Ripe Elwynn Pumpkin (Pilgrim's Bounty food)
	
	-- Quest Items
	24475,		-- Gordawg's Imprint
	
	-- Notes & other items
	106902,		-- Faded Note found with Frostwolf Veteran's Keepsake
}

-- A list of items to ALWAY automatically sell to a merchant, unless otherwise listed.
C.AutoSell = {
	-- Used Fortune Cards
	60839,		-- 1g
	60840,		-- 1000g
	60841,		-- 5g
	60842,		-- 20g
	60843,		-- 50g
	60844,		-- 5000g
	60845,		-- 200g
	62606,		-- 50g
	62246,		-- 50s
	62247,		-- 10s
	62553,		-- 10s
	62552,		-- 10s
	62554,		-- 10s
	62555,		-- 10s
	62556,		-- 10s
	62557,		-- 10s
	62558,		-- 10s
	62559,		-- 10s
	62560,		-- 10s
	62561,		-- 10s
	62562,		-- 10s
	62563,		-- 10s
	62564,		-- 10s
	62565,		-- 10s
	62566,		-- 10s
	62567,		-- 10s
	62568,		-- 10s
	62569,		-- 10s
	62570,		-- 10s
	62571,		-- 10s
	62572,		-- 10s
	62573,		-- 10s
	62574,		-- 10s
	62575,		-- 10s
	62576,		-- 10s
	62577,		-- 50s
	62578,		-- 50s
	62579,		-- 50s
	62580,		-- 50s
	62581,		-- 50s
	62582,		-- 50s
	62583,		-- 50s
	62584,		-- 50s
	62585,		-- 50s
	62586,		-- 50s
	62587,		-- 50s
	62588,		-- 50s
	62589,		-- 50s
	62590,		-- 50s
	62591,		-- 50s
	62598,		-- 1g
	62599,		-- 1g
	62600,		-- 1g
	62601,		-- 1g
	62602,		-- 5g
	62603,		-- 5g
	62604,		-- 5g
	62605,		-- 5g
	
	-- Blood Cards (Used Card of Omens)
	113340,		-- 1c
	113341,		-- 10s
	113342,		-- 50s
	113343,		-- 50s
	113344,		-- 1g
	113345,		-- 1g
	113346,		-- 5g
	113347,		-- 5g
	113348,		-- 10g
	113349,		-- 20g
	113350,		-- 50g
	113351,		-- 100g
	113352,		-- 1000g
	113353,		-- 3000g
	113354,		-- 6000g
}