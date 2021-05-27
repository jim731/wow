local frame = CreateFrame('FRAME')

frame:RegisterEvent('PLAYER_TARGET_CHANGED')

local TEXTURE = 'Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite.blp'

function frame:OnEvent(event, arg1)
  
  if event == 'PLAYER_TARGET_CHANGED' then
    local classification = UnitClassification("target")
  
    if classification == "rareelite" then
      SilverRareElites_ChangePortrait()
    end
  end
end

frame:SetScript('OnEvent', frame.OnEvent)

function SilverRareElites_ChangePortrait()
  local texture = TEXTURE
  
  TargetFrameTextureFrameTexture:SetTexture(texture)
end
