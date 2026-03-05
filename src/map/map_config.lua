local Config = {}

Config.screen_width = love.graphics.getWidth()
Config.screen_height = love.graphics.getHeight()

Config.tile_size = 16
Config.tile_x = math.ceil(Config.screen_width / Config.tile_size)
Config.tile_y = math.ceil(Config.screen_height / Config.tile_size)
Config.desert = "Assets/Tiles/Tiles/tile_0055.png"

Config.Tile = { Desert = 0, Water = 1 }

return Config
