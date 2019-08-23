function love.load () 
  love.window.setMode(1200,1200)
  love.graphics.setBackgroundColor(1.0 ,1.0 ,1.0) 
  fonte=love.graphics.newFont(50)
  fonte2=love.graphics.newFont(250)
end
function ponteiro_hora (r)
   love.graphics.setLineWidth(7)
  love.graphics.setColor(1,0,0)
  love.graphics.line(0,0,0,-((r/2)+r/10))
end
function ponteiro_min (r)
   love.graphics.setLineWidth(6)
  love.graphics.setColor(1,0,0)
  love.graphics.line(0,0,0,-((r-r/8)))
end
function ponteiro_seg (r)
   love.graphics.setLineWidth(5)
  love.graphics.setColor(1,0,0)
  love.graphics.line(0,0,0,-(r-r/10))
end
function relogio (r)
  love.graphics.setColor(1,1,1)
  love.graphics.circle("fill",0,0,r)
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
    love.graphics.print(i,-18,r-300)
  end
  for i=10,12 do
    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(10)
    love.graphics.line(0,r-10,0,r)
    love.graphics.rotate(math.rad(30))
    love.graphics.setFont(fonte)
    love.graphics.print(i,-29,r-300)
  end
end
function recirc (r,re)
  love.graphics.setLineWidth(5)
  if re == 0 then
    return
  else
    local l = 0
    love.graphics.setColor(1,1,1)
    love.graphics.circle("line",0,0,2*r/3)
    love.graphics.setColor(0,0,0.5)
    love.graphics.circle("fill",0,0,2*r/3)
    l=l+10
    recirc(r-16-l,re-1)
  end  
  end
function circdata(r)
  love.graphics.setColor(0,0,0.5)
  love.graphics.circle("fill",376,0,r)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(fonte)
  love.graphics.printf(data.day.."/"..data.month,376,0,200,"left",-(love.timer.getTime()*(math.rad(20))),1,1,56,28)
  end
function love.draw()
  data=os.date("*t")
  love.graphics.push()
  love.graphics.translate(600,600)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.circle("line",0,0,376)
  love.graphics.setColor(0,0,0.5)
  love.graphics.circle("fill",0,0,55)
  love.graphics.circle("fill",0,0,300)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(fonte2)
  love.graphics.print("Lua",-230,-40)
  love.graphics.rotate(love.timer.getTime()*(math.rad(20)))
  circdata(75)
  love.graphics.pop()
  love.graphics.translate(670,485)
  relogio(150)
  recirc(150,8)
  love.graphics.push()
  love.graphics.rotate((data.hour+(data.min/60)+(data.sec/3600))*(math.rad(360/12)))
  ponteiro_hora(150)
  love.graphics.pop()
  love.graphics.push()
  love.graphics.rotate((data.min+(data.sec/60))*(math.rad(6)))
  ponteiro_min(150)
  love.graphics.pop()
  love.graphics.push()
  love.graphics.rotate(data.sec*(math.rad(6)))
  ponteiro_seg(150)
  love.graphics.pop()
end
