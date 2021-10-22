# TiLove2d
-Compatible with Tiled version 1.7.2

This is a Love2d library to import worlds From "Tiled map editor", it is a work in progress.
You can import ".world" (world.json) file extension and ".lua" map files that are exported by "Tiled map editor" into your "Love2d" projetcts.

Supported imports:
------------------
- World files.
- Map files (lua format).
  - Tilesets.
  - Tiles.
  - Rectangles.
  - Animations.
  - Collisions. (collison tiles)
  - Layers (as many layers in each map)/(data maps)

Future supported imports:
-------------------------
- Groups (need to fix)

Deprecated:
-----------
The automatic maps button is deprecated.

Since I'm doing an apprenticeship, i d'ont have the time to work on this library.

Install:
--------
- Download "TiLove2d" in Github by selecting the "<>Code" tab then click on the "Code" button and choose "Download Zip".
- Then unzip (extract) the archive here and you have the "TiLove2d_alpha-master" folder.
- Rename this extracted folder as your project name (the folder should contain a "main.lua" file).
- Now you can use your favourite "Love2d" interpreter as "ZeroBrane or Visual Studio Code..." to lauch "TiLove2d" with its "main.lua" file.

TiLove2d directories and structure:
-----------------------------------
- images folder: put your images and tilesheet images here, you can add any subfolders for various image categories.
  - UI folder: it contains the TiLove2d's button images, let it there as it is.
- lua_maps folder: place your lua maps here (lua maps exported from "Tiled map editor" as ".lua" format).
- tiledFiles folder: place the ".world" files generated by "Tiled map editor" in this folder.
  - ".world" files will be imported automatically by "TiLove2d" when you place them in the "tiledFiles" folder.
  - You can also place any ".tsx" and ".tmx" files in the "tiledFiles" folder if you want that "Tiled map Editor" remembers it as the project directory.
- worldData folder: this is where TiLove2d saves your ".world" files into ".lua" format.
- LICENSE file: this is the MIT license made by Github for "TiLove2d".
- README.md file: this is the text you read here.

TiLove2d files:
---------------
- main.lua file: it's calling "TiLove2d" libraries (modules) and also it sets the anti-aliasing off and the window size.
- mainLinker.lua file: it connects most of the "TiLove2d" libraries (modules).
- tiledToLove.lua file: it renders (draw) tilesets and animations.
- UI.lua file: it create and renders ui buttons.
- worldAndMapsLoader.lua file: it loads maps listed into lua world files of the "worldData" folder.
- worldFileSearch.lua file: it creates "TiLove2d" folders, searches for ".world" files and send infos to the ".json" to ".lua" seralizer.
- worldJsonToLua.lua file: it is the ".world" (".json") file serializer that converts world files into lua files.

Tiled Tutorial:
---------------
Tiled map editor:

You can check the "Tiled map editor" documentation here: 

https://doc.mapeditor.org/en/stable/manual/introduction/

- Open "Tiled map editor" and create a new map, select "Orthographic" orientation, "CSV" for the tile layer format (choose your tileset tiles size according to your tileset images). WARNING !! don't save the map with the default name, write a proper name with no spaces, just letters, underscores and numbers, for example "my_map_01.tmx", and not "default title.tmx" with spaces! (You can save Tiled ".tmx" map files into the "tiledFiles" folder of your project if you wish to work in this directory with "Tiled map editor".
- Create a new tileset, (!check the box to include the tileset into the map!) and make sure the tile size is the same as your map tiles. (You can create maps with different tile size but the tileset images need to match for each map an layers). You can place some tileset tiles onto your map grid and save your map.
- Now create a world file to contain (point to) a map. Click on "world" tab then, "new world", name it and save it into your project, into the "tiledFiles" folder. (Name the file correctly with only letters, underscores and numbers). You have now access to the world tool into the "Tiled map editor" toolbar.
- Choose a map into "Tiled map editor" by selecting some map tab.
- Save the map and export the selected map as a lua file, into the "lua_maps" folder of your project by clicking on "File" then "export as" or "Ctrl+Shift+E" keys and choose the "lua_maps" folder into your project and let the map name as it is, DON'T CHANGE it (make sure that you saved your Tiled map with a correct name, for example "my_map_01.tmx"), the lua map will have the same name "my_map_01.lua" but with the ".lua" extension.
- Click on the world tool in the toolbar and click on the green button "add selected map" and choose the world where the map will be.
- Save the world so that it points to the corresponding maps that belongs to this world, click on the world menu then choose save world and save the world that shows up into the menu. Now your map is linked to this world, you only need to save world files each time you add new maps into it to update the world file. (World files need to be saved into the "tiledFiles" folder of your project).

TiLove2d Tutorial:
------------------
Once your project is ready with world and map files saved from "Tiled map editor" into your project folder as explained into the "TiLove2d directories and structure" and "Tiled Tutorial" sections above, you can load "TiLove2d" with your favourite Love2d interpreter (ZeroBrane or Visual Studio Code...).
- Launch TiLove2d and you will be directly into the world menu, by default, the first world will be selected but you can choose the world with the buttons on the left (there's as many buttons as worlds). You can see all maps of the selected world, listed on the center of the Love2d window.
- Press escape key to open TiLove2d's game menu (you can press escape key when you are ingame to open the game menu).
- Press on resume game when your'e into the game menu to launch the game render. (Escape key to open the game menu again).
- In the game menu, you can click on "Exit Game" to quit 
- Or click on "World editor" to go back to the world selection menu.

Ingame controls:

Press "Escape" key to open the menu.

Camera movement =

Press "a" for left, "d" for rignt, "w" for up and "s" for down.
