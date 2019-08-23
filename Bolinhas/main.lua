local bolas = {}
local  a = 0
local sec = 20
local circ = 0
function gera_bolas (n)
  math.randomseed (os.time ()) 
  local w, h = love.graphics.getDimensions () 
  for i = 1, n do 
    local r = math.random (10,80) -- raio 
    local x = math.random (r,w-r) 
    local y = math.random (r,h-r) 
    local cor = {0.8* math.random (), 0.8* math.random (), 0.8* math.random ()} 
    local pontos = math.floor(500*(1/r))
    table.insert (bolas , {r=r, x=x, y=y, cor=cor,pontos=pontos }) 
  end 
end
function desenha_bolas () 
  for i, b in ipairs ( bolas ) do 
    love.graphics.setColor(b.cor [1] ,b.cor [2] ,b.cor [3]) 
    love.graphics.circle("fill",b.x,b.y,b.r) 
  end 
end
function final ()
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("fill",0,0,600,700)
  s=love.graphics.newFont(28)
  love.graphics.setFont(s)
  love.graphics.setColor(0,0,0)
  love.graphics.print("Infelizmente seu tempo acabou!!\n\t\tSua pontuação final foi:\n\t\t\t\t\t\t"..tostring(a),50,300)
end
function love.load ()
  love.window.setMode (600 ,700)
  love.graphics.setBackgroundColor (1.0 ,1.0 ,1.0) 
  gera_bolas (60) 
end
function love.update(dt)
  sec=sec-dt
  circ=circ+dt
end
function love.mousepressed (x, y, bt) 
  if bt ~= 1 then 
    return
  end 
  for i = #bolas , 1, -1 do 
    local d = math.sqrt ((x- bolas [i].x )^2+(y- bolas [i].y )^2) 
    if d <= bolas [i].r then 
      a=a+bolas[i].pontos
      table.remove(bolas,i) 
      break 
    end
  end 
end
function love.draw () 
  desenha_bolas () 
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill",400,15,160,35)
  love.graphics.setColor(1,1,1)
  f=love.graphics.newFont(18)
  love.graphics.setFont(f)
  love.graphics.print("Pontuação: "..tostring(a),410,20)
  love.graphics.setColor(1,0,0)
  love.graphics.arc("fill",45,35,24,-math.pi/2,-math.pi/2+2*math.pi*1/20+math.floor(circ)*2*math.pi/20,20)
  s=love.graphics.newFont(28)
  love.graphics.setFont(s)
  love.graphics.setColor(0,0,0)
  love.graphics.circle("line",45,35,24)
  if sec < 10 then
    love.graphics.print(math.floor(sec),37,19)
  else
    love.graphics.print(math.floor(sec),30,19)
  end
  if sec < 0 then
    final()
  end
end