--localization file for french/France
local Lang = LibStub("AceLocale-3.0"):NewLocale("Attune", "frFR");
if (not Lang) then
	return;
end


-- INTERFACE
Lang["Credits"] = "Un énorme MERCI à ma guilde |cffffd100<Divine Heresy>|r pour leur support et patience pendant que je teste l'addon, et merci à |cffffd100Bushido @ Pyrewood Village|r pour l'aide sur TBC!\n\nMerci aussi beaucoup aux traducteurs:\n  - Traduction allemande: |cffffd100Sumaya @ Razorfen DE|r\n  - Traduction russe: |cffffd100Guilde Greymarch @ Flamegor RU|r\n  - Traduction espagnole: |cffffd100Coyu @ Pyrewood Village EU|r\n  - Traduction chinoise: |cffffd100ly395842562|r et |cffffd100Icyblade|r\n  - Traduction coréenne: |cffffd100Drix @ Azshara KR|r\n\n/Hug de la part Cixi/Gaya @ Remulos Horde"
Lang["Mini"] = "Mini"
Lang["Maxi"] = "Maxi"
Lang["Version"] = "Attune v.##VERSION## par Cixi@Remulos"
Lang["Splash"] = "v.##VERSION## par Cixi@Remulos. Tapez /attune pour commencer."
Lang["Survey"] = "Sondage"
Lang["Guild"] = "Guilde"
Lang["Party"] = "Groupe"
Lang["Raid"] = "Raid"
Lang["Run an attunement survey (for people with the addon)"] = "Faire un sondage (des personnes avec l'addon)"
Lang["Toggle between attunements and survey results"] = "Basculer entre les accès et les résultats de sondages" 
Lang["Close"] = "Fermer" 
Lang["Export"] = "Exporter"
Lang["My Data"] = "Mes Données"
Lang["Last Survey"] = "Dernier Sondage"
Lang["Guild Data"] = "Ma Guilde"
Lang["All Data"] = "Tout"
Lang["Export your Attune data to the website"] = "Exporter vos données vers un site internet"
Lang["Copy the text below, then upload it to"] = "Copiez le texte, puis uploadez le sur"
Lang["Results"] = "Résultats"
Lang["Not in a guild"] = "Pas dans une guilde"
Lang["Click on a header to sort the results"] = "Clickez sur un entête pour classer les résultats" 
Lang["Character"] = "Personnage"
Lang["Characters"] = "Personnages" 
Lang["Last survey results"] = "Derniers résultats"	
Lang["All FACTION results"] = "Tous les résultats ##FACTION##"
Lang["Guild members"] = "Membres de la guilde" 
Lang["All results"] = "Tous les résultats" 
Lang["Minimum level"] = "Niveau minimum" 
Lang["Click to navigate to that attunement"] = "Clickez pour aller à cet accès"
Lang["Attunes"] = "Accès"
Lang["Guild members on this step"] = "Membres de la guilde à cette étape"
Lang["Attuned guild members"] = "Membres de la guilde ayant accès"
Lang["Attuned alts"] = "Alts ayant accès"
Lang["Alts on this step"] = "Alts à cette étape"
Lang["Settings"] = "Paramètres"
Lang["Survey Log"] = "Audit"
Lang["LeftClick"] = "Click Gauche"
Lang["OpenAttune"] = "   Ouvrir Attune"
Lang["RightClick"] = "Click Droit"
Lang["OpenSettings"] = "       Paramètres"
Lang["Addon disabled"] = "Addon désactivé"
Lang["StartAutoGuildSurvey"] = "Début de sondage de guilde automatique"
Lang["SendingDataTo"] = "Envoi d'informations Attune à |cffffd100##NAME##|r"
Lang["NewVersionAvailable"] = "Une |cffffd100nouvelle version|r d'Attune est disponible, n'oubliez pas de le mettre à jour!"
Lang["CompletedStep"] = "Etape ##TYPE## |cffe4e400##STEP##|r pour l'accès |cffe4e400##NAME##|r terminée."
Lang["AttuneComplete"] = "Accès |cffe4e400##NAME##|r terminé!"
Lang["AttuneCompleteGuild"] = "Accès ##NAME## terminé!"
Lang["SendingSurveyWhat"] = "Début de sondage de ##WHAT##"
Lang["SendingGuildSilentSurvey"] = "Début de sondage de guilde (discret)"
Lang["SendingYellSilentSurvey"] = "Début de sondage de zone (discret)"
Lang["ReceivedDataFromName"] = "Infos reçues de |cffffd100##NAME##|r"
Lang["ExportingData"] = "Preparation des infos Attune pour ##COUNT## perso(s)"
Lang["ReceivedRequestFrom"] = "Sondage reçu de |cffffd100##FROM##|r"
Lang["Help1"] = "Cet addon vous permet de vérifier et partager vos accès"
Lang["Help2"] = "Tapez |cfffff700/attune|r pour commencer."
Lang["Help3"] = "Pour voir l'avancement des votre guilde, clickez |cfffff700Sondage|r pour récuperer les infos."
Lang["Help4"] = "Vous verrez la progression des chacun des membres de votre guilde ayant l'addon."
Lang["Help5"] = "Une fois que vous avez assez d'info, clickez |cfffff700Exporter|r pour exporter l'avancement"
Lang["Help6"] = "Les données peuvent etre publiées via |cfffff700https://warcraftratings.com/attune/upload|r"
Lang["Survey_DESC"] = "Run an attunement survey (for people with the addon)"
Lang["Export_DESC"] = "Export your Attune data to the website"
Lang["Toggle_DESC"] = "Toggle between attunements and survey results"
--Lang["PreferredLocale_TEXT"] = "Preferred Language"
--Lang["PreferredLocale_DESC"] = "Select the language you want to see Attune in. Changes to this will require a reload to take effect."
--v220
Lang["My Toons"] = "Mes Persos"
Lang["No Target"] = "Vous n'avez pas de target"
Lang["No Response From"] = "Pas de réponse de ##PLAYER##"
Lang["Sync Request From"] = "Nouvelle requête Attune Sync de:\n\n##PLAYER##"
Lang["Could be slow"] = "Selon la quantité de données ques vous avez, cela peut prendre longtemps"
Lang["Accept"] = "Accepter"
Lang["Reject"] = "Rejeter"
Lang["Busy right now"] = "##PLAYER## est occupé, réessayez plus tard"
Lang["Sending Sync Request"] = "Requête Sync envoyée à ##PLAYER##"
Lang["Request accepted, sending data to "] = "Requête acceptée, envoi de données à ##PLAYER##"
Lang["Received request from"] = "Requête reçue de ##PLAYER##"
Lang["Request rejected"] = "Requête rejectée"
Lang["Sync over"] = "Sync terminée, durée ##DURATION##"
Lang["Syncing Attune data with"] = "Synchro des données Attune avec ##PLAYER##"
Lang["Cannot sync while another sync is in progress"] = "Impossible, une synchro est déjà en cours"
Lang["Sync with target"] = "Synchro avec target"
Lang["Show Profiles"] = "Voir Profils"
Lang["Show Progress"] = "Voir Avancement"
Lang["Status"] = "Statut"
Lang["Role"] = "Role"
Lang["Last Surveyed"] = "Dernier sondage"
Lang['Seconds ago'] = "il y a ##DURATION##"
Lang["Main"] = "Main"
Lang["Alt"] = "Alt"
Lang["Tank"] = "Tank"
Lang["Healer"] = "Healer"
Lang["Melee DPS"] = "DD Mêlée"
Lang["Ranged DPS"] = "DD Ranged"
Lang["Bank"] = "Banque"
Lang["DelAlts_TEXT"] = "Effacer tous les Alts"
Lang["DelAlts_DESC"] = "Effacer toute information recueillie sur des Alts"
Lang["DelAlts_CONF"] = "Vraiment effacer tous les Alts?"
Lang["DelAlts_DONE"] = "Tous Alts effacés."
Lang["DelUnspecified_TEXT"] = "Effacer tous les sans-statut"
Lang["DelUnspecified_DESC"] = "Effacer toute information recueillie sur des persos sans statut Main/Alt"
Lang["DelUnspecified_CONF"] = "Vraiment effacer tous les sans-statut?"
Lang["DelUnspecified_DONE"] = "Tous sans-statut effacés"
--v221
Lang["Open Raid Planner"] = "Ouvrir le Raid Planner"
Lang["Unspecified"] = "Non specifié"
Lang["Empty"] = "Vide"
Lang["Guildies only"] = "Limiter a la guilde"
Lang["Show Mains"] = "Montrer les Mains"
Lang["Show Unspecified"] = "Montrer les non-specifiés"
Lang["Show Alts"] = "Montrer les Alts"
Lang["Show Unattuned"] = "Montrer les sans-accès"
Lang["Raid spots"] = "##SIZE## places dans le Raid"
Lang["Group Number"] = "Groupe ##NUMBER##"
Lang["Move to next group"] = "    Delplacer dans le groupe suivant"
Lang["Remove from raid"] = "  Enlever du"
Lang["Select a raid and click on players to add them in"] = "Choisissez un raid puis clickez sur un joueur pour l'ajouter"
--v224
Lang["Enter a new name for this raid group"] = "Saisissez un nom pour ce groupe raid"
Lang["Save"] = "Sauvegarder"
--v226
Lang["Invite"] = "Inviter"
Lang["Send raid invites to all listed players?"] = "Inviter tous les joueurs listés a joindre le raid?"
Lang["External link"] = "Lien vers une base de données en ligne"


-- OPTIONS
Lang["MinimapButton_TEXT"] = "Montrer le bouton de minicarte"
Lang["MinimapButton_DESC"] = "Affiche un bouton sur la minicarte pour acceder à l'addon ou ses options."
Lang["AutoSurvey_TEXT"] = "Faire un sondage automatique au démarrage"
Lang["AutoSurvey_DESC"] = "A chaque fois que vous entrez dans le jeu, l'addon fera un sondage automatique."
Lang["ShowSurveyed_TEXT"] = "Montrer quand vous répondez a un sondage"
Lang["ShowSurveyed_DESC"] =  "Affiche un message quand vous recevez (et repondez) à une demande de sondage."
Lang["ShowResponses_TEXT"] = "Montrer les réponses quand vous lancez un sondage"
Lang["ShowResponses_DESC"] = "Affiche un message à chaque réponse d'un de vos sondages."
Lang["ShowSetMessages_TEXT"] = "Montrer les messages de completion"
Lang["ShowSetMessages_DESC"] = "Affiche un message quand vous completez une étape ou un accès."
Lang["AnnounceToGuild_TEXT"] = "Announcer les accès a la guilde"
Lang["AnnounceToGuild_DESC"] = "Envoie un message à la guilde lorsqu'un accès est completé."
Lang["ShowOther_TEXT"] = "Montrer les autres messages de l'addon"
Lang["ShowOther_DESC"] = "Affiche le reste des messages génériques (écran de demarrage, envoi de sondage, mise a jour disponible, etc)."
Lang["ShowGuildies_TEXT"] = "Montrer les membres de la guilde à chaque étape                    Nombre max"  --this has a gap for the editbox
Lang["ShowGuildies_DESC"] = "Affiche dans le tooptip de chaque étape la liste des membres de la guilde qui sont à cette étape.\nAdjustez le nombre maximal de noms à lister si besoin."
Lang["ShowAltsInstead_TEXT"] = "Montrer plutôt la liste des Alts à la place"
Lang["ShowAltsInstead_DESC"] = "Les tooltips afficheront les Alts à cette étape au lieu des membres de la guilde."
Lang["ClearAll_TEXT"] = "Effacer TOUS les résultats"
Lang["ClearAll_DESC"] = "Effacer toute information recueillie sur les joueurs."
Lang["ClearAll_CONF"] = "Vraimer tout effacer?"
Lang["ClearAll_DONE"] = "Tous les résultats effacés."
Lang["DelNonGuildies_TEXT"] = "Effacer les autres guildes"
Lang["DelNonGuildies_DESC"] = "Effacer toute information recueillie sur les joueurs d'autres guildes"
Lang["DelNonGuildies_CONF"] = "Vraimer effacer toutes les autres guildes?"
Lang["DelNonGuildies_DONE"] = "Les résultats d'autres guildes ont été effacés."
Lang["DelUnder60_TEXT"] = "Effacer les persos en dessous de 60"
Lang["DelUnder60_DESC"] = "Effacer toute information recueillie sur les joueurs en dessous de 60."
Lang["DelUnder60_CONF"] = "Vraimer effacer tout ce qui est en dessous de 60?"
Lang["DelUnder60_DONE"] = "Tous les résultats en dessous de 60 effacés."
Lang["DelUnder70_TEXT"] = "Effacer les persos en dessous de 70"
Lang["DelUnder70_DESC"] = "Effacer toute information recueillie sur les joueurs en dessous de 70."
Lang["DelUnder70_CONF"] = "Vraimer effacer tout ce qui est en dessous de 70?"
Lang["DelUnder70_DONE"] = "Tous les résultats en dessous de 70 effacés."


-- TREEVIEW
Lang["World of Warcraft"] = "World of Warcraft"
Lang["The Burning Crusade"] = "The Burning Crusade"
Lang["Molten Core"] = "Coeur de Magma"
Lang["Onyxia's Lair"] = "Repaire d'Onyxia"
Lang["Blackwing Lair"] = "Repaire de l'Aile Noire"
Lang["Naxxramas"] = "Naxxramas"
Lang["Scepter of the Shifting Sands"] = "Sceptre des Sables Changeants"
Lang["Shadow Labyrinth"] = "Labyrinthe des Ombres"
Lang["The Shattered Halls"] = "Les Salles Brisées" 
Lang["The Arcatraz"] = "L'Arcatraz"
Lang["The Black Morass"] = "Le Noir Marécage"
Lang["Thrallmar Heroics"] = "Thrallmar héroïque"
Lang["Honor Hold Heroics"] = "Bastion de l'Honneur héroïque"
Lang["Cenarion Expedition Heroics"] = "Expédition Cénarienne héroïque"
Lang["Lower City Heroics"] = "Ville Basse héroïque"
Lang["Sha'tar Heroics"] = "Sha'tar héroïque"
Lang["Keepers of Time Heroics"] = "Guardiens du Temps héroïque"
Lang["Nightbane"] = "Plaie-de-nuit"
Lang["Karazhan"] = "Karazhan"
Lang["Serpentshrine Cavern"] = "Caverne du Sanctuaire du Serpent"
Lang["The Eye"] = "L'Œil"
Lang["Mount Hyjal"] = "Mont Hyjal"
Lang["Black Temple"] = "Temple Noir"
Lang["MC_Desc"] = "Tous les membres du raid doivent avoir accès pour entrer dans l'instance, sauf s'ils entrent via les Profondeurs de Rochenoire." 
Lang["Ony_Desc"] = "Tous les membres du raid doivent avoir l'Amulette Drakefeu dans leur sac pour entrer dans l'instance."
Lang["BWL_Desc"] = "Tous les membres du raid doivent avoir accès pour entrer dans l'instance, sauf s'ils entrent via le Pic Rochenoire." 
Lang["All_Desc"] = "Tous les membres du raid doivent avoir accès pour entrer dans l'instance."
Lang["AQ_Desc"] = "Une seule personne par royaume a besoin de completer cette chaine afin d'ouvrir les portes d'Ahn'Qiraj."
Lang["OnlyOne_Desc"] = "Un seul membre du groupe a besoin d'avoir accès pour ouvrir l'instance. Un voleur avec Crochetage à 350 peut aussi ouvrir l'instance."
Lang["Heroic_Desc"] = "Tous les membres du groupe doivent avoir la réputation requise ainsi que la clé pour entrer dans un donjon en mode héroïque."
Lang["NB_Desc"] = "Un seul membre du raid a besoin d'avoir l'Urne Noircie pour invoquer Plaie-de-nuit."
Lang["BT_Desc"] = "Tous les membres du raid doivent avoir le Medallion de Karabor pour entrer dans l'instance."
Lang["BM_Desc"] = "Tous les membres du groupe doivent completer ces quêtes pour entrer dans l'instance." 


-- GENERIC
Lang["Reach level"] = "Atteindre niveau"
Lang["Attuned"] = "Accès authorisé"
Lang["Not attuned"] = "Accès interdit"
Lang["AttuneColors"] = "Bleu:    Accès authorisé\nRouge: Accès interdit"
Lang["Minimum Level"] = "Ceci est le niveau minimum pour accéder au quêtes."
Lang["NPC Not Found"] = "PNJ non trouvé"
Lang["Level"] = "Niveau"
Lang["Exalted with"] = "Exalté avec"
Lang["Revered with"] = "Reveré par"
Lang["Honored with"] = "Honoré par"
Lang["Friendly with"] = "Ami avec"
Lang["Neutral with"] = "Neutre avec"
Lang["Quest"] = "Quête"
Lang["Pick Up"] = "Prendre"
Lang["Turn In"] = "Rendre"
Lang["Kill"] = "Tuer"
Lang["Interact"] = "Parler"
Lang["Item"] = "Objet"
Lang["Required level"] = "Niveau requis"
Lang["Requires level"] = "Requiert niveau"
Lang["Attunement or key"] = "Accès ou clé"
Lang["Reputation"] = "Réputation"
Lang["in"] = "dans"
Lang["Unknown Reputation"] = "Réputation inconnue"
Lang["Current progress"] = "Avancement"
Lang["Completion"] = "Progression"
Lang["Quest information not found"] = "Details de la quête non trouvés"
Lang["Information not found"] = "Information non trouvée"
Lang["Solo quest"] = "Quête solo"
Lang["Party quest"] = "Quête de groupe (##NB## joueurs)"
Lang["Raid quest"] = "Quête de raid (##NB## joueurs)"
Lang["HEROIC"] = "H"
Lang["Elite"] = "Elite"
Lang["Boss"] = "Boss"
Lang["Rare Elite"] = "Elite Rare"
Lang["Dragonkin"] = "Dragon"
Lang["Troll"] = "Troll"
Lang["Ogre"] = "Ogre"
Lang["Orc"] = "Orc"
Lang["Half-Orc"] = "Demi-Orc"
Lang["Dragonkin (in Blood Elf form)"] = "Dragon (sous forme d'Elfe de Sang)"
Lang["Human"] = "Humain"
Lang["Dwarf"] = "Nain"
Lang["Mechanical"] = "Mécanique"
Lang["Arakkoa"] = "Arakkoa"
Lang["Dragonkin (in Humanoid form)"] = "Dragon (sous forme Humaine)"
Lang["Ethereal"] = "Ethérien"
Lang["Blood Elf"] = "Elfe de Sang"
Lang["Elemental"] = "Elémentaire"
Lang["Shiny thingy"] = "Truc qui brille"
Lang["Naga"] = "Naga"
Lang["Demon"] = "Demon"
Lang["Gronn"] = "Gronn"
Lang["Undead (in Dragon form)"] = "Mort-vivant (sous forme de Dragon)"
Lang["Tauren"] = "Tauren"
Lang["Qiraji"] = "Qiraji"
Lang["Gnome"] = "Gnome"
Lang["Broken"] = "Roué"
Lang["Draenei"] = "Draeneï"
Lang["Undead"] = "Mort-vivant"
Lang["Gorilla"] = "Gorille"
Lang["Shark"] = "Requin"
Lang["Chimaera"] = "Chimère"
Lang["Wisp"] = "Feu follet"
Lang["Night-Elf"] = "Elfe de la nuit"


-- REP
Lang["Argent Dawn"] = "Aube d'argent"
Lang["Brood of Nozdormu"] = "Progéniture de Nozdormu"
Lang["Thrallmar"] = "Thrallmar"
Lang["Honor Hold"] = "Bastion de l'Honneur"
Lang["Cenarion Expedition"] = "Expédition cénarienne"
Lang["Lower City"] = "Ville basse"
Lang["The Sha'tar"] = "Les Sha'tar"
Lang["Keepers of Time"] = "Guardiens du Temps"
Lang["The Violet Eye"] = "L'Œil pourpre"
Lang["The Aldor"] = "L'Aldor"
Lang["The Scryers"] = "Les Clairvoyants"


-- LOCATIONS
Lang["Blackrock Mountain"] = "Rochenoire"
Lang["Blackrock Depths"] = "Profondeurs de Rochenoire"
Lang["Badlands"] = "Badlands"
Lang["Lower Blackrock Spire"] = "Bas du Pic Rochenoire"
Lang["Upper Blackrock Spire"] = "Sommet du Pic Rochenoire"
Lang["Orgrimmar"] = "Orgrimmar"
Lang["Western Plaguelands"] = "Maleterres de l'ouest"
Lang["Desolace"] = "Désolace"
Lang["Dustwallow Marsh"] = "Marécage d'Âprefange"
Lang["Tanaris"] = "Tanaris"
Lang["Winterspring"] = "Berceau-de-l'Hiver"
Lang["Swamp of Sorrows"] = "Marais des Chagrins"
Lang["Wetlands"] = "Les Paluns"
Lang["Burning Steppes"] = "Steppes ardentes"
Lang["Redridge Mountains"] = "Les Carmines"
Lang["Stormwind City"] = "Hurlevent"
Lang["Eastern Plaguelands"] = "Maleterres de l'est"
Lang["Silithus"] = "Silithus"
Lang["The Temple of Atal'Hakkar"] = "Le Temple d'Atal'Hakkar"
Lang["Teldrassil"] = "Teldrassil"
Lang["Moonglade"] = "Reflet-de-Lune"
Lang["Hinterlands"] = "Hinterlands"
Lang["Ashenvale"] = "Orneval"
Lang["Feralas"] = "Féralas"
Lang["Duskwood"] = "Bois de la Pénombre"
Lang["Azshara"] = "Azshara"
Lang["Blasted Lands"] = "Terres foudroyées"
Lang["Undercity"] = "Fossoyeuse"
Lang["Silverpine Forest"] = "Forêt des Pins argentés"
Lang["Shadowmoon Valley"] = "Vallée d'Ombrelune"
Lang["Hellfire Peninsula"] = "Péninsule des Flammes infernales"
Lang["Sethekk Halls"] = "Les salles des Sethekk"
Lang["Caverns Of Time"] = "Grottes du temps"
Lang["Netherstorm"] = "Raz-de-Néant"
Lang["Shattrath City"] = "Shattrath"
Lang["The Mechanaar"] = "Le Méchanar"
Lang["The Botanica"] = "La Botanica"
Lang["Zangarmarsh"] = "Marécage de Zangar"
Lang["Terokkar Forest"] = "Forêt de Terokkar"
Lang["Deadwind Pass"] = "Défilé de Deuillevent"
Lang["Alterac Mountains"] = "Montagnes d'Alterac"
Lang["The Steamvault"] = "Le Caveau de la vapeur"
Lang["Slave Pens"] = "Les enclos aux esclaves"
Lang["Gruul's Lair"] = "Repaire de Gruul"
Lang["Magtheridon's Lair"] = "Le repaire de Magtheridon"
Lang["Zul'Aman"] = "Zul'Aman"
Lang["Sunwell Plateau"] = "Plateau du Puits de soleil"



-- ITEMS
Lang["Drakkisath's Brand"] = "Marque de Drakkisath"
Lang["Crystalline Tear"] = "Larme cristalline"
Lang["I_18412"] = "Fragment du Magmat"			-- https://www.thegeekcrusade-serveur.com/db/?item=18412
Lang["I_12562"] = "Importants documents Rochenoire"			-- https://www.thegeekcrusade-serveur.com/db/?item=12562
Lang["I_16786"] = "Oeil de draconide noir"			-- https://www.thegeekcrusade-serveur.com/db/?item=16786
Lang["I_11446"] = "Une note chiffonnée"			-- https://www.thegeekcrusade-serveur.com/db/?item=11446
Lang["I_11465"] = "Informations égarées du maréchal Windsor"			-- https://www.thegeekcrusade-serveur.com/db/?item=11465
Lang["I_11464"] = "Informations égarées du maréchal Windsor"			-- https://www.thegeekcrusade-serveur.com/db/?item=11464
Lang["I_18987"] = "Instructions de Main-noire"			-- https://www.thegeekcrusade-serveur.com/db/?item=18987
Lang["I_20383"] = "Tête du seigneur des couvées Lanistaire"			-- https://www.thegeekcrusade-serveur.com/db/?item=20383
Lang["I_21138"] = "Fragment de sceptre rouge"			-- https://www.thegeekcrusade-serveur.com/db/?item=21138
Lang["I_21146"] = "Fragment de la corruption du Cauchemar"			-- https://www.thegeekcrusade-serveur.com/db/?item=21146
Lang["I_21147"] = "Fragment de la corruption du Cauchemar"			-- https://www.thegeekcrusade-serveur.com/db/?item=21147
Lang["I_21148"] = "Fragment de la corruption du Cauchemar"			-- https://www.thegeekcrusade-serveur.com/db/?item=21148
Lang["I_21149"] = "Fragment de la corruption du Cauchemar"			-- https://www.thegeekcrusade-serveur.com/db/?item=21149
Lang["I_21139"] = "Fragment de sceptre vert"			-- https://www.thegeekcrusade-serveur.com/db/?item=21139
Lang["I_21103"] = "Le draconique pour les nuls - Chapitre I"			-- https://www.thegeekcrusade-serveur.com/db/?item=21103
Lang["I_21104"] = "Le draconique pour les nuls - Chapitre II"			-- https://www.thegeekcrusade-serveur.com/db/?item=21104
Lang["I_21105"] = "Le draconique pour les nuls - Chapitre III"			-- https://www.thegeekcrusade-serveur.com/db/?item=21105
Lang["I_21106"] = "Le draconique pour les nuls - Chapitre IV"			-- https://www.thegeekcrusade-serveur.com/db/?item=21106
Lang["I_21107"] = "Le draconique pour les nuls - Chapitre V"			-- https://www.thegeekcrusade-serveur.com/db/?item=21107
Lang["I_21108"] = "Le draconique pour les nuls - Chapitre VI"			-- https://www.thegeekcrusade-serveur.com/db/?item=21108
Lang["I_21109"] = "Le draconique pour les nuls - Chapitre VII"			-- https://www.thegeekcrusade-serveur.com/db/?item=21109
Lang["I_21110"] = "Le draconique pour les nuls - Chapitre VIII"			-- https://www.thegeekcrusade-serveur.com/db/?item=21110
Lang["I_21111"] = "Le draconique pour les nuls : volume II"			-- https://www.thegeekcrusade-serveur.com/db/?item=21111
Lang["I_21027"] = "Carcasse de Lakmaeran"			-- https://www.thegeekcrusade-serveur.com/db/?item=21027
Lang["I_21024"] = "Filet de chimaerok"			-- https://www.thegeekcrusade-serveur.com/db/?item=21024
Lang["I_20951"] = "Lunettes de divination de Narain"			-- https://www.thegeekcrusade-serveur.com/db/?item=20951
Lang["I_21137"] = "Fragment de sceptre bleu"			-- https://www.thegeekcrusade-serveur.com/db/?item=21137
Lang["I_21175"] = "Le Sceptre des Sables changeants"			-- https://www.thegeekcrusade-serveur.com/db/?item=21175
Lang["I_31241"] = "Moule à clé préparé"			-- https://www.thegeekcrusade-serveur.com/db/?item=31241
Lang["I_31239"] = "Moule à clé préparé"			-- https://www.thegeekcrusade-serveur.com/db/?item=31239
Lang["I_27991"] = "Clé du labyrinthe des Ombres"			-- https://www.thegeekcrusade-serveur.com/db/?item=27991
Lang["I_31086"] = "Pièce inférieure de la clé d'Arcatraz"			-- https://www.thegeekcrusade-serveur.com/db/?item=31086
Lang["I_31085"] = "Pièce supérieure de la clé de l'Arcatraz"			-- https://www.thegeekcrusade-serveur.com/db/?item=31085
Lang["I_31084"] = "Clé de l'Arcatraz"			-- https://www.thegeekcrusade-serveur.com/db/?item=31084
Lang["I_30637"] = "Clé en flammes forgées"			-- https://www.thegeekcrusade-serveur.com/db/?item=30637
Lang["I_30622"] = "Clé en flammes forgées"			-- https://www.thegeekcrusade-serveur.com/db/?item=30622
Lang["I_30623"] = "Clé du réservoir"			-- https://www.thegeekcrusade-serveur.com/db/?item=30623
Lang["I_30633"] = "Clé auchenaï"			-- https://www.thegeekcrusade-serveur.com/db/?item=30633
Lang["I_30634"] = "Clé dimensionnelle"			-- https://www.thegeekcrusade-serveur.com/db/?item=30634
Lang["I_30635"] = "Clé du Temps"			-- https://www.thegeekcrusade-serveur.com/db/?item=30635
Lang["I_24514"] = "Premier fragment de la clé"			-- https://www.thegeekcrusade-serveur.com/db/?item=24514
Lang["I_24487"] = "Deuxième fragment de la clé"			-- https://www.thegeekcrusade-serveur.com/db/?item=24487
Lang["I_24488"] = "Troisième fragment de la clé"			-- https://www.thegeekcrusade-serveur.com/db/?item=24488
Lang["I_24490"] = "La clé du maître"			-- https://www.thegeekcrusade-serveur.com/db/?item=24490
Lang["I_23933"] = "Journal de Medivh"			-- https://www.thegeekcrusade-serveur.com/db/?item=23933
Lang["I_25462"] = "Tome de la pénombre"			-- https://www.thegeekcrusade-serveur.com/db/?item=25462
Lang["I_25461"] = "Livre des noms oubliés"			-- https://www.thegeekcrusade-serveur.com/db/?item=25461
Lang["I_24140"] = "Urne noircie"			-- https://www.thegeekcrusade-serveur.com/db/?item=24140
Lang["I_31750"] = "Chevalière terrestre"			-- https://www.thegeekcrusade-serveur.com/db/?item=31750
Lang["I_31751"] = "Chevalière flamboyante"			-- https://www.thegeekcrusade-serveur.com/db/?item=31751
Lang["I_31716"] = "Hache inutilisée du bourreau"			-- https://www.thegeekcrusade-serveur.com/db/?item=31716
Lang["I_31721"] = "Trident de Kalithresh"			-- https://www.thegeekcrusade-serveur.com/db/?item=31721
Lang["I_31722"] = "Essence de Marmon"			-- https://www.thegeekcrusade-serveur.com/db/?item=31722
Lang["I_31704"] = "La clé de la Tempête"			-- https://www.thegeekcrusade-serveur.com/db/?item=31704
Lang["I_29905"] = "Reste de la fiole de Kael"			-- https://www.thegeekcrusade-serveur.com/db/?item=29905
Lang["I_29906"] = "Reste de la fiole de Vashj"			-- https://www.thegeekcrusade-serveur.com/db/?item=29906
Lang["I_31307"] = "Coeur de fureur"			-- https://www.thegeekcrusade-serveur.com/db/?item=31307
Lang["I_32649"] = "Médaillon de Karabor"			-- https://www.thegeekcrusade-serveur.com/db/?item=32649


-- QUESTS - Classic
Lang["Q1_7848"] = "Harmonisation avec le Cœur du Magma"	-- https://www.thegeekcrusade-serveur.com/db/?quest=7848
Lang["Q2_7848"] = "Aventurez-vous jusqu'au portail d'entrée du Cœur du Magma dans les Profondeurs de Rochenoire et récupérez un Fragment du Magma. Lorsque ce sera fait, retournez voir Lothos Ouvrefaille au mont Rochenoire."
Lang["Q1_4903"] = "Ordre du chef de guerre"	-- https://www.thegeekcrusade-serveur.com/db/?quest=4903
Lang["Q2_4903"] = "Tuer le généralissime Omokk, le maître de guerre Voone et le seigneur Wyrmthalak. Récupérer les Importants documents Rochenoire. Retourner voir le chef de guerre Sangredent à Kargath une fois la mission accomplie."
Lang["Q1_4941"] = "Sagesse d'Eitrigg"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4941
Lang["Q2_4941"] = "Parler à Eitrigg, à Orgrimmar. Après avoir discuté avec Eitrigg, demander conseil à Thrall.\n\nVous avez déjà vu Eitrigg dans les Appartements de Thrall."
Lang["Q1_4974"] = "Pour la Horde !"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4974
Lang["Q2_4974"] = "Aller au Pic Rochenoire et tuer le Chef de guerre, Rend Main-noire. Prendre sa tête et retourner à Orgrimmar."
Lang["Q1_6566"] = "Ce que le vent apporte"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6566
Lang["Q2_6566"] = "Écouter Thrall."
Lang["Q1_6567"] = "Le Champion de la Horde"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6567
Lang["Q2_6567"] = "Chercher Rexxar sur les chemins de Désolace."
Lang["Q1_6568"] = "Maîtresse en tromperie"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6568
Lang["Q2_6568"] = "Apporter la Lettre de Rokaro à Myranda la Mégère, dans les Maleterres de l’ouest."
Lang["Q1_6569"] = "Illusions d'Occulus"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6569
Lang["Q2_6569"] = "Aller au Pic Rochenoire et collecter 20 Yeux de draconide noir. Retourner voir Myranda la Mégère quand la tâche sera terminée."
Lang["Q1_6570"] = "Brandeguerre"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6570
Lang["Q2_6570"] = "Aller à la tourbière du Ver, dans le marécage d'Âprefange, et chercher la tanière de Brandeguerre. Une fois à l’intérieur, porter l’Amulette de subversion draconique, et parler à Brandeguerre."
Lang["Q1_6584"] = "L'épreuve des crânes, Chronalis"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6584
Lang["Q2_6584"] = "Chronalis, enfant de Nozdormu, garde les Grottes du temps, dans le Désert de Tanaris. Tuez-le et rapportez son crâne à Brandeguerre."
Lang["Q1_6582"] = "L'épreuve des crânes, Clairvoyant"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6582
Lang["Q2_6582"] = "Vous devez trouver Clairvoyant, le drake champion du Vol bleu, et le tuer. Arracher son crâne à son cadavre, et le rapporter à Brandeguerre."
Lang["Q1_6583"] = "L'épreuve des crânes, Somnus"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6583
Lang["Q2_6583"] = "Détruire le Champion drake du Vol vert, Somnus. Arracher son crâne à son cadavre, puis le rapporter à Brandeguerre."
Lang["Q1_6585"] = "L'épreuve des crânes, Axtroz"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6585
Lang["Q2_6585"] = "Aller à Grim Batol et traquer Axtroz, le Champion drake du Vol rouge. Le tuer et arracher son crâne, puis l’apporter à Brandeguerre."
Lang["Q1_6601"] = "Ascension..."			-- https://www.thegeekcrusade-serveur.com/db/?quest=6601
Lang["Q2_6601"] = "Il semble que la comédie soit finie. Vous savez que l’Amulette de subversion draconique, créée par Myranda la Mégère, ne fonctionnera pas à l’intérieur du pic Rochenoire. Peut-être devriez-vous trouver Rexxar et lui exposer votre fâcheuse situation. Montrez-lui l'Amulette drakefeu terne. Avec un peu de chance, il saura quoi faire."
Lang["Q1_6602"] = "Le sang du champion des dragons noirs"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6602
Lang["Q2_6602"] = "Aller au Pic Rochenoire, et tuer le général Drakkisath. Récupérer son sang et l'apporter à Rexxar."
Lang["Q1_4182"] = "La menace des draconiens"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4182
Lang["Q2_4182"] = "Tuer 15 Rejetons noirs, 10 Draconides noirs, 4 Wyrmides noirs et 1 Drake noir. Retrouver Helendis Ruissecorne une fois la tâche accomplie."
Lang["Q1_4183"] = "Les véritables maîtres"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4183
Lang["Q2_4183"] = "Voyager jusqu'à Comté-du-Lac et remettre la Lettre d'Helendis Ruissecorne au Magistrat Salomon."
Lang["Q1_4184"] = "Les véritables maîtres"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4184
Lang["Q2_4184"] = "Voyager jusqu'à Hurlevent et remettre la Demande d'aide de Salomon au généralissime Bolvar Fordragon.\n\nBolvar demeure dans le Donjon de Hurlevent."
Lang["Q1_4185"] = "Les véritables maîtres"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4185
Lang["Q2_4185"] = "Parler au généralissime Bolvar Fordragon après avoir parlé à dame Katrana Prestor."
Lang["Q1_4186"] = "Les véritables maîtres"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4186
Lang["Q2_4186"] = "Apporter le Décret de Bolvar au Magistrat Salomon à Comté-du-Lac."
Lang["Q1_4223"] = "Les véritables maîtres"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4223
Lang["Q2_4223"] = "Parler au maréchal Maxwell dans les Steppes ardentes."
Lang["Q1_4224"] = "Les véritables maîtres"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4224
Lang["Q2_4224"] = "Parlez à John le Loqueteux pour apprendre ce qu'il est advenu du maréchal Windsor puis retournez voir le maréchal Maxwell lorsque vous aurez accompli cette tâche.\n\nVous vous rappelez que le maréchal Maxwell vous a dit de le chercher dans une grotte au nord."
Lang["Q1_4241"] = "Maréchal Windsor"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4241
Lang["Q2_4241"] = "Partir pour le mont Rochenoire au nord-ouest et pénétrer dans les Profondeurs de Rochenoire. Découvrir ce qu'il est advenu du Maréchal Windsor.\n\nVous vous souvenez que John le Loqueteux a dit que Windsor avait été traîné en prison."
Lang["Q1_4242"] = "Espoir abandonné"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4242
Lang["Q2_4242"] = "Donner les mauvaises nouvelles au maréchal Maxwell."
Lang["Q1_4264"] = "Une note chiffonnée"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4264
Lang["Q2_4264"] = "Il se peut que vous ayez simplement buté sur quelque chose qui pourrait intéresser le maréchal Windsor au plus haut point. Il reste peut-être encore un peu d'espoir, après tout…"
Lang["Q1_4282"] = "Un espoir en lambeaux"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4282
Lang["Q2_4282"] = "Rapporter les Informations égarées du maréchal Windsor.\n\nLe maréchal Windsor pense qu'ils sont détenus par le seigneur golem Argelmach et par le général Forgehargne."
Lang["Q1_4322"] = "Évasion !"			-- https://www.thegeekcrusade-serveur.com/db/?quest=4322
Lang["Q2_4322"] = "Aider le maréchal Windsor à récupérer son équipement et à libérer ses amis. Ensuite, retourner voir le maréchal Maxwell."
Lang["Q1_6402"] = "Le rendez-vous à Hurlevent"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6402
Lang["Q2_6402"] = "Voyagez jusqu'à Hurlevent et rendez-vous aux portes de la ville. Parlez à l'écuyer Rowe, afin qu'il informe le maréchal Windsor de votre arrivée."
Lang["Q1_6403"] = "La grande mascarade"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6403
Lang["Q2_6403"] = "Suivre Reginald Windsor dans Hurlevent. Le protéger contre toute menace !"
Lang["Q1_6501"] = "L'Œil de dragon"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6501
Lang["Q2_6501"] = "Vous devez écumer le monde pour pouvoir rétablir le pouvoir du Fragment de l'Oeil de dragon. La seule information dont vous disposez à propos de cette chose, c’est qu’elle existe."
Lang["Q1_6502"] = "Amulette drakefeu"			-- https://www.thegeekcrusade-serveur.com/db/?quest=6502
Lang["Q2_6502"] = "Récupérer le Sang du Champion des dragons noirs sur le général Drakkisath. Il se trouve dans sa salle du trône, derrière les Halls d'Ascension, sur le Pic Rochenoire."
Lang["Q1_7761"] = "Les ordres de Main-noire"			-- https://www.thegeekcrusade-serveur.com/db/?quest=7761
Lang["Q2_7761"] = "Cet orc est stupide. Il semble que vous deviez trouver un moyen d’obtenir la Marque de Drakkisath pour accéder à l’Orbe de commandement.\n\nD’après la lettre, la Marque est gardée par le général Drakkisath. Vous devriez peut-être enquêter."
Lang["Q1_9121"] = "Naxxramas, la citadelle de l'effroi"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9121
Lang["Q2_9121"] = "L'archimage Angela Dosantos à la chapelle de l'Espoir de Lumière dans les Maleterres de l'est veut 5 Cristaux des arcanes, 2 Cristaux de nexus, 1 Orbe de piété et 60 pièces d'or. Vous devez aussi être <Honoré/Honorée> auprès de l'Aube d'argent."
Lang["Q1_9122"] = "Naxxramas, la citadelle de l'effroi"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9122
Lang["Q2_9122"] = "L'archimage Angela Dosantos à la chapelle de l'Espoir de Lumière dans les Maleterres de l'est veut 2 Cristaux des arcanes, 1 Cristal de nexus et 30 pièces d'or. Vous devez aussi être <Révéré/Révérée> auprès de l'Aube d'argent."
Lang["Q1_9123"] = "Naxxramas, la citadelle de l'effroi"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9123
Lang["Q2_9123"] = "L'archimage Angela Dosantos à la chapelle de l'Espoir de Lumière dans les Maleterres de l'est vous accordera gratuitement l'Occultation arcanique. Vous devez être <Exalté/Exaltée> auprès de l'Aube d'argent."
Lang["Q1_8286"] = "Ce que demain apportera"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8286
Lang["Q2_8286"] = "Rendez-vous dans les Grottes du temps en Tanaris et trouvez Anachronos, la progéniture de Nozdormu."
Lang["Q1_8288"] = "Il ne peut y en avoir qu'un"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8288
Lang["Q2_8288"] = "Rapportez la Tête du seigneur des couvées Lanistaire à Baristolth des Sables changeants, au Fort cénarien en Silithus."
Lang["Q1_8301"] = "Le Chemin des Justes"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8301
Lang["Q2_8301"] = "Récupérez 200 Fragments de carapaces de silithides et retournez voir Baristolth."
Lang["Q1_8303"] = "Anachronos"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8303
Lang["Q2_8303"] = "Chercher Anachronos dans les Grottes du temps à Tanaris."
Lang["Q1_8305"] = "Des souvenirs oubliés depuis longtemps"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8305
Lang["Q2_8305"] = "Trouvez la Larme cristalline, en Silithus, et contemplez ses profondeurs."
Lang["Q1_8519"] = "Un pion sur l'Echiquier éternel"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8519
Lang["Q2_8519"] = "Apprenez tout ce que vous pouvez au sujet du passé, puis parlez à Anachronos dans les Grottes du temps à Tanaris."
Lang["Q1_8555"] = "Le fardeau des Vols draconiques"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8555
Lang["Q2_8555"] = "Eranikus, Vaelastrasz, et Azuregos... Vous avez certainement entendu parler de ces dragons, mortel. Ce n’est pas une simple coïncidence si chacun d’eux a joué un grand rôle comme gardien de ce monde.\n\nMalheureusement, et ma propre naïveté en est en partie responsable, ces gardiens ont tous succombé à de terribles tragédies, si terribles qu’elles ont alimenté ma méfiance à l’égard de votre espèce.\n\nCherchez-les… Et préparez-vous au pire"
Lang["Q1_8730"] = "La corruption de Nefarius"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8730
Lang["Q2_8730"] = "Tuez Nefarian pour récupérer le Fragment de sceptre rouge. Rapportez le Fragment de sceptre rouge à Anachronos aux Grottes du temps en Tanaris. Vous avez 5 heures pour accomplir cette tâche."
Lang["Q1_8733"] = "Eranikus, le tyran du Rêve"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8733
Lang["Q2_8733"] = "Rendez-vous sur Teldrassil et trouvez l’agent de Malfurion à l’extérieur des remparts de Darnassus."
Lang["Q1_8734"] = "Tyrande et Remulos"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8734
Lang["Q2_8734"] = "Rendez-vous à Reflet-de-Lune et parlez au gardien Remulos."
Lang["Q1_8735"] = "La corruption du Cauchemar"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8735
Lang["Q2_8735"] = "Rendez-vous aux quatre portails qui ouvrent sur le Rêve d’Emeraude et récupérez un Fragment de la corruption du Cauchemar auprès de chacun d’eux. Lorsque vous aurez terminé, retournez voir le Gardien Remulos à Reflet-de-Lune."
Lang["Q1_8736"] = "Le Cauchemar se manifeste"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8736
Lang["Q2_8736"] = "Défendre Havrenuit d’Eranikus. Le Gardien Remulos ne doit pas mourir. Eranikus non plus. Défendez-vous. Attendez Tyrande."
Lang["Q1_8741"] = "Le retour du champion"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8741
Lang["Q2_8741"] = "Apporter le Fragment de sceptre vert à Anachronos dans les Grottes du Temps de Tanaris."
Lang["Q1_8575"] = "Le grand livre magique d'Azuregos"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8575
Lang["Q2_8575"] = "Apporter le Grand livre magique d'Azuregos à Narain Soothfancy, en Tanaris."
Lang["Q1_8576"] = "La traduction du grand livre"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8576
Lang["Q2_8576"] = "Tout d'abord nous devons comprendre ce qu'Azuregos a écrit dans son livre.\n\nIl vous a dit de faire une Bouée en arcanite dont voici les plans? Etrange que tout soit écrit en draconique. Je n'y comprends rien.\n\nPour que ca marche il va me falloir mes lunettes de divination, un poulet de 500 livres et le volume II de 'Le draconique pour les nuls'. Pas forcément dans cet ordre."
Lang["Q1_8597"] = "Le draconique pour les nuls"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8597
Lang["Q2_8597"] = "Retrouver le livre de Narain Divinambolesque, enfoui sur une île des mers du Sud."
Lang["Q1_8599"] = "Une chanson d'amour pour Narain"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8599
Lang["Q2_8599"] = "Transmettre la Lettre d’amour de Meredith à Narain Divinambolesque, en Tanaris."
Lang["Q1_8598"] = "rANçOn !"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8598
Lang["Q2_8598"] = "Ramener la Demande de rançon a Narain Divinambolesque, en Tanaris."
Lang["Q1_8606"] = "Un leurre !"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8606
Lang["Q2_8606"] = "Narain Divinambolesque, en Tanaris, veut que vous vous rendiez au Berceau-de-l’hiver et que vous posiez le Sac d'or à l’endroit indiqué par les voleurs de livres."
Lang["Q1_8620"] = "Le seul remède"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8620
Lang["Q2_8620"] = "Retrouver les 8 chapitres perdus du 'Draconique pour les nuls' et les combiner avec la Reliure magique, puis ramener l’exemplaire réparé du 'Draconique pour les nuls, volume II' à Narain Divinambolesque, en Tanaris."
Lang["Q1_8584"] = "On ne parle jamais de mon boulot"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8584
Lang["Q2_8584"] = "Narain Divinambolesque de Tanaris veut que vous parliez à Dirge Hachillico à Gadgetzan."
Lang["Q1_8585"] = "L'île de l'effroi !"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8585
Lang["Q2_8585"] = "Récupérer la Carcasse de Lakmaeran et 20 Filets de chimaerok pour Dirge Hachillico, en Tanaris."
Lang["Q1_8586"] = "Pyro-côtelettes de chimaerok à la Dirge"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8586
Lang["Q2_8586"] = "Dirge Hachillico, de Gadgetzan, veut que vous lui rameniez 20 doses de Carburant de fusée gobelin et 20 doses de Sel de Fonderoc."
Lang["Q1_8587"] = "Retour vers Narain"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8587
Lang["Q2_8587"] = "Remettre le Poulet de 500 livres à Narain Divinambolesque à Tanaris."
Lang["Q1_8577"] = "Stewvul, ex-M.A.P.V."			-- https://www.thegeekcrusade-serveur.com/db/?quest=8577
Lang["Q2_8577"] = "Narain Divinambolesque veut que vous retrouviez son ex-meilleur ami pour la vie (M.A.P.V.), Stewvul, et que vous repreniez les lunettes de divination que Stewvul lui a volé."
Lang["Q1_8578"] = "Des lunettes d'observation ? Aucun problème !"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8578
Lang["Q2_8578"] = "Retrouver les Lunettes de divination de Narain et les rapporter à Narain Divinambolesque en Tanaris."
Lang["Q1_8728"] = "La bonne nouvelle et la mauvaise nouvelle"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8728
Lang["Q2_8728"] = "Narain Divinambolesque, en Tanaris, veut que vous lui apportiez 20 Barres d’arcanite, 10 Minerais d’élémentium, 10 Diamants d’Azeorth et 10 Saphirs bleus"
Lang["Q1_8729"] = "Le courroux de Neptulon"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8729
Lang["Q2_8729"] = "Utilisez la Bouée d’arcanite au Maelström tourbillonnant dans la Baie des tempêtes en Azshara."
Lang["Q1_8742"] = "La puissance de Kalimdor"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8742
Lang["Q2_8742"] = "Devant moi se tient la personne qui va guider son peuple vers une nouvelle ère.\n\nL'Ancien Dieu tremble. Oh oui, il a peur de votre foi. Brisez la prophecie de C'Thun.\n\nIl sait que vous venez, champion - et avec vous toute la puissance de Kalimdor. Dites moi quand vous etes pret et je vous donnerai le Sceptre des Sables changeants."
Lang["Q1_8745"] = "Le trésor de l'Intemporel"			-- https://www.thegeekcrusade-serveur.com/db/?quest=8745
Lang["Q2_8745"] = "Bienvenu, champion. Je suis Jonathan, guardien du gong sacré.\n\nL'Intemporel m'a donné le pouvoir de vous récompenser avec un objet de son trésor eternel. Qu'il vous aide dans votre lutte contre C'Thun."


-- QUESTS - TBC
Lang["Q1_10755"] = "L'entrée dans la citadelle"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10755
Lang["Q2_10755"] = "Apportez le Moule à clé préparé à Nazgrel, à Thrallmar dans la péninsule des Flammes infernales."
Lang["Q1_10756"] = "Le grand maître Rohok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10756
Lang["Q2_10756"] = "Apportez le Moule à clé préparé à Rohok à Thrallmar."
Lang["Q1_10757"] = "La demande de Rohok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10757
Lang["Q2_10757"] = "Apportez 4 Barres de gangrefer, 2 Poussières des arcanes et 4 Granules de feu à Rohok à Thrallmar dans la péninsule des Flammes infernales."
Lang["Q1_10758"] = "Plus chaud que l'enfer"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10758
Lang["Q2_10758"] = "Détruisez un Saccageur gangrené dans la péninsule des Flammes infernales et plongez le Moule à clé inachevé dans ce qu'il en reste. Apportez le Moule à clé carbonisé à Rohok à Thrallmar."
Lang["Q1_10754"] = "L'entrée dans la citadelle"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10754
Lang["Q2_10754"] = "Apportez le Moule à clé préparé au commandant de corps Danath au bastion de l'Honneur dans la péninsule des Flammes infernales."
Lang["Q1_10762"] = "Le grand maître Dumphry"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10762
Lang["Q2_10762"] = "Apportez le Moule à clé préparé à Dumphry au bastion de l'Honneur."
Lang["Q1_10763"] = "La demande de Dumphry"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10763
Lang["Q2_10763"] = "Apportez 4 Barres de gangrefer, 2 Poussières des arcanes et 4 Granules de feu à Dumphry au bastion de l'Honneur dans la péninsule des Flammes infernales."
Lang["Q1_10764"] = "Plus chaud que l'enfer"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10764
Lang["Q2_10764"] = "Détruisez un Saccageur gangrené dans la péninsule des Flammes infernales et plongez le Moule à clé inachevé dans ce qu'il en reste. Apportez le Moule à clé carbonisé à Dumphry au bastion de l'Honneur."
Lang["Q1_10279"] = "Dans le repaire du maîtrer"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10279
Lang["Q2_10279"] = "Parlez à Andormu dans les Grottes du temps."
Lang["Q1_10277"] = "Les Grottes du temps"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10277
Lang["Q2_10277"] = "Andormu vous demande de suivre la Protectrice du temps dans les Grottes du temps."
Lang["Q1_10282"] = "Hautebrande d'antan"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10282
Lang["Q2_10282"] = "Andormu des Grottes du temps vous demande de vous aventurer dans le Hautebrande d'antan et d'aller voir Erozion."
Lang["Q1_10283"] = "La diversion de Taretha"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10283
Lang["Q2_10283"] = "Rendez-vous au bastion de Fort-de-Durn et placez 5 charges incendiaires dans les tonneaux situés dans chacun des pavillons d'internement grâce au Paquet de bombes incendiaires qui vous a été donné par Erozion.\n\nParlez à Thrall dans les oubliettes du bastion de Fort-de-Durn une fois les Pavillons d'internement incendiés."
Lang["Q1_10284"] = "Évasion de Fort-de-Durn"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10284
Lang["Q2_10284"] = "Faites signe à Thrall lorsque vous serez <prêt/prête> à continuer. Suivez-le dans son évasion du bastion de Fort-de-Durn et aidez-le à libérer Taretha et à accomplir son destin.\n\nAllez parler à Erozion au Hautebrande d'antan si vous parvenez à accomplir cette tâche."
Lang["Q1_10285"] = "Retour vers Andormu"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10285
Lang["Q2_10285"] = "Retournez voir le jeune dragon, Andormu, aux Grottes du temps dans le désert de Tanaris."
Lang["Q1_10205"] = "L'écumeur-dimensionnel Nesaad"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10205
Lang["Q2_10205"] = "Tuez l'Écumeur-dimensionnel Nesaad, puis retournez voir le traqueur-du-Néant Khay'ji dans la Zone 52 de Raz-de-Néant."
Lang["Q1_10266"] = "Demande d'assistance"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10266
Lang["Q2_10266"] = "Trouvez Gahruj et proposez-lui vos services. Il se trouve au comptoir des Terres-médianes dans l'Écodôme Terres-médianes au Raz-de-Néant."
Lang["Q1_10267"] = "Récupérer ce qui nous revient de droit"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10267
Lang["Q2_10267"] = "Récupérez 10 Boîtes d'équipement topographique et rapportez-les à Gahruj au comptoir des Terres-médianes dans l'Écodôme Terres-médianes au Raz-de-Néant."
Lang["Q1_10268"] = "Une audience avec le prince"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10268
Lang["Q2_10268"] = "Remettez l'Équipement topographique à l'image du prince-nexus Haramad à la Foudreflèche au Raz-de-Néant."
Lang["Q1_10269"] = "Point de triangulation numéro un"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10269
Lang["Q2_10269"] = "Utilisez l'Appareil de triangulation pour vous indiquer la direction du premier point de triangulation. Une fois que vous l'aurez trouvé, donnez-en l'emplacement au camelot Hazzin au poste de garde du Protectorat dans l'île de la manaforge Ultris au Raz-de-Néant."
Lang["Q1_10275"] = "Point de triangulation numéro deux"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10275
Lang["Q2_10275"] = "Utilisez l'Appareil de triangulation pour vous indiquer la direction du deuxième point de triangulation. Une fois que vous l'aurez trouvé, donnez-en l'emplacement au marchand des vents Tuluman au Point d'ancrage de Tuluman, juste de l'autre côté du pont vers l'île de la manaforge Ara au Raz-de-Néant."
Lang["Q1_10276"] = "Le triangle est triangulé"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10276
Lang["Q2_10276"] = "Récupérez le Cristal d'Ata'mal et rapportez-le à l'image du prince-nexus Haramad à la Foudreflèche au Raz-de-Néant."
Lang["Q1_10280"] = "Livraison spéciale à Shattrath"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10280
Lang["Q2_10280"] = "Apportez le cristal d'Ata'mal à A'dal sur la Terrasse de la Lumière à Shattrath."
Lang["Q1_10704"] = "Comment pénétrer dans l'Arcatraz"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10704
Lang["Q2_10704"] = "A'dal vous a <chargé/chargée> de récupérer les Pièces supérieures et inférieures de la clé de l'Arcatraz. Rapportez-les-lui et il s'en servira pour vous confectionner la Clé de l'Arcatraz."
Lang["Q1_9824"] = "Troubles arcaniques"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9824
Lang["Q2_9824"] = "Vous avez été <chargé/chargée> d'aller sur le satellite d'Arcatraz du donjon de la Tempête et de tuer le Messager Cieuriss. Revenez voir A'dal à la Terrasse de la Lumière de Shattrath quand ce sera fait."
Lang["Q1_9825"] = "L’agitation des sans-repos"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9825
Lang["Q2_9825"] = "Apportez 10 Essences fantomatiques à l’Archimage Alturus, à l’extérieur de Karazhan."
Lang["Q1_9826"] = "Un envoyé de Dalaran"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9826
Lang["Q2_9826"] = "Apportez le Rapport d’Alturus à l’Archimage Cédric, à la périphérie du Cratère de Dalaran."
Lang["Q1_9829"] = "Khadgar"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9829
Lang["Q2_9829"] = "Remettez le Rapport d’Alturus à Khadgar, à Shattrath dans la forêt de Terokkar."
Lang["Q1_9831"] = "L'entrée de Karazhan	"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9831
Lang["Q2_9831"] = "Khadgar veut que vous entriez dans le Labyrinthe des ombres d'Auchindoun pour récupérer le Premier fragment de la clé, dans le Récipient arcanique qui y est caché."
Lang["Q1_9832"] = "Le deuxième et le troisième fragments"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9832
Lang["Q2_9832"] = "Trouver le Deuxième fragment de la clé dans un récipient arcanique à l’intérieur du Réservoir de Glissecroc, et le Troisième fragment de la clé dans un récipient arcanique au Donjon de la tempête. Une fois que ce sera fait, revenir auprès de Khadgar à Shattrath."
Lang["Q1_9836"] = "Le toucher du maître"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9836
Lang["Q2_9836"] = "Rendez-vous aux Grottes du temps et persuadez Medivh d’accepter votre Clé de l’apprenti réparée."
Lang["Q1_9837"] = "Retour vers Khadgar"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9837
Lang["Q2_9837"] = "Retournez voir Khadgar à Shattrath, et montrez-lui à la Clé du maître."
Lang["Q1_9630"] = "Le journal de Medivh"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9630
Lang["Q2_9630"] = "L’archimage Alturus, du défilé de Deuillevent, veut que vous entriez dans Karazhan et que vous parliez à Wravien."
Lang["Q1_9638"] = "En de bonnes mains"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9638
Lang["Q2_9638"] = "Parler avec Gradav dans la Bibliothèque du gardien, à Karazhan."
Lang["Q1_9639"] = "Kamsis"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9639
Lang["Q2_9639"] = "Parler avec Kamsis dans la Bibliothèque du gardien, à Karazhan."
Lang["Q1_9640"] = "L'ombre d'Aran"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9640
Lang["Q2_9640"] = "Obtenez le Journal de Medivh et retournez voir Kamsis dans la Bibliothèque du Gardien de Karazhan."
Lang["Q1_9645"] = "La terrasse du Maître"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9645
Lang["Q2_9645"] = "Allez sur la terrasse du Maître à Karazhan et lisez le Journal de Medivh. Retournez auprès de l'archimage Alturus avec le Journal de Medivh lorsque vous aurez accompli cette tâche."
Lang["Q1_9680"] = "Exhumer le passé"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9680
Lang["Q2_9680"] = "L'archimage Alturus veut que vous vous rendiez dans les montagnes au sud de Karazhan dans le défilé de Deuillevent et que vous y récupériez un Fragment d'os carbonisé."
Lang["Q1_9631"] = "L'aide d'une collègue"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9631
Lang["Q2_9631"] = "Remettez le Fragment d'os carbonisé à Kalynna Rougelatte, dans la Zone 52 de Raz-de-Néant."
Lang["Q1_9637"] = "La requête de Kalynna"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9637
Lang["Q2_9637"] = "Kalynna Rougelatte veut que vous récupériez le Tome du crépuscule sur le Grand démoniste Néanathème dans la citadelle des Flammes infernales, et le Livre des noms oubliés sur le Tisseur d'ombre Syth dans les salles des Sethekk à Auchindoun."
Lang["Q1_9644"] = "Plaie-de-nuit"			-- https://www.thegeekcrusade-serveur.com/db/?quest=9644
Lang["Q2_9644"] = "Allez sur la Terrasse du Maître à Karazhan et utilisez l'Urne de Kalynna pour invoquer Plaie-de-nuit. Récupérez l'Essence arcanique voilée sur le cadavre de Plaie-de-nuit et rapportez-la à l'archimage Alturus."
Lang["Q1_10901"] = "Le gourdin de Kar'desh"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10901
Lang["Q2_10901"] = "Skar’this l’Hérétique, dans les Enclos aux esclaves héroïques du Réservoir de Glissecroc, veut que vous lui apportiez la Chevalière terrestre et la Chevalière flamboyante."
Lang["Q1_10900"] = "La marque de Vashj"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10900
Lang["Q2_10900"] = ""
Lang["Q1_10681"] = "La main de Gul'dan"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10681
Lang["Q2_10681"] = "Parlez au soigneterre Torlok à l'Autel de la damnation dans la vallée d'Ombrelune."
Lang["Q1_10458"] = "Esprits de feu et de terre enragés"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10458
Lang["Q2_10458"] = "Le soigneterre Torlok à l'Autel de la damnation dans la vallée d'Ombrelune veut que vous utilisiez le Totem des esprits pour capturer 8 Âmes terrestres et 8 Âmes flamboyantes."
Lang["Q1_10480"] = "Esprits des eaux enragés"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10480
Lang["Q2_10480"] = "Le soigneterre Torlok à l'Autel de la damnation dans la vallée d'Ombrelune veut que vous utilisiez le Totem des esprits pour capturer 5 Âmes aquatiques."
Lang["Q1_10481"] = "Esprits des airs enragés"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10481
Lang["Q2_10481"] = "Le soigneterre Torlok à l'Autel de la damnation dans la vallée d'Ombrelune veut que vous utilisiez le Totem des esprits pour capturer 10 Âmes aériennes."
Lang["Q1_10513"] = "Oronok Cœur-fendu"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10513
Lang["Q2_10513"] = "Partez à la recherche d’Oronok Cœur-fendu sur la Saillie brisée, au nord de la Citerne de Glissentaille."
Lang["Q1_10514"] = "J'ai tenu bien des rôles…"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10514
Lang["Q2_10514"] = "Oronok Cœur-fendu, à la Ferme d'Oronok dans la vallée d'Ombrelune, veut que vous ramassiez 10 Tubercules d'Ombrelune dans les Plaines brisées.\n\nIl vous demande aussi de rapporter le Sifflet à sanglier d'Oronok lorsque vous aurez terminé."
Lang["Q1_10515"] = "Une leçon bien apprise"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10515
Lang["Q2_10515"] = "Oronok Cœur-fendu, à la Ferme d'Oronok dans la vallée d'Ombrelune, veut que vous détruisiez 10 Œufs d'écorcheurs voraces dans les Plaines brisées."
Lang["Q1_10519"] = "La Formule de damnation - vérité et histoire"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10519
Lang["Q2_10519"] = "Oronok Cœur-fendu à la ferme d'Oronok dans la vallée d'Ombrelune veut que vous écoutiez son histoire. Parlez à Oronok pour commencer à écouter son histoire."
Lang["Q1_10521"] = "Grom'tor, fils d'Oronok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10521
Lang["Q2_10521"] = "Trouvez Grom'tor, fils d'Oronok à la Halte de Glissentaille dans la vallée d'Ombrelune."
Lang["Q1_10527"] = "Ar'tor, fils d'Oronok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10527
Lang["Q2_10527"] = "Trouvez Ar'tor, fils d'Oronok à la Halte Illidari dans la vallée d'Ombrelune."
Lang["Q1_10546"] = "Borak, fils d'Oronok"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10546
Lang["Q2_10546"] = "Trouvez Borak, fils d'Oronok près de la Halte de l'éclipse dans la vallée d'Ombrelune."
Lang["Q1_10522"] = "La Formule de damnation - la charge de Grom'tor"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10522
Lang["Q2_10522"] = "Grom'tor, fils d'Oronok, de la Halte de Glissentaille dans la vallée d'Ombrelune, veut que vous récupériez le Premier fragment de la Formule de damnation."
Lang["Q1_10528"] = "Prisons de cristal démoniaque"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10528
Lang["Q2_10528"] = "Trouvez la Maîtresse de la douleur Gabrissa à la Halte Illidari et tuez-la, puis rapportez le cadavre d'Ar'tor, fils d'Oronok avec la Clé cristalline."
Lang["Q1_10547"] = "Des chardonomanes et des œufs"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10547
Lang["Q2_10547"] = "Borak, fils d'Oronok, sur le pont au nord de la Halte de l'éclipse, veut que vous trouviez un Œuf d'arakkoa pourri et que vous l'apportiez à Tobias le Goinfre-crasse à Shattrath, qui se trouve au nord-ouest de la forêt de Terokkar."
Lang["Q1_10523"] = "La Formule de damnation - Premier fragment retrouvé"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10523
Lang["Q2_10523"] = "Apportez le coffret de Grom'tor à Oronok Cœur-fendu à la Ferme d'Oronok dans la vallée d'Ombrelune."
Lang["Q1_10537"] = "Lohn'goron, arc du Cœur-fendu"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10537
Lang["Q2_10537"] = "L'Esprit d'Ar'tor à la Halte Illidari dans la vallée d'Ombrelune veut que vous repreniez Lohn'goron, arc du Cœur-fendu aux démons de la région."
Lang["Q1_10550"] = "Le fagot de chardons sanglants"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10550
Lang["Q2_10550"] = "Rapportez le Fagot de chardons sanglants à Borak, fils d'Oronok sur le pont près de la Halte de l'éclipse dans la vallée d'Ombrelune."
Lang["Q1_10540"] = "La Formule de damnation - la charge d'Ar'tor"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10540
Lang["Q2_10540"] = "L'Esprit d'Ar'tor à la Halte Illidari dans la vallée d'Ombrelune veut que vous récupériez le Second fragment de la formule de damnation sur Veneratus le Multiple."
Lang["Q1_10570"] = "Pour une poignée de chardons"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10570
Lang["Q2_10570"] = "Borak, fils d'Oronok, du pont qui se trouve près de la halte de l'Éclipse dans la vallée d'Ombrelune, vous demande de récupérer la Missive de Hurlorage."
Lang["Q1_10576"] = "Le bonneteau d'Ombrelune"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10576
Lang["Q2_10576"] = "Borak, fils d'Oronok, du pont qui se trouve près de la halte de l'Éclipse dans la vallée d'Ombrelune, vous demande de récupérer 6 pièces d'Armure éclipsion."
Lang["Q1_10577"] = "Ce qu'Illidan veut, Illidan l'obtient…"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10577
Lang["Q2_10577"] = "Borak, fils d'Oronok, du pont qui se trouve près de la halte de l'Éclipse dans la vallée d'Ombrelune, vous demande de remettre le message d'Illidan au grand commandant Ruusk à la halte de l'Éclipse."
Lang["Q1_10578"] = "La Formule de damnation - la charge de Borak"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10578
Lang["Q2_10578"] = "Borak, fils d'Oronok, du pont qui se trouve près de la halte de l'Éclipse dans la vallée d'Ombrelune, vous demande de prendre la Troisième partie de la formule de damnation à Ruul l'Assombrisseur."
Lang["Q1_10541"] = "La Formule de damnation - Second fragment retrouvé"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10541
Lang["Q2_10541"] = "Apportez le Coffret d'Ar'tor à Oronok Cœur-fendu à la Ferme d'Oronok dans la vallée d'Ombrelune."
Lang["Q1_10579"] = "La Formule de damnation - Troisième fragment retrouvé"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10579
Lang["Q2_10579"] = "Apportez le coffret de Borak à Oronok Cœur-fendu à la Ferme d'Oronok dans la vallée d'Ombrelune."
Lang["Q1_10588"] = "La Formule de damnation"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10588
Lang["Q2_10588"] = "Utilisez la Formule de damnation à l'Autel de la damnation pour invoquer Cyrukh le Seigneur du feu.\n\nDétruisez Cyrukh le Seigneur du feu puis parlez au Soigneterre Torlok, qui se trouve aussi à l'Autel de la damnation."
Lang["Q1_10883"] = "La clé de la Tempête"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10883
Lang["Q2_10883"] = "Parlez à A'dal à Shattrath."
Lang["Q1_10884"] = "L'épreuve des naaru : Miséricorde"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10884
Lang["Q2_10884"] = "A'dal de Shattrath vous demande de prendre la Hache inutilisée du bourreau dans les Salles Brisées de la citadelle des Flammes infernales.\n\nCette quête doit être accomplie en mode de difficulté du donjon Héroïque."
Lang["Q1_10885"] = "L'épreuve des naaru : Force"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10885
Lang["Q2_10885"] = "A'dal de Shattrath vous demande de récupérer le Trident de Kalithresh et l'Essence de Marmon.\n\nCette quête doit être accomplie en mode de difficulté du donjon Héroïque."
Lang["Q1_10886"] = "L'épreuve des naaru : Ténacité"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10886
Lang["Q2_10886"] = "A'dal de Shattrath vous demande de sauver Milhouse Tempête-de-mana de l'Arcatraz du donjon de la Tempête.\n\nCette quête doit être accomplie en mode de difficulté du donjon Héroïque."
Lang["Q1_10888"] = "L'épreuve des naaru : Magtheridon"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10888
Lang["Q2_10888"] = "A'dal de Shattrath vous demande de tuer Magtheridon."
Lang["Q1_10680"] = "La main de Gul'dan"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10680
Lang["Q2_10680"] = "Parlez au soigneterre Torlok à l'Autel de la damnation dans la vallée d'Ombrelune."
Lang["Q1_10445"] = "Les fioles d'éternité"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10445
Lang["Q2_10445"] = "Soridormi aux Grottes du temps vous demande de récupérer le Reste de la fiole de Vashj auprès de Dame Vashj au réservoir de Glissecroc et le Reste de la fiole de Kael auprès de Kael'thas Haut-soleil au donjon de la Tempête."
Lang["Q1_10568"] = "Tablettes de Baa'ri"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10568
Lang["Q2_10568"] = "L'anachorète Ceyla de l'Autel de Sha'tar veut que vous collectiez 12 Tablettes baa'ri sur le sol et sur les Ouvriers cendrelangue aux Ruines de Baa'ri.\n\nAccomplir des quêtes pour l'Aldor fera baisser votre réputation auprès des Clairvoyants."
Lang["Q1_10683"] = "Tablettes de Baa'ri"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10683
Lang["Q2_10683"] = "L'arcaniste Thelis du Sanctum des Étoiles veut que vous collectiez 12 Tablettes baa'ri aux Ruines de Baa'ri.\n\nAccomplir des quêtes pour les Clairvoyants fera baisser votre réputation auprès de l'Aldor."
Lang["Q1_10571"] = "Oronu l'Ancien"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10571
Lang["Q2_10571"] = "L'anachorète Ceyla de l'Autel de Sha'tar veut que vous vous procuriez les Ordres d'Akama sur Oronu l'Ancien aux Ruines de Baa'ri.\n\nAccomplir des quêtes pour l'Aldor fera baisser votre réputation auprès des Clairvoyants."
Lang["Q1_10684"] = "Oronu l'Ancien"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10684
Lang["Q2_10684"] = "L'arcaniste Thelis du Sanctum des Étoiles veut que vous preniez les Ordres d'Akama à Oronu l'Ancien aux Ruines de Baa'ri.\n\nAccomplir des quêtes pour les Clairvoyants fera baisser votre réputation auprès de l'Aldor."
Lang["Q1_10574"] = "Les corrupteurs cendrelangue"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10574
Lang["Q2_10574"] = "Procurez-vous les quatre fragments du médaillon sur Haalum, Eykenen, Lakaan et Uylaru et rapportez-les à l'anachorète Ceyla à l'Autel de Sha'tar dans la vallée d'Ombrelune.\n\nAccomplir des quêtes pour l'Aldor fera baisser votre réputation auprès des Clairvoyants."
Lang["Q1_10685"] = "Les corrupteurs cendrelangue"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10685
Lang["Q2_10685"] = "Procurez-vous les quatre fragments du médaillon sur Haalum, Eykenen, Lakaan et Uylaru et rapportez-les à l'arcaniste Thelis au Sanctum des Étoiles dans la vallée d'Ombrelune.\n\nAccomplir des quêtes pour les Clairvoyants fera baisser votre réputation auprès de l'Aldor."
Lang["Q1_10575"] = "La Cage de la gardienne"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10575
Lang["Q2_10575"] = "L'anachorète Ceyla veut que vous entriez dans la Cage de la gardienne, au sud des ruines de Baa'ri, et que vous interrogiez Sanoru pour apprendre où se trouve Akama.\n\nAccomplir des quêtes pour l'Aldor fera baisser votre réputation auprès des Clairvoyants."
Lang["Q1_10686"] = "La Cage de la gardienne"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10686
Lang["Q2_10686"] = "L'arcaniste Thelis veut que vous entriez dans la Cage de la gardienne, au sud des ruines de Baa'ri, et que vous interrogiez Sanoru pour apprendre où se trouve Akama.\n\nAccomplir des quêtes pour les Clairvoyants fera baisser votre réputation auprès de l'Aldor."
Lang["Q1_10622"] = "Preuve d'allégeance"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10622
Lang["Q2_10622"] = "Tuez Zandras à la Cage de la gardienne dans la vallée d'Ombrelune et retournez voir Sanoru."
Lang["Q1_10628"] = "Akama"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10628
Lang["Q2_10628"] = "Parler à Akama à l'intérieur de la chambre cachée de la Cage de la gardienne."
Lang["Q1_10705"] = "Le voyant Udalo"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10705
Lang["Q2_10705"] = "Trouvez le voyant Udalo à l'intérieur de l'Arcatraz dans le Donjon de la Tempête."
Lang["Q1_10706"] = "Un mystérieux présage"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10706
Lang["Q2_10706"] = "Retournez voir Akama à la Cage de la gardienne dans la vallée d'Ombrelune."
Lang["Q1_10707"] = "La terrasse ata'mal"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10707
Lang["Q2_10707"] = "Allez au sommet de la Terrasse Ata'mal dans la vallée d’Ombrelune, et procurez-vous le Cœur de fureur. Retournez voir Akama à la Cage de la gardienne dans la vallée d'Ombrelune quand vous aurez accompli cette tâche."
Lang["Q1_10708"] = "La promesse d'Akama"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10708
Lang["Q2_10708"] = "Apportez le Médaillon de Karabor à A'dal, à Shattrath."
Lang["Q1_10944"] = "Un secret compromis"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10944
Lang["Q2_10944"] = "Allez à la Cage de la gardienne dans la vallée d'Ombrelune et parlez avec Akama."
Lang["Q1_10946"] = "La ruse des Cendrelangues"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10946
Lang["Q2_10946"] = "Pénétrez dans le Donjon de la Tempête et tuez Al'ar en portant la Capuche de cendrelangue. Retournez voir Akama dans la vallée d'Ombrelune une fois que ce sera fait."
Lang["Q1_10947"] = "Un artefact du passé"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10947
Lang["Q2_10947"] = "Allez aux Grottes du temps en Tanaris, et rendez-vous à la Bataille du mont Hyjal. Quand vous y serez, triomphez de Rage Froidhiver et rapportez le Phylactère chronophasé à Akama dans la vallée d'Ombrelune."
Lang["Q1_10948"] = "L'âme otage"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10948
Lang["Q2_10948"] = "Rendez-vous à Shattrath pour soumettre la requête d'Akama à A'dal."
Lang["Q1_10949"] = "L'entrée dans le Temple Noir"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10949
Lang["Q2_10949"] = "Rendez-vous à l'entrée du Temple Noir dans la vallée d'Ombrelune et allez parler à Xi'ri."
Lang["Q1_10985"] = "Une distraction pour Akama"			-- https://www.thegeekcrusade-serveur.com/db/?quest=10985
Lang["Q2_10985"] = "Assurez-vous qu'Akama et Maiev pénètrent bien dans le Temple Noir de la Vallée d'Ombrelune une fois que les forces de Xi'ri auront fait diversion."
	

-- NPC
Lang["N1_9196"] = "Généralissime Omokk"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9196
Lang["N2_9196"] = "Omokk est le premier boss au Bas de Pic Rochenoire."
Lang["N1_9237"] = "Maître de guerre Voone"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9237
Lang["N2_9237"] = "Voone est un boss a l'interieur du Bas de Pic Rochenoire."
Lang["N1_9568"] = "Seigneur Wyrmthalak"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9568
Lang["N2_9568"] = "Seigneur Wyrmthalak est le dernier boss du Bas du Pic de Rochenoire."
Lang["N1_10429"] = "Chef de guerre Rend Main-noire"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10429
Lang["N2_10429"] = "Rend Main-noire est le 6ème boss au Sommet du Pic Rochenoire. Dal'rend, communement appelé Rend, est le chef de la Horde noire."
Lang["N1_10182"] = "Rexxar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10182
Lang["N2_10182"] = "<Champion de la Horde>\n\nSe promène du sud de Serres-Rocheuses jusqu'au nord de Féralas."
Lang["N1_8197"] = "Chronalis"	-- https://www.thegeekcrusade-serveur.com/db/?npc=8197
Lang["N2_8197"] = "Chronalis du Vol de Bronze.\n\nSe trouve a l'entrée des Grottes du Temps."
Lang["N1_10664"] = "Clairvoyant"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10664
Lang["N2_10664"] = "Clairvoyant du Vol Bleu.\n\nSe trouve dans les profondeurs de la grotte de Mazthoril."
Lang["N1_12900"] = "Somnus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12900
Lang["N2_12900"] = "Somnus du Vol Vert.\n\nSe trouve du coté Est du Temple Englouti."
Lang["N1_12899"] = "Axtroz"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12899
Lang["N2_12899"] = "Axtroz du Vol Rouge.\n\nSe trouve dans Grim Batol, Les Paluns."
Lang["N1_10363"] = "Général Drakkisath"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10363
Lang["N2_10363"] = "Le Général Drakkisath est le dernier boss du Sommet du Pic Rochenoire."
Lang["N1_8983"] = "Seigneur golem Argelmach"	-- https://www.thegeekcrusade-serveur.com/db/?npc=8983
Lang["N2_8983"] = "Seigneur golem Argelmach est le 9ème boss des Profondeurs de Rochenoire."
Lang["N1_9033"] = "Général Forgehargne"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9033
Lang["N2_9033"] = "Le Général Forgehargne est le 7ème boss des Profondeurs de Rochenoire."
Lang["N1_17804"] = "Ecuyer Rowe"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17804
Lang["N2_17804"] = "L'écuyer se trouve au portes de Hurlevent."
Lang["N1_10929"] = "Haleh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10929
Lang["N2_10929"] = "Haleh est toute seule au somment de la cave Mazthoril, à l'exterieur.\nOn peut l'atteindre via la rune bleue sur le sol à l'interieur de la cave."
Lang["N1_9046"] = "Intendant du Bouclier balafré"	-- https://www.thegeekcrusade-serveur.com/db/?npc=9046
Lang["N2_9046"] = "Il est en dehors de l'instance, dans une petite alcove près de l'entrée balcon du Pic Rochenoire"
Lang["N1_15180"] = "Baristolth des Sables changeants"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15180
Lang["N2_15180"] = "Baristolth se trouve au Fort cénarien, près du Puits de lune (49.6,36.6)."
Lang["N1_12017"] = "Seigneur des couvées Lanistaire"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12017
Lang["N2_12017"] = "Le Seigneur des couvées Lanistaire est le 3ème boss du Repaire de l'Aile Noire."
Lang["N1_13020"] = "Vaelastrasz le Corrompu"	-- https://www.thegeekcrusade-serveur.com/db/?npc=13020
Lang["N2_13020"] = "Vaelastrasz le Corrumpu est le 2ème boss du Repaire de l'Aile Noire."
Lang["N1_11583"] = "Nefarian"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11583
Lang["N2_11583"] = "Nefarian est le 8ème et dernier boss du Repaire de l'Aile Noire."
Lang["N1_15362"] = "Malfurion Hurlorage"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15362
Lang["N2_15362"] = "Malfurion peut être trouvé dans le Temple Englouti, et apparait quand on s'approche de l'Ombre d'Eranikus."
Lang["N1_15624"] = "Feu follet forestier"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15624
Lang["N2_15624"] = "Ce feu follet se trouve dans Teldrassil, proche des portes de Darnassus (37.6,48.0)."
Lang["N1_15481"] = "Esprit d'Azuregos"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15481
Lang["N2_15481"] = "L'Esprit d'Azuregos se promène dans la partie sud d'Azshara (vers 58.8,82.2). Il aime bien discuter."
Lang["N1_11811"] = "Narain Divinambolesque"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11811
Lang["N2_11811"] = "Se trouve dans une petite hutte juste au nord de Port Gentepression (65.2,18.4)."
Lang["N1_15526"] = "Meridith la Vierge de mer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15526
Lang["N2_15526"] = "Elll se promène sous l'eau dans la zone avant la grande crevasse (vers 59.6,95.6). Une fois sa quête completée, retournez la voir pour recevoir un buff de nage rapide."
Lang["N1_15554"] = "Numéro Deux"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15554
Lang["N2_15554"] = "Numéro Deux peut être appelé au sud de Berceau-de-l'Hiver, à un endroit particulier (67.2,72.6). Il peut prendre un peu de temps a apparaître."
Lang["N1_15552"] = "Docteur Dwenfer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15552
Lang["N2_15552"] = "Ce gnome se trouve dans une maison sur l'île d'Alcaz dans le Marécage d'Âprefange (77.8,17.6). Préparez-vous au choc!"
Lang["N1_10184"] = "Onyxia"	-- https://www.thegeekcrusade-serveur.com/db/?npc=10184
Lang["N2_10184"] = "Quand elle n'est pas une Dame a Hurlevent, Onyxia reste dans so repaire, au sud du Marécage d'Âprefange."
Lang["N1_11502"] = "Ragnaros"	-- https://www.thegeekcrusade-serveur.com/db/?npc=11502
Lang["N2_11502"] = "Ragnaros, Le Seigneur du Feu, est le 10ème et dernier boss du Coeur de Magma."
Lang["N1_12803"] = "Seigneur Lakmaeran"	-- https://www.thegeekcrusade-serveur.com/db/?npc=12803
Lang["N2_12803"] = "Se trouve sur l'île de l'Effroi (Féralas), juste un peu au nord de la zone aux chimères (29.8,72.6)."
Lang["N1_15571"] = "Crocs-de-la-mer"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15571
Lang["N2_15571"] = "duunnn dunnn... duuuunnnn duun... duuunnnnnnnn dun dun dun dun dun dun dun dun dun dun dunnnnnnnnnnn dunnnn dans Azshara (à 65.6,54.6)"
Lang["N1_22037"] = "Gorlunk le forgeron"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22037
Lang["N2_22037"] = "Il se trouve à la forge évidemment (67,36), du coté nord de l'entrée du Temple Noir"
Lang["N1_18733"] = "Saccageur gangrené"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18733
Lang["N2_18733"] = "Il a tendance a se promener du coté ouest de la Citadelle des Flammes infernales."
Lang["N1_18473"] = "Roi-serre Ikiss"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18473
Lang["N2_18473"] = "Le Roi-serre est le dernier boss des salles des Sethekk dans Auchindoun"
Lang["N1_20142"] = "Régisseur du temps"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20142
Lang["N2_20142"] = "Dragon du Vol de Bronze, près du sablier dans les Grottes du Temps."
Lang["N1_20130"] = "Andormu"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20130
Lang["N2_20130"] = "Ressemble à un petit garçon, près du sablier dans les Grottes du Temps."
Lang["N1_18096"] = "Chasseur d'époques"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18096
Lang["N2_18096"] = "Dernier boss de Hautebrande d'antan (Grottes du Temps), apparait dans Moulin-de-Tarren quand Thrall y arrive enfin."
Lang["N1_19880"] = "Traqueur-du-Néant Khay'ji"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19880
Lang["N2_19880"] = "Se trouve pres de la forge de la zone 52 (32,64)."
Lang["N1_19641"] = "Ecumeur-dimensionnel Nesaad"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19641
Lang["N2_19641"] = "Il se trouve a (28,79). il a deux potes avec lui."
Lang["N1_18481"] = "A'dal"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18481
Lang["N2_18481"] = "A'dal est en plein milieu de Shattrath. Un grand truc jaune qui brille. Difficile a rater."
Lang["N1_19220"] = "Pathaleon le Calculateur"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19220
Lang["N2_19220"] = "Pathaleon the Calculator est le dernier boss du Mechanar."
Lang["N1_17977"] = "Brise-dimension"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17977
Lang["N2_17977"] = "Warp Splinter est le 5eme boss de la Botanica. C'est un grand elementaire arbre."
Lang["N1_17613"] = "Archimage Alturus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17613
Lang["N2_17613"] = "L'archimage se trouve juste devant l'entrée de Karazhan."
Lang["N1_18708"] = "Marmon"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18708
Lang["N2_18708"] = "Marmon est le dernier boss du Labyrinthe des Ombres. C'est un large elementaire de l'air."
Lang["N1_17797"] = "Hydromancienne Thespia"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17797
Lang["N2_17797"] = "Thespia est le premier boss du Caveau de la vapeur dans le réservoir de Glissecroc."
Lang["N1_20870"] = "Zereketh le Délié"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20870
Lang["N2_20870"] = "Zereketh est le premier boss de l'Arcatraz."
Lang["N1_15608"] = "Medhivh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=15608
Lang["N2_15608"] = "Medivh est pres de la Porte des ténèbres, dans la partie sud du Noir Marécage."
Lang["N1_16524"] = "Ombre d'Aran"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16524
Lang["N2_16524"] = "Le père un peu fou de Medhivh, dans Karazhan"
Lang["N1_16807"] = "Grand démoniste Néanathème"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16807
Lang["N2_16807"] = "Le grand démoniste est un Gangr'orc, le premier boss des Salles Brisées."
Lang["N1_18472"] = "Tisseur d'ombre Syth"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18472
Lang["N2_18472"] = "Syth est un Arakkoa, premier boss des salles des Sethekk."
Lang["N1_22421"] = "Skar'this l'Hérétique"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22421
Lang["N2_22421"] = "Skar'this n'est present que dans la version héroïque de l'Enclos aux Esclaves. Il se trouve juste apres le premier boss. Quand on saute dans une petite marre, il est a gauche a la sortie, dans une petite cage."
Lang["N1_19044"] = "Gruul le Tue-dragon"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19044
Lang["N2_19044"] = "Gruul est un enorme gronn, dernier boss du raid le Repaire de Gruul dans les Tranchantes."
Lang["N1_17225"] = "Plaie-de-nuit"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17225
Lang["N2_17225"] = "Plaie-de-nuit est un boss optionel, invoquable dans Karazhan. Allez voir son acces pour plus de details."
Lang["N1_21938"] = "Soigneterre Sabot-cagneux"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21938
Lang["N2_21938"] = "Sabot-cagneux est a l'interieur du petit batiment, au point le plus haut du village Ombrelune (28.6,26.6)."
Lang["N1_21183"] = "Oronok Coeur-fendu"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21183
Lang["N2_21183"] = "Coeur-fendu est en haut d'une colline a un endroit appele la ferme d'Oronok (53.8,23.4), entre la Halte de Glissentaille et l'autel de Sha'tar."
Lang["N1_21291"] = "Grom'tor, fils d'Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21291
Lang["N2_21291"] = "Se trouve a la Halte de Glissentaille (44.6,23.6)."
Lang["N1_21292"] = "Ar'tor, fils d'Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21292
Lang["N2_21292"] = "Se trouve a la Halte Illidari (29.6,50.4), suspendu dans l'air par des rayons rouges."
Lang["N1_21293"] = "Borak, fils d'Oronok"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21293
Lang["N2_21293"] = "Juste au nord du Site d'éclipse (47.6,57.2)."
Lang["N1_18166"] = "Khadgar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18166
Lang["N2_18166"] = "Se trouve au centre de Shattrath, juste a cote d'A'dal, le grand truc jaune brillant."
Lang["N1_16808"] = "Chef de guerre Kargath Lamepoing"	-- https://www.thegeekcrusade-serveur.com/db/?npc=16808
Lang["N2_16808"] = "Lamepoing est le dernier boss des Salles Brisees. Alerte spoiler, il a des lames a la place des poings."
Lang["N1_17798"] = "Seigneur de guerre Kalithreshh"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17798
Lang["N2_17798"] = "Kalithresh est le 3eme et dernier boss du Caveau des Vapeurs dans le réservoir de Glissecroc."
Lang["N1_20912"] = "Messager Cieuriss"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20912
Lang["N2_20912"] = "Cieuriss est le 5eme et dernier boss de la bataille finale a l'Arcatraz."
Lang["N1_20977"] = "Milhouse Tempête-de-mana"	-- https://www.thegeekcrusade-serveur.com/db/?npc=20977
Lang["N2_20977"] = "Millhouse est un gnome mage qui apparait pendant la bataille contre Cieuriss dans l'Arcratraz. Il se trouve dans une des cellules et rejoint le combat quand les monstres sont liberes."
Lang["N1_17257"] = "Magtheridon"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17257
Lang["N2_17257"] = "Magtheridon est retenu prisonnier sous la Citadelle des Flammes infernales, dans le raid appele le Repaire de Magtheridon."
Lang["N1_21937"] = "Soigneterre Sophurus"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21937
Lang["N2_21937"] = "Sophurus se tient a l'exterieur de l'auberge du Bastion des Marteaux-hardis (36.4,56.8)."
Lang["N1_19935"] = "Soridormi"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19935
Lang["N2_19935"] = "Soridormi se promene autour du sablier dans les Grottes du Temps."
Lang["N1_19622"] = "Kael'thas Haut-soleil"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19622
Lang["N2_19622"] = "Kael'thas est le 4eme et dernier boss du raid appele L'OEil, dans le Donjon de la Tempête, Raz-de-Néant."
Lang["N1_21212"] = "Dame Vashj"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21212
Lang["N2_21212"] = "Dame Vashj est le dernier boss du raid appele la Caverne du sanctuaire du Serpent, dans le réservoir de Glissecroc."
Lang["N1_21402"] = "Anachorète Ceyla"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21402
Lang["N2_21402"] = "Ceyla a l'Autel des Sha'tar (62.6,28.4)."
Lang["N1_21955"] = "Arcaniste Thelis"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21955
Lang["N2_21955"] = "Thelis est a l'interieur du Sanctum des Étoiles (56.2,59.6)"
Lang["N1_21962"] = "Udalo"	-- https://www	.thegeekcrusade-serveur.com/db/?npc=21962
Lang["N2_21962"] = "Il est couche, mort, sur la petite rampe just avant le dernier boss dans l'Arcatraz."
Lang["N1_22006"] = "Seigneur de l'ombre Morteplainte"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22006
Lang["N2_22006"] = "Il est a dos de Dragon, en haut de la tour nord du Temple Noir (71.6,35.6)"
Lang["N1_22820"] = "Voyant Olum"	-- https://www.thegeekcrusade-serveur.com/db/?npc=22820
Lang["N2_22820"] = "Olum est a l'interieur de la Caverne du sanctuaire du Serpent, juste derriere le Seigneur des fonds Karathress."
Lang["N1_21700"] = "Akama"	-- https://www.thegeekcrusade-serveur.com/db/?npc=21700
Lang["N2_21700"] = "Akama se trouve a la Cage de la gardienne (58.0,48.2)."
Lang["N1_19514"] = "Al'ar"	-- https://www.thegeekcrusade-serveur.com/db/?npc=19514
Lang["N2_19514"] = "Al'ar est le premier boss du raid L'OEil. C'est un grand oiseau de feu."
Lang["N1_17767"] = "Rage Froidhiver"	-- https://www.thegeekcrusade-serveur.com/db/?npc=17767
Lang["N2_17767"] = "Rage Froidhiver est le premier boss du raid appele Mont Hyjal."
Lang["N1_18528"] = "Xi'ri"	-- https://www.thegeekcrusade-serveur.com/db/?npc=18528
Lang["N2_18528"] = "Xi'ri est a l'entree du Temple Noir. C'est un grand truc bleu qui brille. On ne peut pas le rater non plus."


Lang["O_1"] = "Clickez la Marque de Drakkisath pour completer la quete.\nC'est le globe brillant qui se trouve juste derriere Drakkisath."
Lang["O_2"] = "C'est un minuscule point rouge brillant sur le sol\nen face des portes d'Ahn'Qiraj (28.7,89.2)."

-- à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
-- á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
-- â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
-- ã : \195\163    ë : \195\171    ï : \195\175    õ : \195\181    ü : \195\188
-- ä : \195\164                    ñ : \195\177    ö : \195\182
-- æ : \195\166                                    ø : \195\184
-- ç : \195\167                                    œ : \197\147
-- Ä : \195\132   Ö : \195\150   Ü : \195\156    ß : \195\159