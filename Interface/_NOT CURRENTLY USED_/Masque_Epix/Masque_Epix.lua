local MSQ = LibStub("Masque", true)
if not MSQ then return end

local Resolution = GetCurrentResolution() > 0 and select(GetCurrentResolution(), GetScreenResolutions()) or nil
local Windowed = Display_DisplayModeDropDown:windowedmode()

Resolution = Resolution or (Windowed and GetCVar("gxWindowedResolution")) or GetCVar("gxFullscreenResolution")

local Mult = 768/string.match(Resolution, "%d+x(%d+)") / 0.9
local Scale = function(x) return Mult*math.floor(x/Mult+1.5) end

MSQ:AddSkin("Epix", {
	Icon = {
		Width = Scale(36),
		Height = Scale(36),
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Cooldown = {
		Width = 36,
		Height = 36,
	},
	ChargeCooldown = {
		Width = 36,
		Height = 36,
	},
	Name = {
		Width = 42,
		Height = 10,
		OffsetY = 2,
	},
	Count = {
		Width = 42,
		Height = 10,
		OffsetX = -3,
		OffsetY = 6,
	},
	HotKey = {
		Width = 42,
		Height = 10,
		OffsetX = -5,
		OffsetY = -5,
	},
	Duration = {
		Width = 42,
		Height = 10,
		OffsetY = -3,
	},
	Backdrop = {
		Width = Scale(42),
		Height = Scale(42),
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Backdrop]],
	},			
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Normal]],
	},		
	Border = {
		Width = 38,
		Height = 38,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.1},
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Border]],
	},				
	Checked = {
		Width = 38,
		Height = 38,
		BlendMode = "ADD",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Border]],		
	},
	Normal = {
		Width = Scale(42),
		Height = Scale(42),
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Normal]],
		Color = { 0.125, 0.125, 0.125, 1 },
	},
	Pushed = {
		Width = Scale(36),
		Height = Scale(38),
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Overlay]],
		Color = { 1, 1, 1, 0.1 },
	},
	Highlight = {
		Width = Scale(42),
		Height = Scale(42),	
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Overlay]],
		Color = { 1, 1, 1, 0.1 },
	},
	Flash = {
		Width = Scale(36),
		Height = Scale(38),
		Color = { 1, 0, 0, 0.2 },
		Texture = [[Interface\AddOns\Masque_Epix\Textures\Overlay]],
	},
	AutoCastable = {
		Width = 38,
		Height = 38,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	
}, true)