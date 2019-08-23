local wll = require "wholelottalove"
local m2 = require "MOD2"
local m1 = require "MOD1"
local spec = m2.gen(50)
local ini = false
local ia = false
local userGame = false

function love.load()
  love.window.setMode(800, 600)
  love.graphics.setBackgroundColor(1,1,1)
  estagio = love.graphics.newImage("stage.png")
  imagemInicial = love.graphics.newImage("start.png")
  m2.mutSpecIni(spec)
  wll.load(spec)
end
function love.mousepressed(x, y, bt)
  if bt ~= 1 then return end
  if(x >= 116 and x <=670 and y >= 310 and y <= 395) then
    ini = true
    ia = true
  end
  
  if(x >= 200 and x <= 600 and y >= 115 and y <= 205) then
    ini = true
    userGame = true
  end
end
function love.update()
  wll.update()
end

function love.draw()
  if ini then
    love.graphics.draw(estagio, 0, 0)
    if ia then
      if wll.draw() then
        --love.event.quit('restart')
        print("\n\n\n")
        m1.deep_print(spec)
        m2.assexualGen(spec,2, true)
        m2.mutSpec(spec)
        wll.load(spec)
        
      end
      
      elseif userGame then
        love.graphics.setColor(0,0,0)
        love.graphics.print("em construçao")
        love.graphics.setColor(1,1,1)
      end
  else
    love.graphics.draw(imagemInicial, 0, 0)
  end
end

function love.quit()
  --2.evalGain(spec)
  m1.deep_print(spec, nil, nil ,0.1,nil)
  return false
end