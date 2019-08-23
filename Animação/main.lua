function love.load()
  love.window.setMode(1000,600,{msaa=16})
  love.graphics.setBackgroundColor(1,1,1)
end
local angle = 0
local g = 2
function love.update(dt)
  angle = angle+dt*math.pi
  end
function desenha_cat (x,y,red,gr,b,K,L)
  if K==0 then
    x=50
    y=y+100
    K=K+10
    if L==0 then
      return
    else
      desenha_cat(x,y,red,gr,b,K,L-1)
    end
  elseif K == 0 then
    return
  else
    local w, h = love.graphics.getDimensions ()
    local s = w/50 
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.push () 
    love.graphics.rotate(angle*(K+L/3)/(L+K)*1.2)
    love.graphics.push () 
    love.graphics.rotate(math.pi /4) 
    love.graphics.setColor (0.0 ,0.0 ,0.0) 
    love.graphics.rectangle ("fill",-s,-s ,2*s ,2*s) 
    love.graphics.pop ()
    love.graphics.setLineWidth (5.0)
    for i = 0, 3 do 
      local a = math.pi /4 + i*math.pi/2 
      love.graphics.push () 
      love.graphics.rotate (a) 
      love.graphics.translate (s ,0) 
      love.graphics.setColor (red,gr,b) 
      love.graphics.arc("fill",0,0,s,0, math.pi) 
      love.graphics.setColor (0.0 ,0.0 ,0.0) 
      love.graphics.arc("line" ,0,0,s,0, math.pi) 
      love.graphics.pop () 
    end
   love.graphics.setColor (0.0 ,0.0 ,0.0) 
   love.graphics.circle ("fill",0.0 ,0.0 ,2) 
   love.graphics.setColor (1.0 ,1.0 ,1.0)
   love.graphics.circle ("fill" ,0.0 ,0.0 ,2) 
   love.graphics.setColor(0.0 ,0.0 ,0.0) 
   love.graphics.circle ("fill",0.0 ,0.0 ,1.5) 
   love.graphics.pop()
   love.graphics.pop()
  return desenha_cat(x+100,y,red,gr,b,K-1,L)
end
end
function love.draw()
  desenha_cat(50,50,1,1,1,10,6)
end
