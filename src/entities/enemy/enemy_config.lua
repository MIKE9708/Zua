local Config = {}

Config.screen_width = love.graphics.getWidth()
Config.screen_height = love.graphics.getHeight()

Config.name = "Enemy"

Config.WARIOR_ASSET = "TinySword/Units/Red_units/Lancer/"
Config.idle = Config.WARIOR_ASSET .. "Lancer_Idle.png"
Config.run = Config.WARIOR_ASSET .. "Lancer_Run.png"
Config.attack = Config.WARIOR_ASSET .. "Lancer_Right_Attack.png"
Config.attack_down = Config.WARIOR_ASSET .. "Lancer_Down_Attack.png"
Config.attack_up = Config.WARIOR_ASSET .. "Lancer_Up_Attack.png"

-- The images are 1536x192 you have 8 knights
-- do: 1536 / 8 = 192.
-- Just one row so the size is 192x192
Config.tile_size = 320

Config.tile_x = math.ceil(Config.screen_width / Config.tile_size)
Config.tile_y = math.ceil(Config.screen_height / Config.tile_size)

Config.idle_frames = 12
Config.run_frames = 6
Config.attack_frames = 0


Config.timer = 0

return Config
