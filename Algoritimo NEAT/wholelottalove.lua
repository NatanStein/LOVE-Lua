local M = {}
local m1 = require "MOD1"
local blocos = {}
local chao = {w = 0, h = 0, y0 = 0, x0 = 0, x = 0, y = 0}
local obstaculos = {}
local passarinhos = {}
local t = 0.25
local game = true
local pontos = 0
local tPontos = 0.5
local abort = false
local tPassa = 0.5
local totTime = 0
--{['loss']=0.008,['cG']= { {-1,-99,0.03,2} }, ['nG']= {-1,-99}, ['ecG']= {['-1--99']=1} }
local function netUpdate(genes,dist1,dist2, bird1)
  bird1 = bird1 or {['x']=100000} 
  dist1 = dist1 or 100000
  dist2 = dist2 or 100000
  return m1.evalNet(genes,{[-1]=dist1/800,[-2]=dist2/800,[-3]=bird1.x/800})
end
----
local function pula(bloco)
  bloco.velocidade = -20
end

local function abaixa(bloco,on)
  --[[if on and not(bloco.abaixado) then bloco.h = 15 bloco.abaixado = true
  elseif not(on) and bloco.abaixado then bloco.h = 30 bloco.abaixado = false end]]
  if on then bloco.h = 30
  else bloco.h = 60 end
end
--
local function geraPassarinhos()
  local w, h = love.graphics.getDimensions()
  wb = math.random(40, 40)
  hb = 15
  passarinhos[#passarinhos + 1] = {w = wb, h = hb, velocidade = 5, x = w, y = chao.y - 50 - hb}
end
local function geraBlocos()
  local w, h = love.graphics.getDimensions()
  wb = math.random(40,40)
  hb = math.random(30, 30)
  obstaculos[#obstaculos + 1] = {w = wb, h = hb, velocidade = 5, x = w, y = chao.y - hb}
end 

local function geraObstaculos()
  x = math.random(1,2)
  if( x == 1) then
    geraBlocos()
  else
    geraPassarinhos()
  end
end
--
function M.load(genePool)
  math.randomseed(3)
  blocos = {}
  chao = {w = 0, h = 0, y0 = 0, x0 = 0, x = 0, y = 0}
  obstaculos = {}
  t = 0.25
  game = true
  pontos = 0
  tPontos = 0.5
  abort = false
  totTime = 0
  local totInd = #genePool
  --local genePool = { {['id']=1,['gain']=81,['ecG']= {['-1--99']=1}, ['nG']= {-1,-99},['cG']= { {-1,-99,0,1} } } , {['id']=1,['gain']=81,['ecG']= {['-1--99']=1}, ['nG']= {-1,-99},['cG']= { {-1,-99,0.5,1} } } , {['id']=1,['gain']=81,['ecG']= {['-1--99']=1}, ['nG']= {-1,-99},['cG']= { {-1,-99,0.4,1} } } }
  local w, h= love.graphics.getDimensions()
  chao.w = w
  chao.h = 67
  chao.y0 = h - (chao.h/2)
  chao.x0 = chao.w/2
  chao.x = 0
  chao.y = 534
  for i = 1, totInd do
    blocos[i]={w = 60, h = 60, velocidade = 10, gravidade = 1.5, y = 0, dist = {}, genes=genePool[i], color={i/totInd,0,1-i/totInd}, alive=true,nPulos = 0,abaixado=false}
    blocos[i].x0 = chao.x + 100 + blocos[i].w/2
    blocos[i].y0 = chao.y - blocos[i].h/2
    blocos[i].x = chao.x + 100
  end
  geraObstaculos()
end
local function desenhaObstaculos()
  love.graphics.setColor(0, 0, 0)
  local w, h= love.graphics.getDimensions()
  for i = 1, #obstaculos do
    love.graphics.rectangle("fill", obstaculos[i].x, obstaculos[i].y, obstaculos[i].w, obstaculos[i].h)
  end
  love.graphics.setColor(1,1,1)
end

local function desenhaPassarinhos()
  love.graphics.setColor(0.5, 0.5, 0.5)
  local w, h= love.graphics.getDimensions()
  for i = 1, #passarinhos do
    love.graphics.rectangle("fill", passarinhos[i].x, passarinhos[i].y, passarinhos[i].w, passarinhos[i].h)
  end
  love.graphics.setColor(1,1,1)
end
--
local function desenhaChao()
  local w, h= love.graphics.getDimensions()
  love.graphics.polygon("fill", 0, h, 0, h - chao.h, chao.w, h - chao.h, chao.w, h)
end
--
local function desenhaBloco(bloco)
  love.graphics.setColor(bloco.color)
  love.graphics.rectangle("fill", chao.x + 100, bloco.y, bloco.w, bloco.h)
  love.graphics.setColor(0,0,0)
  love.graphics.print(bloco.genes.id, chao.x+100, bloco.y)
  love.graphics.setColor(1,1,1)
end
--
local function colisao(bloco)
  if abort then return 0 end
  local xi = bloco.x0
  local yi = bloco.y + bloco.w/2
  local dxi = bloco.w
  local dyi = bloco.h
  for i = 1, #obstaculos do
    local xj = obstaculos[i].x + (obstaculos[i].w/2)
    local yj = obstaculos[i].y + (obstaculos[i].h/2)
    local dxj = obstaculos[i].w
    local dyj = obstaculos[i].h
    bloco.dist[i] = obstaculos[i].x - obstaculos[i].w - bloco.x
    if(bloco.y+bloco.h > obstaculos[i].y) and (bloco.x +bloco.w> obstaculos[i].x and (bloco.x < obstaculos[i].x+obstaculos[i].h)) then --- not (xi + dxi/2 <= xj - dxj/2 or xj + dxj/2 <= xi - dxi/2 or yi + dyi/2 <= yj - dyj/2 or yj + dyj/2 <= yi - dyi/2)
      return i
    end
  end
  for i = 1, #passarinhos do
    local xj = passarinhos[i].x + (passarinhos[i].w/2)
    local yj = passarinhos[i].y + (passarinhos[i].h/2)
    local dxj = passarinhos[i].w
    local dyj = passarinhos[i].h
    if((bloco.y < passarinhos[i].y+passarinhos[i].h) and (bloco.x +bloco.w> passarinhos[i].x and (bloco.x < passarinhos[i].x+passarinhos[i].h))) then --- 
      return i
    end
  end
  return -1
end

function M.update()
  local dt = 0.001
  totTime = totTime+dt
  if(true) then
    for i, bloco in pairs(blocos) do
    bloco.velocidade = bloco.velocidade + bloco.gravidade
    bloco.y = bloco.y + bloco.velocidade
    if(bloco.y > chao.y - bloco.h) then
      bloco.y = chao.y - bloco.h
      bloco.nPulos = 0
    end
    end
    t = t - dt
    if(t < 0) then 
      geraObstaculos()
      local factor = math.min(0.11,totTime/40+0.01)
      t = math.random(0.15-factor,0.25-factor)       ------------------------OBJECT GEN TIME
    elseif t >0.15 then
      t = 0.15
    end
   --[[ tPassa = tPassa - dt
    if(tPassa + t  < 0) then
      geraPassarinhos()
      tPassa = math.random(0.05, 0.15)
    elseif tPassa > 0.15 then
      tPassa = 0.15
    end]]--
    pontos = pontos + dt

  for i, bloco in pairs(blocos) do
    if bloco.alive then
      local indexCol = colisao(bloco)
      if(indexCol ~= -1) then
        bloco.genes.pontos= pontos
        bloco.alive=false
      end
    end
  end
  
  for i = #obstaculos,1, -1  do
    obstaculos[i].x = obstaculos[i].x - obstaculos[i].velocidade
    if(obstaculos[i].x < 0) then 
      table.remove(obstaculos, i)
    end
  end
 end 
  for i = #passarinhos,1, -1  do
    passarinhos[i].x = passarinhos[i].x - passarinhos[i].velocidade
    if(passarinhos[i].x < 0) then 
      table.remove(passarinhos, i)
    end
  end
end
function love.keypressed(key)
  if(key == "e") then
    abort = true
  end
end
function M.draw()
  --print(netUpdate(genes,bloco.dist[1]))
  --desenhaChao()
  desenhaObstaculos()
  desenhaPassarinhos()
  local quit = true
  for i, bloco in pairs(blocos) do
    local outs = netUpdate(bloco.genes,bloco.dist[1],bloco.dist[2],passarinhos[1])
    if outs[-99]<0.1 and outs[-99]>-0.1 and bloco.nPulos<2 and bloco.h==60 then pula(bloco) bloco.nPulos = bloco.nPulos+1 end
    abaixa(bloco,outs[-98]<0.1 and outs[-98]>-0.1)--
    if bloco.alive then desenhaBloco(bloco) quit = false
    else love.graphics.print(bloco.genes.pontos, 600, 20*(i+1)) end
  end
  if quit then return true end
  love.graphics.setColor(0,0,0)
  love.graphics.print(pontos, 400, 275)
  --love.graphics.print("NPulos:" .. nPulos, 100, 100) --bloco.y
  local d1 = obstaculos[1] or {['x']="nil"}
  local d2 = obstaculos[2] or {['x']="nil"}
  love.graphics.print("Dists:" .. d1.x.."   "..d2.x.."   Len:"..#obstaculos, 50, 70) --bloco.y
  love.graphics.print("Tempo:" .. totTime, 50, 50)
  love.graphics.setColor(1,1,1)
  --[[for c,k in pairs(bloco.dist) do
    love.graphics.print("distancia proximo bloco:".. k, 10, 10 + 10*c)
  end]]
end

return M
