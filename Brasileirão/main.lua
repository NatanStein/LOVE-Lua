function cria_tabela ()
  arq=io.open("brasileirao-2017.txt")
  for line in arq:lines() do
    string.gsub(line,"^([%a%s]-)%s+(%d) %- (%d)%s+([%a%s]+)",function (nom1,gol1,gol2,nom2)
      if gol1 > gol2 then
        v1=1
        v2=0
        e=0
        d1=0
        d2=1
      elseif gol1 == gol2 then
        e=1
        d1=0
        v1=0
        v2=0
        d2=0
      else
        v1=0
        e=0
        d1=1
        v2=1
        d2=0
      end
      if not t[nom1] then
         t[nom1]={
           p=3*v1+e,
           v=v1,
           e=e,
           d=d1,
           gp=gol1,
           gc=gol2,
           sg=gol1-gol2
           }
      else
        t[nom1]={
          p=t[nom1].p+3*v1+e,
          v=t[nom1].v+v1,
          e=t[nom1].e+e,
          d=t[nom1].d+d1,
          gp=t[nom1].gp+gol1,
          gc=t[nom1].gc+gol2,
          sg=t[nom1].sg+gol1-gol2
        }
      end
      if not t[nom2] then
         t[nom2]={
           p=3*v2+e,
           v=v2,
           e=e,
           d=d2,
           gp=gol2,
           gc=gol1,
           sg=gol2-gol1
           }
      else
        t[nom2]={
          p=t[nom2].p+3*v2+e,
          v=t[nom2].v+v2,
          e=t[nom2].e+e,
          d=t[nom2].d+d2,
          gp=t[nom2].gp+gol2,
          gc=t[nom2].gc+gol1,
          sg=t[nom2].sg+gol2-gol1
          }
      end
     end
    )
  end
  tsort={}
  for k,v in pairs (t) do
    tsort[#tsort+1]={nome=k,p=v.p,v=v.v,e=v.e,d=v.d,gp=v.gp,gc=v.gc,sg=v.sg} 
  end
  table.sort(tsort,function(a,b)
    if a.p > b.p then
      return true
    elseif a.p==b.p then
      if a.v > b.v then
        return true
      elseif a.v == b.v then
        if a.sg > b.sg then
          return true 
        else 
          return false
        end
      else 
        return false
      end
    else 
      return false
    end
    end)
  return tsort
end
function love.load()
  t={}
  t=cria_tabela()
  love.graphics.setBackgroundColor(1,1,1)
  love.window.setMode(700,700)
  font1=love.graphics.newFont(26)
  font2=love.graphics.newFont(13)
  font3=love.graphics.newFont(17)
end
function love.draw()
  love.graphics.setColor(0,0,0)
  for i=0,20 do
    if i == 0 then
      love.graphics.setFont(font1)
      love.graphics.print(" Clube     P    V    E    D   GP   GC   SG",80,20)
      love.graphics.line(30,50,565,50)
      love.graphics.line(30,19,565,19)
      love.graphics.line(30,19,30,650)
      love.graphics.line(70,19,70,650)
      love.graphics.line(565,19,565,650)
      love.graphics.line(190,19,190,650)
      love.graphics.line(237,19,237,650)
      love.graphics.line(284,19,284,650)
      love.graphics.line(330,19,330,650)
      love.graphics.line(380,19,380,650)
      love.graphics.line(440,19,440,650)
      love.graphics.line(500,19,500,650)
      love.graphics.line(30,650,565,650)
    else
      love.graphics.setFont(font2)
      love.graphics.print(t[i].nome,82,28+i*30)
      love.graphics.setFont(font3)
      love.graphics.print(t[i].p,200,26+i*30)
      love.graphics.print(t[i].v,250,26+i*30)
      love.graphics.print(t[i].e,300,26+i*30)
      love.graphics.print(t[i].d,347,26+i*30)
      love.graphics.print(t[i].gp,400,26+i*30)
      love.graphics.print(t[i].gc,460,26+i*30)
      love.graphics.print(t[i].sg,520,26+i*30)
      love.graphics.print(i,40,26+i*30)
      love.graphics.line(30,50+i*30,565,50+i*30)
    end
  end
end


