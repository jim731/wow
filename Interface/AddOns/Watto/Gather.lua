--[[
	Watto v1.7.4
	Gather Functions
	
	Revision: $Id: Gather.lua 17 2019-09-05 15:33:30 Pacific Time Kjasi $
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

-- Libraries
local LibKJ = LibStub("LibKjasi-1.0")

local P = w.PlayerData
local L = w.Localization

function w:UpdateCurrentItem(MerchIndex)
	w.CurrentItem = {}
	local ci = w.CurrentItem
	local n,t,p,q,na,_,ec = GetMerchantItemInfo(MerchIndex)
	local _,li,qu,_,_,_,_,ms,_,_,_,_,_,_,bindtype,_,_,_ = GetItemInfo(GetMerchantItemLink(MerchIndex))
	--local mcid = {GetMerchantCurrencies()}
	
	ci.Slot = MerchIndex
	ci.Name = n
	ci.Image = t
	ci.CostMoney = p
	ci.Link = li
	ci.ItemID,_ = LibKJ:getIDNumber(ci.Link)
	ci.Type = GetItemFamily(ci.Link)
	ci.Quality = qu
	ci.PurchaseStack = q
	ci.MaxStack = ms
	ci.Available = na
	ci.BindType = bindtype

	--[[
	-- Extended Costs
	if (ec == true) then
		local cc = GetMerchantItemCostInfo(ci.Slot)
		local cic = ci.CostCurrency
		for i=1,cc do
			local ct, cv, cl, cn = GetMerchantItemCostItem(ci.Slot,i)
			cic[i] = {}
			cic[i].Name = cn
			cic[i].Link = cl
			cic[i].ItemID = 0
			if (cl ~= nil) then cic[i].ItemID,_ = LibKJ:getIDNumber(cl) 
			else
				for _,CurrencyID in pairs(mcid) do
					local cidname = GetCurrencyInfo(CurrencyID)
					if cn == cidname then
						cic[i].ItemID = tostring(CurrencyID)
						break
					end
				end
			end
			cic[i].Cost = cv
			cic[i].Image = ct
			cic[i].IsCurrency = false
			local linkString = gsub(cl,".-\124H([^\124]*)\124h.-\124h\124r", "%1")
			local linktype, linkID = strsplit(":",linkString)
			if (linktype == "currency") then cic[i].IsCurrency = true end
		end
	end
	]]
end

function w:ScanBags()
	local b = P.Bags
	b = {}

	-- Scan current bags
	for Bag=0,NUM_BAG_SLOTS do
		if not b[Bag] then b[Bag] = {} end
		local tb = b[Bag]
		tb.SlotID = Bag

		tb.NumSlots = GetContainerNumSlots(Bag)
		local slots, type = GetContainerNumFreeSlots(Bag)
		tb.FreeSlots = slots
		tb.Type = type
		tb.Slots = {}

		for Slot=0,tb.NumSlots do
			if not tb.Slots[Slot] then tb.Slots[Slot] = {} end
			local bs = tb.Slots[Slot]
			bs.SlotID = Slot
			local ilink = GetContainerItemLink(Bag,Slot)
			if (ilink ~= nil) then
				bs.Link = ilink
				bs.ItemID,_ = LibKJ:getIDNumber(bs.Link)
				local _, icount = GetContainerItemInfo(Bag,Slot)
				bs.Count = icount
			end
		end
	end
	P.Bags = b
end

function w:UpdatePlayer()
	P.Money = GetMoney()
	P.Level = UnitLevel("Player")
	w:ScanBags()
end

local function BooleanFlip(bool)
	if (bool == false) then
		return true
	end
	return false
end

function w:getSellItems()
	if (w.ListUpdated == true) then return end
	if not w.options then return end
	
	local SellList = {}
	local GenList = Watto_ItemList["General"]
	local PlayList = Watto_ItemList["PerChar"][P.Realm][P.Name]
	
	for Bag,b in pairs(P.Bags) do
		for Slot in pairs(b.Slots) do
			local bs = b.Slots[Slot]
			if (bs.Link ~= nil) then
				local n,_,q,iL,_,ty,st,_,_,t,vp = GetItemInfo(bs.Link)
				local iID = bs.ItemID
				local sell = false
				local reason
				
				-- Quality-Based Selection
				if (q == 0) then
					-- Grey Items
					sell = true
					reason = "quality"
				end
				
				-- Food and Drink
				if (w.options and w.options.autosellfood == true) then
					if (ty == L.ITEMTYPE_CONSUMABLE) and (sc == L.ITEMSUBTYPE_FOODANDDRINK) then
						local Limiter = 4
						if P.Level < 80  then Limiter = 0 end
						if (iL+Limiter<P.Level) then
							sell = true
							reason = "food"
						end
					end
				end

				-- TempList
				if (LibKJ:tcount(Watto_TempSell)>0) then
					if (Watto_TempSell[iID])then
						sell = true
						reason = "temp"
					end
				end
				
				-- Auto-Sell Items
				for i=1,#w.Constants.AutoSell do
					if (iID == w.Constants.AutoSell[i]) then
						sell = true
						reason = "auto"
					end
				end
				
				-- Not Auto-Sell items
				for i=1,#w.Constants.NoAutoSell do
					if (iID == w.Constants.NoAutoSell[i]) then
						sell = false
						reason = nil
					end
				end
				
				-- Soulbound Junk
				if (w.options.selljunksoulbound == true) then
					if (IsEquippableItem(bs.ItemID)) then
						Watto_Tooltip_Scanner:ClearLines()
						Watto_Tooltip_Scanner:SetBagItem(Bag,Slot)
						
						if (Watto_TooltipFind(Watto_Tooltip_Scanner,ITEM_SOULBOUND)) then
							local isGood = nil
							
							-- Class Specific items that don't match our class
							local scan = gsub(ITEM_CLASSES_ALLOWED,"%%s","(.+)")
							if (Watto_TooltipFind(Watto_Tooltip_Scanner,scan)) then
								local _,classes = Watto_TooltipFind(Watto_Tooltip_Scanner,scan)
								--print("Looking for "..P.Class.." in "..tostring(classes[1]))
								if (strfind(classes[1],P.Class)) then
									--print("Match Found!")
									isGood = true
								end
								if (not isGood) then
									--print("Selling Item")
									sell = true
									reason = "soulbound junk"
								end
							end
							
							-- Bad Armor
							isGood = nil
							if (C.ClassGear[P.G_Class]) then 
								for _,v in pairs(C.ClassGear[P.G_Class]["armor"]) do
									scan = v
									if (Watto_TooltipFind(Watto_Tooltip_Scanner,scan)) then
										isGood = true
									end
								end
								if (isGood) then
									--print("Selling Item")
									sell = true
									reason = "soulbound junk"
								end
								-- Bad Weapons
								isGood = nil
								for _,v in pairs(C.ClassGear[P.G_Class]["weapons"]) do
									scan = gsub(v, "-", "")
									test = gsub(L["Gear Two-Hand"], "-", "")
									isFound = strfind(scan, test)
									
									if isFound ~= nil then
										ga = nil
										gb = nil
										gear = gsub(gsub(scan, L["Gear Two-Hand"], '')," +", " ")
										gear = strtrim(gear)
										if (Watto_TooltipFind(Watto_Tooltip_Scanner,L["Gear Two-Hand"])) then
											ga = true
										end
										if (Watto_TooltipFind(Watto_Tooltip_Scanner,gear)) then
											gb = true
										end
										if ga == true and gb == true then
											isGood = true
										end
									elseif (Watto_TooltipFind(Watto_Tooltip_Scanner,scan)) then
										isGood = true
									end
								end
								if (isGood) then
									--print("Selling Item")
									sell = true
									reason = "soulbound junk"
								end
							end
						end
					end
				end
				
				-- General Exclusion List
				if (GenList[iID]) then
					sell = BooleanFlip(sell)
				end
				-- Personal Exclusion List
				if (PlayList[iID]) then
					sell = BooleanFlip(sell)
				end

				if (sell == true) and (not reason) then
					reason = "exclusion"
				end
				
				if (sell == true) and (n ~= nil) then
					if (not SellList[n]) then
						SellList[n] = {}
						SellList[n].Name = n
						SellList[n].Reason = reason
						SellList[n].BagSlots = {}
						SellList[n].ID = bs.ItemID
						SellList[n].Link = bs.Link
						SellList[n].SellValue = vp
						SellList[n].Count = 0
						SellList[n].TotalCount = 0
					end
					local s = SellList[n]
					if (not s.BagSlots[Bag..Slot]) then s.BagSlots[Bag..Slot] = {} end
					s.BagSlots[Bag..Slot].Bag = Bag
					s.BagSlots[Bag..Slot].Slot = Slot
					s.BagSlots[Bag..Slot].Count = bs.Count
					s.Count = s.Count + 1
					s.TotalCount = s.TotalCount + bs.Count
				end
			end
		end
	end
	
	w.List = SellList
	w.ListUpdated = true
end