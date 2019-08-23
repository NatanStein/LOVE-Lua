function love.load () 
  love.window.setMode(1200 ,800) 
  love.graphics.setBackgroundColor(1.0 ,1.0 ,1.0) 
  fonte=love.graphics.newFont(50)
end
function ponteiro_hora (r)
   love.graphics.setLineWidth(5)
  love.graphics.setColor(0,0,0)
  love.graphics.line(0,0,0,-((r/2)+r/10))
end
function ponteiro_min (r)
   love.graphics.setLineWidth(5)
  love.graphics.setColor(0,0,0)
  love.graphics.line(0,0,0,-((r-r/9)))
end
function ponteiro_seg (r)
   love.graphics.setLineWidth(5)
  love.graphics.setColor(0,0,0)
  love.graphics.line(0,0,0,-(r-r/10))
end
function relogio (r)
  love.graphics.setColor(0,0,0)
   love.graphics.setLineWidth(7)
  love.graphics.circle("line",0,0,r)
   for i =1,60 do
    love.graphics.setLineWidth(5)
    love.graphics.setColor(1,0,0)
    love.graphics.line(0,r-7,0,r)
    love.graphics.rotate(math.rad(6))
    end
  for i = 1,9 do
    love.graphics.setLineWidth(10)
    love.graphics.setColor(0,0,0)
    love.graphics.line(0,r-10,0,r)
    love.graphics.rotate(math.rad(30))
    love.graphics.setFont(fonte)
    love.graphics.print(i,-18,r-400)
  end
  for i=10,12 do
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(10)
    love.graphics.line(0,r-10,0,r)
    love.graphics.rotate(math.rad(30))
    love.graphics.setFont(fonte)
    love.graphics.print(i,-29,r-400)
  end
 
  
end
function recirc (r,re,red,g,b,p)
  if re == 0 then
    return
  else
    l = 0
    love.graphics.setColor(0,0,0)
    love.graphics.circle("line",0,0,2*r/3)
    love.graphics.push()
    love.graphics.setColor(1,0+p,0)
    a=10
    love.graphics.rotate(love.timer.getTime()*1/re*(math.rad(a+100)))
    love.graphics.circle("fill",0+2*r/3,0,r/20+3)
    love.graphics.pop()
    l=l+10
    p=p+0.125
    recirc(r-16-l,re-1,red,g,b,p)
  end  
  end

function love.draw()
  data=os.date("*t")
  love.graphics.translate(600,400)
  recirc(200,8,0,0,0,0)
  relogio(200)
  love.graphics.push()
  love.graphics.rotate((data.hour+(data.min/60)+(data.sec/3600))*(math.rad(360/12)))
  ponteiro_hora(200)
  love.graphics.pop()
  love.graphics.push()
  love.graphics.rotate((data.min+(data.sec/60))*(math.rad(6)))
  ponteiro_min(200)
  love.graphics.pop()
  love.graphics.push()
  love.graphics.rotate(data.sec*(math.rad(6)))
  ponteiro_seg(200)
  love.graphics.pop()
end
