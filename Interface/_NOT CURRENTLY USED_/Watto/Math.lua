--[[
	Watto's Classic Math file
	v1.7.4
	
	Revision: $Id: Math.lua 15 2019-09-05 15:23:59 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."Unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end
-- Libraries
local LibKJ = LibStub("LibKjasi-1.0")

local P = w.PlayerData

-- Get the number needed to fill every existing stack in our inventory.
function w:GetNumFillStacks()
	local ci = w.CurrentItem
	local HaveCount = 0

	-- Proccess our bags
	for _,b in pairs(P.Bags) do
		for Slot in pairs(b.Slots) do
			local bs = b.Slots[Slot]
			if (bs.ItemID ~= nil) then
				if (bs.ItemID == ci.ItemID) then
					HaveCount = HaveCount + bs.Count
				end
			end
		end
	end

	local FillCount = ci.MaxStack-HaveCount
	return FillCount
end

-- Return the number needed to fill every empty slot.
function w:GetNumFillSlots()
	local ci = w.CurrentItem
	local FreeSlots = 0

	-- Fill any free slots
	for _,b in pairs(P.Bags) do
		if (b.Type) and (b.Type ~= nil) then
			if (b.Type > 0) and (b.Type == ci.Type) then
				FreeSlots = FreeSlots + b.FreeSlots
			end
			if (b.Type == 0) then
				FreeSlots = FreeSlots + b.FreeSlots
			end
		end
	end
	return FreeSlots*ci.MaxStack
end

-- Modify the value in case there isn't enough items available
function w:GetNumAvailable(Check)
	local ci = w.CurrentItem
	if (ci.Available > 0) and (ci.Available < Check) then
		Check = ci.Available
	end
	return Check
end