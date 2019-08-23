local bolas = {}
local rk={}
local cont=0
local sec = 10
local  a = 0
local circ = 0
local start=false
local MQTT = require "mqttLoveLibrary"
local id = "Lucifer Anão"
local host = "mosquitto.org"
local cont2=1
local players = 2
local cont3=0
function msg(m)
 string.gsub(m,"(.-):(.-):(.-):(.-):",function(jog,ato,xvs,y)
     if ato == "pontos" then
       cont3=cont3+1
       rk[#rk+1]={nome=jog,pontos=tonumber(xvs)}
     end
    if ato == "inicia" and start == false then
      seed=tonumber(xvs)
      gera_bolas(60,seed)
      start=true
    end
    if sec > 0 then
      if ato=="mouse" then
        x=tonumber(xvs)
        for i = #bolas , 1, -1 do 
          local d = math.sqrt ((x- bolas[i].x )^2+(tonumber(y)- bolas[i].y)^2) 
          if d <= bolas [i].r then 
            if jog==id then
              a=a+bolas[i].pontos
            end
            table.remove(bolas,i) 
            break 
          end 
        end
      end
    end
    if ato =="pronto"then
      cont=cont+1
      end
  end
  )
end
function gera_bolas (n,seed)
  math.randomseed (os.time()) 
  local w, h = love.graphics.getDimensions () 
  for i = 1, n do 
    local r = math.random (20,70) 
    local x = math.random (r,w-r) 
    local y = math.random (r,h-r) 
    local cor = {0.8* math.random (), 0.8* math.random (), 0.8* math.random ()} 
    local pontos = 50-(r-20)
    table.insert (bolas, {r=r, x=x, y=y, cor=cor,pontos=pontos }) 
  end 
end
function desenha_bolas () 
  for i, b in ipairs ( bolas ) do 
    love.graphics.setColor(b.cor [1] ,b.cor [2] ,b.cor [3]) 
    love.graphics.circle("fill",b.x,b.y,b.r) 
  end 
end
function ranking(rk)
  s=love.graphics.newFont(28)
  love.graphics.setFont(s)
  table.sort(rk,function(a1,a2)
    return a1.pontos > a2.pontos
  end
)
  love.graphics.setColor(0,0,0)
  if players==1 then
    love.graphics.print(id,218,275)
    love.graphics.print(a,280,315)
  elseif players==2 then
    love.graphics.print(rk[1].nome,218,275)
    love.graphics.print(rk[1].pontos,280,315)
    t=love.graphics.newFont(16)
    love.graphics.setFont(t)
    love.graphics.print(rk[2].nome,52,315)
    love.graphics.print(rk[2].pontos,102,338)
  else
    love.graphics.print(rk[1].nome,218,275)
    love.graphics.print(rk[1].pontos,280,315)
    t=love.graphics.newFont(16)
    love.graphics.setFont(t)
    love.graphics.print(rk[2].nome,52,315)
    love.graphics.print(rk[2].pontos,102,338)
    t=love.graphics.newFont(14)
    love.graphics.setFont(t)
    love.graphics.print(rk[3].nome,438,325)
    love.graphics.print(rk[3].pontos,480,348)
  end
end
function final ()
  love.graphics.setColor(0.7,0.7,0.7)
  love.graphics.rectangle("fill",0,0,600,600)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(podio,-30,0,0,1,1)
end
function love.load ()
  MQTT.start(host,id,"12345",msg)
  love.window.setMode (600 ,600)
  love.graphics.setBackgroundColor (1.0 ,1.0 ,1.0) 
  podio = love.graphics.newImage("podio.jpg")
  MQTT.sendMessage(id..":pronto:a:a:","12345") 
end
function love.update(dt)
  MQTT.checkMessages()
  if start == true then
      sec=sec-dt
      circ=circ+dt
  end
  if cont==players then
      local seed=os.time()
      MQTT.sendMessage(id..":".."inicia"..":"..tostring(seed)..":a:","12345") 
      cont=0
  end
  if sec < 0  and cont2==1 then
    MQTT.sendMessage(id..":pontos:"..tostring(a)..":y:","12345")
    cont2=cont2+1
  end 
end
function love.mousepressed (x, y, bt) 
  if bt ~= 1 then 
    return
  end 
  MQTT.sendMessage(id..":mouse:"..tostring(x)..":"..tostring(y)..":","12345")
end
function love.draw () 
  if start==true then
      desenha_bolas () 
      love.graphics.setColor(0,0,0)
      love.graphics.rectangle("fill",400,15,160,35)
      love.graphics.setColor(1,1,1)
      f=love.graphics.newFont(18)
      love.graphics.setFont(f)
      love.graphics.print("Pontuação: "..tostring(a),410,20)
      love.graphics.setColor(1,0,0)
      love.graphics.arc("fill",45,35,24,-math.pi/2,-math.pi/2+2*math.pi*1/10+math.floor(circ)*2*math.pi/10,20)
      s=love.graphics.newFont(28)
      love.graphics.setFont(s)
      love.graphics.setColor(0,0,0)
      love.graphics.circle("line",45,35,24)
      love.graphics.print(math.floor(sec),37,19)
      if sec < 0 then
        final()
        if cont3==players then
          ranking(rk)
        end
      end
  end 
end