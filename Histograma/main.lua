function le_arq(v,nomearq)
  local arq = io.open(nomearq,"r")
if not arq then 
  print ("Nao foi possivel abrir arquivo : ",nomearq) 
  return nil end
local v = {}
t=arq:read("*a")
t:gsub("(%d%d):(%d%d):(%d%d),",function(h,min,seg)
  tj=h*3600+min*60+seg
 v[#v +1] = tj
 return ""
end
)
return v
end
function cria_histograma (t, v0 , v1 , n) 
  local histo = {v0 = v0 , v1 = v1} 
  for k = 1, n do 
    histo[k] = 0 
  end 
  local d = (v1 -v0 )/n 
    for i = 1, #t do 
      local k = math.floor((t[i]-v0)/d)+1 
      if histo [k] then 
        histo [k] = histo[k]+1 
      end 
    end 
    histo.fmax = histo [1]
    for i = 2, # histo do 
      if histo [i] > histo . fmax then 
        histo.fmax = histo [i] 
      end 
    end 
    return histo 
  end
  function desenha_histograma (histo , x0 , y0 , w, h, fmt,a) 
    local base = w/#histo 
    local x = x0 
    for i = 1, # histo do 
      local alt = h * histo [i]/ histo . fmax 
      love.graphics.setColor (0.875,-0.05+50*(1/alt),0) 
      love.graphics.rectangle("fill",x,y0+h-alt ,base ,alt) 
      love.graphics.setColor(1,1,1) 
      love.graphics.rectangle("line",x,y0+h-alt ,base ,alt)
      x = x + base 
    end
    local dx = ( histo.v1-histo.v0)/#histo 
    local text = love.graphics.newText(font) 
    for i = 0,#histo do 
      local s = string.format(fmt,(histo.v0+i*dx/60)-a) 
      text:set(s) 
      local tx,ty = text:getDimensions() 
      love.graphics.setColor(1,1,1) 
      love.graphics.draw (text ,x0+i*base ,y0+h+5, -math .pi /2,1,1,tx ,ty /2) 
    end 
  end
  function love.load () 
    t1=le_arq(t1,"1half.csv")
    t2=le_arq(t2,"2half.csv")
    H1 = cria_histograma (t1,15*3600+47*60,15*3600+47*60+50*60,50) 
    H2 =cria_histograma(t2,16*3600+51*60,16*3600+51*60+50*60,50)
    love.window.setMode (1200,700) 
    love.graphics.setBackgroundColor (0,0,0) 
    font=love.graphics.setNewFont(8)
    font2=love.graphics.setNewFont(28)
    font3=love.graphics.setNewFont(54)
    RM = love.graphics.newImage("RM.png")
    JV = love.graphics.newImage("JV.png")
    end
function love.draw() 
  local w,h = love.graphics.getDimensions() 
  desenha_histograma (H1,40 ,150,w/2-80 ,h/2-100,"%d",56820)
  desenha_histograma (H2,645,150,w/2-80,h/2-100,"%d",60660)
  love.graphics.setFont(font2)
  love.graphics.setColor(1,1,1) 
  love.graphics.print("Final da Champions League 2017",15,80)
  love.graphics.print("1º tempo",200,430)
  love.graphics.print("2º tempo",830,430)
  love.graphics.setColor(1,1,1) 
  xo,yo=RM:getDimensions()
  x0,y0=JV:getDimensions()
  love.graphics.draw(RM,500,525,0,0.3,0.3,xo/2,yo/2)
  love.graphics.draw(JV,705,530,0,0.4,0.4,x0/2,y0/2)
  love.graphics.setFont(font3)
  love.graphics.setColor(1,1,1) 
  love.graphics.print("4-1",640,580,0,1,1,80,80)
  love.graphics.push()
  --love.graphics.line(33,140,33,400)
  love.graphics.pop()
end