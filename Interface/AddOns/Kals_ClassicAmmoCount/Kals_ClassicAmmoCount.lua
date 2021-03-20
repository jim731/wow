print("Hello " .. UnitName("Player") .. " Kals_ClassicAmmoCount is running.");


local debug = false;

function DebugPrint(msg)
	if(debug)then
		print(msg);
	end
end


local AmmoCount = 10;
local MinAmmoCount = 100;
local LowAmmo = false;

local MovementState = CreateFrame("FRAME", "AddonFrame");
MovementState:RegisterEvent("PLAYER_REGEN_ENABLED");
MovementState:RegisterEvent("ZONE_CHANGED");
MovementState:RegisterEvent("QUEST_ACCEPTED");
MovementState:RegisterEvent("MERCHANT_SHOW");

function TriggerWarning(self, event, ...)

	_index = 0; --default inventory slot ID 0 = ammoslot

	_class = select(2,UnitClass("player"));
	DebugPrint("Player class:  ".. _class);
	--RETURNS:
		--Warrior: 1
		--Hunter: 3

	--HUNTER
	if(_class == "HUNTER")then --hunter
		DebugPrint(_class);

		_index = 0; --ammo slot
	end

	--ROGUE
	if(_class == "ROGUE")then --hunter
		DebugPrint(_class);

		_index = 0; --ammo slot
	end

	--WARRIOR
		--warriors CAN use thrown weapon used from the ranged slot AND ammo slot
	if(_class == "WARRIOR")then --warrior
		DebugPrint(_class);

		if(GetInventoryItemCount("player", 0) == 1 and GetInventoryItemCount("player", 18) == 1)then
			DebugPrint("no ammo equipped anywhere O_O");
		end
		
		if(GetInventoryItemCount("player", 0) > 1)then
			DebugPrint("player using ammo");
			_index = 0; --ammo slot
		end

		if(GetInventoryItemCount("player", 18) > 1) then
			DebugPrint("player using thrown");
			_index = 18; --ranged slot
		end
	end

	

	if(MinAmmoCount ~= 0)then --ammo 0 = disabled
		if(_class == "HUNTER" or _class == "ROGUE" or _class == "WARRIOR")then
			AmmoCount = GetInventoryItemCount("player", _index)
			DebugPrint("Current ammo: " .. AmmoCount .." / ".. MinAmmoCount);

			if(AmmoCount > 1)then
				if(AmmoCount < MinAmmoCount)then
					print("|CFFe60000 AMMO LOW! " .. AmmoCount .." / ".. MinAmmoCount);
				end
			else
				print("|CFFe60000 NO AMMO!");
			end
		else
			print("Class cannot use ammo");
		end
	end
end
MovementState:SetScript("OnEvent", TriggerWarning);


local function AmmoDelay()
      C_Timer.NewTimer(10, TriggerWarning);
end


local CheckOnLoad = CreateFrame("FRAME", "AddonFrame");
CheckOnLoad:RegisterEvent("ADDON_LOADED");
CheckOnLoad:RegisterEvent("PLAYER_LOGOUT");

function CheckOnStart(self, event, ...)
	if(event == "ADDON_LOADED" and ... == "Kals_ClassicAmmoCount") then
		if(MinAmmoCountGlobal == nil) then
			MinAmmoCount = 200;
			print("|CFFe60000 AMMO COUNT HAS BEEN RESET TO: " .. MinAmmoCount .. " USE /AMMO [number] TO SET CUSTOM TRIGGERLEVEL");
		else
			MinAmmoCount = MinAmmoCountGlobal;
		end

		AmmoDelay();
	end

	if( event == "PLAYER_LOGOUT") then
		MinAmmoCountGlobal = MinAmmoCount;
	end
end
CheckOnLoad:SetScript("OnEvent", CheckOnStart);





--CONSOLE
SLASH_ClassicAmmoCount1 = "/ammo";

SlashCmdList.ClassicAmmoCount = function(msg)
	msg = string.lower(msg);

	if(msg == "")then
		print("|CFFffff00 Use /ammo 200 - to set minimum trigger level to 200");
		print("|CFFffff00 Use /ammo 0 - to disable");
		print("|CFFffff00 Current minimum trigger level is: " .. MinAmmoCount );
		
	elseif(msg == "debug") then
		debug = not debug;
		print("Ammo Debugging: " .. tostring(debug));

	elseif(tonumber(msg) ~= nil)then
		MinAmmoCount = tonumber(msg);
		print("|CFFffff00 MinAmmoCount is now: " .. MinAmmoCount );
	else
		print("|CFFe60000 ERROR");
		print("|CFFffff00 Use /ammo [value] - to set minimum trigger level");
	end
end 	