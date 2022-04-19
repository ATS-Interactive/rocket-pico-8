pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
  my_starfield = starfield_new(100)
  my_rocket = rocket_new(64, 100)
  enemies = {}
  explosions = {}
  spawn_enemies()
  shots = {}
end

function _update()
  offset_x = 0
  offset_y = 0
  
  if btn(⬅️) then
    if my_rocket.x > my_rocket.speed then
     offset_x=-1
    end
  end
  if btn(➡️) then
    if my_rocket.x < 120-my_rocket.speed then
     offset_x=1
    end
  end 
  if btn(⬆️) then
    if my_rocket.y > my_rocket.speed then
     offset_y=-1
    end
  end 
  if btn(⬇️) then
    if my_rocket.y < 120-my_rocket.speed then
      offset_y=1
    end
  end

  
  offset_len = sqrt(offset_x*offset_x+offset_y*offset_y)
  
  if offset_len != 0 then
    offset_x /= offset_len
    offset_y /= offset_len  
  
    my_rocket.x+=offset_x * my_rocket.speed 
    my_rocket.y+=offset_y * my_rocket.speed
  end

  if btnp(❎) then
    if offset_y < 0 then
      shot_boost = -offset_y * my_rocket.speed+3
    else
      shot_boost = 3
    end
    shot = bullet_new(my_rocket.x, my_rocket.y-4, shot_boost)
    add(shots, shot)
    sfx(0)
  end
  
  update_enemies()

  for s in all(shots) do
    s:update()
    
    if s.y < -8 then
      del(shots, s)
    end 
  end
  
  my_starfield:update()
  if #enemies==0 then
    spawn_enemies()
  end

  update_explosions()
  
 
end

function _draw()
  
  my_starfield:draw()
  
  my_rocket:draw()
  
  for s in all(shots) do
    s:draw()
  end
  -- enemies
  for e in all(enemies) do
   spr(2,e.x,e.y)
  end

  draw_explosions()

end

-->8
-- player rocket
function rocket_new(_x, _y)
  o = {
    -- properties
    x=_x,
    y=_y,
    sprite=1,
    speed=1.5,
    
    -- methods
    draw = function (self)
      spr(self.sprite, self.x, self.y)
    end
  }

  return o
end
-->8
-- bullet
function bullet_new(_x, _y, _speed)
  o = {
   x=_x,
   y=_y,
   sprite=0,
   speed=_speed,
   
   draw = function(self)
     spr(self.sprite, self.x, self.y)
   end,
   
   update = function(self)
     self.y -= self.speed
   end
  }
  
  return o
end
-->8
-- starfield
function starfield_new(_starcount)
  initial_stars = {}
  for i = 1, _starcount do
    add(initial_stars, {x=rnd(128), y=rnd(128), paralax=1+flr(rnd(3))})
  end
  
  o = {
  stars=initial_stars,

  update = function(self)
    for s in all(self.stars) do
      s.y += 0.1*s.paralax*2
      if s.y > 128 then
        s.y = -1
        s.x = rnd(128)
      end
    end
  end,
    
  draw = function(self)
    cls()
    star_index=0
    for s in all(self.stars) do
      star_index+=1
      if sin(time()/50 * star_index) > 0 then
        if s.paralax == 3 then
          star_color = 7
        else
          star_color = 13
        end
      else
        if s.paralax == 3 then
          star_color = 6
        else
          star_color = 5
        end
      end
            
      pset(s.x, s.y, star_color) 
    end
  end
  }
  
  return o
end

-->8
-- enemies
function spawn_enemies()
  new_enemy = {
   x = 40,
   y = -50,
   speed = 0.4,
   life = 15  

  }
  add(enemies, new_enemy)
end

function update_enemies()
  for e in all(enemies) do
    e.y += new_enemy.speed
    if e.y > 128 then
      del(enemies, e)
    end
    --collision
    for s in all(shots) do
      if collision(e, s) then
        create_explosion(s.x+4, s.y+2)
        del(shots, s)
        e.life-=1
        if e.life==0 then
          del(enemies, e)
          sfx(2)
        end
      end  
    end
  end
end

-->8
-- tools

-- collision
function collision(a, b)
  return not (a.x > b.x + 8
              or a.y > b.y + 8
              or a.x + 8 < b.x
              or a.y + 8 < b.y)
end

-->8
-- explosions
function create_explosion(x, y)
 sfx(1) 
 add(explosions,{x=x, y=y, timer=0})
end

function update_explosions()
 for e in all(explosions) do
  e.timer+=1
  if e.timer==12 then
    del(explosions,e)
  end
 end
end

function draw_explosions()
  for boom in all(explosions) do
    circ(boom.x,boom.y,boom.timer/3,8+boom.timer%3)
  end
end


__gfx__
00000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007cc7000550055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007cc700005dd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000007777000d5555d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000770000d8558d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000990000087780000d55d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000088008800e0dd0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000800008000e00e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
6e01000037020330202f0202d0202c0202a0202902027020260202502023020210201f0201d0201a02018020160201502014020140201402014020130201302012020120201202011020110200f0200e0200c020
200200002e6102d610266100661000610006000060000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
091000002a62027620236201f6201a620126200c62006620006200062001600006000160000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
