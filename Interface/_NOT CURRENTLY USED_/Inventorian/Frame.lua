local _, Inventorian = ...
local L = LibStub("AceLocale-3.0"):GetLocale("Inventorian")

local ItemCache = LibStub("LibItemCache-1.1")

local Frame = CreateFrame("Frame")
local Frame_MT = {__index = Frame}

local LibWindow = LibStub("LibWindow-1.1")
local Events = Inventorian:GetModule("Events")

local ITEM_CONTAINER_OFFSET_W = -22
local ITEM_CONTAINER_OFFSET_H = -95

local PLAYER_NAME = string.format("%s - %s", UnitName("player"), GetRealmName())

MoneyTypeInfo["INVENTORIAN"] = {
	UpdateFunc = function(self)
		return ItemCache:GetPlayerMoney(self:GetParent():GetPlayerName())
	end,

	collapse = 1,
	showSmallerCoins = "Backpack"
};

Inventorian.Frame = {}
Inventorian.Frame.defaults = {}
Inventorian.Frame.prototype = Frame
function Inventorian.Frame:Create(name, titleText, settings, config)
	local frame = setmetatable(CreateFrame("Frame", name, UIParent, "InventorianFrameTemplate"), Frame_MT)

	-- settings
	frame.config = config
	frame.settings = settings
	frame.titleText = titleText
	frame.currentConfig = config[1]
	frame.bagButtons = {}

	if frame:IsBank() then
		frame:SetMinResize(275, 325)
		frame.KeyRingButton:Hide()
	else
		frame:SetMinResize(250, 260)
	end

	if frame:IsKeyring() then
		frame:SetMinResize(200, 200)
		frame.KeyRingButton:Hide()

		frame.Money:Hide()
		frame.BagToggle:Hide()
		frame.ArtBottomDivider:Hide()
		frame.ArtBottomLeft:Hide()
		frame.ArtBottomRight:Hide()
		frame.ArtBottomRight2:Hide()
	end

	-- components
	frame.itemContainer = Inventorian.ItemContainer:Create(frame)
	frame.itemContainer:SetPoint("TOPLEFT", 10, -64)
	frame.itemContainer:SetBags(config[1].bags)
	frame.itemContainer:Show()

	-- scripts
	frame:SetScript("OnShow", frame.OnShow)
	frame:SetScript("OnHide", frame.OnHide)
	frame:SetScript("OnEvent", frame.OnEvent)
	frame:SetScript("OnSizeChanged", frame.OnSizeChanged)

	-- non-bag events
	frame:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "player")

	-- load and apply config
	frame:SetWidth(settings.width)
	frame:SetHeight(settings.height)

	LibWindow.RegisterConfig(frame, settings)
	LibWindow.RestorePosition(frame)

	frame:UpdateTitleText()
	frame:UpdateBags()

	tinsert(UISpecialFrames, name)

	return frame
end

function Frame:OnShow()
	PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
	self:SetPortrait()
end

function Frame:OnHide()
	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)

	if self:IsBank() and self:AtBank() then
		CloseBankFrame()
	end

	-- clear search on hide
	self.SearchBox.clearButton:Click()

	-- close any dropdowns
	CloseDropDownMenus()

	-- reset to the default player when hiding
	if self.playerName then
		self:SetPlayer(nil)
	end
end

function Frame:OnBagToggleClick(toggle, button)
	if button == "LeftButton" then
		_G[toggle:GetName() .. "Icon"]:SetTexCoord(0.075, 0.925, 0.075, 0.925)
		self:ToggleBagFrame()
	elseif button == "RightButton" then
		if not self:IsBank() and ItemCache:HasCache() then
			Inventorian.bank:ShowFrame(false)
		end
	end
end

function Frame:OnBagToggleEnter(toggle)
	GameTooltip:SetOwner(toggle, "ANCHOR_LEFT")
	GameTooltip:SetText(L["Bags"], 1, 1, 1)
	GameTooltip:AddLine(L["<Left-Click> to toggle the bag display"])
	if not self:IsBank() and ItemCache:HasCache() then
		GameTooltip:AddLine(L["<Right-Click> to show the bank contents"])
	end
	GameTooltip:Show()
end

function Frame:OnEvent(event, ...)
	if event == "UNIT_PORTRAIT_UPDATE" and self:IsShown() and not self.portrait.classIcon then
		SetPortraitTexture(self.portrait, "player")
	end
end

function Frame:OnSizeChanged(width, height)
	self.settings.width = width
	self.settings.height = height
	LibWindow.SavePosition(self)

	self:UpdateItemContainer()
end

function Frame:SetPortrait()
	if self:IsCached() and self:GetPlayerName() ~= ItemCache.PLAYER then
		local classToken = ItemCache:GetPlayerInfo(self:GetPlayerName())
		self.portrait:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		self.portrait:SetTexCoord(CLASS_ICON_TCOORDS[classToken][1] + 0.01, CLASS_ICON_TCOORDS[classToken][2] - 0.01, CLASS_ICON_TCOORDS[classToken][3] + 0.01, CLASS_ICON_TCOORDS[classToken][4] - 0.01)
		self.portrait.classIcon = true
	else
		SetPortraitTexture(self.portrait, "player")
		self.portrait:SetTexCoord(0, 1, 0, 1)
		self.portrait.classIcon = false
	end
end

function Frame:OnPortraitClick(portrait)
	self:TogglePlayerDropdown(portrait, 15, 10)
end

function Frame:OnPortraitEnter(portrait)
	GameTooltip:SetOwner(portrait, "ANCHOR_RIGHT")
	GameTooltip:SetText(self:GetPlayerName(), 1, 1, 1)
	if ItemCache:HasCache() then
		GameTooltip:AddLine(L["<Left-Click> to switch characters"])
	else
		GameTooltip:AddLine(L["Install BagBrother to get access to the inventory of other characters."])
	end
	GameTooltip:Show()
end

function Frame:OnSearchTextChanged()
	self.itemContainer:Search(self.SearchBox:GetText())
end

function Frame:UpdateTitleText()
	if self:IsCached() then
		self.Title:SetFormattedText(self.titleText .. " (%s)", self:GetPlayerName(), L["Cached"])
	else
		self.Title:SetFormattedText(self.titleText, self:GetPlayerName())
	end
end

function Frame:ToggleBagFrame()
	self.settings.showBags = not self.settings.showBags
	--self:UpdateBagToggleHighlight()
	self:UpdateBags()
end

function Frame:UpdateBags()
	for i, bag in pairs(self.bagButtons) do
		self.bagButtons[i] = nil
		bag:Free()
	end

	if self.settings.showBags then
		for _, bagID in ipairs(self.currentConfig.bags) do
			local bag = Inventorian.Bag:Create()
			bag:Set(self, bagID)
			tinsert(self.bagButtons, bag)
		end

		for i, bag in ipairs(self.bagButtons) do
			bag:ClearAllPoints()
			if i > 1 then
				bag:SetPoint("TOP", self.bagButtons[i-1], "BOTTOM", 0, -2)
			else
				bag:SetPoint("TOPRIGHT", -12, -66)
			end
			bag:Show()
		end
	end
	self:UpdateItemContainer()
end

function Frame:UpdateItemContainer(force)
	local width = self:GetWidth() + ITEM_CONTAINER_OFFSET_W
	local height = self:GetHeight() + ITEM_CONTAINER_OFFSET_H
	if self.settings.showBags then
		width = width - 36
	end

	if width ~= self.itemContainer:GetWidth() or height ~= self.itemContainer:GetHeight() then
		self.itemContainer:SetWidth(width)
		self.itemContainer:SetHeight(height)
		self.itemContainer:Layout()
	end
end

function Frame:Update()
	self:UpdateBags()
	self.itemContainer:UpdateBags()
	self:UpdateTitleText()
	self:SetPortrait()

	-- update the money frame
	if self:IsCached() then
		MoneyFrame_SetType(self.Money, "INVENTORIAN")
	else
		MoneyFrame_SetType(self.Money, "PLAYER")
	end
	MoneyFrame_UpdateMoney(self.Money)

	self.cachedView = self:IsCached()
end

function Frame:UpdateCachedView()
	if self.cachedView ~= self:IsCached() then
		self:Update()
	end
end

function Frame:ToggleFrame(auto)
	if self:IsShown() then
		self:HideFrame(auto)
	else
		self:ShowFrame(auto)
	end
end

function Frame:ShowFrame(auto)
	if self:IsCached() and not ItemCache:HasCache() then
		Inventorian:Print("No Cache available, please enable BagBrother to enable this functionality")
		return
	end

	if not self:IsShown() then
		self:Show()
		self.autoShown = auto or nil
	end
	if not auto then
		self.autoShown = nil
	end

	self:UpdateCachedView()
end

function Frame:HideFrame(auto)
	if self:IsShown() then
		if not auto or self.autoShown then
			self:Hide()
			self.autoShown = nil
		else
			self:UpdateCachedView()
		end
	end
end

do
	local ActiveFrame
	local PlayerDropdown

	local function DeletePlayer(self)
		local playerName = self.value
		if Inventorian.bag:GetPlayerName() == playerName then
			Inventorian.bag:SetPlayer(nil)
		end

		if Inventorian.bank:GetPlayerName() == playerName then
			Inventorian.bank:SetPlayer(nil)
		end

		ItemCache:DeletePlayer(playerName)
		CloseDropDownMenus()
	end

	local function SetPlayer(self)
		ActiveFrame:SetPlayer(self.value)
		CloseDropDownMenus()
	end

	local function PlayerEntry(player)
		local class = ItemCache:GetPlayerInfo(player)
		if not RAID_CLASS_COLORS[class] or not RAID_CLASS_COLORS[class].colorStr then class = nil end

		UIDropDownMenu_AddButton({
			text = class and ("|c%s%s|r"):format(RAID_CLASS_COLORS[class].colorStr, player) or player,
			hasArrow = ItemCache:IsPlayerCached(player),
			checked = (player == ActiveFrame:GetPlayerName()),
			func = SetPlayer,
			value = player,
		})
	end

	local function CreatePlayerDropdown(self, level)
		if level == 2 then
			UIDropDownMenu_AddButton({ text = REMOVE, notCheckable = true, value = UIDROPDOWNMENU_MENU_VALUE, func = DeletePlayer}, 2)
		else
			PlayerEntry(ItemCache.PLAYER)

			for i, player in ItemCache:IteratePlayers() do
				if player ~= ItemCache.PLAYER then
					PlayerEntry(player)
				end
			end
		end
	end

	local function GetPlayerDropdown()
		if not PlayerDropdown then
			PlayerDropdown = CreateFrame("Frame", "InventorianPlayerDropdown", UIParent, "UIDropDownMenuTemplate")
			PlayerDropdown.initialize = CreatePlayerDropdown
			PlayerDropdown.displayMode = "MENU"
			PlayerDropdown:SetID(1)
		end

		return PlayerDropdown
	end

	function Frame:TogglePlayerDropdown(anchor, offsetX, offsetY)
		if ItemCache:HasCache() then
			ActiveFrame = self
			ToggleDropDownMenu(1, nil, GetPlayerDropdown(), anchor, offsetX, offsetY)
		end
	end

end

-----------------------------------------------------------------------
-- Various information getters

function Frame:SetPlayer(player)
	if not player or not ItemCache:IsPlayerCached(player) then
		self.playerName = nil
	else
		self.playerName = player
	end
	self:Update()
end

function Frame:GetPlayerName()
	local name = self.playerName or PLAYER_NAME

	-- only return the realm name if its not the current realm
	local realm, player = ItemCache:GetPlayerAddress(name)
	if realm == GetRealmName() then
		name = player
	end
	return name
end

function Frame:IsCached()
	return ItemCache:IsPlayerCached(self:GetPlayerName()) or (self:IsBank() and not self:AtBank())
end

function Frame:IsBank()
	return self.currentConfig.isBank
end

function Frame:IsKeyring()
	return self.currentConfig.isKeyring
end

function Frame:AtBank()
	return Events.atBank
end
