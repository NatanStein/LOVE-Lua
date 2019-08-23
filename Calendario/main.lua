function love.load()
  love.graphics.setBackgroundColor(0,0,0)
end
function diaini (mes,ano)
  local t = os.time ({day=1 ,month = mes , year = ano})
  local data=os.date("*t",t)
  return data.wday
end
function bissexto(ano)
  if ano % 400 == 0 then
    return true
  elseif ano % 100 == 0 then
    return false
  elseif ano % 4 == 0 then
    return true
  else
    return false
  end
end
function ndiasmes(mes,ano)
  if mes == 2 then
    if bissexto(ano) then
      return 29
    else
      return 28
    end
  elseif mes == 1 or mes == 3 or mes == 5 or mes == 7 or
    mes == 8 or mes == 10 or mes == 12 then
    return 31
  else
    return 30
  end
end
function calendarioAD (mes,ano)
  local x =370
  local y =325
  love.graphics.print("4 2019",387.5,270)
  love.graphics.print("D\t\tS\t\tT\t\tQ\t\tQ\t\tS\t\tS\n",370,y-25)
    local ini = diaini(mes,ano)
  for i = 1 , ini-1 do
    x=x+10
  end
  for dia = 1,ndiasmes(mes,ano) do
    love.graphics.print(dia,x+30,y)
    if (dia + ini-1) % 7 == 0 then
    x=340
    y=y+30
    else
    x=x+40
    end
  end
end

function love.draw()
love.graphics.setColor(1,1,1)
love.graphics.rectangle("fill",350,250,300,250)
love.graphics.setColor(1,0,0)
calendarioAD(4,2019)
end
  