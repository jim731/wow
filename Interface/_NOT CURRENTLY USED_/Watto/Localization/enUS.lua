--[[
	Watto Classic v1.7.4
	American English (enUS) Localization
	
	Revision: $Id: enUS.lua 9 2019-09-06 09:27:34 Pacific Time Kjasi $
]]

local w = _G.Watto
if (not w) then
	print(RED_FONT_COLOR_CODE.."enUS Localization is unable to find Watto Global."..FONT_COLOR_CODE_CLOSE)
	return
end
local L = w.Localization
if (not L) then
	print(RED_FONT_COLOR_CODE.."enUS Localization is unable to find Watto's Localization data."..FONT_COLOR_CODE_CLOSE)
	return
end

-- Message Templates
L.MSG = "|CFF57A5BB%s:"..FONT_COLOR_CODE_CLOSE.." %s"
L.ERRORMSG = "|CFFFF2020%s Error:"..FONT_COLOR_CODE_CLOSE.." %s"

-- Loaded Message
L.IS_LOADED = "Version %s is now loaded!"		-- Version number is passed as a string. (Example: 1.3.4)
L.INTERFACE_VERSION = "Version %s"				-- Used in the Interface Options page.

-- Errors
L.ERROR_UNKNOWNCOMMAND = "I didn't recognize that command."
L.ERROR_LIST_BADITEM = "Sorry, but %s is not sellable."
L.ERROR_BUY_TOOMANY = "You do not have enough bag space for that many items."
L.ERROR_BUY_TOOEXPENSIVE = "You can not afford that."
L.ERROR_NO_ITEMS = "No valid items listed."

-- Item Selling String
L.SELL_ITEM = "Selling: %s"			-- Selling a single Item
L.SELL_ITEMS = "Selling: %sx%i"		-- Selling multiples of an Item

--Sell Text
-- If randomselltext == 1, we'll use a random selection from SELL_RANDOMSAYINGS. Otherwise, only show SELL_TOTAL.
L.SELL_TOTAL = "Profit Earned: %s" 	-- Non-Random Text.
-- Feel free to add your own. The translations don't have to match these at all! But I would like them to...
L.SELL_RANDOMSAYINGS = {
	"Here's your %s.",
	"I suppose I could give you %s for all that...",
	"%s! That's my final offer!",
	"I know a good way to invest that %s...",
	"If I had %s, I'd bet it on Sebulba!",
	"%s, huh? So... Care to make a wager?",
	"%s, it's a good deal, yeah?",
	"Okay, %s, but YOU have do the shlepping!",
	random(2,7).." minutes ago, I could of gotten you more than %s... ",
	"What?! Anakin gave you %s for that?!",
	"Another day, another %s...",
	"You see %s, I see a price hike!",
	"Demand for that is low... I'll give you %s.",
	"I have a customer that wants all that for %s! With my 10%% fee of course...",
	"You won't find a better deal than %s, I think.",
	"I'm feeling generious. I'll give you %s.",
	"%s?! Ha! I'd get more for selling my Chancecube!",
	"What do you think you are, a Jedi? %s! No more!",
	"If you don't want that %s, I've got a few droids in the back you might be interested in.",
	"That's not worth much. I'll only give you %s for it all.",
	"Ha! I've got lots of that in the back. %s! No more!",
	"Oh! That's... Umm... Not worth much. %s..."
}

-- Money
L.COPPER_S = "c"
L.SILVER_S = "s"
L.GOLD_S = "g"

-- Interface
L.INTERFACE_RANDOMSAYINGS = "Use Watto Sayings"
L.INTERFACE_RANDOMSAYINGS_TOOLTIP = "Have Watto tell you how much you've earned, using a random line of dialog.\r\rIf not used, a standardized line of text will be used instead."
L.INTERFACE_SELLNOTICE = "Show Sell Notice"
L.INTERFACE_SELLNOTICE_TOOLTIP = "Displays a list of what was sold by Watto."
L.INTERFACE_AUTOSELLFOOD = "Sell Low-Level Food"
L.INTERFACE_AUTOSELLFOOD_TOOLTIP = "When selling junk, Watto will sell low-level food items that the current character shouldn't use."
L.INTERFACE_SHOWDATAINTOOLTIPS = "Show Watto Data in Tooltips"
L.INTERFACE_SHOWDATAINTOOLTIPS_TOOLTIP = "Will add selling notices and exclusion list data to item tooltips."
L.INTERFACE_SELLBACKLIMITER = "Use Sell-Back Limiter"
L.INTERFACE_SELLBACKLIMITER_TOOLTIP = "This will limit the number of items Watto sells each time you click the sell button to what you can buy back from the merchant.\r\rUse this if you want to be able to buy back an item that was sold."
L.INTERFACE_USEMONEYICONS = "Use Money Icons"
L.INTERFACE_USEMONEYICONS_TOOLTIP = "Uses icons for money, instead of text."
L.INTERFACE_SELLJUNKSOULBOUND = "Sell Junk Soulbound Items"
L.INTERFACE_SELLJUNKSOULBOUND_TOOLTIP = "Junk Soulbound items are items that are soulbound to you, but unusable by you. Mostly, this is class-specific gear that doesn't match your class."

-- Buying Interface Localization
L.INTERFACE_BUY_STACK = "Add Stack"
L.INTERFACE_BUY_CANAFFORD = "Can Afford"
L.INTERFACE_BUY_FILLSTACKS = "Fill Stacks"
L.INTERFACE_BUY_FILLBAGS = "Fill Bags"
L.INTERFACE_BUY_PURCHASE = "Purchase"
L.INTERFACE_BUY_COST = "Cost:"


-- Command-line Options
-- Should be all lower-case, as strlower() is applied to the command-line first.
L.CMD_DELIMITER = " "	-- Commands are separated by this string.
L.CMD_HELP = "help"		-- Displays CMD_HELP_TEXT.
L.CMD_SHOW = "show"		-- Shows Watto's options window.
L.CMD_CONFIG = "config"	-- Shows Watto's options window.
L.CMD_ADD = "add"
L.CMD_REM = "rem"
L.CMD_LIST = "list"
L.CMD_SUB_ME = "me" 	-- Changes the commands to use the personal lists.
L.CMD_SUB_ALL = "all"	-- Only applies to CMD_REM. Used to delete the entire list.

-- Linked Commands
L.CMD_ADD_ME = L.CMD_ADD..L.CMD_DELIMITER..L.CMD_SUB_ME
L.CMD_REM_ME = L.CMD_REM..L.CMD_DELIMITER..L.CMD_SUB_ME
L.CMD_REM_ALL = L.CMD_REM..L.CMD_DELIMITER..L.CMD_SUB_ALL
L.CMD_REM_ME_ALL = L.CMD_REM..L.CMD_DELIMITER..L.CMD_SUB_ME..L.CMD_DELIMITER..L.CMD_SUB_ALL
L.CMD_LIST_ME = L.CMD_LIST..L.CMD_DELIMITER..L.CMD_SUB_ME

L.CMD_HELP_TEXT = "Watto Help:\rshow = Opens the Options Window.\radd (Item) = Add an item to the Global List.\radd me (Item) = Add an item to your Personal List.\rrem (item) = Removes an item from the Global List.\rrem me (item) = Removes an item from your Personal List.\rrem all = Removes all the items from the Global List.\rrem me all = Removes all the items from your Personal List."

L.CMD_HELP_ADD = "Watto Help:\radd (Item) = Add an item to the Global List.\radd me (Item) = Add an item to your Personal List."
L.CMD_HELP_REM = "Watto Help:\rrem (item) = Removes an item from the Global List.\rrem me (item) = Removes an item from your Personal List.\rrem all = Removes all the items from the Global List.\rrem me all = Removes all the items from your Personal List."

-- Tooltip
L.TOOLTIP_SELLPROFIT = "Estimated Profit: %s"
L.TOOLTIP_SELLITEMNUM = "from %i items to be sold."
L.TOOLTIP_LIST_WILLSELL = "Watto will sell this item."
L.TOOLTIP_LIST_SELLEXCLUSION = "Watto will sell this exclusion item."
L.TOOLTIP_LIST_AUTOSELL = "Watto will automatically sell this item."
L.TOOLTIP_LIST_SELLFOOD = "Watto will sell this low-level food item."
L.TOOLTIP_LIST_SOULBOUNDJUNK = "Watto will sell this unusable, Soulbound item."
L.TOOLTIP_LIST_NOAUTOSELL = "Watto will not automatically sell this item."
L.TOOLTIP_LIST_TITLE = "Watto Exclusions:"
L.TOOLTIP_LIST_INGENERAL = "  General Exclusion List"
L.TOOLTIP_LIST_INPRIVATE = "  Private Exclusion List"

--Listing
L.LIST_ADDGENERAL_SUCCESS = "%s has been added to the general exclusion list."
L.LIST_ADDGENERAL_FAIL = "%s is already in the general exclusion list."
L.LIST_ADDPERSONAL_SUCCESS = "%s has been added to your personal exclusion list."
L.LIST_ADDPERSONALBUTINGENERAL_SUCCESS = "%s has been added, but is already in the general exclusion list. This item will no longer be sold."
L.LIST_ADDPERSONAL_FAIL = "%s is already in your personal exclusion list."
L.LIST_REMGENERAL_SUCCESS = "%s has been removed from the general exclusion list."
L.LIST_REMGENERAL_FAIL = "%s is not in the general exclusion list."
L.LIST_REMPERSONAL_SUCCESS = "%s has been removed from your personal exclusion list."
L.LIST_REMPERSONAL_FAIL = "%s is not in your personal exclusion list."
L.LIST_EMPTYGENERAL = "The general exclusion list is empty."
L.LIST_EMPTYPERSONAL = "Your personal exclusion list is empty."
L.LIST_GENERALLISTING = "General Exclusion List:"
L.LIST_PERSONALLISTING = "Personal Exclusion List:"
L.LIST_ADDFOOD_SUCCESS = "Food items are automatically sold to vendors. %s will no longer be sold to vendors."
L.LIST_ADDPERSONALBUTINGENERALFOOD_SUCCESS = "Food items are automatically sold to vendors. %s is now in both exclusion lists, and will be sold to vendors. You may wish to remove it from both lists instead."
L.LIST_REMALL = "Every item on the general exclusion list has been removed."
L.LIST_REMMEALL = "Every item on your personal exclusion list has been removed."