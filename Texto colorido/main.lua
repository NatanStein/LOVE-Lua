function textoColorido (texto)
  local tDT = {}
  local Cores_disp = { 
    red = {1.0, 0.0, 0.0},
    green = {0.0, 1.0, 0.0}, 
    blue = {0.0, 0.0, 1.0}, 
    yellow = {1.0, 1.0, 0.0}, 
    magenta = {1.0, 0.0, 1.0}, 
    cyan = {0.0, 1.0, 1.0},
    gray= {0.5, 0.5, 0.5},
    white= {1.0, 1.0, 1.0},
  }
 texto=string.gsub(texto,"([^<]*)<(.-):(.-)>",function(tp,cor,tc)
 tDT[#tDT+1]={0.0,0.0,0.0}
 tDT[#tDT+1]=tp 
 tDT[#tDT+1]=Cores_disp[cor]
 tDT[#tDT+1]=tc
 return ""
end
)
tDT[#tDT+1]={0.0,0.0,0.0}
tDT[#tDT+1]=texto
  return tDT;
end

function love.load()
  love.window.setMode(1000,600)
  love.graphics.setBackgroundColor(1,1,1)
  font=love.graphics.newFont(10)
end

function love.draw()
  local t = "Texto todo em preto. Texto em preto, <blue:depois em azul> Texto em preto, <green: verde>, <yellow:amarelo> e depois novamente preto <red:Texto em cinza> e depois em preto <red:Texto em vermelho, ><blue:seguido de azul.>"
  love.graphics.setFont(font)
  love.graphics.print(textoColorido(t),70,200)
end