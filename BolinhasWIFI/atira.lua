local msgr = require "mqttNodeMCULibrary"
local host = "localhost"
local id = "MeuNODE"
local red=3
local verde = 6
local sw1 = 1
local sw2 = 2
local lasttime=0
msgr.start(host,id,"12345love", function() end)
gpio.mode(verde,gpio.OUTPUT)
gpio.mode(red,gpio.OUTPUT)
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
gpio.write(red,gpio.LOW)
gpio.write(verde,gpio.LOW)
mytimer=tmr:create()
function start ()
  if gpio.read(sw1) == 1 then
  msgr.sendMessage("para:dir:","12345love")
else
  msgr.sendMessage("move:dir:","12345love")

end
if gpio.read(sw2) == 1 then
  msgr.sendMessage("para:esq:","12345love")

else
  msgr.sendMessage("move:esq:","12345love")
end
end
mytimer:alarm(200,tmr.ALARM_AUTO,start)


  
