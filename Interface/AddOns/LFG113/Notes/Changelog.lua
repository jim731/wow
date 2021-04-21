	local _, L = ...

	L.VersionInformation = [[
Version 1.16 02/21/21
- Changed version  to newest Version
- Added Draenei and Blood Elf maps
- Added localization for new strings
- Moved communication Language to display tab in settings
- Added ability to load/unload channels or leave as is when loading and exiting interface to Communications tab in settings.
----- When loading/unloading IS enabled:
        * there is a chance of the channels changing order.
		* This is used when you have TEMPORARY channels you want to load on a specific character.
		* you CAN add a channel via the addon interface
----- When loading/unloading is disabled (DEFAULT):
	    * ONLY the channels that existed on start of the game will be used. ANY added channels will not show or will be monitored until the game is rebooted.
		* Safe way to use the addon if you like the order your channels are in.
		* you CAN NOT add a channel via the addon interface

Version 1.15 07/17/2020
- Changed version to newest release. found no issues.

Version 1.14 05/03/2020
- Changed PLAYER_LEAVING_WORLD event to PLAYER_LOGOUT event because of issue when hearth-stoning or using transportation to another zone will log you out of channels.

Version 1.13 04/30/2020
- Added ability to delay addon load via settings for slow machines or those that take a while to get into game.
- Added ability to disable loading the right-click menu via settings for those wanting to use the TARGET menu from chat.
- Restructured the way Channels are setup, loaded, listened to and removed via settings. Channels that loaded PRIOR to addon can not be removed via addon.
- Added custom option {n} to display number of individuals need for instance (When below 5)
- Added custom option {g} to display "then GTG" when you only need one more person
- Language defaults for LFM (in settings) is now "LF{n}M {r} for {i} {s} {g}"
- Changes made to WHISPERS and LFG/LFM broadcast strings will now be displayed in the "OUTPUT" box below the interface and not in the chat window.
- Update notes are now in a scroll-able frame.
- Updated Scrollframes to use OptionsSliderTemplate instead of UIPanelScrollBarTemplate
- Removed/Disabled the LFG custom channel
- Added AND/OR buttons for roles and Instances! You can select Either one or neither to be injected in to the roles/Instances.

Version 1.12 03/20/2020
- Added option in Settings/Display to disable automatic notification when its time to broadcast a search
- Added ability to broadcast search right from minimap icon with SHIFT-LEFT click

Version 1.11 03/17/2020
- Fixed issue with settings LFM/LFG custom text not showing
- Fixed issue with LFG/LFM custom text not showing correctly
- Changed BLACKLIST button to PLAYER button
- Added Blacklist and Rating tabs to Players
- added Premades tab to Premades button
- Added background images to interface
- USE {s} in any custom string in settings or whispers to access whatever you have as a custom lfg/lfm string.
- Removed separate image files and created a map file to save some memory and speed up addon.

Version 1.10 03/10/2020
- Updated for interface 1.13.4

Version 1.09 02/22/2020
- Fixed an error where a period showed up on a random line in the addon effecting Saves (Line 844/845)

Version 1.08 02/21/2020
- LFG/LFM format can now be changed in Settings! Customize your broadcasts permanently.
- Added a Communication Language in settings, this is the language used for default Whispers and any LFG/LFM broadcast-ed.
- ANY issues please let me know
- Guild only has been temporarily disabled.

Version 1.07 02/14/2020
- Added an output box at the bottom of the screen to show what your output will be when you press "Search"

Version 1.06 02/03/2020
- Added Russian Local files
- Rearranged settings to accommodate Russian translations

Version 1.05 01/29/2020
- Corrected an issue with Lcoals not working correctly with clients that have no Local (Should default to english)
- Added a Reload button when Local is changed in the settings.

Version 1.04 01/10/2020
- Language Localization will now default to client if it exists, english otherwise. This can now be changed in the Settings/Display section. Reloading client is mandatory to take effect.
- Started Organizing files

Version 1.03 01/01/2020
- Settings/Display now has option to Compact LFG/LFM into one line each, displaying only the instance
- New arrow in LFG/LFM that will expand the LFG/LFM area

Version 1.02 12/31/2019
- Can select if a raid, and will convert to raid when using that group
- Can edit and change Premade Group name and set Raid status

Version 1.01 12/30/2019
- Added roles to Premade lists
- Can edit Individuals in the Premade lists and change roles.
- Lists now stay open when changes are made or tabs changed.

Version 1.00 12/29/2019
- Added and tested Autoinvites, creation and removal.
- Added ability to remove Blacklisted individuals.
- Removed ALL communication between individuals except for the whispers you can set in settings.

Beta V.46
- Changed timing with Blacklist syncs, everything is 3 seconds between sends.

Beta V.45
- Enabled Syncing again

Beta V.40
- Re-aranged BlackList display
- Moved option "Syncronize List" to options/Communication
- Added a tab in Blacklist to show only YOUR entries, Personal and Synced
- Set limit to 5 maximum reports that can be recieved by any one person. (To combat future spam)
- Set limit to the maximum entries you can make and sync to 5. you can make as many personal as you want.

Beta V.39
- Added delay between sends and recieves on syncing... this way no one is "kicked offline" when files are large
- Added a check to make an entry PERSONAL, meaning it will not sync.
- If you have an Entry on an individual and you SHIFT-Click on the name in the BlackList, the information will show up at the top to be edited.
- Edited versions of the Blacklist will Syncronize with everyone else.
- Optimized send.recieves, cutting down on messages sent when not needed.

Beta V.38
- Corrected issue where Blacklist checkbox wasn't properly displaying its status.
- Blacklist entries are set to expire after 30 days.
- Added abilty for others syncing to sync with possible new information while not part of the sync.
- Worked on fixing a few more sync issues, changed sync commands so previous versions cant sync with newer versions.
- Enabled syncing again.

Beta V.37
- Added synchronization checklist. This is disabled by default.
- Worked on fixing Syncing issue.

Beta V.36
- Added Blacklist. This will propagate across the server you are on with other players using the addon after you first log on.
- You can Add or Change what you posted against an individual, you can not make more then one post against someone.
- You can either type the persons name in, OR right click the name in chat and select "Add To BlackList" under "Other Options"
- ALL Instances now show under CUSTOM pulldown for either Create group,Join group or Both when no filter (selections) are made, otherwise they are filtered.
- When changing Custom whispers or entering Custom text, your "Example" will be displayed in the chat box. The example will go by what your filters and pulldowns are before you change the text.

Beta V.35
- Made some changes with the use of "and" and "or"

Beta V.34
- Add Generic search terms for SM, Ulda, Mara, BRD, DM, Strat so you can use them for searches. They will accept generic searches also
- Added an reset button that will erase and reset pull downs, custom text and roles. It will not touch Show All and Guild Only.
- Exclusive custom text broadcasting ONLY when you have CUSTOM in the pull down selected
- Custom text can be formatted (using all whisper options {i}{t}{l}{c}{r} ) from both Pull down Custom and from instances if used.
- UBRS Moved to RAIDS and set to 10 man max limit.
- LFM will not say how many you need until your waiting on 3 or less players
- Again, stressing that LFM will stop when you reach the Maximum group size of the SMALLEST instance you are looking for.
- Changed (again) the way instances are Capitalized in broadcasts from the re-write.
- Added button to view both Create and Join groups for less populated servers. YOU can not search from here.
- Added TOTAL non filtered Count of those looking for group or those looking for more above the tab.
- Blacklist page Enabled but you can not add or synchronize yet.

Beta V.33
- Changed the way SM, Ulda, Mara, BRD, DM, Strat are parsed. Now, if a generalization is posted in a search, it will be interpreted as ANY instance with those words. This gives you more options when viewing searches.

Beta V.32
- Enabled SAVE, LOAD and REMOVE search options
- Search tab will show ALL saves. Tooltips will show all information on a save.
- Custom box now shows ALL the time
- SAVING a search will save:
----- IF you are looking for a group or looking for more to join
----- The role (Tank, dps, heals)
----- ALL instances selected
----- any text in the custom box
- Loading A search will restore ALL saved information, overwriting everything
----- It will also select the proper option on the left.
- Loading a search WILL NOT start a search automatically. this has to be done manually.
- Removing a search will permanently delete the search.
- Updated German Local for German Clients

Beta V.31
- Fixed an error with custom text error

Beta V.30
*** I'm leaving the previous version up if there are issues so you can download and use. ***
*** Bound to be bugs (Major overhaul)! Tell me whats happening below! ***
*** If I do not hear anything in a few days, I will start working on SAVING/LOADING searches ***

- Added multiple searches
- SAVE button will light up and allow you to click it, but it SAVES nothing... only cosmetic at this point.
- Changed addon channel routines (Different channels used then previous versions - avoiding version conflicts and errors)
- Added release Notes! This will show ONE TIME when you first load an updated Addon.
- Fixed pupDisplayType Local
- Load time increased to 10 seconds to allow channels to form before loading. Notification in Chat when ready to use.
- ALL instances searching for will show up by the minimap.
- Changes can be made to the search WHILE actively searching, but the change WILL NOT take effect until the next broadcast.
- IF there is an invalid option when the next broadcast is set to happen, the search WILL stop until the error is corrected.
- IF your in Join a Group when invited to a group, your addon will change to Create a Group and you can see all people looking for groups. From here, you can click on the "notify" button to notify the leader of any potential members.

Beta V.29
- Fix BUG when using text box for whispers while searching attaches whisper text to search text
- Add custom text to Raids and PVP
- Add Option for DM/VC preference, can be set in settings
- Minimap Icon now has an option to show ALL the time or only when actively searching. When it is on all the time, the eye will stay closed until you do an active search. It will then open and move around as it always has.
- Minimap Icon now displays the Instance you are searching for when you are actively searching.
- Ability to type in a Channel you wish to monitor for groups/people looking for groups in settings

Beta V.28
- Localized dungeon names. IMPORTANT, key words are how they are found in text.
- Add button or use Invite button to whisper party leader of an interest when in a group and not leader. You can now browse and let party leaders know when someone is looking for group and they missed it.
- Added text that will APPEND to the end of a search string in chat, its right next to the instance pulldown. (for now buggy on visibility, just select an instance and it will show up)
- Whispers, check if already in group before processing incomming whisper.
- Corected a mistake when addon  detects a user who is using an old client.

Beta V.27
- Corrected spelling error in Strat keyword
- Added Tribute Runs in instance pulldown
- Corrected a global variable and made it local. Hope this helps with localization
- Added German Local (saved french and german in UTF-8 without sig codepage 65001 for the special language characters to show)

Beta V.26
- Added fix to stop out of date with addon because of new numbering system.

Beta V.25
- Hard coded the following in globals:
-------- Re-worked global variables for dungeons, etc to now have keywords and allowed for more specific dungeons like DM east, etc. The keywords can be added as more show up to help with catching more messages.
-------- Added and implemented an exclusion list. This list will help filter out messages that are not dungeon related, like Guild Recruiting, needing a leather worker, enchanter, etc.
-------- Added more dungeon definitions like DM east, Uldaman front, Dire Maul East, etc.
- Continued prepping for multiple searches, creating, storing and loading.
- If you see a "raid star" on the left side of an Instance someone is searching for, it means they are searching for more then one instance. Mouse over to read the text to see what instances they are looking for.
- Shows the Tooltip over the individual LFG/LFM entries as the original and unedited messages in chat. This way you can see exactly what was said in case of an error or more instance was selected. (They will also show up under each instance they selected and not just 'Select Any')
- I added the word BETA to the top of the addon, some people are confused thinking that this is actually a release when in fact I just started developing it less then a month ago and its only in Beta (Not completed and with bugs)

Beta V.24
- Fixed movingeye 'code' typo when first time users try to load.

Beta V.23
- LOTS of changes, PLEASE update, pretty much mandatory
- Localization in effect, Name/Guild of translator(s) will be displayed with language using when addon is loaded. (To give credit for the time they took out of their day to do this)
- Made a whispers tab in Settings.
- Added Guild invite whisper setting.
- Added a Message Life in settings. You can decide how long you wish to see the Request for LFM/LFG in your display before it expires. This is a minimum and not exact (Accuracy depends on if Accurate Scan is checked)
- Changed how messages are sent on the ADDON channel. It will look like random letters/numbers but its not. This is so other addons that are monitoring this channel have a hard time parsing the text.
- Changed what is sent on Addon channel. NOW, only the Trade, General and Local Defense channels are sent if something is found. IF you are doing a LFG/LFM and do a search, that will also be sent. ALL other communication on other channels are no longer being sent (Redundant information) This is so individuals out in the field who do not have access to those chat channels can also see if there someone LFM/LFG
- Tooltips had to be changed to display the correct information sent
- The addon channel NOW removes itself when the addon is unloaded/character logs out or closes client
- The addon channel name now changes on a daily basis. so if you look at your channel list and see a different  channel evey day, this is intentional. The name will always start with 'LFG113'
- Settings now added for the LFG/LFM eye. It now can either be a FREE moving eye, place it anywhere on the screen, or it can be locked to the "round" minimap. There is a also a DEFAULT button that will reset the position of the eye if it is missing for any reason. The eye is still only visible while your doing an active search.

Beta V.22
- Added menu highlight AND menu selectors colors.
- Highlights first option (Create a Group) when first loading game
- Corrected the default button for the Join Group whisper: had a lowercase char instead of a cap causing an error when used.
- Fixed eye issue, Eye worked for those who already used the addon on a character, but new characters or first time use, the eye didn't work.

Beta V.20
- Added localization for other languages, looking for translators to help translate.
- Fixed the timing issue where lists were not being cleaned out. Timing is 1 minute (was actually set to 2) plus or minus 30 seconds if your not using Accurate Scans
- Accurate Scans use 1 second scans. Could cause Frame rate issues on slower machines.
- Custom Whispers should be working now. There is a "Default" button if you make a mistake or wish to use the default text that the addon is set to use
- There is a button with a ? on it, mouse over to see what the FORMAT of the strings are with example.

Beta V.19
- Whispers working, Display corrected via missing = in script

Beta V.18
- WHISPERS ARE NOT WORKING: did a temporary fix where whispers work again, but will not be changed by settings. Settings can still be changed and saved but the whispers are not effected yet.

Beta V.16
- Active Searches and Black List have been created on the left tab, Disabled at this point
- Settings have changed and have been partially organized
- Whispers can now be customized. you can use a FORMAT:
--- {i} = instance
--- {t} = instance type text
--- {r} = your role(s) selected
--- {l} = your current level
--- {c} = your current class

- NOTE*
-------- {t} will return ONE of the strings depending on the instance type selected via the pulldown:
-------- Dungeons selected: "for the dungeon"
-------- Raids Selected: "for the raid"
-------- Questing Selected: "to do some questing in"
-------- PVP Selected: "to PVP in"

- Example:
-------- I'm a {l} {r} looking for a group {t} {i}
-------- would return I'm a 19 DPS looking for a group for the dungeon RFK
-------- if you where level 19 with DPS and RFK selected.

Beta V.15
- There is now a button to view ALL active searches and allow you to search for more then one instance/pvp/etc (NOT active yet but visible)
- Buttons have changed. IF you liked the classic version, you can change it back in settings. REQUIRES a reload if option is changed- in chat type: /reload
- Settings changed a little to make more room

Beta V.14
- Added a button that DOES NOTHING... its a demo of a major upgrade if accepted... LOOKING FOR FEEDBACK ONLY!

Beta V.13
- SORRY! the last update had a single quote in Global vars instead of a double causing the addon not to load or giving errors. This has been corrected

Beta V.12
- Added mini-map icon whenever you have an ACTIVE search going on. (yea yea yea, its the same moving eye lol)
- Mini-map icon is movable by right mouse button. It will remember location when you logout/login or reload
- Mini-map icon will open/close then interface when you left click
- This way, you will know if you have an active search going.

Beta V.11
- Improved how chat is parsed, picking up on more instances. Still need to do variations from the norm.
- World PVP should now be working. Now you can get a group going and Storm Southshore or Stormwind!
- When entering text into the CUSTOM or PVP text area, a pulldown will show up so you can see all of your text and edit it

Beta V.10
- FIX PING so it only goes off when there is a valid, un-grayed Accept and its clickable.
- FIX the annoying Error message in chat when you invite someone to your group and your not searching/looking.
- If the POPUP Accept is selected, it will automatically press ACCEPT on frame also.
- IF for any reason the broadcast is going to fail while searching, your search will end and a warning in text will show up in chat saying why and if sound is enabled, an audio warning. While searching, ANY changes you make will be on the next broadcast unless its an invalid change (Like no Roles or Instance selected)
- Corrected Instance text when whispering (if someone mentions a level like 19 AND/OR role like DPS then they will trigger an event, otherwise the whisper will be ignored and get no response) IT would be possible for you to have a discussion and use any of those keywords... this WILL trigger the whisper event until I find another way
- Update to use Custom (NOT PVP WORLD)
- Custom text working. You can Search for or create groups with it.
- Whispers or the Addon are the only form of communication with this
- Chat channels ARE NOT monitored for this, if someone says they want to join via a channel it will not register.
- Enter/ESC are used to exit the Custom text box
- You can not invite someone to your group if you haven't selected an Activity and Instance for what you are looking for. You need to have both to be valid (No need for roles, this is just to let everyone know what you need)

Beta V.09
- 10/6/19 I had a V.10 coming up but "Updated" my addons with curse, not ignoring LFG113 thus deleting my two days of work.... needless to say i'm starting over and update should be coming soon.

Whats New:
- You can no longer use "Select Any" when choosing an instance.
- Select Any is now only used to view what people are looking for. you can join or invite from their without creating a group.
- Rewrote the way groups are handled. The Addon should automatically stop broadcasting once you have a full group.
- Changed letters so there are capitals in the sentence and they should stand out.
- Changed the way Broadcast works. It no longer broadcasts every channel at once, it will now span the broadcast over several channels you selected in settings randomly over 15 seconds. This will happen once every n# Seconds set by the slider in settings.

Beta V.08
- IMPORTANT UPDATE: This has the possibility to spam channels due to GROUP_ROSTER_UPDATE trigger (Dependent on number in group). This has been fixed.
- PLEASE UPDATE.

Whats New:
- Popups now work when someone requests to join (Turn on in settings, its off by default)
- Now, when joining a group the addon will stop broadcasting on channels and put you into Settings tab, thereby not allowing you to browse for more groups or try to join another group.

Beta V.07
- Changed the way Timing works. A new timer is created every time you click on Start Search and destroyed when search ends. An initial broadcast will be sent and then one every n# seconds after you click Start Search.
- Requested by a couple of people: Settings now contains a Slider called "Time to Broadcast" so you can change the Broadcasting time. Broadcasting is defaulted to the minimum 1 minute (60 seconds) but you can increase the time up to 3 minutes (180 seconds)

Beta V.06
- Made it so you can not look for a group while in a group.
- Improved logic on number in group while searching for a group based on raid, instance or pvp. The display will show accordingly unless unspecified in chat, then it will be left blank.
- Added Custom Option to the Instances, Raids, PVP and Questing pulldown.
- Added Custom text entries for Custom and World PVP Pulldowns, but stopped short of entering the entries into the broadcasts. THIS is where I need feedback, should I continue with both CUSTOM entries?
- Logically, any Spammer could then USE this to just Spam channels for GOLD or whatever they wish (the text is LIMITED to 150 characters, but even 20 characters could be enough for Spamming GOLD or whatever)

Beta V.05
- Added sound When searching and canceling.
- Addon now continuously pings every 5 seconds while someone is actively trying to join your group.
- Options: Full Group Audio and Popup Alert do not work yet
- No longer connect to or broadcast to the old channel from the older version of the addon.
- Removed some settings im not going to use. Reorganized them.
- while browsing groups, you can now see how many the group is looking for when the person who created the group is using addon.
- Still need to add text entry for World PVP.

Beta V.04
- OK, Major update. This may make or break the addon. I have tested and it seems ok. Please let me know different and ill fix asap!
- Changed Channels to something more readable so you know its from the app. you will still connect to the old channel for the few updates, just so older clients that do not use automatic install from Curse will/should get an outdated message.
- Groups can now be created with RAIDS and PVP groups. I created a generic World PVP for now (for raiding towns, areas etc that are not Instanced), but in the future I will put a text box where you can type in exactly WHAT you want to do and where.
- Whispers have been corrected, so when your Looking for a group you will not send anyone the automated message. (It should only ask for role and level if you created a group, not both)
- Groups no longer display all three roles for an individual when someone doesn't specify a role. Now, it will display nothing. in the future I hope to either instantiate roles based on class (IF all 3 roles are DPS only for that class like a mage, etc) or leave it as is.
- Important and why I Changed the ADDON channel: the format has changed on communication to now include multiple searches and instances when looking and the best way I could minimally impact system performance. This is the first step in allowing you to search for ANY available instance based on your level or ones you specifically choose.

Beta V.03
- Added versioning. you will be notified ONE time that there is an update to the addon during the entire game session.
- All Prints have been removed.
- You will be notified in one line once the addon has been loaded and that you can use it.
- The only notifications you should receive in chat are error messages when your trying to do something.

Beta V.02
- Addon should automatically stop your search if you either: Join a group or your group is "full". Please let me know otherwise (what happened, how many in your group, Instance, etc)
- Then you are actively searching for a team and someone whispers you with the role they wish to join as but not their level or vice versa, they will get a default whisper back asking for both Role and level. When you receive proper information, it will add them to your Create a group window. (when Settings/Accept Whispers is enabled)
- Added default "Builds" for groups of 5, 20 and 40 when using auto accept.
- Added Settings and Global for future updates. (Taking suggestions)
- Fixed the Addon channel pushing other channels down. IF your channels are still pushed down, it because the channel already exists before the update, please just right click on your General Channel tab (Main tab), Select Settings. Click on Global Channels (On left) and drag the Addon channel to the bottom.
- Fixed an issue some had with their LFG/LFM creating the wrong broadcast (didn't effect game play, just added an extra broadcast to the addon channel

Beta V.01
- Fixed the Guild bug. Guild feature did not work when you first start the game, but after a reload it worked.
- Added an option to do a more accurate system scan, but at a cost to a slow system. Option is in settings

First Version.
- LFG and LFM work, along with basic settings. Guild groups work also as well as filtering
]]