--[[
	Watto v1.7.4
	Buying Functions
	
	Revision: $Id: Interface.lua 12 2019-09-17 18:29:19 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."Interface is unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end
local L = w.Localization
if (not L) then
	print(RED_FONT_COLOR_CODE.."Interface is unable to find Watto's Localization data."..FONT_COLOR_CODE_CLOSE)
	return
end
local P = w.PlayerData
if (not P) then
	print(RED_FONT_COLOR_CODE.."Interface is unable to find Watto's Player data."..FONT_COLOR_CODE_CLOSE)
	return
end

-- Libraries
local LibKJ = LibStub("LibKjasi-1.0")

function Watto_Buy_OnChar(newnum)
	local num = tonumber(newnum)
	local type = type(num)
	if (Watto_Buy_FirstCall == true) and (type == "number") and (num > 0) then
		Watto_Buy_Count:SetNumber(tonumber(newnum))
		Watto_Buy_OnChange()
		Watto_Buy_FirstCall = false
	end
end

function Watto_Merchant_ChangeTab()
	if (MerchantFrame.selectedTab == 1) then
		Watto_SellJunkButton:Show()
	else
		Watto_SellJunkButton:Hide()
	end
end

function Watto_Merchant_OnShow()
	if (MerchantFrame.selectedTab == 1) then
		if (w.options.autosell) and (w.options.autosell == "on") then
			Watto_SellJunk()
		end
	end
end

function Watto_Merchant_OnHide()
	Watto_Buy_Frame:Hide()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
end

function Watto_Buy_Frame_OnShow()
	Watto_Buy_Count:HighlightText()
end

function Watto_Tooltip_Sell(frame)
	local Money = w:SellMoneyEstimate()
	local List = w.List
	local Count = 0

	for _,i in pairs(List) do
		Count = Count + i.Count
	end

	WattoTooltip:SetOwner(frame, "ANCHOR_CURSOR")
	WattoTooltip:SetText(L.JUNKYARD_TITLE)
	WattoTooltip:AddLine(format(L.TOOLTIP_SELLPROFIT,Watto_CSG(Money,w.options.usemoneyicons,12)),1,1,1)
	WattoTooltip:AddLine(format(L.TOOLTIP_SELLITEMNUM,Count),1,1,1)
	WattoTooltip:Show()
end

-- Create Tooltip
function Watto_CreateTooltip(frame, title, text, anchor)
	if anchor == nil then
		anchor = "ANCHOR_CURSOR"
	end
	if title == nil then
		title = "nil"
	end
	if text == nil then
		text = "nil"
	end
	
	WattoTooltip:SetOwner(frame, anchor)
	WattoTooltip:SetText(title)
	WattoTooltip:AddLine(text,1,1,1,true)
	WattoTooltip:Show()
end

-- Tooltip Extension
function Watto_TooltipSellNotice(self)
	if (w.options.showtooltipdata ~= true) then return end
	w:getSellItems()
	local List = w.List
	local Add, Reason
	local Name, Link = self:GetItem()
	if (not Link) then
		return
	end
	local ItemID = LibKJ:getIDNumber(Link)
	if (LibKJ:tcount(List)==0) then
		return
	end
	for _,i in pairs(List) do
		if (i.Name == Name) then
			Add = true
			Reason = i.Reason
			break
		end
	end
	
	if (Add) then
		local T = L.TOOLTIP_LIST_WILLSELL
		if (Reason) then
			if (Reason == "auto") then T = L.TOOLTIP_LIST_AUTOSELL end
			if (Reason == "food") then T = L.TOOLTIP_LIST_SELLFOOD end
			if (Reason == "exclusion") then T = L.TOOLTIP_LIST_SELLEXCLUSION end
			if (Reason == "soulbound junk") then T = L.TOOLTIP_LIST_SOULBOUNDJUNK end
		end
		self:AddLine(T,1,1,1)
	elseif (tContains(w.Constants.NoAutoSell,ItemID)) then
		self:AddLine(L.TOOLTIP_LIST_NOAUTOSELL,1,1,1)
	end
	
	if (Watto_ItemList["General"][ItemID]) or (Watto_ItemList["PerChar"][P.Realm][P.Name][ItemID]) then
		self:AddLine(L.TOOLTIP_LIST_TITLE,96/255,149/255,246/255)
		if (Watto_ItemList["General"][ItemID]) then
			self:AddLine(L.TOOLTIP_LIST_INGENERAL,1,1,1)
		end
		if (Watto_ItemList["PerChar"][P.Realm][P.Name][ItemID]) then
			self:AddLine(L.TOOLTIP_LIST_INPRIVATE,1,1,1)
		end
	end
end

--Interface Options
function Watto_InterfaceOptions_onLoad()
	-- Register the Interface Options page
	Watto_InterfaceOptions.name = L.WATTO_TITLE
	InterfaceOptions_AddCategory(Watto_InterfaceOptions)

	-- Localizations
	Watto_InterfaceOptions_Title:SetText(L.WATTO_TITLE)
	Watto_InterfaceOptions_Version:SetText(format(L.INTERFACE_VERSION, w.Version))
	Watto_InterfaceOptions_CheckBox_RandomTextTitle:SetText(L.INTERFACE_RANDOMSAYINGS)
	Watto_InterfaceOptions_CheckBox_SellNoticeTitle:SetText(L.INTERFACE_SELLNOTICE)
	Watto_InterfaceOptions_CheckBox_AutoSellFoodTitle:SetText(L.INTERFACE_AUTOSELLFOOD)
	Watto_InterfaceOptions_CheckBox_ShowTooltipDataTitle:SetText(L.INTERFACE_SHOWDATAINTOOLTIPS)
	Watto_InterfaceOptions_CheckBox_SellBackLimiterTitle:SetText(L.INTERFACE_SELLBACKLIMITER)
	Watto_InterfaceOptions_CheckBox_UseMoneyIconsTitle:SetText(L.INTERFACE_USEMONEYICONS)
	Watto_InterfaceOptions_CheckBox_SellJunkSoulboundTitle:SetText(L.INTERFACE_SELLJUNKSOULBOUND)
end

function Watto_InterfaceOptions_onShow()
	-- Set Checkboxes
	Watto_InterfaceOptions_CheckBox_RandomTextCheckBox:SetChecked(w.options.randomselltext)
	Watto_InterfaceOptions_CheckBox_SellNoticeCheckBox:SetChecked(w.options.sellnotify)
	Watto_InterfaceOptions_CheckBox_AutoSellFoodCheckBox:SetChecked(w.options.autosellfood)
	Watto_InterfaceOptions_CheckBox_ShowTooltipDataCheckBox:SetChecked(w.options.showtooltipdata)
	Watto_InterfaceOptions_CheckBox_SellBackLimiterCheckBox:SetChecked(w.options.sellbacklimiter)
	Watto_InterfaceOptions_CheckBox_UseMoneyIconsCheckBox:SetChecked(w.options.usemoneyicons)
	Watto_InterfaceOptions_CheckBox_SellJunkSoulboundCheckBox:SetChecked(w.options.selljunksoulbound)
end

function Watto_InterfaceOptions_CheckBox(self)
	if (not self) then return end

	local Name = self:GetParent():GetName()
	local isChecked = self:GetChecked()
	if (isChecked == nil) then
		isChecked = false
	end
	
	if (Name == "Watto_InterfaceOptions_CheckBox_RandomText") then
		w.options.randomselltext = isChecked
	end
	if (Name == "Watto_InterfaceOptions_CheckBox_SellNotice") then
		w.options.sellnotify = isChecked
	end
	if (Name == "Watto_InterfaceOptions_CheckBox_AutoSellFood") then
		w.options.autosellfood = isChecked
	end
	if (Name == "Watto_InterfaceOptions_CheckBox_ShowTooltipData") then
		w.options.showtooltipdata = isChecked
	end
	if (Name == "Watto_InterfaceOptions_CheckBox_SellBackLimiter") then
		w.options.sellbacklimiter = isChecked
	end
	if (Name == "Watto_InterfaceOptions_CheckBox_UseMoneyIcons") then
		w.options.usemoneyicons = isChecked
	end
	if (Name == "Watto_InterfaceOptions_CheckBox_SellJunkSoulbound") then
		w.options.selljunksoulbound = isChecked
		w.ListUpdated = false
	end
end