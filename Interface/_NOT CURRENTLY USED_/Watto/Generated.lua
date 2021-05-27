--[[
	Watto
	Version 1.7.4
	
	Revision: $Id: Generated.lua 4 2019-09-05 15:21:54 Pacific Time Kjasi $
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

-- These are the items the class CAN'T use!
C.ClassGear = {
	["SHAMAN"] = {
		["armor"] = {
			L["Gear Plate"],
		},
		["weapons"] = {
			L["Gear Bow"],
			L["Gear Crossbow"],
			L["Gear Gun"],
			L["Gear Polearm"],
			L["Gear Sword"],
			L["Gear Thrown"],
			L["Gear Wand"]
		},
	},
	["HUNTER"] = {
		["armor"] = {
			L["Gear Plate"],
			L["Gear Shield"],
		},
		["weapons"] = {
			L["Gear Mace"],
			L["Gear Thrown"],
			L["Gear Wand"]
		},
	},
	["WARRIOR"] = {
		["armor"] = {
		},
		["weapons"] = {
			L["Gear Wand"]
		},
	},
	["PALADIN"] = {
		["armor"] = {
		},
		["weapons"] = {
			L["Gear Bow"],
			L["Gear Crossbow"],
			L["Gear Dagger"],
			L["Gear Fist Weapon"],
			L["Gear Gun"],
			L["Gear Staff"],
			L["Gear Thrown"],
			L["Gear Wand"]
		},
	},
	["DRUID"] = {
		["armor"] = {
			L["Gear Mail"],
			L["Gear Plate"],
			L["Gear Shield"],
		},
		["weapons"] = {
			L["Gear Axe"],
			L["Gear Bow"],
			L["Gear Crossbow"],
			L["Gear Gun"],
			L["Gear Sword"],
			L["Gear Thrown"],
			L["Gear Wand"]
		},
	},
	["ROGUE"] = {
		["armor"] = {
			L["Gear Mail"],
			L["Gear Plate"],
			L["Gear Shield"],
		},
		["weapons"] = {
			L["Gear Polearm"],
			L["Gear Staff"],
			L["Gear Two-Hand Axe"],
			L["Gear Two-Hand Mace"],
			L["Gear Two-Hand Sword"],
			L["Gear Wand"]
		},
	},
	["MAGE"] = {
		["armor"] = {
			L["Gear Leather"],
			L["Gear Mail"],
			L["Gear Plate"],
			L["Gear Shield"],
		},
		["weapons"] = {
			L["Gear Axe"],
			L["Gear Bow"],
			L["Gear Crossbow"],
			L["Gear Fist Weapon"],
			L["Gear Gun"],
			L["Gear Mace"],
			L["Gear Polearm"],
			L["Gear Thrown"],
			L["Gear Two-Hand Sword"]
		},
	},
	["PRIEST"] = {
		["armor"] = {
			L["Gear Leather"],
			L["Gear Mail"],
			L["Gear Plate"],
			L["Gear Shield"],
		},
		["weapons"] = {
			L["Gear Axe"],
			L["Gear Bow"],
			L["Gear Crossbow"],
			L["Gear Fist Weapon"],
			L["Gear Gun"],
			L["Gear Polearm"],
			L["Gear Sword"],
			L["Gear Thrown"],
			L["Gear Two-Hand Mace"]
		},
	},
	["WARLOCK"] = {
		["armor"] = {
			L["Gear Leather"],
			L["Gear Mail"],
			L["Gear Plate"],
			L["Gear Shield"],
		},
		["weapons"] = {
			L["Gear Axe"],
			L["Gear Bow"],
			L["Gear Crossbow"],
			L["Gear Fist Weapon"],
			L["Gear Gun"],
			L["Gear Mace"],
			L["Gear Polearm"],
			L["Gear Thrown"],
			L["Gear Two-Hand Sword"]
		},
	},
}