function mUsedWords(path,font,scheme)
  local colorSchemes={rgb={{1,0,0},{0,1,0},{0,0,1}},blues={{0.5,0.5,0.5},{0.1,0.1,0.5},{0,0,1},{0.1,0.1,0.4}},greens={{0.5,0.5,0.5},{0.1,0.5,0.1},{0,1,0},{0.1,0.4,0.1}}}
  local tin=io.open(path,"r")
  local out={}
  local pattern ="([^%s%p]+)"
  local txt = tin:read("*a")
  txt= txt:lower()
  txt:gsub(pattern, function (a)
      if out[a] then
        local id = out[a].id
        out[id]={word=a,count=out[id].count+1,obj=love.graphics.newText(font,a),col=colorSchemes[scheme][math.random(1,#colorSchemes[scheme])]}
      elseif #a>4 then
        out[#out+1]={word=a,count=1}
        out[a]={id=#out}
      end
    end
  )
  table.sort(out,function (a,b)
      if a.count==b.count then return a.word<b.word
      else return a.count>b.count end
      end)
  tin:close()
  return out
end
function drawWord(l,num,x,y) --imprime a palavra e retorna o numero de palavras impressas e a lista editada
  local obj=l[num+1].obj
  local kS= (70-num)/obj:getHeight()  -- Assumi que os tamanhos de 70px a 20px requisitados eram referentes a altura
  local lx,ly=obj:getWidth()*kS,obj:getHeight()*kS   -- Change to get Dime
  for i=1, num do
    if collided(l[i].x,l[i].y,l[i].lx,l[i].ly,x,y,lx,ly) then return false,l end
  end
  l[num+1].x,l[num+1].y,l[num+1].lx,l[num+1].ly=x,y,lx,ly
  love.graphics.setColor(l[num+1].col[1],l[num+1].col[2],l[num+1].col[3])
  love.graphics.draw(obj,x-lx/2,y-ly/2,0,kS,kS)
  --love.graphics.setColor(1,0,0) -- Colisões não estavam funcionando então adicionei "Hitboxes" pra ver como estava funcionando
  --love.graphics.rectangle("line", x-lx/2, y-ly/2, lx, ly) 
  return true,l
end
function collided(x1,y1,lx1,ly1,x2,y2,lx2,ly2)
  --if not(lx1) then print(x1,y1,lx1,ly1,x2,y2,lx2,ly2) end
  c1=(x1+lx1/2<=x2-lx2/2+2)
  c2=(x2+lx2/2<=x1-lx1/2+2)
  c3=(y1+ly1/2<=y2-ly2/2+4)
  c4=(y2+ly2/2<=y1-ly1/2+4)
  --print(c1,c2,c3,c4)
  return not((c1 or c2) or (c3 or c4))
end
function spiral (b,l)
  local w, h = love . graphics . getDimensions ()
  love.graphics.setColor(0,0,0)
  local giro = 2* math .pi
  for i=0, 50 do
    local x0 = w/2
    local y0 = h/2
    local nW=0
    for theta = 0, 64* giro , 0.1 do    -- numblamps
      local r = b * theta
      local x = w/2 + r * math .cos( theta )
      local y = h/2 + r * math .sin( theta ) * h / w
      --love . graphics . line (x0 ,y0 ,x,y)
      nW,l=drawWord(l,i,x,y)
      if nW then break end
      x0 , y0 = x, y
      if theta == 63* giro then print("Draw Fail") end
    end
  end
end
function love.load()
  love.window.setMode(900, 700, {resizable=true})
  arial = love.graphics.newFont(80)
  list=mUsedWords("martinlutherking.txt",arial,"blues")  --pode escolher um "esquema de cor"
  love.graphics.setBackgroundColor(1,1,1)
end
function love.draw()
  spiral(5,list)
end
