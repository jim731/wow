local OptionObjects={}
local LSM = HealBot_Libs_LSM()
local HealBot_Plugin_luVars={}
local HealBot_Plugin_Functions={}
local HealBot_Plugin_Config={}
local HealBot_Plugin={}
local HealBot_Plugin_ColourList={}
local HealBot_Plugin_FontOutlineList={}
local HealBot_Bar_Textures=nil
local HealBot_Fonts=nil
local HealBot_Bar_TexturesIndex={}
local HealBot_FontsIndex={}

function HealBot_Plugin_Options_CombatProt()
	HealBot_Plugin_luVars["pluginId"]="CombatProt"
	HealBot_Plugin_luVars["OptionsFrame"]=HealBot_Options_PluginCombatProtFrame
	
	HealBot_Plugin_Functions["pluginShutdown"]=HealBot_Plugin_CombatProt_Shutdown
	HealBot_Plugin_Functions["updateAll"]=HealBot_Plugin_CombatProt_CallUpdateAll

	HealBot_Plugin_Config=HealBot_Plugin_CombatProt_Config
	HealBot_Plugin=HealBot_Plugin_CombatProt
end

local function HealBot_Plugin_InUse()
	if HealBot_Globals.PluginCombatProt then
        OptionObjects["OptionFrame"]:Show()
	else
		OptionObjects["OptionFrame"]:Hide()
	end
end

local function HealBot_Plugin_OnClick(self)
	if self:GetChecked() then
		HealBot_Globals.PluginCombatProt=true
		HealBot_Plugin_CombatProt_Init()
	else
		HealBot_Globals.PluginCombatProt=false
		HealBot_Plugin_CombatProt_Shutdown()
	end
	HealBot_Plugin_InUse()
	HealBot_InitPlugins()
end

--------------------------------------------------------------------

local function HealBot_Plugin_Options_SetupFrame(frame, hide)
	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 0, right = 0, top = 0, bottom = 0, },
	})
	frame:SetBackdropColor(0,0,0,0);
	frame:SetPoint("TOPLEFT", -5, -120)
	frame:SetSize(600,470)
	if hide then
		frame:Hide()
	else 
		HealBot_Plugin_luVars["prevFrame"]=frame
	end
end

local function HealBot_Plugin_UseCrashProt(self)
	if self:GetChecked() then
		HealBot_Plugin_Config.useCP[HealBot_Plugin.Profile]=true
	else
		HealBot_Plugin_Config.useCP[HealBot_Plugin.Profile]=false
	end
    HealBot_Panel_setCP("MAIN", HealBot_Plugin_Config.useCP[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_UseCrashProtGroup(self)
	if self:GetChecked() then
		HealBot_Plugin_Config.useCPGroup[HealBot_Plugin.Profile]=true
	else
		HealBot_Plugin_Config.useCPGroup[HealBot_Plugin.Profile]=false
	end
    HealBot_Panel_setCP("GROUP", HealBot_Plugin_Config.useCPGroup[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_UseCrashProtRaid(self)
	if self:GetChecked() then
		HealBot_Plugin_Config.useCPRaid[HealBot_Plugin.Profile]=true
	else
		HealBot_Plugin_Config.useCPRaid[HealBot_Plugin.Profile]=false
	end
    HealBot_Panel_setCP("RAID", HealBot_Plugin_Config.useCPRaid[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_Frame_Profile(self)
	if self:GetChecked() then
		HealBot_Plugin.Profile="Global"
	else
		HealBot_Plugin.Profile=UnitName("player")
		table.foreach(HealBot_Plugin_Config, function (key,val)
			if HealBot_Plugin_Config[key][HealBot_Plugin.Profile]==nil then
				HealBot_Plugin_Config[key][HealBot_Plugin.Profile] = HealBot_Plugin_Config[key]["Global"];
			end
		end)
	end
	HealBot_Plugin_Functions["updateAll"]()
	HealBot_Plugin_Threat_Options()
end

local function HealBot_Plugin_Options()
	local pId=HealBot_Plugin_luVars["pluginId"]
	if not HealBot_Plugin_luVars["optionsInit"] then
        HealBot_Bar_Textures = LSM:List('statusbar');
        for x,_ in pairs(HealBot_Bar_TexturesIndex) do
            HealBot_Bar_TexturesIndex[x]=nil
        end 
        for i=1,#HealBot_Bar_Textures do
            HealBot_Bar_TexturesIndex[HealBot_Bar_Textures[i]] = i
        end
        HealBot_Fonts = LSM:List('font');
        for x,_ in pairs(HealBot_FontsIndex) do
            HealBot_FontsIndex[x]=nil
        end 
        for i=1,#HealBot_Fonts do
            HealBot_FontsIndex[HealBot_Fonts[i]] = i
        end
		
		OptionObjects["OptionFrame"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_Frame", HealBot_Plugin_luVars["OptionsFrame"], BackdropTemplateMixin and "BackdropTemplate")
		HealBot_Plugin_Options_SetupFrame(OptionObjects["OptionFrame"])

		-- Frame
		OptionObjects["OptionFrameProfile"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Profile", OptionObjects["OptionFrame"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionFrameProfile"]:SetPoint("TOP", -40, -50)
		OptionObjects["OptionFrameProfile"]:SetScript("OnClick", function() HealBot_Plugin_Frame_Profile(OptionObjects["OptionFrameProfile"]); end)
        
		OptionObjects["OptionUseCrashProt"] = CreateFrame("CheckButton", "HealBot_"..pId.."_UseCP", OptionObjects["OptionFrame"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionUseCrashProt"]:SetPoint("TOP", -70, -175)
		OptionObjects["OptionUseCrashProt"]:SetScript("OnClick", function() HealBot_Plugin_UseCrashProt(OptionObjects["OptionUseCrashProt"]); end)

		OptionObjects["OptionUseCrashProtGroup"] = CreateFrame("CheckButton", "HealBot_"..pId.."_UseInGroups", OptionObjects["OptionFrame"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionUseCrashProtGroup"]:SetPoint("TOP", -48, -210)
		OptionObjects["OptionUseCrashProtGroup"]:SetScript("OnClick", function() HealBot_Plugin_UseCrashProtGroup(OptionObjects["OptionUseCrashProtGroup"]); end)

		OptionObjects["OptionUseCrashProtRaid"] = CreateFrame("CheckButton", "HealBot_"..pId.."_UseInRaids", OptionObjects["OptionFrame"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionUseCrashProtRaid"]:SetPoint("TOP", -48, -245)
		OptionObjects["OptionUseCrashProtRaid"]:SetScript("OnClick", function() HealBot_Plugin_UseCrashProtRaid(OptionObjects["OptionUseCrashProtRaid"]); end)

		HealBot_Plugin_luVars["optionsInit"]=true
	end
	local r,g,b=HealBot_Options_OptionsThemeCols()
	HealBot_Options_SetText(OptionObjects["OptionUse"], " Enable Plugin")
	HealBot_Options_SetText(OptionObjects["OptionUseCrashProt"], HEALBOT_OPTIONS_USECP)
	HealBot_Options_SetText(OptionObjects["OptionUseCrashProtGroup"], HEALBOT_OPTIONS_USECPGROUP)
	HealBot_Options_SetText(OptionObjects["OptionUseCrashProtRaid"], HEALBOT_OPTIONS_USECPRAID)
	HealBot_Options_SetText(OptionObjects["OptionFrameProfile"], HEALBOT_WORDS_GLOBALPROFILE)
	OptionObjects["OptionUseCrashProt"]:SetChecked(HealBot_Plugin_Config.useCP[HealBot_Plugin.Profile])
	OptionObjects["OptionUseCrashProtGroup"]:SetChecked(HealBot_Plugin_Config.useCPGroup[HealBot_Plugin.Profile])
	OptionObjects["OptionUseCrashProtRaid"]:SetChecked(HealBot_Plugin_Config.useCPRaid[HealBot_Plugin.Profile])
	if HealBot_Plugin.Profile=="Global" then
		OptionObjects["OptionFrameProfile"]:SetChecked(true)
	else
		OptionObjects["OptionFrameProfile"]:SetChecked(false)
	end

	OptionObjects["OptionFrame"]:SetBackdropBorderColor(r,g,b,0.7)
end

function HealBot_Plugin_CombatProt_Options()
	HealBot_Plugin_Options_CombatProt()
	if not HealBot_Plugin_luVars["optionsInit"] then
		local pId=HealBot_Plugin_luVars["pluginId"]
		OptionObjects["OptionUse"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_Use", HealBot_Plugin_luVars["OptionsFrame"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionUse"]:SetPoint("TOP", -40, -40)
		OptionObjects["OptionUse"]:SetScript("OnClick", function() HealBot_Plugin_OnClick(OptionObjects["OptionUse"]); end)
		OptionObjects["OptionUse"]:SetChecked(HealBot_Globals.PluginCombatProt)		
	end
	HealBot_Plugin_Options()
	HealBot_Plugin_InUse()
end