local pFrame, pFrameTitle, pFrameTitleText
local HealBot_Plugin_luVars={}
local HealBot_Plugin_Config={}
local HealBot_Plugin={}
local LSM = HealBot_Libs_LSM()
local pBars={}
local pHdrs={}
local pBarsValueUp={}
local pBarsValueDown={}
local TimeNow=GetTime()

HealBot_Plugin_luVars["frameInit"]=false
HealBot_Plugin_luVars["maxBars"]=0
HealBot_Plugin_luVars["testMode"]=false
HealBot_Plugin_luVars["barsUpActive"]=false
HealBot_Plugin_luVars["barsDownActive"]=false
local pId="Threat"

local hbBarTextLen={[1]=10,[2]=10}
local hbFontVal={ ["Accidental Presidency"]=3,
                  ["Alba Super"]=1.4,
                  ["Anime Ace"]=1,
                  ["Ariel Narrow"]=3,
                  ["Blazed"]=1.1,
                  ["Designer Block"]=1.7,
                  ["DestructoBeam BB"]=1.4,
                  ["Diogenes"]=2.1,
                  ["Disko"]=1.9,
                  ["DreamSpeak"]=3,
                  ["Drummon"]=1.5,
                  ["Dustismo"]=1.9,
                  ["Electrofied"]=1.1,
                  ["Emblem"]=1.7,
                  ["Frakturika Spamless"]=2.4,
                  ["Friz Quadrata TT"]=1.6,
                  ["Impact"]=2,
                  ["Liberation Sans"]=1.6,
                  ["Liberation Serif"]=1.8,
                  ["Morpheus"]=1.9,
                  ["Mystic Orbs"]=1.2,
                  ["Pokemon Solid"]=1.9,
                  ["Rock Show Whiplash"]=2.4,
                  ["SF Diego Sans"]=1.5,
                  ["SF Laundromatic"]=3,
                  ["Skurri"]=2.2,
                  ["Solange"]=1.4,
                  ["Star Cine"]=1,
                  ["Trashco"]=1.6,
                  ["Waltograph UI"]=1,
                  ["X360"]=1.4,
                  ["Zekton"]=1.6,
 }
local vSetTextLenWidthAdj,vSetTextLenFontAdj=1.1,0
local function HealBot_Plugin_SetTextLen()
    if HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile]==0 then
        vSetTextLenFontAdj=hbFontVal[HealBot_Plugin_Config.font[HealBot_Plugin.Profile]] or 2
        hbBarTextLen[1] = floor((vSetTextLenFontAdj*2)+((HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile]*vSetTextLenWidthAdj)
                                /(HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile])))-12
		if hbBarTextLen[1]<1 then hbBarTextLen[1]=1 end
    else
        hbBarTextLen[1] = HealBot_Plugin_Config.playertxtchars[HealBot_Plugin.Profile]
    end
    if HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile]==0 then
        vSetTextLenFontAdj=hbFontVal[HealBot_Plugin_Config.font[HealBot_Plugin.Profile]] or 2
        hbBarTextLen[2] = floor((vSetTextLenFontAdj*2)+((HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile]*vSetTextLenWidthAdj)
                                /(HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile])))
    else
        hbBarTextLen[2] = HealBot_Plugin_Config.mobtxtchars[HealBot_Plugin.Profile]
    end
end

local function HealBot_Plugin_Name(name, idx)
	if string.len(name)>hbBarTextLen[idx] then
		name=string.sub(name,1,hbBarTextLen[idx]).."."
	end
	return name
end

local function HealBot_Plugin_SetPoint(new)
	local fTop=HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile]
	local fLeft=HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile]
	if new then
		fTop=pFrame:GetTop() or HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile]
		fLeft=pFrame:GetLeft() or HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile]
	end
	if fTop>GetScreenHeight() then fTop=GetScreenHeight(); end
	if fTop<pFrame:GetHeight() then fTop=pFrame:GetHeight(); end
	if fLeft>GetScreenWidth()-pFrame:GetWidth() then fLeft=GetScreenWidth()-pFrame:GetWidth() end
	if fLeft<0 then fLeft=0 end
	HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile] = ceil(fTop)
	HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile] = ceil(fLeft)
	pFrame:ClearAllPoints()
	pFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",
	                     HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile],
						 HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile]);
end

local function HealBot_Plugin_UpdateTitle()
	pFrameTitleText:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
                                             HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile])
	pFrameTitleText:SetText(HealBot_Plugin_Config.titletext[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_SetTitle()
    pFrameTitle=CreateFrame("StatusBar", "HealBot_"..pId.."_FrameTitle", pFrame)
	pFrameTitle:SetPoint("TOPLEFT",pFrame, 2, -2)
    pFrameTitle:SetHeight(19)
    pFrameTitle:SetWidth(HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile]-4)
	pFrameTitle:SetStatusBarTexture("Interface\\AddOns\\HealBot\\Images\\bar8.tga")
	pFrameTitleText=pFrameTitle:CreateFontString("HealBot_"..pId.."_FrameTitleText", "OVERLAY", "GameFontNormal")
	pFrameTitleText:SetPoint("TOP", pFrameTitle, "TOP", 0, -4)
	HealBot_Plugin_Threat_SetTitleCol()
	HealBot_Plugin_UpdateTitle()
end

local function HealBot_Plugin_OnMouseDown(self, button)
    if not HealBot_Plugin_Config.frameLocked[HealBot_Plugin.Profile] then
		if button=="LeftButton" and not pFrame.isMoving then
			pFrame:StartMoving();
			pFrame.isMoving = true;
		end
    end
end

local function HealBot_Plugin_OnMouseUp(self, button)
    if button=="LeftButton" and pFrame.isMoving then
		pFrame:StopMovingOrSizing();
		pFrame.isMoving = false;
		local fTop=pFrame:GetTop()
		local fLeft=pFrame:GetLeft()
		if (fTop>GetScreenHeight()) or 
		   (fTop<pFrame:GetHeight()) or 
		   (fLeft>GetScreenWidth()-pFrame:GetWidth()) or 
		   (fLeft<0) then 
			HealBot_Plugin_SetPoint(true)
		else
			HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile] = ceil(fTop)
			HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile] = ceil(fLeft)
		end
    elseif button=="RightButton" and not HealBot_Data["UILOCK"] and HealBot_Globals.RightButtonOptions then
        HealBot_Action_OptionsButton_OnClick();
    end
end

local function HealBot_Plugin_UpdateUsedMedia(mediatype, key)
    if mediatype == "statusbar" then
		for f=1,40 do
			if pBars[f] then
				pBars[f]:SetStatusBarTexture(LSM:Fetch('statusbar',HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]))
			else
				break
			end
		end
		for f=1,20 do
			if pHdrs[f] then
				pHdrs[f]:SetStatusBarTexture(LSM:Fetch('statusbar',HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]))
			else
				break
			end
		end
    elseif mediatype == "font" then
		for f=1,40 do
			if pBars[f] then
				pBars[f].TextL:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
											HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile],
											HealBot_Font_Outline[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
				pBars[f].TextR:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
											HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile],
											HealBot_Font_Outline[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
			else
				break
			end
		end
		for f=1,20 do
			if pHdrs[f] then
				pHdrs[f].TextC:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
											HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile],
											HealBot_Font_Outline[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
			else
				break
			end
		end
    end
end

function HealBot_Plugin_Threat_Init()
	if not HealBot_Plugin_luVars["pluginInit"] then
		table.foreach(HealBot_Plugin_ThreatDefaults, function (key,val)
			if HealBot_Plugin_Threat[key]==nil then
				HealBot_Plugin_Threat[key] = val;
			end
		end);
		table.foreach(HealBot_Plugin_Threat_ConfigDefaults, function (key,val)
			if HealBot_Plugin_Threat_Config[key]==nil then
				HealBot_Plugin_Threat_Config[key] = val;
			end
		end);
		HealBot_Plugin_Config=HealBot_Plugin_Threat_Config
		HealBot_Plugin=HealBot_Plugin_Threat
		if HealBot_Plugin.Profile~="Global" then 
			HealBot_Plugin.Profile=UnitName("player") 
			table.foreach(HealBot_Plugin_Threat_ConfigDefaults, function (key,val)
				if HealBot_Plugin_Config[key][HealBot_Plugin.Profile]==nil then
					HealBot_Plugin_Config[key][HealBot_Plugin.Profile]=HealBot_Plugin_Config[key]["Global"];
				end
			end);
		end
		
		pFrame=CreateFrame("Frame", "HealBot_Threat_Frame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
		pFrame:SetBackdrop({
			bgFile = "Interface\\Addons\\HealBot\\Images\\WhiteLine",
			edgeFile = "Interface\\Addons\\HealBot\\Images\\border",
			tile = true,
			tileSize = 8,
			edgeSize = 8,
			insets = { left = 3, right = 3, top = 3, bottom = 3, },
		})
		pFrame:SetMovable(true)
		pFrame:EnableMouse(true)
		pFrame:SetScript("OnMouseDown", function(self, button) HealBot_Plugin_OnMouseDown(self, button) end)
		pFrame:SetScript("OnMouseUp", function(self, button) HealBot_Plugin_OnMouseUp(self, button) end)

		pFrame:SetWidth(HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile])
		if HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile]==-1 then
			HealBot_Plugin_Config.frameX[HealBot_Plugin.Profile]=10
		end
		if HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile]==-1 then
			HealBot_Plugin_Config.frameY[HealBot_Plugin.Profile]=HealBot_Comm_round(GetScreenHeight()/2,0)+130
		end            
        LSM.RegisterCallback(HEALBOT_HEALBOT..pId, "LibSharedMedia_SetGlobal", function(mediatype, key) HealBot_Plugin_UpdateUsedMedia(mediatype, key) end)
		HealBot_Plugin_SetTitle()
		HealBot_Plugin_Threat_HidePanel()
		HealBot_Plugin_luVars["pluginInit"]=true
	end
	HealBot_Plugin_Threat_UpdateAll()
	if HealBot_Globals.PluginThreat then HealBot_setOptions_Timer(3100) end
end

local hbp_tConcat={}

local hbp_unitInfo={}
local hbp_unitSort={}
local hbp_mobrt={}
local hbp_mobName=""
local hbp_numMobs=0
local hbp_mobChange=true
local hbp_curBar=0
local hbp_prevMaxHdr=1
local hbp_prevMaxBar=1
local hbp_lastUpdate=TimeNow
local units={}

function HealBot_Plugin_Threat_UpdateMobRT(name, rt)
	hbp_mobrt[name]=rt
end

local function HealBot_Plugin_Concat(elements)
    return table.concat(hbp_tConcat,"",1,elements)
end

local scpR, scpG=1,1 
local function HealBot_Plugin_StatusColourPct(status)
    scpR, scpG = 1,1
	status=status/100
    if status>=0.98 then 
        scpG=0
    elseif status<0.98 and status>=0.65 then 
        scpG=2.94-(status*3)
    elseif status<=0.64 and status>0.31 then 
		scpR=(status-0.31)*3
    elseif status<=0.31 then 
		scpR=0
    end
    return scpR, scpG
end

local stcR, stcG=1,1
local function HealBot_Plugin_SetTextCols(bar, r, g, b, ttd)
	if bar.role>1 then
		if HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]==1 then
			bar.TextL:SetTextColor(r, g, b, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(r, g, b, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		elseif HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]==2 then
			stcR, stcG=HealBot_Plugin_StatusColourPct(ttd)
			bar.TextL:SetTextColor(stcR, stcG, 0, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(stcR, stcG, 0, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		else
			bar.TextL:SetTextColor(HealBot_Plugin_Config.bartxtR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(HealBot_Plugin_Config.bartxtR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		end
	elseif bar.role==1 then
		if HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]==1 then
			bar.TextL:SetTextColor(r, g, b, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(r, g, b, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		elseif HealBot_Plugin_Config.tanktxtcoltype[HealBot_Plugin.Profile]==2 then
			stcR, stcG=HealBot_Plugin_StatusColourPct(ttd)
			bar.TextL:SetTextColor(stcR, stcG, 0, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(stcR, stcG, 0, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		else
			bar.TextL:SetTextColor(HealBot_Plugin_Config.tankbartxtR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.tankbartxtG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.tankbartxtB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(HealBot_Plugin_Config.tankbartxtR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.tankbartxtG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.tankbartxtB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		end
	else
		if HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]==1 then
			bar.TextL:SetTextColor(r, g, b, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(r, g, b, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		elseif HealBot_Plugin_Config.yourtxtcoltype[HealBot_Plugin.Profile]==2 then
			stcR, stcG=HealBot_Plugin_StatusColourPct(ttd)
			bar.TextL:SetTextColor(stcR, stcG, 0, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(stcR, stcG, 0, HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		else
			bar.TextL:SetTextColor(HealBot_Plugin_Config.yourbartxtR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.yourbartxtG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.yourbartxtB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
			bar.TextR:SetTextColor(HealBot_Plugin_Config.yourbartxtR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.yourbartxtG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.yourbartxtB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.bartxtA[HealBot_Plugin.Profile])
		end
	end
end

local sbcR, sbcG=1,1
local function HealBot_Plugin_SetBarCols(bar, r, g, b, tPct)
	if bar.role>1 then
		if HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]==1 then
			bar:SetStatusBarColor(r, g, b, HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		elseif HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]==2 then
			sbcR, sbcG=HealBot_Plugin_StatusColourPct(tPct)
			bar:SetStatusBarColor(sbcR, sbcG, 0, HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		else
			bar:SetStatusBarColor(HealBot_Plugin_Config.barR[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.barG[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.barB[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		end
	elseif bar.role==1 then
		if HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]==1 then
			bar:SetStatusBarColor(r, g, b, HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		elseif HealBot_Plugin_Config.tankcoltype[HealBot_Plugin.Profile]==2 then
			sbcR, sbcG=HealBot_Plugin_StatusColourPct(tPct)
			bar:SetStatusBarColor(sbcR, sbcG, 0, HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		else
			bar:SetStatusBarColor(HealBot_Plugin_Config.tankbarR[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.tankbarG[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.tankbarB[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		end
	else
		if HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]==1 then
			bar:SetStatusBarColor(r, g, b, HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		elseif HealBot_Plugin_Config.yourcoltype[HealBot_Plugin.Profile]==2 then
			sbcR, sbcG=HealBot_Plugin_StatusColourPct(tPct)
			bar:SetStatusBarColor(sbcR, sbcG, 0, HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		else
			bar:SetStatusBarColor(HealBot_Plugin_Config.yourbarR[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.yourbarG[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.yourbarB[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.barA[HealBot_Plugin.Profile])
		end
	end
end

local function HealBot_Plugin_readNumber(n)
    if n>99999999 then
        n=tostring(HealBot_Comm_round(n/1000000,0)).."M"
    elseif n>9999999 then
        n=tostring(HealBot_Comm_round(n/1000000,1)).."M"
    elseif n>999999 then
        n=tostring(HealBot_Comm_round(n/1000000,2)).."M"
    elseif n>99999 then
        n=tostring(HealBot_Comm_round(n/1000,0)).."K"
    elseif n>9999 then
        n=tostring(HealBot_Comm_round(n/1000,1)).."K"
    else
        n=tostring(n)
    end
    return n
end

local h=200
local function HealBot_Plugin_UpdateFrameHeight()
	h=23+((HealBot_Plugin_Config.height[HealBot_Plugin.Profile]+HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])*HealBot_Plugin_luVars["maxBars"])
	pFrame:SetHeight(h)
end

local function HealBot_Plugin_UpdateBarSetPoint(bar, rel)
	if rel>0 then
		bar:SetPoint("TOP", pHdrs[rel], "BOTTOM", 0, 0-HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
	else
		bar:SetPoint("TOP", pBars[bar.id-1], "BOTTOM", 0, 0-HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
	end
	bar.rel=rel
end

local hbp_upbar=0
local function HealBot_Plugin_UpdateFluidBarsUp(upVal)
	HealBot_Plugin_luVars["barsUpActive"]=false
	for id,target in pairs(pBarsValueUp) do
		if target>-1 then
			hbp_upbar=pBars[id]:GetValue()+upVal
			if hbp_upbar>=target then
				pBars[id]:SetValue(target)
				pBarsValueUp[id]=-1
			else
				pBars[id]:SetValue(hbp_upbar)
				HealBot_Plugin_luVars["barsUpActive"]=true
			end
		end
	end
end

local hbp_downbar=0
local function HealBot_Plugin_UpdateFluidBarsDown(downVal)
	HealBot_Plugin_luVars["barsDownActive"]=false
	for id,target in pairs(pBarsValueDown) do
		if target>-1 then
			hbp_downbar=pBars[id]:GetValue()-downVal
			if hbp_downbar<=target then
				pBars[id]:SetValue(target)
				pBarsValueDown[id]=-1
			else
				pBars[id]:SetValue(hbp_downbar)
				HealBot_Plugin_luVars["barsDownActive"]=true
			end
		end
	end
end

local hbp_update=false
local hbp_minUpdate=1
local hbp_PlayersMob=""
local function HealBot_Plugin_Threat_Update()
	hbp_update=false
    hbp_mobName=""
	hbp_numMobs=0
	hbp_curBar=0
	for i,guid in ipairs(units) do
		if hbp_PlayersMob==hbp_unitInfo[guid]["mob"] then
			hbp_tConcat[1]="A"
		else
			hbp_tConcat[1]="B"
		end				
		hbp_tConcat[2]=hbp_unitInfo[guid]["mob"]
		hbp_tConcat[3]=hbp_unitInfo[guid]["sorttpct"]
		hbp_tConcat[4]=hbp_unitInfo[guid]["name"]
		hbp_unitSort[guid]=HealBot_Plugin_Concat(4)
	end
	table.sort(units,function (a,b)
		if hbp_unitSort[a]<hbp_unitSort[b] then 
			return true 
		else
			return false
		end
	end)
	for i,guid in ipairs(units) do
		if hbp_mobName~=hbp_unitInfo[guid]["mob"] then
			hbp_mobName=hbp_unitInfo[guid]["mob"]
			hbp_mobChange=true
			if (hbp_numMobs+hbp_curBar)<HealBot_Plugin_luVars["maxBars"] then
				hbp_numMobs=hbp_numMobs+1
				if not hbp_mobrt[hbp_mobName] then hbp_mobrt[hbp_mobName]=0 end
				if hbp_numMobs>1 and pHdrs[hbp_numMobs].rel~=hbp_curBar then
					pHdrs[hbp_numMobs].rel=hbp_curBar
					pHdrs[hbp_numMobs]:SetPoint("TOP", pBars[hbp_curBar], "BOTTOM", 0, 0-HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
				end
				pHdrs[hbp_numMobs].TextC:SetText(HealBot_Plugin_Name(hbp_mobName, 2))
				pHdrs[hbp_numMobs]:Show()
			else
				break
			end
		else
			hbp_mobChange=false
		end
		if hbp_mobrt[hbp_mobName]~=pHdrs[hbp_numMobs].mobrt then
			pHdrs[hbp_numMobs].mobrt=hbp_mobrt[hbp_mobName]
			if pHdrs[hbp_numMobs].mobrt>0 then
				pHdrs[hbp_numMobs].icon:SetTexture(HealBot_Aura_retRaidtargetIcon(pHdrs[hbp_numMobs].mobrt))
				pHdrs[hbp_numMobs].icon:SetAlpha(1)
			else
				pHdrs[hbp_numMobs].icon:SetAlpha(0)
			end
		end
		if (hbp_numMobs+hbp_curBar)<HealBot_Plugin_luVars["maxBars"] then
			hbp_curBar=hbp_curBar+1
			if pBars[hbp_curBar].guid~=guid then
				pBars[hbp_curBar].role=hbp_unitInfo[guid]["role"]
				HealBot_Plugin_SetBarCols(pBars[hbp_curBar], 
										  hbp_unitInfo[guid]["r"],
										  hbp_unitInfo[guid]["g"],
										  hbp_unitInfo[guid]["b"],
										  hbp_unitInfo[guid]["tpct"])
				HealBot_Plugin_SetTextCols(pBars[hbp_curBar], 
										   hbp_unitInfo[guid]["r"],
										   hbp_unitInfo[guid]["g"],
										   hbp_unitInfo[guid]["b"],
										   hbp_unitInfo[guid]["tpct"])
				pBars[hbp_curBar].TextL:SetText(hbp_unitInfo[guid]["name"])
				if pBars[hbp_curBar].guid=="unused" then
					pBars[hbp_curBar]:Show()
				end
				pBars[hbp_curBar].guid=guid
				hbp_unitInfo[guid]["prevtpct"]=hbp_unitInfo[guid]["tpct"]
			elseif pBars[hbp_curBar].threat~=hbp_unitInfo[guid]["tpct"] then
				if HealBot_Plugin_Config.coltype[HealBot_Plugin.Profile]==2 then
					HealBot_Plugin_SetBarCols(pBars[hbp_curBar], 
											  hbp_unitInfo[guid]["r"],
											  hbp_unitInfo[guid]["g"],
											  hbp_unitInfo[guid]["b"],
											  hbp_unitInfo[guid]["tpct"])
				end
				if HealBot_Plugin_Config.txtcoltype[HealBot_Plugin.Profile]==2 then
					HealBot_Plugin_SetTextCols(pBars[hbp_curBar], 
											   hbp_unitInfo[guid]["r"],
											   hbp_unitInfo[guid]["g"],
											   hbp_unitInfo[guid]["b"],
											   hbp_unitInfo[guid]["tpct"])
				end
			end
			if pBars[hbp_curBar].threat~=hbp_unitInfo[guid]["tpct"] or 
			   pBars[hbp_curBar].rawread~=hbp_unitInfo[guid]["rawread"] then
				if pBars[hbp_curBar]:GetValue()~=hbp_unitInfo[guid]["tpct"]*10 then
					if not HealBot_Plugin_Config.fluidbars[HealBot_Plugin.Profile] then
						pBars[hbp_curBar]:SetValue(hbp_unitInfo[guid]["tpct"]*10)
					elseif hbp_unitInfo[guid]["prevtpct"]==hbp_unitInfo[guid]["tpct"] then
						pBarsValueDown[hbp_curBar]=-1
						pBarsValueUp[hbp_curBar]=-1
						pBars[hbp_curBar]:SetValue(hbp_unitInfo[guid]["tpct"]*10)
					else
						if pBars[hbp_curBar]:GetValue()<hbp_unitInfo[guid]["tpct"]*10 then
							pBarsValueDown[hbp_curBar]=-1
							pBarsValueUp[hbp_curBar]=hbp_unitInfo[guid]["tpct"]*10
							HealBot_Plugin_luVars["barsUpActive"]=true
						else
							pBarsValueUp[hbp_curBar]=-1
							pBarsValueDown[hbp_curBar]=hbp_unitInfo[guid]["tpct"]*10
							HealBot_Plugin_luVars["barsDownActive"]=true
						end
						hbp_unitInfo[guid]["prevtpct"]=hbp_unitInfo[guid]["tpct"]
					end
				end
				pBars[hbp_curBar].rawread=hbp_unitInfo[guid]["rawread"]
				pBars[hbp_curBar].threat=hbp_unitInfo[guid]["tpct"]
				hbp_tConcat[1]=hbp_unitInfo[guid]["tpct"]
				hbp_tConcat[2]="% ("
				hbp_tConcat[3]=pBars[hbp_curBar].rawread
				hbp_tConcat[4]=")"
				pBars[hbp_curBar].TextR:SetText(HealBot_Plugin_Concat(4))
			elseif hbp_unitInfo[guid]["lastupdate"]<TimeNow-3 then
				hbp_unitInfo[guid]["lastupdate"]=TimeNow
				HealBot_Plugin_ThreatUpdate(guid)
			end
			if hbp_mobChange then
				if pBars[hbp_curBar].rel~=hbp_numMobs then 
					HealBot_Plugin_UpdateBarSetPoint(pBars[hbp_curBar], hbp_numMobs)
				end
			elseif pBars[hbp_curBar].rel~=0 then 
				HealBot_Plugin_UpdateBarSetPoint(pBars[hbp_curBar], 0)
			end
		end
	end
	if hbp_curBar<hbp_prevMaxBar then
		for f=hbp_curBar+1,hbp_prevMaxBar do
			if pBars[f].guid~="unused" then
				pBars[f].guid="unused"
				pBars[f].rel=-1
				pBars[f].threat=-1
				pBarsValueDown[f]=-1
				pBarsValueUp[f]=-1
				pBars[f]:SetValue(0)
				pBars[f]:Hide()
			end
		end
		if hbp_curBar==0 then
			if HealBot_Plugin_luVars["ClearDown"] then
				HealBot_Plugin_luVars["ClearDown"]=false
				HealBot_Plugin_Threat_Cleardown()
			end
			pFrame:SetScript("OnUpdate", nil)
			HealBot_Plugin_luVars["OnUpdate"]=false
			if HealBot_Plugin_Config.OnlyShowOnDemand[HealBot_Plugin.Profile] then
				HealBot_Plugin_Threat_HidePanel()
			end
		end
	end
	hbp_prevMaxBar=hbp_curBar
	if hbp_numMobs<hbp_prevMaxHdr then
		for f=hbp_numMobs+1,hbp_prevMaxHdr do
			pHdrs[f]:Hide()
			pHdrs[f].rel=-1
			pHdrs[f].name="_nil"
			pHdrs[f].mobrt=-1
		end
	end
	hbp_prevMaxHdr=hbp_numMobs
	hbp_lastUpdate=TimeNow
	hbp_minUpdate=1
end

function HealBot_Plugin_Threat_MarkClearDown()
	HealBot_Plugin_luVars["ClearDown"]=true
end

local uIdx=0
local function HealBot_Plugin_RemoveUnit(guid)
	if hbp_unitInfo[guid].active then
		uIdx=0
		for j=1, #units do
			if guid==units[j] then
				uIdx=j
				break;
			end
		end
		if uIdx>0 then
			table.remove(units,uIdx)
		end
		hbp_unitInfo[guid].active=false
		hbp_unitInfo[guid]["mob"]="-nil"
		hbp_update=true
	end
end

function HealBot_Plugin_ThreatRemoveUnit(guid)
	HealBot_Plugin_RemoveUnit(guid)
	if hbp_unitInfo[guid] then
		hbp_unitInfo[guid]=nil
	end
	if hbp_unitSort[guid] then
		hbp_unitSort[guid]=nil
	end
end

local hbp_fbUpd=TimeNow
local function HealBot_Plugin_OnUpdate(self)
	TimeNow=GetTime()
	if (hbp_update and hbp_lastUpdate<TimeNow-hbp_minUpdate) or (hbp_curBar>0 and hbp_lastUpdate<TimeNow-2) then
		HealBot_Plugin_Threat_Update()
	elseif HealBot_Plugin_Config.fluidbars[HealBot_Plugin.Profile] and TimeNow>hbp_fbUpd then
		if HealBot_Plugin_luVars["barsUpActive"] then
			HealBot_Plugin_UpdateFluidBarsUp(ceil((TimeNow-hbp_fbUpd)*200)+HealBot_Plugin_Config.fluidfreq[HealBot_Plugin.Profile])
		end
		if HealBot_Plugin_luVars["barsDownActive"] then
			HealBot_Plugin_UpdateFluidBarsDown(ceil((TimeNow-hbp_fbUpd)*200)+HealBot_Plugin_Config.fluidfreq[HealBot_Plugin.Profile])
		end
		hbp_fbUpd=TimeNow+0.02
	end
end

function HealBot_Plugin_Threat_UnitUpdate(button)
	if button.aggro.mobname and button.aggro.threatpct>=HealBot_Plugin_Config.minthreatpct[HealBot_Plugin.Profile] then
		if not hbp_unitInfo[button.guid] or hbp_unitInfo[button.guid]["unit"]~=button.unit then
			if not hbp_unitInfo[button.guid] then 
				hbp_unitInfo[button.guid]={}
			end
			hbp_unitInfo[button.guid]["name"]=HealBot_Plugin_Name((HealBot_GetUnitName(button.unit, button.guid) or HEALBOT_WORDS_UNKNOWN), 1)
			hbp_unitInfo[button.guid]["unit"]=button.unit
			hbp_unitInfo[button.guid]["r"]=button.text.r
			hbp_unitInfo[button.guid]["g"]=button.text.g
			hbp_unitInfo[button.guid]["b"]=button.text.b
			hbp_unitInfo[button.guid]["raw"]=-1
			hbp_unitInfo[button.guid]["mob"]=button.aggro.mobname
			hbp_unitInfo[button.guid]["tpct"]=button.aggro.threatpct
			hbp_minUpdate=0.5
		elseif hbp_unitInfo[button.guid]["mob"]~=button.aggro.mobname then
			hbp_unitInfo[button.guid]["mob"]=button.aggro.mobname
			hbp_unitInfo[button.guid]["tpct"]=button.aggro.threatpct
			hbp_minUpdate=0.5
		end
		if hbp_unitInfo[button.guid]["raw"]~=button.aggro.threatvalue then
			hbp_unitInfo[button.guid]["raw"]=button.aggro.threatvalue
			hbp_unitInfo[button.guid]["rawread"]=HealBot_Plugin_readNumber(button.aggro.threatvalue)
		end
		if UnitIsUnit("player",button.unit) then
			hbp_PlayersMob=button.aggro.mobname
			hbp_unitInfo[button.guid]["role"]=0
		else
			hbp_unitInfo[button.guid]["role"]=button.status.role
		end
		hbp_unitInfo[button.guid]["prevtpct"]=hbp_unitInfo[button.guid]["tpct"]
		hbp_unitInfo[button.guid]["tpct"]=button.aggro.threatpct
		hbp_unitInfo[button.guid]["sorttpct"]=9999-button.aggro.threatpct
		hbp_unitInfo[button.guid]["lastupdate"]=GetTime()
		if not hbp_unitInfo[button.guid]["active"] then
			hbp_unitInfo[button.guid]["active"]=true
			table.insert(units,button.guid)
			if not HealBot_Plugin_luVars["OnUpdate"] then
				pFrame:SetScript("OnUpdate", HealBot_Plugin_OnUpdate)
				HealBot_Plugin_luVars["OnUpdate"]=true
				if HealBot_Plugin_Config.OnlyShowOnDemand[HealBot_Plugin.Profile] then
					HealBot_Plugin_Threat_ShowPanel()
				end
			end
		end
		hbp_update=true
	elseif hbp_unitInfo[button.guid] then
        HealBot_Plugin_RemoveUnit(button.guid)
	end
end

local function HealBot_Plugin_UpdateBarWidth(bar)
	bar:SetWidth(HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile]-4)
end

local function HealBot_Plugin_UpdateBarHeight(bar)
	bar:SetHeight(HealBot_Plugin_Config.height[HealBot_Plugin.Profile])
end

local function HealBot_Plugin_UpdateBarText(bar, hdr)
	if hdr then
		bar.TextC:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
											HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile],
											HealBot_Font_Outline[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
	else
		bar.TextL:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
									HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile],
									HealBot_Font_Outline[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
		bar.TextR:SetFont(LSM:Fetch('font',HealBot_Plugin_Config.font[HealBot_Plugin.Profile]),
									HealBot_Plugin_Config.fontsize[HealBot_Plugin.Profile],
									HealBot_Font_Outline[HealBot_Plugin_Config.txtoutline[HealBot_Plugin.Profile]])
	end
end

local function HealBot_Plugin_UpdateBarTexture(bar)
	bar:SetStatusBarTexture(LSM:Fetch('statusbar',HealBot_Plugin_Config.texture[HealBot_Plugin.Profile]))
end
 
function HealBot_Plugin_Threat_UpdateAll()
	if HealBot_Plugin_luVars["testMode"] then
		HealBot_Plugin_Threat_TestMode(false)
		HealBot_Plugin_luVars["testModeOn"]=true
	end	
	for f=1,HealBot_Plugin_Config.maxBars[HealBot_Plugin.Profile] do
		if not pBars[f] then
			pBars[f]=CreateFrame("StatusBar", "pBar_"..pId..f, pFrame) 
			pBars[f].id=f
			pBars[f]:SetMinMaxValues(0,1000)
			pBars[f]:SetValue(0)
			pBars[f]:Hide()
			pBars[f].guid="unused"
			pBars[f].role=3
			pBars[f].TextL=pBars[f]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			pBars[f].TextL:SetPoint("LEFT",1,0)
			pBars[f].TextR=pBars[f]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			pBars[f].TextR:SetPoint("RIGHT",-1,0)
			HealBot_Plugin_UpdateBarTexture(pBars[f])
			HealBot_Plugin_UpdateBarText(pBars[f])
			HealBot_Plugin_UpdateBarHeight(pBars[f])
			HealBot_Plugin_UpdateBarWidth(pBars[f])
		end
		pBars[f].tpct=-1
		pBars[f].threat=-1
		pBars[f].rel=-1
	end
	HealBot_Plugin_luVars["maxBars"]=HealBot_Plugin_Config.maxBars[HealBot_Plugin.Profile]
	for f=1,20 do
		if not pHdrs[f] then
			pHdrs[f]=CreateFrame("StatusBar", "hBar_"..pId..f, pFrame) 
			pHdrs[f].id=f
			pHdrs[f].rel=-1
			pHdrs[f].name="_nil"
			pHdrs[f].mobrt=-1
			pHdrs[f]:SetMinMaxValues(0,100)
			pHdrs[f]:SetValue(100)
			pHdrs[f]:Hide()
			pHdrs[f].TextC=pHdrs[f]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			pHdrs[f].TextC:SetPoint("CENTER",0,-1)
			pHdrs[f].icon = pHdrs[f]:CreateTexture(nil, "OVERLAY")
			pHdrs[f].icon:SetSize(14, 14)
			pHdrs[f].icon:SetPoint("RIGHT", -4, 0)
			pHdrs[f].icon:SetAlpha(0)
			HealBot_Plugin_UpdateBarHeight(pHdrs[f])
			HealBot_Plugin_UpdateBarWidth(pHdrs[f])
			HealBot_Plugin_UpdateBarTexture(pHdrs[f])
			HealBot_Plugin_UpdateBarText(pHdrs[f],true)
			if f==1 then
				pHdrs[f]:SetPoint("TOP", pFrameTitle, "BOTTOM", 0, 0-HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
			end
		end
		pHdrs[f]:SetStatusBarColor(HealBot_Plugin_Config.headerR[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.headerG[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.headerB[HealBot_Plugin.Profile],
								   HealBot_Plugin_Config.headerA[HealBot_Plugin.Profile])
		pHdrs[f].TextC:SetTextColor(HealBot_Plugin_Config.hdrtxtR[HealBot_Plugin.Profile],
								    HealBot_Plugin_Config.hdrtxtG[HealBot_Plugin.Profile],
								    HealBot_Plugin_Config.hdrtxtB[HealBot_Plugin.Profile],
								    HealBot_Plugin_Config.hdrtxtA[HealBot_Plugin.Profile])
	end
	HealBot_Plugin_SetTextLen()
	HealBot_Plugin_SetPoint()
	HealBot_Plugin_UpdateTitle()
	HealBot_Plugin_UpdateFrameHeight()
	HealBot_Plugin_Threat_Update()
	if HealBot_Plugin_luVars["testModeOn"] then
		HealBot_Plugin_Threat_TestMode(true)
		HealBot_Plugin_luVars["testModeOn"]=false
	end	
end

function HealBot_Plugin_Threat_UpdateHeight()
	for f=1,40 do
		if pBars[f] then
			HealBot_Plugin_UpdateBarHeight(pBars[f])
		else
			break
		end
	end
	for f=1,20 do
		if pHdrs[f] then
			HealBot_Plugin_UpdateBarHeight(pHdrs[f])
		else
			break
		end
	end
	HealBot_Plugin_UpdateFrameHeight()
end

function HealBot_Plugin_Threat_UpdateText()
	for f=1,40 do
		if pBars[f] then
			HealBot_Plugin_UpdateBarText(pBars[f])
		else
			break
		end
	end
	for f=1,20 do
		if pHdrs[f] then
			HealBot_Plugin_UpdateBarText(pHdrs[f],true)
		else
			break
		end
	end
end

function HealBot_Plugin_Threat_UpdateTitle()
	HealBot_Plugin_UpdateTitle()
end

function HealBot_Plugin_Threat_UpdateTexture()
	for f=1,40 do
		if pBars[f] then
			HealBot_Plugin_UpdateBarTexture(pBars[f])
		else
			break
		end
	end
	for f=1,20 do
		if pHdrs[f] then
			HealBot_Plugin_UpdateBarTexture(pHdrs[f])
		else
			break
		end
	end
end

function HealBot_Plugin_Threat_ShowPanel()
	HealBot_Plugin_Threat_SetFrameCols()
	HealBot_Plugin_Threat_SetTitleCol()
	pFrame:EnableMouse(true)
end

function HealBot_Plugin_Threat_HidePanel()
	pFrame:SetBackdropColor(0,0,0,0)
	pFrame:SetBackdropBorderColor(0,0,0,0)
	pFrameTitle:SetStatusBarColor(0,0,0,0)
	pFrameTitleText:SetTextColor(0,0,0,0)
	pFrame:EnableMouse(false)
end

function HealBot_Plugin_Threat_TogglePanel()
    if HealBot_Plugin_luVars["testMode"] then
		HealBot_Plugin_Threat_ShowPanel()
	elseif HealBot_Plugin_Config.OnlyShowOnDemand[HealBot_Plugin.Profile] then
		if hbp_curBar==0 then
			HealBot_Plugin_Threat_HidePanel()
		else
			HealBot_Plugin_Threat_ShowPanel()
		end	
	else
		HealBot_Plugin_Threat_ShowPanel()
	end
	hbp_update=true
end

function HealBot_Plugin_Threat_Cleardown()
    for x,_ in pairs(units) do
        units[x]=nil;
    end
	for x,_ in pairs(hbp_mobrt) do
		hbp_mobrt[x]=nil
	end
	for guid,_ in pairs(hbp_unitInfo) do
		if not HealBot_Panel_RaidUnitGUID(guid) then
			hbp_unitInfo[guid]=nil
			hbp_unitSort[guid]=nil
		end
	end
end

function HealBot_Plugin_Threat_Shutdown()
	HealBot_Plugin_Threat_Cleardown()
	HealBot_Plugin_Threat_TestMode(false)
	HealBot_Plugin_Frame_Threat_TestOff()
	HealBot_Plugin_Threat_HidePanel()
end

function HealBot_Plugin_Threat_FrameWidth()
	pFrame:SetWidth(HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile])
	pFrameTitle:SetWidth(HealBot_Plugin_Config.frameWidth[HealBot_Plugin.Profile]-4)
	for f=1,40 do
		if pBars[f] then
			HealBot_Plugin_UpdateBarWidth(pBars[f])
		else
			break
		end
	end
	for f=1,20 do
		if pHdrs[f] then
			HealBot_Plugin_UpdateBarWidth(pHdrs[f])
		else
			break
		end
	end
	HealBot_Plugin_SetTextLen()
end

function HealBot_Plugin_Threat_SetFrameCols()
	pFrame:SetBackdropColor(HealBot_Plugin_Config.frameR[HealBot_Plugin.Profile],
	                             HealBot_Plugin_Config.frameG[HealBot_Plugin.Profile],
								 HealBot_Plugin_Config.frameB[HealBot_Plugin.Profile],
								 HealBot_Plugin_Config.frameA[HealBot_Plugin.Profile])
	pFrame:SetBackdropBorderColor(HealBot_Plugin_Config.borderR[HealBot_Plugin.Profile],
	                                   HealBot_Plugin_Config.borderG[HealBot_Plugin.Profile],
								       HealBot_Plugin_Config.borderB[HealBot_Plugin.Profile],
								       HealBot_Plugin_Config.borderA[HealBot_Plugin.Profile])
end

function HealBot_Plugin_Threat_SetTitleCol()
	pFrameTitle:SetStatusBarColor(HealBot_Plugin_Config.titlebackR[HealBot_Plugin.Profile],
	                              HealBot_Plugin_Config.titlebackG[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.titlebackB[HealBot_Plugin.Profile],
								  HealBot_Plugin_Config.titlebackA[HealBot_Plugin.Profile])
	pFrameTitleText:SetTextColor(HealBot_Plugin_Config.titletextR[HealBot_Plugin.Profile], 
	                             HealBot_Plugin_Config.titletextG[HealBot_Plugin.Profile], 
								 HealBot_Plugin_Config.titletextB[HealBot_Plugin.Profile], 
								 HealBot_Plugin_Config.titletextA[HealBot_Plugin.Profile])
end

local hbp_testbars={}
local function HealBot_Plugin_Threat_TestModeSetBar(n,i,idx)
	HealBot_Plugin_SetBarCols(pBars[i],hbp_testbars[i].r,hbp_testbars[i].g,hbp_testbars[i].b,100-(i*2))
	HealBot_Plugin_SetTextCols(pBars[i],hbp_testbars[i].r,hbp_testbars[i].g,hbp_testbars[i].b,100-(i*2))
	if idx==1 then
		HealBot_Plugin_UpdateBarSetPoint(pBars[i], n)
	elseif pBars[i].rel~=0 then 
		HealBot_Plugin_UpdateBarSetPoint(pBars[i], 0)
	end
end

local function HealBot_Plugin_Threat_TestModeBar(n,i,idx)
	local tcR,tcG,tcB=HealBot_Panel_RandomClassColour()
	if not hbp_testbars[i] then hbp_testbars[i]={} end
	hbp_testbars[i].r=tcR
	hbp_testbars[i].g=tcG
	hbp_testbars[i].b=tcB
	pBars[i].TextL:SetText(pBars[i].guid)
	pBars[i]:Show()
	pBars[i]:SetValue(1000-(i*20))							
	hbp_tConcat[1]=100-(i*2)
	hbp_tConcat[2]="% ("
	hbp_tConcat[3]=1000-(i*20)
	hbp_tConcat[4]=")"
	pBars[i].TextR:SetText(HealBot_Plugin_Concat(4))
	HealBot_Plugin_Threat_TestModeSetBar(n,i,idx)
end

function HealBot_Plugin_Threat_TestMode(enable)
	if enable then
		HealBot_Plugin_luVars["testMode"]=true
		hbp_curBar=0
		local round={[1]=4,[2]=HealBot_Plugin_luVars["maxBars"]-6}
		pHdrs[1].icon:SetAlpha(0)
		if HealBot_Plugin_luVars["maxBars"]<9 then
			pHdrs[1].TextC:SetText("Mob 1")
			pHdrs[1]:Show()
			pHdrs[2]:Hide()
			for i=1, HealBot_Plugin_luVars["maxBars"]-1 do
				hbp_curBar=hbp_curBar+1
				if pBars[i].guid~="Player "..hbp_curBar then
					pBars[i].guid="Player "..hbp_curBar
					HealBot_Plugin_Threat_TestModeBar(1,hbp_curBar,i)
				else
					HealBot_Plugin_Threat_TestModeSetBar(1,hbp_curBar,i)
				end
			end
		else
			for n=1, 2 do
				if n>1 then
					pHdrs[n]:SetPoint("TOP", pBars[hbp_curBar], "BOTTOM", 0, 0-HealBot_Plugin_Config.rowspace[HealBot_Plugin.Profile])
					pHdrs[n].icon:SetTexture(HealBot_Aura_retRaidtargetIcon(8))
					pHdrs[n].icon:SetAlpha(1)
				end
				pHdrs[n].TextC:SetText("Mob "..n)
				pHdrs[n]:Show()
				for i=1, round[n] do
					hbp_curBar=hbp_curBar+1
					if pBars[hbp_curBar].guid~="Player "..hbp_curBar then
						pBars[hbp_curBar].guid="Player "..hbp_curBar
						HealBot_Plugin_Threat_TestModeBar(n,hbp_curBar,i)
					else
						HealBot_Plugin_Threat_TestModeSetBar(n,hbp_curBar,i)
					end
				end
			end
		end
		for f=hbp_curBar+1,40 do
			if pBars[f] then 
				pBars[f]:Hide() 
				pBars[f].rel=-1
				pBars[f].guid="unused"
			end
		end
	else
		for f=1,2 do
			pHdrs[f]:Hide()
			pHdrs[f].icon:SetAlpha(0)
		end
		for f=1,40 do
			if pBars[f] then 
				pBars[f]:Hide() 
				pBars[f].rel=-1
				pBars[f].guid="unused"
			end
		end
		HealBot_Plugin_luVars["testMode"]=false
		hbp_curBar=0
	end
	HealBot_Plugin_Threat_TogglePanel()
	hbp_update=true
end
