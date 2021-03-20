--[[
	Watto Classic v1.7.4
	Buying Functions
	
	Revision: $Id: Buying.lua 11 2019-09-05 15:20:03 Pacific Time Kjasi $
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

StaticPopupDialogs["WATTO_CONFIRMPURCHASETOKENITEM"] = {
	text = CONFIRM_PURCHASE_TOKEN_ITEM,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		w:Purchase(Watto_Buy_Count:GetNumber())
		return
	end,
	OnCancel = function()
		return
	end,
	OnShow = function()
	end,
	OnHide = function()
	end,
	timeout = 0,
	hideOnEscape = 1,
	hasItemFrame = 1,
}


function Watto_Buy_OnModClick(frame,button,...)
	if (HandleModifiedItemClick(GetMerchantItemLink(frame:GetID()))) then
		return
	end
	if (MerchantFrame.selectedTab == 1) then
		Watto_Buy_CurrentButton = frame
		Watto_Buy_CurrentItem = frame:GetID()
		w:UpdateCurrentItem(frame:GetID())
		local ItemName = GetMerchantItemInfo(Watto_Buy_CurrentItem)
		local _, _, _, quantity = GetMerchantItemInfo(Watto_Buy_CurrentItem)

		-- Set Text
		Watto_Buy_Title:SetText(L.PURCHASE_TITLE)
		Watto_Buy_FrameButton_1:SetText(L.INTERFACE_BUY_STACK)
		Watto_Buy_FrameButton_2:SetText(L.INTERFACE_BUY_CANAFFORD)
		Watto_Buy_FrameButton_3:SetText(L.INTERFACE_BUY_FILLSTACKS)
		Watto_Buy_FrameButton_4:SetText(L.INTERFACE_BUY_FILLBAGS)
		Watto_Buy_ItemName:SetText(ItemName)

		Watto_Buy_FrameButton_Purchase:SetText(L.INTERFACE_BUY_PURCHASE)

		Watto_Buy_Cost_Title:SetText(L.INTERFACE_BUY_COST)
		Watto_Buy_Count:SetText(quantity)
		Watto_Buy_OnChange()
		Watto_Buy_FirstCall = true

		Watto_Buy_Frame:ClearAllPoints()
		Watto_Buy_Frame:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", -2, 5)
		Watto_Buy_Frame:Show()
		Watto_Buy_Count:SetFocus()
	else
		Orig_MerchantItemButton_OnModifiedClick(frame,button,...)
	end
end

function Watto_Buy_ButtonOnClick(self)
	local name = self:GetName()
	-- Watto_Msg(name.." was pressed.")

	if name == "Watto_Buy_FrameButton_Purchase" then
		Watto_Buy_PrePurchase()
	elseif name == "Watto_Buy_FrameButton_1" then
		Watto_Buy_Button_AddStack()
	elseif name == "Watto_Buy_FrameButton_2" then
		Watto_Buy_Button_CanAfford()
	elseif name == "Watto_Buy_FrameButton_3" then
		Watto_Buy_Button_FillStacks()
	elseif name == "Watto_Buy_FrameButton_4" then
		Watto_Buy_Button_FillBags()
	end
end

function Watto_Buy_Button_AddStack()
	local ci = w.CurrentItem
	local CurrentNumber = Watto_Buy_Count:GetNumber()
	local NewNumber = CurrentNumber + ci.MaxStack
	
	if (CurrentNumber == ci.PurchaseStack) and (ci.MaxStack > ci.PurchaseStack) then
		NewNumber = ci.MaxStack
	end

	Watto_Buy_FirstCall = false
	Watto_Buy_Count:SetText(w:GetNumAvailable(NewNumber))
	Watto_Buy_OnChange()
end

function w:GetNumItem(Link)
	if #P.Bags < 0 then w:UpdatePlayer() end
	local id = LibKJ:getIDNumber(Link)
	local count = GetItemCount(Link)
	for slot,data in pairs(P.ReagentBank.Slots) do
		if data.ItemID == id then
			count = count + data.Count
		end
	end
	return count
end

function Watto_Buy_Button_CanAfford()
	local ci = w.CurrentItem
	if #P.Bags < 0 then w:UpdatePlayer() end
	
	local NumAfford = -1
	
	if (ci.CostMoney > 0) then
		local costEach = LibKJ:Floor(ci.CostMoney/ci.PurchaseStack,0)
		NumAfford = LibKJ:Floor(P.Money/costEach,0)
	elseif (#ci.CostCurrency > 0) then
		for _,curr in pairs(ci.CostCurrency) do
			local MyAmount = 0
			if curr.IsCurrency == true then
				MyAmount = P.Currency[tostring(curr.ItemID)].Value
			else
				MyAmount = w:GetNumItem(curr.Link)
			end
			local finalNum = math.floor(MyAmount/curr.Cost)
			if (NumAfford == -1) then
				NumAfford = finalNum
			else
				NumAfford = min(finalNum, NumAfford)
			end
		end
	end
	
	if NumAfford == -1 then NumAfford = 0 end
	
	Watto_Buy_FirstCall = false
	Watto_Buy_Count:SetNumber(w:GetNumAvailable(NumAfford))
	Watto_Buy_OnChange()
end

function Watto_Buy_Button_FillStacks()
	local ci = w.CurrentItem
	if #P.Bags < 0 then w:UpdatePlayer() end
	
	local FillCount = w:GetNumFillStacks()

	if FillCount == 0 then
		FillCount = ci.MaxStack
	end

	Watto_Buy_FirstCall = false
	Watto_Buy_Count:SetNumber(w:GetNumAvailable(FillCount))
	Watto_Buy_OnChange()
end

function Watto_Buy_Button_FillBags()
	if #P.Bags < 0 then w:UpdatePlayer() end
	
	local FreeSlots = w:GetNumFillSlots()
	local FillCount = w:GetNumFillStacks()

	Watto_Buy_FirstCall = false
	Watto_Buy_Count:SetNumber(w:GetNumAvailable(FreeSlots+FillCount))
	Watto_Buy_OnChange()
end

function Watto_Buy_PrePurchase()
	local ci = w.CurrentItem
	local CurrentNumber = Watto_Buy_Count:GetNumber()
	local MaxItems = w:GetNumFillSlots() + w:GetNumFillStacks()
	local NumAvailable = ci.Available
	
	if (CurrentNumber>MaxItems) or ((NumAvailable>-1) and (CurrentNumber>NumAvailable)) then
		Watto_Msg(L.ERROR_BUY_TOOMANY,"error")
		return
	end
	
	if (ci.CostMoney > 0) then
		local MoneyCost = LibKJ:Floor(ci.CostMoney/ci.PurchaseStack,0)*CurrentNumber
		if (MoneyCost > P.Money) then
			Watto_Msg(L.ERROR_BUY_TOOEXPENSIVE,"error")
			return
		end
	end
	--[[
	if (LibKJ:tcount(ci.CostCurrency)>0) then
		for _,c in pairs(ci.CostCurrency) do
			local CostItem = LibKJ:Floor(c.Cost/ci.PurchaseStack,0) * CurrentNumber
			if (c.IsCurrency == true) then
				if (CostItem > P.Currency[c.ItemID].Value) then
					Watto_Msg(L.ERROR_BUY_TOOEXPENSIVE,"error")
					return
				end
			else
				if (CostItem > w:GetNumItem(c.Link)) then
					Watto_Msg(L.ERROR_BUY_TOOEXPENSIVE,"error")
					return
				end
			end
		end
		w:ConfirmPurchase(CurrentNumber)
	else
	]]
	w:Purchase(CurrentNumber)
	--end
end

function w:Purchase(Count)
	local ci = w.CurrentItem
	local Purchased = 0

	while (Purchased < Count) do
		local Amount = ci.MaxStack
		local Left = Count - Purchased
		if (Left < ci.MaxStack) then Amount = Left end
		BuyMerchantItem(ci.Slot,Amount)
		Purchased = Purchased + Amount
	end
	Watto_Merchant_OnHide()
end

function w:ConfirmPurchase(Count)
	local ci = w.CurrentItem
	local CostString
	local r,g,b = GetItemQualityColor(ci.Quality)

	for _,Currency in pairs(ci.CostCurrency) do
		local String = " |T"..Currency.Image..":0:0:0:-1|t "..format(ITEM_QUANTITY_TEMPLATE, (LibKJ:Floor(Currency.Cost/ci.PurchaseStack,0) or 0) * Count, (Currency.Link or Currency.Name))
		if (CostString) then
			CostString = CostString..LIST_DELIMITER..String
		else
			CostString = String
		end
	end
	StaticPopup_Show("WATTO_CONFIRMPURCHASETOKENITEM", CostString, "", {["texture"] = ci.Image, ["name"] = ci.Name, ["color"] = {r, g, b, 1}, ["link"] = ci.Link, ["index"] = ci.Slot, ["count"] = Count})
end

function Watto_Buy_OnChange()
	local ci = w.CurrentItem
	local FontCost = HIGHLIGHT_FONT_COLOR_CODE
	local FontCount = Watto_Count_Font
	
	local CurrentNumber = Watto_Buy_Count:GetNumber()
	local MaxItems = w:GetNumFillSlots() + w:GetNumFillStacks()
	local NumAvailable = ci.Available
	local FinalCost = ""
	
	-- Check Count Number issues
	if (CurrentNumber>MaxItems) or ((NumAvailable>-1) and (CurrentNumber>NumAvailable)) then
		FontCount = Watto_Count_Font_Red
	end
	Watto_Buy_Count:SetFontObject(FontCount)

	-- Check for Price Issues
	-- Gold
	if (ci.CostMoney > 0) then
		local CostMoney = LibKJ:Floor(ci.CostMoney/ci.PurchaseStack,0) * CurrentNumber
		if (CostMoney > P.Money) then
			FontCost = RED_FONT_COLOR_CODE
		end
		FinalCost = FinalCost..Watto_CSG(CostMoney,true)
	end
	--[[
	-- Items and Currency
	if (LibKJ:tcount(ci.CostCurrency)>0) then
		for _,c in pairs(ci.CostCurrency) do
			local CostItem = LibKJ:Floor(c.Cost/ci.PurchaseStack,0) * CurrentNumber
			if (c.IsCurrency == true) then
				if (CostItem > P.Currency[tostring(c.ItemID)].Value) then
					FontCost = RED_FONT_COLOR_CODE
				end
			else
				if (CostItem > w:GetNumItem(c.Link)) then
					FontCost = RED_FONT_COLOR_CODE
				end
			end
			FinalCost = FinalCost..CostItem.."\124T"..c.Image..":18:18:0:-1\124t"
		end
	end
	]]
	
	FinalCost = FontCost..FinalCost..FONT_COLOR_CODE_CLOSE
	Watto_Buy_Cost_Money:SetText(FinalCost)
end