--[[
	Watto Classic v1.7.4
	Primary Localization
	
	This file contains localiation data that is critical to Watto's functions. Decorative localizations that do not impact function, can be found in the Localization directory.
	
	Revision: $Id: Localiation.lua 17 2019-09-06 09:27:06 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."Unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end

w.Localization = {}
local L = w.Localization
local Locale = GetLocale()

-- Watto Names & Titles
L.WATTO_TITLE = "Watto"
L.PURCHASE_TITLE = "Watto's Bulk Supplies"
L.JUNKYARD_TITLE = "Watto's Junkyard"

-- Item Types & Subtypes
L.ITEMTYPE_CONSUMABLE = "Consumable"
L.ITEMSUBTYPE_FOODANDDRINK = "Food & Drink"

-- Gear
L["Gear Axe"] = "Axe"
L["Gear Bow"] = "Bow"
L["Gear Crossbow"] = "Crossbow"
L["Gear Dagger"] = "Dagger"
L["Gear Fist Weapon"] = "Fist Weapon"
L["Gear Gun"] = "Gun"
L["Gear Leather"] = "Leather"
L["Gear Mace"] = "Mace"
L["Gear Mail"] = "Mail"
L["Gear Plate"] = "Plate"
L["Gear Polearm"] = "Polearm"
L["Gear Shield"] = "Shield"
L["Gear Staff"] = "Staff"
L["Gear Sword"] = "Sword"
L["Gear Thrown"] = "Thrown"
L["Gear Two-Hand"] = "Two-Hand"
L["Gear Two-Hand Axe"] = "Two-Hand Axe"
L["Gear Two-Hand Mace"] = "Two-Hand Mace"
L["Gear Two-Hand Sword"] = "Two-Hand Sword"
L["Gear Wand"] = "Wand"

-- Titles translated by Google.
-- Please help me fix them if they're wrong.
if (Locale == "deDE") then
	-- German
	L.PURCHASE_TITLE = "Wattos Ware in großen Mengen"
	L.JUNKYARD_TITLE = "Wattos Junkyard"
	L.ITEMTYPE_CONSUMABLE = "Verbrauchbar"
	L.ITEMSUBTYPE_FOODANDDRINK = "Essen & Trinken"
elseif (Locale == "frFR") then
	-- French
	L.PURCHASE_TITLE = "Fournitures en vrac Watto de"
	L.JUNKYARD_TITLE = "Watto de Junkyard"
	L.ITEMTYPE_CONSUMABLE = "Consommables"
	L.ITEMSUBTYPE_FOODANDDRINK = "Nourriture et boissons"
elseif (Locale == "esES") or (Locale == "esMX") then
	-- Spanish & Latin-America Spanish
	L.PURCHASE_TITLE = "Grandes cantidades de Watto"
	L.JUNKYARD_TITLE = "Junkyard de Watto"
	L.ITEMTYPE_CONSUMABLE = "Consumible"
	L.ITEMSUBTYPE_FOODANDDRINK = "Comida y bebida"
elseif (Locale == "ptBR") then
	-- Brazillian Portuguese
	L.PURCHASE_TITLE = "Watto's Alto Volume Suprimentos"		-- "Watto's High Volume Supplies", Translates back to "Watto's Bulk Supplies"
	L.JUNKYARD_TITLE = "Junkyard do Watto"
	L.ITEMTYPE_CONSUMABLE = "Consumível"
	L.ITEMSUBTYPE_FOODANDDRINK = "Comida e Bebida"
elseif (Locale == "ruRU") then
	-- Russian
	L.WATTO_TITLE = "Уотто"
	L.PURCHASE_TITLE = "Уотто в массовых Поставки"
	L.JUNKYARD_TITLE = "Уотто на свалке"
	L.ITEMTYPE_CONSUMABLE = "Расходуемые"
	L.ITEMSUBTYPE_FOODANDDRINK = "Еда и напитки"
elseif (Locale == "koKR") then
	-- Korean
	L.PURCHASE_TITLE = "Watto의 대량 공급"
	L.JUNKYARD_TITLE = "Watto의 폐차장"
	L.ITEMTYPE_CONSUMABLE = "소비용품"
	L.ITEMSUBTYPE_FOODANDDRINK = "음식과 음료"
elseif (Locale == "zhCN") then
	-- Simplified Chinese
	L.PURCHASE_TITLE = "watto的散装供应"
	L.JUNKYARD_TITLE = "watto的废品旧货栈"
	L.ITEMTYPE_CONSUMABLE = "消耗品"
	L.ITEMSUBTYPE_FOODANDDRINK = "食物和饮料"
elseif (Locale == "zhTW") then
	-- Traditional Chinese
	L.PURCHASE_TITLE = "watto的廢品舊貨棧"
	L.JUNKYARD_TITLE = "watto的廢品舊貨棧"
	L.ITEMTYPE_CONSUMABLE = "消耗品"
	L.ITEMSUBTYPE_FOODANDDRINK = "食物和飲料"
elseif (Locale == "itIT") then
	-- Italian
	L.PURCHASE_TITLE = "Watto forniture in grandi volumi"		-- "Watto's High Volume Supplies", Translates back to "Watto supplies in large volumes"
	L.JUNKYARD_TITLE = "Junkyard di Watto"
elseif (Locale == "jaJP") then
	-- Japanese
	L.WATTO_TITLE = "ワトー"
	L.PURCHASE_TITLE = "ワトーのバルク供給に"
	L.JUNKYARD_TITLE = "ワトーのジャンクヤード"	
end