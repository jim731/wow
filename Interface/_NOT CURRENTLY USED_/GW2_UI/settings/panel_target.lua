local _, GW = ...
local L = GW.L
local addOption = GW.AddOption
local createCat = GW.CreateCat
local InitPanel = GW.InitPanel
local AddForProfiling = GW.AddForProfiling

local function LoadTargetPanel(sWindow)
    local p = CreateFrame("Frame", nil, sWindow.panels, "GwSettingsPanelTmpl")
    p.header:Hide()
    p.sub:Hide()

    local p_target = CreateFrame("Frame", nil, p, "GwSettingsPanelTmpl")
    p_target:SetHeight(300)
    p_target:ClearAllPoints()
    p_target:SetPoint("TOPLEFT", p, "TOPLEFT", 0, 0)
    p_target.header:SetFont(DAMAGE_TEXT_FONT, 20)
    p_target.header:SetTextColor(255 / 255, 241 / 255, 209 / 255)
    p_target.header:SetText(TARGET)
    p_target.sub:SetFont(UNIT_NAME_FONT, 12)
    p_target.sub:SetTextColor(181 / 255, 160 / 255, 128 / 255)
    p_target.sub:SetText(L["TARGET_DESC"])

    createCat(TARGET, L["TARGET_TOOLTIP"], p, 1)

    addOption(p_target, SHOW_TARGET_OF_TARGET_TEXT, L["TARGET_OF_TARGET_DESC"], "target_TARGET_ENABLED", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT, L["HEALTH_VALUE_DESC"], "target_HEALTH_VALUE_ENABLED", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, RAID_HEALTH_TEXT_PERC, L["HEALTH_PERCENTAGE_DESC"], "target_HEALTH_VALUE_TYPE", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, CLASS_COLORS, L["CLASS_COLOR_DESC"], "target_CLASS_COLOR", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, SHOW_DEBUFFS, L["SHOW_DEBUFFS_DESC"], "target_DEBUFFS", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, SHOW_ALL_ENEMY_DEBUFFS_TEXT, L["SHOW_ALL_DEBUFFS_DESC"], "target_BUFFS_FILTER_ALL", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, SHOW_BUFFS, L["SHOW_BUFFS_DESC"], "target_BUFFS", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, L["SHOW_THREAT_VALUE"], L["SHOW_THREAT_VALUE"], "target_THREAT_VALUE_ENABLED", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, L["TARGET_COMBOPOINTS"], L["TARGET_COMBOPOINTS_DEC"], "target_HOOK_COMBOPOINTS", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, BUFFS_ON_TOP, nil, "target_AURAS_ON_TOP", nil, nil, {["TARGET_ENABLED"] = true})
    addOption(p_target, L["DISPLAY_PORTRAIT_DAMAGED"], L["DISPLAY_PORTRAIT_DAMAGED_DESC"], "TARGET_FLOATING_COMBAT_TEXT", nil, nil, {["TARGET_ENABLED"] = true})

    InitPanel(p_target)
end
GW.LoadTargetPanel = LoadTargetPanel
