local _, GW = ...
local L = GW.L
local RoundInt = GW.RoundInt
local GetSetting = GW.GetSetting
local SetSetting = GW.SetSetting
local GetDefault = GW.GetDefault
local bloodSpark = GW.BLOOD_SPARK
local CLASS_ICONS = GW.CLASS_ICONS
local IsFrameModified = GW.IsFrameModified
local Debug = GW.Debug
local LibSharedMedia = LibStub("LibSharedMedia-3.0", true)

GW.VERSION_STRING = "v1.10.8 Classic"

-- setup Binding Header color
_G.BINDING_HEADER_GW2UI = GetAddOnMetadata(..., "Title")

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then 
    DEFAULT_CHAT_FRAME:AddMessage("|cffffedbaGW2 UI:|r You have installed GW2_UI classic version. Please install the retail version to use GW2_UI.")
    return
end

if GW.CheckForPasteAddon() and GetSetting("ACTIONBARS_ENABLED") then 
    DEFAULT_CHAT_FRAME:AddMessage("|cffffedbaGW2 UI:|r |cffff0000You have installed the Addon 'Paste'. This can cause, that our actionbars are empty. Deactive 'Paste' to use our actionbars.|r")
end

local loaded = false
local hudScale = 1
local forcedMABags = false
local ourActionbarsloaded = false
local ourPetbar = false

local MOVABLE_FRAMES = {}
GW.MOVABLE_FRAMES = MOVABLE_FRAMES

local swimAnimation = 0
local lastSwimState = true

if Profiler then
    _G.GW_Addon_Scope = GW
end

local function disableMABags()
    local bags = GetSetting("BAGS_ENABLED")
    if not bags or not MovAny or not MADB then
        return
    end
    MADB.noBags = true
    MAOptNoBags:SetEnabled(false)
    forcedMABags = true
end
GW.AddForProfiling("index", "disableMABags", disableMABags)

local function disableTitanPanelBarAdjusting()
    local ourBars = GetSetting("ACTIONBARS_ENABLED")
    if ourBars and IsAddOnLoaded("TitanClassic") then
        TitanMovable_AddonAdjust("MultiBarRight", true)
        TitanMovable_AddonAdjust("ExtraActionBarFrame", true)
        TitanMovable_AddonAdjust("MinimapCluster", true)
    end
end     

local function lockableOnClick(self, btn)
    local mf = self:GetParent()
    --local f = mf.gw_frame
    local settingsName = mf.gw_Settings
    local lockAble = mf.gw_Lockable

    local dummyPoint = GetDefault(settingsName)
    mf:ClearAllPoints()
    mf:SetPoint(
        dummyPoint["point"],
        UIParent,
        dummyPoint["relativePoint"],
        dummyPoint["xOfs"],
        dummyPoint["yOfs"]
    )

    local point, _, relativePoint, xOfs, yOfs = mf:GetPoint()

    local new_point = GetSetting(settingsName)
    new_point["point"] = point
    new_point["relativePoint"] = relativePoint
    new_point["xOfs"] = GW.RoundInt(xOfs)
    new_point["yOfs"] = GW.RoundInt(yOfs)
    SetSetting(settingsName, new_point)

    --if 'PlayerBuffFrame' or 'PlayerDebuffFrame', set also the grow direction to default
    if settingsName == "PlayerBuffFrame" or settingsName == "PlayerDebuffFrame" then
        SetSetting(settingsName .. "_GrowDirection", "UP")
    end
end
GW.AddForProfiling("index", "lockableOnClick", lockableOnClick)

local function lockFrame_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    GameTooltip:ClearLines()
    GameTooltip:SetText(SYSTEM_DEFAULT, 1, 1, 1)
    GameTooltip:Show()
end
GW.AddForProfiling("index", "lockFrame_OnEnter", lockFrame_OnEnter)

local function mover_OnDragStart(self)
    self.IsMoving = true
    self:StartMoving()
end
GW.AddForProfiling("index", "mover_OnDragStart", mover_OnDragStart)

local function mover_OnDragStop(self)
    local settingsName = self.gw_Settings
    local lockAble = self.gw_Lockable
    local isMoved = self.gw_isMoved
    self:StopMovingOrSizing()
    local point, _, relativePoint, xOfs, yOfs = self:GetPoint()

    local new_point = GetSetting(settingsName)
    new_point.point = point
    new_point.relativePoint = relativePoint
    new_point.xOfs = math.floor(xOfs)
    new_point.yOfs = math.floor(yOfs)
    SetSetting(settingsName, new_point)
    if lockAble ~= nil then
        SetSetting(lockAble, false)
    end
    -- check if we need to know if the frame is on its default position
    if isMoved ~= nil then
        local defaultPoint = GetDefault(settingsName)
        local growDirection = GetSetting(settingsName .. "_GrowDirection")
        local frame = self.gw_frame
        if defaultPoint.point == new_point.point and defaultPoint.relativePoint == new_point.relativePoint and defaultPoint.xOfs == new_point.xOfs and defaultPoint.yOfs == new_point.yOfs and (growDirection and growDirection == "UP") then
            frame.isMoved = false
            frame:SetAttribute("isMoved", false)
        else
            frame.isMoved = true
            frame:SetAttribute("isMoved", true)
        end
    end

    self.IsMoving = false
end
GW.AddForProfiling("index", "mover_OnDragStop", mover_OnDragStop)

local function RegisterMovableFrame(frame, displayName, settingsName, dummyFrame, size, lockAble, isMoved)
    local moveframe = CreateFrame("Frame", nil, UIParent, dummyFrame)
    frame.gwMover = moveframe
    if size then
        moveframe:SetSize(unpack(size))
    else
        moveframe:SetSize(frame:GetSize())
    end
    moveframe.gw_Settings = settingsName
    moveframe.gw_Lockable = lockAble
    moveframe.gw_isMoved = isMoved
    moveframe.gw_frame = frame

    if moveframe.frameName and moveframe.frameName.SetText then
        moveframe.frameName:SetText(displayName)
    end
    local dummyPoint = GetSetting(settingsName)
    moveframe:ClearAllPoints()
    moveframe:SetPoint(
        dummyPoint["point"],
        UIParent,
        dummyPoint["relativePoint"],
        dummyPoint["xOfs"],
        dummyPoint["yOfs"]
    )
    local num = #MOVABLE_FRAMES
    MOVABLE_FRAMES[num + 1] = moveframe
    moveframe:Hide()
    moveframe:RegisterForDrag("LeftButton")

    if lockAble ~= nil then
        local lockFrame = CreateFrame("Button", nil, moveframe, "GwDummyLockButton")
        lockFrame:SetScript("OnEnter", lockFrame_OnEnter)
        lockFrame:SetScript("OnLeave", GameTooltip_Hide)
        lockFrame:SetScript("OnClick", lockableOnClick)
    end

    if isMoved ~= nil then
        local defaultPoint = GetDefault(settingsName)

        if defaultPoint["point"] == dummyPoint["point"] and defaultPoint["relativePoint"] == dummyPoint["relativePoint"] and defaultPoint["xOfs"] == dummyPoint["xOfs"] and defaultPoint["yOfs"] == dummyPoint["yOfs"] then
            frame.isMoved = false
            frame:SetAttribute("isMoved", false)
        else
            frame.isMoved = true
            frame:SetAttribute("isMoved", true)
        end
    end

    moveframe:SetScript("OnDragStart", mover_OnDragStart)
    moveframe:SetScript("OnDragStop", mover_OnDragStop)
end
GW.RegisterMovableFrame = RegisterMovableFrame

local function UpdateFramePositions()
    for i, mf in pairs(MOVABLE_FRAMES) do
        local f = mf.gw_frame
        local newp = GetSetting(mf.gw_Settings)
        f:ClearAllPoints()
        f:SetPoint(newp["point"], UIParent, newp["relativePoint"], newp["xOfs"], newp["yOfs"])
    end
end
GW.UpdateFramePositions = UpdateFramePositions

local animations = {}
GW.animations = animations
local function AddToAnimation(name, from, to, start, duration, method, easeing, onCompleteCallback, doCompleteOnOverider)
    local newAnimation = true
    if animations[name] ~= nil then
        if (animations[name]["start"] + animations[name]["duration"]) > GetTime() then
            newAnimation = false
        end
    end
    if doCompleteOnOverider == nil then
        newAnimation = true
    end

    if newAnimation == false then
        animations[name]["duration"] = duration
        animations[name]["to"] = to
        animations[name]["progress"] = 0
        animations[name]["method"] = method
        animations[name]["completed"] = false
        animations[name]["easeing"] = easeing
        animations[name]["onCompleteCallback"] = onCompleteCallback
    else
        animations[name] = {}
        animations[name]["start"] = start
        animations[name]["duration"] = duration
        animations[name]["from"] = from
        animations[name]["to"] = to
        animations[name]["progress"] = 0
        animations[name]["method"] = method
        animations[name]["completed"] = false
        animations[name]["easeing"] = easeing
        animations[name]["onCompleteCallback"] = onCompleteCallback
    end
end
GW.AddToAnimation = AddToAnimation

local function buttonAnim(self, name, w, hover)
    local prog = animations[name]["progress"]
    local l = GW.lerp(0, w, prog)

    hover:SetPoint("RIGHT", self, "LEFT", l, 0)
    hover:SetVertexColor(1, 1, 1, GW.lerp(0, 1, ((prog) - 0.5) / 0.5))
end
GW.AddForProfiling("index", "buttonAnim", buttonAnim)

local function getSprite(map,x,y)
    local pw = (map.width / map.colums) / map.width
    local ph = (map.height / map.rows) / map.height

    local left = pw * (x - 1)
    local right = pw * x

    local top = ph * (y - 1)
    local bottom = ph * y

    return left, right, top, bottom;
end
GW.getSprite = getSprite

function GwStandardButton_OnEnter(self)
    local name = tostring(self)
    local w = self:GetWidth()
    local hover = self.hover
    if not hover then
        return
    end

    hover:SetAlpha(1)
    self.animationValue = 0

    AddToAnimation(
        name,
        self.animationValue,
        1,
        GetTime(),
        0.2,
        function()
            buttonAnim(self, name, w, hover)
        end
    )
end

function GwStandardButton_OnLeave(self)
    local name = tostring(self)
    local w = self:GetWidth()
    local hover = self.hover
    if not hover then
        return
    end

    hover:SetAlpha(1)
    self.animationValue = 1

    AddToAnimation(
        name,
        self.animationValue,
        0,
        GetTime(),
        0.2,
        function()
            buttonAnim(self, name, w, hover)
        end
    )
end

local function barAnimation(self, barWidth, sparkWidth)
    local snap = (animations[self.animationName]["progress"] * 100) / 5

    local round_closest = 0.05 * snap

    local spark_min = math.floor(snap)
    local spark_current = snap

    local spark_prec = spark_current - spark_min

    local spark =
        math.min(barWidth - sparkWidth, math.floor(barWidth * round_closest) - math.floor(sparkWidth * spark_prec))
    local bI = 17 - math.max(1, RoundInt(16 * spark_prec))

    self.spark:SetTexCoord(bloodSpark[bI].left, bloodSpark[bI].right, bloodSpark[bI].top, bloodSpark[bI].bottom)

    self:SetValue(round_closest)
    self.spark:ClearAllPoints()
    self.spark:SetPoint("LEFT", spark, 0)
end
GW.AddForProfiling("index", "barAnimation", barAnimation)

local function Bar(self, value)
    if self == nil then
        return
    end
    local barWidth = self:GetWidth()
    local sparkWidth = self.spark:GetWidth()

    AddToAnimation(
        self.animationName,
        self.animationValue,
        value,
        GetTime(),
        0.2,
        function()
            barAnimation(self, barWidth, sparkWidth)
        end
    )
    self.animationValue = value
end
GW.Bar = Bar

local function SetClassIcon(self, class)
    if class == nil then
        class = 0
    end

    self:SetTexCoord(CLASS_ICONS[class].l, CLASS_ICONS[class].r, CLASS_ICONS[class].t, CLASS_ICONS[class].b)
end
GW.SetClassIcon = SetClassIcon

local function SetDeadIcon(self)
    self:SetTexCoord(CLASS_ICONS["dead"].l, CLASS_ICONS["dead"].r, CLASS_ICONS["dead"].t, CLASS_ICONS["dead"].b)
end
GW.SetDeadIcon = SetDeadIcon

local function StopAnimation(k)
    if animations[k] ~= nil then
        animations[k] = nil
    end
end
GW.StopAnimation = StopAnimation

local callback = {}

local function actionBarStateChanged()
    for k, v in pairs(callback) do
        v()
    end
end

local function actionBarFrameShow(f, name)
    StopAnimation(name)
    f.gw_FadeShowing = true
    actionBarStateChanged()
    AddToAnimation(name, 0, 1, GetTime(), 0.1, function()
        f:SetAlpha(animations[name]['progress'])
    end, nil, function()
        for i = 1, 12 do
            f.gw_Buttons[i].cooldown:SetDrawBling(true)
        end
        actionBarStateChanged()
    end)
end

local function actionBarFrameHide(f, name)
    StopAnimation(name)
    f.gw_FadeShowing = false
    for i = 1, 12 do
        f.gw_Buttons[i].cooldown:SetDrawBling(false)
    end
    AddToAnimation(name, 1, 0, GetTime(), 0.1, function()
        f:SetAlpha(animations[name]['progress'])
    end, nil, function()
        actionBarStateChanged()
    end)
end

local l = CreateFrame("Frame", nil, UIParent)
local HasPetUIFrame = CreateFrame("Frame", nil, UIParent)
local OnUpdateActionBars = nil

local function swimAnim()
    local r, g, b = _G["GwActionBarHudRIGHTSWIM"]:GetVertexColor()
    _G["GwActionBarHudRIGHTSWIM"]:SetVertexColor(r, g, b, animations["swimAnimation"]["progress"])
    _G["GwActionBarHudLEFTSWIM"]:SetVertexColor(r, g, b, animations["swimAnimation"]["progress"])
end
GW.AddForProfiling("index", "swimAnim", swimAnim)

local updateCB = {}
local function AddUpdateCB(func, payload)
    if type(func) ~= "function" then
        return
    end

    tinsert(
        updateCB,
        {
            ["func"] = func,
            ["payload"] = payload
        }
    )
end
GW.AddUpdateCB = AddUpdateCB

local function gw_OnUpdate(self, elapsed)
    local foundAnimation = false
    local count = 0
    for k, v in pairs(animations) do
        count = count + 1
        if v["completed"] == false and GetTime() >= (v["start"] + v["duration"]) then
            if v["easeing"] == nil then
                v["progress"] = GW.lerp(v["from"], v["to"], math.sin(1 * math.pi * 0.5))
            else
                v["progress"] = GW.lerp(v["from"], v["to"], 1)
            end
            if v["method"] ~= nil then
                v["method"](v["progress"])
            end

            if v["onCompleteCallback"] ~= nil then
                v["onCompleteCallback"]()
            end

            v["completed"] = true
            foundAnimation = true
        end
        if v["completed"] == false then
            if v["easeing"] == nil then
                v["progress"] =
                    GW.lerp(v["from"], v["to"], math.sin((GetTime() - v["start"]) / v["duration"] * math.pi * 0.5))
            else
                v["progress"] = GW.lerp(v["from"], v["to"], (GetTime() - v["start"]) / v["duration"])
            end
            v["method"](v["progress"])
            foundAnimation = true
        end
    end

    if foundAnimation == false and count ~= 0 then
        table.wipe(animations)
    end

    if OnUpdateActionBars then
        OnUpdateActionBars(elapsed)
    end

    --Swim hud
    if lastSwimState ~= IsSwimming() then
        if IsSwimming() then
            AddToAnimation("swimAnimation", swimAnimation, 1, GetTime(), 0.1, swimAnim)
            swimAnimation = 1
        else
            AddToAnimation("swimAnimation", swimAnimation, 0, GetTime(), 3.0, swimAnim)
            swimAnimation = 0
        end
        lastSwimState = IsSwimming()
    end

    for _, cb in ipairs(updateCB) do
        cb.func(cb.payload, elapsed)
    end

    if PetActionBarFrame:IsShown() and ourPetbar and loaded then
        PetActionBarFrame:Hide()
    end
end
GW.AddForProfiling("index", "gw_OnUpdate", gw_OnUpdate)

local function getBestPixelScale()
    return max(0.4, min(1.15, 768 / GW.screenHeight))
end
GW.getBestPixelScale = getBestPixelScale

local function PixelPerfection()
    GW.scale = getBestPixelScale()
    GW.border = ((1 / GW.scale) - ((1 - (768 / GW.screenHeight)) / GW.scale)) * 2
    UIParent:SetScale(GW.scale)
end
GW.PixelPerfection = PixelPerfection

local SCALE_HUD_FRAMES = {}
local function UpdateHudScale()
    hudScale = GetSetting("HUD_SCALE")
    for i, f in ipairs(SCALE_HUD_FRAMES) do
        if f then
            local fm = f.gwMover
            local sf = 1.0
            if f.gwScaleMulti then
                sf = f.gwScaleMulti
            end
            f:SetScale(hudScale * sf)
            if fm then
                fm:SetScale(hudScale * sf)
            end
        end
    end
end
GW.UpdateHudScale = UpdateHudScale

local function RegisterScaleFrame(f, modifier)
    if not f then
        return
    end
    if modifier and modifier > 0 then
        f.gwScaleMulti = modifier
    end
    local num = #SCALE_HUD_FRAMES
    SCALE_HUD_FRAMES[num + 1] = f
end
GW.RegisterScaleFrame = RegisterScaleFrame

local function loadAddon(self)
    if GetSetting("PIXEL_PERFECTION") and not GetCVarBool("useUiScale") then
        PixelPerfection()
        DEFAULT_CHAT_FRAME:AddMessage("|cffffedbaGW2 UI:|r Pixel Perfection-Mode enabled. UIScale down to perfect pixel size. Can be deactivated in HUD settings. |cFF00FF00/gw2|r")
    else
        GW.scale = UIParent:GetScale()
        GW.border = ((1 / GW.scale) - ((1 - (768 / GW.screenHeight)) / GW.scale)) * 2
    end

    -- disable Move Anything bag handling
    disableMABags()

    --disbale TitanPanelClaissc Adjustment
    disableTitanPanelBarAdjusting()

    -- hook debug output if relevant
    --[===[@debug@
    local dev_dbg_tab = GetSetting("DEV_DBG_CHAT_TAB")
    if dev_dbg_tab and dev_dbg_tab > 0 and _G["ChatFrame" .. dev_dbg_tab] then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffedbaGW2 UI:|r hooking Debug to chat tab #" .. dev_dbg_tab)
        GW.dbgTab = dev_dbg_tab
        GW.inDebug = true
    else
        GW.inDebug = false
    end
    --@end-debug@]===]
    --@non-debug@
    GW.inDebug = false
    --@end-non-debug@

    --Create Settings window
    GW.LoadSettings()
    GW.LoadHoverBinds()

    -- Load Slash commands
    GW.LoadSlashCommands()

    --Create the mainbar layout manager
    local lm = GW.LoadMainbarLayout()

    --Create general skins
    if GetSetting("MAINMENU_SKIN_ENABLED") then
        GW.SkinMainMenu()
    else
        --Setup addon button
        local GwMainMenuFrame = CreateFrame("Button", nil, _G.GameMenuFrame, "GameMenuButtonTemplate")
        GwMainMenuFrame:SetText(format("|cffffedba%s|r", L["SETTINGS_BUTTON"]))
        GwMainMenuFrame:SetScript(
            "OnClick",
            function()
                if InCombatLockdown() then
                    DEFAULT_CHAT_FRAME:AddMessage("|cffffedbaGW2 UI:|r " .. L["HIDE_SETTING_IN_COMBAT"])
                    return
                end
                ShowUIPanel(GwSettingsWindow)
                UIFrameFadeIn(GwSettingsWindow, 0.2, 0, 1)
                HideUIPanel(GameMenuFrame)
            end
        )
        GameMenuFrame[L["SETTINGS_BUTTON"]] = GwMainMenuFrame

        if not IsAddOnLoaded("ConsolePortUI_Menu") then
            GwMainMenuFrame:SetSize(GameMenuButtonLogout:GetWidth(), GameMenuButtonLogout:GetHeight())
            GwMainMenuFrame:SetPoint("TOPLEFT", GameMenuButtonAddons, "BOTTOMLEFT", 0, -1)
            hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", GW.PositionGameMenuButton)
        end
    end
    if GetSetting("STATICPOPUP_SKIN_ENABLED") then
        GW.SkinStaticPopup()
    end
    if GetSetting("BNTOASTFRAME_SKIN_ENABLED") then
        GW.SkinBNToastFrame()
    end
    if GetSetting("DROPDOWN_SKIN_ENABLED") then
        GW.SkinDropDown()
    end
    if GetSetting("ADDONLIST_SKIN_ENABLED") then
        GW.SkinAddonList()
    end
    if GetSetting("BINDINGS_SKIN_ENABLED") then
        GW.SkinBindingsUI()
    end
    if GetSetting("BLIZZARD_OPTIONS_SKIN_ENABLED") then
        GW.SkinBlizzardOptions()
    end
    if GetSetting("MACRO_SKIN_ENABLED") then
        GW.SkinMacroOptions()
    end
    if GetSetting("WORLDMAP_SKIN_ENABLED") then
        GW.SkinWorldMap()
    end


    --Create hud art
    GW.LoadHudArt()

    --Create experiencebar
    if GetSetting("XPBAR_ENABLED") then
        GW.LoadXPBar()
    else
        GwActionBarHud:ClearAllPoints()
        GwActionBarHud:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
        GwHudArtFrame.edgeTintBottom1:ClearAllPoints()
        GwHudArtFrame.edgeTintBottom1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
        GwHudArtFrame.edgeTintBottom1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 0)
        GwHudArtFrame.edgeTintBottom2:ClearAllPoints()
        GwHudArtFrame.edgeTintBottom2:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
        GwHudArtFrame.edgeTintBottom2:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 0, 0)
    end

    if GetSetting("FONTS_ENABLED") then
        GW.LoadFonts()
    end

    if GetSetting("CASTINGBAR_ENABLED") then
        GW.LoadCastingBar()
    end

    if GetSetting("MINIMAP_ENABLED") then
        GW.LoadMinimap()
    end

    if GetSetting("QUESTTRACKER_ENABLED") then
        GW.LoadQuestTracker()
    end

    if GetSetting("TOOLTIPS_ENABLED") then
        GW.LoadTooltips()
    end

    if GetSetting("QUESTVIEW_ENABLED") then
        GW.LoadQuestview()
    end

    if GetSetting("CHATFRAME_ENABLED") then
        GW.LoadChat()
    end

    --Create player hud
    if GetSetting("HEALTHGLOBE_ENABLED") then
        local hg = GW.LoadHealthGlobe()
        GW.LoadDodgeBar(hg)
    end

    if GetSetting("POWERBAR_ENABLED") then
        GW.LoadPowerBar()
        if GetSetting("PLAYER_ENERGY_MANA_TICK") then
            GW.load5SR()
        end
    end

    if GetSetting("BAGS_ENABLED") then
        GW.LoadInventory()
        GW.SkinLooTFrame()
    end

    GW.LoadBreathMeter()
    GW.LoadAutoRepair()

    --Create unitframes
    if GetSetting("TARGET_ENABLED") then
        GW.LoadTarget()
        if GetSetting("target_TARGET_ENABLED") then
            GW.LoadTargetOfUnit("Target")
        end

        -- move zone text frame
        if not IsFrameModified("ZoneTextFrame") then
            ZoneTextFrame:ClearAllPoints()
            ZoneTextFrame:SetPoint("TOP", UIParent, "TOP", 0, -175)
        end

        -- move error frame
        if not IsFrameModified("UIErrorsFrame") then
            UIErrorsFrame:ClearAllPoints()
            UIErrorsFrame:SetPoint("TOP", UIParent, "TOP", 0, -190)
            UIErrorsFrame:SetFont(STANDARD_TEXT_FONT, 14)
        end
    end

    if GetSetting("CLASS_POWER") then
        GW.LoadClassPowers()
    end

    -- create action bars
    if GetSetting("ACTIONBARS_ENABLED") then
        GW.LoadActionBars(lm)
        ourActionbarsloaded = true
    end

    -- create pet frame
    if GetSetting("PETBAR_ENABLED") then
        GW.LoadPetFrame(lm)
        ourPetbar = true
    end

    -- create buff frame
    if GetSetting("PLAYER_BUFFS_ENABLED") then
        -- GW.LoadBuffs()
        GW.LoadPlayerAuras(lm)
    end

    if GetSetting("DYNAMIC_CAM") then
        if GetCVar("test_cameraDynamicPitch") == "0" then
            SetCVar("test_cameraDynamicPitch", true)
        end
        hooksecurefunc("StaticPopup_Show", function(which, text_arg1, text_arg2, data, insertedFrame)
            if which == "EXPERIMENTAL_CVAR_WARNING" then
                StaticPopup_Hide("EXPERIMENTAL_CVAR_WARNING")
            end
        end)
    else
        if GetCVar("test_cameraDynamicPitch") == "1" then
            SetCVar("test_cameraDynamicPitch", false)
        end
    end

    if GetSetting("AFK_MODE") then
        GW.loadAFKAnimation()
    end

    if GetSetting("CHATBUBBLES_ENABLED") then
        GW.LoadChatBubbles()
    end

    GW.LoadWindows()

    GW.LoadMicroMenu()

    if GetSetting("PARTY_FRAMES") then
        GW.LoadPartyFrames()
    end

    if GetSetting("RAID_FRAMES") then
        GW.LoadRaidFrames()
    end

    GW.UpdateHudScale()

    if (forcedMABags) then
        GW.Notice(L["DISABLED_MA_BAGS"])
    end

    --Add Shared Media
    --Font
    LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, "GW2_UI", "Interface/AddOns/GW2_UI/fonts/menomonia.ttf", LibSharedMedia.LOCALE_BIT_western + LibSharedMedia.LOCALE_BIT_ruRU)
    LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, "GW2_UI Light", "Interface/AddOns/GW2_UI/fonts/menomonia-italic.ttf", LibSharedMedia.LOCALE_BIT_western + LibSharedMedia.LOCALE_BIT_ruRU)
    LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, "GW2_UI Headlines", "Interface/AddOns/GW2_UI/fonts/headlines.ttf", LibSharedMedia.LOCALE_BIT_western + LibSharedMedia.LOCALE_BIT_ruRU)
    LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, "GW2_UI", "Interface/AddOns/GW2_UI/fonts/chinese.ttf", LibSharedMedia.LOCALE_BIT_zhCN + LibSharedMedia.LOCALE_BIT_zhTW)
    LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, "GW2_UI", "Interface/AddOns/GW2_UI/fonts/korean.ttf", LibSharedMedia.LOCALE_BIT_koKR)

    --Texture
    LibSharedMedia:Register(LibSharedMedia.MediaType.BACKGROUND, "GW2_UI_White", "Interface/AddOns/GW2_UI/Textures/ChatBubble-Background.tga")
    LibSharedMedia:Register(LibSharedMedia.MediaType.BACKGROUND, "GW2_UI", "Interface/Addons/GW2_UI/Textures/UI-Tooltip-Background.tga")
    LibSharedMedia:Register(LibSharedMedia.MediaType.STATUSBAR, "GW2_UI_Yellow", "Interface/Addons/GW2_UI/Textures/castingbar.tga")
    LibSharedMedia:Register(LibSharedMedia.MediaType.STATUSBAR, "GW2_UI_Blue", "Interface/Addons/GW2_UI/Textures/breathmeter.tga")
    LibSharedMedia:Register(LibSharedMedia.MediaType.STATUSBAR, "GW2_UI", "Interface/Addons/GW2_UI/Textures/castinbar-white.tga")

    --Check if we should show Welcomepage or Changelog
    if GetSetting("GW2_UI_VERSION") == "WELCOME" then
        GW.ShowWelcomePanel()
        SetSetting("GW2_UI_VERSION", GW.VERSION_STRING)
    elseif GetSetting("GW2_UI_VERSION") ~= GW.VERSION_STRING then
        GW.ShowChangelogPanel()
        SetSetting("GW2_UI_VERSION", GW.VERSION_STRING)
    end

    self:SetScript("OnUpdate", gw_OnUpdate)
end
GW.AddForProfiling("index", "loadAddon", loadAddon)

-- handles addon loading
local setHasPetUI = false
local setAttributeAfterCombat = CreateFrame("Frame", nil, UIParent)
local function gw_OnEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not loaded then
            loaded = true
            loadAddon(self)
        end
        GW.LoadStorage()
    elseif event == "UI_SCALE_CHANGED" and GetCVarBool("useUiScale") then
        SetSetting("PIXEL_PERFECTION", false)
        GW.scale = UIParent:GetScale()
        GW.screenwidth, GW.screenheight = GetPhysicalScreenSize()
        GW.resolution = format("%dx%d", GW.screenwidth, GW.screenheight)
        GW.border = ((1 / GW.scale) - ((1 - (768 / GW.screenHeight)) / GW.scale)) * 2
    elseif event == "PLAYER_LEAVING_WORLD" then
        GW.inWorld = false
    elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_ENTERING_BATTLEGROUND" then
        GW.inWorld = true
        if GetSetting("PIXEL_PERFECTION") and not GetCVarBool("useUiScale") then
            PixelPerfection()
        end
        if not setHasPetUI then
            local delayUpdateTime = GetTime() + 0.4
            HasPetUIFrame:SetScript(
                "OnUpdate",
                function()
                    if GetTime() < delayUpdateTime then
                        return
                    end
                    if GetSetting("USE_CHARACTER_WINDOW") then
                        if InCombatLockdown() then
                            setAttributeAfterCombat:SetScript(
                                "OnUpdate",
                                function()
                                    local inCombat = UnitAffectingCombat("player")
                                    if inCombat == true then
                                        return
                                    end
                                    GwCharacterWindow:SetAttribute("HasPetUI", select(1, HasPetUI()))
                                    setAttributeAfterCombat:SetScript("OnUpdate", nil)
                                end)
                            return
                        else
                            GwCharacterWindow:SetAttribute("HasPetUI", select(1, HasPetUI()))
                        end
                    end
                    setHasPetUI = true
                    HasPetUIFrame:SetScript("OnUpdate", nil)
                end
            )
        end
    elseif event == "PLAYER_LEVEL_UP" then
        GW.mylevel = ...
        Debug("New level:", GW.mylevel)
    end
end
GW.AddForProfiling("index", "gw_OnEvent", gw_OnEvent)

l:SetScript("OnEvent", gw_OnEvent)
l:RegisterEvent("PLAYER_LOGIN")
l:RegisterEvent("PLAYER_LEAVING_WORLD")
l:RegisterEvent("PLAYER_ENTERING_WORLD")
l:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
l:RegisterEvent("UI_SCALE_CHANGED")
l:RegisterEvent("PLAYER_LEVEL_UP")

local function AddToClique(frame)
    if type(frame) == "string" then
        local frameName = frame
        frame = _G[frameName]
    end

    if frame and frame.RegisterForClicks and ClickCastFrames ~= nil then
        ClickCastFrames[frame] = true
    end
end
GW.AddToClique = AddToClique

local waitTable = {}
local waitFrame = nil
local function wait_OnUpdate(self, elapse)
    local count = #waitTable
    local i = 1
    while (i <= count) do
        local waitRecord = tremove(waitTable, i)
        local d = tremove(waitRecord, 1)
        local f = tremove(waitRecord, 1)
        local p = tremove(waitRecord, 1)
        if (d > elapse) then
            tinsert(waitTable, i, {d - elapse, f, p})
            i = i + 1
        else
            count = count - 1
            f(unpack(p))
        end
    end
end
GW.AddForProfiling("index", "wait_OnUpdate", wait_OnUpdate)

local function Wait(delay, func, ...)
    if type(delay) ~= "number" or type(func) ~= "function" then
        return false
    end
    if waitFrame == nil then
        waitFrame = CreateFrame("Frame", "GwWaitFrame", UIParent)
        waitFrame:SetScript("OnUpdate", wait_OnUpdate)
    end
    tinsert(waitTable, {delay, func, {...}})
    return true
end
GW.Wait = Wait

local function Self_Hide(self)
    self:Hide()
end
GW.Self_Hide = Self_Hide

local function Parent_Hide(self)
    self:GetParent():Hide()
end
GW.Parent_Hide = Parent_Hide
