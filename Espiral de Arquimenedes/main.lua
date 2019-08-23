function ContaPalavras ()
    local arq = io.open("martinlutherking.txt","r")
    local titulo = arq:read()
    local autor = arq:read()
    local texto = arq:read("*a")
    arq:close()
    local palavras={}
    local rest={entre=true,sobre=true,dessa=true,vocês=true,Tenho=true,de=true,da=true,dos=true,["do"]=true,as=true,os=true,a=true,o=true,que=true,ao=true,das=true,é=true,em=true,este=true,esta=true,e=true,um=true,mais=true,mas=true,com=true,Que=true,para=true,à=true,no=true,numa=true,sua=true,se=true,não=true,Com=true,pela=true,será=true,Não=true,como=true,até=true,estar=true,cada=true,uma=true,há=true,onde=true,isso=true,de=true,Esta=true,
  }
      textos=string.gsub(texto,"([^%s%p]+)",
        function(ch)
          if  not rest[ch]  and #ch > 4 then
            ch=string.lower(ch)
            if not palavras[ch] then
              palavras[ch]=1
            else
              palavras[ch]=palavras[ch]+1
            end
          end
        return ""
        end
        )
     v= {}
    for k,ve in pairs (palavras) do
      v[#v+1] = {p = k,n = ve }
    end
 table.sort (v,function (a,b)
    if a.n > b.n  then
      return true
    elseif a.n < b.n then
      return false
    else
      return a.p < b.p
    end
  end
)
    local cd = {}
    cd[1] = {1.0, 0.0, 0.0}
    cd[2] = {0.0, 1.0, 0.0} 
    cd[3] = {0.0, 0.0, 1.0} 
    cd[4] = {0,0,0} 
    cd[5] = {1.0, 0.0, 1.0} 
    cd[6] = {0,0, 0.5}
    cd[7]= {0.5, 0.5, 0.5}
    cd[8]= {0,0,0}
 objtexto={}
 for i=1,50 do
   local font = love.graphics.newFont(70-i+1)
   local txt = love.graphics.newText(font,v[i].p)
   local x,y=txt:getDimensions()
   objtexto[i]={dimx=x,
     dimy=y,
     texto=txt,
     cor=cd[math.random(1,8)],
   }
 end
end


function col(x1,y1,lx1,ly1,x2,y2,lx2,ly2)
  c1=(y1+ly1/2<=y2-ly2/2+7)
  c2=(y2+ly2/2<=y1-ly1/2+7)
  c3=(x1+lx1/2<=x2-lx2/2+7)
  c4=(x2+lx2/2<=x1-lx1/2+7)
  return not((c1 or c2) or (c3 or c4))
end


function desenhaobj (l,num,x,y)
  local lx,ly=objtexto[num+1].dimx,objtexto[num+1].dimy
  for i=1,num do
      if col(l[i].x,l[i].y,l[i].dimx,l[i].dimy,x,y,lx,ly) then 
        return false,l 
      end
  end
  l[num+1].x,l[num+1].y,l[num+1].dimx,l[num+1].dimy=x,y,lx,ly
  love.graphics.setColor(objtexto[num+1].cor)
  love.graphics.draw(l[num+1].texto,x-lx/2,y-ly/2,0)
  return true,l
end


function espiral (b,l)
  local w,h = love.graphics.getDimensions()
  local x0 = w/2
  local y0 = h/2
  local giro = 2*math.pi
  for i=0,49 do
    local x0 = w/2
    local y0 = h/2
    local n=0
    for theta = 0, 32* giro , 0.1 do 
      local r = b * theta
      local x = w/2 + r * math .cos( theta )
      local y = h/2 + r * math .sin( theta ) * h / w
      n,l=desenhaobj(l,i,x,y)
      if n then 
        break 
      end
      love.graphics.setColor(0,0,0)
     -- love.graphics.line(x0,y0,x,y)
      x0,y0 = x, y
    end
  end
 end

function love.load()
  math.randomseed(os.time())
  love.window.setMode(1300,700)
  love.graphics.setBackgroundColor(1,1,1)
  ContaPalavras()
end
function love.draw()
  espiral(5.8,objtexto)
end