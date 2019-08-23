local bolas={}
xmov = 200
local msgr = require "mqttLoveLibrary" 
local canal = "12345love"
local host = "localhost"
desenharaio=false
function gera_bolas (n,seed)
  math.randomseed (os.time()) 
  local w, h = love.graphics.getDimensions () 
  local y = 100
  for i = 1,20 do 
    local r = math.random (20,70) 
    local x = math.random (r,w-r) 
    local cor = {0.8* math.random (), 0.8* math.random (), 0.8* math.random ()} 
    local pontos = 50-(r-20)
    table.insert (bolas, {r=r, x=x, y=y, cor=cor,pontos=pontos }) 
  end 
end
function desenha_bolas () 
  for i, b in ipairs (bolas) do 
    love.graphics.setColor(b.cor [1] ,b.cor [2] ,b.cor [3]) 
    love.graphics.circle("fill",b.x,b.y,b.r) 
  end 
end
function msgrecebida (msg)
   string.gsub(msg,"(.-):(.-):",function(ato,lado)
       if ato == "para" then
         if lado == "dir" then
            movimentadir = false
         else
            movimentaesq = false
          end
       elseif  ato == "move" then
         if lado == "dir" then
           movimentadir = true
         else
           movimentaesq = true
         end
      end
    end
 )
end
function desenhaatirador ()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(nave,xmov-5,442,0,0.06,0.06)
end
function atiraraio ()
  local yconTotal=0
  local indice = 0
  for i = 1,#bolas do
    if xmov >= bolas[i].x-bolas[i].r and xmov <= bolas[i].x + bolas[i].r then
      ycontato = bolas[i].y + math.sqrt(bolas[i].r^2-(xmov-bolas[i].x)^2)
      if ycontato > yconTotal then
        yconTotal = ycontato
        indice=i
      end
    end
  end
  if yconTotal ~= 0 then
    love.graphics.setColor(1,0,0)
    love.graphics.line(xmov+24,454,xmov+24,yconTotal)
    table.remove(bolas,indice)
    movimentadir = false
    movimentaesq = false
  else
    love.graphics.setColor(1,0,0)
    love.graphics.line(xmov+24,454,xmov+24,100)
    movimentadir = false
    movimentaesq = false
  end
end
function love.load()
  msgr.start(host,"Meulove",canal,msgrecebida)
  love.window.setMode (600 ,600)
  love.graphics.setBackgroundColor (1,1,1) 
  nave=love.graphics.newImage("nave.png")
  gera_bolas()
end
function love.update(dt)
  msgr.checkMessages()
  if movimentadir and movimentaesq then
    desenharaio=true
  else
    desenharaio=false
    if movimentadir then
      xmov=xmov+3
      if xmov > 543 then
        xmov=543
      end
    end
    if movimentaesq then
      xmov=xmov-3
      if xmov < 5 then
        xmov=5
      end
    end
    end
end
function love.draw()
  if desenharaio then
    atiraraio()
  end
  love.graphics.setColor(0,0,0)
  love.graphics.setLineWidth(6)
  love.graphics.line(0,500,600,500)
  desenha_bolas()
  desenhaatirador()
end
    