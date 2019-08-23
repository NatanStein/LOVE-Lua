--Nome: Natan Steinbruch, Matricula: 1910877
function love.load ()
love.window.setMode(1000,600)
love.graphics.setBackgroundColor(1,1,1)
c=1/9
end
function circulocol(R,r,g,b,x,y,rep)
  if rep == 0 then
    return
  else
    love.graphics.setColor(r,g,b)
    love.graphics.circle("fill",x,y,R)
    circulocol(R,r+c,g,b+c,x+50,y,rep-1)
  end
end
function linha(l,R,r,g,b,x,y,rep)
  circulocol(R,r,g,b,x,y,rep)
  if l == 0 then
    return
  else
    linha(l-1,R,r,g-c,b,x,y+50,rep)
    circulocol(R,r,g,b,x,y,rep)
  end
end
function love.draw ()
linha(10,25,0,1,0,25,25,10)
end
