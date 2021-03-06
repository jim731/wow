local HealBot_UnitBuffIcons={}
local HealBot_UnitDebuffIcons={}
local HealBot_UnitExtraIcons={}
local HealBot_BuffNameTypes = {}
local HealBot_AuraBuffCache={}
local HealBot_AuraDebuffCache={}
local libCD=nil
local HealBot_ExcludeBuffInCache={}
local HealBot_ExcludeDebuffInCache={}
local HealBot_ExcludeEnemyInCache={}
local HealBot_Aura_WarningFilter={}
local HealBot_iconUpdate={["DEBUFF"]={[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1,[10]=1,},
                            ["BUFF"]={[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1,[10]=1,} }
local HealBot_Watch_HoT={};
local HealBot_CheckBuffs = {}
local HealBot_ShortBuffs = {}
local HealBot_BuffWatch={}
local PlayerBuffs = {}
local PlayerBuffTypes = {}
local debuffCodes={ [HEALBOT_DISEASE_en]=5, [HEALBOT_MAGIC_en]=6, [HEALBOT_POISON_en]=7, [HEALBOT_CURSE_en]=8, [HEALBOT_CUSTOM_en]=9}
local HealBot_SpellID_LookupData={}
local HealBot_SpellID_LookupIdx={}
local _
local HealBot_Buff_Aura2Item={};
local HealBot_Buff_ItemIDs={};
local buffCheck, generalBuffs, buffWarnings, debuffCheck, debuffWarnings=false,false,false,true,true
local tmpBCheck, tmpCBuffs, tmpGBuffs, tmpDCheck=false,false,false,false
local uaName, uaTexture, uaCount, uaDebuffType, uaDuration = false,false,false,false,false
local uaExpirationTime, uaUnitCaster, uaSpellId, uaIsBossDebuff = false,false,false,false
local HealBot_TargetIconsTextures = {[1]=[[Interface\Addons\HealBot\Images\Star.tga]],
                                     [2]=[[Interface\Addons\HealBot\Images\Circle.tga]],
                                     [3]=[[Interface\Addons\HealBot\Images\Diamond.tga]],
                                     [4]=[[Interface\Addons\HealBot\Images\Triangle.tga]],
                                     [5]=[[Interface\Addons\HealBot\Images\Moon.tga]],
                                     [6]=[[Interface\Addons\HealBot\Images\Square.tga]],
                                     [7]=[[Interface\Addons\HealBot\Images\Cross.tga]],
                                     [8]=[[Interface\Addons\HealBot\Images\Skull.tga]],}

local HealBot_Aura_luVars={}
HealBot_Aura_luVars["TankUnit"]="x"
HealBot_Aura_luVars["hbInsName"]=HEALBOT_WORD_OUTSIDE
HealBot_Aura_luVars["prevDebuffType"]="x"
HealBot_Aura_luVars["prevDebuffID"]=0
HealBot_Aura_luVars["MaskAuraDCheck"]=0
HealBot_Aura_luVars["IgnoreFastDurDebuffsSecs"]=-1

function HealBot_Aura_setLuVars(vName, vValue)
    HealBot_Aura_luVars[vName]=vValue
      --HealBot_setCall("HealBot_setLuVars")
end

function HealBot_Aura_retLuVars(vName)
      --HealBot_setCall("HealBot_retLuVars"..vName)
    return HealBot_Aura_luVars[vName]
end

function HealBot_Aura_retRaidtargetIcon(id)
    return HealBot_TargetIconsTextures[id]
end

function HealBot_Aura_ResetBuffCache()
    HealBot_Aura_ClearAllBuffs(false)
    for spellId,_ in pairs(HealBot_AuraBuffCache) do
        HealBot_AuraBuffCache[spellId]=nil
    end
    HealBot_Aura_DeleteExcludeBuffInCache()
end

function HealBot_Aura_ResetDebuffCache()
    HealBot_Aura_ClearAllDebuffs(false)
    for spellId,_ in pairs(HealBot_AuraDebuffCache) do
        HealBot_AuraDebuffCache[spellId]=nil
    end
    HealBot_Aura_DeleteExcludeDebuffInCache()
end

function HealBot_Aura_DeleteExcludeDebuffInCache()
    for id,_ in pairs(HealBot_ExcludeDebuffInCache) do
        HealBot_ExcludeDebuffInCache[id]=nil
    end
end

function HealBot_Aura_DeleteExcludeBuffInCache()
    for id,_ in pairs(HealBot_ExcludeBuffInCache) do
        HealBot_ExcludeBuffInCache[id]=nil
    end
end

function HealBot_Aura_RemoveIcon(button, index)
    if not button then return; end;
    button.gref.icon[index]:SetAlpha(0)
    if index<90 then
        button.gref.txt.expire[index]:SetTextColor(1,1,1,0);
        button.gref.txt.count[index]:SetTextColor(1,1,1,0)
        button.gref.txt.expire[index]:SetText(" ");
        button.gref.txt.count[index]:SetText(" ");
    end
      --HealBot_setCall("HealBot_Aura_RemoveIcon")
end

function HealBot_Aura_RemoveBuffIcons(button, TimeNow)
    if HealBot_UnitBuffIcons[button.id] then
        for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] do
            HealBot_UnitBuffIcons[button.id][i].current=false
            HealBot_UnitBuffIcons[button.id][i].nextUpdate=TimeNow+1000000
        end
    end
    if button.frame>0 then
        for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] do
            HealBot_Aura_RemoveIcon(button, i)
        end
    end
end

function HealBot_Aura_RemoveUnusedUnitBuffIcons(button, index)
    if HealBot_UnitBuffIcons[button.id] then
        HealBot_UnitBuffIcons[button.id][index].current=false
        HealBot_UnitBuffIcons[button.id][index].nextUpdate=GetTime()+1000000
    end
    HealBot_Aura_RemoveIcon(button, index)
end

function HealBot_Aura_RemoveUnusedBuffIcons()
    for _,xButton in pairs(HealBot_Unit_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]<12 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]+1,12 do
                HealBot_Aura_RemoveUnusedUnitBuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Private_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]<12 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]+1,12 do
                HealBot_Aura_RemoveUnusedUnitBuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Enemy_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]<12 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]+1,12 do
                HealBot_Aura_RemoveUnusedUnitBuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Pet_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]<12 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]+1,12 do
                HealBot_Aura_RemoveUnusedUnitBuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Extra_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]<12 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"]+1,12 do
                HealBot_Aura_RemoveUnusedUnitBuffIcons(xButton, i)
            end
        end
    end
end

function HealBot_Aura_RemoveDebuffIcons(button, TimeNow)
    if HealBot_UnitDebuffIcons[button.id] then
        for i = 51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"]+50 do
            HealBot_UnitDebuffIcons[button.id][i].current=false
            HealBot_UnitDebuffIcons[button.id][i].nextUpdate=TimeNow+1000000
        end
    end
    if button.frame>0 then
        for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"]+50 do
            HealBot_Aura_RemoveIcon(button, i)
        end
    end
end

function HealBot_Aura_RemoveUnusedUnitDebuffIcons(button, index)
    if HealBot_UnitDebuffIcons[button.id] then
        HealBot_UnitDebuffIcons[button.id][index].current=false
        HealBot_UnitDebuffIcons[button.id][index].nextUpdate=GetTime()+1000000
    end
    HealBot_Aura_RemoveIcon(button, index)
end

function HealBot_Aura_RemoveUnusedDebuffIcons()
    for _,xButton in pairs(HealBot_Unit_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]<8 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+51,58 do
                HealBot_Aura_RemoveUnusedUnitDebuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Private_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]<8 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+51,58 do
                HealBot_Aura_RemoveUnusedUnitDebuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Enemy_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]<8 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+51,58 do
                HealBot_Aura_RemoveUnusedUnitDebuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Pet_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]<8 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+51,58 do
                HealBot_Aura_RemoveUnusedUnitDebuffIcons(xButton, i)
            end
        end
    end
    for _,xButton in pairs(HealBot_Extra_Button) do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]<8 then
            for i = Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+51,58 do
                HealBot_Aura_RemoveUnusedUnitDebuffIcons(xButton, i)
            end
        end
    end
end

function HealBot_Aura_RemoveExtraUnitIcons(button, index)
    if index==91 then
        button.icon.extra.classtexture=false
    elseif index==92 then
        button.icon.extra.targeticon=0
    elseif index==93 then
        button.icon.extra.readycheck=false
    end
    if HealBot_UnitExtraIcons[button.id] and HealBot_UnitExtraIcons[button.id][index] then
        HealBot_UnitExtraIcons[button.id][index].current=false
        HealBot_UnitExtraIcons[button.id][index]["texture"]=""
    end
    HealBot_Aura_RemoveIcon(button, index)
--    HealBot_OnEvent_UnitAura(button)
        --HealBot_setCall("HealBot_Aura_RemoveExtraUnitIcons")
end

function HealBot_Aura_RemoveExtraIcons(index)
    for _,xButton in pairs(HealBot_Unit_Button) do
        HealBot_Aura_RemoveExtraUnitIcons(xButton, index)
    end
    for _,xButton in pairs(HealBot_Private_Button) do
        HealBot_Aura_RemoveExtraUnitIcons(xButton, index)
    end
    for _,xButton in pairs(HealBot_Enemy_Button) do
        HealBot_Aura_RemoveExtraUnitIcons(xButton, index)
    end
    for _,xButton in pairs(HealBot_Pet_Button) do
        HealBot_Aura_RemoveExtraUnitIcons(xButton, index)
    end
    for _,xButton in pairs(HealBot_Extra_Button) do
        HealBot_Aura_RemoveExtraUnitIcons(xButton, index)
    end
end

HealBot_Aura_luVars["FadeTimeDiv"]=18
HealBot_Aura_luVars["BuffFadeTimeDiv"]=18
local retAlpha=0
function HealBot_Aura_DebuffIcon_AlphaValue(secLeft, button, nextUpdate)
    if secLeft>=0 then
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["FADE"] and 
            secLeft<Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["FADESECS"] then
            retAlpha=(secLeft/HealBot_Aura_luVars["FadeTimeDiv"])+.12
            nextUpdate=0.2
            if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["I15EN"] then
                if retAlpha>Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"] then
                    retAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
                end
            elseif retAlpha>button.status.alpha then
                retAlpha=button.status.alpha
            end
        elseif Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["I15EN"] then
            retAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
        else
            retAlpha=button.status.alpha
        end
    else
        retAlpha=0
    end
      --HealBot_setCall("HealBot_Aura_DebuffIcon_AlphaValue")
    return retAlpha, nextUpdate
end

function HealBot_Aura_BuffIcon_AlphaValue(secLeft, button, nextUpdate)
    if secLeft>=0 then
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFFADE"] and 
           secLeft<Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFFADESECS"] then
            retAlpha=(secLeft/HealBot_Aura_luVars["BuffFadeTimeDiv"])+.12
            nextUpdate=0.2
            if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFI15EN"] then
                if retAlpha>Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"] then
                    retAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
                end
            elseif retAlpha>button.status.alpha then
                retAlpha=button.status.alpha
            end
        elseif Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFI15EN"] then
            retAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
        else
            retAlpha=button.status.alpha
        end
    else
        retAlpha=0
    end
      --HealBot_setCall("HealBot_Aura_BuffIcon_AlphaValue")
    return retAlpha, nextUpdate
end

HealBot_UpdateIconFreq={["DEBUFF"]={[1]=50,[2]=50,[3]=50,[4]=50,[5]=50,[6]=50,[7]=50,[8]=50,[9]=50,[10]=50},
                          ["BUFF"]={[1]=50,[2]=50,[3]=50,[4]=50,[5]=50,[6]=50,[7]=50,[8]=50,[9]=50,[10]=50}}
function HealBot_Aura_SetUpdateIconFreq()
    for j=1,10 do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][j]["FADE"] then
            if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][j]["FADESECS"]<Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][j]["DURTHRH"] then
                HealBot_UpdateIconFreq["DEBUFF"][j]=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][j]["DURTHRH"]
            else
                HealBot_UpdateIconFreq["DEBUFF"][j]=Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][j]["FADESECS"]
            end
        else
            HealBot_UpdateIconFreq["DEBUFF"][j]=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][j]["DURTHRH"]
        end
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][j]["BUFFFADE"] then
            if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][j]["BUFFFADESECS"]<Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][j]["BUFFDURTHRH"] then
                HealBot_UpdateIconFreq["BUFF"][j]=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][j]["BUFFDURTHRH"]
            else
                HealBot_UpdateIconFreq["BUFF"][j]=Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][j]["BUFFFADESECS"]
            end
        else
            HealBot_UpdateIconFreq["BUFF"][j]=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][j]["BUFFDURTHRH"]
        end
    end
end

local auSecsLeft,iconAlpha=0,0
local alphaNextUpdate, durNextUpdate=0,0
function HealBot_Aura_UpdateExtraIcon(button, iconData, index)
    if (index==91 and Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["CLASSEN"]) or
       (index==92 and Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["TARGETEN"]) or
       (index==93 and Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["RCEN"]) or
       (index==94 and Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["OOREN"]) then
        iconAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
    else
        iconAlpha=button.status.alpha
    end
    button.gref.icon[index]:SetAlpha(iconAlpha)
      --HealBot_setCall("HealBot_Aura_UpdateExtraIcon")
end

function HealBot_Aura_UpdateDebuffIcon(button, iconData, index, TimeNow)
    alphaNextUpdate=999
    durNextUpdate=999
    if iconData.expirationTime>0 then
        iconAlpha, alphaNextUpdate=HealBot_Aura_DebuffIcon_AlphaValue(iconData.expirationTime-TimeNow, button, alphaNextUpdate)
    elseif Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["I15EN"] then
        iconAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
    else
        iconAlpha=button.status.alpha
    end
    button.gref.icon[index]:SetAlpha(iconAlpha)
    if Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["SDUR"] and iconData.expirationTime>0 and
       (not Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["SSDUR"] or UnitIsUnit(iconData.unitCaster,"player")) then
        auSecsLeft=floor(iconData.expirationTime-TimeNow)
        if auSecsLeft>-1 and auSecsLeft<=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["DURTHRH"] then
            button.gref.txt.expire[index]:SetText(auSecsLeft);
            if auSecsLeft<=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["DURWARN"] then
                if UnitIsFriend("player",button.unit) then
                    button.gref.txt.expire[index]:SetTextColor(0,1,0,iconAlpha);
                else
                    button.gref.txt.expire[index]:SetTextColor(1,0,0,iconAlpha);
                end
            else
                button.gref.txt.expire[index]:SetTextColor(1,1,1,iconAlpha);
            end
            durNextUpdate=1
        else
            button.gref.txt.expire[index]:SetTextColor(1,1,1,0)
            button.gref.txt.expire[index]:SetText(" ");
            durNextUpdate=auSecsLeft-Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["DURTHRH"]
        end
    else
        button.gref.txt.expire[index]:SetTextColor(1,1,1,0)
        button.gref.txt.expire[index]:SetText(" ");
    end
    if iconData.count > 1 and Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["SCNT"] and
        (not Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["SSCNT"] or UnitIsUnit(iconData.unitCaster,"player")) then
        button.gref.txt.count[index]:SetText(iconData.count);
        button.gref.txt.count[index]:SetTextColor(1,1,1,iconAlpha);
    else
        button.gref.txt.count[index]:SetTextColor(1,1,1,0)
        button.gref.txt.count[index]:SetText(" ");
    end
    if alphaNextUpdate<durNextUpdate then
        return alphaNextUpdate
    else
        return durNextUpdate
    end
      --HealBot_setCall("HealBot_Aura_UpdateDebuffIcon")
end

function HealBot_Aura_UpdateBuffIcon(button, iconData, index, TimeNow)
    alphaNextUpdate=999
    durNextUpdate=999
    if iconData.expirationTime>0 then
        iconAlpha, alphaNextUpdate=HealBot_Aura_BuffIcon_AlphaValue(iconData.expirationTime-TimeNow, button, alphaNextUpdate)
    elseif Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFI15EN"] then
        iconAlpha=Healbot_Config_Skins.BarCol[Healbot_Config_Skins.Current_Skin][button.frame]["HA"]
    else
        iconAlpha=button.status.alpha
    end
    button.gref.icon[index]:SetAlpha(iconAlpha)
    if Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFSDUR"] and iconData.expirationTime>0 and
       (not Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFSSDUR"] or UnitIsUnit(iconData.unitCaster,"player")) then
        auSecsLeft=floor(iconData.expirationTime-TimeNow)
        if auSecsLeft>-1 and auSecsLeft<=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFDURTHRH"] then
            button.gref.txt.expire[index]:SetText(auSecsLeft);
            if auSecsLeft<=Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFDURWARN"] then
                button.gref.txt.expire[index]:SetTextColor(1,0,0,iconAlpha);
            else
                button.gref.txt.expire[index]:SetTextColor(1,1,1,iconAlpha);
            end
            durNextUpdate=1
        else
            button.gref.txt.expire[index]:SetTextColor(1,1,1,0)
            button.gref.txt.expire[index]:SetText(" ");
            durNextUpdate=auSecsLeft-Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFDURTHRH"]
        end
    else
        button.gref.txt.expire[index]:SetTextColor(1,1,1,0)
        button.gref.txt.expire[index]:SetText(" ");
    end
    if iconData.count > 1 and Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFSCNT"] and
       (not Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFSSCNT"] or UnitIsUnit(iconData.unitCaster,"player")) then
        button.gref.txt.count[index]:SetText(iconData.count);
        button.gref.txt.count[index]:SetTextColor(1,1,1,iconAlpha);
    else
        button.gref.txt.count[index]:SetTextColor(1,1,1,0)
        button.gref.txt.count[index]:SetText(" ");
    end
    if alphaNextUpdate<durNextUpdate then
        return alphaNextUpdate
    else
        return durNextUpdate
    end
      --HealBot_setCall("HealBot_Aura_UpdateBuffIcon")
end

function HealBot_Aura_AddExtraIcon(button, index)
    button.gref.icon[index]:SetTexture(HealBot_UnitExtraIcons[button.id][index]["texture"])
    --if index==94 then HealBot_Action_SetDirectionArrow(button) end
    HealBot_Aura_UpdateExtraIcon(button, HealBot_UnitExtraIcons[button.id][index], index)
      --HealBot_setCall("HealBot_Aura_AddExtraIcon")
end

function HealBot_Aura_AddBuffIcon(button, index, TimeNow)
    button.gref.icon[index]:SetTexture(HealBot_AuraBuffCache[HealBot_UnitBuffIcons[button.id][index]["spellId"]]["texture"])
    HealBot_Aura_UpdateBuffIcon(button, HealBot_UnitBuffIcons[button.id][index], index, TimeNow)
      --HealBot_setCall("HealBot_Aura_AddBuffIcon")
end

function HealBot_Aura_DebuffAddIcon(button, index, TimeNow)
    button.gref.icon[index]:SetTexture(HealBot_AuraDebuffCache[HealBot_UnitDebuffIcons[button.id][index]["spellId"]]["texture"])
    HealBot_Aura_UpdateDebuffIcon(button, HealBot_UnitDebuffIcons[button.id][index], index, TimeNow)
      --HealBot_setCall("HealBot_Aura_DebuffAddIcon")
end

local rtuPrevId=false
function HealBot_Aura_RaidTargetUpdate(button, iconID)
    rtuPrevId=button.icon.extra.targeticon
    button.icon.extra.targeticon=iconID
    if button.icon.extra.targeticon~=rtuPrevId and HealBot_UnitExtraIcons[button.id] then
        if not HealBot_TargetIconsTextures[button.icon.extra.targeticon] then
            HealBot_UnitExtraIcons[button.id][92].current=false
            HealBot_UnitExtraIcons[button.id][92]["texture"]=""
            HealBot_Aura_RemoveIcon(button, 92)
        elseif not HealBot_UnitExtraIcons[button.id][92].current or
           HealBot_UnitExtraIcons[button.id][92]["texture"]~=HealBot_TargetIconsTextures[button.icon.extra.targeticon] then
            HealBot_UnitExtraIcons[button.id][92]["texture"]=HealBot_TargetIconsTextures[button.icon.extra.targeticon]
            HealBot_UnitExtraIcons[button.id][92].current=true
            HealBot_Aura_AddExtraIcon(button, 92)
        end
    end
        --HealBot_setCall("HealBot_Aura_RaidTargetUpdate")
end

local cuPrevTexture=false
function HealBot_Aura_ClassUpdate(button, texture)
    cuPrevTexture=button.icon.extra.classtexture
    button.icon.extra.classtexture=texture
    if button.icon.extra.classtexture~=cuPrevTexture and HealBot_UnitExtraIcons[button.id] then
        if not button.icon.extra.classtexture then 
            HealBot_UnitExtraIcons[button.id][91].current=false
            HealBot_UnitExtraIcons[button.id][91]["texture"]=""
            HealBot_Aura_RemoveIcon(button, 91)
        elseif not HealBot_UnitExtraIcons[button.id][91].current or
           HealBot_UnitExtraIcons[button.id][91]["texture"]~=button.icon.extra.classtexture then
            HealBot_UnitExtraIcons[button.id][91]["texture"]=button.icon.extra.classtexture
            HealBot_UnitExtraIcons[button.id][91].current=true
            HealBot_Aura_AddExtraIcon(button, 91)
        end
    end
        --HealBot_setCall("HealBot_Aura_ClassUpdate")
end

local rcuPrevTexture=false
function HealBot_Aura_RCUpdate(button, texture)
    rcuPrevTexture=button.icon.extra.readycheck
    button.icon.extra.readycheck=texture
    if button.icon.extra.readycheck~=rcuPrevTexture and HealBot_UnitExtraIcons[button.id] then
        if not button.icon.extra.readycheck then 
            HealBot_UnitExtraIcons[button.id][93].current=false
            HealBot_UnitExtraIcons[button.id][93]["texture"]=""
            HealBot_Aura_RemoveIcon(button, 93)
        elseif not HealBot_UnitExtraIcons[button.id][93].current or
           HealBot_UnitExtraIcons[button.id][93]["texture"]~=button.icon.extra.readycheck then
            HealBot_UnitExtraIcons[button.id][93]["texture"]=button.icon.extra.readycheck
            HealBot_UnitExtraIcons[button.id][93].current=true
            HealBot_Aura_AddExtraIcon(button, 93)
        end
    end
        --HealBot_setCall("HealBot_Aura_RCUpdate")
end

local ooruPrevTexture=false
function HealBot_Aura_OORUpdate(button, texture)
    button.icon.extra.oorarrow=texture
    if HealBot_UnitExtraIcons[button.id] then
        if not button.icon.extra.oorarrow then 
            HealBot_UnitExtraIcons[button.id][94].current=false
            HealBot_UnitExtraIcons[button.id][94]["texture"]=""
            HealBot_Aura_RemoveIcon(button, 94)
        else
            HealBot_UnitExtraIcons[button.id][94]["texture"]=button.icon.extra.oorarrow
            HealBot_UnitExtraIcons[button.id][94].current=true
            HealBot_Action_SetDirectionArrow(button, 94)
            HealBot_Aura_AddExtraIcon(button, 94)
        end
    end
        --HealBot_setCall("HealBot_Aura_OORUpdate")
end

function HealBot_Aura_InitUnitBuffIcons(buttonId)
    HealBot_UnitBuffIcons[buttonId]={}
    for i = 1,12 do
        HealBot_UnitBuffIcons[buttonId][i]={}
        HealBot_UnitBuffIcons[buttonId][i]["count"]=0
        HealBot_UnitBuffIcons[buttonId][i]["expirationTime"]=0
        HealBot_UnitBuffIcons[buttonId][i]["spellId"]=0
        HealBot_UnitBuffIcons[buttonId][i]["unitCaster"]="x"
        HealBot_UnitBuffIcons[buttonId][i].current=false
        HealBot_UnitBuffIcons[buttonId][i].nextUpdate=GetTime()+1000000
    end
end

function HealBot_Aura_ResetUnitBuffIcons(buttonId)
    for i = 1,12 do
        HealBot_UnitBuffIcons[buttonId][i].current=false
    end
end

function HealBot_Aura_InitUnitDebuffIcons(buttonId)
    HealBot_UnitDebuffIcons[buttonId]={}
    for i = 51,58 do
        HealBot_UnitDebuffIcons[buttonId][i]={}
        HealBot_UnitDebuffIcons[buttonId][i]["count"]=0
        HealBot_UnitDebuffIcons[buttonId][i]["expirationTime"]=0
        HealBot_UnitDebuffIcons[buttonId][i]["spellId"]=0
        HealBot_UnitDebuffIcons[buttonId][i]["unitCaster"]="x"
        HealBot_UnitDebuffIcons[buttonId][i].current=false
        HealBot_UnitDebuffIcons[buttonId][i].nextUpdate=GetTime()+1000000
    end
end

function HealBot_Aura_ResetUnitDebuffIcons(buttonId)
    for i = 51,58 do
        HealBot_UnitDebuffIcons[buttonId][i].current=false
    end
end

function HealBot_Aura_InitUnitExtraIcons(buttonId)
    HealBot_UnitExtraIcons[buttonId]={}
    for i = 91,94 do
        HealBot_UnitExtraIcons[buttonId][i]={}
        HealBot_UnitExtraIcons[buttonId][i]["texture"]=""
        HealBot_UnitExtraIcons[buttonId][i].current=false
    end
end

function HealBot_Aura_ResetUnitExtraIcons(buttonId)
    for i = 91,94 do
        HealBot_UnitExtraIcons[buttonId][i].current=false
    end
end

function HealBot_Aura_setUnitIcons(buttonId, unit)
    if not HealBot_UnitDebuffIcons[buttonId] then 
        HealBot_Aura_InitUnitDebuffIcons(buttonId) 
    else    
        HealBot_Aura_ResetUnitDebuffIcons(buttonId)
    end
    if not HealBot_UnitBuffIcons[buttonId] then 
        HealBot_Aura_InitUnitBuffIcons(buttonId) 
    else
        HealBot_Aura_ResetUnitBuffIcons(buttonId)
    end
    if not HealBot_UnitExtraIcons[buttonId] then 
        HealBot_Aura_InitUnitExtraIcons(buttonId) 
    else
        HealBot_Aura_ResetUnitExtraIcons(buttonId)
    end
    if not HealBot_Aura_WarningFilter[unit] then
        HealBot_Aura_WarningFilter[unit]={}
    end
      --HealBot_setCall("HealBot_Aura_setUnitIcons")
end

function HealBot_Aura_delUnitIcons(buttonId)
    HealBot_UnitDebuffIcons[buttonId]=nil
end

function HealBot_Aura_AutoUpdateCustomDebuff(button, name, spellId)
    HealBot_Globals.CatchAltDebuffIDs[name]=nil
    for dID, x in pairs(HealBot_Globals.HealBot_Custom_Debuffs) do
        if (GetSpellInfo(dID) and GetSpellInfo(dID)==dName) or (not GetSpellInfo(dID) and dID==name) then
            local oldId=dID
            if dID==name then oldId=name end
            HealBot_Globals.Custom_Debuff_Categories[spellId]=HealBot_Globals.Custom_Debuff_Categories[oldId]
            HealBot_Globals.HealBot_Custom_Debuffs[spellId]=x
            if HealBot_Globals.FilterCustomDebuff[oldId] then 
                HealBot_Globals.FilterCustomDebuff[spellId]=HealBot_Globals.FilterCustomDebuff[oldId]
            end
            if HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[oldId] then
                HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[spellId]=HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[oldId]
            end
            if HealBot_Globals.CDCBarColour[oldId] then
                HealBot_Globals.CDCBarColour[spellId]=HealBot_Options_copyTable(HealBot_Globals.CDCBarColour[oldId])
            end
            if HealBot_Globals.IgnoreCustomDebuff[oldId] then
                HealBot_Globals.IgnoreCustomDebuff[spellId]=HealBot_Options_copyTable(HealBot_Globals.IgnoreCustomDebuff[oldId])
            end
            if dID~=name then 
                HealBot_Options_CDebuffResetList()
                HealBot_OnEvent_UnitAura(button)
            end
            break
        end
    end
end

function HealBot_Aura_BumpDebuffIcon(button,id)
    if button.icon.debuff.count==Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"] then
        button.icon.debuff.count=button.icon.debuff.count-1
    end
    for x=button.icon.debuff.count+50,id,-1 do
        HealBot_UnitDebuffIcons[button.id][x+1]["count"]=HealBot_UnitDebuffIcons[button.id][x]["count"]
        HealBot_UnitDebuffIcons[button.id][x+1]["expirationTime"]=HealBot_UnitDebuffIcons[button.id][x]["expirationTime"]
        HealBot_UnitDebuffIcons[button.id][x+1]["unitCaster"]=HealBot_UnitDebuffIcons[button.id][x]["unitCaster"]
        HealBot_UnitDebuffIcons[button.id][x+1]["spellId"]=HealBot_UnitDebuffIcons[button.id][x]["spellId"]
        HealBot_UnitDebuffIcons[button.id][x+1].current=false
    end
      --HealBot_setCall("HealBot_Aura_BumpDebuffIcon")
end

function HealBot_Aura_CacheDebuffIcon(button, id, TimeNow)
    if HealBot_UnitDebuffIcons[button.id][id]["spellId"]~=uaSpellId then
        HealBot_UnitDebuffIcons[button.id][id]["count"]=uaCount
        HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]=uaExpirationTime
        HealBot_UnitDebuffIcons[button.id][id]["spellId"]=uaSpellId
        HealBot_UnitDebuffIcons[button.id][id]["unitCaster"]=uaUnitCaster
        HealBot_UnitDebuffIcons[button.id][id].current=false
        if HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]>0 then
            HealBot_UnitDebuffIcons[button.id][id].nextUpdate=(HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]-1)-HealBot_UpdateIconFreq["DEBUFF"][button.frame]
        else
            HealBot_UnitDebuffIcons[button.id][id].nextUpdate=TimeNow+1000000
        end
    elseif HealBot_UnitDebuffIcons[button.id][id]["count"]~=uaCount or HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]~=uaExpirationTime then
        HealBot_UnitDebuffIcons[button.id][id]["count"]=uaCount
        HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]=uaExpirationTime
        HealBot_UnitDebuffIcons[button.id][id].nextUpdate=TimeNow
        button.aura.debuff.nextupdate=TimeNow
    end
end

local hbCustomDebuffsCastBy={}
local hbCustomDebuffsDisabled={}
local hbADebuffPrio=10
function HealBot_Aura_SetDebuffIcon(button, TimeNow)
    if (hbCustomDebuffsDisabled[uaSpellId] and (hbCustomDebuffsDisabled[uaSpellId][HealBot_Aura_luVars["hbInsName"]] or hbCustomDebuffsDisabled[uaSpellId]["ALL"])) or
       (hbCustomDebuffsDisabled[uaName] and (hbCustomDebuffsDisabled[uaName][HealBot_Aura_luVars["hbInsName"]] or hbCustomDebuffsDisabled[uaName]["ALL"])) then
        return
    else
        hbADebuffPrio=HealBot_Globals.HealBot_Custom_Debuffs[uaSpellId] or HealBot_Globals.HealBot_Custom_Debuffs[uaName] or 10
        if button.icon.debuff.count>0 then
            for x=1, button.icon.debuff.count do
                if HealBot_AuraDebuffCache[HealBot_UnitDebuffIcons[button.id][50+x]["spellId"]]["priority"]>hbADebuffPrio then
                    if x<Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"] then 
                        HealBot_Aura_BumpDebuffIcon(button,50+x) 
                        button.icon.debuff.count=button.icon.debuff.count+1
                    end
                    HealBot_Aura_CacheDebuffIcon(button, 50+x, TimeNow)
                    return
                end
            end
            if button.icon.debuff.count<Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"] then
                button.icon.debuff.count=button.icon.debuff.count+1
                HealBot_Aura_CacheDebuffIcon(button, 50+button.icon.debuff.count, TimeNow)
            end
        else
            button.icon.debuff.count=button.icon.debuff.count+1
            HealBot_Aura_CacheDebuffIcon(button, 50+button.icon.debuff.count, TimeNow)
        end
    end
      --HealBot_setCall("HealBot_Aura_SetDebuffIcon")
end

function HealBot_Aura_BumpBuffIcon(button,id)
    if button.icon.buff.count==Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] then
        button.icon.buff.count=button.icon.buff.count-1
    end
    for x=button.icon.buff.count,id,-1 do
        HealBot_UnitBuffIcons[button.id][x+1]["count"]=HealBot_UnitBuffIcons[button.id][x]["count"]
        HealBot_UnitBuffIcons[button.id][x+1]["spellId"]=HealBot_UnitBuffIcons[button.id][x]["spellId"]
        HealBot_UnitBuffIcons[button.id][x+1]["expirationTime"]=HealBot_UnitBuffIcons[button.id][x]["expirationTime"]
        HealBot_UnitBuffIcons[button.id][x+1]["unitCaster"]=HealBot_UnitBuffIcons[button.id][x]["unitCaster"]
        HealBot_UnitBuffIcons[button.id][x+1].nextUpdate=HealBot_UnitBuffIcons[button.id][x].nextUpdate
        HealBot_UnitBuffIcons[button.id][x+1].current=false
    end
      --HealBot_setCall("HealBot_Aura_BumpBuffIcon")
end

function HealBot_Aura_CacheBuffIcon(button, id, TimeNow)
    if HealBot_UnitBuffIcons[button.id][id]["spellId"]~=uaSpellId then
        HealBot_UnitBuffIcons[button.id][id]["spellId"]=uaSpellId
        HealBot_UnitBuffIcons[button.id][id]["count"]=uaCount
        HealBot_UnitBuffIcons[button.id][id]["expirationTime"]=uaExpirationTime
        HealBot_UnitBuffIcons[button.id][id].current=false
        if HealBot_UnitBuffIcons[button.id][id]["expirationTime"]>0 then
            HealBot_UnitBuffIcons[button.id][id].nextUpdate=(HealBot_UnitBuffIcons[button.id][id]["expirationTime"]-1)-HealBot_UpdateIconFreq["BUFF"][button.frame]
        else
            HealBot_UnitBuffIcons[button.id][id].nextUpdate=TimeNow+1000000
        end
    elseif HealBot_UnitBuffIcons[button.id][id]["count"]~=uaCount or HealBot_UnitBuffIcons[button.id][id]["expirationTime"]~=uaExpirationTime then
        HealBot_UnitBuffIcons[button.id][id]["count"]=uaCount
        HealBot_UnitBuffIcons[button.id][id]["expirationTime"]=uaExpirationTime
        HealBot_UnitBuffIcons[button.id][id].nextUpdate=TimeNow
        button.aura.buff.nextupdate=TimeNow
    end
    HealBot_UnitBuffIcons[button.id][id]["unitCaster"]=uaUnitCaster
      --HealBot_setCall("HealBot_Aura_CacheBuffIcon")
end

local debuffIndex=0
function HealBot_Aura_CheckUnitDebuffIcons(button, TimeNow)
    if button.icon.debuff.count<HealBot_Aura_luVars["prevIconCount"] then 
        for i = HealBot_Aura_luVars["prevIconCount"], button.icon.debuff.count+1, -1 do
            debuffIndex=50+i
            HealBot_UnitDebuffIcons[button.id][debuffIndex].current=false
            HealBot_Aura_RemoveIcon(button, debuffIndex)
            HealBot_UnitDebuffIcons[button.id][debuffIndex].nextUpdate=TimeNow+1000000
        end
    end    
    if button.icon.debuff.count>0 then
        for i = 51, 50+button.icon.debuff.count do
            if not HealBot_UnitDebuffIcons[button.id][i].current then
                    HealBot_UnitDebuffIcons[button.id][i].current=true
                    HealBot_Aura_DebuffAddIcon(button, i, TimeNow)
            end
        end
        if button.aura.debuff.nextupdate>TimeNow+HealBot_iconUpdate["DEBUFF"][button.frame] then
            button.aura.debuff.nextupdate=TimeNow+HealBot_iconUpdate["DEBUFF"][button.frame]
        end
    end
      --HealBot_setCall("HealBot_Aura_CheckUnitDebuffIcons")
end

local hasBuffTypes, ownBlessing = false, false
function HealBot_Aura_HasBuffTypes(spellName, pBuffTypes)
    hasBuffTypes = false
    if HealBot_BuffNameTypes[spellName] then
        if pBuffTypes[HealBot_BuffNameTypes[spellName]] or (ownBlessing and HealBot_BuffNameTypes[spellName]<7 and HealBot_Config_Buffs.PalaBlessingsAsOne) then
            hasBuffTypes = true
        end
    end
      --HealBot_setCall("HealBot_Aura_HasBuffTypes")
    return hasBuffTypes
end

local curBuffName,curBuffxTime=false,0
local buffCheckThis, buffWatchTarget, buffSpellStart, buffSpellDur=false,false,0,0
local customBuffPriority=HEALBOT_CUSTOM_en.."Buff"
function HealBot_Aura_CheckGeneralBuff(button, TimeNow)  
    PlayerBuffsList=button.aura.buff.recheck
    for bName,nexttime in pairs (PlayerBuffsList) do
        if not PlayerBuffs[bName] then
            PlayerBuffsList[bName]=nil
            button.aura.buff.nextcheck=1
        elseif nexttime < TimeNow then
            PlayerBuffs[bName]=false
        end
    end
    for bName,_ in pairs(HealBot_BuffWatch) do
        if not PlayerBuffs[bName] and not HealBot_Aura_HasBuffTypes(bName, PlayerBuffTypes) then
            buffSpellStart, buffSpellDur=0,0
            if GetSpellCooldown(bName) then
                buffSpellStart, buffSpellDur=GetSpellCooldown(bName)
                if bName==HEALBOT_ICE_BARRIER then 
                    HealBot_AddDebug("Here start="..buffSpellStart.."  Dur="..buffSpellDur)
                end
            elseif HealBot_Buff_ItemIDs[bName] then
                buffSpellStart, buffSpellDur=GetItemCooldown(HealBot_Buff_ItemIDs[bName])
            end 
            if ((buffSpellStart or 0)+(buffSpellDur or 0))-TimeNow<2 then
                buffCheckThis=false;
                buffWatchTarget=HealBot_Options_retBuffWatchTarget(bName);
                if buffWatchTarget["Raid"] then
                    buffCheckThis=true;
                elseif buffWatchTarget[button.text.classtrim] then
                    buffCheckThis=true
                elseif buffWatchTarget["Party"] and button.group==HealBot_Data["PLAYERGROUP"] then 
                    buffCheckThis=true
                elseif buffWatchTarget["MainTanks"] and HealBot_Panel_IsTank(button.guid) then
                    buffCheckThis=true;
                elseif buffWatchTarget["SingleTank"] and UnitIsUnit(button.unit, HealBot_Aura_luVars["TankUnit"]) then
                    buffCheckThis=true
                elseif buffWatchTarget["Self"] and button.guid==HealBot_Data["PGUID"] then
                    buffCheckThis=true
                elseif buffWatchTarget["Name"] and button.guid==HealBot_Config.MyFriend then
                    buffCheckThis=true
                elseif buffWatchTarget["Focus"] and UnitIsUnit(button.unit, "focus") then
                    buffCheckThis=true
                elseif buffWatchTarget["MyTargets"] then
                    local myhTargets=HealBot_GetMyHealTargets();
                    for i=1, #myhTargets do
                        if button.guid==myhTargets[i] then
                            buffCheckThis=true;
                            break;
                        end
                    end
                elseif buffWatchTarget["PvP"] and UnitIsPVP(button.unit) then
                    buffCheckThis=true
                elseif buffWatchTarget["PvE"] and not UnitIsPVP(button.unit) then
                    buffCheckThis=true
                end
                if buffCheckThis then
                    curBuffName=bName
                    button.aura.buff.missingbuff=true
                    if not button.aura.buff.colbar then
                        button.aura.buff.colbar=true
                        button.aura.buff.priority=20
                    end
                    break
                end
            else
                button.aura.buff.recheck[bName] = (TimeNow-buffSpellStart)+buffSpellDur
                button.aura.buff.nextcheck=1
            end
        end
    end
      --HealBot_setCall("HealBot_Aura_CheckGeneralBuff")
end

local buffCustomType,scbUnitClassEN,scbUnitClassTrim="nil","nil","nil"
function HealBot_Aura_ShowCustomBuff(button)
    buffCustomType=HealBot_Watch_HoT[uaSpellId] or HealBot_Watch_HoT[uaName]
    if buffCustomType then
        if buffCustomType=="S" then
            if uaUnitCaster=="player" then 
                return true
            end
        elseif buffCustomType=="A" then
            return true
        elseif buffCustomType=="C" then
            _, scbUnitClassEN = UnitClass(uaUnitCaster)
            scbUnitClassTrim = strsub(scbUnitClassEN or "XXXX",1,4)
            if HealBot_Data["PCLASSTRIM"]==scbUnitClassTrim then
                return true
            end
        end
    end
    return false
end

local ciCustomBuff=false
function HealBot_Aura_CheckCurBuff(button)
    ciCustomBuff=HealBot_Aura_ShowCustomBuff(button)
    if ciCustomBuff or HealBot_BuffWatch[uaName] or HealBot_BuffNameTypes[uaName] then
        if not HealBot_AuraBuffCache[uaSpellId] then
            HealBot_AuraBuffCache[uaSpellId]={}
            HealBot_AuraBuffCache[uaSpellId]["priority"]=HealBot_Globals.HealBot_Custom_Buffs[uaSpellId] or HealBot_Globals.HealBot_Custom_Buffs[uaName] or 15
            HealBot_AuraBuffCache[uaSpellId]["texture"]=uaTexture
            HealBot_AuraBuffCache[uaSpellId]["name"]=uaName
            HealBot_AuraBuffCache[uaSpellId].custom=ciCustomBuff
            if HealBot_SpellID_LookupData[uaName] and HealBot_SpellID_LookupData[uaName]["CHECK"] then
                HealBot_SpellID_LookupData[uaName]["CHECK"]=false
                HealBot_SpellID_LookupData[uaName]["ID"]=uaSpellId
                table.insert(HealBot_SpellID_LookupIdx,uaName)
            end
        end
        return true
    else
        return false
    end
end

local hbCustomBuffsDisabled={}
function HealBot_Aura_setCustomBuffFilterDisabled()
    for id,_ in pairs(hbCustomBuffsDisabled) do
        hbCustomBuffsDisabled[id]=false
    end
    for id, _ in pairs(HealBot_Globals.IgnoreCustomBuff) do
        local name, _, _, _, _, _, _ = GetSpellInfo(id)
        if (HealBot_Globals.CustomBuffIDMethod[id] or 3)<3 then
            if HealBot_Globals.CustomBuffIDMethod[id]==1 then
                hbCustomBuffsDisabled[id]={}
            elseif name then 
                hbCustomBuffsDisabled[name]={}
            end
        else
            if name then hbCustomBuffsDisabled[name]={} end
            hbCustomBuffsDisabled[id]={}
        end
        for instName, disabled in pairs(HealBot_Globals.IgnoreCustomBuff[id]) do
            if (HealBot_Globals.CustomBuffIDMethod[id] or 3)<3 then
                if HealBot_Globals.CustomBuffIDMethod[id]==1 then
                    hbCustomBuffsDisabled[id][instName]=disabled
                elseif name then 
                    hbCustomBuffsDisabled[name][instName]=disabled
                end
            else
                if name then hbCustomBuffsDisabled[name][instName]=disabled end
                hbCustomBuffsDisabled[id][instName]=disabled
            end
        end
    end
    for id,_ in pairs(hbCustomBuffsDisabled) do
        if not hbCustomBuffsDisabled[id] then hbCustomBuffsDisabled[id]=nil end
    end
end

local hbABuffPrio=15
function HealBot_Aura_SetBuffIcon(button, TimeNow)
    if (hbCustomBuffsDisabled[uaSpellId] and (hbCustomBuffsDisabled[uaSpellId][HealBot_Aura_luVars["hbInsName"]] or hbCustomBuffsDisabled[uaSpellId]["ALL"])) or
       (hbCustomBuffsDisabled[uaName] and (hbCustomBuffsDisabled[uaName][HealBot_Aura_luVars["hbInsName"]] or hbCustomBuffsDisabled[uaName]["ALL"])) then
        return
    else
        hbABuffPrio=HealBot_Globals.HealBot_Custom_Buffs[uaSpellId] or HealBot_Globals.HealBot_Custom_Buffs[uaName] or 15
        if button.icon.buff.count>0 then
            for x=1, button.icon.buff.count do
                if HealBot_AuraBuffCache[HealBot_UnitBuffIcons[button.id][x]["spellId"]]["priority"]>hbABuffPrio then
                    if x<Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] then
                        HealBot_Aura_BumpBuffIcon(button,x) 
                        button.icon.buff.count=button.icon.buff.count+1
                    end
                    HealBot_Aura_CacheBuffIcon(button, x, TimeNow)
                    return
                end
            end
            if button.icon.buff.count<Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] then
                button.icon.buff.count=button.icon.buff.count+1
                HealBot_Aura_CacheBuffIcon(button, button.icon.buff.count, TimeNow)
            end
        else
            button.icon.buff.count=button.icon.buff.count+1
            HealBot_Aura_CacheBuffIcon(button, button.icon.buff.count, TimeNow)
        end
    end
      --HealBot_setCall("HealBot_Aura_SetBuffIcon")
end

local castByListIndexed={[HEALBOT_CUSTOM_CASTBY_EVERYONE]=1,
                         [HEALBOT_CUSTOM_CASTBY_ENEMY]=2,
                         [HEALBOT_CUSTOM_CASTBY_FRIEND]=3,
                         [HEALBOT_OPTIONS_SELFHEALS]=4,
                        }
function HealBot_Aura_setCDebuffCasyByIndexed(CDebuffCasyByList)
    castByListIndexed = CDebuffCasyByList
end

function HealBot_Aura_setCustomDebuffFilterCastBy()
    for id,_ in pairs(hbCustomDebuffsCastBy) do
        hbCustomDebuffsCastBy[id]=false
    end
    for id, x in pairs(HealBot_Globals.FilterCustomDebuff) do
        local name, _, _, _, _, _, _ = GetSpellInfo(id)
        if (HealBot_Globals.CustomDebuffIDMethod[id] or 3)<3 then
            if HealBot_Globals.CustomDebuffIDMethod[id]==1 then
                hbCustomDebuffsCastBy[id]=x
            elseif name then 
                hbCustomDebuffsCastBy[name]=x
            end
        else
            if name then hbCustomDebuffsCastBy[name]=x end
            hbCustomDebuffsCastBy[id]=x
        end
    end
    for id,_ in pairs(hbCustomDebuffsCastBy) do
        if not hbCustomDebuffsCastBy[id] then hbCustomDebuffsCastBy[id]=nil end
    end
end

function HealBot_Aura_setCustomDebuffFilterDisabled()
    for id,_ in pairs(hbCustomDebuffsDisabled) do
        hbCustomDebuffsDisabled[id]=false
    end
    for id, _ in pairs(HealBot_Globals.IgnoreCustomDebuff) do
        local name, _, _, _, _, _, _ = GetSpellInfo(id)
        if (HealBot_Globals.CustomDebuffIDMethod[id] or 3)<3 then
            if HealBot_Globals.CustomDebuffIDMethod[id]==1 then
                hbCustomDebuffsDisabled[id]={}
            elseif name then 
                hbCustomDebuffsDisabled[name]={}
            end
        else
            if name then hbCustomDebuffsDisabled[name]={} end
            hbCustomDebuffsDisabled[id]={}
        end
        for instName, disabled in pairs(HealBot_Globals.IgnoreCustomDebuff[id]) do
            if (HealBot_Globals.CustomDebuffIDMethod[id] or 3)<3 then
                if HealBot_Globals.CustomDebuffIDMethod[id]==1 then
                    hbCustomDebuffsDisabled[id][instName]=disabled
                elseif name then 
                    hbCustomDebuffsDisabled[name][instName]=disabled
                end
            else
                if name then hbCustomDebuffsDisabled[name][instName]=disabled end
                hbCustomDebuffsDisabled[id][instName]=disabled
            end
        end
    end
    for id,_ in pairs(hbCustomDebuffsDisabled) do
        if not hbCustomDebuffsDisabled[id] then hbCustomDebuffsDisabled[id]=nil end
    end
end

local dNamePriority, dTypePriority=99,99
local spellCD, debuffIsCurrent, cDebuffPrio, debuffIsAlways, debuff_Type, debuffIsCustom, debuffIsNever=0, true, 15, false, debuffType, false, false
local ccdbCasterID, ccdbUnitCasterID, ccdbCheckthis, ccdbAlways=0,1,false,false
local ccdbWatchTarget={}
function HealBot_Aura_CheckCurCustomDebuff(button, canBeAlways)
    ccdbCasterID=hbCustomDebuffsCastBy[uaName] or hbCustomDebuffsCastBy[uaSpellId] or HealBot_Globals.CureCustomDefaultCastBy
    if ccdbCasterID~=castByListIndexed[HEALBOT_CUSTOM_CASTBY_EVERYONE] then
        if uaUnitCaster=="player" then
            ccdbUnitCasterID=castByListIndexed[HEALBOT_OPTIONS_SELFHEALS]
            if ccdbCasterID==castByListIndexed[HEALBOT_CUSTOM_CASTBY_FRIEND] then 
                ccdbCasterID=castByListIndexed[HEALBOT_OPTIONS_SELFHEALS]
            end
        elseif UnitIsFriend("player",uaUnitCaster) then
            ccdbUnitCasterID=castByListIndexed[HEALBOT_CUSTOM_CASTBY_FRIEND]
        else
            ccdbUnitCasterID=castByListIndexed[HEALBOT_CUSTOM_CASTBY_ENEMY]
        end
    else
        ccdbUnitCasterID=castByListIndexed[HEALBOT_CUSTOM_CASTBY_EVERYONE]
    end
    if ccdbUnitCasterID==ccdbCasterID then 
        debuff_Type=HEALBOT_CUSTOM_en
        cDebuffPrio=dNamePriority
        if ccdbCasterID==1 and canBeAlways then --hbCastByEveryone then 
            debuffIsAlways=true 
            debuffIsCustom=true
        end
    else
        debuffIsCurrent=false
    end
end

function HealBot_Aura_CacheDebuff(spellId, spellName, debuffIsCustom, debuffIsAlways, debuffTexture, debuffType)
    HealBot_AuraDebuffCache[spellId]={}
    HealBot_AuraDebuffCache[spellId].customType=debuffIsCustom
    HealBot_AuraDebuffCache[spellId].always=debuffIsAlways
    HealBot_AuraDebuffCache[spellId]["texture"]=debuffTexture
    HealBot_AuraDebuffCache[spellId]["debuffType"]=debuffType
    HealBot_AuraDebuffCache[spellId]["name"]=spellName
    if HealBot_Globals.CatchAltDebuffIDs[name] then
        if not HealBot_Globals.HealBot_Custom_Debuffs[spellId] then
            HealBot_Aura_AutoUpdateCustomDebuff(button, name, spellId)
        else
            HealBot_Globals.CatchAltDebuffIDs[name]=nil
        end
    end
end

function HealBot_Aura_CheckCurDebuff(button, TimeNow)
    spellCD, debuffIsCurrent, cDebuffPrio, debuffIsAlways, debuff_Type, debuffIsCustom, debuffIsNever=0, true, 20, false, uaDebuffType, false, false
    if HealBot_Config_Cures.IgnoreOnCooldownDebuffs then
        spellCD=HealBot_Options_retDebuffWatchTargetCD(uaDebuffType, TimeNow)
        if spellCD>2 then
            HealBot_Aura_luVars["prevDebuffID"]=0
            if spellCD<15 and HealBot_Aura_luVars["MaskAuraDCheck"]<TimeNow then 
                HealBot_Aura_luVars["MaskAuraDCheck"]=(TimeNow+spellCD)-0.25
                HealBot_setLuVars("MaskAuraDCheck", HealBot_Aura_luVars["MaskAuraDCheck"])
                HealBot_setLuVars("MaskAuraReCheck", true)
                HealBot_CheckAllActiveDebuffs()
            end
        elseif HealBot_Aura_luVars["MaskAuraDCheck"]<TimeNow then
            spellCD=0
        end
    end
    dNamePriority, dTypePriority=HealBot_Options_retDebuffPriority(uaSpellId, uaName, uaDebuffType)
    if (hbCustomDebuffsDisabled[uaSpellId] and (hbCustomDebuffsDisabled[uaSpellId][HealBot_Aura_luVars["hbInsName"]] or hbCustomDebuffsDisabled[uaSpellId]["ALL"])) or
       (hbCustomDebuffsDisabled[uaName] and (hbCustomDebuffsDisabled[uaName][HealBot_Aura_luVars["hbInsName"]] or hbCustomDebuffsDisabled[uaName]["ALL"])) then
        debuffIsCurrent=false
        if not HealBot_Spell_Names[uaName] then debuffIsNever=true end
    elseif dTypePriority>dNamePriority and dNamePriority<21 then
        HealBot_Aura_CheckCurCustomDebuff(button, true)
    else
        ccdbCheckthis=false
        if dTypePriority<21 and spellCD<0.2 and 
          (not HealBot_Config_Cures.IgnoreFriendDebuffs or not UnitIsFriend("player",uaUnitCaster)) and
          (uaDuration==0 or uaDuration>=HealBot_Aura_luVars["IgnoreFastDurDebuffsSecs"]) then
            ccdbWatchTarget=HealBot_Options_retDebuffWatchTarget(uaDebuffType);
            if ccdbWatchTarget then
                if ccdbWatchTarget["Raid"] then
                    ccdbCheckthis=true;
                elseif ccdbWatchTarget[button.text.classtrim] then
                    ccdbCheckthis=true;
                elseif ccdbWatchTarget["Party"] and (UnitInParty(button.unit) or button.guid==HealBot_Data["PGUID"]) then 
                    ccdbCheckthis=true;
                elseif ccdbWatchTarget["MainTanks"] and HealBot_Panel_IsTank(button.guid) then
                    ccdbCheckthis=true;
                elseif ccdbWatchTarget["SingleTank"] and UnitIsUnit(button.unit, HealBot_Aura_luVars["TankUnit"]) then
                    ccdbCheckthis=true
                elseif ccdbWatchTarget["Self"] and button.guid==HealBot_Data["PGUID"] then
                    ccdbCheckthis=true
                elseif ccdbWatchTarget["Name"] and xGUID==HealBot_Config.MyFriend then
                    ccdbCheckthis=true
                elseif ccdbWatchTarget["Focus"] and UnitIsUnit(button.unit, "focus") then
                    ccdbCheckthis=true;
                elseif ccdbWatchTarget["MyTargets"] then
                    local myhTargets=HealBot_GetMyHealTargets();
                    for i=1, #myhTargets do
                        if button.guid==myhTargets[i] then
                            ccdbCheckthis=true;
                            break
                        end
                    end
                elseif ccdbWatchTarget["PvP"] and UnitIsPVP(button.unit) then
                    ccdbCheckthis=true
                elseif ccdbWatchTarget["PvE"] and not UnitIsPVP(button.unit) then
                    ccdbCheckthis=true
                end
            end
        end
        if ccdbCheckthis then
            cDebuffPrio=dTypePriority
            if not HealBot_Config_Cures.IgnoreOnCooldownDebuffs then debuffIsAlways=true end
        elseif (UnitIsEnemy("player",uaUnitCaster) and uaIsBossDebuff and HealBot_Config_Cures.AlwaysShowBoss and UnitExists("boss1")) or 
               (HealBot_Config_Cures.AlwaysShowTimed and uaDuration>0 and uaDuration<HealBot_Config_Cures.ShowTimeMaxDuration) or 
               (HealBot_Config_Cures.HealBot_Custom_Defuffs_All[uaDebuffType]) then
            debuff_Type=HEALBOT_CUSTOM_en
            cDebuffPrio=15
            if dTypePriority>15 then
                if HealBot_AuraDebuffCache[uaSpellId] then
                    HealBot_AuraDebuffCache[uaSpellId].customType=true
                    HealBot_AuraDebuffCache[uaSpellId].always=true
                else
                    debuffIsAlways=true 
                    debuffIsCustom=true
                end
            end
        elseif dNamePriority<21 then
            HealBot_Aura_CheckCurCustomDebuff(button, false)
        elseif UnitIsUnit(uaUnitCaster,"player") and not UnitIsFriend("player",button.unit) then
            debuff_Type=HEALBOT_CUSTOM_en
            cDebuffPrio=20
        else
            debuffIsCurrent=false
            if dTypePriority>20 and not HealBot_Spell_Names[uaName] then 
                debuffIsNever=true
            end
        end
    end
    if debuffIsCurrent then
        if not HealBot_AuraDebuffCache[uaSpellId] then
            HealBot_Aura_CacheDebuff(uaSpellId, uaName, debuffIsCustom, debuffIsAlways, uaTexture, uaDebuffType)
        end
        HealBot_AuraDebuffCache[uaSpellId]["priority"]=cDebuffPrio
    end
      --HealBot_setCall("HealBot_Aura_CheckCurDebuff")
    return debuffIsCurrent, debuff_Type, debuffIsNever
end


local hbAuxBuffAssigned={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}}
local hbAuxDebuffAssigned={[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={},[8]={},[9]={},[10]={}}
function HealBot_Aura_clearAuxAssigned()
    for f=1,9 do
        hbAuxBuffAssigned[f]={};
        hbAuxDebuffAssigned[f]={};
    end
end

function HealBot_Aura_setAuxAssigned(aType, frame, id)
    if aType=="BUFF" then
        hbAuxBuffAssigned[frame][id]=true
    else
        hbAuxDebuffAssigned[frame][id]=true
    end
end

function HealBot_Aura_UpdateAuraBuffBars(button)
    for id in pairs(hbAuxBuffAssigned[button.frame]) do
        if Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["COLOUR"]==1 then
            if HealBot_BuffWatch[button.aura.buff.name] and HealBot_Config_Buffs.HealBotBuffColR[HealBot_BuffWatch[button.aura.buff.name]] then
                button.aux[id]["R"]=HealBot_Config_Buffs.HealBotBuffColR[HealBot_BuffWatch[button.aura.buff.name]]
                button.aux[id]["G"]=HealBot_Config_Buffs.HealBotBuffColG[HealBot_BuffWatch[button.aura.buff.name]]
                button.aux[id]["B"]=HealBot_Config_Buffs.HealBotBuffColB[HealBot_BuffWatch[button.aura.buff.name]]
            else
                button.aux[id]["R"]=Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["R"]
                button.aux[id]["G"]=Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["G"]
                button.aux[id]["B"]=Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["B"]
            end
        end
        HealBot_setAuxBar(button, id, 1000, false)
    end
end

function HealBot_Aura_ClearAuraBuffBars(button)
    for id in pairs(hbAuxBuffAssigned[button.frame]) do
        HealBot_clearAuxBar(button, id)
    end
end

local buffUnitRange=0
function HealBot_Aura_BuffWarnings(button, TimeNow)
    if button.aura.buff.name~=curBuffName and (button.status.unittype~=5 or HealBot_Config_Buffs.ShowGroups[button.group]) then
        button.aura.buff.name=curBuffName
        if button.status.range>-1 then 
            HealBot_Aura_UpdateAuraBuffBars(button) 
        else
            HealBot_Aura_ClearAuraBuffBars(button)
        end
        if buffWarnings and (not HealBot_Aura_WarningFilter[button.unit][curBuffName] or HealBot_Aura_WarningFilter[button.unit][curBuffName]<TimeNow) then
            if HealBot_Config_Buffs.ShowBuffWarning and buffUnitRange>(HealBot_Config_Buffs.HealBot_CBWarnRange_Screen-3) then
                if button.aura.buff.missingbuff and HealBot_BuffWatch[button.aura.buff.name] and HealBot_Config_Buffs.HealBotBuffColR[HealBot_BuffWatch[button.aura.buff.name]] then
                    HealBot_Aura_WarningFilter[button.unit][curBuffName]=TimeNow+2
                    UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." requires "..button.aura.buff.name, 
                                             HealBot_Config_Buffs.HealBotBuffColR[HealBot_BuffWatch[button.aura.buff.name]],
                                             HealBot_Config_Buffs.HealBotBuffColG[HealBot_BuffWatch[button.aura.buff.name]],
                                             HealBot_Config_Buffs.HealBotBuffColB[HealBot_BuffWatch[button.aura.buff.name]],
                                             1, UIERRORS_HOLD_TIME);
                else
                    HealBot_Aura_WarningFilter[button.unit][curBuffName]=curBuffxTime
                    if HealBot_Globals.CustomBuffBarColour[button.aura.buff.id] then
                        UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." benefits from "..curBuffName, 
                                                 HealBot_Globals.CustomBuffBarColour[button.aura.buff.id].R,
                                                 HealBot_Globals.CustomBuffBarColour[button.aura.buff.id].G,
                                                 HealBot_Globals.CustomBuffBarColour[button.aura.buff.id].B,
                                                 1, UIERRORS_HOLD_TIME);
                    else
                        UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." benefits from "..curBuffName,
                                                 HealBot_Globals.CustomBuffBarColour[customBuffPriority].R,
                                                 HealBot_Globals.CustomBuffBarColour[customBuffPriority].G,
                                                 HealBot_Globals.CustomBuffBarColour[customBuffPriority].B,
                                                 1, UIERRORS_HOLD_TIME);
                    end
                end
            end
            if HealBot_Config_Buffs.SoundBuffWarning and buffUnitRange>(HealBot_Config_Buffs.HealBot_CBWarnRange_Sound-3) then
                HealBot_PlaySound(HealBot_Config_Buffs.SoundBuffPlay)
            end
        end
    end
    HealBot_Action_UpdateDebuffButton(button)
        --HealBot_setCall("HealBot_Aura_BuffWarnings")
end

local customDebuffPriority=HEALBOT_CUSTOM_en.."15"
function HealBot_Aura_UpdateAuraDebuffBars(button)
    if button and button.frame then
        for id in pairs(hbAuxDebuffAssigned[button.frame]) do
            if Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["COLOUR"]==1 then
                if HealBot_Globals.CDCBarColour[button.aura.debuff.id] then
                    button.aux[id]["R"]=HealBot_Globals.CDCBarColour[button.aura.debuff.id].R
                    button.aux[id]["G"]=HealBot_Globals.CDCBarColour[button.aura.debuff.id].G
                    button.aux[id]["B"]=HealBot_Globals.CDCBarColour[button.aura.debuff.id].B
                elseif HealBot_Globals.CDCBarColour[button.aura.debuff.name] then
                    button.aux[id]["R"]=HealBot_Globals.CDCBarColour[button.aura.debuff.name].R
                    button.aux[id]["G"]=HealBot_Globals.CDCBarColour[button.aura.debuff.name].G
                    button.aux[id]["B"]=HealBot_Globals.CDCBarColour[button.aura.debuff.name].B
                elseif button.aura.debuff.type == HEALBOT_CUSTOM_en then
                    button.aux[id]["R"]=HealBot_Globals.CDCBarColour[customDebuffPriority].R
                    button.aux[id]["G"]=HealBot_Globals.CDCBarColour[customDebuffPriority].G
                    button.aux[id]["B"]=HealBot_Globals.CDCBarColour[customDebuffPriority].B
                elseif HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type] then
                    button.aux[id]["R"]=HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type].R
                    button.aux[id]["G"]=HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type].G
                    button.aux[id]["B"]=HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type].B
                else
                    button.aux[id]["R"]=Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["R"]
                    button.aux[id]["G"]=Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["G"]
                    button.aux[id]["B"]=Healbot_Config_Skins.AuxBar[Healbot_Config_Skins.Current_Skin][id][button.frame]["B"]
                end
            end
            HealBot_setAuxBar(button, id, 1000, false)
        end
    end
end

function HealBot_Aura_ClearAuraDebuffBars(button)
    for id in pairs(hbAuxDebuffAssigned[button.frame]) do
        HealBot_clearAuxBar(button, id)
    end
end

local dbUnitRange=0
--local DebuffWarnSpamFilter={}
local curDebuffName,curDebuffxTime="",0
function HealBot_Aura_DebuffWarnings(button, TimeNow)
    if button.aura.debuff.name~=curDebuffName and (button.status.unittype~=5 or HealBot_Config_Cures.ShowGroups[button.group]) then
        button.aura.debuff.name=curDebuffName
        if button.status.range>-1 then 
            HealBot_Aura_UpdateAuraDebuffBars(button) 
        else
            HealBot_Aura_ClearAuraDebuffBars(button)
        end
        if debuffWarning and (not HealBot_Aura_WarningFilter[button.unit][curDebuffName] or HealBot_Aura_WarningFilter[button.unit][curDebuffName]<TimeNow) then
            HealBot_Aura_WarningFilter[button.unit][curDebuffName]=curDebuffxTime
            if HealBot_Config_Cures.ShowDebuffWarning then
                if dbUnitRange>(HealBot_Config_Cures.HealBot_CDCWarnRange_Screen-3) then
                    if HealBot_Globals.CDCBarColour[button.aura.debuff.id] then
                        UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." suffers from "..button.aura.debuff.name, 
                                                 HealBot_Globals.CDCBarColour[button.aura.debuff.id].R,
                                                 HealBot_Globals.CDCBarColour[button.aura.debuff.id].G,
                                                 HealBot_Globals.CDCBarColour[button.aura.debuff.id].B,
                                                 1, UIERRORS_HOLD_TIME);
                    elseif HealBot_Globals.CDCBarColour[button.aura.debuff.name] then
                        UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." suffers from "..button.aura.debuff.name, 
                                                 HealBot_Globals.CDCBarColour[button.aura.debuff.name].R,
                                                 HealBot_Globals.CDCBarColour[button.aura.debuff.name].G,
                                                 HealBot_Globals.CDCBarColour[button.aura.debuff.name].B,
                                                 1, UIERRORS_HOLD_TIME);
                    elseif button.aura.debuff.type == HEALBOT_CUSTOM_en then
                        UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." suffers from "..button.aura.debuff.name,
                                                 HealBot_Globals.CDCBarColour[customDebuffPriority].R,
                                                 HealBot_Globals.CDCBarColour[customDebuffPriority].G,
                                                 HealBot_Globals.CDCBarColour[customDebuffPriority].B,
                                                 1, UIERRORS_HOLD_TIME);
                    else
                        UIErrorsFrame:AddMessage(HealBot_GetUnitName(button.unit, button.guid).." suffers from "..button.aura.debuff.name, 
                                                 HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type].R,
                                                 HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type].G,
                                                 HealBot_Config_Cures.CDCBarColour[button.aura.debuff.type].B,
                                                 1, UIERRORS_HOLD_TIME);
                    end
                end
            end
            if HealBot_Config_Cures.SoundDebuffWarning and dbUnitRange>(HealBot_Config_Cures.HealBot_CDCWarnRange_Sound-3) then
                HealBot_PlaySound(HealBot_Config_Cures.SoundDebuffPlay)
            end
        end
        if Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["NDEBUFF"] then
            button.text.nameupdate=true
        end
        if Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["HDEBUFF"] then
            button.text.healthupdate=true
        end
    end
    HealBot_Action_UpdateDebuffButton(button)
        --HealBot_setCall("HealBot_Aura_DebuffWarnings")
end

local asbtPrevEndTime=0
function HealBot_Aura_SetUnitBuffTimer(button)
    asbtPrevEndTime=button.aura.buff.recheck[uaName] or 0
    if HealBot_ShortBuffs[uaName] then 
        button.aura.buff.recheck[uaName] = uaExpirationTime-HealBot_Config_Buffs.ShortBuffTimer
    else
        button.aura.buff.recheck[uaName] = uaExpirationTime-HealBot_Config_Buffs.LongBuffTimer
    end
    if asbtPrevEndTime~=button.aura.buff.recheck[uaName] then
        button.aura.buff.nextcheck=1
    end
      --HealBot_setCall("HealBot_Aura_SetUnitBuffTimer")
end

function HealBot_Aura_CheckUnitBuffIcons(button, TimeNow)
    if button.icon.buff.count<HealBot_Aura_luVars["prevBuffIconCount"] then 
        for i = HealBot_Aura_luVars["prevBuffIconCount"], button.icon.buff.count+1, -1 do
            HealBot_UnitBuffIcons[button.id][i].current=false
            HealBot_UnitBuffIcons[button.id][i].nextUpdate=TimeNow+1000000
            HealBot_Aura_RemoveIcon(button, i)
        end
    end
    if button.icon.buff.count>0 then
        for i = 1, button.icon.buff.count do
            if not HealBot_UnitBuffIcons[button.id][i].current then
                HealBot_UnitBuffIcons[button.id][i].current=true
                HealBot_Aura_AddBuffIcon(button, i, TimeNow)
            end
        end
        if button.aura.buff.nextupdate>TimeNow+HealBot_iconUpdate["BUFF"][button.frame] then
            button.aura.buff.nextupdate=TimeNow+HealBot_iconUpdate["BUFF"][button.frame]
        end
    end
      --HealBot_setCall("HealBot_Aura_CheckUnitBuffIcons")
end

local uaIsCurrent, uaNever, uaDbType, uaZ=false, false, false, 1
local onlyPlayers=false
function HealBot_Aura_CheckUnitAuras(button, TimeNow)
    button.aura.check=false
    uaZ=1
    uaIsCurrent=false
    HealBot_Aura_luVars["prevIconCount"]=button.icon.debuff.count
    button.icon.debuff.count=0
    button.aura.debuff.colbar=false
    if debuffCheck and button.status.current<9 then
        HealBot_Aura_luVars["prevDebuffID"]=button.aura.debuff.id or 0
        HealBot_Aura_luVars["prevDebuffType"]=button.aura.debuff.type or "x"
        button.aura.debuff.type=false
        curDebuffName=""
        while true do
            uaName=false
            if HEALBOT_GAME_VERSION<4 and libCD then
                uaName, uaTexture, uaCount, uaDebuffType, uaDuration, uaExpirationTime, uaUnitCaster, _, _, uaSpellId = libCD:UnitAura(button.unit,uaZ,"HARMFUL")
                if uaUnitCaster and (UnitClassification(uaUnitCaster)=="worldboss" or HealBot_UnitBosses(uaUnitCaster)) then
                    uaIsBossDebuff=true
                else
                    uaIsBossDebuff=false
                end
            else
                uaName, uaTexture, uaCount, uaDebuffType, uaDuration, uaExpirationTime, uaUnitCaster, _, _, uaSpellId, _, uaIsBossDebuff = UnitDebuff(button.unit,uaZ)
            end
            if uaName then
                uaZ=uaZ+1
                --if uaName=="Strange Aura" then uaDebuffType=HEALBOT_CURSE_en end
                if not HealBot_ExcludeDebuffInCache[uaSpellId] and uaExpirationTime then
                    uaIsCurrent, uaNever=true, false
                    if not uaUnitCaster then uaUnitCaster="nil" end
                    if not HealBot_AuraDebuffCache[uaSpellId] or not HealBot_AuraDebuffCache[uaSpellId].always then
                        uaIsCurrent, uaDbType, uaNever=HealBot_Aura_CheckCurDebuff(button, TimeNow) 
                    elseif HealBot_AuraDebuffCache[uaSpellId].customType then
                        uaDbType=HEALBOT_CUSTOM_en
                    else
                        uaDbType=uaDebuffType
                    end
                    if uaIsCurrent then
                        HealBot_Aura_SetDebuffIcon(button, TimeNow)
                    elseif uaNever then
                        HealBot_ExcludeDebuffInCache[uaSpellId]=true
                    end
                end
            else
                break
            end
        end
        HealBot_Aura_CheckUnitDebuffIcons(button, TimeNow)
        if HealBot_UnitDebuffIcons[button.id][51].current then
            if HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_UnitDebuffIcons[button.id][51]["spellId"]]==false or
               HealBot_Globals.HealBot_Custom_Debuffs_ShowBarCol[HealBot_AuraDebuffCache[HealBot_UnitDebuffIcons[button.id][51]["spellId"]]["name"]]==false then
                button.aura.debuff.colbar=false
            else
                button.aura.debuff.colbar=true
                button.aura.debuff.type=uaDbType
                curDebuffName=HealBot_AuraDebuffCache[HealBot_UnitDebuffIcons[button.id][51]["spellId"]]["name"]
                curDebuffxTime=HealBot_UnitDebuffIcons[button.id][51]["expirationTime"]
                button.aura.debuff.id=HealBot_UnitDebuffIcons[button.id][51]["spellId"]
                button.aura.debuff.priority=HealBot_AuraDebuffCache[HealBot_UnitDebuffIcons[button.id][51]["spellId"]]["priority"]
            end
        end
        if button.aura.debuff.type and UnitIsFriend("player",button.unit) then 
            HealBot_Aura_DebuffWarnings(button, TimeNow)
        elseif button.aura.debuff.name then 
            HealBot_Aura_ClearDebuff(button, true)
        end
    else
        HealBot_Aura_ClearDebuff(button, true)
    end
    
    button.aura.buff.missingbuff=false
    button.aura.buff.colbar=false
    if UnitOnTaxi("player") then
        button.aura.buff.nextcheck=TimeNow
        HealBot_Aura_ClearBuff(button, true)
    elseif buffCheck and button.status.current<9 then 
        uaZ=1
        HealBot_Aura_luVars["prevBuffIconCount"]=button.icon.buff.count
        button.icon.buff.count=0
        curBuffName=false;
        if generalBuffs then
            if UnitIsUnit("player", button.unit) then
                onlyPlayers=true
            elseif HEALBOT_GAME_VERSION>3 then
                onlyPlayers=UnitIsPlayer(button.unit)
            else
                onlyPlayers=UnitIsFriend("player",button.unit)
            end
            if onlyPlayers then 
                for x,_ in pairs(PlayerBuffs) do
                    PlayerBuffs[x]=false;
                end
                for x,_ in pairs(PlayerBuffTypes) do
                    PlayerBuffTypes[x]=false;
                end
                ownBlessing=false
            end
        end
        while true do
            uaName=false
            if HEALBOT_GAME_VERSION<4 and libCD then
                uaName, uaTexture, uaCount, uaDebuffType, uaDuration, uaExpirationTime, uaUnitCaster, _, _, uaSpellId = libCD:UnitAura(button.unit,uaZ,"HELPFUL")
            else
                uaName, uaTexture, uaCount, uaDebuffType, uaDuration, uaExpirationTime, uaUnitCaster, _, _, uaSpellId = UnitBuff(button.unit,uaZ)
            end
            if uaName then
                uaZ=uaZ+1
                if HealBot_Buff_Aura2Item[uaName] then
                    uaName=GetItemInfo(HealBot_Buff_Aura2Item[uaName]) or uaName
                end
                if not HealBot_ExcludeBuffInCache[uaSpellId] and uaExpirationTime then
                    if not uaUnitCaster then uaUnitCaster="nil" end
                    uaIsCurrent=HealBot_Aura_CheckCurBuff(button)
                    if uaIsCurrent then
                        curBuffxTime=uaExpirationTime
                        if HealBot_AuraBuffCache[uaSpellId].custom then
                            HealBot_Aura_SetBuffIcon(button, TimeNow)
                        end
                        if generalBuffs and onlyPlayers and (HealBot_BuffWatch[uaName] or HealBot_BuffNameTypes[uaName]) then
                            if HealBot_BuffNameTypes[uaName] and (not button.aura.buff.recheck[uaName] or button.aura.buff.recheck[uaName]>TimeNow) then
                                if HealBot_BuffNameTypes[uaName] then
                                    if HealBot_BuffNameTypes[uaName]<7 and button.unit==uaUnitCaster then ownBlessing=true end
                                    PlayerBuffTypes[HealBot_BuffNameTypes[uaName]]=true
                                end
                            end
                            PlayerBuffs[uaName]=true
                            if HealBot_CheckBuffs[uaName] and uaExpirationTime>0 and (HEALBOT_GAME_VERSION>3 or UnitIsUnit(uaUnitCaster,"player")) then
                                HealBot_Aura_SetUnitBuffTimer(button)
                            elseif button.aura.buff.recheck[uaName] then
                                button.aura.buff.recheck[uaName]=nil
                                button.aura.buff.nextcheck=1
                            end
                        end
                    elseif not HealBot_Watch_HoT[uaSpellId] and not HealBot_Watch_HoT[uaName] then
                        HealBot_ExcludeBuffInCache[uaSpellId]=true
                    end
                end
            else
                break
            end
        end
        if generalBuffs and onlyPlayers then
            HealBot_Aura_CheckGeneralBuff(button, TimeNow) 
        end
        HealBot_Aura_CheckUnitBuffIcons(button, TimeNow)
        if HealBot_UnitBuffIcons[button.id][1].current and 
          (HealBot_Globals.HealBot_Custom_Buffs_ShowBarCol[HealBot_UnitBuffIcons[button.id][1]["spellId"]] or 
           HealBot_Globals.HealBot_Custom_Buffs_ShowBarCol[HealBot_AuraBuffCache[HealBot_UnitBuffIcons[button.id][1]["spellId"]]["name"]]) then
            curBuffName=HealBot_AuraBuffCache[HealBot_UnitBuffIcons[button.id][1]["spellId"]]["name"]
            button.aura.buff.colbar=true
            button.aura.buff.id=HealBot_UnitBuffIcons[button.id][1]["spellId"]
            button.aura.buff.priority=HealBot_AuraBuffCache[HealBot_UnitBuffIcons[button.id][1]["spellId"]]["priority"]
        end
        if curBuffName then
            HealBot_Aura_BuffWarnings(button, TimeNow)
        elseif button.aura.buff.name then 
            HealBot_Aura_ClearBuff(button, true)
        end
    else
        HealBot_Aura_ClearBuff(button, true)
    end
end

local vUpdateIcons=false
function HealBot_Aura_CheckUnitsWithoutEvents(button, TimeNow)
    vUpdateIcons=false
    if HealBot_UnitBuffIcons[button.id] then
        for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] do
            if HealBot_UnitBuffIcons[button.id][i].current then
                vUpdateIcons=true
                break
            end
        end
    end
    if not vUpdateIcons and HealBot_UnitDebuffIcons[button.id] then
        for i = 51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"]+50 do
            if HealBot_UnitDebuffIcons[button.id][i].current then
                vUpdateIcons=true
                break
            end
        end
    end
    if vUpdateIcons then
        if UnitIsFriend("player",button.unit) then
            HealBot_Aura_CheckUnitAuras(button, TimeNow)
        else
            HealBot_Aura_RefreshEnemyAuras(button, TimeNow)
        end
    end
        --HealBot_setCall("HealBot_Aura_CheckUnitsWithoutEvents")
end

local lowTime=0
local PlayerBuffsList={}
function HealBot_Aura_ResetCheckBuffsTime(button, TimeNow)
    lowTime=TimeNow+10000000
    PlayerBuffsList=button.aura.buff.recheck
    button.aura.buff.nextcheck=false
    for name,nexttime in pairs (PlayerBuffsList) do
        if nexttime<0 then
            PlayerBuffsList[name]=nil
        elseif nexttime < lowTime then
            lowTime=nexttime
            button.aura.buff.nextcheck=nexttime
        end
    end
      --HealBot_setCall("HealBot_Aura_ResetCheckBuffsTime")
end

function HealBot_Aura_SetAuraWarningFlags()
    if HealBot_Config_Buffs.SoundBuffWarning or HealBot_Config_Buffs.ShowBuffWarning then
        buffWarnings=true
    else
        buffWarnings=false
    end
    if HealBot_Config_Buffs.SoundDebuffWarning or HealBot_Config_Buffs.ShowDebuffWarning then
        debuffWarning=true
    else
        debuffWarning=false
    end
end

function HealBot_Aura_SetAuraCheckFlags()
    tmpBCheck=buffCheck
    tmpGBuffs=generalBuffs
    tmpDCheck=debuffCheck
    
    if HealBot_Config_Buffs.NoAuraWhenRested and IsResting() then 
        buffCheck=false 
    elseif HealBot_Config_Buffs.BuffWatch then
        buffCheck=true
        if (not HealBot_Config_Buffs.BuffWatchWhenGrouped or GetNumGroupMembers()>0) and (HealBot_Config_Buffs.BuffWatchInCombat or not HealBot_Data["UILOCK"]) then
            generalBuffs=true
        else
            generalBuffs=false
        end
    else
        buffCheck=false 
    end
    
    if HealBot_Config_Buffs.NoAuraWhenRested and IsResting() then 
        debuffCheck=false 
    elseif HealBot_Config_Cures.DebuffWatch and 
           (not HealBot_Config_Cures.DebuffWatchWhenGrouped or GetNumGroupMembers()>0) and 
           (HealBot_Config_Cures.DebuffWatchInCombat or not HealBot_Data["UILOCK"])  then
        debuffCheck=true
    else
        debuffCheck=false
    end
    
    if tmpBCheck~=buffCheck or tmpGBuffs~=generalBuffs or tmpDCheck~=debuffCheck then
        HealBot_AuraCheck()
    end
end

function HealBot_Aura_ClearDebuff(button, updButton)
    if button.aura.debuff.name then
        button.aura.debuff.type = false;
        button.aura.debuff.name = false;
        button.aura.debuff.colbar=false
        button.aura.debuff.id=0
        button.aura.debuff.priority = 99;
        HealBot_Aura_ClearAuraDebuffBars(button)
        if Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["NDEBUFF"] then
            button.text.nameupdate=true
        end
        if Healbot_Config_Skins.BarTextCol[Healbot_Config_Skins.Current_Skin][button.frame]["HDEBUFF"] then
            button.text.healthupdate=true
        end
        if updButton then HealBot_Action_UpdateDebuffButton(button) end
    end
        --HealBot_setCall("HealBot_Aura_ClearDebuff")
end

function HealBot_Aura_ClearBuff(button, updButton)
    if button.aura.buff.name then
        button.aura.buff.name=false
        button.aura.buff.colbar=false
        button.aura.buff.priority=99
        if updButton then HealBot_Action_UpdateDebuffButton(button) end
        HealBot_Aura_ClearAuraBuffBars(button)
    end
        --HealBot_setCall("HealBot_Aura_ClearBuff")
end

function HealBot_Aura_ClearAllBuffs(updButton)
    for _,xButton in pairs(HealBot_Unit_Button) do
        HealBot_Aura_ClearBuff(xButton, updButton)
    end
    for _,xButton in pairs(HealBot_Private_Button) do
        HealBot_Aura_ClearBuff(xButton, updButton)
    end
    for _,xButton in pairs(HealBot_Pet_Button) do
        HealBot_Aura_ClearBuff(xButton, updButton)
    end
    for _,xButton in pairs(HealBot_Extra_Button) do
        HealBot_Aura_ClearBuff(xButton, updButton)
    end
      --HealBot_setCall("HealBot_Aura_ClearAllBuffs")
end

function HealBot_Aura_ClearAllDebuffs(updButton)
    for _,xButton in pairs(HealBot_Unit_Button) do
        HealBot_Aura_ClearDebuff(xButton, updButton)
    end
    for _,xButton in pairs(HealBot_Private_Button) do
        HealBot_Aura_ClearDebuff(xButton, updButton)
    end
    for _,xButton in pairs(HealBot_Pet_Button) do
        HealBot_Aura_ClearDebuff(xButton, updButton)
    end
    for _,xButton in pairs(HealBot_Extra_Button) do
        HealBot_Aura_ClearDebuff(xButton, updButton)
    end
        --HealBot_setCall("HealBot_Aura_ClearAllDebuffs")
end

local eaName, eaTexture, eaCount, eaDebuffType, eaExpirationTime, eaUnitCaster, eaSpellId, eaZ = false,false,false,false,false,false,false,1
function HealBot_Aura_SetEnemyDebuffIcon(button, id, TimeNow)
    if not HealBot_AuraDebuffCache[eaSpellId] then
        HealBot_Aura_CacheDebuff(eaSpellId, eaName, true, false, eaTexture, eaDebuffType)
    end
    if HealBot_UnitDebuffIcons[button.id][id]["spellId"]~=eaSpellId then
        HealBot_UnitDebuffIcons[button.id][id]["count"]=eaCount
        HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]=eaExpirationTime
        HealBot_UnitDebuffIcons[button.id][id]["spellId"]=eaSpellId
        HealBot_UnitDebuffIcons[button.id][id].current=false
        if HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]>0 then
            HealBot_UnitDebuffIcons[button.id][id].nextUpdate=(HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]-1)-HealBot_UpdateIconFreq["DEBUFF"][button.frame]
        else
            HealBot_UnitDebuffIcons[button.id][id].nextUpdate=TimeNow+1000000
        end
    elseif HealBot_UnitDebuffIcons[button.id][id]["count"]~=eaCount or HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]~=eaExpirationTime then
        HealBot_UnitDebuffIcons[button.id][id]["count"]=eaCount
        HealBot_UnitDebuffIcons[button.id][id]["expirationTime"]=eaExpirationTime
        HealBot_UnitDebuffIcons[button.id][id].nextUpdate=TimeNow
        button.aura.debuff.nextupdate=TimeNow
    end
      --HealBot_setCall("HealBot_Aura_SetEnemyDebuffIcon")
end

function HealBot_Aura_RefreshEnemyAuras(button, TimeNow)
    eaZ=1        
    HealBot_Aura_luVars["prevIconCount"]=button.icon.debuff.count
    button.icon.debuff.count=0
    while true do
        eaName=false
        if HEALBOT_GAME_VERSION<4 and libCD then
            eaName, eaTexture, eaCount, eaDebuffType, _, eaExpirationTime, eaUnitCaster, _, _, eaSpellId = libCD:UnitAura(button.unit,eaZ,"HARMFUL")
        else
            eaName, eaTexture, eaCount, eaDebuffType, _, eaExpirationTime, eaUnitCaster, _, _, eaSpellId = UnitDebuff(button.unit,eaZ)
        end
        if eaSpellId then
            eaZ=eaZ+1
            if not HealBot_ExcludeEnemyInCache[eaSpellId] and eaExpirationTime then
                if not eaUnitCaster then eaUnitCaster="nil" end
                if not UnitIsFriend("player",button.unit) and UnitIsUnit(eaUnitCaster,"player") then
                    if button.icon.debuff.count < Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"] then
                        button.icon.debuff.count=button.icon.debuff.count+1
                        HealBot_Aura_SetEnemyDebuffIcon(button, 50+button.icon.debuff.count, TimeNow)
                    end
                elseif not HealBot_Spell_IDs[eaSpellId] or not HealBot_Spell_IDs[eaSpellId].known then
                    HealBot_ExcludeEnemyInCache[eaSpellId]=true
                end
            end
        else
            break
        end
    end
    HealBot_Aura_CheckUnitDebuffIcons(button, TimeNow)
end

function HealBot_Aura_ClearBuffWatch()
    for x,_ in pairs(HealBot_BuffWatch) do
        HealBot_BuffWatch[x]=nil;
    end
      --HealBot_setCall("HealBot_Aura_ClearBuffWatch")
end

function HealBot_Aura_retBuffWatch(bName)
      --HealBot_setCall("HealBot_Aura_retBuffWatch")
    return HealBot_BuffWatch[bName]
end

function HealBot_Aura_SetBuffWatch(buffName, ddId)
   -- table.insert(HealBot_BuffWatch,buffName);
    HealBot_BuffWatch[buffName]=ddId
    HealBot_Aura_DeleteExcludeBuffInCache()
      --HealBot_setCall("HealBot_Aura_SetBuffWatch")
end

function HealBot_Aura_ClearCheckBuffs()
    for x,_ in pairs(HealBot_CheckBuffs) do
        HealBot_CheckBuffs[x]=nil;
    end
      --HealBot_setCall("HealBot_Aura_ClearCheckBuffs")
end

function HealBot_Aura_SetCheckBuffs(buffName)
    HealBot_CheckBuffs[buffName]=true;
      --HealBot_setCall("HealBot_Aura_SetCheckBuffs")
end

local isBuffSpellName=""
function HealBot_Aura_IsBuffSpell(spellId)
    isBuffSpellName=GetSpellInfo(spellId) or "x"
    return HealBot_CheckBuffs[isBuffSpellName]
end

function HealBot_Aura_RetMyBuffTime(button,buffName)
    if not button.aura.buff.recheck[buffName] then return end
    if HealBot_ShortBuffs[buffName] then
        return button.aura.buff.recheck[buffName]+HealBot_Config_Buffs.ShortBuffTimer
    else
        return button.aura.buff.recheck[buffName]+HealBot_Config_Buffs.LongBuffTimer
    end
      --HealBot_setCall("HealBot_Aura_RetMyBuffTime")
end

local rdType=HEALBOT_CUSTOM_en
function HealBot_Aura_retDebufftype(unit, id)
      --HealBot_setCall("HealBot_Aura_retDebufftype")
    rdType=HEALBOT_CUSTOM_en
    if HealBot_AuraDebuffCache[id] then rdType=HealBot_AuraDebuffCache[id]["debuffType"] end
    return rdType
end

function HealBot_Aura_SetIconUpdateInterval()
    for f=1,10 do
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][f]["FADE"] then
            HealBot_iconUpdate["DEBUFF"][f]=0.2
        else
            HealBot_iconUpdate["DEBUFF"][f]=1
        end
        if Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][f]["SDUR"] then
        elseif HealBot_iconUpdate["DEBUFF"][f]==1 then
            HealBot_iconUpdate["DEBUFF"][f]=1000
        end
        if Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][f]["BUFFFADE"] then
            HealBot_iconUpdate["BUFF"][f]=0.2
        else
            HealBot_iconUpdate["BUFF"][f]=1
        end
        if Healbot_Config_Skins.IconText[Healbot_Config_Skins.Current_Skin][f]["BUFFSDUR"] then
        elseif HealBot_iconUpdate["BUFF"][f]==1 then
            HealBot_iconUpdate["BUFF"][f]=1000
        end
    end
      --HealBot_setCall("HealBot_Aura_SetIconUpdateInterval")
end

local nextBuffIconUpdate=0
function HealBot_Aura_Update_UnitBuffIcons(button, TimeNow)
    button.aura.buff.nextupdate=TimeNow+10000
    for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] do
        if HealBot_UnitBuffIcons[button.id][i].current then
            if HealBot_UnitBuffIcons[button.id][i].nextUpdate<=TimeNow then
                nextBuffIconUpdate=HealBot_Aura_UpdateBuffIcon(button, HealBot_UnitBuffIcons[button.id][i], i, TimeNow)
                HealBot_UnitBuffIcons[button.id][i].nextUpdate=HealBot_UnitBuffIcons[button.id][i].nextUpdate+nextBuffIconUpdate
            end
            if button.aura.buff.nextupdate>HealBot_UnitBuffIcons[button.id][i].nextUpdate then
                button.aura.buff.nextupdate=HealBot_UnitBuffIcons[button.id][i].nextUpdate
            end
        end
    end
end


function HealBot_Aura_Update_UnitAllBuffIcons(button, TimeNow)
    if button then
        for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXBICONS"] do
            if HealBot_UnitBuffIcons[button.id][i].current then
                --HealBot_Aura_UpdateBuffIcon(button, HealBot_UnitBuffIcons[button.id][i], i, TimeNow)
                HealBot_UnitBuffIcons[button.id][i].nextUpdate=TimeNow
                button.aura.buff.nextupdate=TimeNow
            end
        end
    else
        for _,xButton in pairs(HealBot_Unit_Button) do
            for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"] do
                if HealBot_UnitBuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateBuffIcon(xButton, HealBot_UnitBuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitBuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.buff.nextupdate=TimeNow
                end
            end
        end
        for _,xButton in pairs(HealBot_Private_Button) do
            for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"] do
                if HealBot_UnitBuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateBuffIcon(xButton, HealBot_UnitBuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitBuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.buff.nextupdate=TimeNow
                end
            end
        end
        for _,xButton in pairs(HealBot_Pet_Button) do
            for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"] do
                if HealBot_UnitBuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateBuffIcon(xButton, HealBot_UnitBuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitBuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.buff.nextupdate=TimeNow
                end
            end
        end
        for _,xButton in pairs(HealBot_Extra_Button) do
            for i=1,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXBICONS"] do
                if HealBot_UnitBuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateBuffIcon(xButton, HealBot_UnitBuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitBuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.buff.nextupdate=TimeNow
                end
            end
        end
    end
end

function HealBot_Aura_Update_UnitAllDebuffIcons(button, TimeNow)
    if button then
        for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"]+50 do
            if HealBot_UnitDebuffIcons[button.id][i].current then
                --HealBot_Aura_UpdateDebuffIcon(button, HealBot_UnitDebuffIcons[button.id][i], i, TimeNow)
                HealBot_UnitDebuffIcons[button.id][i].nextUpdate=TimeNow
                button.aura.debuff.nextupdate=TimeNow
            end
        end
    else
        for _,xButton in pairs(HealBot_Unit_Button) do
            for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+50 do
                if HealBot_UnitDebuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateDebuffIcon(xButton, HealBot_UnitDebuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitDebuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.debuff.nextupdate=TimeNow
                end
            end
        end
        for _,xButton in pairs(HealBot_Private_Button) do
            for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+50 do
                if HealBot_UnitDebuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateDebuffIcon(xButton, HealBot_UnitDebuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitDebuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.debuff.nextupdate=TimeNow
                end
            end
        end
        for _,xButton in pairs(HealBot_Pet_Button) do
            for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+50 do
                if HealBot_UnitDebuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateDebuffIcon(xButton, HealBot_UnitDebuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitDebuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.debuff.nextupdate=TimeNow
                end
            end
        end
        for _,xButton in pairs(HealBot_Extra_Button) do
            for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][xButton.frame]["MAXDICONS"]+50 do
                if HealBot_UnitDebuffIcons[xButton.id][i].current then
                    --HealBot_Aura_UpdateDebuffIcon(xButton, HealBot_UnitDebuffIcons[xButton.id][i], i, TimeNow)
                    HealBot_UnitDebuffIcons[xButton.id][i].nextUpdate=TimeNow
                    xButton.aura.debuff.nextupdate=TimeNow
                end
            end
        end
    end
end

function HealBot_Aura_Update_UnitAllExtraIcons(button, index)
    if button then
        if HealBot_UnitExtraIcons[button.id][index].current then
            HealBot_Aura_UpdateExtraIcon(button, HealBot_UnitExtraIcons[button.id][index], index)
        end
    else
        for _,xButton in pairs(HealBot_Unit_Button) do
            if HealBot_UnitExtraIcons[xButton.id] and HealBot_UnitExtraIcons[xButton.id][index].current then
                HealBot_Aura_UpdateExtraIcon(xButton, HealBot_UnitExtraIcons[xButton.id][index], index)
            end
        end
        for _,xButton in pairs(HealBot_Private_Button) do
            if HealBot_UnitExtraIcons[xButton.id] and HealBot_UnitExtraIcons[xButton.id][index].current then
                HealBot_Aura_UpdateExtraIcon(xButton, HealBot_UnitExtraIcons[xButton.id][index], index)
            end
        end
        for _,xButton in pairs(HealBot_Pet_Button) do
            if HealBot_UnitExtraIcons[xButton.id] and HealBot_UnitExtraIcons[xButton.id][index].current then
                HealBot_Aura_UpdateExtraIcon(xButton, HealBot_UnitExtraIcons[xButton.id][index], index)
            end
        end
        for _,xButton in pairs(HealBot_Extra_Button) do
            if HealBot_UnitExtraIcons[xButton.id] and HealBot_UnitExtraIcons[xButton.id][index].current then
                HealBot_Aura_UpdateExtraIcon(xButton, HealBot_UnitExtraIcons[xButton.id][index], index)
            end
        end
    end
end

function HealBot_Aura_Update_AllIcons(button, TimeNow)
    button.aura.alpha=false
    if not Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["BUFFI15EN"] then
        HealBot_Aura_Update_UnitAllBuffIcons(button,TimeNow)
    end
    if not Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["I15EN"] then
        HealBot_Aura_Update_UnitAllDebuffIcons(button, TimeNow)
    end
    for i = 91,94 do
        HealBot_Aura_Update_UnitAllExtraIcons(button, i)
    end
end

function HealBot_Aura_ReturnHoTdetails(buttonId)
      --HealBot_setCall("HealBot_Aura_ReturnHoTdetails")
    return HealBot_UnitBuffIcons[buttonId]
end

function HealBot_Aura_ReturnHoTdetailsname(spellId)
    if HealBot_AuraBuffCache[spellId] then
        return HealBot_AuraBuffCache[spellId]["name"]
    else
        return false
    end
end

function HealBot_Aura_ReturnDebuffdetails(buttonId)
      --HealBot_setCall("HealBot_Aura_ReturnDebuffdetails")
    return HealBot_UnitDebuffIcons[buttonId]
end

function HealBot_Aura_ReturnDebuffdetailsname(spellId)
    if HealBot_AuraDebuffCache[spellId] then
        return HealBot_AuraDebuffCache[spellId]["name"]
    else
        return false
    end
end

function HealBot_Aura_RemoveIcons(button, TimeNow)
    HealBot_Aura_RemoveBuffIcons(button, TimeNow)
    HealBot_Aura_RemoveDebuffIcons(button, TimeNow)
    for i=91,94 do
        HealBot_Aura_RemoveExtraUnitIcons(button, i)
    end
      --HealBot_setCall("HealBot_Aura_RemoveIcons")
end

local nextDebuffIconUpdate=0
function HealBot_Aura_Update_UnitDebuffIcons(button, TimeNow)
    button.aura.debuff.nextupdate=TimeNow+10000
    for i=51,Healbot_Config_Skins.Icons[Healbot_Config_Skins.Current_Skin][button.frame]["MAXDICONS"]+50 do
        if HealBot_UnitDebuffIcons[button.id][i].current then
            if HealBot_UnitDebuffIcons[button.id][i].nextUpdate<=TimeNow then
                nextDebuffIconUpdate=HealBot_Aura_UpdateDebuffIcon(button, HealBot_UnitDebuffIcons[button.id][i], i, TimeNow)
                HealBot_UnitDebuffIcons[button.id][i].nextUpdate=HealBot_UnitDebuffIcons[button.id][i].nextUpdate+nextDebuffIconUpdate
            end
            if button.aura.debuff.nextupdate>HealBot_UnitDebuffIcons[button.id][i].nextUpdate then
                button.aura.debuff.nextupdate=HealBot_UnitDebuffIcons[button.id][i].nextUpdate
            end
        end
    end
end

function HealBot_Aura_ConfigClassHoT()
    local hbClassHoTwatch=HealBot_Globals.WatchHoT
    for id,_ in pairs(HealBot_Watch_HoT) do
        HealBot_Watch_HoT[id]=false
    end
    for xClass,_  in pairs(hbClassHoTwatch) do
        local HealBot_configClassHoTClass=HealBot_Globals.WatchHoT[xClass]
        for id,x  in pairs(HealBot_configClassHoTClass) do
            local sName=false
            if tonumber(id)==nil and not HealBot_SpellID_LookupData[id] then
                HealBot_SpellID_LookupData[id]={}
                HealBot_SpellID_LookupData[id]["CHECK"]=true
                HealBot_SpellID_LookupData[id]["CLASS"]=xClass
            elseif GetSpellInfo(id) then
                sName=GetSpellInfo(id)
            end
            --local giftNaaru=false
            --if sName==HealBot_Spell_IDs[HEALBOT_GIFT_OF_THE_NAARU] or (HealBot_Spell_Names[sName] or 0)==HEALBOT_GIFT_OF_THE_NAARU then
            --    giftNaaru=true
            --end
            if xClass=="ALL" and x==3 then
                if (HealBot_Globals.CustomBuffIDMethod[id] or 3)<3 then
                    if HealBot_Globals.CustomBuffIDMethod[id]==2 and sName then
                        HealBot_Watch_HoT[sName]="C"
                    else
                        HealBot_Watch_HoT[id]="C"
                    end
                else
                    HealBot_Watch_HoT[id]="C"
                    if sName then HealBot_Watch_HoT[sName]="C" end
                end
              --  if giftNaaru and HealBot_Data["PRACE_EN"]=="Draenei" then HealBot_Watch_HoT[sName]="C" end
            elseif (x==4) or (x==3 and xClass==HealBot_Data["PCLASSTRIM"]) then
                if (HealBot_Globals.CustomBuffIDMethod[id] or 3)<3 then
                    if HealBot_Globals.CustomBuffIDMethod[id]==2 and sName then
                        HealBot_Watch_HoT[sName]="A"
                    else
                        HealBot_Watch_HoT[id]="A"
                    end
                else
                    HealBot_Watch_HoT[id]="A"
                    if sName then HealBot_Watch_HoT[sName]="A" end
                end
            --    if giftNaaru and HealBot_Data["PRACE_EN"]=="Draenei" then HealBot_Watch_HoT[sName]="A" end
            elseif x==2 then
                if (HealBot_Globals.CustomBuffIDMethod[id] or 3)<3 then
                    if HealBot_Globals.CustomBuffIDMethod[id]==2 and sName then
                        HealBot_Watch_HoT[sName]="S"
                    else
                        HealBot_Watch_HoT[id]="S"
                    end
                else
                    HealBot_Watch_HoT[id]="S"
                    if sName then HealBot_Watch_HoT[sName]="S" end
                end
            --    if giftNaaru and HealBot_Data["PRACE_EN"]=="Draenei" then HealBot_Watch_HoT[sName]="S" end
            --else
            --    HealBot_Watch_HoT[sName]="H"
            end
        end
    end
    for id,_ in pairs(HealBot_Watch_HoT) do
        if not HealBot_Watch_HoT[id] then HealBot_Watch_HoT[id]=nil end
    end
    HealBot_Aura_setCustomBuffFilterDisabled()
      --HealBot_setCall("HealBot_configClassHoT")
end

function HealBot_Aura_BuffIdLookup()
    if HealBot_SpellID_LookupIdx[1] then
        local sName=HealBot_SpellID_LookupIdx[1]
        local sID=HealBot_SpellID_LookupData[sName]["ID"]
        local class=HealBot_SpellID_LookupData[sName]["CLASS"]
        table.remove(HealBot_SpellID_LookupIdx,1)
        if GetSpellInfo(sID) and GetSpellInfo(sID)==sName and HealBot_Globals.WatchHoT[class][sName] then
            HealBot_Globals.WatchHoT[class][sID]=HealBot_Globals.WatchHoT[class][sName]
            if HealBot_Globals.IgnoreCustomBuff[sName] then
                HealBot_Globals.IgnoreCustomBuff[sID]=HealBot_Options_copyTable(HealBot_Globals.IgnoreCustomBuff[sName])
            end
            if HealBot_Globals.HealBot_Custom_Buffs[sName] then
                HealBot_Globals.HealBot_Custom_Buffs[sID]=HealBot_Globals.HealBot_Custom_Buffs[sName]
            end
            if HealBot_Globals.CustomBuffBarColour[sName] then
                HealBot_Globals.CustomBuffBarColour[sID]=HealBot_Options_copyTable(HealBot_Globals.CustomBuffBarColour[sName])
            end
            if HealBot_Globals.HealBot_Custom_Buffs_ShowBarCol[sName] then
                HealBot_Globals.HealBot_Custom_Buffs_ShowBarCol[sID]=HealBot_Globals.HealBot_Custom_Buffs_ShowBarCol[sName]
            end
        end
    end
end

local function HealBot_Aura_InitItem2BuffsNames(buffId, itemId)
    local sName=GetSpellInfo(buffId)
    if sName then HealBot_Buff_Aura2Item[sName] = itemId end
end

function HealBot_Aura_InitData()
    local sName=nil
    if HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_PRIEST] then
        sName=GetSpellInfo(HBC_DAMPEN_MAGIC)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_SHADOW_PROTECTION)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HEALBOT_FEAR_WARD)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_INNER_FIRE)
        if sName then HealBot_ShortBuffs[sName]=true end
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_DRUID] then
        sName=GetSpellInfo(HBC_THORNS)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_OMEN_OF_CLARITY)
        if sName then HealBot_ShortBuffs[sName]=true end
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_PALADIN] then
        sName=GetSpellInfo(HEALBOT_BEACON_OF_LIGHT)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HEALBOT_SACRED_SHIELD)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_BLESSING_OF_KINGS)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_BLESSING_OF_MIGHT)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_BLESSING_OF_WISDOM)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_BLESSING_OF_LIGHT)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_BLESSING_OF_SANCTUARY)
        if sName then HealBot_ShortBuffs[sName]=true end
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_MONK] then
        -- short buffs
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_WARRIOR] then
        -- short buffs
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_MAGE] then
        sName=GetSpellInfo(HEALBOT_ICE_WARD)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HEALBOT_ICE_BARRIER)
        if sName then HealBot_ShortBuffs[sName]=true end
        sName=GetSpellInfo(HBC_DAMPEN_MAGIC)
        if sName then HealBot_ShortBuffs[sName]=true end
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_WARLOCK] then
        -- short buffs
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_DEATHKNIGHT] then
        sName=GetSpellInfo(HEALBOT_HORN_OF_WINTER)
        if sName then HealBot_ShortBuffs[sName]=true end
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_HUNTER] then
        -- short buffs
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_SHAMAN] then
        -- short buffs
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_ROGUE] then
        -- short buffs
    elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_DEMONHUNTER] then
        -- short buffs
    end

    
    HealBot_Buff_Aura2Item = {}
    
    HealBot_Aura_InitItem2BuffsNames(HEALBOT_WHISPERS_OF_INSANITY, HEALBOT_ORALIUS_WHISPERING_CRYSTAL)
    HealBot_Aura_InitItem2BuffsNames(HEALBOT_BLOOM, HEALBOT_EVER_BLOOMING_FROND)
    HealBot_Aura_InitItem2BuffsNames(HEALBOT_FEL_FOCUS, HEALBOT_REPURPOSED_FEL_FOCUSER)
    HealBot_Aura_InitItem2BuffsNames(HEALBOT_TAILWIND, HEALBOT_TAILWIND_SAPPHIRE)
    HealBot_Aura_InitItem2BuffsNames(HEALBOT_SHADOW_TOUCHED, HEALBOT_AMETHYST_OF_THE_SHADOW_KING)
    HealBot_Aura_InitItem2BuffsNames(HEALBOT_VEILED_AUGMENTATION, HEALBOT_VEILED_AUGMENT_RUNE)
    if HealBot_IsItemInBag(HEALBOT_LIGHTNING_FORGED_AUGMENT_RUNE) then
        HealBot_Aura_InitItem2BuffsNames(HEALBOT_LIGHTNING_FORGED_AUGMENT, HEALBOT_LIGHTNING_FORGED_AUGMENT_RUNE)
    elseif HealBot_IsItemInBag(HEALBOT_BATTLE_SCARRED_AUGMENT_RUNE) then
        HealBot_Aura_InitItem2BuffsNames(HEALBOT_BATTLE_SCARRED_AUGMENT, HEALBOT_BATTLE_SCARRED_AUGMENT_RUNE)
    end
    
    HealBot_Buff_ItemIDs={}
    for _,id in pairs(HealBot_Buff_Aura2Item) do
        local itemName=GetItemInfo(id)
        if itemName then
            HealBot_Buff_ItemIDs[itemName]=id
        end
    end

    if HEALBOT_GAME_VERSION<4 then
        if not libCD then
            libCD = HealBot_Libs_CD()
            if libCD then libCD:Register(HEALBOT_HEALBOT) end
        end
        
        local HBC_WISDOM_ID = 1 --Mana Regen
        local HBC_LIGHT_ID = 2 --Incoming Heals
        local HBC_SALVATION_ID = 3 --Threat Reduction
        local HBC_SANCTUARY_ID = 4 --Damage Reduction
        local HBC_STATS_ID = 5 --Stats
        local HBC_MIGHT_ID = 6 --Attack Power
        local HBC_STAMINA_ID = 7 --Stamina
        local HBC_INT_ID = 8 --Int
        local HBC_SPIRIT_ID = 9 --Spirit
        local HBC_SP_ID = 10 --Shadow Resistance 
        if HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_DRUID] then
            HealBot_BuffNameTypes = {
                [(GetSpellInfo(HEALBOT_MARK_OF_THE_WILD) or "x")] = HBC_STATS_ID,
                [(GetSpellInfo(HBC_GIFT_OF_THE_WILD) or "x")] = HBC_STATS_ID,
            }
        elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_MAGE] then
            HealBot_BuffNameTypes = {
                [(GetSpellInfo(HBC_ARCANE_BRILLIANCE) or "x")] = HBC_INT_ID,
                [(GetSpellInfo(HEALBOT_ARCANE_BRILLIANCE) or "x")] = HBC_INT_ID,
            }
        elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_PALADIN] then
            HealBot_BuffNameTypes = {
                [(GetSpellInfo(HBC_BLESSING_OF_KINGS) or "x")] = HBC_STATS_ID,
                [(GetSpellInfo(HBC_BLESSING_OF_LIGHT) or "x")] = HBC_LIGHT_ID,
                [(GetSpellInfo(HBC_BLESSING_OF_MIGHT) or "x")] = HBC_MIGHT_ID,
                [(GetSpellInfo(HEALBOT_HAND_OF_SALVATION) or "x")] = HBC_SALVATION_ID,
                [(GetSpellInfo(HBC_BLESSING_OF_SANCTUARY) or "x")] = HBC_SANCTUARY_ID,
                [(GetSpellInfo(HBC_BLESSING_OF_WISDOM) or "x")] = HBC_WISDOM_ID,
                [(GetSpellInfo(HBC_GREATER_BLESSING_OF_KINGS) or "x")] = HBC_STATS_ID,
                [(GetSpellInfo(HBC_GREATER_BLESSING_OF_LIGHT) or "x")] = HBC_LIGHT_ID,
                [(GetSpellInfo(HBC_GREATER_BLESSING_OF_MIGHT) or "x")] = HBC_MIGHT_ID,
                [(GetSpellInfo(HBC_GREATER_BLESSING_OF_SALVATION) or "x")] = HBC_SALVATION_ID,
                [(GetSpellInfo(HBC_GREATER_BLESSING_OF_SANCTUARY) or "x")] = HBC_SANCTUARY_ID,
                [(GetSpellInfo(HBC_GREATER_BLESSING_OF_WISDOM) or "x")] = HBC_WISDOM_ID,
            }
        elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_PRIEST] then
            HealBot_BuffNameTypes = {
                [(GetSpellInfo(HBC_POWER_WORD_FORTITUDE) or "x")] = HBC_STAMINA_ID,
                [(GetSpellInfo(HEALBOT_POWER_WORD_FORTITUDE) or "x")] = HBC_STAMINA_ID,
                [(GetSpellInfo(HBC_DIVINE_SPIRIT) or "x")] = HBC_SPIRIT_ID,
                [(GetSpellInfo(HBC_PRAYER_OF_SPIRIT) or "x")] = HBC_SPIRIT_ID,
                [(GetSpellInfo(HBC_SHADOW_PROTECTION) or "x")] = HBC_SP_ID,
                [(GetSpellInfo(HBC_PRAYER_OF_SHADOW_PROTECTION) or "x")] = HBC_SP_ID,
            }
        elseif HealBot_Data["PCLASSTRIM"]==HealBot_Class_En[HEALBOT_WARLOCK] then
            HealBot_BuffNameTypes = {
                [(GetSpellInfo(HBC_DETECT_LESSER_INVISIBILITY) or "x")] = HBC_SP_ID,
                [(GetSpellInfo(HBC_DETECT_INVISIBILITY) or "x")] = HBC_SP_ID,
                [(GetSpellInfo(HBC_DETECT_GREATER_INVISIBILITY) or "x")] = HBC_SP_ID,
            }
        else
            HealBot_BuffNameTypes = {
                [(GetSpellInfo(HEALBOT_TRUESHOT_AURA) or "x")] = HBC_STAMINA_ID,
                [(GetSpellInfo(HEALBOT_BATTLE_SHOUT) or "x")] = HBC_STAMINA_ID,
            }
        end
    end
end