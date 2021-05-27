Watto v1.7.4
Released September 18th, 2019
----------------------------------------

Watto is a useful tool for buying massive amounts of items, and selling your junk items!

Commandline Help:

	show = Opens the options window.
	add (Item) = This will add an item to your global sell list.
	add me (Item) = This adds an item to the current character's sell list.
	rem (Item) or remove (Item) = Remove an item from the global sell list.
	rem me (Item) or remove me (Item) = Remove an item from your personal sell list.
	rem all or remove all = Remove every item from the global sell list.
	rem me all or remove me all = Remove every item from your personal sell list.
	list = See a list of items on the general exclusion list.
	list me = See a list of items on your personal exclusion list.
	options autosell [on/off] = Toggle the autosell function on and off. You can also add "on" and "off" to specify a setting.
	options notify [on/off] = Toggle the listing of the items when you sell them.
	options randomtext [on/off] = Toggle Watto's random saying when you sell items to a vendor.
	autosell [on/off] = Toggle the automatic selling of your junk items.
	autosell food [on/off] = Toggle if Watto will automatically sell food and drink items.

----------------------------------------
F.A.Q.
----------------------------------------

Q: How do I add an item to sell?
A1: To add an item to the global sell list (the list that all your toons use) type "/watto add" then link the item(s).
A2: Adding an item to your current toon's private sell list, type "/watto add me" then link the item(s).

Q: Can I add more than 1 item at a time?
A: You can add as many items as you can link at once.

Q: I don't understand! What's an exclusion list? General list? Personal list? What??
A: Let's say you go out and kill a lot of things, but you get a bunch of items you don't want. Most of it is trash, but there are some white-quality items that you want to sell too. The exclusion list lets you add those items to the group of items that will be sold to vendors when you hit the "Watto's Junkyard" button on the top-right hand side of a merchant window. In the case of grey-quality (junk) items, the exclusion list will make it so that item is NOT sold to the vendor. There are 2 types of lists: The General Exclusion list works for all toons, on all the servers. This is generally used for white-quality items such as various food and water items that you don't need. The Personal Exclusion list works the same, but is for the current toon only. If you need the food and water items on all your toons, but don't need them on your mage, you can add them to his personal exclusion list, and any food or water on that toon will be sold, as if it was a junk item.

Q: I added a white-quality item to both my lists but it won't sell! How do I fix it?
A: When a white-quality item is added to the general sell list, it is considered a "trash" item. However, if that item is also on your current toon's private list, it is no longer considered a trash item. Type "/watto list me" and see if that item is in your private exclusion list. If it is, you can remove it by typing "/watto rem", link the item, and it will become sellable again.

Q: Watto keeps selling my food! Why is it doing that, and how do I stop it?!
A: Watto will automatically sell your food if it's not of a high enough level. There is usually better food you can use, so it sells your current food. You can add your specific food to either exclusion list, and they will no longer be automatically sold. You can compeletely disable this by turning off "Sell Low-Level Food" in the Options window.

Q: How do I buy a lot of items?
A: When at a merchant, press the SHIFT key to open Watto's Discount Items window. There, you can type in the total number of items you want then press the "purchase" button, and Watto will buy them for you. Or you can press one of the handy buttons for Watto to automatically choose an amount for you!

----------------------------------------
History

v1.7.4
 - Can now instantly start typing the amount you want when opening Watto's Bulk Supplies.

v1.7.3
 - Removed some legacy code that was deleting user's options.
 - Fixed a bug that would show up while trying to get Sell Items before the Options have been loaded.

v1.7.1
 - Updated for WoW Classic (1.13.2)

----------------------------------------

Watto and his likeness are copyrighted to Lucasfilms & The Disney Corperation. I mean only to honor this wonderful character by his usage.