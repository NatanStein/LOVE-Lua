local wll = require "wholelottalove"
local m2 = require "MOD2"
local m1 = require "MOD1"
local spec = m2.gen(100)


function love.load()
  m2.mutSpecIni(spec)
  wll.load(spec)
  estagio = love.graphics.newImage("stage.png")
end
function love.update()
  wll.update()
end

function love.draw()
  love.graphics.draw(estagio, 0, 0)
      if wll.draw() then
        --love.event.quit('restart')
        print("\n\n\n")
        m1.deep_print(spec)
        m2.assexualGen(spec,8)
        pcall(m2.mutSpec,spec, 0.9, 0.9 ,0,0.5)
        wll.load(spec)
      end
end

function love.quit()
  --2.evalGain(spec)
  m1.deep_print(spec, nil, nil ,0.1,nil)
  return false
end