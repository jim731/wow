local HealBot_Plugin_luVars={}
local HealBot_Plugin_Config={}
local HealBot_Plugin={}
HealBot_Plugin_luVars["frameInit"]=false

function HealBot_Plugin_CombatProt_Init()
	if not HealBot_Plugin_luVars["pluginInit"] then
		table.foreach(HealBot_Plugin_CombatProtDefaults, function (key,val)
			if HealBot_Plugin_CombatProt[key]==nil then
				HealBot_Plugin_CombatProt[key] = val;
			end
		end);
		table.foreach(HealBot_Plugin_CombatProt_ConfigDefaults, function (key,val)
			if HealBot_Plugin_CombatProt_Config[key]==nil then
				HealBot_Plugin_CombatProt_Config[key] = val;
			end
		end);
		HealBot_Plugin_Config=HealBot_Plugin_CombatProt_Config
		HealBot_Plugin=HealBot_Plugin_CombatProt
		if HealBot_Plugin.Profile~="Global" then HealBot_Plugin.Profile=UnitName("player") end

		HealBot_Plugin_luVars["pluginInit"]=true
	end
	HealBot_Plugin_CombatProt_UpdateAll()
    
end

function HealBot_Plugin_CombatProt_CallUpdateAll()
	HealBot_Plugin_CombatProt_UpdateAll()
end

function HealBot_Plugin_CombatProt_UpdateAll()
    HealBot_Panel_setCP("MAIN", HealBot_Plugin_Config.useCP[HealBot_Plugin.Profile])
    HealBot_Panel_setCP("GROUP", HealBot_Plugin_Config.useCPGroup[HealBot_Plugin.Profile])
    HealBot_Panel_setCP("RAID", HealBot_Plugin_Config.useCPRaid[HealBot_Plugin.Profile])
end

function HealBot_Plugin_CombatProt_Shutdown()
    HealBot_Panel_setCP("MAIN", false)
end
