AutoAmmo_Quantity = 0
local ammoID;
local ammoTable = {}
ammoTable[LE_ITEM_WEAPON_GUNS] = {
	[1] =  2516,
	[10] = 2519,
	[25] = 3033,
	[40] = 11284,
}
ammoTable[LE_ITEM_WEAPON_BOWS] = {
	[1] = 2512,
	[10] = 2515,
	[25] = 3030,
	[40] = 11285,
}
ammoTable[LE_ITEM_WEAPON_CROSSBOW] = ammoTable[LE_ITEM_WEAPON_BOWS]

function AutoAmmo_ItemToBuy()
	local rangedItemID = GetInventoryItemID("player", 18)
	if rangedItemID ~= nil then
		local subclassID  = select(7, GetItemInfoInstant(rangedItemID))
		ammoID = nil
		local playerLevel = UnitLevel("PLAYER");
		if subclassID == LE_ITEM_WEAPON_BOWS or subclassID == LE_ITEM_WEAPON_GUNS or subclassID == LE_ITEM_WEAPON_CROSSBOW then
			while (playerLevel > 0) and (ammoID == nil) do
				ammoID = ammoTable[subclassID][playerLevel]
				playerLevel = playerLevel - 1;
			end
		end
	else
		ammoID = nil;
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event, ...)
	AutoAmmo_ItemToBuy();
	local i = GetMerchantNumItems();
	local toBuy = AutoAmmo_Quantity - GetItemCount(ammoID)
	while i>0 and toBuy > 0 and ammoID ~= nil do
		local merchItemID = GetMerchantItemID(i)
		if merchItemID == ammoID then
			while (toBuy > 200) do
				BuyMerchantItem(i, 200)
				toBuy = toBuy - 200
			end
			if toBuy > 0 then
				BuyMerchantItem(i, toBuy)
				toBuy = 0
			end
		end
		i = i - 1;
	end
end)

function AutoAmmo_Command(arg1)
	AutoAmmo_ItemToBuy();
	if tonumber(arg1) ~= nil then
		AutoAmmo_Quantity = tonumber(arg1)
		if ammoID ~= nil then
			local ammoName = select(1, GetItemInfo(ammoID))
			if ammoName == nil then
				ammoName = "ammo"
			end
			print("Stockpiling " ..  AutoAmmo_Quantity .. " " .. ammoName)
		else
			print("Stockpiling " .. AutoAmmo_Quantity .. " ammo when you get a weapon that needs it.")
		end
	else
		print("Available command is \/aa <number>")
	end
end

SLASH_AUTOAMMO1 = "/aa"
SLASH_AUTOAMMO2 = "/autoammo"
SlashCmdList.AUTOAMMO = AutoAmmo_Command