function AutoLootAssist_OnLoad(self)
    self:RegisterEvent("UNIT_SPELLCAST_SENT")
end


function AutoLootAssist_OnEvent(self, event, ...)
    if event == "LOOT_READY" then
        self:UnregisterEvent("LOOT_READY")
        if AutoLootAssist_IsSpellRelevant(self.LastSpellID) then
            for i = 1, GetNumLootItems() do
                LootSlot(i)
            end
        end
    elseif event == "UNIT_SPELLCAST_SENT" then
        local _, _, _, spellID = ...
        if AutoLootAssist_IsSpellRelevant(spellID) then
            self.LastSpellID = spellID
            self:RegisterEvent("LOOT_READY")
        else
            self.LastSpellID = nil
        end
    end
end


function AutoLootAssist_IsSpellRelevant(spellID)
    return spellID == 921 -- Pick Pocket
        or spellID == 7620 -- Fishing (Apprentice)
        or spellID == 7731 -- Fishing (Journeyman)
        or spellID == 7732 -- Fishing (Expert)
        or spellID == 13262 -- Disenchant
        or spellID == 18248 -- Fishing (Artisan)
        or spellID == 31252 -- Prospecting
        or spellID == 33095 -- Fishing (Master)
end
