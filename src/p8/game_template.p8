pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- game template
-- your name here
-- version 1.0

-- game state
game = {
 state = "menu", -- menu, play, gameover
 score = 0,
 level = 1
}

-- player object
player = {
 x = 64,
 y = 64,
 dx = 0,
 dy = 0,
 speed = 2,
 sprite = 1,
 width = 8,
 height = 8,
 health = 3
}

-- enemies array
enemies = {}

-- particles array
particles = {}

-- initialization
function _init()
 -- set palette if needed
 -- pal()

 -- initialize music
 -- music(0)

 -- reset game state
 reset_game()
end

-- main update loop
function _update60()
 if game.state == "menu" then
  update_menu()
 elseif game.state == "play" then
  update_game()
 elseif game.state == "gameover" then
  update_gameover()
 end
end

-- main draw loop
function _draw()
 cls(0) -- clear screen with color 0 (black)

 if game.state == "menu" then
  draw_menu()
 elseif game.state == "play" then
  draw_game()
 elseif game.state == "gameover" then
  draw_gameover()
 end
end

-- menu state functions
function update_menu()
 if btnp(4) or btnp(5) then -- x or z button
  game.state = "play"
  sfx(0) -- play sound effect
 end
end

function draw_menu()
 print("pico-8 game template", 20, 40, 7)
 print("press x or z to start", 18, 60, 6)
 print("arrows to move", 32, 80, 5)
end

-- game state functions
function update_game()
 -- player movement
 player.dx = 0
 player.dy = 0

 if btn(0) then player.dx = -player.speed end -- left
 if btn(1) then player.dx = player.speed end  -- right
 if btn(2) then player.dy = -player.speed end -- up
 if btn(3) then player.dy = player.speed end  -- down

 -- update player position
 player.x += player.dx
 player.y += player.dy

 -- keep player on screen
 player.x = mid(0, player.x, 120)
 player.y = mid(0, player.y, 120)

 -- update enemies
 update_enemies()

 -- update particles
 update_particles()

 -- check collisions
 check_collisions()

 -- check game over
 if player.health <= 0 then
  game.state = "gameover"
 end
end

function draw_game()
 -- draw background
 -- map(0, 0, 0, 0, 16, 16)

 -- draw player
 spr(player.sprite, player.x, player.y)

 -- draw enemies
 for e in all(enemies) do
  spr(e.sprite, e.x, e.y)
 end

 -- draw particles
 for p in all(particles) do
  pset(p.x, p.y, p.color)
 end

 -- draw ui
 print("score: "..game.score, 2, 2, 7)
 print("health: "..player.health, 2, 10, 8)
 print("level: "..game.level, 90, 2, 7)
end

-- game over state functions
function update_gameover()
 if btnp(4) or btnp(5) then
  reset_game()
  game.state = "menu"
 end
end

function draw_gameover()
 print("game over!", 44, 50, 8)
 print("score: "..game.score, 40, 60, 7)
 print("press x or z", 36, 80, 6)
end

-- helper functions
function reset_game()
 game.score = 0
 game.level = 1
 player.x = 64
 player.y = 64
 player.health = 3
 enemies = {}
 particles = {}

 -- spawn initial enemies
 spawn_enemies(3)
end

function spawn_enemies(count)
 for i=1,count do
  add(enemies, {
   x = rnd(120),
   y = rnd(120),
   dx = rnd(2) - 1,
   dy = rnd(2) - 1,
   sprite = 2,
   width = 8,
   height = 8
  })
 end
end

function update_enemies()
 for e in all(enemies) do
  e.x += e.dx
  e.y += e.dy

  -- bounce off walls
  if e.x < 0 or e.x > 120 then
   e.dx = -e.dx
  end
  if e.y < 0 or e.y > 120 then
   e.dy = -e.dy
  end
 end
end

function update_particles()
 for p in all(particles) do
  p.x += p.dx
  p.y += p.dy
  p.life -= 1

  if p.life <= 0 then
   del(particles, p)
  end
 end
end

function check_collisions()
 -- check player vs enemies
 for e in all(enemies) do
  if collide(player, e) then
   player.health -= 1
   del(enemies, e)
   sfx(1) -- hurt sound

   -- create explosion particles
   for i=1,10 do
    add(particles, {
     x = e.x + 4,
     y = e.y + 4,
     dx = rnd(4) - 2,
     dy = rnd(4) - 2,
     life = 20,
     color = 8 + rnd(3)
    })
   end

   -- spawn new enemy
   spawn_enemies(1)
  end
 end
end

function collide(a, b)
 return a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end

-- utility functions
function lerp(a, b, t)
 return a + (b - a) * t
end

function distance(x1, y1, x2, y2)
 return sqrt((x2-x1)^2 + (y2-y1)^2)
end

function angle(x1, y1, x2, y2)
 return atan2(x2-x1, y2-y1)
end

__gfx__
00000000008888000022220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700888888882222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888888882222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888888882222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700888888882222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000022220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
000100000105001050010500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000336502d6502665021650196500f6500a65007650056500365001650006500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000