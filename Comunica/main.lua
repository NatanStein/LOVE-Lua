local msgr = require "mqttLoveLibrary"
local host = "localhost" 
local minhamat = "1910877"
local mostrabaleia = false 
local baleia 
local W, H = 700,700
local x2=W/2
local y2=H/2
local function mensagemRecebida (mensagem)
  if mensagem=="right" then
    x2=x2+10
  end
  if mensagem=="left" then
    x2=x2-10
  end
  if mensagem=="down" then
    y2=y2+10
  end
  if mensagem=="up" then
    y2=y2-10
  end  
end
 
function love.load () 
  msgr.start(host,minhamat,"12345",mensagemRecebida ) 
  msgr.sendMessage(tostring(x1),"12345") 
  msgr.sendMessage(tostring(y1),"12345")
  baleia = love.graphics.newImage("whale.png") 
  rm = love.graphics.newImage("RM.png")
  love.window.setMode(W,H) 
  love.graphics.setBackgroundColor (0,0,0) 
end
function love.update (dt) 
  msgr.checkMessages() 
    if love.keyboard.isDown ("right") then
    msgr.sendMessage("right","12345")
  end
    if love.keyboard.isDown("left") then
    msgr.sendMessage("left","12345")
  end
    if love.keyboard.isDown("down") then
    msgr.sendMessage("down","12345")
  end
    if love.keyboard.isDown("up") then
    msgr.sendMessage("up","12345")
  end
end
function love.draw ()  
love.graphics.draw(baleia,x2,y2,0,0.5) 
end