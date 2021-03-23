--Game main settings
io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")

love.window.setMode(800, 600, {resizable=false, vsync=true, minwidth=400, minheight=300})

--TiLove2d libraries call
local TiLove2d = require("mainLinker")