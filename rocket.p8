pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
  my_starfield = starfield_new(100)
  my_rocket    = rocket_new(64, 100)
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
  end
  
  for s in all(shots) do
    s:update()
    
    if s.y < -8 then
      del(shots, s)
    end 
  end
  
  my_starfield:update()
end

function _draw()

  my_starfield:draw()
  
  my_rocket:draw()
  
  for s in all(shots) do
    s:draw()
  end

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
__gfx__
00000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007cc7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007cc7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099000008778000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000088008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
