# TiLove2d_alpha
This is a Love2d library to import worlds From "Tiled map editor", it is a work in progress as an alpha version.
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

Tutorial:
---------

- Open "Tiled map editor" and create a new map, select "Orthographic" orientation, "CSV" for the tile layer format (choose your tileset tiles size according to your tileset images).
- Create a new tileset, (!check the box to include the tileset into the map!) and make sure the tile size is the same as your map tiles. (You can create maps with different tile size but the tileset images need to match for each map an layers).
- Now create a world file to contain (point to) a map. Click on "world" tab then, "new world", name it and save it into your project, into the "tiledFiles" folder.
- Choose a map into "Tiled map editor" by selecting some map tab.
- Export the selected map as a lua file, into the "lua_maps" folder of your project by clicking on "File" then "export as" and choose the "lua_maps" folder into your project and name the map file as your want (no need to set the file extension .lua).
- Click on the world tool in the toolbar and click on the green button "add selected map" and choose the world where the map will be.
