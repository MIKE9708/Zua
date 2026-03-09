local Config = {}

Config.screen_width = love.graphics.getWidth()
Config.screen_height = love.graphics.getHeight()

Config.WARIOR_ASSET = "TinySword/Units/Purple_Units/Warrior/"
Config.idle = Config.WARIOR_ASSET .. "Warrior_Idle.png"
Config.run = Config.WARIOR_ASSET .. "Warrior_Run.png"
Config.attack = Config.WARIOR_ASSET .. "Warrior_Attack1.png"

-- The images are 1536x192 you have 8 knights
-- do: 1536 / 8 = 192.
-- Just one row so the size is 192x192
Config.tile_size = 192

Config.tile_x = math.ceil(Config.screen_width / Config.tile_size)
Config.tile_y = math.ceil(Config.screen_height / Config.tile_size)

Config.timer = 0

return Config
