--[[
	Watto Classic v1.7.4
	Selling Functions
	
	Revision: $Id: Selling.lua 8 2019-09-05 15:28:24 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."Unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end
-- Libraries
local LibKJ = LibStub("LibKjasi-1.0")

local L = w.Localization
if (not L) then
	print(RED_FONT_COLOR_CODE.."Unable to find Watto's Localization data."..FONT_COLOR_CODE_CLOSE)
	return
end
local C = w.Constants
if (not C) then
	print(RED_FONT_COLOR_CODE.."Unable to find Watto's Constants data."..FONT_COLOR_CODE_CLOSE)
	return
end
local P = w.PlayerData

function w:SellMoneyEstimate()
	w:UpdatePlayer()
	w:getSellItems()
	local List = w.List
	local Money = 0

	for _,s in pairs(List) do
		Money = Money + (s.SellValue * s.TotalCount)
	end

	return Money
end

function Watto_SellJunk()
	if (not MerchantFrame:IsVisible()) then
		--Watto_Msg("Merchant Window Not Opened.")
		return
	end
	if (MerchantFrame.selectedTab ~= 1) then
		--Watto_Msg("Not on Main Merchant Tab.")
		return
	end

	local Count = 0
	w:getSellItems()
	local List = w.List
	local Money = w:SellMoneyEstimate()

	if (LibKJ:tcount(List)==0) or (Money == 0) then
		return
	end
	
	for _,i in pairs(List) do
		local iCount = 0
		for _,s in pairs(i.BagSlots) do
			--print("Selling ["..i.Link.."] in Bag ["..s.Bag.."], Slot ["..s.Slot.."]")
			Count = Count + 1
			iCount = iCount + s.Count
			UseContainerItem(s.Bag, s.Slot)
			if (w.options.sellbacklimiter == true) then
				if (Count == w.Constants.MerchantSellSlots) then break end
			end
		end
		if (w.options.sellnotify == true) then
			local F = L.SELL_ITEM
			if (i.TotalCount > 1) then
				F = L.SELL_ITEMS
			end
			Watto_Msg(format(F,i.Link,iCount))
		end
		
		if (w.options.sellbacklimiter == true) then
			if (Count == w.Constants.MerchantSellSlots) then break end
		end
	end
	
	if (Money>0) then
		local F = L.SELL_TOTAL
		if w.options.randomselltext == true then
			local rand = random(1,#L.SELL_RANDOMSAYINGS)
			F = L.SELL_RANDOMSAYINGS[rand]
		end
		Watto_Msg(format(F,"|CFF8DD2E6"..Watto_CSG(Money,w.options.usemoneyicons,12)..""..FONT_COLOR_CODE_CLOSE))
	end
	Watto_TempSell = {}
end

-- Bad Item Check
-- Returns nil if okay, returns true if a bad item is found.
function Watto_CheckforBadItem(itemid)
	if (not itemid) then return true end

	-- Check Sell Price
	local iname, _, _, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemid)
	if itemSellPrice == nil or itemSellPrice == 0 then
		-- Watto_Msg(iname.."'s sell price is "..tostring(itemSellPrice))
		return true
	end
	
	return
end