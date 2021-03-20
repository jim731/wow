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

function HealBot_Plugin_Options_Threat()
	HealBot_Plugin_luVars["pluginId"]="Threat"
	HealBot_Plugin_luVars["OptionsFrame"]=HealBot_Options_PluginThreatFrame
	
	HealBot_Plugin_Functions["frameWidth"]=HealBot_Plugin_Threat_FrameWidth
	HealBot_Plugin_Functions["pluginShutdown"]=HealBot_Plugin_Threat_Shutdown
	HealBot_Plugin_Functions["toggleShow"]=HealBot_Plugin_Threat_TogglePanel
	HealBot_Plugin_Functions["updateAll"]=HealBot_Plugin_Threat_UpdateAll
	HealBot_Plugin_Functions["updateText"]=HealBot_Plugin_Threat_UpdateText
	HealBot_Plugin_Functions["updateTexture"]=HealBot_Plugin_Threat_UpdateTexture
	HealBot_Plugin_Functions["updateHeight"]=HealBot_Plugin_Threat_UpdateHeight
	HealBot_Plugin_Functions["updateTitle"]=HealBot_Plugin_Threat_UpdateTitle
	HealBot_Plugin_Functions["testMode"]=HealBot_Plugin_Threat_TestMode
	
	HealBot_Plugin_ColourList={HEALBOT_OPTIONS_PROFILE_CLASS,
	                           HEALBOT_WORD_THREAT,
							   HEALBOT_CLASSES_CUSTOM}
    HealBot_Plugin_FontOutlineList={
							   HEALBOT_WORDS_NONE,
							   HEALBOT_WORDS_THIN,
							   HEALBOT_WORDS_THICK}
	HealBot_Plugin_Config=HealBot_Plugin_Threat_Config
	HealBot_Plugin=HealBot_Plugin_Threat
end

local function HealBot_Plugin_InUse()
	if HealBot_Globals.PluginThreat then
		OptionObjects["OptionFrameBtn"]:Show()
		OptionObjects["OptionBarBtn"]:Show()
		OptionObjects["OptionTextBtn"]:Show()
		HealBot_Plugin_luVars["prevFrame"]:Show()
	else
		OptionObjects["OptionFrameBtn"]:Hide()
		OptionObjects["OptionBarBtn"]:Hide()
		OptionObjects["OptionTextBtn"]:Hide()
		HealBot_Plugin_luVars["prevFrame"]:Hide()
	end
end

local function HealBot_Plugin_OnClick(self)
	if self:GetChecked() then
		HealBot_Globals.PluginThreat=true
		HealBot_Plugin_Threat_Init()
	else
		HealBot_Globals.PluginThreat=false
		HealBot_Plugin_Threat_Shutdown()
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

local function HealBot_Plugin_Options_Setup_EditBox(editbox,parent,x,y,headertext, text)
	editbox:SetPoint("TOP",parent,x,y)
	editbox:SetTextInsets(2, 2, 2, 2)
	editbox:SetMaxLetters(30)
	editbox:SetWidth(200)
	editbox.Txt = editbox:CreateFontString()
	editbox.Txt:SetFontObject(GameFontNormal)
	editbox.Txt:SetPoint("TOP", 0 , 12)
    editbox.Txt:SetText(headertext)
	editbox:SetText(text)
end

local function HealBot_Plugin_Frame_Lock(self)
	if self:GetChecked() then
		HealBot_Plugin_Config.frameLocked[HealBot_Plugin.Profile]=true
	else
		HealBot_Plugin_Config.frameLocked[HealBot_Plugin.Profile]=false
	end
end

local function HealBot_Plugin_Frame_Test(self)
	if self:GetChecked() then
		HealBot_Plugin_Functions["testMode"](true)
	else
		HealBot_Plugin_Functions["testMode"](false)
	end
end

function HealBot_Plugin_Frame_Threat_TestOff()
	OptionObjects["OptionFrameTest"]:SetChecked(false)
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

local function HealBot_Plugin_Frame_OnlyInCombat(self)
	if self:GetChecked() then
		HealBot_Plugin_Config.OnlyShowOnDemand[HealBot_Plugin.Profile]=true
	else
		HealBot_Plugin_Config.OnlyShowOnDemand[HealBot_Plugin.Profile]=false
	end
	HealBot_Plugin_Functions["toggleShow"]()
end

local function HealBot_Plugin_Frame_FluidBars_OnClick(self)
	if self:GetChecked() then
		HealBot_Plugin_Config.fluidbars[HealBot_Plugin.Profile]=true
	else
		HealBot_Plugin_Config.fluidbars[HealBot_Plugin.Profile]=false
	end
	HealBot_Plugin_Functions["updateAll"]()
end

local function HealBot_Plugin_Frame_TitleText_Change(self)
	HealBot_Plugin_Config.titletext[HealBot_Plugin.Profile]=strtrim(self:GetText())
	HealBot_Plugin_Functions["updateTitle"]()
end

local function HealBot_Plugin_Options_SetupSlider(slider, point, width, x, y)
	slider:SetSize(width, 15)
	slider:SetOrientation('HORIZONTAL')
	slider:SetPoint(point, x, y)
end

local function HealBot_Plugin_Options_SetupDropDown(dropdown, width, x, y, text)
	dropdown:SetPoint("TOP", x, y)
	UIDropDownMenu_SetWidth(dropdown, width)	
	dropdown.Txt = dropdown:CreateFontString()
	dropdown.Txt:SetFontObject(GameFontNormal)
	dropdown.Txt:SetPoint("TOP", 0 , 12)
    dropdown.Txt:SetText(text)
end

local function OptionBarColourType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_ColourList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionBarColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateAll"]()							
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function OptionTankBarColourType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_ColourList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionTankBarColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateAll"]()							
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function OptionYourBarColourType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_ColourList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionYourBarColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateAll"]()							
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function OptionTextColourType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_ColourList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionTextColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateAll"]()							
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function OptionTankTextColourType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_ColourList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionTankTextColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateAll"]()							
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function OptionYourTextColourType_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_ColourList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionYourTextColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateAll"]()							
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function OptionTextOutline_DropDown()
    local info = UIDropDownMenu_CreateInfo()
    for j=1, 3, 1 do
        info.text = HealBot_Plugin_FontOutlineList[j];
        info.func = function(self)
                        if HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]~=self:GetID() then
							HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]=self:GetID()
                            UIDropDownMenu_SetText(OptionObjects["OptionTextOutline"],HealBot_Plugin_FontOutlineList[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
							HealBot_Plugin_Functions["updateText"]()
                        end
                    end
        info.checked = false;
        if HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]==j then info.checked = true end
        UIDropDownMenu_AddButton(info);
    end
end

local function HealBot_Plugin_Options_SetLabel(object, text)
	local r,g,b,a=HealBot_Options_OptionsThemeCols()
	object:SetText(text)
	object:SetTextColor(r,g,b,a)
end

local function HealBot_Plugin_Options_SetupStatusBar(bar, width, height, x, y, text)
	bar:SetSize(width, height)
	bar:SetPoint("TOP", x, y)
	bar:SetStatusBarTexture("Interface\\Addons\\HealBot\\Images\\bar8.tga")
	bar.Text = bar:CreateFontString()
	bar.Text:SetFontObject(GameFontNormal)
	bar.Text:SetPoint("CENTER")
	bar.Text:SetJustifyH("CENTER")
	bar.Text:SetJustifyV("CENTER")
    bar.Text:SetText(text)
end

local function HealBot_Plugin_Options_SetupStatusBarButton(bar, width, x, text)
	bar:SetSize(width, 22)
	bar:SetPoint("TOP", x, -85)
	bar:SetStatusBarTexture("Interface\\Addons\\HealBot\\Images\\tukuibar.tga")
	bar.Text = bar:CreateFontString()
	bar.Text:SetFontObject(GameFontNormal)
	bar.Text:SetPoint("CENTER")
	bar.Text:SetJustifyH("CENTER")
	bar.Text:SetJustifyV("CENTER")
    bar.Text:SetText(text)
end

local function HealBot_Plugin_Frame_OnClick(frame, button)
	HealBot_Plugin_luVars["prevFrame"]:Hide()
	frame:Show()
	HealBot_Plugin_luVars["prevFrame"]=frame
	local r,g,b=HealBot_Options_OptionsThemeCols()
	HealBot_Plugin_luVars["prevFrameBtn"]:SetStatusBarColor(r, g, b, 0.5)
	HealBot_Plugin_luVars["prevFrameBtn"].Text:SetTextColor(r, g, b, 0.8)
	button:SetStatusBarColor(r, g, b, 1)
	button.Text:SetTextColor(1, 1, 1, 1)
	HealBot_Plugin_luVars["prevFrameBtn"]=button
end

local function HealBot_Plugin_Frame_Width_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile] = val;
        HealBot_Plugin_Functions["frameWidth"]()
		local g=_G[self:GetName().."Text"]
		g:SetText(self.text .. ": " .. val);
    end
end

local function HealBot_Plugin_Frame_FluidBarsValue_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.fluidfreq[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.fluidfreq[HealBot_Plugin.Profile] = val;
    end
end

local function HealBot_Plugin_BarMax_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.maxBars[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.maxBars[HealBot_Plugin.Profile] = val;
        HealBot_Plugin_Functions["updateAll"]()
		local g=_G[self:GetName().."Text"]
		g:SetText(self.text .. ": " .. val);
    end
end

local function HealBot_Plugin_TextFontSize_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile] = val;
		local g=_G[self:GetName().."Text"]
		g:SetText(self.text .. ": " .. val);
		HealBot_Plugin_Functions["updateText"]()
		HealBot_Plugin_Functions["updateTitle"]()
    end
end

local function HealBot_Plugin_TextFontChars_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile] = val;
		local g=_G[self:GetName().."Text"]
		if val==0 then
			g:SetText(self.text .. ": " .. HEALBOT_WORD_AUTO);
		else
			g:SetText(self.text .. ": " .. val);
		end
		HealBot_Plugin_Functions["updateAll"]()
    end
end

local function HealBot_Plugin_TextFontChars_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile] = val;
		local g=_G[self:GetName().."Text"]
		if val==0 then
			g:SetText(self.text .. ": " .. HEALBOT_WORD_AUTO);
		else
			g:SetText(self.text .. ": " .. val);
		end
		HealBot_Plugin_Functions["updateAll"]()
    end
end

local function HealBot_Plugin_HdrTextFontChars_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile] = val;
		local g=_G[self:GetName().."Text"]
		if val==0 then
			g:SetText(self.text .. ": " .. HEALBOT_WORD_AUTO);
		else
			g:SetText(self.text .. ": " .. val);
		end
		HealBot_Plugin_Functions["updateAll"]()
    end
end

local function HealBot_Plugin_BarTexture_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    else
        if HealBot_Bar_Textures then
            HealBot_Plugin_Config.texture[HealBot_Plugin.Profile] = HealBot_Bar_Textures[val];
            g=_G[self:GetName().."Text"]
            g:SetText(self.text .. " "..val..": " .. HealBot_Bar_Textures[val]);
        else
            g=_G[self:GetName().."Text"]
            g:SetText(self.text);
        end
		HealBot_Plugin_Functions["updateTexture"]()
    end
end

local function HealBot_Plugin_TextFont_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    else
        if HealBot_Fonts then
            HealBot_Plugin_Config.font[HealBot_Plugin.Profile] = HealBot_Fonts[val];
            g=_G[self:GetName().."Text"]
            g:SetText(self.text .. " "..val..": " .. HealBot_Fonts[val]);
        else
            g=_G[self:GetName().."Text"]
            g:SetText(self.text);
        end
		HealBot_Plugin_Functions["updateText"]()
		HealBot_Plugin_Functions["updateTitle"]()
    end
end

local function HealBot_Plugin_BarHeight_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.height[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.height[HealBot_Plugin.Profile] = val;
        HealBot_Plugin_Functions["updateHeight"]()
		local g=_G[self:GetName().."Text"]
		g:SetText(self.text .. ": " .. val);
    end
end

local function HealBot_Plugin_OptionBarMinThreatPct_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.minthreatpct[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.minthreatpct[HealBot_Plugin.Profile] = val;
		local g=_G[self:GetName().."Text"]
		g:SetText(self.text .. ": " .. val .. "%");
    end
end

local function HealBot_Plugin_BarRowS_OnValueChanged(self)
    local val=floor(self:GetValue()+0.5)
    if val~=self:GetValue() then
        self:SetValue(val) 
    elseif HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile]~=val then
		HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile] = val;
        HealBot_Plugin_Functions["updateAll"]()
		local g=_G[self:GetName().."Text"]
		g:SetText(self.text .. ": " .. val);
    end
end

local function HealBot_Plugin_BarColourA_OnValueChanged(self)
    HealBot_Plugin_Config.barA[HealBot_Plugin.Profile] = HealBot_Comm_round(HealBot_Options_Pct_OnValueChanged(self),2)
    HealBot_Plugin_Functions["updateAll"]()
end

local function HealBot_Plugin_TextColourA_OnValueChanged(self)
    HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile] = HealBot_Comm_round(HealBot_Options_Pct_OnValueChanged(self),2)
    HealBot_Plugin_Functions["updateAll"]()
end

local function HealBot_Plugin_Options_SetTitleCols()
	OptionObjects["OptionFrameTitleBack"]:SetStatusBarColor(HealBot_Plugin_Config.titlebackR[HealBot_Plugin.Profile],
                                                            HealBot_Plugin_Config.titlebackG[HealBot_Plugin.Profile],
                                                            HealBot_Plugin_Config.titlebackB[HealBot_Plugin.Profile],
                                                            HealBot_Plugin_Config.titlebackA[HealBot_Plugin.Profile])
	OptionObjects["OptionFrameTitleTextCol"]:SetStatusBarColor(HealBot_Plugin_Config.titlebackR[HealBot_Plugin.Profile],
                                                               HealBot_Plugin_Config.titlebackG[HealBot_Plugin.Profile],
                                                               HealBot_Plugin_Config.titlebackB[HealBot_Plugin.Profile],
														       HealBot_Plugin_Config.titlebackA[HealBot_Plugin.Profile])
	OptionObjects["OptionFrameTitleBack"].Text:SetTextColor(HealBot_Plugin_Config.titletextR[HealBot_Plugin.Profile],
                                                            HealBot_Plugin_Config.titletextG[HealBot_Plugin.Profile],
                                                            HealBot_Plugin_Config.titletextB[HealBot_Plugin.Profile],
                                                            HealBot_Plugin_Config.titletextA[HealBot_Plugin.Profile])
	OptionObjects["OptionFrameTitleTextCol"].Text:SetTextColor(HealBot_Plugin_Config.titletextR[HealBot_Plugin.Profile],
                                                               HealBot_Plugin_Config.titletextG[HealBot_Plugin.Profile],
                                                               HealBot_Plugin_Config.titletextB[HealBot_Plugin.Profile],
                                                               HealBot_Plugin_Config.titletextA[HealBot_Plugin.Profile])
end


local function HealBot_Plugin_Options_SetBarCols()
	OptionObjects["OptionBarColour"]:SetStatusBarColor(HealBot_Plugin_Config.barR[HealBot_Plugin.Profile],
					    							    HealBot_Plugin_Config.barG[HealBot_Plugin.Profile],
													    HealBot_Plugin_Config.barB[HealBot_Plugin.Profile],
													    HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
	OptionObjects["OptionTankBarColour"]:SetStatusBarColor(HealBot_Plugin_Config.tankbarR[HealBot_Plugin.Profile],
					    							       HealBot_Plugin_Config.tankbarG[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.tankbarB[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
	OptionObjects["OptionYourBarColour"]:SetStatusBarColor(HealBot_Plugin_Config.yourbarR[HealBot_Plugin.Profile],
					    							       HealBot_Plugin_Config.yourbarG[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.yourbarB[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
	OptionObjects["OptionTextColour"]:SetStatusBarColor(HealBot_Plugin_Config.barR[HealBot_Plugin.Profile],
					    							    HealBot_Plugin_Config.barG[HealBot_Plugin.Profile],
													    HealBot_Plugin_Config.barB[HealBot_Plugin.Profile],
													    HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
	OptionObjects["OptionTankTextColour"]:SetStatusBarColor(HealBot_Plugin_Config.tankbarR[HealBot_Plugin.Profile],
					    							        HealBot_Plugin_Config.tankbarG[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.tankbarB[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
	OptionObjects["OptionYourTextColour"]:SetStatusBarColor(HealBot_Plugin_Config.yourbarR[HealBot_Plugin.Profile],
					    							        HealBot_Plugin_Config.yourbarG[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.yourbarB[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
	OptionObjects["OptionBarColour"].Text:SetTextColor(HealBot_Plugin_Config.bartxtR[HealBot_Plugin.Profile],
					    							   HealBot_Plugin_Config.bartxtG[HealBot_Plugin.Profile],
													   HealBot_Plugin_Config.bartxtB[HealBot_Plugin.Profile],
													   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
	OptionObjects["OptionTankBarColour"].Text:SetTextColor(HealBot_Plugin_Config.tankbartxtR[HealBot_Plugin.Profile],
					    							       HealBot_Plugin_Config.tankbartxtG[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.tankbartxtB[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
	OptionObjects["OptionYourBarColour"].Text:SetTextColor(HealBot_Plugin_Config.yourbartxtR[HealBot_Plugin.Profile],
					    							       HealBot_Plugin_Config.yourbartxtG[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.yourbartxtB[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
	OptionObjects["OptionTextColour"].Text:SetTextColor(HealBot_Plugin_Config.bartxtR[HealBot_Plugin.Profile],
					    							    HealBot_Plugin_Config.bartxtG[HealBot_Plugin.Profile],
													    HealBot_Plugin_Config.bartxtB[HealBot_Plugin.Profile],
													    HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
	OptionObjects["OptionTankTextColour"].Text:SetTextColor(HealBot_Plugin_Config.tankbartxtR[HealBot_Plugin.Profile],
					    			    				    HealBot_Plugin_Config.tankbartxtG[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.tankbartxtB[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
	OptionObjects["OptionYourTextColour"].Text:SetTextColor(HealBot_Plugin_Config.yourbartxtR[HealBot_Plugin.Profile],
					    			    				    HealBot_Plugin_Config.yourbartxtG[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.yourbartxtB[HealBot_Plugin.Profile],
													        HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_Options_SetHeaderCols()
	OptionObjects["OptionHdrBarColour"]:SetStatusBarColor(HealBot_Plugin_Config.headerR[HealBot_Plugin.Profile],
					    							      HealBot_Plugin_Config.headerG[HealBot_Plugin.Profile],
												  	      HealBot_Plugin_Config.headerB[HealBot_Plugin.Profile],
													      HealBot_Plugin_Config.headerA[HealBot_Plugin.Profile])
	OptionObjects["OptionHdrTextColour"]:SetStatusBarColor(HealBot_Plugin_Config.headerR[HealBot_Plugin.Profile],
					    							       HealBot_Plugin_Config.headerG[HealBot_Plugin.Profile],
												  	       HealBot_Plugin_Config.headerB[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.headerA[HealBot_Plugin.Profile])
	OptionObjects["OptionHdrBarColour"].Text:SetTextColor(HealBot_Plugin_Config.hdrtxtR[HealBot_Plugin.Profile],
					    							      HealBot_Plugin_Config.hdrtxtG[HealBot_Plugin.Profile],
												  	      HealBot_Plugin_Config.hdrtxtB[HealBot_Plugin.Profile],
													      HealBot_Plugin_Config.hdrtxtA[HealBot_Plugin.Profile])
	OptionObjects["OptionHdrTextColour"].Text:SetTextColor(HealBot_Plugin_Config.hdrtxtR[HealBot_Plugin.Profile],
					    							       HealBot_Plugin_Config.hdrtxtG[HealBot_Plugin.Profile],
												  	       HealBot_Plugin_Config.hdrtxtB[HealBot_Plugin.Profile],
													       HealBot_Plugin_Config.hdrtxtA[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_Returned_Colours(R, G, B, A)
    R=HealBot_Comm_round(R,3)
    G=HealBot_Comm_round(G,3)
    B=HealBot_Comm_round(B,3)
	if not A then
		A=1
	else
		A=1-A
	end
    if HealBot_Plugin_luVars["ColourObjWaiting"]=="FrameBack" then
        HealBot_Plugin_Config.frameR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.frameG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.frameB[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.frameA[HealBot_Plugin.Profile] = R, G, B, A;
		OptionObjects["OptionFrameBack"]:SetStatusBarColor(R, G, B, A)
		HealBot_Plugin_Functions["toggleShow"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="FrameBor" then
        HealBot_Plugin_Config.borderR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.borderG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.borderB[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.borderA[HealBot_Plugin.Profile] = R, G, B, A;
		OptionObjects["OptionFrameBor"]:SetStatusBarColor(R, G, B, A)
		HealBot_Plugin_Functions["toggleShow"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="TitleBack" then
        HealBot_Plugin_Config.titlebackR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.titlebackG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.titlebackB[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.titlebackA[HealBot_Plugin.Profile] = R, G, B, A;
		HealBot_Plugin_Options_SetTitleCols()
		HealBot_Plugin_Functions["toggleShow"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="TitleText" then
        HealBot_Plugin_Config.titletextR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.titletextG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.titletextB[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.titletextA[HealBot_Plugin.Profile] = R, G, B, A;
		HealBot_Plugin_Options_SetTitleCols()
		HealBot_Plugin_Functions["toggleShow"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="Bar" then
        HealBot_Plugin_Config.barR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.barG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.barB[HealBot_Plugin.Profile] = R, G, B;
		HealBot_Plugin_Options_SetBarCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="TankBar" then
        HealBot_Plugin_Config.tankbarR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.tankbarG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.tankbarB[HealBot_Plugin.Profile] = R, G, B;
		HealBot_Plugin_Options_SetBarCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="YourBar" then
        HealBot_Plugin_Config.yourbarR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.yourbarG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.yourbarB[HealBot_Plugin.Profile] = R, G, B;
		HealBot_Plugin_Options_SetBarCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="Text" then
        HealBot_Plugin_Config.bartxtR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.bartxtG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.bartxtB[HealBot_Plugin.Profile] = R, G, B;
		HealBot_Plugin_Options_SetBarCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="TankText" then
        HealBot_Plugin_Config.tankbartxtR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.tankbartxtG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.tankbartxtB[HealBot_Plugin.Profile] = R, G, B;
		HealBot_Plugin_Options_SetBarCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="YourText" then
        HealBot_Plugin_Config.yourbartxtR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.yourbartxtG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.yourbartxtB[HealBot_Plugin.Profile] = R, G, B;
		HealBot_Plugin_Options_SetBarCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="HdrBar" then
        HealBot_Plugin_Config.headerR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.headerG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.headerB[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.headerA[HealBot_Plugin.Profile] = R, G, B, A;
		HealBot_Plugin_Options_SetHeaderCols()
		HealBot_Plugin_Functions["updateAll"]()
	elseif HealBot_Plugin_luVars["ColourObjWaiting"]=="HdrText" then
        HealBot_Plugin_Config.hdrtxtR[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.hdrtxtG[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.hdrtxtB[HealBot_Plugin.Profile],
        HealBot_Plugin_Config.hdrtxtA[HealBot_Plugin.Profile] = R, G, B, A;
		HealBot_Plugin_Options_SetHeaderCols()
		HealBot_Plugin_Functions["updateAll"]()
    end
end

HealBot_Plugin_luVars["prevR"] = nil
HealBot_Plugin_luVars["prevG"] = nil
HealBot_Plugin_luVars["prevB"] = nil
HealBot_Plugin_luVars["prevA"] = nil
local function HealBot_Plugin_UseColourPick(R, G, B, A)
    if not R then R=1; end
    if not G then G=1; end
    if not B then B=1; end
    HealBot_Plugin_luVars["prevR"], HealBot_Plugin_luVars["prevG"], HealBot_Plugin_luVars["prevB"], HealBot_Plugin_luVars["prevA"] = R, G, B, A;
    if ColorPickerFrame:IsVisible() then 
        ColorPickerFrame:Hide();
    elseif A then
        ColorPickerFrame.hasOpacity = true;
        ColorPickerFrame.opacity = 1-A;
        ColorPickerFrame.func = function() local lR,lG,lB=ColorPickerFrame:GetColorRGB(); local lA=OpacitySliderFrame:GetValue()  HealBot_Plugin_Returned_Colours(lR,lG,lB,lA); end;
        ColorPickerFrame.opacityFunc = function() local lR,lG,lB=ColorPickerFrame:GetColorRGB(); local lA=OpacitySliderFrame:GetValue() HealBot_Plugin_Returned_Colours(lR,lG,lB,lA); end;
        ColorPickerFrame.cancelFunc = function() HealBot_Plugin_Returned_Colours(HealBot_Plugin_luVars["prevR"], HealBot_Plugin_luVars["prevG"], HealBot_Plugin_luVars["prevB"], 1-HealBot_Plugin_luVars["prevA"]); end;
        ColorPickerFrame:ClearAllPoints();
        ColorPickerFrame:SetPoint("TOPLEFT","HealBot_Options","TOPRIGHT",0,-152);
        OpacitySliderFrame:SetValue(1-A);
        ColorPickerFrame:SetColorRGB(R, G, B);
        ColorPickerFrame:Show();
    else
        ColorPickerFrame.hasOpacity = false;
        ColorPickerFrame.func = function() HealBot_Plugin_Returned_Colours(ColorPickerFrame:GetColorRGB()); end;
        ColorPickerFrame.cancelFunc = function() HealBot_Plugin_Returned_Colours(HealBot_Plugin_luVars["prevR"], HealBot_Plugin_luVars["prevG"], HealBot_Plugin_luVars["prevB"]); end;
        ColorPickerFrame:ClearAllPoints();
        ColorPickerFrame:SetPoint("TOPLEFT","HealBot_Options","TOPRIGHT",0,-152);
        ColorPickerFrame:SetColorRGB(R, G, B);
        ColorPickerFrame:Show();
    end
    return ColorPickerFrame:GetColorRGB();
end

local function HealBot_Plugin_Col(oName)
	HealBot_Plugin_luVars["ColourObjWaiting"]=oName
	if oName=="FrameBack" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.frameR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.frameG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.frameB[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.frameA[HealBot_Plugin.Profile])
	elseif oName=="FrameBor" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.borderR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.borderG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.borderB[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.borderA[HealBot_Plugin.Profile])
	elseif oName=="TitleBack" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.titlebackR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.titlebackG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.titlebackB[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.titlebackA[HealBot_Plugin.Profile])
	elseif oName=="TitleText" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.titletextR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.titletextG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.titletextB[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.titletextA[HealBot_Plugin.Profile])
	elseif oName=="Bar" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.barR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.barG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.barB[HealBot_Plugin.Profile])
	elseif oName=="TankBar" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.tankbarR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.tankbarG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.tankbarB[HealBot_Plugin.Profile])
	elseif oName=="YourBar" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.yourbarR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.yourbarG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.yourbarB[HealBot_Plugin.Profile])
	elseif oName=="Text" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.bartxtR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.bartxtG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.bartxtB[HealBot_Plugin.Profile])
	elseif oName=="TankText" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.tankbartxtR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.tankbartxtG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.tankbartxtB[HealBot_Plugin.Profile])
	elseif oName=="YourText" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.yourbartxtR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.yourbartxtG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.yourbartxtB[HealBot_Plugin.Profile])
	elseif oName=="HdrBar" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.headerR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.headerG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.headerB[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.headerA[HealBot_Plugin.Profile])
	elseif oName=="HdrText" then
        HealBot_Plugin_UseColourPick(HealBot_Plugin_Config.hdrtxtR[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.hdrtxtG[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.hdrtxtB[HealBot_Plugin.Profile],
                                     HealBot_Plugin_Config.hdrtxtA[HealBot_Plugin.Profile])
	end
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

		OptionObjects["OptionFrameBtn"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Frame_Button", HealBot_Plugin_luVars["OptionsFrame"])
		HealBot_Plugin_Options_SetupStatusBarButton(OptionObjects["OptionFrameBtn"], 170, -190, HEALBOT_OPTIONS_FRAME)
		OptionObjects["OptionFrameBtn"]:SetScript("OnMouseDown", function() HealBot_Plugin_Frame_OnClick(OptionObjects["OptionFrameFrm"], OptionObjects["OptionFrameBtn"]); end)
		OptionObjects["OptionBarBtn"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Text_Button", HealBot_Plugin_luVars["OptionsFrame"])
		HealBot_Plugin_Options_SetupStatusBarButton(OptionObjects["OptionBarBtn"], 170, 0, HEALBOT_OPTIONS_TAB_BARS)
		OptionObjects["OptionBarBtn"]:SetScript("OnMouseDown", function() HealBot_Plugin_Frame_OnClick(OptionObjects["OptionBarFrm"], OptionObjects["OptionBarBtn"]); end)
		OptionObjects["OptionTextBtn"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Text_Button", HealBot_Plugin_luVars["OptionsFrame"])
		HealBot_Plugin_Options_SetupStatusBarButton(OptionObjects["OptionTextBtn"], 170, 190, HEALBOT_WORD_TEXT)
		OptionObjects["OptionTextBtn"]:SetScript("OnMouseDown", function() HealBot_Plugin_Frame_OnClick(OptionObjects["OptionTextFrm"], OptionObjects["OptionTextBtn"]); end)
		HealBot_Plugin_luVars["prevFrameBtn"]=OptionObjects["OptionFrameBtn"]
		
		OptionObjects["OptionFrameFrm"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_Frame", HealBot_Plugin_luVars["OptionsFrame"], BackdropTemplateMixin and "BackdropTemplate")
		HealBot_Plugin_Options_SetupFrame(OptionObjects["OptionFrameFrm"])
		OptionObjects["OptionBarFrm"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_Bar", HealBot_Plugin_luVars["OptionsFrame"], BackdropTemplateMixin and "BackdropTemplate")
		HealBot_Plugin_Options_SetupFrame(OptionObjects["OptionBarFrm"], true)
		OptionObjects["OptionTextFrm"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_Text", HealBot_Plugin_luVars["OptionsFrame"], BackdropTemplateMixin and "BackdropTemplate")
		HealBot_Plugin_Options_SetupFrame(OptionObjects["OptionTextFrm"], true)
		
		-- Frame
		OptionObjects["OptionFrameLock"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_Lock", OptionObjects["OptionFrameFrm"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionFrameLock"]:SetPoint("TOPLEFT", 75, -25)
		OptionObjects["OptionFrameLock"]:SetScript("OnClick", function() HealBot_Plugin_Frame_Lock(OptionObjects["OptionFrameLock"]); end)
		
		OptionObjects["OptionFrameOnlyIC"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_Only_InCombat", OptionObjects["OptionFrameFrm"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionFrameOnlyIC"]:SetPoint("TOPLEFT", 75, -70)
		OptionObjects["OptionFrameOnlyIC"]:SetScript("OnClick", function() HealBot_Plugin_Frame_OnlyInCombat(OptionObjects["OptionFrameOnlyIC"]); end)

		OptionObjects["OptionFrameTest"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_Test", OptionObjects["OptionFrameFrm"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionFrameTest"]:SetPoint("TOP", 55, -25)
		OptionObjects["OptionFrameTest"]:SetScript("OnClick", function() HealBot_Plugin_Frame_Test(OptionObjects["OptionFrameTest"]); end)
		
		OptionObjects["OptionFrameProfile"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_Profile", OptionObjects["OptionFrameFrm"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionFrameProfile"]:SetPoint("TOP", 55, -70)
		OptionObjects["OptionFrameProfile"]:SetScript("OnClick", function() HealBot_Plugin_Frame_Profile(OptionObjects["OptionFrameProfile"]); end)
		
		OptionObjects["OptionFrameTitleText"] = CreateFrame("EditBox", "HealBot_"..pId.."_Options_FrameTitleText", OptionObjects["OptionFrameFrm"], "HealBot_Options_EditBoxTemplate")
		HealBot_Plugin_Options_Setup_EditBox(OptionObjects["OptionFrameTitleText"],OptionObjects["OptionFrameFrm"], 0, -140, HEALBOT_OPTIONS_FRAME_TITLE, HealBot_Plugin_Config.titletext[HealBot_Plugin.Profile])
		OptionObjects["OptionFrameTitleText"]:SetScript("OnTextChanged", function() HealBot_Plugin_Frame_TitleText_Change(OptionObjects["OptionFrameTitleText"]); end)
		
		OptionObjects["OptionFrameTitleBack"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_FrameTitleBack", OptionObjects["OptionFrameFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionFrameTitleBack"], 225, 30, -135, -180, HEALBOT_OPTIONS_FRAME_TITLE.." "..HEALBOT_SKIN_BACKTEXT)
		OptionObjects["OptionFrameTitleBack"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("TitleBack"); end)
		OptionObjects["OptionFrameTitleTextCol"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_FrameTitleTextCol", OptionObjects["OptionFrameFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionFrameTitleTextCol"], 225, 30, 135, -180, HEALBOT_OPTIONS_FRAME_TITLE.." "..HEALBOT_WORD_TEXT)
		OptionObjects["OptionFrameTitleTextCol"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("TitleText"); end)
		
		OptionObjects["OptionFrameBack"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_FrameBack", OptionObjects["OptionFrameFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionFrameBack"], 225, 30, -135, -240, HEALBOT_OPTIONS_FRAME.." "..HEALBOT_SKIN_BACKTEXT)
		OptionObjects["OptionFrameBack"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("FrameBack"); end)
		OptionObjects["OptionFrameBor"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_FrameBor", OptionObjects["OptionFrameFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionFrameBor"], 225, 30, 135, -240, HEALBOT_OPTIONS_FRAME.." "..HEALBOT_SKIN_BORDERTEXT)
		OptionObjects["OptionFrameBor"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("FrameBor"); end)

		OptionObjects["OptionFrameWidth"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_FrameWidth", OptionObjects["OptionFrameFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionFrameWidth"], "TOP", 500, 0, -340)
		OptionObjects["OptionFrameWidth"]:SetScript("OnValueChanged", function() HealBot_Plugin_Frame_Width_OnValueChanged(OptionObjects["OptionFrameWidth"]); end)
		
		OptionObjects["OptionFrameFluidBars"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_FluidBars", OptionObjects["OptionFrameFrm"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionFrameFluidBars"]:SetPoint("TOPLEFT", 50, -401)
		OptionObjects["OptionFrameFluidBars"]:SetScript("OnClick", function() HealBot_Plugin_Frame_FluidBars_OnClick(OptionObjects["OptionFrameFluidBars"]); end)
		OptionObjects["OptionFrameFluidBarsValue"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_FluidBarsValue", OptionObjects["OptionFrameFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionFrameFluidBarsValue"], "TOPLEFT", 350, 190, -405)
		OptionObjects["OptionFrameFluidBarsValue"]:SetScript("OnValueChanged", function() HealBot_Plugin_Frame_FluidBarsValue_OnValueChanged(OptionObjects["OptionFrameFluidBarsValue"]); end)
		
		
		-- Bars
		OptionObjects["OptionBarColourType"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_BarColType", OptionObjects["OptionBarFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionBarColourType"], 70, -220, -40, HEALBOT_SKIN_RAIDBARCOL)
		OptionObjects["OptionBarColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_BarCol", OptionObjects["OptionBarFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionBarColour"], 70, 21, -220, -70, HEALBOT_CLASSES_CUSTOM)
		OptionObjects["OptionBarColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("Bar"); end)
		
		OptionObjects["OptionTankBarColourType"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_TankBarColType", OptionObjects["OptionBarFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionTankBarColourType"], 70, -120, -40, HEALBOT_SKIN_TANKBARCOL)
		OptionObjects["OptionTankBarColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_TankBarCol", OptionObjects["OptionBarFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionTankBarColour"], 70, 21, -120, -70, HEALBOT_CLASSES_CUSTOM)
		OptionObjects["OptionTankBarColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("TankBar"); end)
		
		OptionObjects["OptionYourBarColourType"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_YourBarColType", OptionObjects["OptionBarFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionYourBarColourType"], 70, -20, -40, HEALBOT_SKIN_YOURBARCOL)
		OptionObjects["OptionYourBarColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_YourBarCol", OptionObjects["OptionBarFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionYourBarColour"], 70, 21, -20, -70, HEALBOT_CLASSES_CUSTOM)
		OptionObjects["OptionYourBarColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("YourBar"); end)
		
		OptionObjects["OptionBarColourA"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_BarColourA", OptionObjects["OptionBarFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionBarColourA"], "TOP", 195, 150, -47)
		OptionObjects["OptionBarColourA"]:SetScript("OnValueChanged", function() HealBot_Plugin_BarColourA_OnValueChanged(OptionObjects["OptionBarColourA"]); end)

		OptionObjects["OptionBarMax"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_BarMax", OptionObjects["OptionBarFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionBarMax"], "TOP", 500, 0, -120)
		OptionObjects["OptionBarMax"]:SetScript("OnValueChanged", function() HealBot_Plugin_BarMax_OnValueChanged(OptionObjects["OptionBarMax"]); end)
		OptionObjects["OptionBarTexture"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_BarTexture", OptionObjects["OptionBarFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionBarTexture"], "TOP", 500, 0, -180)
		OptionObjects["OptionBarTexture"]:SetScript("OnValueChanged", function() HealBot_Plugin_BarTexture_OnValueChanged(OptionObjects["OptionBarTexture"]); end)
		OptionObjects["OptionBarHeight"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_BarHeight", OptionObjects["OptionBarFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionBarHeight"], "TOP", 500, 0, -240)
		OptionObjects["OptionBarHeight"]:SetScript("OnValueChanged", function() HealBot_Plugin_BarHeight_OnValueChanged(OptionObjects["OptionBarHeight"]); end)
		OptionObjects["OptionBarRowS"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_BarRowS", OptionObjects["OptionBarFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionBarRowS"], "TOP", 500, 0, -300)
		OptionObjects["OptionBarRowS"]:SetScript("OnValueChanged", function() HealBot_Plugin_BarRowS_OnValueChanged(OptionObjects["OptionBarRowS"]); end)
		
		
		OptionObjects["OptionBarMinThreatPct"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_MinThreatPct", OptionObjects["OptionBarFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionBarMinThreatPct"], "TOP", 500, 0, -360)
		OptionObjects["OptionBarMinThreatPct"]:SetScript("OnValueChanged", function() HealBot_Plugin_OptionBarMinThreatPct_OnValueChanged(OptionObjects["OptionBarMinThreatPct"]); end)
		
		OptionObjects["OptionHdrBarColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_HdrBarCol", OptionObjects["OptionBarFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionHdrBarColour"], 200, 25, 0, -405, HEALBOT_PLUGIN_THREATMOBBARCOL)
		OptionObjects["OptionHdrBarColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("HdrBar"); end)

		-- Text
		OptionObjects["OptionTextColourType"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_TextColType", OptionObjects["OptionTextFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionTextColourType"], 70, -220, -40, HEALBOT_SKIN_RAIDBARCOL)
		OptionObjects["OptionTextColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_TextCol", OptionObjects["OptionTextFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionTextColour"], 70, 21, -220, -70, HEALBOT_CLASSES_CUSTOM)
		OptionObjects["OptionTextColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("Text"); end)
		
		OptionObjects["OptionTankTextColourType"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_TankTextColType", OptionObjects["OptionTextFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionTankTextColourType"], 70, -120, -40, HEALBOT_SKIN_TANKBARCOL)
		OptionObjects["OptionTankTextColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_TankTextCol", OptionObjects["OptionTextFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionTankTextColour"], 70, 21, -120, -70, HEALBOT_CLASSES_CUSTOM)
		OptionObjects["OptionTankTextColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("TankText"); end)
		
		OptionObjects["OptionYourTextColourType"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_YourTextColType", OptionObjects["OptionTextFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionYourTextColourType"], 70, -20, -40, HEALBOT_SKIN_YOURBARCOL)
		OptionObjects["OptionYourTextColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_YourTextCol", OptionObjects["OptionTextFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionYourTextColour"], 70, 21, -20, -70, HEALBOT_CLASSES_CUSTOM)
		OptionObjects["OptionYourTextColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("YourText"); end)
		
		OptionObjects["OptionTextColourA"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_TextColourA", OptionObjects["OptionTextFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionTextColourA"], "TOP", 195, 150, -47)
		OptionObjects["OptionTextColourA"]:SetScript("OnValueChanged", function() HealBot_Plugin_TextColourA_OnValueChanged(OptionObjects["OptionTextColourA"]); end)

		OptionObjects["OptionTextFont"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_TextFont", OptionObjects["OptionTextFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionTextFont"], "TOP", 500, 0, -130)
		OptionObjects["OptionTextFont"]:SetScript("OnValueChanged", function() HealBot_Plugin_TextFont_OnValueChanged(OptionObjects["OptionTextFont"]); end)
		OptionObjects["OptionTextFontSize"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_TextFontSize", OptionObjects["OptionTextFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionTextFontSize"], "TOP", 500, 0, -190)
		OptionObjects["OptionTextFontSize"]:SetScript("OnValueChanged", function() HealBot_Plugin_TextFontSize_OnValueChanged(OptionObjects["OptionTextFontSize"]); end)
		OptionObjects["OptionTextFontChars"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_TextFontChar", OptionObjects["OptionTextFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionTextFontChars"], "TOP", 500, 0, -250)
		OptionObjects["OptionTextFontChars"]:SetScript("OnValueChanged", function() HealBot_Plugin_TextFontChars_OnValueChanged(OptionObjects["OptionTextFontChars"]); end)	

		OptionObjects["OptionTextOutline"] = CreateFrame("Frame", "HealBot_"..pId.."_Options_TextOutline", OptionObjects["OptionTextFrm"], "UIDropDownMenuTemplate")
		HealBot_Plugin_Options_SetupDropDown(OptionObjects["OptionTextOutline"], 125, 0, -300, HEALBOT_OPTIONS_SKINFOUTLINE)

		OptionObjects["OptionHdrTextColour"] = CreateFrame("StatusBar", "HealBot_"..pId.."_Options_HdrTextCol", OptionObjects["OptionTextFrm"])
		HealBot_Plugin_Options_SetupStatusBar(OptionObjects["OptionHdrTextColour"], 200, 25, 0, -355, HEALBOT_PLUGIN_THREATMOBTEXTCOL)
		OptionObjects["OptionHdrTextColour"]:SetScript("OnMouseDown", function() HealBot_Plugin_Col("HdrText"); end)
		OptionObjects["OptionHdrTextFontChars"] = CreateFrame("Slider", "HealBot_"..pId.."_Options_TextFontMobChar", OptionObjects["OptionTextFrm"], "OptionsSliderTemplate")
		HealBot_Plugin_Options_SetupSlider(OptionObjects["OptionHdrTextFontChars"], "TOP", 500, 0, -420)
		OptionObjects["OptionHdrTextFontChars"]:SetScript("OnValueChanged", function() HealBot_Plugin_HdrTextFontChars_OnValueChanged(OptionObjects["OptionHdrTextFontChars"]); end)
		
		if not HealBot_Bar_TexturesIndex[HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]] then
			HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]=HealBot_Default_Textures[8].name
		end
		if not HealBot_FontsIndex[HealBot_Plugin_Config.font[HealBot_Plugin.Profile]] then
			HealBot_Plugin_Config.font[HealBot_Plugin.Profile]=HealBot_Default_Font
		end
		HealBot_Plugin_luVars["optionsInit"]=true
	end
	local r,g,b=HealBot_Options_OptionsThemeCols()
	HealBot_Options_SetText(OptionObjects["OptionUse"], " Enable Plugin")
	HealBot_Options_SetText(OptionObjects["OptionFrameLock"], HEALBOT_OPTIONS_ACTIONLOCKED)
	HealBot_Options_SetText(OptionObjects["OptionFrameTest"], HEALBOT_OPTION_TESTMODE)
	HealBot_Options_SetText(OptionObjects["OptionFrameProfile"], HEALBOT_WORDS_GLOBALPROFILE)
	HealBot_Options_SetText(OptionObjects["OptionFrameOnlyIC"], HEALBOT_OPTIONS_ONLYONDEMAND)
	HealBot_Options_SetText(OptionObjects["OptionFrameFluidBars"], HEALBOT_OPTION_USEFLUIDBARS)
	HealBot_Options_sliderlabels_Init(OptionObjects["OptionFrameFluidBarsValue"],HEALBOT_OPTION_BARUPDFREQ,1,19,1,2,HEALBOT_OPTIONS_WORD_SLOWER,HEALBOT_OPTIONS_WORD_FASTER)
	OptionObjects["OptionFrameFluidBarsValue"]:SetValue(HealBot_Plugin_Config.fluidfreq[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionFrameFluidBarsValue"], HEALBOT_OPTION_BARUPDFREQ)
	OptionObjects["OptionFrameOnlyIC"]:SetChecked(HealBot_Plugin_Config.OnlyShowOnDemand[HealBot_Plugin.Profile])
	OptionObjects["OptionFrameFluidBars"]:SetChecked(HealBot_Plugin_Config.fluidbars[HealBot_Plugin.Profile])
	OptionObjects["OptionFrameLock"]:SetChecked(HealBot_Plugin_Config.frameLocked[HealBot_Plugin.Profile])
	if HealBot_Plugin.Profile=="Global" then
		OptionObjects["OptionFrameProfile"]:SetChecked(true)
	else
		OptionObjects["OptionFrameProfile"]:SetChecked(false)
	end
	OptionObjects["OptionTextFrm"]:SetBackdropBorderColor(r,g,b,0.7)
	OptionObjects["OptionBarFrm"]:SetBackdropBorderColor(r,g,b,0.7)
	OptionObjects["OptionFrameFrm"]:SetBackdropBorderColor(r,g,b,0.7)
	OptionObjects["OptionFrameBtn"]:SetStatusBarColor(r, g, b, 0.5)
	OptionObjects["OptionFrameBtn"].Text:SetTextColor(r, g, b, 0.8)
	OptionObjects["OptionBarBtn"]:SetStatusBarColor(r, g, b, 0.5)
	OptionObjects["OptionBarBtn"].Text:SetTextColor(r, g, b, 0.8)
	OptionObjects["OptionTextBtn"]:SetStatusBarColor(r, g, b, 0.5)
	OptionObjects["OptionTextBtn"].Text:SetTextColor(r, g, b, 0.8)
	HealBot_Plugin_luVars["prevFrameBtn"]:SetStatusBarColor(r, g, b, 1)
	HealBot_Plugin_luVars["prevFrameBtn"].Text:SetTextColor(1, 1, 1, 1)
	HealBot_Options_val_OnLoad(OptionObjects["OptionFrameWidth"],HEALBOT_OPTIONS_SKINWIDTH,100,500,5,5)
	OptionObjects["OptionFrameWidth"]:SetValue(HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionFrameWidth"],HEALBOT_OPTIONS_SKINWIDTH..": "..HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile])
	HealBot_Options_val_OnLoad(OptionObjects["OptionBarMax"],HEALBOT_OPTIONS_MAXBARS,5,40,1,5)
	OptionObjects["OptionBarMax"]:SetValue(HealBot_Plugin_Config.maxBars[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionBarMax"],HEALBOT_OPTIONS_MAXBARS..": "..HealBot_Plugin_Config.maxBars[HealBot_Plugin.Profile])
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionFrameTitleText"].Txt, HEALBOT_OPTIONS_FRAME_TITLE)
	HealBot_Options_val_OnLoad(OptionObjects["OptionBarTexture"],HEALBOT_OPTIONS_SKINTEXTURE,1,#HealBot_Bar_Textures,1)
	OptionObjects["OptionBarTexture"]:SetValue(HealBot_Bar_TexturesIndex[HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]])
	HealBot_Options_SetText(OptionObjects["OptionBarTexture"],HEALBOT_OPTIONS_SKINTEXTURE.." "..HealBot_Bar_TexturesIndex[HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]]..": "..HealBot_Plugin_Config.texture[HealBot_Plugin.Profile])
	HealBot_Options_val_OnLoad(OptionObjects["OptionBarHeight"],HEALBOT_OPTIONS_SKINHEIGHT,10,40,1)
	OptionObjects["OptionBarHeight"]:SetValue(HealBot_Plugin_Config.height[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionBarHeight"],HEALBOT_OPTIONS_SKINHEIGHT..": "..HealBot_Plugin_Config.height[HealBot_Plugin.Profile])
	HealBot_Options_val_OnLoad(OptionObjects["OptionBarRowS"],HEALBOT_OPTIONS_SKINBRSPACE,0,5,1)
	OptionObjects["OptionBarRowS"]:SetValue(HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionBarRowS"],HEALBOT_OPTIONS_SKINBRSPACE..": "..HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
	HealBot_Options_val_OnLoad(OptionObjects["OptionTextFont"],HEALBOT_OPTIONS_SKINFONT,1,#HealBot_Fonts,1)
	OptionObjects["OptionTextFont"]:SetValue(HealBot_FontsIndex[HealBot_Plugin_Config.font[HealBot_Plugin.Profile]])
	HealBot_Options_SetText(OptionObjects["OptionTextFont"],HEALBOT_OPTIONS_SKINFONT.." "..HealBot_FontsIndex[HealBot_Plugin_Config.font[HealBot_Plugin.Profile]]..": "..HealBot_Plugin_Config.font[HealBot_Plugin.Profile])
	HealBot_Options_val_OnLoad(OptionObjects["OptionTextFontSize"],HEALBOT_OPTIONS_SKINFHEIGHT,7,18,1)
	OptionObjects["OptionTextFontSize"]:SetValue(HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionTextFontSize"],HEALBOT_OPTIONS_SKINFHEIGHT..": "..HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile])
	HealBot_Options_val_OnLoad(OptionObjects["OptionTextFontChars"],HEALBOT_OPTIONS_PLAYERMAXCHARS,0,30,1)
	OptionObjects["OptionTextFontChars"]:SetValue(HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile])
	if HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile]==0 then
		HealBot_Options_SetText(OptionObjects["OptionTextFontChars"],HEALBOT_OPTIONS_PLAYERMAXCHARS..": "..HEALBOT_WORD_AUTO)
	else
		HealBot_Options_SetText(OptionObjects["OptionTextFontChars"],HEALBOT_OPTIONS_PLAYERMAXCHARS..": "..HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile])
	end
	HealBot_Options_val_OnLoad(OptionObjects["OptionHdrTextFontChars"],HEALBOT_OPTIONS_MOBMAXCHARS,0,30,1)
	OptionObjects["OptionHdrTextFontChars"]:SetValue(HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile])
	if HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile]==0 then
		HealBot_Options_SetText(OptionObjects["OptionHdrTextFontChars"],HEALBOT_OPTIONS_MOBMAXCHARS..": "..HEALBOT_WORD_AUTO)
	else
		HealBot_Options_SetText(OptionObjects["OptionHdrTextFontChars"],HEALBOT_OPTIONS_MOBMAXCHARS..": "..HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile])
	end
	HealBot_Options_Pct_OnLoad_MinMax(OptionObjects["OptionBarColourA"],HEALBOT_OPTIONS_TTALPHA,0,1,0.01)
	OptionObjects["OptionBarColourA"]:SetValue(HealBot_Plugin_Config.barA[HealBot_Plugin.Profile]);
	HealBot_Options_Pct_OnValueChanged(OptionObjects["OptionBarColourA"])
	HealBot_Options_Pct_OnLoad_MinMax(OptionObjects["OptionTextColourA"],HEALBOT_OPTIONS_TTALPHA,0,1,0.01)
	OptionObjects["OptionTextColourA"]:SetValue(HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile]);
	HealBot_Options_Pct_OnValueChanged(OptionObjects["OptionTextColourA"])
	HealBot_Options_val_OnLoad(OptionObjects["OptionBarMinThreatPct"],HEALBOT_PLUGIN_THREATPCT,1,25,1)
	OptionObjects["OptionBarMinThreatPct"]:SetValue(HealBot_Plugin_Config.minthreatpct[HealBot_Plugin.Profile])
	HealBot_Options_SetText(OptionObjects["OptionBarMinThreatPct"],HEALBOT_PLUGIN_THREATPCT..": "..HealBot_Plugin_Config.minthreatpct[HealBot_Plugin.Profile].."%")
	UIDropDownMenu_Initialize(OptionObjects["OptionBarColourType"], OptionBarColourType_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionBarColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]])
	UIDropDownMenu_Initialize(OptionObjects["OptionTankBarColourType"], OptionTankBarColourType_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionTankBarColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]])
	UIDropDownMenu_Initialize(OptionObjects["OptionYourBarColourType"], OptionYourBarColourType_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionYourBarColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]])
	UIDropDownMenu_Initialize(OptionObjects["OptionTextColourType"], OptionTextColourType_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionTextColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]])
	UIDropDownMenu_Initialize(OptionObjects["OptionTankTextColourType"], OptionTankTextColourType_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionTankTextColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]])
	UIDropDownMenu_Initialize(OptionObjects["OptionYourTextColourType"], OptionYourTextColourType_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionYourTextColourType"],HealBot_Plugin_ColourList[HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]])
	UIDropDownMenu_Initialize(OptionObjects["OptionTextOutline"], OptionTextOutline_DropDown)
	UIDropDownMenu_SetText(OptionObjects["OptionTextOutline"],HealBot_Plugin_FontOutlineList[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionBarColourType"].Txt, HEALBOT_SKIN_RAIDBARCOL)
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionTankBarColourType"].Txt, HEALBOT_SKIN_TANKBARCOL)
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionYourBarColourType"].Txt, HEALBOT_SKIN_YOURBARCOL)
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionTextColourType"].Txt, HEALBOT_SKIN_RAIDBARCOL)
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionTankTextColourType"].Txt, HEALBOT_SKIN_TANKBARCOL)
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionYourTextColourType"].Txt, HEALBOT_SKIN_YOURBARCOL)
	HealBot_Plugin_Options_SetLabel(OptionObjects["OptionTextOutline"].Txt, HEALBOT_OPTIONS_SKINFOUTLINE)

	OptionObjects["OptionFrameBack"]:SetStatusBarColor(HealBot_Plugin_Config.frameR[HealBot_Plugin.Profile],
                                                       HealBot_Plugin_Config.frameG[HealBot_Plugin.Profile],
                                                       HealBot_Plugin_Config.frameB[HealBot_Plugin.Profile],
                                                       HealBot_Plugin_Config.frameA[HealBot_Plugin.Profile])
	OptionObjects["OptionFrameBor"]:SetStatusBarColor(HealBot_Plugin_Config.borderR[HealBot_Plugin.Profile],
                                                      HealBot_Plugin_Config.borderG[HealBot_Plugin.Profile],
                                                      HealBot_Plugin_Config.borderB[HealBot_Plugin.Profile],
                                                      HealBot_Plugin_Config.borderA[HealBot_Plugin.Profile])
													  			  
	HealBot_Plugin_Options_SetTitleCols()
	HealBot_Plugin_Options_SetBarCols()
	HealBot_Plugin_Options_SetHeaderCols()
end

function HealBot_Plugin_Threat_Options()
	HealBot_Plugin_Threat_Init()
	HealBot_Plugin_Options_Threat()
	if not HealBot_Plugin_luVars["optionsInit"] then
		local pId=HealBot_Plugin_luVars["pluginId"]
		OptionObjects["OptionUse"] = CreateFrame("CheckButton", "HealBot_"..pId.."_Frame_Use", HealBot_Plugin_luVars["OptionsFrame"], "OptionsCheckButtonTemplate")
		OptionObjects["OptionUse"]:SetPoint("TOP", -40, -40)
		OptionObjects["OptionUse"]:SetScript("OnClick", function() HealBot_Plugin_OnClick(OptionObjects["OptionUse"]); end)
		OptionObjects["OptionUse"]:SetChecked(HealBot_Globals.PluginThreat)		
	end
	HealBot_Plugin_Options()
	HealBot_Plugin_InUse()
end