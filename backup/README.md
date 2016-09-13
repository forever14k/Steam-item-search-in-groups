# Steam item search between friends
This extension allows to find items you looking for in all friends inventories on the same time.(On steam friends page e.g. http://steamcommunity.com/my/friends)

**Extension allows filtering results like:**
 * **quality**: strange | unusual | tournament | vintage | genuine | etc..
 * **rarity**: rare | common | uncommon | mythical | etc...
 * **hero**: anti-mage | sven | wraith king | doom | etc...
 * **tag_type**: equipment | crate | ward | courier | etc...
 * **item_class**: pyro | demoman | heavy | etc...

For community inventory also can be applied game filter by using "**game: < game >**", for example "**game:dota**".

**How To:** Find appid and contextid for game items you looking for.
 1. Open any inventory in chrome.
 2. Select game inventory that you need. (for example, "Steam" inventory)
 3. Choose items category if you need to. (for example, "Coupons")
 4. Refresh or open now steam friends page in chrome.
 5. **Thats it.** Now extension grab updated ids and show them up in input boxes. You can now load inventories and search items you looking for.

In my opinion, steam trading system lack of such a functionality.

**Changelog**
 * Version 1.0.1 changes:
  * added csgo filters such as: exterior:<exterior>, category:<category>, quality:<quality>.
 * Version 1.0.2 changes:
  * fixed quality rarity filters
  * disabled unusual tooltips for now (gems update)
 * Version 1.0.3 changes:
  * enabled unusual tooltips
  * added gems support
  * updated tournament tooltips
  * added rarity filters for community inventorys (753,6)
  * updated qualitys for dota2 (Vintage -> Elder, Tournament ->Heroic, Haunted -> Cursed, Strange -> Inscribed)
 * Version 1.0.4 changes:
  * fixed unusual tooltips for teamfortress2
 * Version 1.0.5 changes:
  * fixed incidental error
 * Version 1.0.6 changes:
  * fixed url pattern match caused extension dont work if no slash in the end of url.
 * Version 1.0.7 changes:
  * added ui for filters
  * filters in input box is no longer aviable
 * Version 1.0.8 changes:
  * fixed incidental error :)
 * Version 1.0.9 changes:
  * steam now limits per minute api calls, so if steam blocked us we wait one minute for gaining access.
 * Version 1.1.0 changes:
  * reworked previous change for smoother experience.
 * Version 1.1.1 changes:
  * fixed not showing results if item dont had tags.
 * Version 1.1.2 changes:
  * Fixed Slot filters not showing
 * Version 1.1.3 changes:
  * increased steam calls timeout due to steam updates (2100)
 * Version 1.1.4 changes:
  * increased steam calls timeout due to steam updates (4300)
 * Version 1.1.5 changes:
  * using https protocol (if requested over https)
 * Version 1.1.6 changes:
  * fixed crash if items don't have description
