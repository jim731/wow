-- $Id: Atlas-ptBR.lua 368 2021-05-20 15:03:14Z arithmandar $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2005 ~ 2010 - Dan Gilbert <dan.b.gilbert at gmail dot com>
	Copyright 2010 - Lothaer <lothayer at gmail dot com>, Atlas Team
	Copyright 2011 ~ 2021 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]

local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale("Atlas", "ptBR", false);
-- Localize file must set above to false, for example:
--    local AL = AceLocale:NewLocale("Atlas", "deDE", false);

-- Atlas English Localization
if ( GetLocale() == "ptBR" ) then
-- Define the leading strings to be ignored while sorting
-- Ex: The Stockade
--AtlasSortIgnore = {"the (.+)"};

-- Syntax: ["real_zone_name"] = "localized map zone name"
AtlasZoneSubstitutions = {
--	["Ahn'Qiraj"] = "Temple of Ahn'Qiraj";
--	["The Temple of Atal'Hakkar"] = "Sunken Temple";
--	["Throne of Tides"] = "The Abyssal Maw: Throne of the Tides";
};
end


if L then
L["Adult"] = "Adulto"
L["AKA"] = "Conhecido como"
L["Arms Warrior"] = "Guerreiro Armas"
L["ATLAS_CLICK_TO_OPEN"] = "Clique para abrir a janela do mapa do Atlas."
L["ATLAS_COLLAPSE_BUTTON"] = "Clique para fechar o painel de legendas do Atlas."
L["ATLAS_DDL_CONTINENT"] = "Continente"
L["ATLAS_DDL_CONTINENT_DEEPHOLM"] = "Masmorras de Geodomo"
L["ATLAS_DDL_CONTINENT_DRAENOR"] = "Inst??ncias de Draenor"
L["ATLAS_DDL_CONTINENT_EASTERN"] = "Masmorras dos Reinos do Leste"
L["ATLAS_DDL_CONTINENT_KALIMDOR"] = "Masmorras de Kalimdor"
L["ATLAS_DDL_CONTINENT_NORTHREND"] = "Masmorras de Nort??ndria"
L["ATLAS_DDL_CONTINENT_OUTLAND"] = "Masmorras de Terral??m"
L["ATLAS_DDL_CONTINENT_PANDARIA"] = "Inst??ncias de Pandaria"
L["ATLAS_DDL_EXPANSION"] = "Expans??o"
L["ATLAS_DDL_EXPANSION_BC"] = "Masmorras de Burning Crusade"
L["ATLAS_DDL_EXPANSION_CATA"] = "Masmorras do Cataclisma"
L["ATLAS_DDL_EXPANSION_WOTLK"] = "Inst??ncia de Wrath of the Lich King"
L["ATLAS_DDL_LEVEL"] = "N??vel"
L["ATLAS_DDL_LEVEL_100PLUS"] = "Inst??ncias de N??vel 100+"
L["ATLAS_DDL_LEVEL_100TO110"] = "Inst??ncias de N??vel 100-110"
L["ATLAS_DDL_LEVEL_110PLUS"] = "Inst??ncias de N??vel 110+"
L["ATLAS_DDL_LEVEL_45TO60"] = "N??vel das Inst??ncias 45-60"
L["ATLAS_DDL_LEVEL_60TO70"] = "N??vel das Inst??ncias 60-70"
L["ATLAS_DDL_LEVEL_70TO80"] = "N??vel das Inst??ncias 70-80"
L["ATLAS_DDL_LEVEL_80TO85"] = "N??vel das Inst??ncias 80-85"
L["ATLAS_DDL_LEVEL_85TO90"] = "Inst??ncias de N??vel 85-90"
L["ATLAS_DDL_LEVEL_90TO100"] = "Inst??ncias de N??vel 90-100"
L["ATLAS_DDL_LEVEL_UNDER45"] = "Inst??ncias abaixo do N??vel 45"
L["ATLAS_DDL_PARTYSIZE"] = "Tamanho do Grupo"
L["ATLAS_DDL_TYPE"] = "Tipo"
L["ATLAS_DDL_TYPE_ENTRANCE"] = "Entradas"
L["ATLAS_DEP_MSG1"] = "O Atlas detectou m??dulo(s) desatualizado(s)."
L["ATLAS_DEP_OK"] = "Ok!"
L["ATLAS_ENTRANCE_BUTTON"] = "Entrada"
L["ATLAS_EXPAND_BUTTON"] = "Clique para abrir o painel de legendas do Atlas."
L["ATLAS_INFO"] = "Informa????es do Atlas"
L["ATLAS_INSTANCE_BUTTON"] = "Inst??ncia"
L["ATLAS_LDB_HINT"] = [=[Clique com o bot??o esquerdo para abrir o Atlas.
Clique com o bot??o direito para abrir as op????es do Atlas.]=]
L["ATLAS_MINIMAPLDB_HINT"] = [=[Clique com o bot??o esquerdo para abrir o Atlas.
Clique com o bot??o direito para as op????es do Atlas.
Clique com o bot??o esquerdo e arraste para mover este bot??o.]=]
L["ATLAS_OPEN_ADDON_LIST"] = "Abra a lista de addons"
L["ATLAS_OPTIONS_AUTOSEL"] = "Selecione automaticamente o Mapa da Inst??ncia"
L["ATLAS_OPTIONS_AUTOSEL_TIP"] = "Selecione automaticamente o Mapa da Inst??ncia, o Atlas vai detectar a sua localiza????o para escolher o melhor mapa de inst??ncia para voc??."
L["ATLAS_OPTIONS_BOSS_DESC"] = "Mostre a descri????o do Chefe quando dsipon??vel"
L["ATLAS_OPTIONS_BUTPOS"] = "Pois????o do bot??o"
L["ATLAS_OPTIONS_BUTTON"] = "Op????es"
L["ATLAS_OPTIONS_CATDD"] = "Organize os Mapas de Inst??ncias por:"
L["ATLAS_OPTIONS_DONTSHOWAGAIN"] = "N??o mostre a mesma informa????o novamente."
L["ATLAS_OPTIONS_LOCK"] = "Travar a janela do Atlas"
L["ATLAS_OPTIONS_RCLICK"] = "Clique com o bot??o direito para ir para o Mapa do Mundo"
L["ATLAS_OPTIONS_RESETPOS"] = "Recarregar posi????o"
L["ATLAS_OPTIONS_TRANS"] = "Transpar??ncia"
L["ATLAS_SEARCH_UNAVAIL"] = "Busca Indispon??vel"
L["ATLAS_SLASH"] = "/atlas"
L["ATLAS_SLASH_OPTIONS"] = "op????es"
L["ATLAS_STRING_CLEAR"] = "Claro"
L["ATLAS_STRING_LOCATION"] = "Localiza????o"
L["ATLAS_STRING_MINLEVEL"] = "N??vel M??nimo"
L["ATLAS_STRING_PLAYERLIMIT"] = "Limite de Jogadores"
L["ATLAS_STRING_RECLEVELRANGE"] = "N??vel Recomendado"
L["ATLAS_STRING_SEARCH"] = "Pesquisa"
L["ATLAS_STRING_SELECT_CAT"] = "Selecione a Categoria"
L["ATLAS_STRING_SELECT_MAP"] = "Selecione o Mapa"
L["ATLAS_TITLE"] = "Atlas"
L["Basement"] = "Por??o"
L["Blacksmithing Plans"] = "Planos de Ferraria"
L["Child"] = "Crian??a"
L["Colon"] = ":"
L["Comma"] = ","
L["Connection"] = "Conex??o"
L["East"] = "Leste"
L["Elevator"] = "Elevador"
L["End"] = "Fim"
L["Engineer"] = "Engenheiro"
L["Entrance"] = "Entrada"
L["Event"] = "Evento"
L["Exit"] = "Sa??da"
L["Fourth Stop"] = "Quarta Parada"
L["Ghost"] = "Fantasma"
L["Graveyard"] = "Cemit??rio"
L["Heroic"] = "Her??ico"
L["Heroic_Symbol"] = "(H)"
L["Holy Paladin"] = "Paladino Sagrado"
L["Holy Priest"] = "Sacerdote Sagrado"
L["Hyphen"] = "-"
L["Key"] = "Chave"
L["L-DQuote"] = "???"
L["L-Parenthesis"] = "("
L["L-SBracket"] = "["
L["MapA"] = "[A]"
L["MapB"] = "[B]"
L["MapC"] = "[C]"
L["MapD"] = "[D]"
L["MapE"] = "[E]"
L["MapF"] = "[F]"
L["MapG"] = "[G]"
L["MapH"] = "[H]"
L["MapI"] = "[I]"
L["MapJ"] = "[J]"
L["Middle"] = "Meio"
L["Mythic"] = "M??tico"
L["Mythic_Symbol"] = "(M)"
L["North"] = "Norte"
L["Optional"] = "Opcional"
L["Period"] = "."
L["Portal"] = "Portal"
L["PossibleMissingModule"] = "?? prov??vel que este mapa seja deste m??dulo:"
L["Protection Warrior"] = "Guerreiro Prote????o"
L["Random"] = "Aleat??rio"
L["Rare"] = "Raro"
L["R-DQuote"] = "???"
L["Repair"] = "Reparar"
L["Retribution Paladin"] = "Paladino Retribui????o"
L["Rewards"] = "Recompensas"
L["R-Parenthesis"] = ")"
L["R-SBracket"] = [=[]
]=]
L["Second Stop"] = "Segunda Parada"
L["Semicolon"] = ";"
L["Slash"] = "/"
L["South"] = "Sul"
L["Start"] = "in??cio"
L["Teleporter"] = "Teletransportador"
L["Teleporter destination"] = "Destino do teletransportador"
L["Third Stop"] = "Terceira Parada"
L["Top"] = "Topo"
L["Transport"] = "Transporte"
L["Tunnel"] = "T??nel"
L["West"] = "Oeste"
L["Yarley <Armorer>"] = "Yarley <Armoraria>"
L["Zaladormu"] = "Zaladormu"

end
