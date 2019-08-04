pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- untitled
-- typhyter

-- #include blx.blx_ctrlr.lua
-- #include blx.col_ctrlr.lua
-- #include pico8-messenger.lua

function _init()
  cartdata("typhyter_blx_cd")
  dset(0, 1)
  write_gpio_unsigned(7, 1, 8)
  printh("started")
  poke(0x5f2c,3) -- set mode3 64x64
  animTimer=0
  -- init_blx()
  init_cols()
end

function _update60()
  update_cols()
  if btnp(5) then
    -- printh("gpio: "..tostr(peek(0x5f80)))
    dset(0,dget(0) + 10)
    -- local oldgpio=read_gpio(1,8) 
    -- write_gpio(oldgpio+1,1,8)
    printh("cartdata[0]: "..tostr(dget(0)))
  end
end

function _draw()
  cls()

  -- column divider bars
  -- for x=0,7 do
  -- 	for y=0,6 do
  -- 		spr(1,x*8+0,y*8+0)
  -- 	end
  -- end
  
  
  -- draw_cols()
  print("dget: "..tostr(dget(0)))
  print("gpio: "..tostr(read_gpio_unsigned(1, 8)))
  print("cpu: "..tostr(stat(1)).."%")
  print("mem: "..tostr(stat(0)).."/2048")
end

function create_blx(cnt, col)
  local obj = {}
  for i=1,cnt do
    local block = {}
    block.id = 5
    block.color = flr(1+rnd(5))
    block.column = col
    block.y = 0 + (i - 1) * 5
    block.frame = 0
    add(obj,block)
  end
  return obj
end

function init_cols() 
  cols = {}
  for i=1, 7 do
    local col_blx = create_blx(2,i)
    col = {}
    col.blx = col_blx
    add(cols, col)
  end 
end

function draw_cols()

  foreach(cols, function(col)

    foreach(col.blx, function(b)

      x=5+(8*(b.column-1))
      y=b.y
      rectfill(x,y,x+5,y+5,b.color)
    
      spr(5+b.frame,x,y)
    end)
  end)
end

function update_cols()

  animTimer+=.0125
  if animTimer >= 1 then
    animTimer=0
    foreach(cols, function(col)
      foreach(col.blx, function(b)
        b.y+=5
        if(rnd(1) > .65) b.frame=flr(rnd(3))
      end)
    end)
  end
end

function write_gpio(num,pin_index,bits)
   write_gpio_unsigned(
   num + shl(1, bits-1),
   pin_index,
   bits
  )
 end
 
 function write_gpio_unsigned(num,pin_index,bits)
  local lastbit_i =
   0x5f80+pin_index+bits-1
  local mask = 1
  for j=0,bits-1 do
   local bit = shr(band(num, mask), j)
   poke(lastbit_i-j, bit*255)
   mask = shl(mask, 1)
  end
 end
 
 function read_gpio(pin_index,bits)
  return read_gpio_unsigned(
   pin_index,
   bits
  ) - shl(1, bits-1)
 end
 
 function read_gpio_unsigned(pin_index,bits)
  local firstbit_i =
   0x5f80+pin_index
  local num = 0
  for j=0,bits-1 do
   local val = peek(firstbit_i+j)
   if val > 0 then
    num = num + shl(1, bits-1-j)
   end
  end
  return num
 end

__gfx__
00000000000030000004500066667ddd66667d000000600070000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000033000000530006111111d60000d000000000066000000060000000000000000000000000000000000000000000000000000000000000000000000
007007000004000000035000d111111dd0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000300000044000d111111dd0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000300000035000d111111dd0000d000500000005000000050000000000000000000000000000000000000000000000000000000000000000000000
007007000003400000055000d111111dd55555000000550000005000500055000000000000000000000000000000000000000000000000000000000000000000
000000000003000000033000d111111d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000004000000043000d5555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000016050120501105034050350503505033050300502c05029050280502b050250503e050230502b0502f05021050210502605028050280502705010050140502505025050320502f050330503405034050
000400001f050280501505028050000000e050000000c05034050320500d0502c0502a0002501027050130502e05017050230503c0501e0502305026000250502005020050280502000024050000000000000000
011000000055001550025500255002550025500255002550005500155002550025500255002550025500255000550015500255002550025500255002550025500055001550025500255002550025500255002550
