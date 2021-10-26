# Space-Love
A space shooter written with [LÖVE❤](https://love2d.org/) (version 0.10.2) in Lua.

![sample](assets/space-love_demo-v0.4.gif)

## Download
Download the latest version of the game via the [releases][]. 

### Windows and MacOS
For Windows (win32, win64) and MacOS users, please download the corresponding `.zip` file. 

If you have installed LÖVE or want to install it - for this, install the corresponding [release 0.10.2 from GitHub](https://github.com/love2d/love/releases/tag/0.10.2) - you can simply download the `.love` file from the [releases][] and double-click the file to start the game.

### Linux
To run the game on Linux you have to install LÖVE 0.10.2. You can do this manually using the link above or run the following commands in a terminal.

```bash
LOVE_URL='https://github.com/love2d/love/releases/download/0.10.2'
TEMP_DEB1="$(mktemp)"
TEMP_DEB2="$(mktemp)"
wget -O "$TEMP_DEB1" "$LOVE_URL/liblove0_0.10.2ppa1_amd64.deb"
wget -O "$TEMP_DEB2" "$LOVE_URL/love_0.10.2ppa1_amd64.deb"
sudo dpkg -i "$TEMP_DEB1" "$TEMP_DEB2"
rm -f "$TEMP_DEB1" "$TEMP_DEB2"
```

Then download the `.love` file from the [releases][] and simply double-click it.


## Instructions
#### Menu
Use the arrow keys <kbd>&uarr;</kbd> <kbd>&darr;</kbd> to navigate within menus and press <kbd>enter</kbd> to select.

#### In-Game
Use the arrow keys <kbd>&larr;</kbd> <kbd>&uarr;</kbd> <kbd>&rarr;</kbd> <kbd>&darr;</kbd> to navigate your ship. Press/Hold <kbd>space</kbd> to shoot.

Press <kbd>p</kbd> to pause the game.

Press <kbd>esc</kbd> to quit.

## Used Libraries, Art Packs, Sounds
### Art Pack
The sprites (plus backgrounds, fonts and some sound effects) used in this game are from the art pack [Space Shooter Redux](https://opengameart.org/content/space-shooter-redux) by [Kenny](www.kenney.nl).

Some UI elements are from the [UI Pack: RPG Expansion](https://www.kenney.nl/assets/ui-pack-rpg-expansion) by Kenny.


### Sounds
The soundtracks are from Juhani Junkala and can be found [here](https://opengameart.org/content/5-chiptunes-action).

Other sound effects:
- Various sounds from [512 Sound Effects](https://opengameart.org/content/512-sound-effects-8-bit-style)
- [Explosion](https://opengameart.org/content/explosion-0)

### Libraries
 * [Class](https://github.com/vrld/hump)
 * [Push](https://github.com/Ulydev/push)
 * [Knife](https://github.com/airstruck/knife)
 * [XmlParser](https://github.com/jonathanpoelen/xmlparser)



 [releases]: https://github.com/RafaelWO/space-love/releases
 